local Entity = require("game.entities.entity")
local Events = require("game.events")

-- Define a static table for collidable entities
local collidables = {
    missile = true
}

-- Power up maps
local powerMaps = {
    killAll = "killAll",
    fasterEnemies = "fasterEnemies",
    lurcher = "lurcher"
}

-- Create metatable
Crate =
    Entity:new(
    {
        type = "crate",
        exploding = false,
        destroyed = false,
        collidables = collidables,
        lurcherId = nil
    }
)

-- Constructor
function Crate:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Pull additional properties
    self.powerUp = properties.powerUp
    self.lurcherId = properties.lurcherId

    -- Return new instance
    return entity
end

-- Initialize the entity
function Crate:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("floating")

    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Update the entity
function Crate:update()
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Slowly decrease velocity if exploding
    if self.exploding then
        self.vX = self.vX * .95
        self.vY = self.vY * .95
    else
        graphic.rotate(-.2)
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the crate to explode
function Crate:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false

    -- Fire attached event
    Events[powerMaps[self.powerUp]](self)
end

-- Handles collision
function Crate:collided(entity)
    -- Explode
    self.explode()
end

-- Get the size
function Crate:size()
    if not self.initialized then
        return nil
    end

    -- Append radius
    local size = self.graphic.size()
    size.radius = size.width / 2

    return size
end

-- Release
function Crate:release()
    self.destroyed = true
    Entity.release(self)
end

return Crate
