-- A Löve2d game including a platform and a mustache.. not yet..
require("lib.collision")

thePlayer = require("lib.player")
theWorld = require("lib.world")
worldMap = require("lib.worldmap")
Background = require("lib.background")

worldMap.initMap(30, 10)
worldMap.drawX = 10
worldMap.drawY = 10

function love.load()    
    -- Set the window size
    love.window.setMode(worldMap.tileSize * worldMap.drawX, worldMap.tileSize * worldMap.drawY)
    
    -- Initialize the background
    background = Background:new()
    background:initBackground(4, 4)
    background:setColor({1, 0.5, 1, 0.1})
    
    -- Set some tiles to 1
    background.background[1][1] = 1
    background.background[2][2] = 1
    background.background[3][3] = 1
    background.background[4][4] = 1
    
    background:initRepeatedBackground(2, worldMap.tileSize, worldMap.drawX, worldMap.drawY, 4)
    --background:shiftY(-1)
    
    bgClose = Background:new()
    bgClose:initBackground(2, 20)
    bgClose:setColor({1, 0.7, 1, 0.2})
    
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
    
    worldMap.addBackground(background)
    worldMap.addBackground(bgClose)
    
    
    thePlayer.xPosition = 100
    thePlayer.yPosition = 100
        
    -- Set one row to 1 (for solid blocks)
    for x = 1, worldMap.tilesX do
        worldMap.fullMap[x][10] = 1
    end
        
    worldMap.fullMap[10][2] = 1
    worldMap.fullMap[10][9] = 1
    worldMap.fullMap[10][8] = 1
    worldMap.fullMap[10][7] = 1
    worldMap.fullMap[10][6] = 1
    worldMap.fullMap[1][2] = 1
    worldMap.fullMap[1][3] = 1
    worldMap.fullMap[6][9] = 1
    worldMap.fullMap[6][8] = 1
    worldMap.fullMap[6][6] = 1
    worldMap.fullMap[6][4] = 2
    worldMap.fullMap[7][4] = 2
    worldMap.fullMap[8][4] = 2
    worldMap.fullMap[9][4] = 2
    worldMap.fullMap[4][9] = 1
    worldMap.fullMap[2][8] = 1
    worldMap.fullMap[2][7] = 1
    worldMap.fullMap[3][5] = 1
    worldMap.fullMap[4][5] = 1
    worldMap.fullMap[5][5] = 1
    worldMap.fullMap[1][8] = 1
    worldMap.fullMap[11][9] = 3
    worldMap.fullMap[11][8] = 3
    worldMap.fullMap[11][7] = 3
    worldMap.fullMap[11][6] = 3
    
    
    worldMap.updatePaddedMap()
    
end
 
function love.update(dt)   
    if love.keyboard.isDown('left') then
       background:shiftX(1) 
    end
    if love.keyboard.isDown('right') then
        background:shiftX(-1)
    end
    if love.keyboard.isDown('up') then
        background:shiftY(1)
    end
    if love.keyboard.isDown('down') then
        background:shiftY(-1)
    end
    
    -- Set player speed based on keyboard input
    if love.keyboard.isDown('d') then
        moveLeft(thePlayer, dt)
    end
    if love.keyboard.isDown('a') then
        moveRight(thePlayer, dt)
    end
    if love.keyboard.isDown('space') then
        if(thePlayer.crouching) then
            thePlayer.dropDown = true
        else
            jumpAction(thePlayer, dt)
        end
    end
    if love.keyboard.isDown('w') then
        upAction(thePlayer, dt)
    end
    if love.keyboard.isDown('s') then
        downAction(thePlayer, dt)    
    end
    
    if not love.keyboard.isDown('w') then
        thePlayer.graspingUp = false
        thePlayer.climbingUp = false
    end
    if not love.keyboard.isDown('space') then
        thePlayer.crouching = false
        thePlayer.lastJumpTime = love.timer.getTime()
       -- Nothing
    end
    if not love.keyboard.isDown('s') then
        thePlayer.graspingDown = false
        thePlayer.climbingDown = false
    end
    if not love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
        -- Apply drag to the player
        applyDrag(thePlayer, dt)
    end
    if love.keyboard.isDown('g') then
        resetPlayer(thePlayer)
    end
    
    updatePadding(thePlayer, worldMap, backgrounds, theWorld, dt)
    
    -- Apply gravity to the player (unless he/she is climbing)
    if love.timer.getTime() - thePlayer.lastClimbTime > thePlayer.allowAirClimbFor then
        thePlayer.ySpeed = thePlayer.ySpeed - theWorld.gravity * dt

        -- Cap the fall speed
        if thePlayer.ySpeed > thePlayer.maxFallSpeed then
            thePlayer.ySpeed = thePlayer.maxFallSpeed
        end
    elseif thePlayer.climbingUp then
        thePlayer.ySpeed = thePlayer.ySpeed - thePlayer.climbAcceleration * dt
        if thePlayer.ySpeed < -thePlayer.maxClimbSpeed then
            thePlayer.ySpeed = -thePlayer.maxClimbSpeed
        end
    elseif thePlayer.climbingDown then
        thePlayer.ySpeed = thePlayer.ySpeed + thePlayer.climbAcceleration * dt
        if thePlayer.ySpeed > thePlayer.maxClimbSpeed then
            thePlayer.ySpeed = thePlayer.maxClimbSpeed    
        end
    else
        -- Apply some drag to the player
        applyClimbDrag(thePlayer, dt)
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
            if ctX >= 0 and ctX <= worldMap.tilesX + 1 and ctY >= 0 and ctY <= worldMap.tilesY + 1 then
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
                    processCollision(ctX, ctY, tileX, tileY, thePlayer, worldMap)
                end
            end
        end
    end
    
    thePlayer.xPosition = nextX
    thePlayer.yPosition = nextY
    worldMap.updatePaddedMap()   
end
 
function love.draw()
    -- Draw the backgrounds (if any)
    for bgId = 1, #worldMap.backgrounds do
        thisBg = worldMap.backgrounds[bgId]
        for i = 0, thisBg.tilesX + 1 do
            for j = 0, thisBg.tilesY + 1 do
                if thisBg.repeatedBackground[i][j] == 1 then
                    love.graphics.setColor(thisBg.color)
                    --love.graphics.setColor(1, 0.5, 1, 0.1)
                    love.graphics.rectangle("fill", (i - 1) * thisBg.tileSize + thisBg.xPadding, (j - 1) * thisBg.tileSize + thisBg.yPadding, thisBg.tileSize, thisBg.tileSize)
                end
            end
        end
    end
        
    -- Draw the whole map
    for i = 0, worldMap.drawX + 1 do
        for j = 0, worldMap.drawY + 1 do
            if worldMap.paddedMap[i][j] == 1 then
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", (i - 1) * worldMap.tileSize + worldMap.pixelPaddingX,
                    (j - 1) * worldMap.tileSize + worldMap.pixelPaddingY, worldMap.tileSize, worldMap.tileSize)
            elseif worldMap.paddedMap[i][j] == 2 then
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", (i - 1) * worldMap.tileSize + worldMap.pixelPaddingX,
                    (j - 1) * worldMap.tileSize + worldMap.pixelPaddingY, worldMap.tileSize, worldMap.tileSize)
            elseif worldMap.paddedMap[i][j] == 3 then
                love.graphics.setColor(1, 0, 1, 0.5)
                love.graphics.rectangle("fill", (i - 1) * worldMap.tileSize + worldMap.pixelPaddingX,
                    (j - 1) * worldMap.tileSize + worldMap.pixelPaddingY, worldMap.tileSize, worldMap.tileSize)                
            end
        end
    end
    
    -- Debug
    --[[
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, 220, 220)
    for i = 0, background.tilesX + 1 do
        for j = 0, background.tilesY + 1 do
            if background.repeatedBackground[i][j] == 1 then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle("fill", i * 10, j * 10, 10, 10)
            end
        end
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0, 0, 220, 220)
    for i = 0, bgClose.tilesX + 1 do
        for j = 0, bgClose.tilesY + 1 do
            if bgClose.repeatedBackground[i][j] == 1 then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle("fill", i * 10 + 250, j * 10, 10, 10)
            end
        end
    end   --]]
    
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

function moveLeft(thePlayer, dt)
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

function moveRight(thePlayer, dt)
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

function jumpAction(thePlayer, dt)
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

function upAction(thePlayer, dt)
    thePlayer.graspingUp = true
end

function downAction(thePlayer, dt)
    thePlayer.crouching = true
    thePlayer.graspingDown = true
end

function applyDrag(thePlayer, dt)
    if thePlayer.xSpeed > 0 then
        thePlayer.xSpeed = thePlayer.xSpeed - theWorld.drag * dt
        if thePlayer.xSpeed < 0 then
            thePlayer.xSpeed = 0
        end
    elseif thePlayer.xSpeed < 0 then
        thePlayer.xSpeed = thePlayer.xSpeed + theWorld.drag * dt
        if thePlayer.xSpeed > 0 then
            thePlayer.xSpeed = 0
        end
    end    
end

function applyClimbDrag(thePlayer, dt)
    if thePlayer.ySpeed > 0 then
        thePlayer.ySpeed = thePlayer.ySpeed - theWorld.climbDrag * 0.5 * dt
        if thePlayer.ySpeed < 0 then
            thePlayer.ySpeed = 0
        end
    elseif thePlayer.ySpeed < 0 then
        thePlayer.ySpeed = thePlayer.ySpeed + theWorld.climbDrag * dt
        if thePlayer.ySpeed > 0 then
            thePlayer.ySpeed = 0
        end
    end    
end

function resetPlayer(thePlayer)
    thePlayer.xPosition = 200
    thePlayer.yPosition = 100
    thePlayer.ySpeed = 0
    thePlayer.xSpeed = 0    
end

function updatePadding(thePlayer, worldMap, backgrounds, theWorld, dt)
    playerRelativeXPos = (thePlayer.xPosition - thePlayer.width / 2) + worldMap.pixelPaddingX - worldMap.tilePaddingX * worldMap.tileSize
    playerRelativeYPos = (thePlayer.yPosition - thePlayer.width / 2) + worldMap.pixelPaddingY - worldMap.tilePaddingY * worldMap.tileSize
        
    middleX = (worldMap.drawX / 2) * worldMap.tileSize
    middleY = (worldMap.drawY / 2) * worldMap.tileSize
    
    playerDeltaX = playerRelativeXPos - middleX
    playerDeltaY = playerRelativeYPos - middleY

    if playerDeltaX > theWorld.allowedXDelta and (worldMap.tilePaddingX < worldMap.tilesX - worldMap.drawX or worldMap.pixelPaddingX > 0) then
        worldMap.pixelPaddingX = worldMap.pixelPaddingX - (playerDeltaX * theWorld.scrollSpeedX * dt)

        if math.abs(worldMap.pixelPaddingX) >= worldMap.tileSize then
            worldMap.pixelPaddingX = 0
            worldMap.tilePaddingX = worldMap.tilePaddingX + 1
            --print("X pad: "..worldMap.tilePaddingX)
        end
        
        -- Sweep through all the backgrounds in backgrounds and update the padding accordingly
        for bgId = 1, #worldMap.backgrounds do
            thisBg = worldMap.backgrounds[bgId]
            thisBg.xPadding = thisBg.xPadding - (playerDeltaX * theWorld.scrollSpeedX * dt) * (1 / thisBg.zDistance)                    
            if math.abs(thisBg.xPadding) >= thisBg.tileSize then
                thisBg.xPadding = 0
                thisBg:shiftX(-1)
            end
        end        
    end

    if playerDeltaX < -theWorld.allowedXDelta and (worldMap.tilePaddingX - 1 > -1 or worldMap.pixelPaddingX < 0) then
        worldMap.pixelPaddingX = worldMap.pixelPaddingX - (playerDeltaX * theWorld.scrollSpeedX * dt)
        if math.abs(worldMap.pixelPaddingX) >= worldMap.tileSize then
            worldMap.pixelPaddingX = 0
            worldMap.tilePaddingX = worldMap.tilePaddingX - 1
            --print("X pad: "..worldMap.tilePaddingX)
        end
            
        -- Sweep through all the backgrounds in backgrounds and update the padding accordingly
        for bgId = 1, #worldMap.backgrounds do
            thisBg = worldMap.backgrounds[bgId]
            thisBg.xPadding = thisBg.xPadding - (playerDeltaX * theWorld.scrollSpeedX * dt) * (1 / thisBg.zDistance)                    
            if math.abs(thisBg.xPadding) >= thisBg.tileSize then
                thisBg.xPadding = 0
                thisBg:shiftX(1)
            end
        end              
    end 
        
    if playerDeltaY > theWorld.allowedYDelta and (worldMap.tilePaddingY < worldMap.tilesY - worldMap.drawY or worldMap.pixelPaddingY > 0) then
        worldMap.pixelPaddingY = worldMap.pixelPaddingY - (playerDeltaY * theWorld.scrollSpeedY * dt)
        if math.abs(worldMap.pixelPaddingY) >= worldMap.tileSize then
            worldMap.tilePaddingY = worldMap.tilePaddingY + 1
            worldMap.pixelPaddingY = 0
            --print("Y pad:"..worldMap.tilePaddingY)
        end
                
         -- Sweep through all the backgrounds in backgrounds and update the padding accordingly
        for bgId = 1, #worldMap.backgrounds do
            thisBg = worldMap.backgrounds[bgId]
            thisBg.yPadding = thisBg.yPadding - (playerDeltaY * theWorld.scrollSpeedY * dt) * (1 / thisBg.zDistance)                    
            if math.abs(thisBg.xPadding) >= thisBg.tileSize then
                thisBg.yPadding = 0
                thisBg:shiftY(-1)
            end
        end
    end
    
    if playerDeltaY < -theWorld.allowedYDelta and (worldMap.tilePaddingY - 1 > -1 or worldMap.pixelPaddingY < 0) then
        worldMap.pixelPaddingY = worldMap.pixelPaddingY - (playerDeltaY * theWorld.scrollSpeedY * dt)
        if math.abs(worldMap.pixelPaddingY) >= worldMap.tileSize then
            worldMap.tilePaddingY = worldMap.tilePaddingY - 1
            worldMap.pixelPaddingY = 0
            --print("Y pad:"..worldMap.tilePaddingY)
        end
                    
         -- Sweep through all the backgrounds in backgrounds and update the padding accordingly
        for bgId = 1, #worldMap.backgrounds do
            thisBg = worldMap.backgrounds[bgId]
            thisBg.yPadding = thisBg.yPadding - (playerDeltaY * theWorld.scrollSpeedY * dt) * (1 / thisBg.zDistance)                    
            if math.abs(thisBg.xPadding) >= thisBg.tileSize then
                thisBg.yPadding = 0
                thisBg:shiftY(1)
            end
        end
    end    
end