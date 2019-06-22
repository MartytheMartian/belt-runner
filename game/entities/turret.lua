local Entity = require("game.entities.entity")
local Static = require("game.graphics.static")

-- Create metatable
Turret = setmetatable({}, {__index = Entity})

-- Constructor
function Turret:new(properties)
    -- Create the instance
    local instance = {
        type = "turret",
        flying = false
    }

    -- Create the graphic
    local graphic = Static({
        id = "turret",
        type = "static",
        path = "sprites/turret.png",
        width = 54,
        height = 37
    })(properties)

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Turret:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    -- Initialize variables
    self.initialized = true
    self.destroyed = false
end

-- Rotate the turret
function Turret:rotate(rotation)
    if not self.initialized then
        return
    end

    self.graphic.setRotation(rotation)
end

return Turret
