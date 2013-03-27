; ; Recommendation Rules

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

(defrule retract-recommend
	(current-phase ?phase&: (> ?phase 8))
	?recommend <- (recommend)
	=>
	(retract ?recommend)
)

(defrule no-recommendation
	?question <- (question (stage decide))
	(not (recommend))
	=>
	(printout t "No more items to recommend." crlf)
	(modify ?question (stage main-question))
)

(defrule recommend-town-portal
	?recommend <- (recommend (item "Town Portal Scroll"))
	(player (inventory $?i))
	(or (test (subsetp (create$ "Boots of Speed") $?i))
		(test (subsetp (create$ "Power Treads") $?i)))
	;; (not (test (subsetp (create$ "Boots of Travel") $?i)))	
	(not (test (subsetp (create$ "Town Portal Scroll") $?i)))
	=>
	(modify ?recommend (weight 1000))
)

(defrule decision
	(declare (salience -1))
	(recommend (item ?i) (weight ?w1))
	(not (recommend (weight ?w2&:(> ?w2 ?w1))))
	=>
	(assert (goal ?i))
	(printout t "*** You should aim to get " ?i " now." crlf)
	)
	
(defrule nextItemBOT
	(declare (salience 100))
	?question <- (question (stage decide))
	?g <- (goal "Boots of Travel")
	?p <- (player (gold ?playerG) (inventory $?inv))
	(test (subsetp (create$ "Power Treads") $?inv))
	=>
	(if (<= 1750 ?playerG)
	then
		(printout t "*** Sell Power Threads and buy Boots of Travel next." crlf)
		(modify ?p (gold (- ?playerG 1750)) (inventory (insert$ $?inv 1 "Boots of Travel")))
	else
		(printout t "*** Save for Boots of Travel next." crlf))
	(modify ?question (stage main-question)))

(defrule nextItem
	?question <- (question (stage decide))
	?g <- (goal ?i)
	(item (name ?i) (gold ?itemG) (recipe $?r))
	?p <- (player (gold ?playerG) (inventory $?inv))
	=>
	(if (eq (str-compare (nth$ 1 $?r) "None") 0) 
	then
		(if (<= ?itemG ?playerG)
		then
			(printout t "*** Buy " ?i " next." crlf)
			(modify ?p (gold (- ?playerG ?itemG)) (inventory (insert$ $?inv 1 ?i)))
			(retract ?g)
		else
			(printout t "*** Save for " ?i " next." crlf))
		(modify ?question (stage main-question))

	else
		(bind ?found 0)
		(bind ?temp (create$))
		(loop-for-count (?a 1 (length$ $?r))
			(bind ?temp ?temp (nth$ ?a $?r))
			(if (not (subsetdp ?temp $?inv))
			then
				(bind ?found 1)
				(assert (goal (nth$ ?a $?r)))	
				(break)
			)
		)
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


(defrule resetGoal
	(declare (salience 100))
	(resetRec)
	?g <- (goal ?i)
	=>
	(retract ?g))

(defrule resetControl
	(declare (salience 99))
	?r <- (resetRec)
	=>
	(retract ?r))