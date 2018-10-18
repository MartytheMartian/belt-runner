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
  for i, entity in pairs(entities) do
    repeat
      if not entity.collidable or not entity.initialized or entity.id == target.id then
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

      -- Target is a rectangle
      if target.shape == "rectangle" and M.rectangleCircleCollision(targetBounds, entityBounds) then
        return entity
      end

      -- Entity is a rectangle
      if entity.shape == "rectangle" and M.rectangleCircleCollision(entityBounds, targetBounds) then
        return entity
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
