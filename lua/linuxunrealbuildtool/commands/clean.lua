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
  local project_root = config.project_root .. "/" .. project_name
  local log_suffix = "Clean"
  log.setup(log_suffix)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local total_steps = 7
  local current_step = 0

  log_message("Cleaning previous build...")
  print("Project path: " .. project_root)
  print("Log file: " .. log_file)

  -- Execute the clean command
  local clean_command = "rm -rf " .. project_root .. "/Binaries " ..
                        project_root .. "/Intermediate " ..
                        project_root .. "/Saved " ..
                        project_root .. "/.vscode " ..
                        project_root .. "/" .. project_name .. ".code-workspace" ..
                        " | tee -a " .. log_file
  print("Executing command: " .. clean_command)
  local result = os.execute(clean_command)
  print("Clean command executed with result: " .. tostring(result))

  current_step = current_step + 1
  progress(current_step, total_steps)

  current_step = current_step + 1
  progress(current_step, total_steps)

  local start_time = os.time()
  local end_time = os.time()
  log_message("Total script execution time: " .. os.difftime(end_time, start_time) .. " seconds")

  log_message("Clean command executed.")
  log.log_trashcollector()
end

return M
