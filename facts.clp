; ; Facts
(deffacts initial-facts

	; ; Question.
	
	(question)
	
	; ; Player.
	
	(player)
	
	; ; Heroes.
	
	(hero (heroName "abaddon"))
	(hero (heroName "alchemist"))
	(hero (heroName "ancient apparition"))
	(hero (heroName "anti mage"))
	(hero (heroName "arc warden"))
	(hero (heroName "axe"))
	(hero (heroName "bane"))
	(hero (heroName "batrider"))
	(hero (heroName "beastmaster"))
	(hero (heroName "bloodseeker"))
	(hero (heroName "bounty hunter"))
	(hero (heroName "brewmaster"))
	(hero (heroName "bristleback"))
	(hero (heroName "broodmother"))
	(hero (heroName "centaur warrunner"))
	(hero (heroName "chaos knight") (heroType physical))
	(hero (heroName "chen"))
	(hero (heroName "clinkz"))
	(hero (heroName "clockwerk"))
	(hero (heroName "crystal maiden"))
	(hero (heroName "dark seer"))
	(hero (heroName "dazzle"))
	(hero (heroName "death prophet"))
	(hero (heroName "disruptor"))
	(hero (heroName "doom bringer"))
	(hero (heroName "dragon knight"))
	(hero (heroName "drow ranger") (heroType physical))
	(hero (heroName "earthshaker") (heroType disabler))
	(hero (heroName "ember spirit"))
	(hero (heroName "enchantress"))
	(hero (heroName "enigma"))
	(hero (heroName "faceless void"))
	(hero (heroName "goblin techies"))
	(hero (heroName "gyrocopter"))
	(hero (heroName "huskar"))
	(hero (heroName "invoker"))
	(hero (heroName "jakiro"))
	(hero (heroName "juggernaut"))
	(hero (heroName "keeper of the light"))
	(hero (heroName "kunkka"))
	(hero (heroName "legion commander"))
	(hero (heroName "leshrac") (heroType spell))
	(hero (heroName "lich") (heroType spell))
	(hero (heroName "lifestealer"))
	(hero (heroName "lina") (heroType spell))
	(hero (heroName "lion") (heroType disabler))
	(hero (heroName "lone druid"))
	(hero (heroName "luna"))
	(hero (heroName "lycanthrope") (heroType physical))
	(hero (heroName "magnus"))
	(hero (heroName "medusa"))
	(hero (heroName "meepo"))
	(hero (heroName "mirana"))
	(hero (heroName "morphling"))
	(hero (heroName "naga siren"))
	(hero (heroName "nature's prophet"))
	(hero (heroName "necrolyte"))
	(hero (heroName "night stalker"))
	(hero (heroName "nyx assasin"))
	(hero (heroName "ogre magi") (heroType spell))
	(hero (heroName "omniknight"))
	(hero (heroName "outworld destroyer"))
	(hero (heroName "phantom assasin") (heroType physical))
	(hero (heroName "phantom lancer"))
	(hero (heroName "phoenix"))
	(hero (heroName "pit lord"))
	(hero (heroName "puck"))
	(hero (heroName "pudge"))
	(hero (heroName "pugna"))
	(hero (heroName "queen of pain") (heroType spell))
	(hero (heroName "razor"))
	(hero (heroName "riki") (heroType physical))
	(hero (heroName "rubick"))
	(hero (heroName "sand king"))
	(hero (heroName "shadow demon"))
	(hero (heroName "shadow fiend"))
	(hero (heroName "shadow shaman") (heroType disabler))
	(hero (heroName "silencer"))
	(hero (heroName "skeleton king"))
	(hero (heroName "skywrath mage"))
	(hero (heroName "slardar"))
	(hero (heroName "slark"))
	(hero (heroName "sniper"))
	(hero (heroName "soul keeper"))
	(hero (heroName "spectre"))
	(hero (heroName "spirit breaker"))
	(hero (heroName "storm spirit"))
	(hero (heroName "sven"))
	(hero (heroName "tauren chieftain"))
	(hero (heroName "templar assasin"))
	(hero (heroName "tidehunter"))
	(hero (heroName "timbersaw"))
	(hero (heroName "tinker"))
	(hero (heroName "tiny") (heroType disabler))
	(hero (heroName "treant protector"))
	(hero (heroName "troll warlord"))
	(hero (heroName "tusk"))
	(hero (heroName "undying"))
	(hero (heroName "ursa") (heroType physical))
	(hero (heroName "vengeful spirit"))
	(hero (heroName "venomancer"))
	(hero (heroName "viper"))
	(hero (heroName "visage"))
	(hero (heroName "warlock"))
	(hero (heroName "weaver"))
	(hero (heroName "windrunner"))
	(hero (heroName "wisp"))
	(hero (heroName "witch doctor"))
	(hero (heroName "zeus") (heroType spell))
	
	; ; Opponent team.
	
	(team (count -1))
	
	; ; Items.
	
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
	
	; ; Phases.
	
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
	
	; ; Current phase.
	
	(current-phase 1)
	; ; <testing>
	;;(current-phase 2)
	
	; ; Recommend.
	
	(recommend (item "Magic Wand"))
	(recommend (item "Bottle"))
	(recommend (item "Perseverance"))
	(recommend (item "Boots of Speed"))
	(recommend (item "Power Treads"))
	(recommend (item "Ultimate Orb"))
	(recommend (item "Black King Bar"))
	(recommend (item "Ghost Scepter"))
	(recommend (item "Scythe of Vyse"))
	(recommend (item "Monkey King Bar"))
	(recommend (item "Shiva's Guard"))
	(recommend (item "Manta Style"))
	(recommend (item "Boots of Travel"))
	
	; ; Decided.
	(decided)

	; ; Ownage Level.
	(ownage-level low)
)