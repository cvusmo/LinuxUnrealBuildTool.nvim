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
  table.remove(args, 1)

  if command == "DEVTEST" then
    require("cvusmo.linuxunrealbuildtool.commands.dev_test").devtest()
  elseif command == "Clean" then
    require("cvusmo.linuxunrealbuildtool.commands.clean").clean(args)
  elseif command == "Build" then
    require("cvusmo.linuxunrealbuildtool.commands.build").build(args)
  elseif command == "Rebuild" then
    require("cvusmo.linuxunrealbuildtool.commands.rebuild").rebuild(args)
  elseif command == "Run" then
    require("cvusmo.linuxunrealbuildtool.commands.run_project").run_project(args)
  elseif command == "CreateProject" then
    require("cvusmo.linuxunrealbuildtool.commands.create_project").create_project(args)
  elseif command == "InstallPlugins" then
    require("cvusmo.linuxunrealbuildtool.commands.install_plugins").install_plugins(args)
  elseif command == "Help" then
    require("cvusmo.linuxunrealbuildtool.commands.help").help(args)
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
