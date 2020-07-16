--[[
    GD50 2018
    Pong Remake

    pong-12
    "The Resize Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Originally programmed by Atari in 1972. Features two
    paddles, controlled by players, with the goal of getting
    the ball past your opponent's edge. First to 10 points wins.

    This version is built to more closely resemble the NES than
    the original Pong machines or the Atari 2600 in terms of
    resolution, though in widescreen (16:9) so it looks nicer on 
    modern systems.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
--
-- https://github.com/Ulydev/push
push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

--[[ 
    Runs when the game first starts up, only once; used to initialize the game.
 ]]
function love.load()
    --[[ love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false
    }) ]]
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and -100 or 100 -- similar to a ternary
    ballDY = math.random(-50, 50)

    gameState = 'start'

    -- love.graphics.setFont(smallFont)
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false,
    })
end

function love.update(dt) -- dt stands for delta time
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and -100 or 100 -- similar to a ternary
            ballDY = math.random(-50, 50)
        end
    end
end


--[[ 
    Called after updated by LÖVE, used to draw anything to the screen, updated or otherwise.
 ]]

function love.draw()
    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- creates a grey-ish game screen

    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf(
            "Hello Pong!",          -- text to render
            0,                      -- starting X (0 since we're going to center it based on width)
            20,                     -- starting Y (20 pixels down the screen)
            VIRTUAL_WIDTH,          -- number of pixels to center within (the entire screen here)
            'center')               -- alignment mode, can be 'center', 'left', 'right'
    elseif gameState == 'play' then
        love.graphics.printf(
            "Hello Play State!",          -- text to render
            0,                      -- starting X (0 since we're going to center it based on width)
            20,                     -- starting Y (20 pixels down the screen)
            VIRTUAL_WIDTH,          -- number of pixels to center within (the entire screen here)
            'center')  
    end

    love.graphics.setFont(scoreFont)
    love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- renders ball, center
    love.graphics.rectangle('fill', ballX, ballY, 5, 5)

    -- =========================== RENDER THE PADDLES ============================== --

    -- love.graphics.rectangle( mode, x, y, width, height )

    --[[ 
        Arguments
            DrawMode mode
                How to draw the rectangle.
            number x
                The position of top-left corner along the x-axis.
            number y
                The position of top-left corner along the y-axis.
            number width
                Width of the rectangle.
            number height
                Height of the rectangle.
            Returns
                Nothing.
     ]]

--[[      player1Y = 30
     player2Y = VIRTUAL_HEIGHT - 50 ]]

    -- render first paddle (left side)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20) -- 
    -- render second paddle (right side)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20) --

    push:apply('end')
end
