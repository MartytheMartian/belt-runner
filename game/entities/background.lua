local Entity = require("game.entities.entity")
local Events = require("game.events")

Background = setmetatable({}, {__index = Entity})

-- Constructor
function Background:new(properties, graphic)
    -- Create instance
    local instance = {
        type = "Background"
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Update the entity
function Background:update()
    if Events.stopped or not self.initialized then
        return
    end

    -- Scroll
    self.graphic.scroll(self.vX)
end

return Background
