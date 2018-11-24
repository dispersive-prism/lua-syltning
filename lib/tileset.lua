-- Class for holding collisionable platforms
Tileset = {}

function Tileset:init(x, y)
        o = {}
        for i = 1, x do
            o[i] = {}
            for j = 1, y do
                o[i][j] = 0
            end
        end
        return o
end

return Tileset
