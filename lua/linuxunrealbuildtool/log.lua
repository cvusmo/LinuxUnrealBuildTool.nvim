local path = require("linuxunrealbuildtool.path")

local M = {}

local log_dir = ""
local log_file = ""

-- f(logdir)
function M.setup(log_suffix, project_path)
  log_dir = project_path .. "/Log"
  log_file = log_dir .. "/" .. os.date("%Y-%m-%d_%H-%M-%S") .. "_" .. log_suffix .. ".log"
  if log_dir then
    os.execute("mkdir -p " .. log_dir)
  else
    print("Error: log_dir is nil")
  end
end

-- f(get_log_file)
function M.get_log_file()
  return log_file
end

-- f(logmessages)
function M.log_message(message)
  local time_stamp = os.date("%Y-%m-%d %H:%M:%S")
  local log_entry = time_stamp .. " - " .. message
  local log_command = string.format("echo '%s' | tee -a %s", log_entry, log_file)

  if log_file then
    os.execute(log_command)
  else
    print("Error: log_file is nil")
  end
end

-- f(logtrashcollector)
function M.log_trashcollector()
  if log_dir then
    local handle = io.popen("ls -1 " .. log_dir .. "/*.log 2>/dev/null | wc -l")
    if handle then
      local log_count = handle:read("*a")
      handle:close()

      if tonumber(log_count) > 5 then
        os.execute("ls -1t " .. log_dir .. "/*.log | tail -n +6 | xargs rm -f")
      end
    else
      print("Error: Failed to open pipe to execute command.")
    end
  else
    print("Error: log_dir is nil")
  end
end

return M
