local Entity = require("game.entities.entity")

-- Create metatable
Nebula = setmetatable({}, {__index = Entity})

-- Constructor
function Nebula:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "nebula"
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Nebula:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    self.initialized = true
    self.stopped = false
end

-- Update the entity
function Nebula:update()
    if stopped or not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()
    local size = self.graphic.size()

    -- Release the moon if off screen
    if position.x + size.width <= 0 then
        self.release()
        return
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

return Nebula
