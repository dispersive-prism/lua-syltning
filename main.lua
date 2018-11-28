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
    -- Position the player
    thePlayer.x = 230
    thePlayer.y = 100
end
 
function love.update(dt)
    if love.keyboard.isDown('d') then
        thePlayer.xSpeed = 100
    end
    if love.keyboard.isDown('a') then
        thePlayer.xSpeed = -100    
    end
    if love.keyboard.isDown('w') then
        thePlayer.ySpeed = thePlayer.jumpHeight    
    end
    
    -- Apply gravity to the player
    nextY = thePlayer.y + theWorld.gravity * dt
    nextX = thePlayer.x + thePlayer.xSpeed * dt
    
    -- Check for collisions in the tiles around the player
    tileX = math.floor(nextX / tilesize) + 1
    tileY = math.floor(nextY / tilesize) + 1
    
    xx = -1
    yy = -1
    
    for i = tileX - 1, tileX + 1 do
        for j = tileY - 1, tileY + 1 do
            --print("x: "..xx..", y: "..yy)
            if i > 0 and j > 0 and i <= 10 and j <= 10 then
                if table[i][j] == 1 then
                    -- Convert the tile positions into coordinates
                    x = (i - 1) * tilesize
                    y = (j - 1) * tilesize
                    w = tilesize + x
                    h = tilesize + y
                    
                    -- Playeris positioned based on its center point, create its bounding box
                    px = nextX - thePlayer.width / 2
                    py = nextY - thePlayer.height / 2
                    pw = px + thePlayer.width
                    ph = py + thePlayer.height
                    
                    -- print("x: "..x..", y: "..y.." --- w: "..w..", h: "..h.." Player px: "..px..", py: "..py.." pw: "..pw..", ph: "..ph)
                    -- print(i..", "..j.."  "..xx..", "..yy)
                    -- Two items are overlapping depending on direction
                    if xx == -1 and yy == -1 then
                        -- Upper left -> x - 1, y - 1 => stops negative x and negative y movement
                        if px < w and py < h then
                            --print("1")
                            nextX = thePlayer.x
                            nextY = thePlayer.y    
                        end
                    end
                    if xx == 0 and yy == -1 then
                        -- Upper middle -> x -1, y => stops negative y movement
                        if py < h then
                            --print("3")
                            nextY = thePlayer.y
                        end
                    end
                    if xx == 1 and yy == -1 then
                        -- Upper right -> x - 1, y + 1 => stops positive z and negative y movement
                        if pw > x and py < y then
                            --print("4")
                            nextX = thePlayer.x    
                            nextY = thePlayer.y
                        end
                    end
                    if xx == -1 and yy == 0 then
                        -- Middle left -> x, y - 1 => stops negative x movement
                        if px < w then
                            --print("6")
                            nextX = thePlayer.x
                        end
                    end
                    if xx == 1 and yy == 0 then
                        -- Middle right -> x, y + 1 => stops positive x movement
                        if pw > x then
                            --print("7")
                            nextX = thePlayer.x
                        end
                    end
                    if xx == -1 and yy == 1 then
                        -- Lower left -> x + 1, y - 1 => stops negative x and positive y movement
                        if pw < w and ph > y then
                            --print("8")
                            nextX = thePlayer.x
                            nextY = thePlayer.y
                        end
                    end
                    if xx == 0 and yy == 1 then
                        -- Lower middle -> x + 1, y => stops positive y movement
                        if ph > y then
                            --print("10")
                            nextY = thePlayer.y
                        end
                    end
                    if xx == 1 and yy == 1 then
                        -- Lower right -> x + 1, y + 1 => stops positive x and positive y movement
                        if pw > x and ph > y then
                            --print("11")
                            nextX = thePlayer.x
                            nextY = thePlayer.y
                        end
                    end
                end
            end
            yy = yy + 1
            if yy > 1 then yy = -1 end
        end
        xx = xx + 1
        if xx > 1 then xx = -1 end
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