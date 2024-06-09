 local M = {}

 -- Load modules
 local path = require("linuxunrealbuildtool.path")
 local log = require("linuxunrealbuildtool.log")
 local commands = require("linuxunrealbuildtool.commands")

 -- f(initialize)
 local function init()
   local paths = path.init_paths()
   log.setup()

   if not paths.unreal_build_tool
     or not paths.setup
     or not paths.fix_dependency_files
     or not paths.update_deps
     or not paths.generate_project_files then
      print("Error: One or more required scripts not found.")
      return
    end

   print("Paths initialized")
end

 --f(setup)
local function setup()
  init()
  commands.setup()
  print("Configuring LinuxUnrealBuildTool")
end

M.setup = setup

return M
