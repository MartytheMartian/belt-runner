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

    self.initialized = true
    self.destroyed = false
end

-- Update the entity
function Turret:update()
    if not self.initialized or not self.flying then
        return
    end

    local position = self.graphic.position()

    self.graphic.rotate(10)
    self.graphic.move(position.x + self.vX, position.y + self.vY)
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
    self.vX = 10
    self.vY = -6
    self.flying = true
end

return Turret
