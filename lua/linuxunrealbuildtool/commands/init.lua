
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
  
  if command == "DEVTEST" then
    print("Running DEVTEST")
    require("linuxunrealbuildtool.commands.dev_test").devtest()
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

