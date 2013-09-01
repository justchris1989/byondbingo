obj/hud
	icon = 'hud.dmi'
	var/action
	Click()
		if(action == "Switch")
			var/length = usr.cards.len
			if(usr.cardViewing == length)
				usr.cardViewing = 0
			usr.cardViewing ++
			generateCard(usr,usr.cardViewing)
			for(var/i in bingoGames)
				if(bingoGames[i] == usr.bingoGame)
					var/Bingo/B = bingoGames[i]
					generateTracker(usr,B,usr.cardViewing)
			createHud(usr.client,usr.rights)
		if(action == "BINGO")
			if(!usr.lastTracker)
				return
			var/bingo = checkBingo(usr,usr.lastTracker,1)
			if(bingo)
				for(var/i in bingoGames)
					if(bingoGames[i] == usr.bingoGame)
						var/Bingo/B = bingoGames[i]
						B.winners.Add(usr)
						B.leaveGame(usr)
			else
				usr << "nope"
		/*if(action == "Create")
			var/Bingo/B = new()
			bingoGames["[B.gameNumber]"] += B
			createHud(usr.client,usr.rights)*/
		if(action == "Join")
			var/string = findtext(src.maptext,"BINGO ")
			var/space = findtext(src.maptext," ",string+6)
			var/gameNumber = copytext(src.maptext,string + 6, space)
			for(var/i in bingoGames)
				if(gameNumber == i)
					var/Bingo/B = bingoGames[i]
					//if(!B.started)
					B.joinGame(usr)
					//else
					//	usr << "This game has already started."
			createHud(usr.client,usr.rights)
		if(action == "Leave")
			for(var/i in bingoGames)
				if(bingoGames[i] == usr.bingoGame)
					var/Bingo/B = bingoGames[i]
					B.leaveGame(usr)

proc/createHud(client/C,rights)
	for(var/obj/hud/h in C.screen)
		del(h)
	var/y = 15
	/*if(rights && !C.mob.playing)
		if(bingoGames.len < 12)
			var/obj/hud/create = new /obj/hud
			create.icon = 'smallerhud.dmi'
			create.screen_loc = "1,[y]"
			create.maptext = "<font color=black><text align = middle><center><small>Create"
			create.maptext_width = 64
			create.action = "Create"
			C.screen += create
			y = y - 4*/
	if(!C.mob.playing)
		y = 11
		if(bingoGames.len > 0)
			var/x = 3
			for(var/i in bingoGames)
				if(x >=14)
					x = 3
					y = y - 3
				var/Bingo/B = bingoGames[i]
				var/obj/hud/join = new /obj/hud
				var/color="black"
				join.screen_loc = "[x],[y]"
				if(B.started)
					color="grey"
				join.maptext = "<font color=[color]><text align = top><center><small>BINGO [i] <br>Players - [B.players.len]"
				join.maptext_width = 64
				join.action = "Join"
				C.screen += join
				x = x + 3
	else
		var/obj/hud/leave = new /obj/hud
		leave.icon = 'smallerhud.dmi'
		leave.screen_loc = "1,[y]"
		leave.maptext = "<font color=black><text align = middle><center><small>Leave"
		leave.maptext_width = 64
		leave.action = "Leave"
		C.screen += leave
		y --
		if(C.mob.availableCards > 1)
			var/obj/hud/cardswitch = new /obj/hud
			cardswitch.icon = 'smallerhud.dmi'
			cardswitch.screen_loc = "1,[y]"
			cardswitch.maptext = "<font color=black><text align = middle><center><small>Switch Cards"
			cardswitch.maptext_width = 64
			cardswitch.action = "Switch"
			C.screen += cardswitch
		var/Bingo/B = C.mob.bingoGame
		if(B.availableBingos > 0)
			var/obj/hud/bingo = new /obj/hud
			bingo.icon = 'smallerhud.dmi'
			bingo.icon_state = "bingo"
			bingo.screen_loc = "13:26,1:6"
			bingo.maptext = "<font color=white><text align = middle><center>! BINGO !"
			bingo.maptext_width = 64
			bingo.action = "BINGO"
			C.screen += bingo