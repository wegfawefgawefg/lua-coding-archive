local Vec2 = require("vec2")

function love.load()
    startTime = love.timer.getTime()
    love.math.getRandomSeed(123)
    -- humans = {}
    human = {}
    -- love.window.setFullscreen( true )
end

function makeHumans()
    humans = {}
    local numHumans = 1
    for i=1, numHumans do
        local newHuman = genHuman()
        table.insert(humans, newHuman)
    end
end

function makeLine(x, y, angle, length)
    local line = {
        x = x,
        y = y,
        angle = angle,
        length = length
    }
    return line
end

function getLineEnd(line)
    local endPoint = Vec2.fromAngle(line.angle)
    Vec2.setMag(endPoint, line.length)
    Vec2.add(endPoint, line.x, line.y)
    return {    x = endPoint[1], 
                y = endPoint[2] }
end

function genHuman()
    local time = (love.timer.getTime() - startTime) / 4
    local human = {}
    human.x = love.graphics.getWidth() / 2
    human.y = love.graphics.getHeight() / 2

    --  generate torso
    human.torso = makeLine(
        human.x, 
        human.y, 
        math.rad(90 + 5 * love.math.noise(time)), 
        150)
    --  --  create mount points
    --  --  --  neck
    human.torso.neckMount = {
        x=human.torso.x, 
        y=human.torso.y}
    --  --  --  hip
    human.torso.hipMount = getLineEnd(human.torso)

    --  generate neck
    human.neck = makeLine(
        human.torso.neckMount.x,
        human.torso.neckMount.y,
        human.torso.angle - math.rad(180  + 5 * love.math.noise(time + 0.2)),
        human.torso.length / 5)
    --  --  create mount points
    --  --  --  head
    human.neck.headMount = getLineEnd(human.neck)

    --  generate head
    human.head = makeLine(
        human.neck.headMount.x,
        human.neck.headMount.y,
        human.neck.angle - math.rad(10 + 10 * love.math.noise(time + 0.3)),
        human.torso.length / 5)
    human.head.top = getLineEnd(human.head)

    --  generate shoulders
    human.shoulders = makeLine(
        human.torso.neckMount.x,
        human.torso.neckMount.y,
        human.neck.angle - math.rad(10 + 10 * love.math.noise(time + 0.4)),
        1)
    --  --  create mount points
    --  --  --  right arm mount point
    local rightArmMount = makeLine(
        human.shoulders.x,
        human.shoulders.y,
        human.neck.angle - math.rad(90 + 10 * love.math.noise(time + 0.5)),
        human.torso.length / 5)
    human.shoulders.rightArmMount = getLineEnd(rightArmMount)
    --  --  --  left arm mount point
    local leftArmMount = makeLine(
        human.shoulders.x,
        human.shoulders.y,
        human.neck.angle - math.rad(-90 + 10 * love.math.noise(time + 0.6)),
        human.torso.length / 5)
    human.shoulders.leftArmMount = getLineEnd(leftArmMount)
    --  --  --  head
    human.neck.headMount = getLineEnd(human.neck)

    --  generate upper right arm
    human.upperRightArm = makeLine(
        human.shoulders.rightArmMount.x,
        human.shoulders.rightArmMount.y,
        human.neck.angle - math.rad(10 + 10 * love.math.noise(time + 0.4)),
        1)

    --  generate lower right arm

    --  generate upper left arm

    --  generate lower left arm

    --  generate upper right

    --  generate lower right leg

    --  generate upper left leg

    --  generate lower left leg

    return human
end

function drawHuman(human)
    local h = human
    love.graphics.setColor(0, 1, 0, 1)
    --  draw head
    love.graphics.line(
        h.head.x,
        h.head.y,
        h.head.top.x,
        h.head.top.y)
    --  draw neck
    love.graphics.line(
        h.neck.x,
        h.neck.y,
        h.neck.headMount.x,
        h.neck.headMount.y)    
    --  draw torso
    love.graphics.line(
        h.torso.x,
        h.torso.y,
        h.torso.hipMount.x,
        h.torso.hipMount.y)
    --  draw shoulers
    --  --  draw right shoulder
    love.graphics.line(
        h.shoulders.x,
        h.shoulders.y,
        h.shoulders.rightArmMount.x,
        h.shoulders.rightArmMount.y)
    --  --  draw left shoulder
    love.graphics.line(
        h.shoulders.x,
        h.shoulders.y,
        h.shoulders.leftArmMount.x,
        h.shoulders.leftArmMount.y)
end

function love.update()
    -- makeHumans()
    human = genHuman()
end

function love.draw()
    love.graphics.clear()
    -- for i, human in ipairs(humans) do
    drawHuman(human)
    -- end
end

function love.keypressed(k)
    if k == 'escape' then
       love.event.quit()
    end
 end