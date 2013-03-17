(deftemplate item
	(slot name (type STRING))
	(slot gold (type INTEGER))
	(multislot recipe (type STRING) (default NIL))
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
	(slot playstyle (allowed-values defensive neutral aggressive NIL)  (default NIL))
	(slot gpm (type INTEGER))
	(slot gold (type INTEGER))
	(multislot inventory (type STRING))
)

; ; Item Combination rule
(defrule item-combination
	(player (inventory ?i))
	(item (name ?n) (recipe ?r))

)	