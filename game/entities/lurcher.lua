local Entity = require("game.entities.entity")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Lurcher = setmetatable({}, {__index = Entity})

-- Constructor
function Lurcher:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "lurcher",
        attacking = false,
        exploding = false,
        collidables = collidables,
        shape = "circle"
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
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
    Sound.play("explosion")

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
    Sound.play("lurcherAttack")

    -- Wait three seconds before lurching
    timer.performWithDelay(3000, function() self:moveToPlayer() end)
end

-- Cause the lurcher to attack
function Lurcher:moveToPlayer()
    -- Set self to collidable
    self.collidable = true

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

    -- Explode if missile
    if entity.type == "missile" then
        self:explode()
    end

    -- Laugh if player
    if entity.type == "player" then
        Sound.play("lurcherLaugh")
    end
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
    self.attacking = false
    self.exploding = false
    Entity.release(self)
end

return Lurcher
