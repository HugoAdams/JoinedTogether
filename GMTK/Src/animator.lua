
local animator = class()

--[[
	Create a new animator that handles a single spritesheet.
	Each of these animators can fully handle an entire single sheet,
	and can store any number of descrete animations and call them
	individually, with a number of variables.
	As it handles its own animating, it is not well suited to rendering
	multiple different sprites during the same drawcall.

	"sprite" is your image texture, and should be generated prior to
	passing it to the animator by using love.graphics.newImage("path")

	"framewidth" and "frameheight" are 'static' variables that determine
	the width and height of the generated quads. After this it is only
	used for reference purposes and should not be altered manually.

	"offsetx" and "offsety" are more 'static' variables used to offset
	the image that is used for generating the quads. Similar to frame
	sizes, they should not be altered manually.
	
	"centered" determines if the image that renders should be rendered
	from the top left (false) or from the center of the image (true).
	This can be changed at any time.
--]]
function animator:new(sprite,framewidth,frameheight,offsetx,offsety,centered)
	if not offsetx then offsetx = 0 end
	if not offsety then offsety = offsetx end

	self = self:init({
			sprite = sprite,
			centered = centered,
			animations = {},
			quads = {},

			transform = love.math.newTransform(0,0,0,1,1,offsetx,offsety,0,0),
			flipped = vec2(1,1),
			scale = vec2(1,1),

			halfFrameSize = vec2(framewidth/2/meter,frameheight/2/meter),

			frame = vec2(),
			currentAnimation = 0,
			animationPlace = 0,
			delay = 0,
			flag = "",
			loop = false,
			reverse = false,
			pause = false
		})

	for i = offsetx + framewidth, sprite:getWidth(), framewidth do
		self.frame.x = self.frame.x + 1
		self.quads[self.frame.x] = {}

		self.quads[i] = {}
		for j = offsety + frameheight, sprite:getHeight(), frameheight do
			self.frame.y = self.frame.y + 1

			local quad = love.graphics.newQuad( i-framewidth, j-frameheight, framewidth, frameheight, sprite:getDimensions())
			self.quads[self.frame.x][self.frame.y] = quad
		end
		self.frame.y = 0
	end
	self.frame:zero()

	return self
end

--[[
	Creates a completely new animation, that is then stored so it can
	be called as needed.

	"name" should be a string, and is the name of the particular
	animation, such as "run" or "Turn into a banana". This is used for
	finding the right animation you want, so make it intuitive.

	"frames" should be a table of tables, in the format:
	{{frame1x,frame1y,frame1delay,frame1flag},
		{frame2x,frame2y,frame2delay,frame2flag},
		...}
	All x's and y's should be in frames, which then finds the right
	image quad based on the frame size.
	Delay is in seconds, and is only used in "manual" mode.
	Flag is used to check by external sources if the animation is at a
	particular frame, and this variable will be stored under self.flag
	during that frame. Using a string is recommended, but any variable
	will work here.

	"loop" determines what happens when the animation reaches the end.
	 o true or "loop" will cause the animation to begin from frame 1
		after the last frame.
	 o false, "end" or nil will cause the animation to pause upon
	 	reaching the last frame.
	 o "bounce" will cause the animation to reverse direction upon
	 	reaching the last frame.

	"mode" determines the way that the intervals between frames are
	measured, and "variable" determines how that mode functions.
	"mode" should be a string, and can either be:
	 o "fps"	: Every frame has the same interval, which is
	 			determined by "variable", where "variable" is the
	 			number of frames you want per second. Defaults to 30.
	 o "manual"	: Each frame has its own unique delay, stored in
	 			"frames". While using "manual", if no frame delay is
	 			specified, it will be assumed to be 0.03, resulting in
	 			roughly 30fps. "variable" is not needed.
	--
	"mode" will default to 30fps if nothing is specified
--]]
function animator:newAnimation(name,frames,loop,mode,variable)
	if not mode then mode = "fps" end
	if loop == true then loop = "loop" end
	if loop == nil or loop == false then loop = "end" end

	if not name then
		print("ERROR: cannot add animation without name")
		return self
	else
		for i, v in ipairs(self.animations) do
			if v[1] == name then
				print("ERROR: cannot add two animations with the same name: '"..name.."'")
				return self
			end
		end
	end
	if not frames[1] or not frames[1][1] or not frames[1][2] then
		print("ERROR: cannot add animation without frames")
		return self
	end


	if mode == "fps" then
		if not variable then variable = 30 end

		table.insert(self.animations,{name,frames,loop,mode,variable})
		return self
	elseif mode == "manual" then
		table.insert(self.animations,{name,frames,loop,mode})
		return self
	else
		print("ERROR: cannot add animation with mode: '"..mode.."'")
		return self
	end
end

function animator:setAnimation(name,playBackwards,start,loopOverride)
	if loop == true then loop = "loop" end
	if loop == false then loop = "end" end
	for i, v in ipairs(self.animations) do
		if v[1] == name then
			self.currentAnimation = i

			if loopOverride == nil then
				self.loop = self.animations[self.currentAnimation][3]
			else
				self.loop = loopOverride
			end
			self:setFrame(1)
			if start or start == nil then self.pause = false
			else self.pause = true end

			return currentAnimation
		end
	end


	print("ERROR: failed to find the specified animation: '"..name.."'")
	return currentAnimation
end

function animator:setFrame(frameNumber)

	self.animationPlace = frameNumber

	self.flag = self.animations[self.currentAnimation][2][frameNumber][4]

	self.frame:sset(self.animations[self.currentAnimation][2][frameNumber][1],
					self.animations[self.currentAnimation][2][frameNumber][2])

	if self.animations[self.currentAnimation][4] == "fps" then
		self.delay = self.delay + 1/self.animations[self.currentAnimation][5]
	elseif self.animations[self.currentAnimation][4] == "manual" then
		if self.animations[self.currentAnimation][2][frameNumber][3] then
			self.delay = self.delay + self.animations[self.currentAnimation][2][frameNumber][3]
		else
			self.delay = self.delay + 0.03
		end
	else
		self.pause = true
	end
end

function animator:setFlipped(x,y)
	if y == nil then y = x end

	if x == true then self.flipped.x = -1
	else self.flipped.x = 1 end

	if y == true then self.flipped.y = -1
	else self.flipped.y = 1 end
end

function animator:setState(pos)
	local scaleX = 1*self.scale.x*self.flipped.x
	local scaleY = 1*self.scale.x*self.flipped.x
	self.transform:setTransformation(pos.x,pos.y, 0, scaleX, scaleY, 0, 0, 0, 0)
end

--[[
	Draw the current frame at the given location.
	Compatible with vec2 inputs.
--]]
function animator:draw(x,y)
	local drawPos = vec2()
	if x.type == "vec2" then
		drawPos = x:copy()
	else
		drawPos = vec2(x,y)
	end

	if self.centered then
		drawPos:vsubi(self.halfFrameSize)
	end

	drawPos:smuli(meter):roundi()

	self:setState(drawPos)

	love.graphics.draw(self.sprite,
						self.quads[self.frame.x][self.frame.y],
						self.transform)
end

function animator:update(dt)
	if not self.pause then
		self.delay = self.delay - dt

		--If the frame delay has expired...
		if self.delay <= 0 then
			--if the next frame exists, set it to that
			local frameExists = false
			if self.reverse and self.animations[self.currentAnimation][2][self.animationPlace-1] then
				self:setFrame(self.animationPlace-1)
				frameExists = true
			elseif not self.reverse and self.animations[self.currentAnimation][2][self.animationPlace+1] then
				self:setFrame(self.animationPlace+1)
				frameExists = true
			end
			--If not...
			if not frameExists then
				--If we are looping, set the frame to frame 1.
				if self.loop == "loop" then
					self:setFrame(1)

				--If we are bouncing, go the other way.
				elseif self.loop == "bounce" then
					self.reverse = not self.reverse

				--otherwise, stop the animation.
				else
					self.pause = true
				end
			end
		end
	end
end

return animator