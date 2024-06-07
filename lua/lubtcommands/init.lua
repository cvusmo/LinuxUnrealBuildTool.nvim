local M = {}

-- Path Configuration
local unreal_build_script = vim.g.unreal_build_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/Linux/Build.sh"
local unreal_uat_script = vim.g.unreal_uat_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh"
local unreal_editor_path = vim.g.unreal_editor_path or "/home/echo/Projects/remote/UnrealEngine/Engine/Binaries/Linux/UnrealEditor"
local unreal_ubt_executable = vim.g.unreal_ubt_executable or "/home/echo/Projects/remote/UnrealEngine/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool"

local project_base_path = vim.g.unreal_project_path or "/home/echo/Projects"

local function execute_command(cmd)
  local handle = io.popen(cmd)
  if not handle then
    error("Failed to execute command: " .. cmd)
  end
  local result = handle:read("*a")
  handle:close()
  return result
end

-- Checkfile
local function file_exists(path)
  local file = io.open(path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

local function ensure_essential_files_exist()
  if not file_exists(unreal_build_script) then
    error("Build script not found at " .. unreal_build_script)
  end

  if not file_exists(unreal_editor_path) then
    error("Unreal Editor not found at " .. unreal_editor_path)
  end

  if not file_exists(unreal_uat_script) then
    error("RunUAT.sh not found at " .. unreal_uat_script)
  end
end

-- Create new Project
local function create_project(name)
  local project_path = project_base_path .. "/" .. name .. "/" .. name .. ".uproject"
  if file_exists(project_path) then
    print("Project file found: " .. project_path)
  else
    print("Project file not found. Creating a new project...")
    os.execute("mkdir -p " .. project_base_path .. "/" .. name)
    os.execute(unreal_editor_path .. " " .. project_path .. " -game -CreateBlankProject")
  end
end

-- Start Command
function M.start(opts)
  if opts.args == "YES" then
    os.execute(unreal_editor_path .. " &")
  elseif opts.args == "NO" then
    print("Start command cancelled")
  else
    print("use :Start YES")
  end
end

-- Build command
function M.build(opts)
  ensure_essential_files_exist()
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/" .. name .. ".uproject"
  create_project(name)
  print("Building project...")
  local cmd = unreal_build_script .. " -projectfiles -project=" .. project_path .. " -game -engine -progress"
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error during build: " .. result)
  else
    print(result)
  end
end

-- Clean command
function M.clean(opts)
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/"
  print("Cleaning project...")
  local cmd = "rm -rf " .. project_path .. "Binaries " .. project_path .. "Intermediate " .. project_path .. "Saved"
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error during clean: " .. result)
  else
    print(result)
  end
end

-- Rebuild command
function M.rebuild(opts)
  M.clean(opts)
  M.build(opts)
end

-- Run command
function M.run(opts)
  ensure_essential_files_exist()
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/" .. name .. ".uproject"
  create_project(name)
  print("Running project...")
  local cmd = "cd " .. project_base_path .. " && ./UnrealEditor " .. project_path
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error during run: " .. result)
  else
    print(result)
  end
end

-- Build Plugin command
function M.build_plugin(opts)
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/"
  local plugin_path = project_path .. "Plugins/Voxel"
  print("Building plugins...")
  local cmd = unreal_uat_script .. " BuildPlugin -plugin=" .. plugin_path .. "/Voxel.uplugin -package=" .. plugin_path .. "/Output"
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error during plugin build: " .. result)
  else
    print(result)
  end
end

return M

