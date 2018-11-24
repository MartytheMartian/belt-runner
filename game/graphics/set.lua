local animated = require("game.graphics.animated")
local scrolling = require("game.graphics.scrolling")
local static = require("game.graphics.static")

local graphicConstructors = {
  animated = animated,
  scrolling = scrolling,
  static = static
}

-- Creates an instance of a 'set' generator
function generator(graphic)
  if graphic.graphics == nil then
    error("Sets must have child graphics to use")
  end

  -- Store each graphic
  local graphicCreators = {}
  for i, subGraphic in ipairs(graphic.graphics) do
    -- Duplicate entries
    if graphicCreators[subGraphic.id] ~= nil then
      error("Duplicate graphic entries detected with an id of " .. subGraphic.id)
    end

    -- Need a type to load correctly
    if subGraphic.type == nil then
      error("Graphic entry with a missing type found with an id of " .. subGraphic.id)
    end

    -- Determine the constructor to use
    local constructor = graphicConstructors[subGraphic.type]

    -- Type unsupported
    if constructor == nil then
      error("Graphic entry with an unsupported type found with an id of " .. subGraphic.id)
    end

    graphicCreators[subGraphic.id] = constructor(subGraphic)
  end

  -- Create an instance of a 'set'
  function create(entity)
    -- Return instance
    local M = {type = "set"}

    if entity.x == nil then
      error("Sets cannot have a nil x position")
    end

    if entity.y == nil then
      error("Sets cannot have a nil y position")
    end

    -- Graphic currently in use
    local activeGraphic = nil

    -- Initialize the set with a particular graphic
    function M.initialize(graphicID)
      -- Ensure the graphic creator exists
      if graphicCreators[graphicID] == nil then
        error("Graphic requested does not exist")
      end

      -- Create the requested graphic
      activeGraphic = graphicCreators[graphicID](entity)

      -- Initialize the active graphic
      activeGraphic.initialize()
    end

    -- Swap the active graphic
    function M.setGraphic(graphicID)
      -- Ensure the graphic exists
      if graphicCreators[graphicID] == nil then
        error("Graphic requested does not exist")
      end

      -- Capture the current position
      local position = activeGraphic.position()

      -- Create the requested graphic
      local requestedGraphic = graphicCreators[graphicID](position)

      -- Initialize the requested graphic
      requestedGraphic.initialize()

      -- Release the existing graphic
      activeGraphic.release()
      activeGraphic = nil

      -- Swap graphics
      activeGraphic = requestedGraphic
    end

    -- Get current position
    function M.position()
      return activeGraphic.position()
    end

    -- Rotate the sprite
    function M.rotate(rotation)
      activeGraphic.rotate(rotation)
    end

    -- Get size
    function M.size()
      return activeGraphic.size()
    end

    -- Move the sprite
    function M.move(x, y)
      return activeGraphic.move(x, y)
    end

    -- Move to a location over a set time 
    -- (params is a set using the transition.moveTo options from Corona https://docs.coronalabs.com/api/library/transition/moveTo.html)
    function M.moveTransition(params)
      activeGraphic.moveTransition(params)
    end

    function M.setFillColor(r, g, b, a)
      return activeGraphic.setFillColor(r, g, b, a)
    end

    -- Release the set
    function M.release()
      -- Release the active graphic
      activeGraphic.release()
    end

    return M
  end

  return create
end

return generator
