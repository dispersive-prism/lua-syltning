Background = {}

function Background:new(o)
    o = o or {
        -- How much bigger (or smaller) should the tiles be in comparison to the foreground
        scaleFactor = 1,
        tileSize = 0,
        yPadding = 0,
        xPadding = 0,
        -- What should the perceived zDistance be of this background?
        zDistance = 1,
        -- An array which will keep the tilemap that will be repeated...
        background = {},
        -- ...in this array based on configuration (which covers one screen)
        repeatedBackground = {},
        -- Might be a representation of another repeated version of the repeated background
        paddedBackground = {},
        tilesX = 0,
        tilesY = 0,
        color = { 1, 1, 1, 1 }
    }
    setmetatable(o, self) 
    self.__index = self
    return o
end

function Background:setColor(color)
    self.color = color
end

-- Initialized a placeholder for one background element
function Background:initBackground(x, y)
    for i = 1, x do
        self.background[i] = {}
        for j = 1, y do
            self.background[i][j] = 0
        end
    end
end

function Background:initRepeatedBackground(scaleFactor, tileSize, windowXTiles, windowYTiles, zDistance)
    
    --print("The window that we want to fill is: "..(tileSize * windowXTiles)..", "..(tileSize * windowYTiles))
    --print("The scale factor that we want to use is: "..scaleFactor)
    --print("The tile size of the parent window is: "..tileSize)
    
    if zDistance ~= 0 then
        self.zDistance = zDistance
    else
        self.zDistance = 1
    end
    
    arrayToFillX = math.floor(windowXTiles * scaleFactor)
    arrayToFillY = math.floor(windowYTiles * scaleFactor)
    
    self.tilesX = arrayToFillX
    self.tilesY = arrayToFillY
    
    self.tileSize = tileSize / scaleFactor
    
    bgI = 1
    bgJ = 1
    bgIMax = #self.background
    bgJMax = #self.background[bgI]
    
    for i = 0, arrayToFillX + 1 do
        self.repeatedBackground[i] = {}
        for j = 0, arrayToFillY + 1 do
            self.repeatedBackground[i][j] = self.background[bgI][bgJ]
            bgJ = bgJ + 1
            if bgJ > bgJMax then bgJ = 1 end
        end
        bgI = bgI + 1
        bgJ = 1
        if bgI > bgIMax then bgI = 1 end
    end
    
    --print("Result background size: "..#Background.background..", "..#Background.background[1])
    --print("Resulting backgroundRepSize: "..#self.repeatedBackground..", "..#self.repeatedBackground[1])
    --print("Resulting tile size: "..Background.tileSize)
end

-- A function to rebuild the repeated background by shifting it x-wise
function Background:shiftX(shiftX)
    -- 4 => - 1
    -- 3 => 
    if shiftX < 0 then shiftX = self.tilesX + shiftX + 1 else shiftX = shiftX - 1 end
    
    -- Decide which cunk of the array to put in the front of the shifted array
    chunkStart = self.tilesX + 1 - shiftX
    chunkEnd = self.tilesX + 1
    chunkLength = chunkEnd - chunkStart + 1
    
    --print("Chunk start: "..chunkStart)
    --print("Chunk end: "..chunkEnd)
    --print("Chunk length: "..chunkLength)
    
    shiftedArray = {}
    
    -- Sweep through the chunk and populate the new array with the initial chunks
    x = 0
    for i = chunkStart, chunkEnd + 1 do
        shiftedArray[x] = {}
        for j = 0, self.tilesY + 1 do
            shiftedArray[x][j] = self.repeatedBackground[i][j]
            --print("Shiftedarray["..x.."]["..j.."] = Background.repeatedBackground["..i.."]["..j.."]")
        end
        x = x + 1
        if x > chunkLength - 1 then
            --print("here with "..(chunkLength -1))
            break
        end
    end
    
    -- Now make sure that we add the rest
    for i = shiftX + 1, self.tilesX + 1 do
        shiftedArray[i] = {}
        for j = 0, self.tilesY + 1 do
            shiftedArray[i][j] = self.repeatedBackground[i - shiftX - 1][j]
            --print("Shiftedarray["..i.."]["..j.."] = Background.repeatedBackground["..(i - shiftX - 1).."]["..j.."]")
        end
    end
    
    self.repeatedBackground = shiftedArray
end

-- Can be concatenated together with shiftX later on. Code duplication for now...
-- A function to rebuild the repeated background by shifting it x-wise
function Background:shiftY(shiftY)
    -- -1 => 20 + 1 -1 = 20
    if shiftY < 0 then shiftY = #self.repeatedBackground[0] + 1 + shiftY end
    
    --print("shiftY: "..shiftY)
    
    -- Decide which cunk of the array to put in the front of the shifted array
    chunkStart = self.tilesY + 1 - shiftY + 1
    chunkEnd = self.tilesY + 1
    chunkLength = chunkEnd - chunkStart + 1
    
    shiftedArray = {}
    
    for i = 0, self.tilesX + 1 do
        -- The chunk to chop is shiftY
        shiftedArray[i] = {}
        for j = 0, self.tilesY + 1 do
            if j >= shiftY then
                shiftedArray[i][j] = self.repeatedBackground[i][j - shiftY]
            else
                shiftedArray[i][j] = self.repeatedBackground[i][#self.repeatedBackground[i] + 1 - shiftY + j]
                --print("2. Shiftedarray["..i.."]["..j.."] = Background.repeatedBackground["..i.."]["..(#self.repeatedBackground[i] - shiftY + j).."]")
            end
        end
    end
    
    self.repeatedBackground = shiftedArray
end


return Background