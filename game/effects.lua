local Effects = {}

-- Cause the entity to flicker
function Effects.flicker(entity)
  entity:color(1, 0, 0, 0.8)
  timer.performWithDelay(
    50,
    function()
      entity:color(1, 1, 1, 1.0)
    end
  )
  timer.performWithDelay(
    100,
    function()
      entity:color(1, 0, 0, 0.8)
    end
  )
  timer.performWithDelay(
    150,
    function()
      entity:color(1, 1, 1, 1.0)
    end
  )
  timer.performWithDelay(
    200,
    function()
      entity:color(1, 0, 0, 0.8)
    end
  )
  timer.performWithDelay(
    250,
    function()
      entity:color(1, 1, 1, 1.0)
    end
  )
end

return Effects