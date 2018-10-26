local game = require("game.game")

-- Generate seed for random operations
math.randomseed(os.time())

-- Setup debugging
-- require("mobdebug").start()

-- Start the game at level one
game.start("maps/one.xml")
