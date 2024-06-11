local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")
local progress = require("linuxunrealbuildtool.progress")

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

  local project_path = config.get_paths().project_root .. "/" .. project_name
  local log_suffix = "RunProject"
  log.setup(log_suffix, project_path)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local target_file = project_path .. "/Binaries/Linux/" .. project_name .. "Editor.target"
  if not vim.fn.filereadable(target_file) then
    log_message("Target file " .. target_file .. " does not exist. Please build the project first.")
    return
  end

  local uproject_file = project_path .. "/" .. project_name .. ".uproject"
  if not vim.fn.filereadable(uproject_file) then
    log_message("Project file " .. uproject_file .. " does not exist.")
    return
  end

  log_message("Starting Project " .. project_name .. "...")
  log.run_command(paths.unreal_editor .. " " .. uproject_file .. " | tee -a " .. log_file)

  log_message("Project " .. project_name .. " started.")

  log.log_trashcollector()
end

return M
