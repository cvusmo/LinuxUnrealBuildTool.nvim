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
  local project_name = args[1]
  if not project_name then
    print(":LUBT Clean <PROJECTNAME>")
    return
  end

  local paths = path.init_paths()
  local project_path = config.project_root .. "/" .. project_name
  local log_suffix = "Clean"
  log.setup(log_suffix)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  log_message("Cleaning previous build...")
  local clean_command = "rm -rf " .. project_path .. "/{Binaries,Intermediate,Saved,.vscode," .. project_name .. ".code-workspace} | tee -a " .. log_file
  os.execute(clean_command)
end

return M
