; ; Item Rules

; ; Item Combination rule
(defrule item-combination
	(declare (salience 10))
	?p <- (player (inventory $?i1))
	(item (name ?n) (recipe $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	(modify ?p (inventory (insert$ (remove-subset $?i2 $?i1) 1 ?n)))
	(printout t crlf "ITEMS COMBINED: " crlf)
	(loop-for-count (?x 1 (length$ $?i2))
					(printout t (nth$ ?x $?i2))
					(if (< ?x (length$ $?i2))
						then (printout t ", "))) 
	(printout t " were combined into " ?n crlf)
)

; ; Phase Changing Rule
(defrule phase-change
	(declare (salience 1)) ; phase change should happen before any recommendation
	?cp <- (current-phase ?p)
	(player (inventory $?i1))
	(phase (number ?p) (items $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	(retract ?cp)
	(assert (current-phase (+ ?p 1)))
)