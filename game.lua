-- External references
local xml = require("xml").newParser();

-- Export object
local M = {};

-- Variables
local assets = {};
local entities = {};

-- Parse the map
local function parse(level)
    -- Read the map XML file
    local mapFile = xml:loadFile(level);
    
    -- My awesome map
    assets = {};
    entities = {};
    
    -- Gather all assets
    for i, asset in ipairs(mapFile.child[1].child) do
      local options =
      {
        width = asset.properties.width,
        height = asset.properties.height,
        numFrames = asset.properties.numFrames,
        sheetContentWidth = asset.properties.sheetContentWidth, 
        sheetContentHeight = asset.properties.sheetContentHeight 
      };
    
      -- Load the image
      local image = graphics.newImageSheet(asset.properties.path, options);
      
      -- Store assets in a table keyed on type
      assets[asset.properties.type] = image;
    end

    -- Loop through each layer to get the objects
    for i, layer in ipairs(mapFile.child[2].child) do
      -- Store entities in layers
      for i, object in ipairs(layer.child) do
        entities[i] = 
        {
          type = object.properties.type,
          x = object.properties.x,
          y = object.properties.y,
          active = false,
          destroyed = false
        };
      end
    end
end


-- Draws items to the screen
local function draw(i)
  -- Sequence data for the asteroid sprite
  local sequenceData =
  {
      name="walking",
      start=1,
      count=64,
      time=2400,
      loopCount = 0,
      loopDirection = "bounce"
  };
  
  -- Grab the entity and asset
  local entity = entities[i];
  local asset = assets[entity.type];
  
  -- Display the thing
  entity.sprite = display.newSprite(asset, sequenceData);
  entity.sprite.x = entity.x;
  entity.sprite.y = entity.y;
  
  sequenceData.loopCount = 1;
  
  -- Start animation
  entity.sprite:play();
  
  -- Setup velocity
  entity.xVel = math.random(-10, 10);
  entity.yVel = math.random(-10, 10);
  
  -- Do not draw this again
  entity.active = true;
end

-- Updates crap
local function update()
  for i, entity in ipairs(entities) do
    -- Draw the entity initially if it hasn't been
    if not entity.active then
      -- Draw the thing
      draw(i);
    end
    
    -- Move stuff
    entity.sprite.x = entity.sprite.x + entity.xVel;
    entity.sprite.y = entity.sprite.y + entity.yVel;
  end
end

-- Start the target level
function M.start(level)
    -- Parse the map XML
    local map = parse(level);
    
    -- Render the game
    timer.performWithDelay(16.67, update, 0);
end

return M;