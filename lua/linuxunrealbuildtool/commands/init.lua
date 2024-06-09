-- linuxunrealbuildtool.commands.init
if 1 ~= vim.fn.has "nvim-0.10.0" then
  vim.api.nvim_err_writeln "LinuxUnrealBuildTool.nvim requires at least nvim-0.10.0"
  return
end

if vim.g.loaded_lubtnvim == 1 then
  return
end
vim.g.loaded_lubtnvim = 1

vim.api.nvim_create_user_command("LUBT", function(opts)
  local args = {}
  if opts.args then
    args = vim.split(opts.args, " ")
  end
  local command = args[1]
  -- debug-tools
  --print("Received command: " .. (command or "nil"))
  --print("Sub options: " .. vim.inspect({ args = table.concat(args, " ") }))
  table.remove(args, 1)
  local sub_opts = { args = table.concat(args, " ") }

  if command == "DEVTEST" then
    print("Running DEVTEST")
    require("linuxunrealbuildtool.commands.dev_test").devtest()
  elseif command == "Clean" then
    print("Running Clean")
    require("linuxunrealbuildtool.commands.clean").clean(sub_opts)
  elseif command == "Build" then
    print("Running Build")
    require("linuxunrealbuildtool.commands.build").build(sub_opts)
  elseif command == "Rebuild" then
    print("Running Rebuild")
    require("linuxunrealbuildtool.commands.rebuild").rebuild(sub_opts)
  elseif command == "Run" then
    print("Running Run")
    require("linuxunrealbuildtool.commands.run_project").run_project(sub_opts)
  elseif command == "CreateProject" then
    print("Running CreateProject")
    require("linuxunrealbuildtool.commands.create_project").create_project(sub_opts)
  elseif command == "InstallPlugins" then
    print("Running InstallPlugins")
    require("linuxunrealbuildtool.commands.install_plugins").install_plugins(sub_opts)
  elseif command == "Help" then
    print("Running Help")
    require("linuxunrealbuildtool.commands.help").help(sub_opts)
  else
    print("LUBT command does not exist. Please use :LUBT Help for list of commands")
  end
end, { nargs = "*" })

local function setup()
  print("Configuring :LUBT commands")
end

return {
  setup = setup
}
