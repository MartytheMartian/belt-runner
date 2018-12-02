local collision = require("game.collision")
local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true
}

-- Create metatable
Pirate = setmetatable({}, {__index = Entity})

-- Constructor
function Pirate:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "pirate",
        exploding = false,
        destroyed = false,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Pirate:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("alive")

    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Update the entity
function Alien:update()
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Slowly decrease velocity if exploding
    if self.exploding then
        self.vX = self.vX * .95
        self.vY = self.vY * .95
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the alien to explode
function Pirate:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
end

-- Handles fast enemy powerup calls
function Pirate:fast()
    self.vX = self.vX * 1.1
    self.vY = self.vY * 1.1
end

-- Handles fast enemy powerup calls
function Pirate:slow()
    self.vX = self.vX / 1.1
    self.vY = self.vY / 1.1
end

-- Handles 'kill all' powerup calls
function Pirate:killAll()
    self:explode()
end

-- Handles collision
function Pirate:collided(entity)
    self:explode()
end

-- Release
function Pirate:release()
    self.exploding = false
    self.destroyed = true
    Entity.release(self)
end

return Pirate
