local Entity = require("game.entities.entity")

-- Create metatable
Background =
    Entity:new(
    {
        type = "background"
    }
)

-- Constructor
function Background:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Background:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    self.initialized = true
end

-- Update the entity
function Background:update()
    if self.stopped or not self.initialized then
        return
    end

    -- Scroll
    self.graphic.scroll(self.vX)
end

return Background
