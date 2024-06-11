local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")
local progress = require("linuxunrealbuildtool.progress")
local clean = require("linuxunrealbuildtool.commands.clean")
local build = require("linuxunrealbuildtool.commands.build")

local M = {}

-- f(log_message)
local function log_message(message)
  log.log_message(message)
end

-- f(rebuild)
function M.rebuild(args)
  local project_name = args[1]
  if not project_name then
    print(":LUBT Rebuild <ProjectName>")
  return
end

local paths = path.init_paths()
  if not paths.unreal_build_tool
  or not paths.unreal_editor
  or not paths.fix_dependency_files
  or not paths.update_deps
  or not paths.generate_project_files then
    print("Error: One or more required scripts not found.")
  return
end

local project_path = config.get_paths().project_root .. "/" .. project_name
local log_suffix = "Rebuild"
log.setup(log_suffix, project_path)
local log_file = log.get_log_file()

log.log_trashcollector()

local total_steps = 2
local current_step = 0

progress.init(total_steps, project_path, log_suffix)

local start_time = os.time()

-- call clean
log_message("Cleaning previous build...")
clean.clean(args)
current_step = current_step + 1
progress.update(current_step)

-- call build
log_message("Rebuilding project...")
build.build(args)
current_step = current_step + 1

local total_end_time = os.time()
log_message("Total script execution time: " .. os.difftime(total_end_time, start_time) .. " seconds")
log_message("Project " .. project_name .. " successfully rebuilt.")

log.log_trashcollector()
end

return M
