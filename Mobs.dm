mob
	var
		list/cards = list()
		cardViewing = 0
		playing = 0
		list/numbersSelected = list()
		list/bingosPossible = list()
		availableCards = 1
		credits = 0
		rights = 1
		Bingo/bingoGame = null
		obj/tracker/lastTracker = null
		bingosWon = 0

mob/Login()
	..()
	createHud(src.client,src.rights)