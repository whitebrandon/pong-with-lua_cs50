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


-- Imports
Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

-- Constants

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

BALL_START_X = VIRTUAL_WIDTH / 2 - 2
BALL_START_Y = VIRTUAL_HEIGHT / 2 - 2

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

    love.window.setTitle("Pong")

    smallFont = love.graphics.newFont('font.ttf', 8)

    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- initializes player scores to 0
    player1Score = 0
    player2Score = 0

    -- x = a (?/and) b (:/or) c | if math.random() generates 1, then servingPlayer is 1 else servingPlayer is 2
    servingPlayer = math.random(2) -- == 1 and 1 or 2 

    -- creates Paddles instances
    paddle1 = Paddle(10, 30, 5, 20)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- creates Ball instance
    ball = Ball(BALL_START_X, BALL_START_Y, 5, 5)

    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = false,
    })
end

function love.update(dt) -- dt stands for delta time

    if gameState == 'play' then

        -- this denotes ball has exited screen left
        if ball.x <= 0 then
            player2Score = player2Score + 1
            servingPlayer = 1
            ball:reset(BALL_START_X, BALL_START_Y)
            ball.dx = 100
            gameState = 'serve'
        end

        -- this denotes ball has exited screen right
        if ball.x >= VIRTUAL_WIDTH - 5 then
            player1Score = player1Score + 1
            servingPlayer = 2
            ball:reset(BALL_START_X, BALL_START_Y)
            ball.dx = -100
            gameState = 'serve'
        end

        -- detect ball collision with paddles, reversing dx if true and
        -- slightly increasing it, then altering the dy based on the position of collision
        if ball:collides(paddle1) then
            -- deflect ball to the right
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1.x + 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(paddle2) then
            -- deflect ball to the left
            ball.dx = -ball.dx * 1.03
            ball.x = paddle2.x - 5

            -- keep velocity going in the same direction, but randomize it
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.y <= 0 then
            -- deflect the ball down
            ball.dy = -ball.dy
            ball.y = 0
        end

        if ball.y >= VIRTUAL_HEIGHT - 5 then
            ball.dy = -ball.dy
            ball.y = ball.y - 5
        end

        -- calculates player 1 movement
        if love.keyboard.isDown('w') then
            paddle1.dy = -PADDLE_SPEED 
        elseif love.keyboard.isDown('s') then
            paddle1.dy = PADDLE_SPEED
        else
            paddle1.dy = 0
        end

        -- calculates player 2 movement
        if love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED 
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
        else
            paddle2.dy = 0
        end

        paddle1:update(dt) -- updates player 1 movement
        paddle2:update(dt) -- updates player 2 movement

        -- ball movement
        if gameState == 'play' then
            ball:update(dt)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        -- TOGGLES gamestate
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
            --ball:reset(BALL_START_X, BALL_START_Y) -- removing reset from here as it's set in update
        end
    end
end


--[[ 
    Called after updated by LÖVE, used to draw anything to the screen, updated or otherwise.
 ]]

function love.draw()
    push:apply('start')

        love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255) -- creates a grey-ish game screen

        -- ============== PRINTS BANNER MESSAGE DEPENDING ON GAME STATE ================== --
        love.graphics.setFont(smallFont)

        if gameState == 'start' then
            love.graphics.printf("Welcome to Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Press Enter to Play!", 0, 32, VIRTUAL_WIDTH, 'center')
        elseif gameState == 'serve' then
            love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve" , 0, 20, VIRTUAL_WIDTH, 'center')
            love.graphics.printf("Press Enter to Serve!", 0, 32, VIRTUAL_WIDTH, 'center')
        end

        --[[ if gameState == 'start' then
            love.graphics.printf(
                "Hello Pong!",          -- text to render
                0,                      -- starting X (0 since we're going to center it based on width)
                20,                     -- starting Y (20 pixels down the screen)
                VIRTUAL_WIDTH,          -- number of pixels to center within (the entire screen here)
                'center')               -- alignment mode, can be 'center', 'left', 'right'
        elseif gameState == 'play' then
            love.graphics.printf(
                "Hello Play State!",
                0,
                20,
                VIRTUAL_WIDTH,
                'center')  
        end ]]

        -- =========================== PRINTS PLAYER SCORES ============================== --
        love.graphics.setFont(scoreFont) -- resets font
        love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

        -- =========================== RENDER GAME OBJECTS ============================== --
        -- renders ball, center
        ball:render()
        -- render first paddle (left side)
        paddle1:render()
        -- render second paddle (right side)
        paddle2:render()

        displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()))
end