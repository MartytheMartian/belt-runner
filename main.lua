local composer = require("composer")

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Generate seed for random operations
math.randomseed(os.time())

-- Setup debugging
-- require("mobdebug").start()

-- Load the menu for the game
composer.gotoScene("menu")
