local composer = require("composer")
local game = require("game.game")

-- Create the game scene
local scene = composer.newScene()

-- Transitions to the menu
local function gotoMenu()
    composer.gotoScene("menu")
end

-- Creates the scene
function scene:create(event)
    -- Loads the game at level one
    game.load("maps/one.xml", gotoMenu)
end

-- Shows the scene
function scene:show(event)
    if event.phase == "did" then
        game.start()
        return
    end
end

-- Hides the scene
function scene:hide(event)
    if event.phase == "will" then
        game.stop()
        return
    end

    if event.phase == "did" then
        composer.removeScene("game")
        return
    end
end

-- Destroys the scene
function scene:destroy(event)
    game.destroy()
end

-- Subscribe to scene events
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
