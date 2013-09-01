obj/cards
	icon = 'icons.dmi'
	var/value
	var/clicked
	var/card
	var/cardx
	var/cardy
	blankSpot
		icon_state = "spots"
		Click()
			if(!src.clicked)
				src.clicked = 1
				src.maptext = "<font color = white><text align=middle><center>[src.value]"
				src.icon_state = "cover"
				usr.numbersSelected += src.value
				usr.numbersSelected[src.value] = src.card
			else
				src.clicked = 0
				src.maptext = "<font color = black><text align=middle><center>[src.value]"
				src.icon_state = "spots"
				usr.numbersSelected -= src.value
			generateTracker(usr,usr.bingoGame,usr.cardViewing)
	left
		icon_state="left1"
	right
		icon_state="right1"
	middle
		icon_state="middle"
