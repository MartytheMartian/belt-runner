local game = require("game");

math.randomseed(os.time());
require("mobdebug").start();

game.start("maps/one.xml");