require("Batteries"):export()
require("globals")

function love.load(arg)
	window.set = love.window.setMode(window.width,window.height)
	
end


function love.update(dt)
	-- DEBUG - easy exit
	if love.keyboard.isDown("lctrl") then
		if love.keyboard.isDown("q") then
			love.event.quit()
		end
		if love.keyboard.isDown("r") then
			love.event.quit("restart")
		end

	end

end


function love.draw(dt)
	love.graphics.setColor(1,1,1,1)
	
end