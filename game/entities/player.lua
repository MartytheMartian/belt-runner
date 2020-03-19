local Effects = require("game.effects")
local Entity = require("game.entities.entity")
local Turret = require("game.entities.turret")
local Events = require("game.events")
local Emitter = require("game.graphics.emitter")
local Sound = require("game.sound")

-- Create the afterburner emitter creator
local afterburnerFactory = Emitter("emitters/afterburners.json")

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
        collidables = collidables,
        afterburner = afterburnerFactory(),
        group = nil,
        turret = Turret:new(properties)
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Player:initialize()
    if self.initialized then
        return
    end

    -- Initialize the children
    self.afterburner.initialize()
    self.graphic.initialize("alive")
    self.turret:initialize()

    -- Initialize variables
    self.hp = 1
    self.invulnerable = 0
    self.initialized = true
    self.collidable = true
    self.destroyed = false

    -- Create a group for the player and its children
    self.group = display.newGroup()
    self.group:insert(self.afterburner.emitter())
    self.group:insert(self.graphic.sprite())
    self.group:insert(self.turret.graphic.sprite())

    -- Set the group the in the current position and adjust the position
    local position = self.graphic.position()
    self.group.x = position.x
    self.group.y = position.y
    self.graphic.move(0, 0)
    self.afterburner.move(-60, 0)
    self.turret.graphic.move(0, 0)

    -- Move to the center of the screen
    timer.performWithDelay(4000, function()
        transition.moveTo(self.group, { time = 1200, x = 667, y = 375, transition = easing.outSine })
    end)
end

-- Get the player position
function Player:position()
    return {
        x = self.group.x,
        y = self.group.y
    }
end

-- Update the player
function Player:update()
    -- Reduce invulnerable frames
    if self.invulnerable > 0 then
        self.invulnerable = self.invulnerable - 1
    end

    -- Do nothing if dead
    if self.destroyed then
        return
    end

    -- Move
    self.group.x = self.group.x + self.vX
    self.group.y = self.group.y + self.vY
end

-- Fire sequence
function Player:fire()
    -- Rotate the turret
    self.turret:rotate()
end

-- Cause the player to explode
function Player:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")
    self.graphic.move(667, 375)

    -- Play audio
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
    self.turret:release()
    self.afterburner:release()

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

-- Handles exit
function Player:exit()
    -- Don't allow collisions
    self.collidable = false

    -- Play the sound effect for departure
    Sound.play("depart")

    -- Wait 3.69 seconds then take off.
    -- This corresponds to the audio in the effect sound clip.
    timer.performWithDelay(3690, function()
        transition.moveTo(self.group, { time = 500, x = 1550, y = 375, transition = easing.outSine })
    end)
end

-- Release
function Player:release()
    self.exploding = false
    self.afterburner:release()
    self.turret:release();
    Entity.release(self)
end

return Player
