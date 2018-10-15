-- External references
local xml = require("xml").newParser()
local asteroid = require("asteroid")
local player = require("player")

-- Export object
local M = {}

-- Variables
local entities = {}

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

  -- Keep track of the entity count
  local entityCount = 0

  -- Loop through each layer to get the objects
  for i, layer in ipairs(mapFile.child[2].child) do
    -- Store entities in layers
    for j, object in ipairs(layer.child) do
      -- Increment the loaded entity count
      entityCount = entityCount + 1

      -- Extract the object properties and asset
      local properties = object.properties
      local asset = assets[properties.type]

      -- Build the entity and add it
      entities[entityCount] = entityConstructors[properties.type](asset, properties)
    end
  end

  -- Load the player up
  entities[entityCount + 1] = player()
end

-- Draws items to the screen
local function draw(i)
  -- Sequence data for the asteroid sprite
  local sequenceData = {
    name = "walking",
    start = 1,
    count = 64,
    time = 2400,
    loopCount = 0,
    loopDirection = "bounce"
  }

  -- Grab the entity and asset
  local entity = entities[i]
  local asset = assets[entity.type]

  -- Display the thing
  entity.sprite = display.newSprite(asset, sequenceData)
  entity.sprite.x = entity.x
  entity.sprite.y = entity.y

  sequenceData.loopCount = 1

  -- Start animation
  entity.sprite:play()

  -- Setup velocity
  if entity.type == "asteroid" then
    entity.xVel = math.random(-10, 10)
    entity.yVel = math.random(-10, 10)
  else
    entity.xVel = 0
    entity.yVel = 0
  end

  -- Do not draw this again
  entity.active = true
end

-- Updates crap
local function update(event)
  -- Loop through each entity and process it
  for i, entity in ipairs(entities) do
    entity.update()
  end
end

-- Start the target level
function M.start(level)
  -- Initialize the game with the map
  initialize(level)

  -- Render the game
  Runtime:addEventListener("enterFrame", update)
end

return M
