(deftemplate recommend
	(slot item (type STRING))
	(slot weight (type INTEGER) (default 0)))

(deftemplate player
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type STRING)))

(deftemplate team
	(slot count (type INTEGER))
	(slot num_disabler (type INTEGER))
	(slot num_physical (type INTEGER))
	(slot num_spell (type INTEGER))
	(slot num_useless (type INTEGER)))

(deftemplate item
	(slot name (type STRING))
	(slot gold (type INTEGER))
	(multislot recipe (type STRING) (default "None"))
)

(deffacts items
	(item (name "Animal Courier") (gold 150))
	(item (name "Band of Elvenskin") (gold 450))
	(item (name "Belt of Strength") (gold 450))
	(item (name "Blade of Alacrity") (gold 1000))
	(item (name "Boots of Speed") (gold 450))
	(item (name "Bottle") (gold 600))
	(item (name "Demon Edge") (gold 2400))
	(item (name "Ghost Scepter") (gold 1600))
	(item (name "Gloves of Haste") (gold 500))
	(item (name "Healing Salve") (gold 100))
	(item (name "Iron Branch") (gold 53))
	(item (name "Javelin") (gold 1500))
	(item (name "Magic Stick") (gold 200))
	(item (name "Mithril Hammer") (gold 1600))
	(item (name "Mystic Staff") (gold 2700))
	(item (name "Ogre Club") (gold 1000))
	(item (name "Platemail") (gold 1400))
	(item (name "Ring of Health") (gold 875))
	(item (name "Tango") (gold 90))
	(item (name "Town Portal Scroll") (gold 135))
	(item (name "Ultimate Orb") (gold 2100))
	(item (name "Void Stone") (gold 875))
	
	(item (name "Black King Bar Recipe") (gold 1300))
	(item (name "Boots of Travel Recipe") (gold 2000))
	(item (name "Flying Courier Recipe") (gold 220))
	(item (name "Magic Wand Recipe") (gold 150))
	(item (name "Manta Style Recipe") (gold 900))
	(item (name "Shiva's Guard Recipe") (gold 600))
	(item (name "Yasha Recipe") (gold 600))
	
	(item (name "Black King Bar") (recipe "Mithril Hammer" "Ogre Club" "Black King Bar Recipe"))
	(item (name "Boots of Travel") (recipe "Boots of Speed" "Boots of Travel Recipe"))
	(item (name "Flying Courier") (recipe "Animal Courier" "Flying Courier Recipe"))
	(item (name "Magic Wand") (recipe "Magic Stick" "Iron Branch" "Iron Branch" "Iron Branch" "Magic Wand Recipe"))
	(item (name "Manta Style") (recipe "Ultimate Orb" "Yasha" "Manta Style Recipe"))
	(item (name "Monkey King Bar") (recipe "Javelin" "Javelin" "Demon Edge"))
	(item (name "Perseverance") (recipe "Void Stone" "Ring of Health"))
	(item (name "Power Treads") (recipe "Boots of Speed" "Gloves of Haste" "Belt of Strength"))
	(item (name "Scythe of Vyse") (recipe "Mystic Staff" "Ultimate Orb" "Void Stone"))
	(item (name "Shiva's Guard") (recipe "Mystic Staff" "Platemail" "Shiva's Guard Recipe"))
	(item (name "Yasha") (recipe "Blade of Alacrity" "Band of Elvenskin" "Yasha Recipe"))
)

(deffacts recommend-facts
	(current-phase 7)
	; ;(recommend (item "Boots of Speed") (weight 100))
	(recommend (item "Scythe of Vyse"))
	(recommend (item "Monkey King Bar"))
	(recommend (item "Shiva's Guard"))
	(recommend (item "Manta Style"))
	(recommend (item "Boots of Travel"))
	(player (gold 500) (inventory "Magic Stick" "Mystic Staff" "Boots of Speed"))
	(team (num_physical 3)))

(defrule recommend-guinsoo
	?recommend <- (recommend (item "Scythe of Vyse") (weight ?weight))
	(not (fired recommend-guinsoo))
	(current-phase 5)
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-guinsoo))
)

(defrule recommend-mkb
	?recommend <- (recommend (item "Monkey King Bar") (weight ?weight))
	(not (fired recommend-mkb))
	(current-phase 6)
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-mkb))
)

(defrule recommend-shiva
	?recommend <- (recommend (item "Shiva's Guard") (weight ?weight))
	(not (fired recommend-shiva))
	(current-phase 7)
	(team (num_physical ?num_physical))
	=>
	; ; Each physical enemy adds 1 vote to Shiva's Guard.
	(modify ?recommend (weight (+ ?weight ?num_physical)))
	(assert (fired recommend-shiva))
)

(defrule recommend-manta
	?recommend <- (recommend (item "Manta Style") (weight ?weight))
	(not (fired recommend-manta))
	(current-phase 7)
	(player (gold ?gold))
	=>
	; ; Every 2000 gold the player has adds 1 vote to Manta Style.
	(modify ?recommend (weight (+ ?weight (integer (/ ?gold 2000)))))
	(assert (fired recommend-manta))
)

(defrule recommend-bot
	?recommend <- (recommend (item "Boots of Travel") (weight ?weight))
	(not (fired recommend-bot))
	(current-phase 8)
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-bot))
)

(deffunction get-item-cost (?item-name ?inventory)
	
)
	
(defrule decision
	(declare (salience -1))
	(recommend (item ?i) (weight ?w1))
	(not (recommend (weight ?w2&:(> ?w2 ?w1))))
	(not (decided))
	=>
	(assert (goal ?i))
	; ; Prevent repeat execution in case of tie
	(assert (decided))) 
	
(defrule nextItem
	?g <- (goal ?i)
	(item (name ?i) (gold ?itemG) (recipe $?r))
	?p <- (player (gold ?playerG) (inventory $?inv))
	=>
	(if (eq (str-compare (nth$ 1 $?r) "None") 0) 
	then
		(if (<= ?itemG ?playerG)
		then
			(printout t "Buy " ?i " next." crlf)
			(modify ?p (gold (- ?playerG ?itemG)) (inventory (insert$ $?inv 1 ?i)))
			(retract ?g)
		else
			(printout t "Save for " ?i " next." crlf))
	else
		(bind ?found 0)
		(loop-for-count (?a 1 (length$ $?r))
			(if (not (subsetp (create$ (nth$ ?a $?r)) $?inv))
			then 
				(bind ?found 1)
				(assert (goal (nth$ ?a $?r)))	
				(break)
			)
		)
		(if (= ?found 0) then (retract ?g))
	)
) 

(defrule resetRec
	(declare (salience 100))
	(resetRec)
	?rec <- (recommend (weight ~0))
	=>
	(modify ?rec (weight 0)))

(defrule resetFired
	(declare (salience 100))
	(resetRec)
	?f <- (fired ?n)
	=>
	(retract ?f))

(defrule resetControl
	(declare (salience 99))
	?r <- (resetRec)
	?d <- (decided)
	=>
	(retract ?r)
	(retract ?d))