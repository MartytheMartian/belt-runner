local game = require("game")

math.randomseed(os.time())
require("mobdebug").start();

-- local x = "<object type=\"asteroid\" x=\"156\" y=\"418\"/>"
-- for i=1,1000 do
--   print("<object type=\"asteroid\" x=\"" .. math.random(1400, 6000) .. "\" y=\"" .. math.random(50, 750) .. "\"/>")
-- end

game.start("maps/one.xml")
