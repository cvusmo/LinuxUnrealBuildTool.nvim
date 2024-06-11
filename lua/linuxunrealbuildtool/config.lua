local config = {
  project_root = os.getenv("HOME") .. "/Projects/remote",
  unreal_engine_path = os.getenv("HOME") .. "/Projects/remote/UnrealEngine"
}

-- f(setpath)
function config.set_paths(paths)
  if paths.project_root then
    config.project_root = paths.project_root
  end
  if paths.unreal_engine_path then
    config.unreal_engine_path = paths.unreal_engine_path
  end
end

-- f(getpath)
function config.get_paths()
  return {
    project_root = config.project_root,
    unreal_engine_path = config.unreal_engine_path
  }
end

return config
