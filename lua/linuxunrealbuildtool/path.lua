local config = require("linuxunrealbuildtool.config")

local M = {}

-- f(searchpaths)
function M.find(name, search_paths)
  for _, path in ipairs(search_paths) do
    local full_path = path .. "/" .. name
    if vim.fn.glob(full_path) ~= "" then
      return full_path
    end
  end
  return nil
end

-- f(initializepaths)
function M.init_paths()
  local paths_config = config.get_paths()
  local search_paths = {
    paths_config.unreal_engine_path .. "/Engine/Build/BatchFiles",
    paths_config.unreal_engine_path .. "/Engine/Build/BatchFiles/Linux",
    paths_config.unreal_engine_path .. "/Engine/Binaries/Linux",
    paths_config.project_root
  }

  local paths = {
    unreal_build_tool = M.find("BuildUBT.sh", search_paths),
    fix_dependency_files = M.find("FixDependencyFiles.sh", search_paths),
    update_deps = M.find("UpdateDeps.sh", search_paths),
    generate_project_files = M.find("GenerateProjectFiles.sh", search_paths),
    unreal_editor = M.find("UnrealEditor", search_paths)
  }

  for key, path in pairs(paths) do
    if not path then
      print("Error: " .. key .. " not found.")
    end
  end

  return paths
end

return M
