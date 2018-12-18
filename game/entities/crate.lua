local Entity = require("game.entities.entity")
local Events = require("game.events")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true
}

-- Power up maps
local powerMaps = {
    killAll = "killAll",
    fasterEnemies = "fasterEnemies",
    slowRecharge = "slowRecharge",
    fastRecharge = "fastRecharge",
    shield = "shield",
    lurcher = "lurcher"
}

-- Create metatable
Crate = setmetatable({}, {__index = Entity})

-- Constructor
function Crate:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "crate",
        collidables = collidables,
        powerUp = properties.powerUp,
        lurcherId = nil
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Crate:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("floating")

    self.initialized = true
    self.destroyed = false
    self.collidable = true
end

-- Update the entity
function Crate:update()
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Slowly decrease velocity if exploding
    if self.exploding then
        self.vX = self.vX * .95
        self.vY = self.vY * .95
    else
        self.graphic.rotate(-.2)
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the crate to explode
function Crate:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.collidable = false

    -- Fire attached event
    Events[powerMaps[self.powerUp]]()
end

-- Handles collision
function Crate:collided(entity)
    -- Explode
    self:explode()
end

-- Get the size
function Crate:size()
    if not self.initialized then
        return nil
    end

    -- Append radius
    local size = self.graphic.size()
    size.radius = size.width / 2

    return size
end

return Crate
