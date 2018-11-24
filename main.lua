-- A Löve2d game including a platform and a mustache

tileset = require("lib.tileset")
thePlayer = require("lib.player")
theWorld = require("lib.world")

tilesize = 50

function love.load()    
    -- Set the window size
    love.window.setMode(tilesize * 10, tilesize * 10)
    
    -- Just init an 2d array acting as our playing field
    table = tileset:init(10,10)
    
    -- Set one row to 1 (for solid blocks)
    for x = 1, 10 do
        table[x][10] = 1
    end
    
    -- Position the player
    thePlayer.x = 250
    thePlayer.y = 100
end
 
function love.update(dt)
    -- Apply gravity to the player
    nextY = thePlayer.y + theWorld.gravity * dt
    nextX = thePlayer.x
    
    -- Check for collisions in the tiles around the player
    tileX = math.floor(thePlayer.x / tilesize)
    tileY = math.floor(thePlayer.y / tilesize)
    
    for i = tileX - 1, tileX + 1 do
        for j = tileY - 1, tileY + 1 do
            if tileX > 0 or tileY > 0 or tileX <= 10 or tileY <= 10 then
                if table[i][j] == 1 then
                    -- Do the collision checking using overlaps
                end
            end
        end
    end
    
        
    thePlayer.y = thePlayer.y + theWorld.gravity * dt
    --thePlayer.x = thePlayer.x + theWorld.gravity * dt
end
 
function love.draw()
    -- Draw the whole grid
    for i = 1, 10 do
        for j = 1, 10 do
            if table[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (i - 1) * tilesize, (j - 1) * tilesize, tilesize, tilesize)
            end
        end
    end
    
    -- Draw the player
    love.graphics.setColor(200 / 255, 100 / 255, 100 / 255)
    love.graphics.rectangle("fill", thePlayer.x - thePlayer.width / 2, thePlayer.y - thePlayer.height / 2, thePlayer.width, thePlayer.height)
    
    -- Which tile is the player currently in?
    tileX = math.floor(thePlayer.x / tilesize)
    tileY = math.floor(thePlayer.y / tilesize)
    
    love.graphics.setColor(1, 1, 1, 0.5)
    
    -- Draw the collision tiles around the player
    for i = -1, 1 do
        for j = -1, 1 do
            love.graphics.rectangle("line", (tileX + i) * tilesize, (tileY + j) * tilesize, tilesize, tilesize)
        end
    end
    
    --print("Tile X: "..tileX.." Tile Y: "..tileY)
    
    
    
end