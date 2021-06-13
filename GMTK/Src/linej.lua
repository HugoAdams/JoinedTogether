
local linej = class()
linej.type = "linej"

function linej:new(x1,y1,x2,y2)
    self=self:init({p1 = vec2(x1,y1), p2 = vec2(x2,y2)})
    return self
end

return linej