proc
	checkGames()
		for(var/i = 1, i<=12, i++)
			var/Bingo/B = new()
			bingoGames["[B.gameNumber]"] += B
			for(var/mob/M in world)
				if(!M.playing)
					createHud(M.client,M.rights)
		while(1)
			if(bingoGames.len <= 0)
				for(var/i = 1, i<=12, i++)
					var/Bingo/B = new()
					bingoGames["[B.gameNumber]"] += B
					for(var/mob/M in world)
						if(!M.playing)
							createHud(M.client,M.rights)
			else if(bingoGames.len < 12)
				var/Bingo/B = new()
				bingoGames["[B.gameNumber]"] += B
				for(var/mob/M in world)
					if(!M.playing)
						createHud(M.client,M.rights)
			sleep(10)