; ; Item Rules

; ; Item Combination rule
(defrule item-combination
	(declare (salience 10))
	?p <- (player (inventory $?i1))
	(item (name ?n) (recipe $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	(modify ?p (inventory (insert$ (remove-subset $?i2 $?i1) 1 ?n)))
)

; ; Phase Changing Rule
(defrule phase-change
	?cp <- (current-phase ?p)
	(player (inventory $?i1))
	(phase (number ?p) (items $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	(retract ?cp)
	(assert (current-phase (+ ?p 1)))
)