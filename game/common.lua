Common = {}

local world = {}
local resources = {}

function Common.hook(w, r)
    world = w
    resources = r
end

function Common.getWorld()
    return world
end

function Common.getResources()
    return resources
end

return Common