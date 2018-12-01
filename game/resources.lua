local Alien = require("game.entities.alien")
local Animated = require("game.graphics.animated")
local Asteroid = require("game.entities.asteroid")
local Background = require("game.entities.background")
local Crate = require("game.entities.crate")
local Debris = require("game.entities.debris")
local Lurcher = require("game.entities.lurcher")
local Missle = require("game.entities.missle")
local MoonBottom = require("game.entities.moon-bottom")
local MoonComplete = require("game.entities.moon-complete")
local MoonTop = require("game.entities.moon-top")
local Nebula = require("game.entities.nebula")
local Pirate = require("game.entities.pirate")
local Player = require("game.entities.player")
local Scrolling = require("game.graphics.scrolling")
local Set = require("game.graphics.set")
local Static = require("game.graphics.static")
local Tentacle = require("game.entities.tentacle")
local Turret = require("game.entities.turret")

-- Return instance
Resources = {
  graphics = {},
  entities = nil
}

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
  alien = Alien,
  asteroid = Asteroid,
  background = Background,
  crate = Crate,
  debris = Debris,
  lurcher = Lurcher,
  missle = Missle,
  moonBottom = MoonBottom,
  moonComplete = MoonComplete,
  moonTop = MoonTop,
  nebula = Nebula,
  player = Player,
  pirate = Pirate,
  tentacle = Tentacle,
  turret = Turret
}

-- Create graphics
function Resources.createGraphic(graphic)
  -- Duplicate entries
  if Resources.graphics[graphic.id] ~= nil then
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

  Resources.graphics[graphic.id] = constructor(graphic)
end

-- Create entities
function Resources.createEntity(entity)
  -- Initialize if necessary
  if Resources.entities == nil then
    Resources.entities = {}
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
  if entity.graphic == nil or Resources.graphics[entity.graphic] == nil then
    error("Entity entry with an unloaded graphic type found")
  end

  -- Create the correct graphic
  local graphic = Resources.graphics[entity.graphic](entity)

  -- Increment entity count
  entityCount = entityCount + 1

  -- Create the entity
  Resources.entities[entityCount] = constructor:new(entity, graphic)

  -- Set the delay
  Resources.entities[entityCount].delay = entity.delay

  -- Map ID if necessary
  if entity.id ~= nil then
    idMap[entity.id] = entityCount
  end
end

-- Setup initial resources
function Resources.setup()
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

  Resources.createGraphic(missle)
end

-- Clear out all resources
function Resources.clear()
  -- Reset all flags
  Resources.graphics = {}
  Resources.entities = nil
  entityCount = 0
  idMap = {}
end

-- Get a specific entity by ID
function Resources.getEntityByID(id)
  return Resources.entities[idMap[id]]
end

return Resources
