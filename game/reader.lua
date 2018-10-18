local xmlParser = require("references.xml").newParser()

-- Parse the info section of XML
local function parseInfo(infoXML)
  if infoXML == nil or infoXML.name ~= "info" then
    error("'map' element must have 'info' element as its first child")
  end

  if infoXML.properties == nil or infoXML.properties.name == nil then
    error("'info' element must have a 'name' attribute")
  end

  return {
    name = infoXML.properties.name
  }
end

-- Parse 'sequence' graphic XML
local function parseSequence(sequenceXML)
  if
    sequenceXML.properties == nil or sequenceXML.properties.name == nil or sequenceXML.properties.start == nil or
      sequenceXML.properties.count == nil or
      sequenceXML.properties.rotation == nil or
      sequenceXML.properties.time == nil or
      sequenceXML.properties.loopCount == nil or
      sequenceXML.properties.loopDirection == nil
   then
    error(
      "'seqeuence' must have 'name', 'start', 'count', 'rotation', 'time', 'loopCount', and 'loopDirection' attributes"
    )
  end

  return {
    name = sequenceXML.properties.name,
    start = tonumber(sequenceXML.properties.start),
    count = tonumber(sequenceXML.properties.count),
    rotation = tonumber(sequenceXML.properties.rotation),
    time = tonumber(sequenceXML.properties.time),
    loopCount = tonumber(sequenceXML.properties.loopCount),
    loopDirection = sequenceXML.properties.loopDirection
  }
end

-- Parse 'static' graphic XML
local function parseStatic(staticXML, parsedGraphic)
  if staticXML.properties.path == nil then
    error("'graphic' of type 'static' must have a 'path' attribute")
  end

  if staticXML.properties.width == nil then
    error("'graphic' of type 'static' must have a 'width' attribute")
  end

  if staticXML.properties.height == nil then
    error("'graphic' of type 'static' must have a 'height' attribute")
  end

  parsedGraphic.path = staticXML.properties.path
  parsedGraphic.width = tonumber(staticXML.properties.width)
  parsedGraphic.height = tonumber(staticXML.properties.height)
end

-- Parse 'scrolling' graphic XML
local function parseScrolling(scrollingXML, parsedGraphic)
  if scrollingXML.properties.path == nil then
    error("'graphic' of type 'scrolling' must have a 'path' attribute")
  end

  if scrollingXML.properties.width == nil then
    error("'graphic' of type 'scrolling' must have a 'width' attribute")
  end

  if scrollingXML.properties.height == nil then
    error("'graphic' of type 'scrolling' must have a 'height' attribute")
  end

  parsedGraphic.path = scrollingXML.properties.path
  parsedGraphic.width = tonumber(scrollingXML.properties.width)
  parsedGraphic.height = tonumber(scrollingXML.properties.height)
end

-- Parse 'animated' graphic XML
local function parseAnimated(animatedXML, parsedGraphic)
  if animatedXML.properties.path == nil then
    error("'graphic' of type 'animated' must have a 'path' attribute")
  end

  if animatedXML.properties.width == nil then
    error("'graphic' of type 'animated' must have a 'width' attribute")
  end

  if animatedXML.properties.height == nil then
    error("'graphic' of type 'animated' must have a 'height' attribute")
  end

  if animatedXML.properties.numFrames == nil then
    error("'graphic' of type 'animated' must have a 'numFrames' attribute")
  end

  if animatedXML.properties.sheetContentWidth == nil then
    error("'graphic' of type 'animated' must have a 'sheetContentWidth' attribute")
  end

  if animatedXML.properties.sheetContentHeight == nil then
    error("'graphic' of type 'animated' must have a 'sheetContentHeight' attribute")
  end

  -- Set the properties
  parsedGraphic.path = animatedXML.properties.path
  parsedGraphic.width = tonumber(animatedXML.properties.width)
  parsedGraphic.height = tonumber(animatedXML.properties.height)
  parsedGraphic.numFrames = tonumber(animatedXML.properties.numFrames)
  parsedGraphic.sheetContentWidth = tonumber(animatedXML.properties.sheetContentWidth)
  parsedGraphic.sheetContentHeight = tonumber(animatedXML.properties.sheetContentHeight)

  -- There should be at least one sequence element as a child
  if animatedXML.child[1] == nil then
    error("'graphic' of type 'animated' must have at least one 'sequence' element as a child")
  end

  -- Declare the sequences collection
  parsedGraphic.sequences = {}

  -- Read in each sequence
  for i, sequenceXML in ipairs(animatedXML.child) do
    parsedGraphic.sequences[i] = parseSequence(sequenceXML)
  end
end

-- Parse 'set' graphic XML
local function parseSet(setXML, parsedGraphicSet)
  -- Set the graphics
  parsedGraphicSet.graphics = {}

  -- Read each "graphic" element
  for i, graphicXML in ipairs(setXML.child) do
    -- Create the graphic
    local parsedGraphic = {}

    -- Properties must exist
    if graphicXML.properties == nil then
      error("'graphic' element within graphic of type 'set' must at least have 'id', 'type', and 'path' attributes")
    end

    -- id must be unique
    if graphicXML.properties.id == nil or parsedGraphicSet.graphics[graphicXML.properties.id] ~= nil then
      error("'graphic' element within graphic of type 'set' must have a unique 'id' attribute")
    end

    -- Type must be set
    if graphicXML.properties.type == nil then
      error("'graphic' element within graphic of type 'set' must have a 'type' attribute")
    end

    parsedGraphic.id = graphicXML.properties.id
    parsedGraphic.type = graphicXML.properties.type

    -- Interpret additional properties for types
    if parsedGraphic.type == "static" then
      parseStatic(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "scrolling" then
      parseScrolling(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "animated" then
      parseAnimated(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "set" then
      error("'graphic' element of type 'set' cannot have another set within itself")
    else
      error("'graphic' element contains a type that is not supported")
    end

    parsedGraphicSet.graphics[i] = parsedGraphic
  end
end

-- Parse the graphics section of XML
local function parseGraphics(graphicsXML)
  if graphicsXML == nil or graphicsXML.name ~= "graphics" then
    error("'map' element must have 'graphics' element as its second child")
  end

  -- Declare the return graphics object
  local parsedGraphics = {}

  -- Read each "graphic" element
  for i, graphicXML in ipairs(graphicsXML.child) do
    -- Create the graphic
    local parsedGraphic = {}

    -- Properties must exist
    if graphicXML.properties == nil then
      error("'graphic' element must at least have 'id', 'type', and 'path' attributes")
    end

    -- id must be unique
    if graphicXML.properties.id == nil or parsedGraphics[graphicXML.properties.id] ~= nil then
      error("'graphic' element must have a unique 'id' attribute")
    end

    -- Type must be set
    if graphicXML.properties.type == nil then
      error("'graphic' element must have a 'type' attribute")
    end

    parsedGraphic.id = graphicXML.properties.id
    parsedGraphic.type = graphicXML.properties.type

    -- Interpret additional properties for types
    if parsedGraphic.type == "static" then
      parseStatic(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "scrolling" then
      parseScrolling(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "animated" then
      parseAnimated(graphicXML, parsedGraphic)
    elseif parsedGraphic.type == "set" then
      parseSet(graphicXML, parsedGraphic)
    else
      error("'graphic' element contains a type that is not supported")
    end

    -- Set the graphic
    parsedGraphics[i] = parsedGraphic
  end

  return parsedGraphics
end

-- Parse the entities section of XML
local function parseEntities(entitiesXML)
  if entitiesXML == nil or entitiesXML.name ~= "entities" then
    error("'map' element must have 'entities' element as its third child")
  end

  -- Start building the entities
  local parsedEntities = {}

  -- Read each entity
  for i, entityXML in ipairs(entitiesXML.child) do
    if
      entityXML.properties == nil or entityXML.properties.type == nil or entityXML.properties.graphic == nil or
        entityXML.properties.x == nil or
        entityXML.properties.y == nil
     then
      error("'entity' must have 'type', 'graphic', 'x', and 'y' attributes")
    end

    -- Determine the id
    local id = entityXML.properties.id

    -- Set properties with default values for optionals initially
    parsedEntities[id] = {}
    parsedEntities[id].id = id
    parsedEntities[id].type = entityXML.properties.type
    parsedEntities[id].graphic = entityXML.properties.graphic
    parsedEntities[id].x = tonumber(entityXML.properties.x)
    parsedEntities[id].y = tonumber(entityXML.properties.y)
    parsedEntities[id].vX = 0
    parsedEntities[id].vY = 0
    parsedEntities[id].delay = 0

    -- Read 'X' velocity if necessary
    if entityXML.properties.vX ~= nil then
      parsedEntities[id].vX = tonumber(entityXML.properties.vX)
    end

    -- Read 'Y' velocity if necessary
    if entityXML.properties.vY ~= nil then
      parsedEntities[id].vY = tonumber(entityXML.properties.vY)
    end

    -- Read 'delay' if necessary
    if entityXML.properties.delay ~= nil then
      parsedEntities[id].delay = tonumber(entityXML.properties.delay)
    end
  end

  return parsedEntities
end

-- Read a level file
function read(file)
  if file == nil then
    error("Cannot read nil xml data")
  end

  -- Parse the XML file
  local level = xmlParser:loadFile(file)
  if level == nil then
    error("Failed to parse the level as XML")
  end

  -- Top level should be a 'map' element
  if level.name ~= "map" then
    error("Root element should be a 'map' element")
  end

  -- Parse each piece of the level object
  return {
    info = parseInfo(level.child[1]),
    graphics = parseGraphics(level.child[2]),
    entities = parseEntities(level.child[3])
  }
end

return read
