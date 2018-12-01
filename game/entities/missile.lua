local collision = require("game.collision")
local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    asteroid = true,
    alien = true,
    debris = true,
    lurcher = true,
    pirate = true,
    tentacle = true
}

-- Create metatable
Missile =
    Entity:new(
    {
        type = "missile",
        destroyed = false,
        collidables = collidables
    }
)

-- Constructor
function Missile:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Missile:initialize()
    if self.initialized then
        return
    end

    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Spawn the missile
function Missile.spawn(x, y, vX, vY, rotation)
    if not self.initialized then
        return
    end

    -- Reset velocity and rotation
    self.vX = vX
    self.vY = vY
    self.rotation = rotation

    -- Initialize and position
    self.graphic.initialize()
    self.graphic.move(x, y)

    -- Rotate
    self.graphic.rotate(rotation)

    -- Set flags
    self.initialized = true
    self.collidable = true
    self.destroyed = false

    -- Fire sound
end

-- Update the entity
function Missile:update()
    if self.destroyed or not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Destroy it off-screen
    local size = graphic.size()
    if not collision.onScreen(position.x, position.y, size.width, size.height) then
        self.collidable = false
        self.destroyed = true
        return
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Handles collision
function Missile:collided(entity)
    -- Flag as destroyed
    self.collidable = false
    self.destroyed = true

    -- Move off screen
    graphic.move(-32, -32)
end

-- Release
function Missile:release()
    self.destroyed = true
    Entity.release(self)
end

return Missile
