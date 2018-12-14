-- A Löve2d game including a platform and a mustache

tileset = require("lib.tileset")
thePlayer = require("lib.player")
theWorld = require("lib.world")
worldView = require("lib.worldview")

worldView.setViewSize(20, 10)
--tilesize = worldView.tileSize

function love.load()    
    -- Set the window size
    love.window.setMode(worldView.tileSize * worldView.drawX, worldView.tileSize * worldView.drawY)
    
    -- Just init an 2d array acting as our playing field
    table = tileset:init(worldView.tilesX, worldView.tilesY)
    
    -- Set one row to 1 (for solid blocks)
    for x = 1, worldView.tilesX do
        table[x][10] = 1
    end
    
    table[10][2] = 1
    table[10][3] = 1
    table[10][9] = 1
    table[10][8] = 1
    table[10][7] = 1
    table[10][6] = 1
    table[10][2] = 1
    table[1][2] = 1
    table[1][3] = 1
    table[6][9] = 1
    table[6][8] = 1
    table[4][9] = 1
    table[6][6] = 1
    table[2][8] = 1
    table[2][7] = 1
    table[3][5] = 1
    table[4][5] = 1
    table[5][5] = 1
    table[1][8] = 1
    
    -- Position the player
    thePlayer.x = 230
    thePlayer.y = 100
    
    checkedX = -1
    checkedY = -1
end
 
function love.update(dt)
    -- Set player speed based on keyboard input
    if love.keyboard.isDown('d') then
        if math.abs(thePlayer.xSpeed) < thePlayer.runSpeed then
            thePlayer.xSpeed = thePlayer.xSpeed + thePlayer.acceleration * dt
        end
        if thePlayer.xSpeed > thePlayer.runSpeed then
            thePlayer.xSpeed = thePlayer.runSpeed
        end
        -- Apply drag if we're running in the opposite direciton
        if thePlayer.xSpeed < 0 then
            thePlayer.xSpeed = thePlayer.xSpeed + theWorld.drag * dt
        end
    end
    if love.keyboard.isDown('a') then
        if math.abs(thePlayer.xSpeed) < thePlayer.runSpeed then
            thePlayer.xSpeed = thePlayer.xSpeed - thePlayer.acceleration * dt
        end
        if -thePlayer.xSpeed > thePlayer.runSpeed then
            thePlayer.xSpeed = -thePlayer.runSpeed
        end
        -- Apply drag if we're running in the opposite direction to the key
        if thePlayer.xSpeed > 0 then
            thePlayer.xSpeed = thePlayer.xSpeed - theWorld.drag * dt
        end
    end
    if love.keyboard.isDown('w') then
        if thePlayer.lastJumpTime == 0 then
                thePlayer.lastJumpTime = love.timer.getTime()
        end
        if love.timer.getTime() - thePlayer.lastJumpTime >= thePlayer.allowJumpAfter and thePlayer.lastGrounded ~= 0 
            and love.timer.getTime() - thePlayer.lastGrounded <= thePlayer.groundedDelay then        
            thePlayer.ySpeed = thePlayer.jumpHeight
            thePlayer.lastJumpTime = love.timer.getTime()
            thePlayer.lastGrounded = 0
        end
    end
    if not love.keyboard.isDown('w') then
       thePlayer.lastJumpTime = love.timer.getTime()
       -- Nothing
    end
    if not love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
        -- Apply drag to the player
        if thePlayer.xSpeed > 0 then
            thePlayer.xSpeed = thePlayer.xSpeed - theWorld.drag * dt
            if thePlayer.xSpeed < 0 then
                thePlayer.xSpeed = 0
            end
        elseif thePlayer.xSpeed > 0 then
            thePlayer.xSpeed = thePlayer.xSpeed + theWorld.drag * dt
        end
        
    end
    if not love.keyboard.isDown('a') and not love.keyboard.isDown('w') then
        if thePlayer.xSpeed < 0 then
            thePlayer.xSpeed = thePlayer.xSpeed + theWorld.drag * dt
            if thePlayer.xSpeed > 0 then
                thePlayer.xSpeed = 0
            end
        elseif thePlayer.xSpeed < 0 then
            thePLayer.xSpeed = thePlayer.xSpeed - theWorld.drag * dt
        end
    end
    if love.keyboard.isDown('g') then
        thePlayer.x = 200
        thePlayer.y = -100
        thePlayer.ySpeed = 0
        thePlayer.xSpeed = 0
    end
    
    -- Apply force to the player
    --if thePlayer.ySpeed >= 0 and thePlayer.ySpeed <= thePlayer.maxFallSpeed then
        thePlayer.ySpeed = thePlayer.ySpeed - theWorld.gravity
        --print(thePlayer.ySpeed)
        if thePlayer.ySpeed > thePlayer.maxFallSpeed then
            thePlayer.ySpeed = thePlayer.maxFallSpeed
        end
    --end

    
    -- Apply gravity to the player
    nextY = math.floor(thePlayer.y + thePlayer.ySpeed * dt)
    nextX = math.floor(thePlayer.x + thePlayer.xSpeed * dt)
    
    -- Check for collisions in the tiles around the player
    tileX = math.floor(nextX / worldView.tileSize) + 1
    tileY = math.floor(nextY / worldView.tileSize) + 1
    
    -- Always set the player to airborne and explicitly determine whether it should be set to 0
    -- thePlayer.airborne = 1
    
    px = nextX - thePlayer.width / 2
    py = nextY - thePlayer.height / 2
    pw = px + thePlayer.width
    ph = py + thePlayer.height    
    
    -- Check all the tiles surrounding the player
    for ctX = tileX - 1, tileX + 1 do
        for ctY = tileY - 1, tileY + 1 do
            if ctX > 0 and ctX <= worldView.tilesX and ctY > 0 and ctY <= worldView.tilesY and table[ctX][ctY] == 1 then
                x = (ctX - 1) * worldView.tileSize
                y = (ctY - 1) * worldView.tileSize
                w = worldView.tileSize + x
                h = worldView.tileSize + y
                
                if (pw > x and pw < w and py > y and py < h) or
                   (pw > x and pw < w and ph > y and ph < h) or
                   (pw > x and pw < w and py > y and py < h) or
                   (px > x and pw < w and ph > y and ph < h) or
                   (px > x and pw < w and py > y and ph < h) or
                   (px > x and pw < w and py > y and py < h) or
                   (px > x and px < w and ph > y and ph < h) or
                   (px > x and px < w and py > y and ph < h) or
                   (px > x and px < w and py > y and py < h) then

                    -- Figure out which side that collided
                    if ctX < tileX and ctY < tileY then
                        -- Upper left. Cancel any ySpeed and reset the player
                        --print("Upper left")
                        if thePlayer.xSpeed < 0 then
                            thePlayer.xSpeed = 0
                            nextX = w + thePlayer.width / 2
                        end
                        if table[tileX][tileY - 1] == 0 and table[tileX - 1][tileY] == 0 then
                            -- We're facing the scenario where were jumping head first into a corner
                            if thePlayer.ySpeed < 0 then
                                thePlayer.ySpeed = 0
                                nextY = h + thePlayer.height / 2
                            end
                        end    
                    end
                    if ctX == tileX and ctY < tileY then
                        -- Upper middle. Cancel any ySpeed and reset the player
                        --print("Upper middle")
                        if thePlayer.ySpeed < 0 then
                            thePlayer.ySpeed = 0
                            nextY = h + thePlayer.height / 2    
                        end
                    end
                    if ctX > tileX and ctY < tileY then
                        -- Upper right. Cancel any negative ySpeed (player jumping) and reset the player
                        --print("Upper right")
                        if thePlayer.xSpeed > 0 then
                            thePlayer.xSpeed = 0
                            nextX = x - thePlayer.width / 2
                        end
                        if table[tileX][tileY - 1] == 0 and table[tileX + 1][tileY] == 0 then
                            if thePlayer.ySpeed < 0 then
                                thePlayer.ySpeed = 0
                                nextY = h + thePlayer.height / 2
                            end
                        end
                    end
                    if ctX < tileX and ctY == tileY then
                        -- Middle left. Cancel any xSpeed and reset the player
                        --print("Middle left")
                        thePlayer.xSpeed = 0
                        nextX = w + thePlayer.width / 2        
                    end
                    if ctX == tileX and ctY == tileY then
                        --print("Middle")
                        -- Middle. This is a tricky situation. Clipping through
                        if thePlayer.ySpeed > 0 then
                            thePlayer.ySpeed = 0
                            nextY = y - thePlayer.height / 2
                        end
                        if thePlayer.ySpeed < 0 then
                            thePlayer.ySpeed = 0
                            nextY = h - thePlayer.height / 2
                        end
                        if thePlayer.xSpeed > 0 then
                            thePlayer.xSpeed = 0
                            nextX = x - thePlayer.width / 2
                        end
                        if thePlayer.xSpeed < 0 then
                            thePlayer.xSpeed = 0
                            nextX = w + thePlayer.width / 2
                        end
                    end
                    if ctX > tileX and ctY == tileY then
                        -- Middle right.
                        --print("Middle right")
                        thePlayer.xSpeed = 0
                        nextX = x - thePlayer.width / 2
                    end
                    if ctX < tileX and ctY > tileY then
                        --print("Lower left")
                        if table[tileX+1][tileY] == 1 then
                            thePlayer.ySpeed = 0
                            thePlayer.airborne = 0
                            nextY = y - thePlayer.height / 2
                        end
                        checkedX = tileX
                        checkedY = tileY + 1
                        if table[tileX][tileY + 1] == 0 and table[tileX - 1][tileY] == 0 and thePlayer.ySpeed >= 0 then
                            if px < w then
                                thePlayer.lastGrounded = love.timer.getTime()
                                thePlayer.ySpeed = 0
                                nextY = y - thePlayer.height / 2
                            end
                        end
                    end
                    if ctX == tileX and ctY > tileY then
                        -- Lower middle.
                        --print("Lower middle")
                        thePlayer.ySpeed = 0
                        nextY = y - thePlayer.height / 2
                        -- Also set the lastGrounded
                        thePlayer.lastGrounded = love.timer.getTime()
                    end
                    if ctX > tileX and ctY > tileY then
                        --print("Lower right ")
                        if table[tileX - 1][tileY] == 1 then
                            thePlayer.ySpeed = 0
                            nextY = y - thePlayer.height / 2
                        end
                        -- Check if we're at a cliff side
                        --checkedX = tileX
                        --checkedY = tileY + 1
                        if table[tileX][tileY + 1] == 0 and table[tileX + 1][tileY] == 0 and thePlayer.ySpeed >= 0 then
                            -- Are we still grounded in terms of x? Do we have a foot on the ground
                            if pw > x then
                                thePlayer.lastGrounded = love.timer.getTime()
                                thePlayer.ySpeed = 0
                                nextY = y - thePlayer.height / 2
                            end
                        end
                    end
                end
            end
        end
    end
    
    thePlayer.x = nextX
    thePlayer.y = nextY
    
    -- Update the padding parameters
    
    -- If the player is outside the scrollWindow, update padding depending on position (and whether there is more to show)

    --[[
   tilePaddingX = 0, -- How many xTiles to pad in the world
    tilePaddingY = 0, -- How many yTiles ot pad in the world
    pixelPaddingX = 0, -- How many x pixels to pad in the world (should never be more than world.tileSize)
    pixelPaddingY = 0, -- How many y pixels to pad in the world (should never be more than world.tileSize)    
    
    scrollWindowX = 0,
    scrollWindowY = 0,
    scrollWindowW = 0,
    scrollWindowH = 0
    
    ]]--
    
    if thePlayer.x < worldView.scrollWindowX then
        -- Just make sure that we have initialized something in the tilset for this tile
        if(worldView.pixelPaddingX - 1 >= 0) then
            -- Calculate how far out the player is
            offDistance = thePlayer.x - worldView.scrollWindowX
            worldView.pixelPaddingX = worldView.pixelPaddingX - offDistance * dt
            if worldView.pixelPaddingX >= worldView.tileSize then
                -- We have now padded a whole tile, update the tilePadding instead and reset the pixelPadding
                worldView.pixelPaddingX = 0
                worldView.tilePaddingX = worldView.tilePaddingX + 1
            end
        end
    end
    if thePlayer.x > worldView.scrollWindowW then
        print((worldView.pixelPaddingX + 1).." <= "..worldView.tilesX)
        if(worldView.pixelPaddingX + 1 <= worldView.tilesX) then
            -- Calculate how far out the player is
            offDistance = thePlayer.x + worldView.scrollWindowW
            worldView.pixelPaddingX = worldView.pixelPaddingX + offDistance * dt
            print(worldView.pixelPaddingX)
            if worldView.pixelPaddingX >= worldView.tileSize then
                -- We have now padded a whole tile, update the tilePadding instead and reset the pixelPadding
                worldView.pixelPaddingX = 0
                worldView.tilePaddingX = worldView.tilePaddingX - 1
            end
        end
    end
    
end
 
function love.draw()
    -- Draw the whole grid
    
    -- This is where we need to figure out which tiles to draw.
    
    for i = worldView.tilePaddingX + 1, worldView.drawX + worldView.tilePaddingX do
        for j = worldView.tilePaddingY + 1, worldView.drawY + worldView.tilePaddingY do
            if table[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (i - 1) * worldView.tileSize + worldView.pixelPaddingX, (j - 1) * worldView.tileSize, worldView.tileSize, worldView.tileSize)
            end
        end
    end
    
    --love.graphics.setColor(1, 0.2, 0)
    --love.graphics.print("Mannby version!", 90, 200, 0, 3)
    
    -- For debugging purposes
    --love.graphics.setColor(0, 1, 0)
    --love.graphics.rectangle("fill", (checkedX - 1) * worldView.tileSize, (checkedY - 1) * worldView.tileSize, worldView.tileSize, worldView.tileSize)
    
    -- Draw the player
    love.graphics.setColor(200 / 255, 100 / 255, 100 / 255)
    love.graphics.rectangle("fill", thePlayer.x - thePlayer.width / 2, thePlayer.y - thePlayer.height / 2, thePlayer.width, thePlayer.height)
    
    -- Which tile is the player currently in?
    tileX = math.floor(thePlayer.x / worldView.tileSize)
    tileY = math.floor(thePlayer.y / worldView.tileSize)
    
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