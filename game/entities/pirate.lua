local collision = require("game.collision")
local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true
}

-- Create metatable
Pirate = setmetatable({}, {__index = Entity})

-- Constructor
function Pirate:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "pirate",
        exploding = false,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Pirate:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("alive")

    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Update the entity
function Pirate:update()
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Process events
    self:processExplosion()
    Events.processSpeed(self)
    Events.processKill(self)

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the alien to explode
function Pirate:explode()
    if self.exploding then
        return
    end

    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.collidable = false
end

-- Called when 'kill all' is triggered
function Pirate:killAll()
  self:explode()
end

-- Set to 'fast'
function Pirate:fast()
  self.vX = self.vX * 1.5
  self.vY = self.vY * 1.5
end

-- Set to normal speed
function Pirate:resetSpeed()
  self.vX = self.vX / 1.5
  self.vY = self.vY / 1.5
end

-- Continues to process exploding
function Pirate:processExplosion()
  if self.exploding then
    self.vX = self.vX * .95
    self.vY = self.vY * .95
  end
end

-- Handles collision
function Pirate:collided(entity)
    Events.addPoints(25)
    self:explode()
end

-- Release
function Pirate:release()
    self.exploding = false
    Entity.release(self)
end

return Pirate
