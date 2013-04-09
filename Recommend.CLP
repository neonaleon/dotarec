; ; Recommendation Rules

(defrule retract-recommend
	(declare (salience 110))
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
		(bind $?inv (insert$ $?inv 1 "Boots of Travel"))
		(bind $?inv (delete$ $?inv (member$ "Power Treads" $?inv) (member$ "Power Treads" $?inv)))
		(modify ?p (gold (- ?playerG 1750)) (inventory $?inv)) ; ; No idea what the sale price of Power Treads is.
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