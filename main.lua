local composer = require("composer")
local file = require("file")

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar)

-- Generate seed for random operations
math.randomseed(os.time())

-- Setup debugging
-- require("mobdebug").start()

-- Read save data
file.load()

-- Load the menu for the game
composer.gotoScene("menu")
