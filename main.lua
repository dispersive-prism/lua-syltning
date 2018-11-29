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
    
    table[10][2] = 1
    table[10][3] = 1
    table[1][2] = 1
    table[1][3] = 1
    table[6][9] = 1
    -- Position the player
    thePlayer.x = 230
    thePlayer.y = 100
end
 
function love.update(dt)
    -- Set player speed based on keyboard input
    if love.keyboard.isDown('d') then
        thePlayer.xSpeed = thePlayer.runSpeed
    end
    if love.keyboard.isDown('a') then
        thePlayer.xSpeed = -thePlayer.runSpeed
    end
    if love.keyboard.isDown('w') and thePlayer.airborne == 0 then
        thePlayer.ySpeed = thePlayer.jumpHeight
        thePlayer.airborne = 1
    end
    if not love.keyboard.isDown('d') and not love.keyboard.isDown('a') then
        thePlayer.xSpeed = 0
    end
    if love.keyboard.isDown('g') then
        thePlayer.x = 200
        thePlayer.y = 100
        thePlayer.ySpeed = 0
        thePlayer.xSpeed = 0
    end
    
    -- Apply force to the player
    if thePlayer.airborne == 1 then
        thePlayer.ySpeed = thePlayer.ySpeed - theWorld.gravity
    end

    
    -- Apply gravity to the player
    nextY = math.floor(thePlayer.y + thePlayer.ySpeed * dt)
    nextX = math.floor(thePlayer.x + thePlayer.xSpeed * dt)
    
    -- Check for collisions in the tiles around the player
    tileX = math.floor(nextX / tilesize) + 1
    tileY = math.floor(nextY / tilesize) + 1
    
    -- Always set the player to airborne and explicitly determine whether it should be set to 0
    thePlayer.airborne = 1
    
    tileXCheck = tileX
    tileYCheck = tileY
    
    -- Check for collision based on xSpeed and ySpeed
    if thePlayer.ySpeed > 0 then
        tileYCheck = tileYCheck + 1
    end
    if thePlayer.ySpeed < 0 then
        tileYCheck = tileYCheck - 1 
    end
    if thePlayer.xSpeed < 0 then
        tileXCheck = tileXCheck - 1
    end
    if thePlayer.xSpeed > 0 then
        tileXCheck = tileXCheck + 1
    end
    
    px = nextX - thePlayer.width / 2
    py = nextY - thePlayer.height / 2
    pw = px + thePlayer.width
    ph = py + thePlayer.height    
    
    -- Vertical check
    if tileXCheck > 0 and tileXCheck <= 10 then
        if table[tileXCheck][tileY] == 1 then
            x = (tileXCheck - 1) * tilesize
            y = (tileY - 1) * tilesize
            w = tilesize + x
            h = tilesize + y
                        
            
            print(pw.." > "..x.." and "..pw.." < "..w.." and "..ph.." > "..y.." and "..ph.." < "..h)
            print(px.." > "..w.." and "..px.." < "..x.." and "..ph.." > "..y.." and "..ph.." < "..h)
            print(px.." > "..x.." and "..pw.." < "..w.." and "..ph.." > "..y.." and "..ph.." < "..h)
            print(px.." > "..x.." and "..pw.." < "..w.." and "..py.." > "..y.." and "..ph.." < "..h)
            
            if (pw > x and pw < w and ph > y and ph < h) or
               (px < w and px > x and ph > y and ph < h) or 
               (px > x and pw < w and ph > y and ph < h) or
               (px > x and pw < w and py > y and ph < h) then
                -- Collision?
                
                if thePlayer.xSpeed > 0 then
                    nextX = x - thePlayer.width / 2
                else
                    nextX = w + thePlayer.width / 2
                end
                
                thePlayer.xSpeed = 0
            end
        end
    end
    
    if tileYCheck > 0 and tileYCheck <= 10 then
        if table[tileX][tileYCheck] == 1 then
            x = (tileX - 1) * tilesize
            y = (tileYCheck - 1) * tilesize
            w = tilesize + x
            h = tilesize + y
            
            --print(pw.." > "..x.." and "..pw.." < "..w.." and "..ph.." > "..y.." and "..ph.." < "..h)
            --print(px.." > "..w.." and "..px.." < "..x.." and "..ph.." > "..y.." and "..ph.." < "..h)
            --print(px.." > "..x.." and "..pw.." < "..w.." and "..ph.." > "..y.." and "..ph.." < "..h)
            --print(px.." > "..x.." and "..pw.." < "..w.." and "..py.." > "..y.." and "..ph.." < "..h)
            
            if (pw > x and pw < w and ph > y and ph < h) or
               (px < w and px > x and ph > y and ph < h) or 
               (px > x and pw < w and ph > y and ph < h) or
               (px > x and pw < w and py > y and ph < h) then
                -- Collision?
                if thePlayer.ySpeed > 0 then
                    nextY = y - thePlayer.height / 2
                else
                    nextY = h + thePlayer.height / 2
                end
                
                thePlayer.ySpeed = 0
                thePlayer.airborne = 0
                nextY = y - thePlayer.height / 2
            end
        end
    end
    
    thePlayer.x = nextX
    thePlayer.y = nextY
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
end