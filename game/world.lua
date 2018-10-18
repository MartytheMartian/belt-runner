local collision = require("game.collision")
local resources = require("game.resources")
local weapon = require("game.weapon")

-- Exposed properties of the world
local M = {}

-- Is the level initialized
local initialized = false

-- Current frame count
local frames = 0

-- Initialize the world
function M.initialize(level)
  -- Read each graphic
  for i, graphic in ipairs(level.graphics) do
    resources.createGraphic(graphic)
  end

  -- Read each entity
  for i, entity in pairs(level.entities) do
    resources.createEntity(entity)
  end

  -- Set the world as initialized
  initialized = true
end

-- Update the world
function M.update()
  if not initialized then
    return
  end

  -- Update the frame count
  frames = frames + 1

  -- Update each entity
  for i, entity in pairs(resources.entities) do
    repeat
      -- Initialize the entity if necessary
      if not entity.initialized then
        if entity.delay <= frames then
          entity.initialize()
        else
          break
        end
      end

      -- Detect collision if necessary
      if entity.collidable then
        -- Determine if collided with something
        local collider = collision.detectCollision(entity, resources.entities)

        -- Let the entity know it collided with something
        if collider ~= nil then
          entity.collided(collider)
        end
      end

      -- Update the entity
      entity.update()
    until true
  end
end

-- Handle touch events in the world
function M.touch(x, y)
  -- Get the player
  local player = resources.entities["player"]

  -- Create a missle
  weapon.fireMissle(player.position(), {x = x, y = y})
end

-- Relase the world
function M.release()
  if not initialized then
    return
  end

  -- Release each entity
  for i, entity in ipairs(resources.entities) do
    entity.release()
  end

  -- Reset initialized status
  initialized = false
end

-- Return the world
return M
