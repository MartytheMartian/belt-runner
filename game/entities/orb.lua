local Collision = require("game.collision")
local Entity = require("game.entities.entity")
local Math = require("game.math")
local Sound = require("game.sound")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Orb = setmetatable({}, {__index = Entity})

-- Determines the time the orb should take to transition from two points
function TransitionTime(x1, x2)
    local time = (x1 - x2) * 1.5
    if time < 0 then
        time = time * -1
    end

    return time
end

-- Constructor
function Orb:new(properties, graphic)
    -- Create the instance
    local instance = {
        type = "orb",
        collidables = collidables
    }

    -- Return new instance
    return setmetatable(instance, {__index = Entity.new(self, properties, graphic)})
end

-- Initialize the entity
function Orb:initialize()
    if self.initialized then
        return
    end

    -- Don't set collidable until spawn'd
    self.initialized = true
    self.collidable = false
    self.destroyed = true
    self.peakPointReached = false
    self.transitionX = nil
    self.transitionY = nil
    self.vX = 0
    self.vY = 0
end

-- Spawn the orb
function Orb:spawn(x, y, peakPoint)
    if not self.initialized then
        return
    end

    -- Initialize the orb and set its position
    self.graphic.initialize()
    self.graphic.move(x, y)

    -- Set flags
    self.collidable = true
    self.destroyed = false

    -- Play orb firing audio on spawn
    Sound.play("orb")

    -- Determine the orb transition time based on its distance from the edge of the screen
    local time = TransitionTime(x, peakPoint.x)

    -- X-axis transition
    self.transitionX = self.graphic.moveTransition({ time = time, x = peakPoint.x, y = peakPoint.y, transition = easing.outSine, onComplete = function()
        time = TransitionTime(peakPoint.x, 667)
        self.transitionX = self.graphic.moveTransition({ time = time, x = 667, y = 375, transition = easing.inSine, onComplete = function()
            local velocity = Math.calculateVelocity({ x = peakPoint.x, y = peakPoint.y }, { x = 667, y = 375 }, 16)
            self.vX = velocity.x
            self.vY = velocity.y
            self.peakPointReached = true
        end })
    end })
end

-- Update the entity
function Orb:update()
    if not self.initialized or self.destroyed then
        return
    end

    -- Check the current position
    local position = self.graphic.position()

    -- Move it
    if self.peakPointReached then
        self.graphic.move(position.x + self.vX, position.y + self.vY)
    end

    -- Destroy it off-screen
    local size = self.graphic.size()
    if not Collision.onScreen(position.x, position.y, size.width, size.height) then
        self.collidable = false
        self.destroyed = true
        return
    end
end

-- Handles collision
function Orb:collided(entity)
    -- Flag as destroyed
    self.collidable = false
    self.destroyed = true

    -- Add points
    if entity.type ~= "player" then
        Events.addPoints(50)
    end

    -- Cancel transitions
    transition.cancel(self.transitionX)
    transition.cancel(self.transitionY)
    
    -- Move off screen
    self.graphic.move(-32, -32)
end

return Orb
