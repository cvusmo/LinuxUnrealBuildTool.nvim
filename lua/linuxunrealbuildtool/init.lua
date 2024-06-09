local M = {}

local config = require("linuxunrealbuildtool.config")

-- f(init)
local function init(user_config)
  if user_config then
    config.set_paths(user_config)
  end

  local paths = require("linuxunrealbuildtool.path").init_paths()
  require("linuxunrealbuildtool.log").setup()

  if not paths.unreal_build_tool
     or not paths.setup
     or not paths.fix_dependency_files
     or not paths.update_deps
     or not paths.generate_project_files then
      print("Error: One or more required scripts not found.")
      return
    end

  print("Paths initialized successfully")
end

 --f(setup)
local function setup(user_config)
  init(user_config)
  require("linuxunrealbuildtool.commands").setup()
  print("Configuring LinuxUnrealBuildTool")
end

M.setup = setup

return M
