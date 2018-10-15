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

return M