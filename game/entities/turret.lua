local Entity = require("game.entities.entity")

-- Create metatable
Turret =
    Entity:new(
    {
        type = "turret",
        destroyed = false
    }
)

-- Constructor
function Turret:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
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

-- Called when the world has stopped
function Turret:stop()
    self:release()
end

-- Release
function Turret:release()
    self.destroyed = true
    Entity.release(self)
end

return Turret
