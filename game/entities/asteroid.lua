local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
  missile = true,
  player = true
}

-- Create metatable
Asteroid = setmetatable({}, {__index = Entity})

-- Constructor
function Asteroid:new(properties, graphic)
  -- Create the instance
  local instance = {
    type = "asteroid",
    exploding = false,
    collidables = collidables,
    shape = "circle"
  }

  -- Return new instance
  return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Asteroid:initialize()
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
function Asteroid:update()
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
    self.graphic.rotate(3)
  end

  -- Move it
  self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the asteroid to explode
function Asteroid:explode()
  -- Swap animations
  self.graphic.setSequence("exploding")

  -- Play audio
  Sound.play("explosion")

  -- Set flags
  self.exploding = true
  self.collidable = false
end

-- Handles fast enemy powerup calls
function Asteroid:fast()
  self.vX = self.vX * 1.5
  self.vY = self.vY * 1.5
end

-- Handles fast enemy powerup calls
function Asteroid:slow()
  self.vX = self.vX / 1.5
  self.vY = self.vY / 1.5
end

-- Handles 'kill all' powerup calls
function Asteroid:killAll()
  self:explode()
end

-- Handles collision
function Asteroid:collided(entity)
  self:explode()
end

-- Get the size
function Asteroid:size()
  if not self.initialized then
    return nil
  end

  local size = self.graphic.size()
  size.radius = size.width / 2

  return size
end

return Asteroid
