;; Recommendation rules

; how well the player is doing in the game is determined by his gpm or farming rate
; salience 1 is given so that ownage level is fired before recommendation
(defrule low-ownage
	(declare (salience 1))
	?o <- (ownage-level (level ~low))
	(question (stage decide))
	(player (gpm ?gpm))
	(test (<= ?gpm 200))
	=>
	(modify ?o (level low))
	)

(defrule normal-ownage
	(declare (salience 1))
	?o <- (ownage-level (level ~normal))
	(player (gpm ?gpm))
	(test (> ?gpm 200))
	(test (<= ?gpm 400))
	=>
	(modify ?o (level normal))
	)

(defrule high-ownage
	(declare (salience 1))
	?o <- (ownage-level (level ~high))
	(player (gpm ?gpm))
	(test (> ?gpm 400))
	=>
	(modify ?o (level high))
	)

;; Rule 1 
;; if team has chick -> 2 tango, 1 flask, 3 branch
;; else -> chick, 1 tango, 1 flask, 2 branch
;; note: how to recommend list of items?
; (defrule recommend-rule-1
; 	;;?recommend <- (recommend (item "Manta Style") (weight ?weight))
; 	(current-phase 1)
; 	(player (inventory $?inv))
; 	=>
; 	(if (member$ "Animal Courier" $?inv)
; 		then (printout t "Do actual recommendation here.." crlf)
; 		else (printout t "Recommend other stuff.." crlf))
; 	(assert (fired recommend-rule-1))
; 	)

;; Rule 2
;; if getting owned -> magic wand
;; else if neutral -> bottle
;; else if owning -> ring of health -> perseverance
;; note: have to decide how to determine owning or not
(defrule recommend-rule-2
	(current-phase 2)
	?r1 <- (recommend (item "Magic Wand")(weight ?w1))
	?r2 <- (recommend (item "Bottle")(weight ?w2))
	?r3 <- (recommend (item "Perseverance")(weight ?w3))
	(not (fired recommend-rule-2))
	=>
	(modify ?r1 (weight (+ ?w1 1)))
	(modify ?r2 (weight (+ ?w2 1)))
	(modify ?r3 (weight (+ ?w3 1)))
	(assert (fired recommend-rule-2))
	)

(defrule recommend-rule-2-low
	(current-phase 2)
	(ownage-level (level low))
	?recommend <- (recommend (item "Magic Wand") (weight ?weight))
	(not (fired recommend-rule-2-low))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-2-low))
	)

(defrule recommend-rule-2-normal
	(current-phase 2)
	(ownage-level (level normal))
	?recommend <- (recommend (item "Bottle") (weight ?weight))
	(not (fired recommend-rule-2-normal))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-2-normal))
	)

(defrule recommend-rule-2-high
	(current-phase 2)
	(ownage-level (level high))
	?recommend <- (recommend (item "Perseverance") (weight ?weight))
	(not (fired recommend-rule-2-high))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-2-high))
	)

;; Rule 3
;; boots
;; note: not sure
(defrule recommend-rule-3
	(current-phase 3)
	?recommend <- (recommend (item "Boots of Speed") (weight ?weight))
	(not (fired recommend-rule-3))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-3))
	)

;; Rule 4
;; if getting owned -> power treads
;; else if owning -> ultimate orb
(defrule recommend-rule-4
	(current-phase 4)
	(not (fired recommend-rule-4))
	?r1 <- (recommend (item "Power Treads")(weight ?w1))
	?r1 <- (recommend (item "Ultimate Orb")(weight ?w2))
	=>
	(modify ?r1 (weight (+ ?w1 1)))
	(modify ?r2 (weight (+ ?w2 1)))
	(assert (fired recommend-rule-4))
	)

(defrule recommend-rule-4-treads
	(current-phase 4)
	(ownage-level (level low))
	(not (fired recommend-rule-4-treads))
	?recommend <- (recommend (item "Power Treads")(weight ?weight))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-4-treads))
	)

(defrule recommend-rule-4-ultorb
	(current-phase 4)
	(ownage-level (level high))
	(not (fired recommend-rule-4-ultorb))
	?recommend <- (recommend (item "Ultimate Orb")(weight ?weight))
	=>
	(modify ?recommend (weight (+ ?weight 1)))
	(assert (fired recommend-rule-4-ultorb))
	)

;; if disablers -> BKB
;; else if physical -> ghost scepter
;; note: give more weight to bkb if more disablers, more weight to ghost scepter if more physical dps
(defrule recommend-rule-4-bkb-gs
	(current-phase 4)
	(ownage-level (level normal))
	?r1 <- (recommend (item "Black King Bar") (weight ?w1))
	?r2 <- (recommend (item "Ghost Scepter") (weight ?w2))
	(team (count ?c) (num_disabler ?d) (num_physical ?p) (num_spell ?s) (num_useless ?u))
	(not (fired recommend-rule-4-bkb-gs))
	=>
	(modify ?r1 (weight (+ ?w1 ?d)))
	(modify ?r2 (weight (+ ?w2 ?p)))
	(assert (fired recommend-rule-4-bkb-gs))
	)