local Entity = require("game.entities.entity")
local Events = require("game.events")

-- Define a static table for collidable entities
local collidables = {
    asteroid = true,
    debris = true,
    alien = true,
    tentacle = true,
    lurcher = true
}

-- Create metatable
Player =
    Entity:new(
    {
        type = "player",
        exploding = false,
        destroyed = false,
        collidables = collidables
    }
)

-- Constructor
function Player:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Player:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("alive")

    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Cause the alien to explode
function Player:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false

    -- Fire death event
    Events.playerDied()
end

-- Handles collision
function Player:collided(entity)
    self.explode()
end

-- Release
function Player:release()
    self.exploding = false
    self.destroyed = true
    Entity.release(self)
end

return Player
