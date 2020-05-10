local json = require("json")

local M = {}
local saveData = nil

local function load()
  -- Open the file
  local path = system.pathForFile("save.json", nil)
  if path == nil then
    return
  end
  
  -- Do nothing if the file doesn't exist
  local file = io.open(path, "r")
  if not file then
    return
  end
  
  -- Read the data
  local binarySaveData = file:read("*a")
  io.close(file)

  -- Decode the JSON data
  local jsonData = json.decode(binarySaveData)
  if not jsonData then
    return
  end

  -- Set the data
  saveData = jsonData.value
end

local function get()
  return saveData
end

local function set(data)
  saveData = data
end

local function save()
  -- Set the save data in an object
  local data = {}
  data["value"] = saveData

  -- JSON encode the data
  local jsonSaveData = json.encode(data)

  -- Open a file
  local path = system.pathForFile("save.json", nil)
  local file = io.open(path, "w")

  -- Write the data
  file:write(jsonSaveData)
  io.close(file)

  -- Close out
  file = nil
end

M.load = load
M.get = get
M.set = set
M.save = save
return M