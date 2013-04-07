; ; User Interface Rules

; ; Ask player for his/her playing style.
(defrule ask-playstyle
	; ; TODO if there is a player without playstyle
	?player <- (player (playstyle NIL))
	=>
	(printout t crlf "What is your playstyle?" crlf)
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
		(printout t crlf "What are the heroes on the opposing team?" crlf)
		(bind ?count 0)
		(modify ?opTeam (count ?count))
	)
	(printout t "Hero (#" (+ ?count 1) ") : ")
	(bind ?ans (lowcase (readline)))
	(assert (checkHero (str-cat ?ans)))
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
	(player (playstyle ~NIL) (inventory $?inv))
	(team (count ?count&: (= ?count 5)))
	(current-phase ?phase)
	=>
	(printout t crlf "YOUR INVENTORY NOW: " crlf)
	(loop-for-count (?x 1 (length$ $?inv))
		(printout t (nth$ ?x $?inv) crlf))
	(printout t crlf "What would you like to do next?" crlf)
	(printout t "(1) Get next suggestion" crlf)
	(printout t "(2) Use/discard/sell an item" crlf)
	(printout t "(3) End session" crlf)
	(printout t "(other) Stop program" crlf)
	(bind ?ans (read))
	(switch ?ans
		(case 1 then
			;;(if
			;;	(<= ?phase 8)
			;;then
			;;	(modify ?question (stage gold-question))
			;;else
			;;	(modify ?question (stage decide))
			;;)
			(switch ?phase
				(case 1 then (modify ?question (stage initial-suggestion)))
				(case 9 then
					(modify ?question (stage decide))
					(assert (resetRec))
				)
				(default (modify ?question (stage gold-question)))
			)
		)
		(case 2 then (modify ?question (stage discard)))
		(case 3 then (modify ?question (stage end)))
	)
)

; ; Give initial suggestion.
(defrule initial-suggestion
	?question <- (question (stage initial-suggestion))
	?player <- (player (inventory $?inventory))
	=>
	(printout t crlf "Does your team have an Animal/Flying Courier?" crlf)
	(printout t "(1) Yes" crlf)
	(printout t "(2) No" crlf)
	(bind ?ans (read))
	(printout t crlf "MY SUGGESTION:" crlf)
	(switch ?ans
		(case 1 then
			(printout t "*** Buy 2x Tango, 1x Healing Salve, 3x Iron Branch next." crlf)
			(modify ?player (inventory (insert$ $?inventory 1 (create$ "Tango" "Tango" "Healing Salve" "Iron Branch" "Iron Branch" "Iron Branch"))))
		)
		(case 2 then
			(printout t "*** Buy Animal Courier, 1x Tango, 1x Healing Salve, 2x Iron Branch next." crlf)
			(modify ?player (inventory (insert$ $?inventory 1 (create$ "Tango" "Healing Salve" "Iron Branch" "Iron Branch"))))
		)
	)
	(modify ?question (stage main-question))
)

; ; Ask player for gold per minute and current gold.
(defrule ask-gold
	?question <- (question (stage gold-question))
	?player <- (player (inventory $?inventory))
	=>
	(printout t crlf "What is your current gold per minute? ")
	(bind ?ans-gpm (read))
	(printout t "How much gold do you currently have? ")
	(bind ?ans-gold (read))
	(modify ?player (gpm ?ans-gpm) (gold ?ans-gold))
	(printout t crlf "MY SUGGESTION:" crlf)
	(modify ?question (stage decide))
	(assert (resetRec))
)

; ; Ask player which item has been used/discarded/sold.
(defrule ask-items
	?question <- (question (stage discard))
	?player <- (player (inventory $?inventory))
	=>
	(if
		(> (length $?inventory) 0)
	then
		(printout t crlf "Choose an item to remove from your inventory:" crlf)
	else
		(printout t crlf "You do not have any items at the moment." crlf)
	)
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
	;;(printout t "Would you like to start a new session? (Y/y or N/n) ")
	(printout t "Would you like to start a new session?" crlf)
	(printout t "(1) Yes" crlf)
	(printout t "(2) No" crlf)
	;;(if
	;;	(eq (lowcase (read)) y)
	;;then
	;;	(reset)
	;;	(printout t "****************************************" crlf crlf)
	;;else
	;;	(reset)
	;;	(halt)
	;;)
	(bind ?ans (read))
	(switch ?ans
		(case 1 then
			(reset)
			(printout t "****************************************" crlf crlf)
		)
		(case 2 then
			(reset)
			(halt)
		)
	)
)