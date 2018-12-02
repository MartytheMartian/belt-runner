local Collision = require("game.collision")
local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Bomb =
    Entity:new(
    {
        type = "bomb",
        exploding = false,
        destroyed = false,
        collidables = collidables
    }
)

-- Constructor
function Bomb:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Bomb:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("falling")

    self.initialized = true
    self.collidable = true
    self.exploding = false
    self.destroyed = false
end

-- Update the entity
function Bomb:update()
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
function Bomb:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
end

-- Handles fast enemy powerup calls
function Bomb:fast()
    self.vX = self.vX * 2.5
    self.vY = self.vY * 2.5
end

-- Handles fast enemy powerup calls
function Bomb:slow()
    self.vX = self.vX / 2.5
    self.vY = self.vY / 2.5
end

-- Handles 'kill all' powerup calls
function Bomb:killAll()
    self.explode()
end

-- Handles collision
function Bomb:collided(entity)
    self.explode()
end

return Bomb
