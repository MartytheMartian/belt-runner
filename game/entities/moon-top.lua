local Entity = require("game.entities.entity")
local Events = require("game.events")

-- Create metatable
MoonTop = setmetatable({}, {__index = Entity})

-- Constructor
function MoonTop:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "moonTop"
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function MoonTop:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    self.initialized = true
    self.destroyed = false
end

-- Update the entity
function MoonTop:update()
    if Events.stopped or not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()
    local size = self.graphic.size()

    -- Release the moon if off screen
    if position.x + size.width <= 0 then
        self:release()
        return
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

return MoonTop
