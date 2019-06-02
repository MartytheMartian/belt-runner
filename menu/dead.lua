local M = {}

-- Menu elements
local restart = nil
local quit = nil

-- Initializes the menu
function M.initialize(restartEvent, quitEvent)
    -- Restart button 
    restart = display.newText("Restart", display.contentCenterX, 340, native.systemFont, 44)
    restart:setFillColor(0.82, 0.86, 1)
    restart:addEventListener("tap", restartEvent)

    -- Quit button
    quit = display.newText("Quit", display.contentCenterX, 410, native.systemFont, 44)
    quit:setFillColor(0.82, 0.86, 1)
    quit:addEventListener("tap", quitEvent)
end

-- Destroys the menu
function M.destroy()
    restart:removeSelf()
    restart = nil

    quit:removeSelf()
    quit = nil
end

return M
