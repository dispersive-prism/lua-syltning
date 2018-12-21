-- A Löve2d game including a platform and a mustache.. not yet..

thePlayer = require("lib.player")
theWorld = require("lib.world")
worldMap = require("lib.worldMap")
Background = require("lib.background")

worldMap.initMap(30, 10)

function love.load()    
    -- Set the window size
    love.window.setMode(worldMap.tileSize * worldMap.drawX, worldMap.tileSize * worldMap.drawY)
    
    -- Initialize the background
    background = Background:new()
    background:initBackground(4, 4)
    
    -- Set some tiles to 1
    background.background[1][1] = 1
    background.background[2][2] = 1
    background.background[3][3] = 1
    background.background[4][4] = 1
    
    background:initRepeatedBackground(2, worldMap.tileSize, worldMap.drawX, worldMap.drawY, 4)
    --background.shiftY(-5)
    
    bgClose = Background:new()
    bgClose:initBackground(2, 20)
    
    bgClose.background[1][9] = 1
    bgClose.background[1][10] = 1
    bgClose.background[1][11] = 1
    bgClose.background[1][12] = 1
    bgClose.background[1][13] = 1
    bgClose.background[1][14] = 1
    bgClose.background[1][15] = 1
    bgClose.background[1][16] = 1
    bgClose.background[1][17] = 1
    bgClose.background[1][18] = 1
    bgClose.background[1][19] = 1
    bgClose.background[1][20] = 1
    bgClose.background[1][9] = 1

    bgClose.background[2][11] = 1
    bgClose.background[2][13] = 1
    bgClose.background[2][15] = 1
    bgClose.background[2][17] = 1
    bgClose.background[2][19] = 1
    bgClose.background[2][20] = 1

    bgClose:initRepeatedBackground(1.5, worldMap.tileSize, worldMap.drawX, worldMap.drawY, (1.5 / 2) * 4)
    
    
    thePlayer.xPosition = 100
    thePlayer.yPosition = 100
        
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
    if love.keyboard.isDown('left') then
       background:shiftX(1) 
    end
    if love.keyboard.isDown('up') then
        background:shiftY(1)
    end
    
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
            thePlayer.xSpeed = thePlayer.xSpeed - theWorld.drag * dt
        end
    end
    if love.keyboard.isDown('g') then
        thePlayer.xPosition = 200
        thePlayer.yPosition = 100
        thePlayer.ySpeed = 0
        thePlayer.xSpeed = 0
    end
    
    -- Calculate relative delta x and relative delta y and update the padding depending on this
    playerRelativeXPos = (thePlayer.xPosition - thePlayer.width / 2) + worldMap.pixelPaddingX - worldMap.tilePaddingX * worldMap.tileSize
    playerRelativeYPos = (thePlayer.yPosition - thePlayer.width / 2) + worldMap.pixelPaddingY - worldMap.tilePaddingY * worldMap.tileSize
        
    middleX = (worldMap.drawX / 2) * worldMap.tileSize
    middleY = (worldMap.drawY / 2) * worldMap.tileSize
    
    playerDeltaX = playerRelativeXPos - middleX
    playerDeltaY = playerRelativeYPos - middleY
    
    --print("PDX: "..playerDeltaX..", PDY: "..playerDeltaY)
    -- The delta sets pixelPadding
    -- Pixelpadding sets tilePadding
    -- 

    if playerDeltaX > theWorld.allowedXDelta and (worldMap.tilePaddingX < worldMap.tilesX - worldMap.drawX or worldMap.pixelPaddingX > 0) then
        worldMap.pixelPaddingX = worldMap.pixelPaddingX - (playerDeltaX * theWorld.scrollSpeedX * dt)
        background.xPadding = background.xPadding - (playerDeltaX * theWorld.scrollSpeedY * dt) * (1 / background.zDistance)
        bgClose.xPadding = bgClose.xPadding - (playerDeltaX * theWorld.scrollSpeedY * dt) * (1 / bgClose.zDistance)
        -- added after and
        if math.abs(worldMap.pixelPaddingX) >= worldMap.tileSize then
            worldMap.pixelPaddingX = 0
            worldMap.tilePaddingX = worldMap.tilePaddingX + 1
            --print("X pad: "..worldMap.tilePaddingX)
        end
        if math.abs(background.xPadding) >= background.tileSize then
            background.xPadding = 0
            background:shiftX(-1)
        end
        if math.abs(bgClose.xPadding) >= bgClose.tileSize then
            bgClose.xPadding = 0
            bgClose:shiftX(-1)
        end        
    end

    if playerDeltaX < -theWorld.allowedXDelta and (worldMap.tilePaddingX - 1 > -1 or worldMap.pixelPaddingX < 0) then
        worldMap.pixelPaddingX = worldMap.pixelPaddingX - (playerDeltaX * theWorld.scrollSpeedX * dt)
        background.xPadding = background.xPadding - (playerDeltaX * theWorld.scrollSpeedX * dt) * (1 / background.zDistance)
        bgClose.xPadding = bgClose.xPadding - (playerDeltaX * theWorld.scrollSpeedX * dt) * (1 / bgClose.zDistance)
        if math.abs(worldMap.pixelPaddingX) >= worldMap.tileSize then
            worldMap.pixelPaddingX = 0
            worldMap.tilePaddingX = worldMap.tilePaddingX - 1
            --print("X pad: "..worldMap.tilePaddingX)
        end
        if math.abs(background.xPadding) >= background.tileSize then
            background.xPadding = 0
            background:shiftX(1)
        end
        if math.abs(bgClose.xPadding) >= bgClose.tileSize then
            bgClose.xPadding = 0
            bgClose:shiftX(1)
        end        
    end 
        
    if playerDeltaY > theWorld.allowedYDelta and (worldMap.tilePaddingY < worldMap.tilesY - worldMap.drawY or worldMap.pixelPaddingY > 0) then
        worldMap.pixelPaddingY = worldMap.pixelPaddingY - (playerDeltaY * theWorld.scrollSpeedY * dt)
        background.yPadding = background.yPadding - (playerDeltaY * theWorld.scrollSpeedY * dt) * (1 / background.zDistance)
        bgClose.yPadding = bgClose.yPadding - (playerDeltaY * theWorld.scrollSpeedY * dt) * (1 / bgClose.zDistance)
        if math.abs(worldMap.pixelPaddingY) >= worldMap.tileSize then
            worldMap.tilePaddingY = worldMap.tilePaddingY + 1
            worldMap.pixelPaddingY = 0
            --print("Y pad:"..worldMap.tilePaddingY)
        end
        if math.abs(background.yPadding) >= background.tileSize then
            background.yPadding = 0
            background:shiftY(1)
        end
        if math.abs(bgClose.yPadding) >= bgClose.tileSize then
            bgClose.yPadding = 0
            bgClose:shiftY(1)
        end        
    end
    
    if playerDeltaY < -theWorld.allowedYDelta and (worldMap.tilePaddingY - 1 > -1 or worldMap.pixelPaddingY < 0) then
        worldMap.pixelPaddingY = worldMap.pixelPaddingY - (playerDeltaY * theWorld.scrollSpeedY * dt)
        background.yPadding = background.yPadding - (playerDeltaY * theWorld.scrollSpeedY * dt) * (1 / background.zDistance)
        if math.abs(worldMap.pixelPaddingY) >= worldMap.tileSize then
            worldMap.tilePaddingY = worldMap.tilePaddingY - 1
            worldMap.pixelPaddingY = 0
            --print("Y pad:"..worldMap.tilePaddingY)
        end
        if math.abs(background.yPadding) >= background.tileSize then
            background.yPadding = 0
            background:shiftY(-1)
        end
    end
    
    -- Apply gravity to the player
    thePlayer.ySpeed = thePlayer.ySpeed - theWorld.gravity

    if thePlayer.ySpeed > thePlayer.maxFallSpeed then
        thePlayer.ySpeed = thePlayer.maxFallSpeed
    end
    
    nextX = thePlayer.xPosition + thePlayer.xSpeed * dt
    nextY = thePlayer.yPosition + thePlayer.ySpeed * dt
    
    
    -- Check for collisions in the tiles around the player
    tileX = math.floor(nextX / worldMap.tileSize) + 1
    tileY = math.floor(nextY / worldMap.tileSize) + 1
    
    px = nextX - thePlayer.width / 2
    py = nextY - thePlayer.height / 2
    pw = px + thePlayer.width
    ph = py + thePlayer.height    
    
    -- Check all the tiles surrounding the player
    for ctX = tileX - 1, tileX + 1 do
        for ctY = tileY - 1, tileY + 1 do
            if ctX >= 0 and ctX <= worldMap.tilesX + 1 and ctY >= 0 and ctY <= worldMap.tilesY + 1 and worldMap.fullMap[ctX][ctY] == 1 then
                x = (ctX - 1) * worldMap.tileSize
                y = (ctY - 1) * worldMap.tileSize
                w = worldMap.tileSize + x
                h = worldMap.tileSize + y
                
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
                        if worldMap.fullMap[tileX][tileY - 1] == 0 and worldMap.fullMap[tileX - 1][tileY] == 0 then
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
                        if worldMap.fullMap[tileX][tileY - 1] == 0 and worldMap.fullMap[tileX + 1][tileY] == 0 then
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
                        if worldMap.fullMap[tileX+1][tileY] == 1 then
                            --thePlayer.ySpeed = 0
                            --thePlayer.airborne = 0
                            nextY = y - thePlayer.height / 2
                        end
                        checkedX = tileX
                        checkedY = tileY + 1
                        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX - 1][tileY] == 0 and thePlayer.ySpeed > 0 then
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
                        if worldMap.fullMap[tileX - 1][tileY] == 1 then
                            --thePlayer.ySpeed = 0
                            --nextY = y - thePlayer.height / 2
                        end
                        -- Check if we're at a cliff side
                        --checkedX = tileX
                        --checkedY = tileY + 1
                        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX + 1][tileY] == 0 and thePlayer.ySpeed > 0 then
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
    
    thePlayer.xPosition = nextX
    thePlayer.yPosition = nextY
    worldMap.updatePaddedMap()   
end
 
function love.draw()
    -- Draw the background
    for i = 0, background.tilesX + 1 do
        for j = 0, background.tilesY + 1 do
            if background.repeatedBackground[i][j] == 1 then
                love.graphics.setColor(1, 0.5, 1, 0.1)
                love.graphics.rectangle("fill", (i - 1) * background.tileSize + background.xPadding, (j - 1) * background.tileSize, background.tileSize, background.tileSize)
            end
        end
    end
    
    for i = 0, bgClose.tilesX + 1 do
        for j = 0, bgClose.tilesY + 1 do
            if bgClose.repeatedBackground[i][j] == 1 then
                love.graphics.setColor(0.3, 0.2, 0.3, 0.9)
                love.graphics.rectangle("fill", (i - 1) * bgClose.tileSize + bgClose.xPadding, (j - 1) * bgClose.tileSize, bgClose.tileSize, bgClose.tileSize)
            end
        end
    end
    
    -- Draw the whole grid
    
    -- This is where we need to figure out which tiles to draw. Notice that we're starting from inded 0 (which is one tile outside the screen)
    -- to cope with pixel padding. We're also drawing drawX/drawY + 1 for the same reasons. paddedMap is initiated to be +2 in x, y
    for i = 0, worldMap.drawX + 1 do
        for j = 0, worldMap.drawY + 1 do
            if worldMap.paddedMap[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (i - 1) * worldMap.tileSize + worldMap.pixelPaddingX,
                    (j - 1) * worldMap.tileSize + worldMap.pixelPaddingY, worldMap.tileSize, worldMap.tileSize)
            end
        end
    end
    
    -- Debug
    --[[love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, 220, 220)
    for i = 0, background.tilesX + 1 do
        for j = 0, background.tilesY + 1 do
            if background.repeatedBackground[i][j] == 1 then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle("fill", i * 10, j * 10, 10, 10)
            end
        end
    end]]--
    
    
    --love.graphics.setColor(1, 0.2, 0)
    --love.graphics.print("Mannby version!", 90, 200, 0, 3)
    
    -- For debugging purposes
    --love.graphics.setColor(0, 1, 0)
    --love.graphics.rectangle("fill", (checkedX - 1) * worldView.tileSize, (checkedY - 1) * worldView.tileSize, worldView.tileSize, worldView.tileSize)
    
    -- Draw the player
    love.graphics.setColor(200 / 255, 100 / 255, 100 / 255)
    playerRelativeXPos = thePlayer.xPosition - thePlayer.width / 2 + worldMap.pixelPaddingX - worldMap.tilePaddingX * worldMap.tileSize
    playerRelativeYPos = thePlayer.yPosition - thePlayer.height / 2 + worldMap.pixelPaddingY - worldMap.tilePaddingY * worldMap.tileSize
    
    
    love.graphics.rectangle("fill", playerRelativeXPos, playerRelativeYPos, thePlayer.width, thePlayer.height)
    
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