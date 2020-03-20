local Collision = require("game.collision")
local Common = require("game.common")
local Entity = require("game.entities.entity")
local Events = require("game.events")
local Sound = require("game.sound")
local Weapon = require("game.weapon")

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
    collidables = collidables,
    lastFire = 120,
    visible = false
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
  if not self.initialized or self.destroyed then
    return
  end

  -- Check the current position
  local position = self.graphic.position()
  local size = self.graphic.size()

  -- Check if on screen
  self.visible = Collision.onScreen(position.x, position.y, size.width, size.height)

  -- Process events if on screen
  if self.visible then
    self:processExplosion()
    self:processFire()
    Events.processSpeed(self)
    Events.processKill(self)

    -- Destroy it when off-screen only after its been on screen once
    if not Collision.onScreen(position.x, position.y, size.width, size.height) then
      self.collidable = false
      self.destroyed = true
      self.visible = false
      return
    end
  end

  -- Move
  self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the alien to explode
function Alien:explode()
  -- Do nothing if already exploding
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
function Alien:killAll()
  self:explode()
end

-- Set to 'fast'
function Alien:fast()
  self.vX = self.vX * 1.5
  self.vY = self.vY * 1.5
end

-- Set to normal speed
function Alien:resetSpeed()
  self.vX = self.vX / 1.5
  self.vY = self.vY / 1.5
end

-- Fires an orb if it is time
function Alien:processFire()
  -- Back out if exploding
  if self.exploding then
    return
  end

  -- Count down to next fire
  self.lastFire = self.lastFire - 1

  -- Back out if not time
  if self.lastFire ~= 0 then
    return
  end

  -- Get the resources from common
  local resources = Common.getResources()

  -- Prepare to read an orb
  local orb = nil

  -- Find the next available orb entity
  for i = 1, 10 do
    repeat
      local next = Resources.getEntityByID("O" .. i)

      -- Not available if not destroyed
      if not next.destroyed then
        break
      end

      -- Ready
      orb = next
    until true
  end

  -- Do nothing if there are no available orbs
  if orb == nil then
    return
  end

  -- Fire the orb. Velocity is only used for direction, so use the alien's velocity.
  local position = self:position()
  Weapon.fireOrb(orb, self:position(), self.vX);
  
  -- Reset shot clock
  self.lastFire = 120
end

-- Continues to process exploding
function Alien:processExplosion()
  if self.exploding then
    self.vX = self.vX * .95
    self.vY = self.vY * .95
  end
end

-- Handles collision
function Alien:collided(entity)
  Events.addPoints(25)
  self:explode()
end

-- Release
function Alien:release()
  self.exploding = false
  Entity.release(self)
end

return Alien
