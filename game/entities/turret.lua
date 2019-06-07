local Entity = require("game.entities.entity")

-- Create metatable
Turret = setmetatable({}, {__index = Entity})

-- Constructor
function Turret:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "turret",
        flying = false
    }

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

    -- Move to the center of the screen
    timer.performWithDelay(4000, function()
        self.graphic.moveTransition({ time = 1200, x = 667, y = 375, transition = easing.outSine })
    end)
end

-- Rotate the turret
function Turret:rotate(rotation)
    if not self.initialized then
        return
    end

    self.graphic.setRotation(rotation)
end

return Turret
