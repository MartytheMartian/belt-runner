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

function M.calculateVelocity(start, dest, s)
  -- Calculate differences
  local difX = dest.x - start.x
  local difY = dest.y - start.y

  -- Calculate distance
  local distance = math.sqrt((difX * difX) + (difY * difY))

  return {
    x = (s / distance) * (difX),
    y = (s / distance) * (difY)
  }
end

function M.calculateRotation(p1, p2)
  return (math.atan2(p2.y - p1.y, p2.x - p1.x) / 3.14) * 180
end

function M.circleCollision(obj1, obj2)
  -- Get positions
  local pos1 = obj1.position()
  local pos2 = obj2.position()

  -- Get bounds
  local size1 = obj1.size()
  local size2 = obj2.size()

  local dx = pos1.x - pos2.x
  local dy = pos1.y - pos2.y

  local distance = math.sqrt(dx * dx + dy * dy)
  local objectSize = (size2.w / 2) + (size1.h / 2)

  if (distance < objectSize) then
    return true
  end

  return false
end

function M.rectToCircle(rectangle, circ)
  if circ == nil then
    return false
  end

  local rect = rectangle.size()
  local circle = circ.size()

  local circleDistance_x = math.abs(circle.x - rect.x);
  local circleDistance_y = math.abs(circle.y - rect.y);

  if (circleDistance_x > (rect.w / 2 + circle.r)) then
    return false
  end
  if (circleDistance_y > (rect.h / 2 + circle.r)) then
    return false
  end

  if (circleDistance_x <= (rect.w / 2)) then
    return true
  end

  if (circleDistance_y <= (rect.h / 2)) then
    return true
  end

  cornerDistance_sq = (circleDistance_x - rect.w / 2) ^ 2 + (circleDistance_y - rect.h / 2) ^ 2

  return (cornerDistance_sq <= (circle.r ^ 2))
end

-- Global properties
M.background = {}
M.frames = 0
M.entities = {}
M.entityCount = 0
M.player = {}
M.turret = {}

return M
