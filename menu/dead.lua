local M = {}

-- Menu elements
local restart = nil
local loadout = nil
local quit = nil

-- Initializes the menu
function M.initialize(restartEvent, loadoutEvent, quitEvent)
    -- Restart button 
    restart = display.newText("Restart", display.contentCenterX, 300, native.systemFont, 44)
    restart:setFillColor(0.82, 0.86, 1)
    restart:addEventListener("tap", restartEvent)

    -- Loadout button
    loadout = display.newText("Loadout", display.contentCenterX, 375, native.systemFont, 44)
    loadout:setFillColor(0.82, 0.86, 1)
    loadout:addEventListener("tap", loadoutEvent)

    -- Quit button
    quit = display.newText("Quit", display.contentCenterX, 450, native.systemFont, 44)
    quit:setFillColor(0.82, 0.86, 1)
    quit:addEventListener("tap", quitEvent)
end

-- Destroys the menu
function M.destroy()
    restart:removeSelf()
    restart = nil

    loadout:removeSelf()
    loadout = nil

    quit:removeSelf()
    quit = nil
end

return M
