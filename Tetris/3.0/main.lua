function love.load()
    love.window.setMode(600, 600, {resizable=true, vsync=0, minwidth=400, minheight=580})
    love.graphics.setBackgroundColor(0.7, 0.7, 0.7)
    love.graphics.setFont(love.graphics.newFont("PIXELADE.ttf", 30))
    love.window.setTitle('Tetris')
    love.keyboard.setKeyRepeat(true)

    columns = 10
    rows = 22

    staticBlocks = {}
    for y = 1, rows do
        staticBlocks[y] = {}
        for x = 1, columns do
            staticBlocks[y][x] = ' '
        end
    end
    
    tetrominoes = {
        {
            {
                {' ', 'w', 'w', ' '},
                {' ', 'w', 'w', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {'q', 'q', 'q', 'q'},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
                {' ', 'q', ' ', ' '},
            },
        },
        {
            {
                {'e', 'e', 'e', ' '},
                {' ', ' ', 'e', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'e', ' ', ' '},
                {' ', 'e', ' ', ' '},
                {'e', 'e', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'e', ' ', ' ', ' '},
                {'e', 'e', 'e', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'e', 'e', ' '},
                {' ', 'e', ' ', ' '},
                {' ', 'e', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {'r', 'r', 'r', ' '},
                {'r', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', 'r', 'r', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', ' ', 'r', ' '},
                {'r', 'r', 'r', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'r', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', 'r', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', 't', 't', ' '},
                {'t', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'t', ' ', ' ', ' '},
                {'t', 't', ' ', ' '},
                {' ', 't', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {'u', 'u', ' ', ' '},
                {' ', 'u', 'u', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'u', ' ', ' '},
                {'u', 'u', ' ', ' '},
                {'u', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {'y', 'y', 'y', ' '},
                {' ', 'y', ' ', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'y', ' ', ' '},
                {' ', 'y', 'y', ' '},
                {' ', 'y', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'y', ' ', ' '},
                {'y', 'y', 'y', ' '},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'y', ' ', ' '},
                {'y', 'y', ' ', ' '},
                {' ', 'y', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
    }

    currenttetrominoType = 1
    currentRotation = 1

    posX = 3
    posY = 0

    timer = 0
    timerLimit = 0.7

    tetrominoesWidth = 4
    tetrominoesHeight = 4

    score = 0
    gameEnded = false

    function randomSequence()
        newSequence = {}
        for tetrominoTypeIndex = 1, #tetrominoes do
            local position = love.math.random(#newSequence + 1)
            table.insert(newSequence, position, tetrominoTypeIndex)
        end
    end
    randomSequence()

    function newPiece()
        posX = 3
        posY = 0
        tetrominoRotation = 1
        tetrominoType = table.remove(newSequence)

        if #newSequence == 0 then
            randomSequence()
        end
    end
    newPiece()

    function isMovingPossible(testX, testY, testRotation) -- collision detection
        for y = 1, tetrominoesHeight do
            for x = 1, tetrominoesWidth do
                local testBlockX = testX + x
                local testBlockY = testY + y

                if tetrominoes[tetrominoType][testRotation][y][x] ~= ' ' and ( -- if part of the tetromino that we are currently checking is not empty
                    testBlockX < 1 --left wall
                    or testBlockY > rows    -- bottom wall 
                    or testBlockX > columns  -- right wall 
                    or staticBlocks[testBlockY][testBlockX] ~= ' '  -- other tetrominoes 
                ) then
                    return false
                end
            end
        end

        return true
    end


    function restart()
        timer = 0
        timerLimit = 0.7
        score = 0
        gameEnded = false

        staticBlocks = {}
        for y = 1, rows do
            staticBlocks[y] = {}
            for x = 1, columns do
                staticBlocks[y][x] = ' '
            end
        end

        randomSequence()
        newPiece()

    end
    restart()

end

function love.update(dt)
    timer = timer + dt
    if timer >= timerLimit then
        timer = 0

        local testY = posY + 1
        if isMovingPossible(posX, testY, tetrominoRotation) then
            posY = testY
        else 
            -- adding tetromino to staticBlocks when it cannot move anymore
            for y = 1, tetrominoesHeight do
                for x = 1, tetrominoesWidth do
                    local block = tetrominoes[tetrominoType][tetrominoRotation][y][x]
                    if block ~= ' ' then
                        staticBlocks[posY + y][posX + x] = block
                    end
                end
            end

            -- finding completed rows
            for y = 1, rows do
                local complete = true
                for x = 1, columns do
                    if staticBlocks[y][x] == ' ' then
                        complete = false
                        break
                    end
                end

                if complete then
                    for removeY = y, 2, -1 do
                        for removeX = 1, columns do
                            staticBlocks[removeY][removeX] = staticBlocks[removeY - 1][removeX]
                        end
                    end

                    for removeX = 1, columns do
                        score = score + 1 

                        if(timerLimit>0.15) then
                            timerLimit = timerLimit - 0.001 
                        end
                        staticBlocks[1][removeX] = ' '
                    end

                end
            end

            if gameEnded == false then
                newPiece()
            end

            if not isMovingPossible(posX, posY, tetrominoRotation) then
                gameEnded = true --game over
            end
        end
    end
end

function love.draw()

    local function drawTetromino(block, x, y)
        local colors = {
            q = {0.81, 0.61, 0.99}, -- violet
            w = {0.44, 0.98, 0.98}, -- blue
            e = {0.54, 0.98, 0.40}, -- green
            r = {0.97, 0.97, 0.41}, -- yellow
            t = {0.97, 0.84, 0.41}, -- orange
            y = {0.98, 0.61, 0.96}, -- pink
            u = {0.05, 0.97, 0.81}, -- turquoise
            [' '] = {0.91, 0.91, 0.91},
            nextBlockColor = {0.87, 0.87, 0.87}, 
        }
        
        local color = colors[block]
        love.graphics.setColor(color)

        local blockSize = 22
        local blockDrawSize = blockSize - 1
        love.graphics.rectangle('fill', (x - 1) * blockSize, (y - 1) * blockSize, blockDrawSize, blockDrawSize)
    end

    love.graphics.print("points: " .. score, 400, 90)
    love.graphics.print("speed: " .. 1-timerLimit, 400, 120)

    love.graphics.print("rotate: arrow up", 390, 420)
    love.graphics.print("movement: arrows", 390, 445)
    love.graphics.print("drop: spacebar ", 390, 470)
    love.graphics.print("restart: r ", 390, 495)
   -- love.graphics.print("save game: s ", 390, 520)
    --love.graphics.print("load game: l ", 390, 545)
    
    local offsetX = 5
    local offsetY = 4

    for y = 1, rows do
        for x = 1, columns do
            drawTetromino(staticBlocks[y][x], x + offsetX, y + offsetY)
        end
    end

    for y = 1, tetrominoesHeight do
        for x = 1, tetrominoesWidth do
            local block = tetrominoes[tetrominoType][tetrominoRotation][y][x]
            if block ~= ' ' then
                drawTetromino(block, x + posX + offsetX, y + posY + offsetY)
            end
        end
    end

    for y = 1, tetrominoesHeight do
        for x = 1, tetrominoesWidth do
            local block = tetrominoes[newSequence[#newSequence]][1][y][x]
            if block ~= ' ' then
                drawTetromino('nextBlockColor', x + 8, y + 1)
            end
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'up' then
        local testRotation = tetrominoRotation + 1
        if testRotation > #tetrominoes[tetrominoType] then
            testRotation = 1
        end

        if isMovingPossible(posX, posY, testRotation) then
            tetrominoRotation = testRotation
        end

    elseif key == 'space' then
        while isMovingPossible(posX, posY + 1, tetrominoRotation) do
            posY = posY + 1
            timer = timerLimit
        end
    
    elseif key == 'down' then
        local testY = posY + 1
        if isMovingPossible(posX, posY + 1, tetrominoRotation) then
            posY = posY + 1
        end

    elseif key == 'left' then
        local testX = posX - 1

        if isMovingPossible(testX, posY, tetrominoRotation) then
            posX = testX
        end

    elseif key == 'right' then
        local testX = posX + 1

        if isMovingPossible(testX, posY, tetrominoRotation) then
            posX = testX
        end

    elseif key == 'r' then
        restart()
        
    end
end