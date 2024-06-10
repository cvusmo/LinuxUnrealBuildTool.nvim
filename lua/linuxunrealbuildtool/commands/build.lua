local log = require("linuxunrealbuildtool.log")
local path = require("linuxunrealbuildtool.path")
local config = require("linuxunrealbuildtool.config")

local M = {}

-- f(logmessage)
local function log_message(message)
  log.log_message(message)
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
     or not paths.setup
     or not paths.fix_dependency_files
     or not paths.update_deps
     or not paths.generate_project_files then
      print("Error: One or more required scripts not found.")
      return
    end

  local project_path = config.project_root .. "/" .. project_name
  local log_suffix = "Build"
  log.setup(log_suffix)
  local log_file = log.get_log_file()

  log.log_trashcollector()

  log_message("Building project...")

  local function run_step(step_script, step_name)
    log_message(step_name)
    os.execute(step_script .. " | tee -a " .. log_file)
  end

  local start_time = os.time()

  log_message("Setting up project...")
  run_step(paths.setup, "Running Setup.sh")

  log_message("Fixing dependencies...")
  run_step(paths.fix_dependency_files, "Running FixDependencyFiles.sh")

  log_message("Updating dependencies...")
  run_step(paths.update_deps, "Running UpdateDeps.sh")

  log_message("Generating project files and Makefile...")
  local gpf_command = "pgrep -f UnrealBuildTool | xargs kill -9 && " .. 
                      paths.unreal_build_tool .. " -projectfiles -project=" 
                      .. project_path .. "/" .. project_name .. 
                      ".uproject -game -makefile | tee -a " .. log_file
  os.execute(gpf_command)

  log_message("Building project in Development mode...")
  os.execute("pgrep -f UnrealBuildTool | xargs kill -9 && make VERBOSE=1 UnrealEditor | tee -a " .. log_file)
  
  local total_end_time = os.time()
  log_message("Total script execution time: " .. os.difftime(total_end_time, start_time) .. " seconds")
  log_message("Project " .. project_name .. " successfully built.")

  log.log_trashcollector()
end
