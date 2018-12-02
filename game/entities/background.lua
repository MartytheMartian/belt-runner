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
    entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
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
