-- Class for holding collisionable platforms
Tileset = {}

function Tileset:init(x, y)
        o = {}
        for i = -1, x + 1 do
            o[i] = {}
            for j = -1, y + 1 do
                o[i][j] = 0
            end
        end
        return o
end

return Tileset
