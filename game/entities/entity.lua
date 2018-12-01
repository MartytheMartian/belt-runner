-- Create metatable
Entity = {
    id = nil,
    type = nil,
    initialized = false,
    collidable = false,
    stopped = false,
    collidables = {},
    x = 0,
    y = 0,
    vX = 0,
    vY = 0,
    graphic = nil,
    shape = "rectangle"
}

-- Constructor
function Entity:new(o, graphic)
    -- Default to empty
    o = o or {}

    -- Setup metatable
    setmetatable(o, self)
    self.__index = self

    -- Set properties
    self.id = o.id or nil
    self.type = o.type or "none"
    self.initialized = o.initialized or false
    self.collidable = o.collidable or false
    self.stopped = o.stopped or false
    self.collidables = o.collidables or {}
    self.x = o.x or 0
    self.y = o.y or 0
    self.vX = o.vX or 0
    self.vY = o.vY or 0
    self.graphic = graphic
    self.shape = o.shape or "rectangle"

    -- Return new instance
    return o
end

-- Initialize the entity
function Entity:initialize()
    if self.initialized then
        return
    end

    -- Initialize the graphic
    self.graphic.initialize()

    self.initialized = true
end

-- Update the entity
function Entity:update()
    -- Does nothing by default
end

-- Stops the entity
function Entity:stop()
    -- Flag to stop
    self.stopped = true
end

-- Handles fast enemy powerup calls
function Entity:fast()
    -- Do nothing by default
end

-- Handles slow enemy calls
function Entity:slow()
    -- Do nothing by default
end

-- Handles 'kill all' powerup calls
function Entity:killAll()
    -- Do nothing by default
end

-- Gets the position
function Entity:position()
    if not self.initialized then
        return nil
    end

    return self.graphic.position()
end

-- Get the size
function Entity:size()
    return self.graphic.size()
end

-- Can collide
function Entity.canCollide(type)
    return self.collidable and self.collidables[type] ~= nil
end

-- Handles collision
function Entity.collided(entity)
    -- Do nothing by default
end

-- Release the entity
function Entity:release()
    -- Ignore if the entity is not initialized
    if not self.initialized then
        return
    end

    -- Release the graphic
    self.graphic.release()

    -- Flag as no longer initialized
    self.collidable = false
    self.initialized = false
end

return Entity
