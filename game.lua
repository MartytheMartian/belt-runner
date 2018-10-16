-- External references
local xml = require("xml").newParser()
local asteroid = require("asteroid")
local background = require("background")
local common = require("common")
local missle = require("missle")
local player = require("player")
local turret = require("turret")

-- Export object
local M = {}

-- Map table for entity constructors
local entityConstructors = {
  asteroid = asteroid
}

-- Initialize the level
local function initialize(level)
  -- Read the map XML file
  local mapFile = xml:loadFile(level)

  -- Initialize the variables
  local assets = {}

  -- Gather all assets
  for i, asset in ipairs(mapFile.child[1].child) do
    -- Store assets in a table keyed on type
    assets[asset.properties.type] = asset.properties
  end

  -- Loop through each layer to get the objects
  for i, layer in ipairs(mapFile.child[2].child) do
    -- Store entities in layers
    for j, object in ipairs(layer.child) do
      -- Increment the loaded entity count
      common.entityCount = common.entityCount + 1

      -- Extract the object properties and asset
      local properties = object.properties
      local asset = assets[properties.type]

      -- Build the entity and add it
      common.entities[common.entityCount] = entityConstructors[properties.type](asset, properties)
    end
  end

  -- Load the background up
  common.background = background()

  -- Load the player up
  common.player = player()

  -- Load the turret up
  common.turret = turret()
end

-- Updates crap
local function update(event)
  -- Update the world time
  common.frames = common.frames + 1

  -- Loop through each entity and process it
  for i, entity in ipairs(common.entities) do
    entity.update()
  end

  -- Update the player and turret
  common.background.update()
  common.player.update()
  common.turret.update()
end

-- Handle touch events
local function touch(event)
  -- Ignore if player is dead
  if not common.player.alive() then
    return
  end

  -- Create missle properties
  local properties = {
    x = 670,
    y = 375,
    vX = 0,
    vY = 0
  }

  -- Set destination
  local destination = {
    x = event.x,
    y = event.y
  }

  -- Calculate velocity
  local velocity = common.calculateVelocity(properties, destination, 18)
  properties.vX = velocity.x
  properties.vY = velocity.y

  -- Calculate rotation
  properties.rotation = common.calculateRotation(properties, destination)

  -- Determine missle index
  common.entityCount = common.entityCount + 1

  -- Spawn missle
  common.entities[common.entityCount] = missle(properties)

  -- Set turret rotation to match the missle
  common.turret.rotate(properties.rotation)
end

-- Start the target level
function M.start(level)
  -- Initialize the game with the map
  initialize(level)

  -- Render the game
  Runtime:addEventListener("enterFrame", update)

  -- Listen for user interaction
  Runtime:addEventListener("touch", touch)
end

return M
