local M = {}

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

return M