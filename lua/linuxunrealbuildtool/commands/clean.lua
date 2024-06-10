local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")

local M = {}

-- f(logmessage)
local function log_message(message)
  log.log_message(message)
end

-- f(progress)
local function progress(current_step, total_steps)
  local percentage = math.floor((current_step * 100) / total_steps)
  log_message("Progress: " .. percentage .. "% completed")
end

-- f(clean)
function M.clean(args)
  print("Running clean command...")
  local project_name = args[1]
  if not project_name then
    print(":LUBT Clean <PROJECTNAME>")
    return
  end

  print("Initializing paths...")
  local paths = path.init_paths()
  local project_path = config.project_root .. "/" .. project_name
  local log_suffix = "Clean"
  log.setup(log_suffix, project_path)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local total_steps = 7
  local current_step = 0

  log_message("Cleaning previous build...")
  print("Project path: " .. project_path)
  print("Log file: " .. log_file)

  os.execute("ls -l " .. project_path .. " | tee -a " .. log_file)

  local clean_command = "rm -rf " .. project_path .. "/Binaries " ..
                        project_path .. "/Intermediate " ..
                        project_path .. "/Saved " ..
                        project_path .. "/.vscode " ..
                        project_path .. "/DerivedDataCache " ..
                        project_path .. "/" .. project_name .. ".code-workspace" ..
                        " | tee -a " .. log_file
  print("Executing command: " .. clean_command)
  local result = os.execute(clean_command)

  if result then
    log_message("Clean command executed successfully.")
  else
    log_message("Clean command failed.")
  end

  progress(current_step, total_steps)
end

return M
