MainMenu = require("mainMenu")

function love.load()
    --  CONSTANTS
    --  --  OUTER LOOP STATES
    outerLoopStates = {}
    outerLoopStates.MainMenu = "mainMenu"
    outerLoopStates.InGame = "inGame"

    gameStates = {}
    gameStates.NotInGame = "notInGame"
    gameStates.GameStart = "gameStart"
    gameStates.GameUninitialized = "gameUninitialized"
    gameStates.GameInProgress = "gameInProgress"

    --  SETUP POGRAM STARTING STATE
    outerLoopState = outerLoopStates.MainMenu
    gameState = gameStates.NotInGame
    currentGame = "noGame"
end

function love.update()
    if outerLoopState == outerLoopStates.MainMenu then
        drawMainMenu = true
        MainMenu.tic()
        --  State Exit: a button press with specific menu state
    elseif outerLoopState == outerLoopStates.InGame then
        if gameState == gameStates.GameUninitialized then
            -- initializeNewGame()
            gameState = gameStates.GameStart
            --  State Exit: immediatly after initializing the game
        elseif gameState == gameStates.GameStart then
            -- gameStart()
            --  do start of game things
            --  --  game start animations?
            --  --  countdown timer?
            --  State Exit: when starting animations are finished
        elseif gameState == gameStates.GameInProgress then
            -- ticGame()
            --  tic game
            --  State Exit 1: loss condition
            --  State Exit 2: player exit
        elseif gameState == gameStates.GameLost then
            -- gameLost()
            --  State Exit: finish score animation then go to main menu
        elseif gameState == gameStates.GameQuit then
            -- gameQuit()
            --  State Exit: finish animation then go to main menu
        end
        --  State Exit: in GameLost or GameQuit
    end
end

function love.draw()
    if drawMainMenu then
        MainMenu.draw()
    end
    if drawGameStart then
        -- drawGameStart()
    end
    if drawGame then
        -- drawGame()
    end
    if drawGameOver then
        -- drawGameOver()
    end
end