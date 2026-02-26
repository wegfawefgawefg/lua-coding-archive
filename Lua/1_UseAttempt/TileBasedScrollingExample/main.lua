function createMap(width, height)
    local map = {}
end

function love.load()
    -- our tiles
   tile = {}
   for i=0,3 do -- change 3 to the number of tile images minus 1.
      tile[i] = love.graphics.newImage( "tile"..i..".png" )
   end
 
   love.graphics.setNewFont(12)
 
   -- map variables
   map_w = 20
   map_h = 20
   map_x = 0
   map_y = 0
   map_offset_x = 30
   map_offset_y = 30
   map_display_w = 15
   map_display_h = 11
   tile_w = 48
   tile_h = 48

   map={
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
        { 0, 1, 0, 0, 2, 2, 2, 0, 3, 0, 3, 0, 1, 1, 1, 0, 0, 0, 0, 0},
        { 0, 1, 0, 0, 2, 0, 2, 0, 3, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 0},
        { 0, 1, 1, 0, 2, 2, 2, 0, 0, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
        { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
        { 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0},
        { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
        { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
        { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 2, 2, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    }
end

function ruleOne(you, left, right, up, down)
    local newYou = you
    if you == 1 and left == 0 then
        newYou = 0
    elseif you == 0 and right == 1 then
        newYou = 2
    end
    return newYou
end

function itterateMap()
    for y=1, map_h do
        for x=1, map_w do
            local num = map[y][x]
            local right =   map[y][math.min(x + 1, map_w)]
            local left =    map[y][math.max(x - 1, 1)]
            local up =      map[math.max(y - 1, 1)][x]
            local down =    map[math.min( y + 1, map_h)][x]
            map[y][x] = ruleOne(num, left, right, up, down)
        end
    end
end

function love.update()
    itterateMap()
end

function draw_map()
    local tileTlY = map_offset_y
    for y=1, map_display_h do
        local tileTlX = map_offset_x
        for x=1, map_display_w do                                                         
            love.graphics.draw( 
                tile[map[y+map_y][x+map_x]], 
                tileTlX, tileTlY)
            tileTlX = tileTlX + tile_w
        end
        tileTlY = tileTlY + tile_h
    end
 end
 
 function love.keypressed(key, unicode)
    if key == 'up' then
       map_y = map_y-1
       if map_y < 0 then map_y = 0; end
    end
    if key == 'down' then
       map_y = map_y+1
       if map_y > map_h-map_display_h then map_y = map_h-map_display_h; end
    end
  
    if key == 'left' then
       map_x = math.max(map_x-1, 0)
    end
    if key == 'right' then
       map_x = math.min(map_x+1, map_w-map_display_w)
    end
 end



 function love.draw()
    draw_map()
  end