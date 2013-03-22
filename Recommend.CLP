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
	(not (decided))
	=>
	(assert (goal ?i)))
	
(defrule nextItem
	(decided)
	?question <- (question (stage decide))
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
		(modify ?question (stage main-question))
		; ; Prevent repeat execution
		(assert (decided))
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