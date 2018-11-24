local gameAudio = require("game.sounds")
local collision = require("game.collision")

-- Entities that this entity can collide with
local collidableEntities = {
  missle = true,
  player = true
}

-- Create a asteroid
function asteroid(properties, graphic)
  local M = {}

  M.id = properties.id
  M.type = "asteroid"
  M.initialized = false
  M.collidable = false
  M.shape = "circle"
  M.increasedSpeedPowerupActivated = false
  M.increasedSpeedPowerupActivatedSet = false
  M.originalvX = properties.vX
  M.originalvY = properties.vY

  local exploding = false

  -- Initialize the asteroid
  function M.initialize()
    if M.initialized then
      return
    end

    graphic.initialize("floating")

    M.collidable = true
    M.initialized = true
  end

  -- Update the asteroid
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
    else
      graphic.rotate(3)
    end

    -- Set increased speed because of crate power up if needed
    if M.increasedSpeedPowerupActivated and not M.increasedSpeedPowerupActivatedSet then
      print("sped up asteroid in update")
      M.increasedSpeedPowerupActivatedSet = true
      properties.vX = properties.vX * 1.50
      properties.vY = properties.vY * 1.50
    end

    -- Move it
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
      graphic.setSequence("exploding")
      exploding = true
      M.destroyed = true
      M.collidable = false
    elseif (powerUpName == "fasterEnemies") then
      print("asteroid faster enemies power up detected")
      M.setPowerUpIncreasedSpeed()
    elseif (powerUpName == "normalSpeedEnemies") then
      print("asteroid normal speed power up detected")
      M.setNormalSpeed()
    end
  end

  function M.setPowerUpIncreasedSpeed()
    M.increasedSpeedPowerupActivated = true
    M.increasedSpeedPowerupActivatedSet = false
  end

  function M.setNormalSpeed()
    print("normal speed asteroid set")
    M.increasedSpeedPowerupActivated = false
    M.increasedSpeedPowerupActivatedSet = false
    properties.vX = M.originalvX
    properties.vY = M.originalvY
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

    -- Append radius
    local size = graphic.size()
    size.radius = size.width / 2

    return size
  end

  function M.canCollide(type)
    if not M.collidable then
      return false
    end

    return collidableEntities[type] ~= nil
  end

  -- Called when the asteroid has collided with something
  function M.collided(entity)
    -- No longer collidable
    M.collidable = false

    -- Explode
    graphic.setSequence("exploding")

    -- Play asteroid explosion sound
    gameAudio.playBasicExplosionSound()

    -- Mark as exploding
    exploding = true
  end

  -- Release the asteroid
  function M.release()
    if not M.initialized then
      return
    end

    graphic.release()

    M.initialized = false
  end

  return M
end

return asteroid
