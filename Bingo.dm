Bingo
	var
		list/players = list()
		list/availableNumbers = list()
		list/usedNumbers = list("Free")
		//BINGO
		list/B = list()
		list/I = list()
		list/N = list()
		list/G = list()
		list/O = list()
		//End BINGO
		availableBingos = 10
		gameNumber = 0
		checking = 1
		started = 0
		obj/cards/blankSpot/lastCalled = null
		list/displayedNumbers = list()
		list/numberSpots = list()
		list/bingosAccepted = list("ALL")
		list/winners = list()
	proc
		endGame()
			bingoGames.Remove("[src.gameNumber]")
			world << "<b>Bingo Game [src.gameNumber] has ended!"
			for(var/mob/M in src.players)
				M.playing = 0
				M.bingoGame = null
				src.players.Remove(M)
				for(var/i in M.cards)
					M.cards.Remove(i)
				for(var/obj/o in M.client.screen)
					del(o)
			for(var/mob/M in world)
				createHud(M.client,M.rights)
			del(src)
		joinGame(mob/M)
			if(!M.playing)
				if(!(src.winners.Find(M)))
					src.players.Add(M)
					M.playing = 1
					M.bingoGame = src
					for(var/mob/Mob in world)
						if(!Mob.playing)
							createHud(Mob.client,Mob.rights)
					for(var/i=1,i<=M.availableCards,i++)
						src.createCard(M.client,5,5)
				else
					M << "You have already won in this game and are not allowed re-entry."
			else
				M << "You are currently taking part in a game already."
		leaveGame(mob/M)
			if(!(src.winners.Find(M)))
				switch(alert("Are you sure you want to leave this game?","Error -","Yes","No"))
					if("Yes")
						M.playing = 0
						src.players.Remove(M)
						for(var/i in M.cards)
							M.cards.Remove(i)
						for(var/obj/o in M.client.screen)
							del(o)
						createHud(M.client,M.rights)
			else
				var/creditsAwarded
				if(M.bingosWon < 1)
					M << "<b>Congratulations on winning your first bingo game! You will be awarded 50 credits for your first win!"
					creditsAwarded = 50
				else
					creditsAwarded = 5
					M << "<b>Congratulations on winning another bingo game! You will be awarded [creditsAwarded] credits!"
				M.credits += creditsAwarded
				M.playing = 0
				src.players.Remove(M)
				for(var/i in M.cards)
					M.cards.Remove(i)
				for(var/obj/o in M.client.screen)
					del(o)
				createHud(M.client,M.rights)
		numberCaller()
			while(1)
				if(src.availableNumbers.len > 0)
					if(src.availableBingos > 0)
						var/number = pick(availableNumbers)
						var/obj/cards/blankSpot/bp = new /obj/cards/blankSpot/
						bp.value = number
						checkLocation(bp)
						src.usedNumbers[number] += time2text()
						src.availableNumbers -= number
						sleep(5)
					else
						for(var/mob/M in src.players)
							M << "There are no more bingos."
						spawn() endGame()
						break
				else
					for(var/mob/M in src.players)
						M << "There are no longer any more numbers to choose from."
					spawn() endGame()
					break
		checkLocation(obj/cards/blankSpot/C)
			var
				x
				y
				newValue
				newType
				list/newSpots = list()
			x = 15
			y = 15
			newSpots += "value=[C.value],type=[availableNumbers[C.value]],x=[x],y=[y]"
			for(var/i in src.numberSpots)
				var/value = findtext(i,"value=")
				var/endValue = findtext(i,",",value)
				var/type = findtext(i,"type=")
				var/endType = findtext(i,",",type)
				var/xLocation = findtext(i,"x=")
				var/endX = findtext(i,",",xLocation)
				var/yLocation = findtext(i,"y=")
				var/endY = findtext(i,",",yLocation)
				newValue = copytext(i,value + 6,endValue)
				newType = copytext(i,type + 5,endType)
				x = text2num(copytext(i,xLocation + 2,endX))
				y = text2num(copytext(i,yLocation + 2,endY))
				x = x-1
				newSpots += "value=[newValue],type=[newType],x=[x],y=[y]"

			for(var/i in src.numberSpots)
				src.numberSpots.Remove(i)
			for(var/i in newSpots)
				src.numberSpots += i
			for(var/i in src.numberSpots)
				var/value = findtext(i,"value=")
				var/endValue = findtext(i,",",value)
				var/type = findtext(i,"type=")
				var/endType = findtext(i,",",type)
				var/xLocation = findtext(i,"x=")
				var/endX = findtext(i,",",xLocation)
				var/yLocation = findtext(i,"y=")
				var/endY = findtext(i,",",yLocation)
				newValue = copytext(i,value + 6,endValue)
				newType = copytext(i,type + 5,endType)
				x = text2num(copytext(i,xLocation + 2,endX))
				y = text2num(copytext(i,yLocation + 2,endY))
				if(x >= 11)
					var/obj/cards/blankSpot/bp = new /obj/cards/blankSpot/
					bp.maptext = "<font color=black><text align=top><center>[newType]<br><b>[newValue]</b>"
					bp.screen_loc = "[x],[y]"
					for(var/mob/M in world)
						if(src.players.Find(M))
							M.client.screen += bp
		generateNumbers(maxNumber)
			for(var/number=1,number<=maxNumber,number++)
				if(number<=maxNumber*0.20)
					src.B += number
					src.availableNumbers["[number]"] = "B"
				if(number<=maxNumber*0.40 && number>maxNumber*0.20)
					src.I += number
					src.availableNumbers["[number]"] = "I"
				if(number<=maxNumber*0.60 && number>maxNumber*0.40)
					src.N += number
					src.availableNumbers["[number]"] = "N"
				if(number<=maxNumber*0.80 && number>maxNumber*0.60)
					src.G += number
					src.availableNumbers["[number]"] = "G"
				if(number<=maxNumber && number>maxNumber*0.80)
					src.O += number
					src.availableNumbers["[number]"] = "O"
		createCard(client/c,totalX,totalY)
			//creating lists
			var/list/availableB = list()
			var/list/availableI = list()
			var/list/availableN = list()
			var/list/availableG = list()
			var/list/availableO = list()
			//filling lists
			for(var/i in src.B)
				availableB += i
			for(var/i in src.I)
				availableI += i
			for(var/i in src.N)
				availableN += i
			for(var/i in src.G)
				availableG += i
			for(var/i in src.O)
				availableO += i
			//ending filling
			var/string
			for(var/y=1,y<=totalY,y++)
				for(var/x=1,x<=totalX,x++)

					var/newX = x + 5
					var/newY = y + 5

					var/number
					if(x == round(totalX / 2,1) && y == round(totalY / 2,1))
						number = "Free"
					else
						if(x==1)
							number=pick(availableB)
							availableB -= number
						if(x==2)
							number=pick(availableI)
							availableI -= number
						if(x==3)
							number=pick(availableN)
							availableN -= number
						if(x==4)
							number=pick(availableG)
							availableG -= number
						if(x==5)
							number=pick(availableO)
							availableO -= number
					string += "[number],[newX],[newY];"
			var/amountOfCards = c.mob.cards.len + 1
			c.mob.cards +=  "[amountOfCards]"
			c.mob.cards["[amountOfCards]"] = string
			if(amountOfCards == 1)
				c.mob.cardViewing = 1
				generateCard(c.mob,1)
				generateTracker(c.mob,src,1)
		startGame()
			for(var/mob/M in world)
				if(!M.playing || src.players.Find(M))
					world << "<b>A new bingo game has been created and will start in 1 minute!"
			sleep(300)
			for(var/mob/M in world)
				if(!M.playing || src.players.Find(M))
					world << "Bingo Game [src.gameNumber] will start in 30 seconds!"
			sleep(300)
			for(var/mob/M in world)
				if(!M.playing || src.players.Find(M))
					world << "Bingo Game [src.gameNumber] has started!"
			src.started = 1
			if(src.players.len < 2)
				src.endGame()
			src.numberCaller()
	New()
		..()
		src.gameNumber = bingoGames.len + 1
		generateNumbers(75)
		spawn() src.startGame()