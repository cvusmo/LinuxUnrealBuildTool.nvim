local log = require("linuxunrealbuildtool.log")

local M = {}

--f(progressinitialize)
function M.init(total_steps, project_path, log_suffix)
  M.total_steps = total_steps or 0
  M.current_step = 0
  log.setup(log_suffix, project_path)
end

--f(progressupdate)
function M.update(current_step)
  M.current_step = current_step
  local percentage = math.floor((M.current_step * 100) / M.total_steps)
  log.log_message("Progress: " .. percentage .. "% completed")
end

return M
