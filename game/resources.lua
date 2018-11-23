local alien = require("game.entities.alien")
local animated = require("game.graphics.animated")
local asteroid = require("game.entities.asteroid")
local background = require("game.entities.background")
local debris = require("game.entities.debris")
local crate = require("game.entities.crate")
local lurcher = require("game.entities.lurcher")
local missle = require("game.entities.missle")
local nebula = require("game.entities.nebula")
local pirate = require("game.entities.pirate")
local player = require("game.entities.player")
local scrolling = require("game.graphics.scrolling")
local set = require("game.graphics.set")
local static = require("game.graphics.static")
local turret = require("game.entities.turret")
local moonComplete = require("game.entities.moon-complete")
local moonTop = require("game.entities.moon-top")
local moonBottom = require("game.entities.moon-bottom")
local tentacle = require("game.entities.tentacle")

-- Return instance
local M = {}

-- Game resources
M.graphics = {}
M.entities = nil

-- Track number of entities
local entityCount = 0

-- Mapper for ID's to entity
local idMap = {}

-- Graphic constructor map
local graphicConstructors = {
  animated = animated,
  scrolling = scrolling,
  set = set,
  static = static
}

-- Entity constructor map
local entityConstructors = {
  alien = alien,
  asteroid = asteroid,
  background = background,
  debris = debris,
  crate = crate,
  lurcher = lurcher,
  missle = missle,
  nebula = nebula,
  player = player,
  pirate = pirate,
  turret = turret,
  moonComplete = moonComplete,
  moonTop = moonTop,
  tentacle = tentacle,
  moonBottom = moonBottom
}

-- Create graphics
function M.createGraphic(graphic)
  -- Duplicate entries
  if M.graphics[graphic.id] ~= nil then
    error("Duplicate graphic entries detected with an id of " .. graphic.id)
  end

  -- Need a type to load correctly
  if graphic.type == nil then
    error("Graphic entry with a missing type found with an id of " .. graphic.id)
  end

  -- Determine the constructor to use
  local constructor = graphicConstructors[graphic.type]

  -- Type unsupported
  if constructor == nil then
    error("Graphic entry with an unsupported type found with an id of " .. graphic.id)
  end

  M.graphics[graphic.id] = constructor(graphic)
end

-- Create entities
function M.createEntity(entity)
  -- Initialize if necessary
  if M.entities == nil then
    M.entities = {}
  end

  -- Need a type to load correctly
  if entity.type == nil then
    error("Entity entry with a missing type found")
  end

  -- Determine the constructor to use
  local constructor = entityConstructors[entity.type]

  -- Type unsupported
  if constructor == nil then
    error("Entity entry with an unsupported type found")
  end

  -- Graphic type unsupported
  if entity.graphic == nil or M.graphics[entity.graphic] == nil then
    error("Entity entry with an unloaded graphic type found")
  end

  -- Create the correct graphic
  local graphic = M.graphics[entity.graphic](entity)

  -- Increment entity count
  entityCount = entityCount + 1

  -- Create the entity
  M.entities[entityCount] = constructor(entity, graphic)

  -- Set the delay
  M.entities[entityCount].delay = entity.delay

  -- Map ID if necessary
  if entity.id ~= nil then
    idMap[entity.id] = entityCount
  end
end

-- Setup initial resources
function M.setup()
  -- Load in defaults
  local missle = {
    id = "missle",
    type = "animated",
    path = "assets/fireball.png",
    width = 22,
    height = 12,
    numFrames = 4,
    sheetContentWidth = 22,
    sheetContentHeight = 48,
    sequences = {
      name = "flying",
      start = 1,
      count = 3,
      rotation = 0,
      time = 400,
      loopCount = 0,
      loopDirection = "forward"
    }
  }

  M.createGraphic(missle)
end

-- Clear out all resources
function M.clear()
  -- Reset all flags
  M.graphics = {}
  M.entities = nil
  entityCount = 0
  idMap = {}
end

-- Get a specific entity by ID
function M.getEntityByID(id)
  return M.entities[idMap[id]]
end

return M
