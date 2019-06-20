local json = require("json")

-- Creates an instance of an 'emitter' generator
function generator(filePath)
  if filePath == nil then
    error("Emitters cannot have a nil filePath")
  end

  -- Load the file
  local file = system.pathForFile(filePath)
  if file == nil then
    error("Emitters must reference a file that exists")
  end

  -- Parse the emitter data
  local emitterData = json.decodeFile(file)
  if emitterData == nil then
    error("Emitters must reference a file that can be parsed as JSON")
  end

  -- Create an instance of an 'emitter'
  function create()
    -- Return instance
    local M = { type = "emitter" }

    -- Emitter to use
    local emitter = nil

    -- Initialize the emitter
    function M.initialize()
      emitter = display.newEmitter(emitterData)
    end

    -- Get the sprite object itself
    function M.emitter()
      return emitter
    end

    -- Get current position
    function M.position()
      -- No position if there is no emitter
      if emitter == nil then
        error("Cannot get position of an emitter if it has not been drawn yet")
      end

      return {
        x = emitter.x,
        y = emitter.y,
        rotation = emitter.rotation
      }
    end

    -- Move the sprite
    function M.move(x, y)
      emitter.x = x
      emitter.y = y
    end

    -- Move to a location over a set time
    function M.moveTransition(params)
      transition.moveTo(emitter, params)
    end

    -- Rotate the emitter
    function M.rotate(rotation)
      emitter.rotation = emitter.rotation + rotation
    end

    -- Sets the rotation of the emitter
    function M.setRotation(rotation)
      emitter.rotation = rotation
    end

    -- Release the emitter
    function M.release()
      -- Clear out the emitter and set it to nothing
      if emitter ~= nil then
        emitter:removeSelf()
        emitter = nil
      end
    end

    return M
  end

  return create
end

return generator
