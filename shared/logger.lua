--- Logger class for handling logging.
-- @classmod Logger

local Logger = {}
Logger.__index = Logger

--- Constructor for the Logger class.
-- @param enabled boolean Whether logging is enabled.
-- @param level string The logging level (DEBUG, INFO, WARN, ERROR).
-- @return Logger A new instance of Logger.
function Logger:new(enabled, level)
    local self = setmetatable({}, Logger)
    self.enabled = enabled
    self.level = level
    return self
end

--- Log a message at the specified level.
-- @param level string The logging level.
-- @param message string The message to log.
function Logger:log(level, message)
    if self.enabled and self.level == level then
        print("[" .. level .. "] " .. message)
    end
end

--- Log a debug message.
-- @param message string The message to log.
function Logger:debug(message)
    self:log("DEBUG", message)
end

--- Log an info message.
-- @param message string The message to log.
function Logger:info(message)
    self:log("INFO", message)
end

--- Log a warning message.
-- @param message string The message to log.
function Logger:warn(message)
    self:log("WARN", message)
end

--- Log an error message.
-- @param message string The message to log.
function Logger:error(message)
    self:log("ERROR", message)
end

return Logger
