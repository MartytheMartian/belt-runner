local M = {}

-- Menu elements
local play = nil

-- Initializes the menu
function M.initialize(startEvent)
    -- Create menu elements
    play = display.newText("Play", display.contentCenterX, 375, native.systemFont, 44)
    play:setFillColor(0.82, 0.86, 1)

    -- Hook into menu events
    play:addEventListener("tap", startEvent)
end

-- Destroys the menu
function M.destroy()
    play:removeSelf()
    play = nil
end

return M
