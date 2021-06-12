local level = class()
function level:new(name,objects)
    self = self.init
    ({
        m_name = name,
        objects = objects
    })
    self:reset()
    return self
end

function level:update(dt)
    for i, ob in objects
    {
        ob.update(dt)
    }

end

function level:draw(dt)
    for i, ob in objects
    {
        ob.draw(dt)
    }
    
end