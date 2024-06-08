if 1 ~= vim.fn.has "nvim-0.7.0" then
  vim.api.nvim_err_writeln "LinuxUnrealBuildTool.nvim requires at least nvim-0.7.0"
  return
end

if vim.g.loaded_lubtnvim == 1 then
  return
end
vim.g.loaded_lubtnvim = 1

vim.api.nvim_create_user_command("Start", function(opts)
  require("lubtcommands").start(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Build", function(opts)
  require("lubtcommands").build(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Clean", function(opts)
  require("lubtcommands").clean(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Rebuild", function(opts)
  require("lubtcommands").rebuild(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("Run", function(opts)
  require("lubtcommands").run(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("BuildPlugin", function(opts)
  require("lubtcommands").buildplugin(opts)
end, { nargs = 1 })

vim.api.nvim_create_user_command("CreateProject", function(opts)
  require("lubtcommands").createproject(opts)
end, { nargs = 1 })

local function setup()
  print("Configuring")
end

return {
  setup = setup
}
