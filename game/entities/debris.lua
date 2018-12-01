local Collision = require("game.collision")
local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Debris =
    Entity:new(
    {
        type = "debris",
        exploding = false,
        destroyed = false
    }
)

-- Constructor
function Debris:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Debris:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("floating")

    self.initialized = true
    self.collidable = true
    self.exploding = false
    self.destroyed = false
end

-- Update the entity
function Debris:update()
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

-- Cause the asteroid to explode
function Debris:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
end

-- Handles fast enemy powerup calls
function Debris:fast()
    self.vX = self.vX * 2.5
    self.vY = self.vY * 2.5
end

-- Handles fast enemy powerup calls
function Debris:slow()
    self.vX = self.vX / 2.5
    self.vY = self.vY / 2.5
end

-- Handles 'kill all' powerup calls
function Debris:killAll()
    self.explode()
end

-- Handles collision
function Debris:collided(entity)
    self.explode()
end

return Debris
