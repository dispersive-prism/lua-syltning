WorldMap = {
    fullMap = {{}},
    paddedMap = {{}},
    tilesX = 10,
    tilesY = 10,
    drawX = 10,
    drawY = 10,
    tilePaddingX = 0,
    tilePaddingY = 0,
    pixelPaddingX = 0,
    pixelPaddingY = 0,
    tileSize = 50
}

function WorldMap.initMap(x, y)
    WorldMap.tilesX = x
    WorldMap.tilesY = y
    for i = 0, x + 1 do
        WorldMap.fullMap[i] = {}
        for j = 0, y + 1 do
            if i > 0 and i <= x and j > 0 and j <= y then
                WorldMap.fullMap[i][j] = 0
            else
                WorldMap.fullMap[i][j] = 1
            end
        end
    end
    
    WorldMap.updatePaddedMap()
end

function WorldMap.updatePaddedMap()
    for i = 0, WorldMap.drawX + 1 do
        WorldMap.paddedMap[i] = {}
        for j = 0, WorldMap.drawY + 1 do
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