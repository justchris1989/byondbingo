obj/tracker
	icon = 'pixels.dmi'
	var/clicked
	var/tileX
	var/tileY
	var/marked

proc
	generateTracker(mob/M,Bingo/B,cardNumber)
		for(var/obj/tracker/t in M.client.screen)
			del(t)
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
				var/obj/tracker/t = new /obj/tracker/
				t.screen_loc = "0:[text2num(x)*6],0:[text2num(y)*6]"
				t.tileX = text2num(x)
				t.tileY = text2num(y)
				if(M.numbersSelected.len > 0)
					for(var/i in M.numbersSelected)
						if(number == i && cardNumber == M.numbersSelected[i])
							t.clicked = 1
				if(t.clicked)
					if(B.usedNumbers.Find(number))
						t.icon_state = "marked"
						t.marked = 1
						M.lastTracker = t
						checkBingo(M,t,0)
					else
						t.icon_state = "error"
				else
					t.icon_state = "unmarked"
				M.client.screen += t
				var/newString = copytext(string1,stopper + 1, lentext(string1) + 1)
				string1 = newString
			else
				break
