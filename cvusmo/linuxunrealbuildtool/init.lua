local M = {}

local config = require("cvusmo.linuxunrealbuildtool.config")
local path = require("cvusmo.linuxunrealbuildtool.path")
local log = require("cvusmo.linuxunrealbuildtool.log")
local commands = require("cvusmo.linuxunrealbuildtool.commands")

local function init_paths()
  local paths = path.init_paths()
  return paths
end

local function setup(user_config)
  if user_config then
    config.set_paths(user_config)
  end
  init_paths()
  log.setup("log_suffix", config.project_root)
  commands.setup()
  print("Configuring LinuxUnrealBuildTool")
end

M.setup = setup

return M
