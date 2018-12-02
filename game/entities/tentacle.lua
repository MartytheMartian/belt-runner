local Entity = require("game.entities.entity")

-- Define a static table for collidable entities
local collidables = {
    missile = true,
    player = true
}

-- Create metatable
Tentacle =
    Entity:new(
    {
        type = "tentacle",
        hp = 3,
        dying = false,
        pulling = false,
        destroyed = false,
        collidables = collidables
    }
)

-- Constructor
function Tentacle:new(properties, graphic)
    -- Default to an entity
    local entity = Entity:new(nil, properties, graphic)

    -- Setup metatable
    setmetatable(entity, self)
    self.__index = self

    -- Return new instance
    return entity
end

-- Initialize the entity
function Tentacle:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize("attacking")

    self.hp = 3
    self.dying = false
    self.pulling = false
    self.initialized = true
    self.collidable = true
    self.destroyed = false
end

-- Update the entity
function Tentacle:update()
    if not self.initialized then
        return
    end

    -- Check the current position
    local position = self.graphic.position()
    local size = self.graphic.size()
    
    -- Different states
    if (self.dying or self.pulling) and position.y <= 1070 then
        self.vY = 4.5
    elseif self.dying and position.y == 2000 then
        self.graphic.move(position.x, 2000)
        self.destroyed = true
    elseif self.pulling and position.y == 2000 then
        -- TODO: Do something here when tentacle has fully dragged
        self.destroyed = true
    else
        -- Move towards player
        if position.x <= 1350 and position.y >= 505 then
            self.vY = -3.2
        else
            self.vY = 0
        end
    end

    -- Move it
    if self.stopped then
        self.graphic.move(position.x, position.y + self.vY)
    else
        self.graphic.move(position.x + self.vX, position.y + self.vY)
    end
end

-- Modify color
function Tentacle:color(r, g, b, a)
    self.graphic.setFillColor(r, g, b, a)
end

-- Flicker
function Tentacle:flicker()
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
function Tentacle:collided(entity)
    if entity.type == "player" then
        self.graphic.setSequence("killing")
        self.pulling = true
        self.collidable = false
        return
    end
    
    -- Must be a missile
    if self.hp > 1 then
        self.hp = self.hp - 1
    else
        self.dying = true
        self.collidable = false
    end

    -- Flicker color
    self.flicker()
end

-- Release
function Tentacle:release()
    self.destroyed = true
    Entity.release(self)
end

return Tentacle