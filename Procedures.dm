proc
	checkBingo(mob/M,obj/tracker/t,checkBingo)
		var/bingo = 0
		//long ways
		var/list/longMarked = list()
		for(var/obj/tracker/newT in M.client.screen)
			if(newT.tileY == t.tileY && newT.marked)
				longMarked.Add(newT)
		if(longMarked.len >= 4)
			bingo = 1
			t.icon_state = "bingo"
			for(var/obj/tracker/createT in longMarked)
				createT.icon_state = "bingo"
		//tall ways
		var/list/tallMarked = list()
		for(var/obj/tracker/newT in M.client.screen)
			if(newT.tileX == t.tileX && newT.marked)
				tallMarked.Add(newT)
		if(tallMarked.len >= 4)
			bingo = 1
			t.icon_state = "bingo"
			for(var/obj/tracker/createT in tallMarked)
				createT.icon_state = "bingo"
		//four corners
		var/list/cornersMarked = list()
		for(var/obj/tracker/newT in M.client.screen)
			if(newT.tileY == 10 && newT.tileX == 6 && newT.marked || newT.tileY == 6 && newT.tileX == 6 && newT.marked || newT.tileY == 10 && newT.tileX == 10 && newT.marked|| newT.tileY == 6 && newT.tileX == 10 && newT.marked)
				cornersMarked.Add(newT)
		if(t.tileY == 10 && t.tileX == 6|| t.tileY == 6 && t.tileX == 6|| t.tileY == 10 && t.tileX == 10|| t.tileY == 6 && t.tileX == 10)
			cornersMarked.Add(t)
		if(cornersMarked.len >= 4)
			bingo = 1
			t.icon_state = "bingo"
			for(var/obj/tracker/createT in cornersMarked)
				createT.icon_state = "bingo"
		//left diagnol bingo
		var/list/leftdiagnolsMarked = list()
		for(var/i=6,i<=10,i++)
			for(var/obj/tracker/newT in M.client.screen)
				if(newT.tileX == i && newT.tileY == i && newT.marked)
					leftdiagnolsMarked.Add(newT)
			if(t.tileX == i && t.tileY == i)
				leftdiagnolsMarked.Add(t)
		if(leftdiagnolsMarked.len >= 5)
			bingo = 1
			for(var/obj/tracker/createT in leftdiagnolsMarked)
				createT.icon_state = "bingo"
		var/list/rightdiagnolsMarked = list()
		//right diagnol bingo
		var/y = 6
		var/x = 10
		for(var/i=0,i<=4,i++)
			y = y + i
			x = x - i
			for(var/obj/tracker/newT in M.client.screen)
				if(newT.tileY == x && newT.tileX == y && newT.marked)
					rightdiagnolsMarked.Add(newT)
			if(t.tileX == y && t.tileY == x)
				rightdiagnolsMarked.Add(t)
			y = 6
			x = 10
		if(rightdiagnolsMarked.len >= 5)
			bingo = 1
			for(var/obj/tracker/createT in rightdiagnolsMarked)
				world << "[createT.tileY],[createT.tileX]"
				createT.icon_state = "bingo"
		if(checkBingo)
			return bingo

	generateCard(mob/M,cardNumber)
		var/string
		for(var/i in M.cards)
			if(i == "[cardNumber]")
				string = M.cards[i]
		if(!string)
			world << "no card exists"
			return
		var/string1 = copytext(string,1,lentext(string) + 1)
		while(1)

			if(string1)
				var/stopper = findtext(string1,";")
				var/information = copytext(string1,1,stopper)
				var/number = copytext(information,1,findtext(information,","))
				information = copytext(information,findtext(information,",") + 1,lentext(information) + 1)
				var/x = copytext(information,1,findtext(information,","))
				information = copytext(information,findtext(information,",") + 1,lentext(information) + 1)
				var/y = copytext(information,1,lentext(information) + 1)
				var/obj/cards/blankSpot/bp = new /obj/cards/blankSpot/
				bp.screen_loc = "[x],[y]"
				bp.value = number
				bp.card = cardNumber
				bp.cardx = x
				bp.cardy = y
				if(M.numbersSelected.len > 0)
					for(var/i in M.numbersSelected)
						if(bp.value == i && bp.card == M.numbersSelected[i])
							bp.clicked = 1
				if(bp.clicked)
					bp.maptext = "<font color=white><text align=middle><center>[number]"
					bp.icon_state = "cover"
				else
					bp.maptext = "<font color=black><text align=middle><center>[number]"
					bp.icon_state = "spots"
				M.client.screen += bp
				var/newString = copytext(string1,stopper + 1, lentext(string1) + 1)
				string1 = newString
			else
				break
		generateTitle(M,5,5)
	generateTitle(mob/M,totalX,totalY)
		var/newY = totalY + 6
		for(var/x=1,x<=totalX,x++)
			var/newX = x + 5
			var/obj/o
			if(x==1)
				o = new /obj/cards/left/
				o.maptext = "<font color = white><text align=middle><center><B>B"
			if(x>1&&x<5)
				o = new /obj/cards/middle/
				if(x==2)
					o.maptext = "<font color = white><text align=middle><center><B>I"
				if(x==3)
					o.maptext = "<font color = white><text align=middle><center><B>N"
				if(x==4)
					o.maptext = "<font color = white><text align=middle><center><B>G"
			if(x==5)
				o = new /obj/cards/right/
				o.maptext = "<font color = white><text align=middle><center><B>O"
			o.screen_loc = "[newX],[newY]"
			M.client.screen += o