;; Recommendation rules
;; note: currently just placeholders

;; Rule 1 
;; if team has chick -> 2 tango, 1 flask, 3 branch
;; else -> chick, 1 tango, 1 flask, 2 branch
;; note: how to recommend list of items?
(defrule recommend-rule-1
	;;?recommend <- (recommend (item "Manta Style") (weight ?weight))
	(current-phase 1)
	(player (inventory $?inv))
	=>
	(if (member$ "Animal Courier" $?inv)
		then (printout t "Do actual recommendation here.." crlf)
		else (printout t "Recommend other stuff.." crlf))
	(assert (fired recommend-rule-1))
	)

;; Rule 2
;; if getting owned -> magic wand
;; else if neutral -> bottle
;; else if owning -> ring of health -> perseverance
;; note: have to decide how to determine owning or not
(defrule recommend-rule-2
	(current-phase 2)
	=>
	(assert (fired recommend-rule-2))
	)

;; Rule 3
;; boots
;; note: not sure
(defrule recommend-rule-3
	(current-phase 3)
	=>
	(assert (fired recommend-rule-3))
	)

;; Rule 4
;; if getting owned -> power treads
;; else if owning -> ultimate orb

;; if disablers -> BKB
;; else if physical -> ghost scepter
;; note: give more weight to bkb if more disablers, more weight to ghost scepter if more physical dps
(defrule recommend-rule-4
	(team (count ?c) (num_disabler ?d) (num_physical ?p) (num_spell ?s) (num_useless ?u))
	(current-phase 4)
	=>
	(assert (recommend ("Black King Bar") (weight (* 1 ?d))))
	(assert (recommend ("Ghost Scepter") (weight (* 1 ?p))))
	(assert (fired recommend-rule-4))
	)
