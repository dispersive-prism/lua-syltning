Background = {
    -- How much bigger (or smaller) should the tiles be in comparison to the foreground
    scaleFactor = 1,
    yPadding = 0,
    xPadding = 0,
    -- What should the perceived zDistance be of this background?
    zDistance = 0,
    -- An array which will keep the tilemap that will be repeated...
    background = {},
    -- ...in this array based on configuration
    repeatedBackground = {}
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

function Background.initRepeatedBackground(scaleFactor, tileSize, windowXSize, windowYSize, zDistance)
    
    print("The window that we want to fill is: "..windowXSize..", "..windowYSize)
    print("The scale factor that we want to use is: "..scaleFactor)
    print("The tile size of the parent window is: "..tileSize)
    
    Background.zDistance = zDistance
    
    arrayToFillX = math.floor(windowXSize / tileSize) * scaleFactor
    arrayToFillY = math.floor(windowYSize / tileSize) * scaleFactor
    
    print(arrayToFillX..", "..arrayToFillY)
    
    bgI = 1
    bgJ = 1
    bgIMax = #Background.background
    bgJMax = #Background.background[bgI]
    
    for i = 1, arrayToFillX do
        Background.repeatedBackground[i] = {}
        for j = 1, arrayToFillY do
            Background.repeatedBackground[i][j] = Background.background[bgI][bgJ]
            bgJ = bgJ + 1
            if bgJ >= bgJMax then bgJ = 1 end
        end
        bgI = bgI + 1
        if bgI >= bgIMax then bgI = 1 end
    end
    
    print("Result background size: "..#Background.background..", "..#Background.background[1])
    print("Resulting backgroundRepSize: "..#Background.repeatedBackground..", "..#Background.repeatedBackground[1])
end

return Background