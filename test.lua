  -- Read the exported Particle Designer file (JSON) into a string
  local filePath = system.pathForFile("sprites/particle.json")
  local f = io.open(filePath, "r")
  local emitterData = f:read("*a")
  f:close()

  -- Decode the string
  local emitterParams = json.decode(emitterData)

  -- Create the emitter with the decoded parameters
  emitter = display.newEmitter(emitterParams)
  emitter.x = 600
  emitter.y = 200