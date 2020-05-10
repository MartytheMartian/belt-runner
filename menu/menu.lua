local file = require("file")

local M = {}

-- Menu elements
local continue = nil
local newGame = nil

-- Initializes the menu
function M.initialize(startEvent)
    -- Determine if there is a game to continue
    local saveData = file.get()

    -- Create the continue button and new game button if necessary.
    -- Otherwise just create the new game button.
    if saveData then
        continue = display.newText("Continue", display.contentCenterX, 335, native.systemFont, 44)
        continue:setFillColor(0.82, 0.86, 1)
        newGame = display.newText("New Game", display.contentCenterX, 400, native.systemFont, 44)
        newGame:setFillColor(0.82, 0.86, 1)
    else
        newGame = display.newText("New Game", display.contentCenterX, 375, native.systemFont, 44)
        newGame:setFillColor(0.82, 0.86, 1)
    end

    -- Hook into menu events
    newGame:addEventListener("tap", startEvent)
end

-- Destroys the menu
function M.destroy()
    if continue then
        continue:removeSelf()
        continue = nil
    end

    newGame:removeSelf()
    newGame = nil
end

return M
