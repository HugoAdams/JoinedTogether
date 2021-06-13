require("Batteries"):export()
require("globals")

object = require("Src.object")
linej = require("Src.linej")

function love.load(arg)
	window.set = love.window.setMode(window.width,window.height)
	balloon = object(100,100)
	balloon:setDrag(40)

	lines = {linej(0,window.height-50, 400, window.height-50), linej(400,window.height-50, 800, window.height-100)}
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
		balloon:setAccX(500)
	end
	if love.keyboard.isDown({"left","a"}) then
		balloon:setAccX(-500)
	end
	if love.keyboard.isDown({"down","s"}) then
		balloon:setAccY(500)
	end
	if love.keyboard.isDown({"up","w"}) then
		balloon:setAccY(-500)
	end
	
	balloon:setAccY(balloon.acc.y + 250)
	for i, l in ipairs(lines) do 
		if intersect.line_circle_overlap(l.p1, l.p2, 2, balloon.pos, 8) then
			balloon:setPos(balloon.pos.x, balloon.pos.y)
		end
	end
	balloon:update(dt)
end


function love.draw(dt)
	love.graphics.setColor(1,0,1,1)
	love.graphics.print("cowboy")
	love.graphics.circle("line", 100,100, 32, 1000)
	love.graphics.circle("line", balloon.pos.x,balloon.pos.y, 8, 8)
	love.graphics.print("Cowdoy!",100,100)

	for i, l in ipairs(lines) do
		love.graphics.line(l.p1.x, l.p1.y, l.p2.x, l.p2.y)
	end
	
end