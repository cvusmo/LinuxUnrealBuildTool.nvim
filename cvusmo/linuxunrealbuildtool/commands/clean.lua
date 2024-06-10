local log = require("cvusmo.linuxunrealbuildtool.log")
local path = require("cvusmo.linuxunrealbuildtool.path")
local config = require("cvusmo.linuxunrealbuildtool.config")
local progress = require("cvusmo.linuxunrealbuildtool.progress")

local M = {}

-- f(clean)
function M.clean(args)
  print("Running clean command...")
  local project_name = args[1]
  if not project_name then
    print(":LUBT Clean <PROJECTNAME>")
    return
  end

  print("Initializing paths...")
  path.init_paths()
  local project_path = config.project_root .. "/" .. project_name
  local log_suffix = "Clean"
  log.setup(log_suffix, project_path)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local total_steps = 7
  progress.init(total_steps, project_path, log_suffix)
  local current_step = 1

  log.log_message("Cleaning previous build...")
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
    log.log_message("Clean command executed successfully.")
  else
    log.log_message("Clean command failed.")
  end

  progress(current_step)
end

return M
