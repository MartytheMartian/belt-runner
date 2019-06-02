local composer = require("composer")
local dead = require("menu.dead")

-- Create the menu scene
local scene = composer.newScene()

-- Transitions to the game
local function restartGame()
    composer.gotoScene("game")
end

-- Transitions to the main menu
local function goToMenu()
    composer.gotoScene("menu")
end

-- Creates the scene
function scene:create(event)
    dead.initialize(restartGame, goToMenu)
end

-- Hides the scene
function scene:hide(event)
    if event.phase == "did" then
        composer.removeScene("dead")
        return
    end
end

-- Destroys the scene
function scene:destroy(event)
    dead.destroy()
end

-- Subscribe to scene events
scene:addEventListener("create", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
