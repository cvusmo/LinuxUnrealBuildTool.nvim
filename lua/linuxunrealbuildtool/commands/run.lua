local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")

local M = {}

-- f(log_message)
local function log_message(message)
  log.log_message(message)
end

-- f(run)
function M.run(args)
  local project_name = args[1]
  if not project_name then
    log_message(":LUBT Run <ProjectName>")
    return
  end

  local paths = path.init_paths()
  if not paths.unreal_editor then
    log_message("Error: Unreal Editor binary not found.")
    return
  end

  local project_path = paths.current_project .. "/" .. project_name
  local log_suffix = "RunProject"
  log.setup(log_suffix, project_path)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local target_file = project_path .. "/Binaries/Linux/" .. project_name .. "Editor.target"
  if vim.fn.filereadable(target_file) == 0 then
    log_message("Target file " .. target_file .. " does not exist. Please build the project first.")
    return
  end

  local uproject_file = project_path .. "/" .. project_name .. ".uproject"
  if vim.fn.filereadable(uproject_file) == 0 then
    log_message("Project file " .. uproject_file .. " does not exist.")
    return
  end

  log_message("Starting Project " .. project_name .. "...")
  local run_command = paths.unreal_editor .. " \"" .. uproject_file .. "\" | tee -a " .. log_file
  local result = log.execute_command(run_command)
  
  if result == 0 then
    log_message("Project " .. project_name .. " started.")
  else
    log_message("Failed to start project " .. project_name .. ".")
  end

  log.log_trashcollector()
end

return M
