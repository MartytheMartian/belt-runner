local composer = require("composer")
local menu = require("menu.menu")

-- Create the game scene
local scene = composer.newScene()

-- Transitions to the game
local function startGame()
    composer.gotoScene("game")
end

-- Creates the scene
function scene:create(event)
    menu.initialize(startGame)
end

-- Hides the scene
function scene:hide(event)
    if event.phase == "did" then
        composer.removeScene("menu")
        return
    end
end

-- Destroys the scene
function scene:destroy(event)
    menu.destroy()
end

-- Subscribe to scene events
scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
