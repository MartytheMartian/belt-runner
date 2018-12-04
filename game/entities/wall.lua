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
        destroyed = false,
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

-- Handles 'kill all' powerup calls
function Wall:killAll()
    self:explode()
end

-- Modify color
function Wall:color(r, g, b, a)
    self.graphic.setFillColor(r, g, b, a)
end

-- Flicker
function Wall:flicker()
    self.graphic.setFillColor(1, 0, 0, 0.8)
    timer.performWithDelay(
      50,
      function()
        self.graphic.setFillColor(1, 1, 1, 1.0)
      end
    )
    timer.performWithDelay(
      100,
      function()
        self.graphic.setFillColor(1, 0, 0, 0.8)
      end
    )
    timer.performWithDelay(
      150,
      function()
        self.graphic.setFillColor(1, 1, 1, 1.0)
      end
    )
    timer.performWithDelay(
      200,
      function()
        self.graphic.setFillColor(1, 0, 0, 0.8)
      end
    )
    timer.performWithDelay(
      250,
      function()
        self.graphic.setFillColor(1, 1, 1, 1.0)
      end
    )
end

-- Handles collision
function Wall:collided(entity)
    -- Must be a missile
    if self.hp > 1 and entity.type == "missile" then
        self.hp = self.hp - 1
        -- Flicker color
        self:flicker()
    else
        self.collidable = false
        self.destroyed = true
        self:explode()
    end
end

return Wall
