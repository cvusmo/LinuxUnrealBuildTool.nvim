local config = {
  project_root = os.getenv("HOME") .. "/Projects/remote",
  unreal_engine_path = os.getenv("HOME") .. "/Projects/remote/UnrealEngine"
}

function config.set_paths(paths)
  if paths.project_root then
    config.project_root = paths.project_root
  end
  if paths.unreal_engine_path then
    config.unreal_engine_path = paths.unreal_engine_path
  end
end

return config
