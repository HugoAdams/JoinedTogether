require("Batteries"):export()
require("globals")

object = require("Src.object")

function love.load(arg)
	window.set = love.window.setMode(window.width,window.height)
	balloon = object(100,100)
	balloon:setDrag(40)
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

	balloon:setAcc()

	if love.keyboard.isDown({"right","d"}) then
		balloon:setAccX(50)
	end
	if love.keyboard.isDown({"left","a"}) then
		balloon:setAccX(-50)
	end
	if love.keyboard.isDown({"down","s"}) then
		balloon:setAccY(50)
	end
	if love.keyboard.isDown({"up","w"}) then
		balloon:setAccY(-50)
	end

	balloon:update(dt)
end


function love.draw(dt)
	love.graphics.setColor(1,0,1,1)
	love.graphics.print("cowboy")
	love.graphics.circle("line", 100,100, 32, 1000)
	love.graphics.circle("line", balloon.pos.x,balloon.pos.y, 32, 8)
	love.graphics.print("Cowdoy!",100,100)
	
end