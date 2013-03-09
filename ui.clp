; ; User Interface

; ; Question template.
(deftemplate question
	(slot stage (allowed-values suggest discard end NIL) (default NIL))
)

; ; <for-testing>
(deftemplate player
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type SYMBOL))
)

(deffacts test-facts
	;;(player (playstyle neutral) (inventory item-1 item-2 item-3 item-4 item-5 item-6))
	(player (inventory item-1 item-2 item-3 item-4 item-5 item-6))
	(question)
)
; ; </for-testing>

; ; Ask player for his/her playing style.
(defrule ask-playstyle
	; ; TODO if there is a player without playstyle
	?player <- (player (playstyle NIL))
	=>
	(printout t "What is your playstyle?" crlf)
	(printout t "(1) Defensive" crlf)
	(printout t "(2) Neutral" crlf)
	(printout t "(3) Aggressive" crlf)
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
	?opTeam <- (team (count ?count&: (< ?count 5)))
	=>
	(printout t "What are the heroes on the opposing team?" crlf)
	(while (< ?count 5)
		(printout t "Hero (#" (+ ?count 1) ") : ")
		(bind ?ans (read))
		;;(if
			; ; TODO check whether ?ans is a valid hero name
		;;then
			; ; TODO add hero into facts
			(printout t ?ans " added to opposing team fact." crlf)
			(bind ?count (+ ?count 1))
		;;else
		;;	(printout t ?ans " is not a valid hero!" crlf)
		;;)
	)
	(modify ?opTeam (count ?count))
)

; ; Ask player for next action.
; ; NOTES problem with use/discard/sell being situational:
; ; 		- have to check if there are consumables in player's inventory
; ;			- in addition to checking if inventory is full
; ;			- player may have removed more than 1 item from inventory
; ;			- additional facts/templates may have to be added to keep track of this
; ;			- easier to just let player choose to inform system whenever item is removed
(defrule ask-next-action
	?question <- (question (stage NIL))
	(player (playstyle ~NIL))
	(team (count ?count&: (= ?count 5)))
	=>
	(printout t "What would you like to do next?" crlf)
	(printout t "(1) Get next suggestion" crlf)
	(printout t "(2) Use/discard/sell an item" crlf)
	(printout t "(3) End session" crlf)
	(bind ?ans (read))
	(switch ?ans
		(case 1 then (modify ?question (stage suggest)))
		(case 2 then (modify ?question (stage discard)))
		(case 3 then (modify ?question (stage end)))
	)
)

; ; Ask player for gold per minute and current gold.
(defrule ask-gold
	?question <- (question (stage suggest))
	?player <- (player)
	=>
	(printout t "What is your current gold per minute? ")
	(bind ?ans-gpm (read))
	(printout t "How much gold do you currently have? ")
	(bind ?ans-gold (read))
	(modify ?player (gpm ?ans-gpm) (gold ?ans-gold))
	; ; TODO other rules that will modify question stage for situational questions
	; ; such as whether player is being killed
	(modify ?question (stage NIL))
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
	(printout t "(" ?count ") Cancel" crlf)
	(bind ?ans (read))
	(if
		(< (- ?ans 1) (length $?inventory))
	then
		(modify ?player (inventory (delete$ $?inventory ?ans ?ans)))
	)
	(modify ?question (stage NIL))
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