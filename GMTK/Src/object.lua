
local object = class()
object.type = "object"

--[[
	Initialize the object by loading the x and y values into
	their relevant vectors, and linking a pre-loaded sprite and
	body. Also initializes the velocity and acceleration vec2's
	for automatic use in update; acc will automatically add
	itself to vel by itself per second, and then vel will add
	itself to pos in the same way, scaled by the global 'meters'
	variable if you desire. Drag is used to modify vel as
	described above setDrag().

	If an object is initialized without a pos/vel/acc/drag, the
	omitted values will be assumed to be 0, however they must
	come in pairs (you cannot just set x and not y for a vector)
	and you must include the lesser vectors (if you only want to
	set acc, you must still include pos and vel as 0,0)
--]]
function object:new(x,y,velX,velY,accX,accY,dragX,dragY)
	self = self:init({
		pos = vec2(),
		vel = vec2(),
		acc = vec2(),
		drag = vec2(),
		realDrag = vec2()
	})
	self:setPos(x,y)
	self:setVel(velX,velY)
	self:setAcc(accX,accY)
	self:setDrag(dragX,dragY)
	return self
end

--[[
	Sets the object's position (in meters) and the raw
	value of Vel and Acc, which are then converted to
	meters at runtime (to avoid weird computation errors)

	GetPos() returns the current position in meters, or
	in pixels if meters aren't being used.
--]]
function object:setPosX(pos)
	if not pos then pos = 0 end
	self.pos.x = pos

	return self.pos.x
end
function object:setPosY(pos)
	if not pos then pos = 0 end
	self.pos.y = pos

	return self.pos.y
end
function object:setPos(x,y)
	self:setPosX(x)
	self:setPosY(y)
	return self.pos
end

function object:setVelX(vel)
	if not vel then vel = 0 end
	self.vel.x = vel
	return self.vel.x
end
function object:setVelY(vel)
	if not vel then vel = 0 end
	self.vel.y = vel
	return self.vel.y
end
function object:setVel(x,y)
	if not y then y = x end
	self:setVelX(x)
	self:setVelY(y)
	return self.vel
end

function object:setAccX(acc)
	if not acc then acc = 0 end
	self.acc.x = acc
	return self.acc.x
end
function object:setAccY(acc)
	if not acc then acc = 0 end
	self.acc.y = acc
	return self.acc.y
end
function object:setAcc(x,y)
	if not y then y = x end
	self:setAccX(x)
	self:setAccY(y)
	return self.acc
end

--[[
	TODO

	If one value is given for setDrag(), both x and y are set
	to the same value.
	If no values are given, the drag is set to 0%.
--]]
function object:setDragX(drag)
	if drag then
		self.drag.x = drag/10
	else
		self.drag.x = 0
	end
	return self.drag.x
end
function object:setDragY(drag)
	if drag then
		self.drag.y = drag/10
	else
		self.drag.y = 0
	end
	return self.drag.y
end
function object:setDrag(x,y)
	if not y then y = x end
	self:setDragX(x)
	self:setDragY(y)
	return self.drag
end
function object:getDragX()
	return self.drag.x*10
end
function object:getDragY()
	return self.drag.y*10
end
function object:getDrag()
	return vec2(getDragX(),getDragY())
end

function object:update(dt)
	self.vel:fmai(self.acc,dt)
	self.vel:vsubi(self.vel:vmul(self.drag):smul(dt))

	--set the position based on time spent
	self.pos:fmai(self.vel,dt)

	self.pos:decimal_roundi(7)
	self.vel:decimal_roundi(5)
	self.acc:decimal_roundi(5)
end

return object