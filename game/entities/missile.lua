local Collision = require("game.collision")
local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    asteroid = true,
    alien = true,
    crate = true,
    debris = true,
    lurcher = true,
    pirate = true,
    tentacle = true,
    wall = true
}

-- Create metatable
Missile = setmetatable({}, {__index = Entity})

-- Constructor
function Missile:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "missile",
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
    self.initialized = true
    self.collidable = false
    self.destroyed = true
end

-- Spawn the missile
function Missile:spawn(x, y, vX, vY, rotation)
    if not self.initialized then
        return
    end

    -- Reset the velocity and rotation
    self.vX = vX
    self.vY = vY

    -- Initialize the missle and set its position
    self.graphic.initialize()
    self.graphic.move(x, y)

    -- Rotate the missle
    self.graphic.rotate(rotation)

    -- Set flags
    self.collidable = true
    self.destroyed = false

    -- Play missile firing audio on spawn
    Sound.play("missile")
end

-- Update the entity
function Missile:update()
    if not self.initialized or self.destroyed then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Destroy it off-screen
    local size = self.graphic.size()
    if not Collision.onScreen(position.x, position.y, size.width, size.height) then
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
    self.graphic.move(-32, -32)
end

return Missile
