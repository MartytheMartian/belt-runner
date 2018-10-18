local animated = require("game.graphics.animated")
local asteroid = require("game.entities.asteroid")
local background = require("game.entities.background")
local missle = require("game.entities.missle")
local nebula = require("game.entities.nebula")
local player = require("game.entities.player")
local scrolling = require("game.graphics.scrolling")
local set = require("game.graphics.set")
local static = require("game.graphics.static")
local turret = require("game.entities.turret")

-- Return instance
local M = {}

-- Exposed properties
M.graphics = {}
M.entities = nil

-- Graphic constructor map
local graphicConstructors = {
  animated = animated,
  scrolling = scrolling,
  set = set,
  static = static
}

-- Entity constructor map
local entityConstructors = {
  asteroid = asteroid,
  background = background,
  missle = missle,
  nebula = nebula,
  player = player,
  turret = turret
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

  -- Duplicate entries
  if M.entities[entity.id] ~= nil then
    error("Duplicate entity entries detected with an id of " .. entity.id)
  end

  -- Need a type to load correctly
  if entity.type == nil then
    error("Entity entry with a missing type found with an id of " .. entity.id)
  end

  -- Determine the constructor to use
  local constructor = entityConstructors[entity.type]

  -- Type unsupported
  if constructor == nil then
    error("Entity entry with an unsupported type found with an id of " .. entity.id)
  end

  -- Graphic type unsupported
  if entity.graphic == nil or M.graphics[entity.graphic] == nil then
    error("Entity entry with an unloaded graphic type found with an id of " .. entity.id)
  end

  -- Create the correct graphic
  local graphic = M.graphics[entity.graphic](entity)

  -- Create the entity
  M.entities[entity.id] = constructor(entity, graphic)

  -- Set the delay
  M.entities[entity.id].delay = entity.delay
end

-- Load in defaults
local missle = {
  id = "missle",
  type = "animated",
  path = "assets/fireball.png",
  width = 32,
  height = 32,
  numFrames = 4,
  sheetContentWidth = 32,
  sheetContentHeight = 128,
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

return M
