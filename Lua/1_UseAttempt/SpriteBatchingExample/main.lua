function love.load()
    mapWidth = 60
    mapHeight = 40
   
    --  fill the map with random tiles
    map = {}
    for x=1,mapWidth do
        map[x] = {}
        for y=1,mapHeight do
            map[x][y] = love.math.random(0,3)
        end
    end
   
    --  rendering constants
    mapX = 1
    mapY = 1
    tilesDisplayWidth = 26
    tilesDisplayHeight = 20
   
    zoomX = 1
    zoomY = 1

    --  map init
    tilesetImage = love.graphics.newImage( "tileset.png" )
    tilesetImage:setFilter("nearest", "linear") -- this "linear filter" removes some artifacts if we were to scale the tiles
    tileSize = 32

    tileQuads = {}

    -- grass
    tileQuads[0] = love.graphics.newQuad(0 * tileSize, 20 * tileSize, tileSize, tileSize,
    tilesetImage:getWidth(), tilesetImage:getHeight())
    -- kitchen floor tile
    tileQuads[1] = love.graphics.newQuad(2 * tileSize, 0 * tileSize, tileSize, tileSize,
    tilesetImage:getWidth(), tilesetImage:getHeight())
    -- parquet flooring
    tileQuads[2] = love.graphics.newQuad(4 * tileSize, 0 * tileSize, tileSize, tileSize,
    tilesetImage:getWidth(), tilesetImage:getHeight())
    -- middle of red carpet
    tileQuads[3] = love.graphics.newQuad(3 * tileSize, 9 * tileSize, tileSize, tileSize,
    tilesetImage:getWidth(), tilesetImage:getHeight())

    tilesetBatch = love.graphics.newSpriteBatch(tilesetImage, tilesDisplayWidth * tilesDisplayHeight)
end

function updateTilesetBatch()
    tilesetBatch:clear()
    for x=0, tilesDisplayWidth-1 do
        for y=0, tilesDisplayHeight-1 do
            tilesetBatch:add(tileQuads[map[x+mapX][y+mapY]], x*tileSize, y*tileSize)
        end
    end
    tilesetBatch:flush()
  end

  function love.draw()
    love.graphics.draw(tilesetBatch)
  end

  -- central function for moving the map
function moveMap(dx, dy)
    oldMapX = mapX
    oldMapY = mapY
    mapX = math.max(math.min(mapX + dx, mapWidth - tilesDisplayWidth), 1)
    mapY = math.max(math.min(mapY + dy, mapHeight - tilesDisplayHeight), 1)
    -- only update if we actually moved
    if math.floor(mapX) ~= math.floor(oldMapX) or math.floor(mapY) ~= math.floor(oldMapY) then
      updateTilesetBatch()
    end
  end
   
  function love.keypressed(key)
    if key == "up" then
      moveMap(0, -1)
    end
    if key == "down" then
      moveMap(0, 1)
    end
    if key == "left" then
      moveMap(-1, 0)
    end
    if key == "right" then
      moveMap(1, 0)
    end
    if key == "escape" then
        love.event.quit()
    end
  end