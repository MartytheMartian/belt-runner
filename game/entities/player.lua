local Entity = require("game.entities.entity")
local Effects = require("game.effects")
local Events = require("game.events")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    alien = true,
    asteroid = true,
    bomb = true,
    debris = true,
    lurcher = true,
    orb = true,
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
        hp = 1,
        invulnerable = 0,
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

    -- Initialize variables
    self.hp = 1
    self.invulnerable = 0
    self.initialized = true
    self.collidable = true
    self.destroyed = false

    -- Move to the center of the screen
    timer.performWithDelay(4000, function()
        self.graphic.moveTransition({ time = 1200, x = 667, y = 375, transition = easing.outSine })
    end)
end

-- Update the player
function Player:update()
    -- Reduce invulnerable frames
    if self.invulnerable > 0 then
        self.invulnerable = self.invulnerable - 1
    end
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

-- Up the shield count
function Player:shield()
    self.hp = self.hp + 1
end

-- Handles collision
function Player:collided(entity)
    -- Tentable, wall, and lurcher instantly kills player
    if entity.type == "tentacle" or entity.type == "wall" or entity.type == "lurcher" then
        self:explode()
        return
    end

    -- Invulnerable currently
    if self.invulnerable > 0 then
        return
    end

    -- Reduce hitpoints if necessary
    if self.hp > 1 then
        self.hp = self.hp - 1
        self.invulnerable = 120
        Effects.flicker(self)
        return
    end

    self:explode()
end

-- Release
function Player:release()
    self.exploding = false
    Entity.release(self)
end

return Player
