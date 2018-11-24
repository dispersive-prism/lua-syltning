-- A Löve2d game including a platform and a mustache

tileset = require("lib.tileset")

tilesize = 50

function love.load()
    -- Just init an 2d array
    table = tileset:init(10,10)
    
    -- Set one row to 1 (for solid blocks)
    for x = 1, 10 do
        table[x][10] = 1
    end
    
    -- Set the window size
    love.window.setMode(tilesize * 10, tilesize * 10)
end
 
function love.update(dt)
end
 
function love.draw()
    for i = 1, 10 do
        for j = 1, 10 do
            if table[i][j] == 1 then 
                love.graphics.rectangle("fill", (i - 1) * tilesize, (j - 1) * tilesize, tilesize, tilesize)
            end
        end
    end
end