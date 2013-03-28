; ; Templates

; ; Question template.
(deftemplate question
	(slot stage (allowed-values main-question initial-suggestion gold-question decide discard end) (default main-question))
)

; ; Player template.
(deftemplate player
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type SYMBOL))
)

; ; Hero template.
(deftemplate hero
	(slot heroName (type STRING))
	(slot heroType (allowed-values disabler physical spell useless)  (default useless))
)

; ; Opponent team template
(deftemplate team
	(slot count (type INTEGER))
	(slot num_disabler (type INTEGER))
	(slot num_physical (type INTEGER))
	(slot num_spell (type INTEGER))
	(slot num_useless (type INTEGER))
)

; ; Item template.
(deftemplate item
	(slot name (type STRING))
	(slot gold (type INTEGER))
	(multislot recipe (type STRING) (default "None"))
)

; ; Game phase template.
(deftemplate phase
	(slot number (type INTEGER))
	(multislot items (type STRING))
)

; ; Recommend template.
(deftemplate recommend
	(slot item (type STRING))
	(slot weight (type INTEGER) (default 0))
)

(deftemplate ownage-level
	(slot level (allowed-values low normal high))
	)