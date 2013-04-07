; ; Hero Rules

; ; Check if hero specified by player exists.
(defrule check-hero-exists
	?check <- (checkHero ?name)
	(hero (heroName ?name) (heroType ?type))
	?opTeam <- (team (count ?count) (num_disabler ?num_d) (num_physical ?num_p) (num_spell ?num_s) (num_useless ?num_u))
	=>
	(bind ?count (+ ?count 1))
	(switch ?type
		(case disabler then (bind ?num_d (+ ?num_d 1)))
		(case physical then (bind ?num_p (+ ?num_p 1)))
		(case spell then (bind ?num_s (+ ?num_s 1)))
		(case useless then (bind ?num_u (+ ?num_u 1)))
	)
	(modify ?opTeam (count ?count) (num_disabler ?num_d) (num_physical ?num_p) (num_spell ?num_s) (num_useless ?num_u))
	;;(printout t ?name " added to enemy team fact." crlf)
	(retract ?check)
)

; ; If hero specified does not exist.
(defrule check-hero-not-exists
	?check <- (checkHero ?name)
	(not (hero (heroName ?name)))
	=>
	(printout t ?name " is not a valid hero name! Please try again." crlf)
	(retract ?check)
)

(defrule retract-heroes
	(team (count 5))
	?h <- (hero)
	=>
	(retract ?h)
)