Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- delta x means change in x (ie. determines direction and speed that ball moves along x axis)
    -- this is because on each update the ball will be redrawn at self.x plus self.dx (multplied by delta time)
    self.dx = math.random(2) == 1 and 100 or -100 
    -- delta y means change in y (ie. determines direction and speed that ball moves along y axis)
    -- this is because on each update the ball will be redrawn at self.y plus self.dy (multplied by delta time)
    self.dy = math.random(-50, 50)
end

function Ball:collides(box)
    if self.x >= box.x + box.width or self.x + self.width <= box.x then
        return false
    end
    
    if self.y >= box.y + box.height or self.y + self.height <= box.y then
        return false
    end

    return true
end

function Ball:reset(x, y)
    self.x = x-- VIRTUAL_WIDTH / 2 - 2
    self.y = y-- VIRTUAL_HEIGHT / 2 - 2

    self.dx = math.random(2) == 1 and -100 or 100 -- similar to a ternary
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    -- (x, y) of ball is redrawn at (x + dx * dt, y + dy * dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
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

    love.graphics.rectangle('fill', self.x, self.y, 5, 5)
end