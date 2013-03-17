(deftemplate recommend
	(slot item (type STRING))
	(slot weight (type INTEGER) (default 0)))

(deftemplate player
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type SYMBOL)))

(deftemplate team
	(slot count (type INTEGER))
	(slot num_disabler (type INTEGER))
	(slot num_physical (type INTEGER))
	(slot num_spell (type INTEGER))
	(slot num_useless (type INTEGER)))

(deffacts the-facts
	(current-phase 7)
	;;(recommend (item boots))
	;;(recommend (item BKB))
	;;(recommend (item guinsoo))
	(recommend (item "Scythe of Vyse"))
	(recommend (item "Monkey King Bar"))
	(recommend (item "Shiva's Guard"))
	(recommend (item "Manta Style"))
	(recommend (item "Boots of Travel"))
	(player (gold 5000))
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

;;(defrule dummy1
;;	?rec <- (recommend (item boots) (weight ?w))
;;	(not (fired 1))
;;	=>
;;	(bind ?r (random 1 6))
;;	(modify ?rec (weight (+ ?w ?r)))
;;	(assert (fired 1)))

;;(defrule dummy2
;;	?rec <- (recommend (item BKB) (weight ?w))
;;	(not (fired 2))
;;	=>
;;	(bind ?r (random 1 6))
;;	(modify ?rec (weight (+ ?w ?r)))
;;	(assert (fired 2)))

;;(defrule dummy3
;;	?rec <- (recommend (item guinsoo) (weight ?w))
;;	(not (fired 3))
;;	=>
;;	(bind ?r (random 1 6))
;;	(modify ?rec (weight (+ ?w ?r)))
;;	(assert (fired 3)))
	
(defrule decision
	(declare (salience -1))
	(recommend (item ?i) (weight ?w1))
	(not (recommend (weight ?w2&:(> ?w2 ?w1))))
	(not (decided))
	=>
	(printout t "Buy " ?i " next." crlf)
	; ; Prevent repeat execution in case of tie
	(assert (decided))) 
	
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