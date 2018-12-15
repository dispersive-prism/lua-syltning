WorldMap = {
    fullMap = {{}},
    paddedMap = {{}},
    tilesX = 10,
    tilesY = 10,
    drawX = 10,
    drawY = 10,
    tilePaddingX = 0,
    tilePaddingY = 0,
    tileSize = 50
}

function WorldMap.initMap(x, y)
    WorldMap.tilesX = x
    WorldMap.tilesY = y
    for i = 1, x do
        WorldMap.fullMap[i] = {}
        for j = 1, y do
           WorldMap.fullMap[i][j] = 0 
        end
    end

    WorldMap.updatePaddedMap()
end

function WorldMap.updatePaddedMap()
    for i = 1, WorldMap.drawX do
        WorldMap.paddedMap[i] = {}
        for j = 1, WorldMap.drawY do
            -- Check whether this cooridnate (including padding) is within the fullMap boundaries.
            -- If so, copy the fullMap tile, else default to 1 (solid block)
            if WorldMap.tilePaddingX + i <= WorldMap.tilesX and WorldMap.tilePaddingX + i > 0 and
                WorldMap.tilePaddingY + j < WorldMap.tilesY and WorldMap.tilePaddingY + j > 0 then
                WorldMap.paddedMap[i][j] = WorldMap.fullMap[WorldMap.tilePaddingX + i][WorldMap.tilePaddingY + j]
            else
                WorldMap.paddedMap[i][j] = 1
            end
        end
    end    
end

return WorldMap