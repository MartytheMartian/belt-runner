local Entity = require("game.entities.entity")

-- Create metatable
MoonBottom =
    Entity:new(
    {
        type = "moonBottom"
    }
)

-- Constructor
function MoonBottom:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function MoonBottom:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    self.initialized = true
    self.stopped = false
end

-- Update the entity
function MoonBottom:update()
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

return MoonBottom
