local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true
}

-- Create metatable
Lurcher =
    Entity:new(
    {
        type = "lurcher",
        attacking = false,
        exploding = false,
        destroyed = false,
        collidbales = collidables,
        shape = "circle"
    }
)

-- Constructor
function Lurcher:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Lurcher:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("alive")

    self.initialized = true
    self.attacking = false
    self.exploding = false
    self.destroyed = false
end

-- Update the entity
function Lurcher:update()
    if self.attacking or not self.initialized then
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

-- Cause the lurcher to explode
function Lurcher:explode()
    -- Swap animations
    self.graphic.setGraphic("exploding")

    -- Play audio

    -- Set flags
    self.exploding = true
    self.destroyed = true
    self.collidable = false
    self.attacking = false
end

-- Cause the lurcher to initiate an attack
function Lurcher:attack()
    -- Flag as attacking
    self.attacking = true

    -- Play audio here

    -- Wait three seconds before lurching
    timer.performWithDelay(3000, moveToPlayer)
end

-- Cause the lurcher to attack
function Lurcher:moveToPlayer()
    -- Move to the player
    self.graphic.moveTransition(
        {
            x = 667,
            y = 375,
            time = 300
        }
    )
end

-- Handles collision
function Lurcher:collided(entity)
    -- Freeze on collision
    self.vX = 0
    self.vY = 0
    self.move(self.graphic.x, self.graphic.y)

    -- Explode
    self.explode()
end

-- Get the size
function Lurcher:size()
    if not self.initialized then
        return nil
    end

    -- Append radius
    local size = self.graphic.size()
    size.radius = size.width / 2

    return size
end

-- Release
function Lurcher:release()
    self.destroyed = true
    self.attacking = false
    self.exploding = false
    Entity.release(self)
end

return Crate
