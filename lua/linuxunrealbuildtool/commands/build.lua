local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")
local progress = require("linuxunrealbuildtool.progress")

local M = {}

-- f(logmessage)
local function log_message(message)
  log.log_message(message)
end

-- f(terminate_conflicting_ubt)
local function terminate_conflicting_ubt()  
  log.log_message("Terminating conflicting UBT...")
  os.execute("pgrep -f UnrealBuildTool | xargs -r kil -9")
end

-- f(build)
function M.build(args)
  local project_name = args[1]
  if not project_name then
    print(":LUBT Build <ProjectName>")
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
  local log_suffix = "Build"
  log.setup(log_suffix)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  local total_steps = 5
  local current_step = 0

  progress.init(total_steps, project_path, log_suffix)

  local start_time = os.time()

  log_message("Building project...")

  local function run_step(step_script, step_name)
    log_message(step_name)
    os.execute(step_script .. " | tee -a " .. log_file)
  end

  local start_time = os.time()

  log_message("Fixing dependency files...")
  os.execute(paths.fix_dependency_files .. " | tee -a " .. log_file)
  current_step = current_step + 1
  progress.update(current_step)

  log_message("Updating dependencies...")
  os.execute(paths.update_deps .. " | tee -a " log_file)
  current_step = current_step + 1

  log_message("Generating project files...")
  terminate_conflicting_ubt()
  local gpf_command = paths.generate_project_files .. " -project=\"" .. project_path ..
                      "/" .. project_name .. ".uproject\" -game -makefile | tee -a " .. log_file
  local result = os.execute(gpf_command)
  if result ~= 0 then
    log_message("Generating project files failed.")
    return
  end
  current_step = current_step + 1
  progress.update(current_step)

  log_message("Generating Makefiles...")
  terminate_conflicting_ubt()
  local makefile_command = paths.unreal_build_tool .. " -projectfiles -project=\"" .. project_path ..
                          "/" .. project_name .. ".uproject\" -game -makefile | tee -a " .. log_file
  result = os.execute(makefile_command)
  if result ~= 0 then
    log_message("Generating Makefiles failed.")
    return
  end
  current_step = current_step + 1
  progress.update(current_step)

  log_message("Building " .. project_name .. "Editor...")
  terminate_conflicting_ubt()
  local build_command = "cd " .. project_path .. " && make VERBOSE=1 " .. project_name .. "Editor | tee -a " .. log_file
  result = os.execute(build_command)
  if result ~= 0 then
    log_message("Building " .. project_name .. "Editor failed.")
    return
  end
  current_step = current_step + 1
  progress.update(current_step)

  local total_end_time = os.time()
  log_message("Total script execution time: " .. os.difftime(total_end_time, start_time) .. " seconds")
  log_message("Project " .. project_name .. " successfully built.")

  log.log_trashcollector()
end

return M
