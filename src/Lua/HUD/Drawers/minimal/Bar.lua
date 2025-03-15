local minimalbar_hud = function(v, player)
	if PTSR.pizzatime then
		local minimalbar = {
			x = 96,
			y = 187,
			width = 128,
			timeleft_width = 128,
			height = 11,
			flags = V_SNAPTOBOTTOM,
			padding = 2,
			timeleft_color = 98
		}
		local bartext = {
			string = G_TicsToMTIME(PTSR.timeleft),
			flags = minimalbar.flags
		}
		if PTSR.isOvertime()
			bartext.string = "OVERTIME!"
			bartext.flags = minimalbar.flags|V_REDMAP
			minimalbar.timeleft_color = 38
		else
			bartext.string = G_TicsToMTIME(PTSR.timeleft)
			minimalbar.timeleft_width = FixedMul( FixedDiv(PTSR.timeleft, (PTSR.maxtime or 4*60*TICRATE)), minimalbar.width)
			local warning_time = 60*TICRATE
			local preovertime = 25*TICRATE
			--bar colors
			if PTSR.timeleft <= warning_time and PTSR.timeleft > preovertime
				minimalbar.timeleft_color = 73
			elseif PTSR.timeleft <= preovertime and PTSR.timeleft > preovertime/2
				minimalbar.timeleft_color = 55
			elseif PTSR.timeleft <= preovertime/2
				minimalbar.timeleft_color = 36
			end
			bartext.flags = minimalbar.flags
		end
		v.drawFill(minimalbar.x, minimalbar.y, minimalbar.width, minimalbar.height, 31|minimalbar.flags|V_HUDTRANSHALF)
		v.drawFill(minimalbar.x+minimalbar.padding, --x
				   minimalbar.y+minimalbar.padding,  --y
				   minimalbar.timeleft_width-(minimalbar.padding*2), --width
				   minimalbar.height-(minimalbar.padding*2), --height
				   minimalbar.timeleft_color|minimalbar.flags|V_HUDTRANS) --flags
		v.drawString(minimalbar.x+(minimalbar.width/2), minimalbar.y+1, bartext.string, bartext.flags|V_HUDTRANS, "center")		  
	end
end

return "Bar", minimalbar_hud, "game", "minimal"