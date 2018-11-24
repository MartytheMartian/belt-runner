-- local resources = require("game.resources")
local gameAudio = require("game.sounds")
local weapon = require("game.weapon")
local collision = require("game.collision")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true
}

-- Create a pirate
function pirate(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "pirate"
  M.initialized = false
  M.collidable = false
  M.shape = "rectangle"
  M.increasedSpeedPowerupActivated = false
  M.increasedSpeedPowerupActivatedSet = false
  M.originalvX = properties.vX
  M.originalvY = properties.vY

  local exploding = false
  local shotFired = false
  local increasedSpeedPowerupActivated = false
  local originalvX = properties.vX
  local originalvY = properties.vY

  -- Initialize the pirate
  function M.initialize()
    if M.initialized then
      return
    end

    -- Flying
    graphic.initialize("alive")

    -- Set flags
    M.collidable = true
    M.initialized = true
  end

  -- Update the pirate
  function M.update()
    if not M.initialized then
      return
    end

    -- Check the current position
    local position = graphic.position()

    -- Slowly decrease velocity if exploding
    if exploding then
      properties.vX = properties.vX * .95
      properties.vY = properties.vY * .95
    end

    -- Fire the shot if necessary
    -- if not shotFired and position.x > 750 then
    --   local missleSetup = weapon.createMissle("P1")
    --   local missle = resources.
    --   weapon.fireMissle(position, { x = 667, y = 750 }, missle)
    --   shotFired = true
    -- end

    graphic.move(position.x + properties.vX, position.y + properties.vY)
  end

  -- Do anything that needs to be done if the world has stopped moving
  function M.handleWorldStoppedMoving()
  end

  -- Do anything that needs to be done if a powerup affecting this entity is activated
  function M.handleCratePowerActivated(powerUpName)
    local isActive = false
    local onScreen = false

    if M.initialized and not M.destroyed then
      isActive = true
      local position = graphic.position()
      local size = graphic.size()
      onScreen = collision.onScreen(position.x, position.y, size.width, size.height)
    --print("onScreen " .. onScreen)
    end

    if (powerUpName == "killAll" and onScreen and isActive) then
      graphic.setGraphic("exploding")
      exploding = true
      M.destroyed = true
      M.collidable = false
    elseif (powerUpName == "fasterEnemies") then
      M.setPowerUpIncreasedSpeed()
    elseif (powerUpName == "normalSpeedEnemies") then
      M.setNormalSpeed()
    end
  end

  function M.setPowerUpIncreasedSpeed()
    M.increasedSpeedPowerupActivated = true
    M.increasedSpeedPowerupActivatedSet = false
  end

  function M.setNormalSpeed()
    M.increasedSpeedPowerupActivated = false
    M.increasedSpeedPowerupActivatedSet = false
    --properties.vX = M.originalvX
    --properties.vY = M.originalvY
  end

  -- Gets the position
  function M.position()
    if not M.initialized then
      return nil
    end

    return graphic.position()
  end

  -- Gets the size
  function M.size()
    if not M.initialized then
      return nil
    end

    return graphic.size()
  end

  -- Can this entity collide with a given type
  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the pirate has collided with something
  function M.collided(entity)
    -- No longer collidable
    M.collidable = false

    -- Explode
    graphic.setGraphic("exploding")

    -- Play explosion sound
    gameAudio.playBasicExplosionSound()

    -- Mark as exploding
    exploding = true
    M.destroyed = true
    M.collidable = false
  end

  -- Release the pirate
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return pirate
