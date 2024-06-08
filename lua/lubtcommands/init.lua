local M = {}

-- Path Configuration
local unreal_build_script = vim.g.unreal_build_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/Linux/Build.sh"
local unreal_uat_script = vim.g.unreal_uat_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/BuildUAT.sh"
local unreal_ubt_script = vim.g.unreal_ubt_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/BuildUBT.sh"
local unreal_gpf_script = vim.g.unreal_gpf_script or "/home/echo/Projects/remote/UnrealEngine/Engine/Build/BatchFiles/Linux/GenerateProjectFiles.sh"
local unreal_editor_path = vim.g.unreal_editor_path or "/home/echo/Projects/remote/UnrealEngine/Engine/Binaries/Linux/UnrealEditor"
local project_base_path = vim.g.unreal_project_path or "/home/echo/Projects/remote/"

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

  if not file_exists(unreal_uat_script) then
    error("RunUAT.sh not found at " .. unreal_uat_script)
  end

  if not file_exists(unreal_ubt_script) then
    error("RunUBT.sh not found at " .. unreal_ubt_script)
  end

  if not file_exists(unreal_gpf_script) then
    error("GenerateProjectFiles.sh not found at " .. unreal_gpf_script)
  end

  if not file_exists(unreal_editor_path) then
    error("Unreal Editor not found at " .. unreal_editor_path)
  end
end

-- Log 
local function create_log_dir(log_dir)
  local cmd = "mkdir -p " .. log_dir
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error creating log directory: " .. result)
  end
end

-- Create Project
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
  local log_dir = project_base_path .. "/" .. name .. "/Log"
  local log_file = log_dir .. "/LUBT_" .. os.date("%Y-%m-%d_%H-%M") .. ".log"

  create_log_dir(log_dir)
  --create_project(name)

  print("Generating project files...")
  local gpf_cmd = unreal_gpf_script .. " -projectfiles -project=" .. project_path .. " -game -engine -progress 2>&1 | tee -a " .. log_file .. " | grep -v 'UE_DEPRECATED'"
  os.execute(gpf_cmd)

  if not file_exists(project_path) then
    print("Unable to find project '" .. project_path .. "'.")
    return
  end

  print("Building the project and generating compile_commands.json...")
  local build_cmd = "bear -- " .. unreal_build_script .. " " .. name .. " Development Linux -project=" .. project_path .. " -progress -NoEngineChanges -NoHotReloadFromIDE 2>&1 | tee -a " .. log_file .. " | grep -v 'UE_DEPRECATED'"
  local success, result = pcall(execute_command, build_cmd)
  if not success then
    print("Error during build: " .. result)
  else
    print(result)
  end
end

-- Clean Command
function M.clean(opts)
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/"
  print ("Cleaning project...")
  local cmd = "rm -rf " .. project_base_path .. "/" .. name .. "/{Binaries,Intermediate,Saved,.vscode}"
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error during clean: " .. result)
  else
    print(result)
  end
end

-- Rebuild Command
function M.rebuild(opts)
  M.clean(opts)
  M.build(opts)
end

-- Run Project Command
function M.run(opts)
  ensure_essential_files_exist()
  local name = opts.args
  local project_path = project_base_path .. "/" .. name .. "/" .. name .. ".uproject"
  M.start(name)
  print("Launching project...")
  local cmd = "cd" .. project_base_path .. " && ./UnrealEditor " .. project_path
  local success, result = pcall(execute_command, cmd)
  if not success then
    print("Error: " .. result)
  else
    print(result)
  end
end

-- Build Plugin Command
-- :BuildPlugin [NAMEOFPLUGIN]
function M.build_plugin(opts)
  local project_name = opts.args:match("^%S+")
  local plugin_name = opts.args:match("%S+$")

  if not project_name or not plugin_name then
    print("Usage: :BuildPlugin <ProjectName> <PluginName>")
    return
  end

  local project_path = project_base_path .. "/" .. project_name .. "/"
  local plugin_path = project_path .. "Plugins/Runtime/" .. plugin_name

  if not file_exists(plugin_path .. "/" .. plugin_name .. ".uplugin") then
    print("Plugin " .. plugin_name .. " not found in project " .. project_name)
    return
  end

  print("Building plugin " .. plugin_name .. "...")
  local cmd = unreal_uat_script .. " BuildPlugin -plugin=" .. plugin_path .. "/" .. plugin_name .. ".uplugin -package=" .. plugin_path .. "/Output"
  local success, result = pcall(execute_command, cmd)

  if not success then
    print("Error: " .. result)
  else
    print(result)
  end
end

return M
