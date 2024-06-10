local log = require("cvusmo.linuxunrealbuildtool.log")
local path = require("cvusmo.linuxunrealbuildtool.path")
local config = require("cvusmo.linuxunrealbuildtool.config")

local M = {}

-- f(logmessage)
local function log_message(message)
  log.log_message(message)
end

-- f(installplugins)
function M.install_plugins(project_name)
  if not project_name then
    print("Usage: LUBT InstallPlugins <ProjectName>")
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

    --fix hardcoded pathing
    local project_path = os.getenv("$HOME") .. "/Projects/remote/" .. project_name
    local log_suffix = "InstallPlugins"
    log.setup(log_suffix)
    local log_file = log.get_log_file()

    -- checklog if exists, don't mkdir
    os.execute("mkdir -p " .. project_path .. "/Log")

   local function install_plugins()
    local uproject_file = project_path .. "/" .. project_name .. ".uproject"
    if vim.fn.filereadable(uproject_file) == 1 then
      log_message("Updating " .. uproject_file .. " to include plugins...")
      local plugin_entries = {}
      for _, plugin_dir in ipairs(vim.fn.glob(project_path .. "/Plugins/Runtime/*", true, true)) do
        if vim.fn.isdirectory(plugin_dir) == 1 then
          local plugin_name = vim.fn.fnamemodify(plugin_dir, ":t")
          log_message("Installing plugin: " .. plugin_name)
          table.insert(plugin_entries, { Name = plugin_name, Enabled = true })
        end
      end

      local plugins_json = vim.fn.json_encode(plugin_entries)
      local jq_command = string.format("jq --argjson plugins '%s' '. + {Plugins: $plugins}' %s > %s.tmp && mv %s.tmp %s",
                                       plugins_json, uproject_file, uproject_file, uproject_file, uproject_file)
      os.execute(jq_command)
    else
      log_message("Error: .uproject not found")
      return
    end
  end

  local start_time = os.time()

  log.log_trashcollector()

  log_message("Cleaning previous build...")
  os.execute("rm -rf " .. project_path .. "/{Binaries,Intermediate,Saved,.vscdoe," .. project_name .. ".code-workspace}")

  log_message("Installing plugins...")
  install_plugins()

  local function run_step(step_script, step_name)
    log_message(step_name)
    os.execute(step_script .. " | tee -a " .. log_file)
  end

  run_step(paths.setup, "[LUBT] Setting up .. ")
  run_step(paths.fix_dependency_files, "[LUBT] Fixing dependency files...")
  run_step(paths.update_deps, "[LUBT] Updating dependencies...")
  run_step(paths.generate_project_files, "[LUBT] Generating project files...")

  log_message("[LUBT] Generating Makefile...")
  os.execute(paths.unreal_build_tool .. " -projectfiles -project=" .. project_path .. "/" .. project_name .. ".uproject -game -makefile | tee -a " .. log_file)

  local total_end_time = os.time()
  log_message("[LUBT] InstallPlugins total time: " .. os.difftime(total_end_time, start_time) .. " seconds")

  log_message("[LUBT] Starting Project " .. project_name .. "...")
  os.execute(paths.unreal_build_tool .. " " .. project_path .. "/" .. project_name .. ".uproject | tee -a " .. log_file)

  log.logtrashcollector()
end

return M
