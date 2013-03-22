; ; User Interface Rules

; ; Ask player for his/her playing style.
(defrule ask-playstyle
	; ; TODO if there is a player without playstyle
	?player <- (player (playstyle NIL))
	=>
	(printout t "What is your playstyle?" crlf)
	(printout t "(1) Defensive" crlf)
	(printout t "(2) Neutral" crlf)
	(printout t "(3) Aggressive" crlf)
	(printout t "(other) Stop program" crlf)
	(bind ?ans (read))
	(switch ?ans
		; ; TODO modify player playstyle
		(case 1 then (modify ?player (playstyle defensive)))
		(case 2 then (modify ?player (playstyle neutral)))
		(case 3 then (modify ?player (playstyle aggressive)))
	)
)

; ; Find out what heroes are on the opposing team.
(defrule ask-opponents
	(not (checkHero ?))
	?opTeam <- (team (count ?count&: (< ?count 5)))
	=>
	(if
		(= ?count -1)
	then
		(printout t "What are the heroes on the opposing team?" crlf)
		(bind ?count 0)
		(modify ?opTeam (count ?count))
	)
	(printout t "Hero (#" (+ ?count 1) ") : ")
	(bind ?ans (lowcase (readline)))
	(assert (checkHero (str-cat ?ans)))
)

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

; ; Ask player for next action.
; ; NOTES problem with use/discard/sell being situational:
; ; 		- have to check if there are consumables in player's inventory
; ;			- in addition to checking if inventory is full
; ;			- player may have removed more than 1 item from inventory
; ;			- additional facts/templates may have to be added to keep track of this
; ;			- easier to just let player choose to inform system whenever item is removed
(defrule ask-next-action
	?question <- (question (stage main-question))
	(player (playstyle ~NIL))
	(team (count ?count&: (= ?count 5)))
	=>
	(printout t "What would you like to do next?" crlf)
	(printout t "(1) Get next suggestion" crlf)
	(printout t "(2) Use/discard/sell an item" crlf)
	(printout t "(3) End session" crlf)
	(printout t "(other) Stop program" crlf)
	(bind ?ans (read))
	(switch ?ans
		(case 1 then (modify ?question (stage gold-question)))
		(case 2 then (modify ?question (stage discard)))
		(case 3 then (modify ?question (stage end)))
	)
)

; ; Ask player for gold per minute and current gold.
(defrule ask-gold
	?question <- (question (stage gold-question))
	?player <- (player)
	=>
	(printout t "What is your current gold per minute? ")
	(bind ?ans-gpm (read))
	(printout t "How much gold do you currently have? ")
	(bind ?ans-gold (read))
	(modify ?player (gpm ?ans-gpm) (gold ?ans-gold))
	; ; TODO other rules that will modify question stage for situational questions
	; ; such as whether player is being killed
	(modify ?question (stage decide))
	(assert (resetRec))
)

; ; Ask player which item has been used/discarded/sold.
(defrule ask-items
	?question <- (question (stage discard))
	?player <- (player (inventory $?inventory))
	=>
	(printout t "Choose an item to remove from your inventory." crlf)
	(bind ?count 1)
	(loop-for-count (length $?inventory)
		(printout t "(" ?count ") " (nth$ ?count $?inventory) crlf)
		(bind ?count (+ ?count 1))
	)
	(printout t "(other) Back" crlf)
	(bind ?ans (read))
	(if
		(< (- ?ans 1) (length $?inventory))
	then
		(modify ?player (inventory (delete$ $?inventory ?ans ?ans)))
	)
	(modify ?question (stage main-question))
)

; ; Ask if player wants to start a new session.
(defrule ask-end
	(question (stage end))
	=>
	(printout t "Would you like to start a new session? (Y/y or N/n) ")
	(if
		(eq (lowcase (read)) y)
	then
		(reset)
		(printout t "****************************************" crlf crlf)
	else
		(reset)
		(halt)
	)
)