local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")

local M = {}

-- f(logmessage)
local function log_message(message)
  log.log_message(message)
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

  log_message("Cleaning previous build...")
  print("Project path: " .. project_root)
  print("Log file: " .. log_file)

  local clean_command = "rm -rf " .. project_root .. "/Binaries " ..
                        project_root .. "/Intermediate " ..
                        project_root .. "/Saved " ..
                        project_root .. "/.vscode " ..
                        project_root .. "/" .. project_name .. ".code-workspace" ..
                        " | tee -a " .. log_file
  print("Executing command: " .. clean_command)
  local result = os.execute(clean_command)
  print("Clean command executed with result: " .. tostring(result))

  log_message("Clean command executed.")
end

return M
