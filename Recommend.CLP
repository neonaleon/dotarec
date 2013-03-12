(deftemplate recommend
	(slot item (type SYMBOL))
	(slot weight (type INTEGER) (default 0))
	(slot save (type SYMBOL) (default NIL)))

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
	(highWeight 0)
	(player (gold 2000)))


(defrule dummy1
	?rec <- (recommend (item boots) (weight ?w) (save NIL))
	(player (gold ?g))
	=>
	(bind ?r (random 1 6))
	(if (>= ?g 500)
	then
		(modify ?rec (weight (+ ?w ?r)) (save NO))
	else
		(modify ?rec (weight (+ ?w ?r)) (save YES))))

(defrule dummy2
	?rec <- (recommend (item BKB) (weight ?w) (save NIL))
	(player (gold ?g))
	=>
	(bind ?r (random 1 6))
	(if (>= ?g 2000)
	then
		(modify ?rec (weight (+ ?w ?r)) (save NO))
	else
		(modify ?rec (weight (+ ?w ?r)) (save YES))))

(defrule dummy3
	?rec <- (recommend (item guinsoo) (weight ?w) (save NIL))
	(player (gold ?g))
	=>
	(bind ?r (random 1 6))
	(if (>= ?g 5000)
	then
		(modify ?rec (weight (+ ?w ?r)) (save NO))
	else
		(modify ?rec (weight (+ ?w ?r)) (save YES))))

(defrule findHighestWeight
	?h <- (highWeight ?w1)
	(recommend (weight ?w2&:(> ?w2 ?w1)))
	=>  
	(retract ?h)
	(assert (highWeight ?w2)))
	
(defrule decision
	(declare (salience -1))
	(highWeight ?w1)
	(recommend (item ?i) (weight ?w2&:(= ?w2 ?w1)) (save ?s))
	(not (decided))
	=>
	(switch ?s
		(case NO then (printout t "Buy " ?i " next." crlf))
		(case YES then (printout t "Save for " ?i " next." crlf))
		(case NIL then (printout t "ERROR!!" crlf)))
	; ; Prevent repeat execution in case of tie
	(assert (decided))) 
	
(defrule resetRec
	(declare (salience 100))
	(resetRec)
	?rec <- (recommend (save ~NIL))
	=>
	(modify ?rec (weight 0) (save NIL)))

(defrule resetControl
	(declare (salience 99))
	?r <- (resetRec)
	?d <- (decided)
	?h <- (highWeight ?w)
	=>
	(retract ?r)
	(retract ?d)
	(retract ?h)
	(assert (highWeight 0)))