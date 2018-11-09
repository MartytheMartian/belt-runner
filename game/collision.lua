local M = {}

function M.onScreen(x, y, w, h)
  -- Calculate face positions
  local right = x + w / 2
  local left = x - w / 2
  local top = y - h / 2
  local bottom = y + h / 2

  -- Too far to the right
  if left > 1334 then
    return false
  end

  -- Too far to the left
  if right < 0 then
    return false
  end

  -- Too far up
  if bottom < 0 then
    return false
  end

  -- Too far down
  if top > 750 then
    return false
  end

  return true
end

function M.detectCollision(target, entities)
  -- Get position and size of the target
  local targetPosition = target.position()
  local targetSize = target.size()

  local targetBounds = {
    x = targetPosition.x,
    y = targetPosition.y,
    w = targetSize.width,
    h = targetSize.height,
    r = targetSize.radius
  }

  -- Check against other entities
  for i, entity in ipairs(entities) do
    repeat
      -- Move on if not collidable, not initialized, is the current target, or not collidable type
      if not entity.initialized or not entity.collidable or not target.canCollide(entity.type) or entity.id == target.id then
        break
      end

      -- Get position and size of the entity
      local entityPosition = entity.position()
      local entitySize = entity.size()

      local entityBounds = {
        x = entityPosition.x,
        y = entityPosition.y,
        w = entitySize.width,
        h = entitySize.height,
        r = entitySize.radius
      }

      -- Check rect status
      local targetRectangle = target.shape == "rectangle"
      local entityRectangle = entity.shape == "rectangle"

      -- Both entity and target are rectangles
      if targetRectangle and entityRectangle then
        if M.rectangleCollision(targetBounds, entityBounds) then return entity
        else break end
      end

      -- Target is a rectangle
      if targetRectangle then
        if M.rectangleCircleCollision(targetBounds, entityBounds) then return entity
        else break end
      end

      -- Entity is a rectangle
      if entityRectangle then
        if M.rectangleCircleCollision(entityBounds, targetBounds) then return entity
        else break end
      end

      -- Must be circle-circle
      if M.circleCollision(targetBounds, entityBounds) then
        return entity
      end
    until true
  end

  return nil
end

function M.circleCollision(obj1, obj2)
  local dx = obj1.x - obj2.x
  local dy = obj1.y - obj2.y

  local distance = math.sqrt(dx * dx + dy * dy)
  local objectSize = (obj2.w / 2) + (obj1.h / 2)

  if (distance < objectSize) then
    return true
  end

  return false
end

function M.rectangleCollision(obj1, obj2)
  -- Set x and y coordinates to upper left corner of rectangles rather than the center
  local obj1X = obj1.x - (obj1.w / 2)
  local obj2X = obj2.x - (obj2.w / 2)
  local obj1Y = obj1.y - (obj1.h / 2)
  local obj2Y = obj2.y - (obj2.h / 2)

  return obj1X < obj2X + obj2.w and
  obj1X + obj1.w > obj2X and
  obj1Y < obj2Y + obj2.h and
  obj1Y + obj1.h > obj2Y
end

function M.rectangleCircleCollision(rectangle, circle)
  local circleDistance_x = math.abs(circle.x - rectangle.x)
  local circleDistance_y = math.abs(circle.y - rectangle.y)

  if (circleDistance_x > (rectangle.w / 2 + circle.r)) then
    return false
  end
  if (circleDistance_y > (rectangle.h / 2 + circle.r)) then
    return false
  end

  if (circleDistance_x <= (rectangle.w / 2)) then
    return true
  end

  if (circleDistance_y <= (rectangle.h / 2)) then
    return true
  end

  cornerDistance_sq = (circleDistance_x - rectangle.w / 2) ^ 2 + (circleDistance_y - rectangle.h / 2) ^ 2

  return (cornerDistance_sq <= (circle.r ^ 2))
end

return M
