local Entity = require("game.entities.entity")

-- Create metatable
Turret = setmetatable({}, {__index = Entity})

-- Constructor
function Turret:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "turret"
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

-- Called when the world has stopped
function Turret:stop()
    self:release()
end

return Turret
