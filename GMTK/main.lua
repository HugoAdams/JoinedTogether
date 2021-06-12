require("Batteries"):export()
require("globals")

function love.load(arg)
	window.set = love.window.setMode(window.width,window.height)
	--TESTB
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
	love.graphics.setColor(1,0,1,1)
	love.graphics.print("cowboy")
	love.graphics.circle("line", 100,100, 32, 8)
	love.graphics.print("Cowdoy!",100,100)
	
end