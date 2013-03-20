(deftemplate item
	(slot name (type STRING))
	(slot gold (type INTEGER))
	(multislot recipe (type STRING) (default "None"))
)

(deffacts items
	(item (name "Animal Courier") (gold 150))
	(item (name "Band of Elvenskin") (gold 450))
	(item (name "Belt of Strength") (gold 450))
	(item (name "Blade of Alacrity") (gold 1000))
	(item (name "Boots of Speed") (gold 450))
	(item (name "Bottle") (gold 600))
	(item (name "Demon Edge") (gold 2400))
	(item (name "Ghost Scepter") (gold 1600))
	(item (name "Gloves of Haste") (gold 500))
	(item (name "Healing Salve") (gold 100))
	(item (name "Iron Branch") (gold 53))
	(item (name "Javelin") (gold 1500))
	(item (name "Magic Stick") (gold 200))
	(item (name "Mithril Hammer") (gold 1600))
	(item (name "Mystic Staff") (gold 2700))
	(item (name "Ogre Club") (gold 1000))
	(item (name "Platemail") (gold 1400))
	(item (name "Ring of Health") (gold 875))
	(item (name "Tango") (gold 90))
	(item (name "Town Portal Scroll") (gold 135))
	(item (name "Ultimate Orb") (gold 2100))
	(item (name "Void Stone") (gold 875))
	
	(item (name "Black King Bar Recipe") (gold 1300))
	(item (name "Boots of Travel Recipe") (gold 2000))
	(item (name "Flying Courier Recipe") (gold 220))
	(item (name "Magic Wand Recipe") (gold 150))
	(item (name "Manta Style Recipe") (gold 900))
	(item (name "Shiva's Guard Recipe") (gold 600))
	(item (name "Yasha Recipe") (gold 600))
	
	(item (name "Black King Bar") (recipe "Mithril Hammer" "Ogre Club" "Black King Bar Recipe"))
	(item (name "Boots of Travel") (recipe "Boots of Speed" "Boots of Travel Recipe"))
	(item (name "Flying Courier") (recipe "Animal Courier" "Flying Courier Recipe"))
	(item (name "Magic Wand") (recipe "Magic Stick" "Iron Branch" "Iron Branch" "Iron Branch" "Magic Wand Recipe"))
	(item (name "Manta Style") (recipe "Ultimate Orb" "Yasha" "Manta Style Recipe"))
	(item (name "Monkey King Bar") (recipe "Javelin" "Javelin" "Demon Edge"))
	(item (name "Perseverance") (recipe "Void Stone" "Ring of Health"))
	(item (name "Power Treads") (recipe "Boots of Speed" "Gloves of Haste" "Belt of Strength"))
	(item (name "Scythe of Vyse") (recipe "Mystic Staff" "Ultimate Orb" "Void Stone"))
	(item (name "Shiva's Guard") (recipe "Mystic Staff" "Platemail" "Shiva's Guard Recipe"))
	(item (name "Yasha") (recipe "Blade of Alacrity" "Band of Elvenskin" "Yasha Recipe"))
)

; ; <for-testing>
(deftemplate player
	(slot name (type SYMBOL))
	(multislot inventory (type STRING))
)

; ; <for-testing>
(deffacts players
	(player (name a5) (inventory "Scythe of Vyse" "Blade of Alacrity" "Band of Elvenskin" "Yasha Recipe"))
	(player (name b) (inventory "Boots of Speed" "Belt of Strength" "Gloves of Haste"))
	(player (name c) (inventory "Boots of Speed" "Belt of Strength" "Town Portal Scroll"))
	(player (name d4) (inventory "Power Treads" "Demon Edge" "Town Portal Scroll"))
	(player (name e) (inventory "Belt of Strength" "Mithril Hammer" "Ogre Club" "Javelin" "Demon Edge"))
	(player (name f2) (inventory "Magic Wand"))
	(player (name g) (inventory "Tango" "Healing Salve" "Iron Branch"))
)

; ; <for-testing>
(deftemplate phase
	(slot number (type INTEGER))
	(multislot items (type STRING))
)

; ; <for-testing>
(deffacts phases
	(phase (number 1) (items "Tango" "Tango" "Healing Salve" "Iron Branch" "Iron Branch" "Iron Branch"))
	(phase (number 1) (items "Animal Courier" "Tango" "Healing Salve" "Iron Branch" "Iron Branch"))
	
	(phase (number 2) (items "Magic Wand"))
	(phase (number 2) (items "Bottle"))
	(phase (number 2) (items "Boots of Speed"))
	
	(phase (number 3) (items "Perseverance"))
	
	(phase (number 4) (items "Power Treads"))
	(phase (number 4) (items "Ultimate Orb"))
	(phase (number 4) (items "Black King Bar"))
	(phase (number 4) (items "Ghost Scepter"))
	
	(phase (number 5) (items "Scythe of Vyse"))
	
	(phase (number 6) (items "Monkey King Bar"))
	
	(phase (number 7) (items "Shiva's Guard"))
	(phase (number 7) (items "Manta Style"))
	
	(phase (number 8) (items "Boots of Travel"))
)

; ; <for-testing>
(deffacts initial-facts
	(current-phase 1)
	(current-phase 2)
	(current-phase 3)
	(current-phase 4)
	(current-phase 5)
	(current-phase 6)
	(current-phase 7)
	(current-phase 8)
)


; ; Player template used in the following 3 rules are for testing
; ; Item Combination rule
(defrule item-combination
	?p <- (player (name ?n1) (inventory $?i1))
	(item (name ?n2) (recipe $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	(modify ?p (inventory (insert$ (remove-subset $?i2 $?i1) 1 ?n2)))
)	

; ; Town Portal Scroll Rule
(defrule town-portal
	?recommend <- (recommend (item "Town Portal Scroll"))
	(player (name ?n) (inventory $?i))
	(or (test (subsetp (create$ "Boots of Speed") $?i))
		(test (subsetp (create$ "Power Treads") $?i)))
	;; (not (test (subsetp (create$ "Boots of Travel") $?i)))	
	(not (test (subsetp (create$ "Town Portal Scroll") $?i)))
	=>
	(modify ?recommend (weight 1000))
)

; ; Phase Changing Rule
(defrule phase-change
	?cp <- (current-phase ?p)
	(player (name ?n) (inventory $?i1))
	(phase (number ?p) (items $?i2))
	(test (subsetdp $?i2 $?i1))
	=>
	;; (printout t "phase change for " ?n " from " ?p " to " (+ ?p 1))
	(retract ?cp)
	(assert (current-phase (+ ?p 1)))
)