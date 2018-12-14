WorldView = {
    tilePaddingX = 0, -- How many xTiles to pad in the world
    tilePaddingY = 0, -- How many yTiles ot pad in the world
    pixelPaddingX = 0, -- How many x pixels to pad in the world (should never be more than world.tileSize)
    pixelPaddingY = 0, -- How many y pixels to pad in the world (should never be more than world.tileSize)
    tilesX = 10, -- How big is the map x wise
    tilesY = 10, -- How big is the map y wise
    drawX = 10,
    drawY = 10,
    tileSize = 50,
    scrollWindowX = 0,
    scrollWindowY = 0,
    scrollWindowW = 0,
    scrollWindowH = 0
}

function WorldView.setViewSize(x, y)
    WorldView.tilesX = x
    WorldView.tilesY = y
    
    WorldView.scrollWindowX = 2 * WorldView.tileSize
    WorldView.scrollWindowY = 2 * WorldView.tileSize
    WorldView.scrollWindowW = (WorldView.tilesX - 2) * WorldView.tileSize
    WorldView.scrollWindowH = (WorldView.tilesY - 2) * WorldView.tileSize
end

return WorldView