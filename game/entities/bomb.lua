local Collision = require("game.collision")
local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Bomb = setmetatable({}, {__index = Entity})

-- Constructor
function Bomb:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "bomb",
        exploding = false,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
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

-- Cause the bomb to explode
function Bomb:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.collidable = false
end

-- Handles collision
function Bomb:collided(entity)
    self:explode()
end

return Bomb
