local M = {}

function M.getConstrainedPos(topFract, botFract, leftFract, rightFract)
    local w = love.graphics.getWidth()
    local h = love.hraphics.getHeight()
    local left = w * leftFract
    local right = w - w * rightFract
    local top = h * topFract
    local bottom = h - h * botFract
    
    local pos = {}
    pos.tl = {}
    pos.tl.x = left
    pos.tl.y = top
    pos.br.x = right
    pos.br.y = bottom
    
    return pos
end

function M.constrainComponents()
end

function M.createButton(text, topFract, botFract, leftFract, rightFract)
    local button = {}
    button.text = text
    button.pos = M.getConstrainedPos(topFract, botFract, leftFract, rightFract)
end

function M.init()
    --  menu state values
    M.setup = false
    
    --  create buttons
    M.buttons = {}
    M.createButton()

    --  set default selected menu option
    M.selectedButton = "play"

    M.setup = true
end

function M.tic()
    if not M.setup then
        M.init()
        M.setup = true
    end
    M.constrainComponents()
    
    --  check if mouse is hovering buttons
    M.
    --  --  set hovered buttons

end

function M.draw()
    

    print("draw")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 50, 50, 100, 200)
end

return M