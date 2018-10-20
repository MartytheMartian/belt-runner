local game = require("game.game")

-- Generate seed for random operations
math.randomseed(os.time())

-- Setup debugging
-- require("mobdebug").start()

-- Because I feel like it
display.setDefault("textureWrapX", "repeat")

-- Start the game at level one
game.start("maps/one.xml")
