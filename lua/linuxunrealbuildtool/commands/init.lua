-- linuxunrealbuildtool.commands init
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
  print("Received command: " .. (command or "nil"))
  table.remove(args, 1)
  local sub_opts = { args = table.concat(args, " ") }
  print("Sub options: " .. vim.inspect(sub_opts))

  if command == "DEVTEST" then
    print("Running DEVTEST")
    require("linuxunrealbuildtool.commands.dev_test").devtest()
  elseif command == "Clean" then
    require("linuxunrealbuildtool.commands.clean").clean(sub_opts)
  elseif command == "Build" then
    require("linuxunrealbuildtool.commands.build").build(sub_opts)
  elseif command == "Rebuild" then
    require("linuxunrealbuildtool.commands.rebuild").rebuild(sub_opts)
  elseif command == "Run" then
    require("linuxunrealbuildtool.commands.run_project").run_project(sub_opts)
  elseif command == "CreateProject" then
    require("linuxunrealbuildtool.commands.create_project").create_project(sub_opts)
  elseif command == "InstallPlugins" then
    require("linuxunrealbuildtool.commands.install_plugins").install_plugins(sub_opts)
  elseif command == "Help" then
    require("linuxunrealbuildtool.commands.help").help(sub_opts)
  else print("LUBT command does not exist. Please use :LUBT Help for list of commands")
  end
end, { nargs = "*" } )

local function setup()
  print("Configuring :LUBT commands")
end

return {
  setup = setup
}
