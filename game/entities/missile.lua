local Collision = require("game.collision")
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
Missile = setmetatable({}, {__index = Entity})

-- Constructor
function Missile:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "missile",
        destroyed = true,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Missile:initialize()
    if self.initialized then
        return
    end

    -- Don't set collidable until spawn'd
    self.initialized = false
    self.collidable = false
    self.destroyed = true
end

-- Spawn the missile
function Missile:spawn(x, y, vX, vY, rotation)
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

-- 'Despawn' the missile
function Missile:despawn()
    -- Flag as destroyed
    self.collidable = false
    self.destroyed = true

    -- Move off screen
    self.graphic.move(-32, -32)
end

-- Update the entity
function Missile:update()
    if self.destroyed or not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Destroy it off-screen
    local size = self.graphic.size()
    if not Collision.onScreen(position.x, position.y, size.width, size.height) then
        self:despawn()
        return
    end

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Handles collision
function Missile:collided(entity)
    self:despawn()
end

-- Release
function Missile:release()
    self.destroyed = true
    Entity.release(self)
end

return Missile
