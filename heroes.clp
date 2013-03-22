; ; Hero Rules

(defrule retract-heroes
	(team (count 5))
	?h <- (hero)
	=>
	(retract ?h)
)