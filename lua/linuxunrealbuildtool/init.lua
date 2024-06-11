local M = {}

local notify = require("notify")
vim.notify = notify
local config = require("linuxunrealbuildtool.config")
local path = require("linuxunrealbuildtool.path")
local log = require("linuxunrealbuildtool.log")
local commands = require("linuxunrealbuildtool.commands")

-- f(init_paths)
local function init_paths()
  local paths = path.init_paths()
  return paths
end

-- f(setup)
local function setup(user_config)
  if user_config then
    config.set_paths(user_config)
  end
  init_paths()
  log.setup("log_suffix", config.project_root)
  commands.setup()
  vim.notify("Configuring LinuxUnrealBuildTool", vim.log.levels.INFO)
end

M.setup = setup

return M
