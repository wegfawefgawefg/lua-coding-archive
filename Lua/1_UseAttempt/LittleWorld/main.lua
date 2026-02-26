--  make sliders that let you edit the noise in real time
--  make it so you can change how many noises there are
--  insert more colors
--  insert trees and such
--  use water droplets to erode world
--  use the world to do physics
--  add high frequency noise to the coloring
--  color the world based on discrete derivative

function makeWorld()
    local world = {}
    world.height = love.graphics.getWidth() / 16 --6 --16
    world.width = love.graphics.getHeight() / 16 --6 --16
    world.x = 0
    world.y = 0
    world.screenWidth = love.graphics.getWidth()
    world.screenHeight = love.graphics.getHeight()

    world.tiles = {}
    local yNoise = yNoiseStart
    local yNoise2 = yNoiseStart
    local yNoise3 = yNoiseStart
    local yNoise4 = yNoiseStart

    local noiseDelta = noiseFrequency
    local noiseDelta2 = noiseFrequency * 4
    local noiseDelta3 = noiseFrequency  * 0.2
    local noiseDelta4 = noiseFrequency  * 0.05

    local noiseFrac = 1
    local noise2Frac = 1/8
    local noise3Frac = 1/4
    local noise4Frac = 10

    for y=1, world.height do
        world.tiles[y] = world.tiles[y] or {}
        local xNoise = xNoiseStart
        local xNoise2 = xNoiseStart
        local xNoise3 = xNoiseStart
        local xNoise4 = xNoiseStart

        for x=1, world.width do
            local noise1 = love.math.noise(xNoise, yNoise) * noiseFrac - noiseFrac / 2
            local noise2 = love.math.noise(xNoise2, yNoise2) * noise2Frac - noise2Frac / 2
            local noise3 = (love.math.noise(xNoise3, yNoise3) * love.math.noise(xNoise4, yNoise4))* noise3Frac - noise3Frac / 2
            local noise4 = love.math.noise(xNoise4, yNoise4) * noise4Frac - noise4Frac / 2

            world.tiles[y][x] = noise1 + noise2 + noise3 + noise4
        
            xNoise = xNoise + noiseDelta
            xNoise2 = xNoise2 + noiseDelta2
            xNoise3 = xNoise3 + noiseDelta3
            xNoise4 = xNoise4 + noiseDelta4
        end
        
        yNoise = yNoise + noiseDelta
        yNoise2 = yNoise2 + noiseDelta2
        yNoise3 = yNoise3 + noiseDelta3
        yNoise4 = yNoise4 + noiseDelta4
    end
    return world
end

function drawWorldFlat()
    local brown = {140/255,86/255,24/255, 1}
    local blue = {0, 0, 1, 0.5}
    local green = {0, 1, 0, 1}
    local tileWidth = world.screenWidth / world.width
    local tileHeight = world.screenHeight / world.height

    local tileY = world.y
    for y=1, #world.tiles do
        local tileX = world.x
        for x=1, #world.tiles[y] do
            local h = world.tiles[y][x]
            love.graphics.setColor(h, h, h, 1)
            -- if h < waterHeight then
            --     love.graphics.setColor(blue)
            -- elseif h < dirtHeight then
            --     love.graphics.setColor(brown)
            -- elseif h < grassheight then
            --     love.graphics.setColor(green)
            -- else
            --     love.graphics.setColor(1, 1, 1, 0.9)
            -- end
            love.graphics.rectangle( 'fill', tileX, tileY, tileWidth, tileHeight)
            tileX = tileX + tileWidth
        end
        tileY = tileY + tileHeight
    end
end

function drawWorldOrtho()
    local tileWidth = world.screenWidth / world.width
    local tileHeight = world.screenHeight / world.height
    local worldHeight = love.graphics.getHeight()

    -- local brownVariation = 20
    -- local blueVariation = 30
    -- local greenVariation = 150

    local maxOffsetHeight = 50
    local offsetHeight = 0
    local tileY = world.y
    for y=1, #world.tiles do
        local tileX = world.x
        for x=1, #world.tiles[y] do
            
            -- local brown = { (140 + brownVariation*love.math.random()) /255,
            --                 (86 + brownVariation*love.math.random()) /255,
            --                 (24 + brownVariation*love.math.random()) /255,
            --                 1}
            -- local blue = {  (10 + blueVariation*love.math.random()) /255, 
            --                 (10 + blueVariation*love.math.random()) /255, 
            --                 (255 + blueVariation*love.math.random()) /255, 
            --                 0.1}
            -- local green = { (10 + greenVariation*love.math.random()) /255, 
            --                 (255 + greenVariation*love.math.random()) /255,  
            --                 (10 + greenVariation*love.math.random()) /255, 
            --                 1}
            -- local grey = {  107/255,
            --                 96/255,
            --                 96/255, 
            --                 1}

            local brown = {140/255,86/255,24/255, 1}
            local blue = {0, 0, 1, 0.5}
            local green = {0, 1, 0, 1}
            local grey = {  107/255, 96/255, 96/255, 1}

            local h = world.tiles[y][x]
            -- love.graphics.setColor(0, 0, 0, 0)
            if h < waterHeight then
                love.graphics.setColor(blue)
                h = 0.3
            elseif h < dirtHeight then
                love.graphics.setColor(brown)
            elseif h < grassHeight then
                love.graphics.setColor(green)
            else
                love.graphics.setColor(1, 1, 1, 0.9)
            end
            offsetHeight = tileY - (h * maxOffsetHeight)
            love.graphics.rectangle( 'fill', tileX, offsetHeight, tileWidth, tileHeight)
            love.graphics.setColor(grey)
            if h <= waterHeight then
                love.graphics.setColor(blue)
            end
            love.graphics.rectangle( 'fill', tileX, offsetHeight + tileHeight, tileWidth, maxOffsetHeight)

            tileX = tileX + tileWidth
        end
        tileY = tileY + tileHeight
    end
end

function love.load()
    love.math.getRandomSeed(123)
    waterHeight = 0.3
    dirtHeight = 0.9
    grassHeight = 3.0
    noiseFreqDelta = 0.001
    noiseFrequency = 1/10  - 5 * noiseFreqDelta
    mouseNoiseFrequency = 1/100
    xNoiseStart = 0
    yNoiseStart = 0
    world = makeWorld()
    flags = {}
    flags.fullscreen = true
    flags.display = 4
    -- love.window.setFullscreen( true )
    -- love.window.setMode( 1920, 1080, flags )
    love.window.setMode( 3840, 2160, flags )
end

function love.update()
    -- xNoiseStart = love.mouse.getX() * mouseNoiseFrequency
    -- yNoiseStart = love.mouse.getY() * mouseNoiseFrequency
    xNoiseStart = xNoiseStart + 0.002 -- 0.004
    yNoiseStart = yNoiseStart + 0.001
    world = makeWorld()
end

function love.draw()
    love.graphics.clear()
    drawWorldOrtho()
    -- drawWorldFlat()
end

function love.wheelmoved( dx, dy )
    noiseFrequency = noiseFrequency + noiseFreqDelta * dy
end

function love.keypressed(k)
    if k == 'escape' then
       love.event.quit()
    end
 end