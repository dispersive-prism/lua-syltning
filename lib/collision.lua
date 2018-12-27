function processCollision(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    if ctX < tileX and ctY < tileY then
        upperLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap) 
    end
    if ctX == tileX and ctY < tileY then
        upperMiddle(ctX, ctY, tileX, tileY, thePlayer, worldMap)        
    end
    if ctX > tileX and ctY < tileY then
        upperRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)        
    end
    if ctX < tileX and ctY == tileY then
        middleLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap) 
    end
    if ctX == tileX and ctY == tileY then
        middle(ctX, ctY, tileX, tileY, thePlayer, worldMap)         
    end
    if ctX > tileX and ctY == tileY then
        middleRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)          
    end
    if ctX < tileX and ctY > tileY then
        lowerLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap)          
    end
    if ctX == tileX and ctY > tileY then
        lowerMiddle(ctX, ctY, tileX, tileY, thePlayer, worldMap)          
    end
    if ctX > tileX and ctY > tileY then
        lowerRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)           
    end

end

function upperLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
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
end

function upperMiddle(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
        if thePlayer.ySpeed < 0 then
            thePlayer.ySpeed = 0
            nextY = h + thePlayer.height / 2 
        end
    end
end

function upperRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
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
end

function middleLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
        thePlayer.xSpeed = 0
        nextX = w + thePlayer.width / 2
    end
end

function middle(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
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
end

function middleRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
        thePlayer.xSpeed = 0
        nextX = x - thePlayer.width / 2
    end
end

function lowerLeft(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks (1)
    if worldMap.fullMap[ctX][ctY] == 1 then
        if worldMap.fullMap[tileX+1][tileY] == 1 then
            nextY = y - thePlayer.height / 2
        end
        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX - 1][tileY] == 0 and thePlayer.ySpeed > 0 then
            if px < w then
                thePlayer.lastGrounded = love.timer.getTime()
                thePlayer.ySpeed = 0
                nextY = y - thePlayer.height / 2
            end
        end
    end
    -- For bridge blocks (2) (Code duplication for now)
    if worldMap.fullMap[ctX][ctY] == 2 then
        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX - 1][tileY] == 0 and thePlayer.ySpeed > 0 then
            if px < w then
                thePlayer.lastGrounded = love.timer.getTime()
                thePlayer.ySpeed = 0
                nextY = y - thePlayer.height / 2
            end
        end
    end    
end

function lowerMiddle(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks (1)
    if worldMap.fullMap[ctX][ctY] == 1 then
        thePlayer.ySpeed = 0
        nextY = y - thePlayer.height / 2
        -- Also set the lastGrounded
        thePlayer.lastGrounded = love.timer.getTime()
    end
    -- For bridge blocks (2) (Code duplication for now)
    if worldMap.fullMap[ctX][ctY] == 2 then
        if thePlayer.ySpeed > 0 then
            thePlayer.ySpeed = 0
            nextY = y - thePlayer.height / 2
            thePlayer.lastGrounded = love.timer.getTime()
        end
    end
end

function lowerRight(ctX, ctY, tileX, tileY, thePlayer, worldMap)
    -- For solid blocks
    if worldMap.fullMap[ctX][ctY] == 1 then
        if worldMap.fullMap[tileX - 1][tileY] == 1 then
            --thePlayer.ySpeed = 0
            nextY = y - thePlayer.height / 2
        end
        -- Check if we're at a cliff side
        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX + 1][tileY] == 0 and thePlayer.ySpeed > 0 then
            -- Are we still grounded in terms of x? Do we have a foot on the ground
            if pw > x then
                thePlayer.lastGrounded = love.timer.getTime()
                thePlayer.ySpeed = 0
                nextY = y - thePlayer.height / 2
            end
        end
    end
    -- For bridge blocks (2) (Code duplication for now)
    if worldMap.fullMap[ctX][ctY] == 2 then
        if worldMap.fullMap[tileX][tileY + 1] == 0 and worldMap.fullMap[tileX - 1][tileY] == 0 and thePlayer.ySpeed > 0 then
            if px < w then
                thePlayer.lastGrounded = love.timer.getTime()
                thePlayer.ySpeed = 0
                nextY = y - thePlayer.height / 2
            end
        end
    end   
end