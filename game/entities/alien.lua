local Entity = require("game.entities.entity")
local Events = require("game.events")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
  missile = true
}

-- Create metatable
Alien = setmetatable({}, {__index = Entity})

-- Constructor
function Alien:new(properties, graphic)
  -- Create the instance
  local instance = {
    type = "alien",
    exploding = false,
    fast = false,
    collidables = collidables
  }

  -- Return new instance
  return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Alien:initialize()
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
function Alien:update()
  if not self.initialized then
    return
  end

  -- Check the current position
  local position = self.graphic.position()

  -- Slowly decrease velocity if exploding
  if self.exploding then
    -- Flip velocity if necessary
    self.vX = self.vX * .95
    self.vY = self.vY * .95
  elseif not self.fast and Events.speed then
    self.fast = true
    self.vX = self.vX * 1.5
    self.vY = self.vX * 1.5
  elseif self.fast and not Events.speed then
    self.fast = false
    self.vX = self.vX / 1.5
    self.vY = self.vY / 1.5
  end

  self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the alien to explode
function Alien:explode()
  -- Swap animations
  self.graphic.setGraphic("exploding")

  -- Play audio
  Sound.play("explosion")

  -- Set flags
  self.exploding = true
  self.collidable = false
end

-- Handles collision
function Alien:collided(entity)
  self:explode()
end

-- Release
function Alien:release()
  self.exploding = false
  Entity.release(self)
end

return Alien
