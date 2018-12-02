local Collision = require("game.collision")
local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Wall =
    Entity:new(
    {
        type = "wall",
        hp = 3,
        exploding = false,
        destroyed = false,
        collidables = collidables
    }
)

-- Constructor
function Wall:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
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
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Move it
    self.graphic.move(position.x + self.vX, position.y + self.vY)
end

-- Cause the asteroid to explode
function Wall:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
end

-- Handles 'kill all' powerup calls
function Wall:killAll()
    self.explode()
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

    self.destroyed = true
    self.explode()
end

return Wall
