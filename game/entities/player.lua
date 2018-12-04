local Entity = require("game.entities.entity")
local Events = require("game.events")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    alien = true,
    asteroid = true,
    bomb = true,
    debris = true,
    lurcher = true,
    tentacle = true,
    wall = true
}

-- Create metatable
Player = setmetatable({}, {__index = Entity})

-- Constructor
function Player:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "player",
        exploding = false,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
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
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false

    -- Fire death event
    Events.playerDied()
end

-- Handles collision
function Player:collided(entity)
    -- Tentacle doesn't cause the player to explode
    if entity.type == "tentacle" then
        self:release()
        Events.playerDied()
    else
        self:explode()
    end
end

-- Release
function Player:release()
    self.exploding = false
    Entity.release(self)
end

return Player
