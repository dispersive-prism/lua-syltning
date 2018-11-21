-- Class for holding collisionable platforms

Tileset = { x = 0, y = 0}

function Tilset:new(o)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        return o
end

function Tileset:setPosition(x, y)
    self.x = x
    self.y = y
end

return Tileset