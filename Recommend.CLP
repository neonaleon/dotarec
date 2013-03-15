(deftemplate recommend
	(slot item (type SYMBOL))
	(slot weight (type INTEGER) (default 0)))

(deftemplate player
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type SYMBOL))
)

(deffacts the-facts
	(recommend (item boots))
	(recommend (item BKB))
	(recommend (item guinsoo))
	(player (gold 2000)))


(defrule dummy1
	?rec <- (recommend (item boots) (weight ?w))
	(not (fired 1))
	=>
	(bind ?r (random 1 6))
	(modify ?rec (weight (+ ?w ?r)))
	(assert (fired 1)))

(defrule dummy2
	?rec <- (recommend (item BKB) (weight ?w))
	(not (fired 2))
	=>
	(bind ?r (random 1 6))
	(modify ?rec (weight (+ ?w ?r)))
	(assert (fired 2)))

(defrule dummy3
	?rec <- (recommend (item guinsoo) (weight ?w))
	(not (fired 3))
	=>
	(bind ?r (random 1 6))
	(modify ?rec (weight (+ ?w ?r)))
	(assert (fired 3)))
	
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