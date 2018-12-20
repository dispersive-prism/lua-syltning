Background = {
    -- How much bigger (or smaller) should the tiles be in comparison to the foreground
    scaleFactor = 1,
    tileSize = 0,
    yPadding = 0,
    xPadding = 0,
    -- What should the perceived zDistance be of this background?
    zDistance = 0,
    -- An array which will keep the tilemap that will be repeated...
    background = {},
    -- ...in this array based on configuration (which covers one screen)
    repeatedBackground = {},
    -- Might be a representation of another repeated version of the repeated background
    paddedBackground = {},
    tilesX = 0,
    tilesY = 0
}

-- Initialized a placeholder for one background element
function Background.initBackground(x, y)
    for i = 1, x do
        Background.background[i] = {}
        for j = 1, y do
            Background.background[i][j] = 0
        end
    end
end

function Background.initRepeatedBackground(scaleFactor, tileSize, windowXTiles, windowYTiles, zDistance)
    
    --print("The window that we want to fill is: "..(tileSize * windowXTiles)..", "..(tileSize * windowYTiles))
    --print("The scale factor that we want to use is: "..scaleFactor)
    --print("The tile size of the parent window is: "..tileSize)
    
    Background.zDistance = zDistance
    
    arrayToFillX = math.floor(windowXTiles * scaleFactor)
    arrayToFillY = math.floor(windowYTiles * scaleFactor)
    
    Background.tilesX = arrayToFillX
    Background.tilesY = arrayToFillY
    
    Background.tileSize = tileSize / scaleFactor
    
    bgI = 1
    bgJ = 1
    bgIMax = #Background.background
    bgJMax = #Background.background[bgI]
    
    for i = 1, arrayToFillX do
        Background.repeatedBackground[i] = {}
        for j = 1, arrayToFillY do
            if Background.background[bgI][bgJ] == 1 then
                --print(bgI..", "..bgJ.." equals 1")
            else
                --print(bgI..", "..bgJ.." does not equal 1")
            end
            Background.repeatedBackground[i][j] = Background.background[bgI][bgJ]
            bgJ = bgJ + 1
            if bgJ > bgJMax then bgJ = 1 end
        end
        bgI = bgI + 1
        if bgI > bgIMax then bgI = 1 end
    end
    
    --print("Result background size: "..#Background.background..", "..#Background.background[1])
    --print("Resulting backgroundRepSize: "..#Background.repeatedBackground..", "..#Background.repeatedBackground[1])
    --print("Resulting tile size: "..Background.tileSize)
end

-- A function to rebuild the repeated background by shifting it x-wise
function Background.shiftX(shiftX)
    if shiftX < 0 then shiftX = Background.tilesX + shiftX end
    
    -- Decide which cunk of the array to put in the front of the shifted array
    chunkStart = Background.tilesX - shiftX + 1
    chunkEnd = Background.tilesX
    chunkLength = chunkEnd - chunkStart + 1
    
    --print("Chunk start: "..chunkStart)
    --print("Chunk end: "..chunkEnd)
    --print("Chunk length: "..chunkLength)
    
    shiftedArray = {}
    
    -- Sweep through the chunk and populate the new array with the initial chunks
    x = 1
    for i = chunkStart, chunkEnd do
        shiftedArray[x] = {}
        for j = 1, Background.tilesY do
            shiftedArray[x][j] = Background.repeatedBackground[i][j]
            --print("Shiftedarray["..x.."]["..j.."] = Background.repeatedBackground["..i.."]["..j.."]")
        end
        x = x + 1
        if x > chunkLength then
            break
        end
    end
    
    -- Now make sure that we add the rest
    for i = shiftX + 1, Background.tilesX do
        shiftedArray[i] = {}
        for j = 1, Background.tilesY do
            shiftedArray[i][j] = Background.repeatedBackground[i - shiftX][j]
            --print("Shiftedarray["..i.."]["..j.."] = Background.repeatedBackground["..(i - shiftX).."]["..j.."]")
        end
    end
    
    Background.repeatedBackground = shiftedArray
end

return Background