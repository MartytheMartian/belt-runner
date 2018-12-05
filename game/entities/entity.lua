-- Create metatable
Entity = {}

-- Constructor
function Entity:new(properties, graphic)
    -- Default to empty
    properties = properties or {}

    -- Create instance
    local instance = {
        id = properties.id or nil,
        initialized = false,
        destroyed = false,
        collidable = false,
        collidables = {},
        x = properties.x or 0,
        y = properties.y or 0,
        vX = properties.vX or 0,
        vY = properties.vY or 0,
        graphic = graphic or nil,
        shape = "rectangle"
    }

    -- Setup metatable
    return setmetatable(instance, {__index = self})
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

-- Gets the position
function Entity:position()
    if not self.initialized or self.destroyed then
        return nil
    end

    return self.graphic.position()
end

-- Get the size
function Entity:size()
    return self.graphic.size()
end

-- Set to 'fast'
function Entity:fast()
    -- Do nothing by default
end

-- Set to normal speed
function Entity:resetSpeed()
    -- Do nothing by default
end

-- Called on 'kill all'
function Entity:killAll()
    -- Do nothing by default
end

-- Modify color
function Entity:color(r, g, b, a)
    self.graphic.color(r, g, b, a)
end

-- Can collide
function Entity:canCollide(type)
    return self.collidable and self.collidables[type] ~= nil
end

-- Handles collision
function Entity:collided(entity)
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
    self.destroyed = true
    self.initialized = false
end

return Entity
