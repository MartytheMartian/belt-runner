local Collision = require("game.collision")
local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Wall = setmetatable({}, {__index = Entity})

-- Constructor
function Wall:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "wall",
        hp = 3,
        exploding = false,
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Wall:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("floating")

    self.hp = 3
    self.initialized = true
    self.collidable = true
    self.exploding = false
    self.destroyed = false
end

-- Update the entity
function Wall:update()
    if not self.initialized or self.stopped then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the wall to explode
function Wall:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio
    Sound.play("explosion")

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
end

-- Handles collision
function Wall:collided(entity)
    -- Must be a missile
    if self.hp > 1 and entity.type == "missile" then
        self.hp = self.hp - 1
    else
        self.dying = true
        self.collidable = false
    end

    self:explode()
end

return Wall
