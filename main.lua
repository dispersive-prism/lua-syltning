-- A Löve2d game including a platform and a mustache

--tileset = require("lib.tileset")
thePlayer = require("lib.player")
theWorld = require("lib.world")
worldMap = require("lib.worldMap")

worldMap.initMap(20, 10)

function love.load()    
    -- Set the window size
    love.window.setMode(worldMap.tileSize * worldMap.drawX, worldMap.tileSize * worldMap.drawY)
        
    -- Set one row to 1 (for solid blocks)
    for x = 1, worldMap.tilesX do
        worldMap.fullMap[x][10] = 1
    end
        
    worldMap.fullMap[10][2] = 1
    worldMap.fullMap[10][3] = 1
    worldMap.fullMap[10][9] = 1
    worldMap.fullMap[10][8] = 1
    worldMap.fullMap[10][7] = 1
    worldMap.fullMap[10][6] = 1
    worldMap.fullMap[10][2] = 1
    worldMap.fullMap[1][2] = 1
    worldMap.fullMap[1][3] = 1
    worldMap.fullMap[6][9] = 1
    worldMap.fullMap[6][8] = 1
    worldMap.fullMap[4][9] = 1
    worldMap.fullMap[6][6] = 1
    worldMap.fullMap[2][8] = 1
    worldMap.fullMap[2][7] = 1
    worldMap.fullMap[3][5] = 1
    worldMap.fullMap[4][5] = 1
    worldMap.fullMap[5][5] = 1
    worldMap.fullMap[1][8] = 1
    
    worldMap.updatePaddedMap()
    
end
 
function love.update(dt)
    -- Set player speed based on keyboard input
    if love.keyboard.isDown('d') then
        worldMap.tilePaddingX = worldMap.tilePaddingX + 1
        print(worldMap.paddingX)
    end
    if love.keyboard.isDown('a') then
        worldMap.tilePaddingX = worldMap.tilePaddingX - 1
        print(worldMap.paddingY)
    end
    if love.keyboard.isDown('w') then
        worldMap.tilePaddingY = worldMap.tilePaddingY - 1
        print(worldMap.paddingX)
    end 
    if love.keyboard.isDown('s') then
        worldMap.tilePaddingY = worldMap.tilePaddingY + 1
        print(worldMap.paddingY)
    end
    
    worldMap.updatePaddedMap()
end
 
function love.draw()
    -- Draw the whole grid
    
    -- This is where we need to figure out which tiles to draw.
    for i = 1, worldMap.drawX do
        for j = 1, worldMap.drawY do
            if worldMap.paddedMap[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (i - 1) * worldMap.tileSize, (j - 1) * worldMap.tileSize, worldMap.tileSize, worldMap.tileSize)
            end
        end
    end
    
    --love.graphics.setColor(1, 0.2, 0)
    --love.graphics.print("Mannby version!", 90, 200, 0, 3)
    
    -- For debugging purposes
    --love.graphics.setColor(0, 1, 0)
    --love.graphics.rectangle("fill", (checkedX - 1) * worldView.tileSize, (checkedY - 1) * worldView.tileSize, worldView.tileSize, worldView.tileSize)
    
    -- Draw the player
    -- love.graphics.setColor(200 / 255, 100 / 255, 100 / 255)
    -- love.graphics.rectangle("fill", thePlayer.x - thePlayer.width / 2 - worldView.pixelPaddingX - worldView.tilePaddingX * worldView.tileSize, thePlayer.y - thePlayer.height / 2, thePlayer.width, thePlayer.height)
    
    -- Which tile is the player currently in?
    --tileX = math.floor(thePlayer.x / worldView.tileSize)
    --tileY = math.floor(thePlayer.y / worldView.tileSize)
    
    -- Debugging 
    --[[love.graphics.setColor(1, 1, 1, 0.5)
    
    -- Draw the collision tiles around the player
    for i = -1, 1 do
        for j = -1, 1 do
            love.graphics.rectangle("line", (tileX + i) * worldView.tileSize, (tileY + j) * worldView.tileSize, worldView.tileSize, worldView.tileSize)
        end
    end   
    --]]
end