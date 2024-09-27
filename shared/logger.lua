local Config = require 'shared.config'

-- Define logging levels
local levels = { DEBUG = 1, INFO = 2, WARN = 3, ERROR = 4 }

-- Define the Logger class
local Logger = {}
Logger.__index = Logger

--- Constructor for the Logger class
-- @param enabled boolean Whether logging is enabled
-- @param level string The logging level
-- @return Logger A new instance of Logger
function Logger:new(enabled, level)
    local self = setmetatable({}, Logger)
    self.enabled = enabled or Config.LOGGING_ENABLED
    self.level = levels[level] or levels[Config.LOGGING_LEVEL]
    return self
end

--- Log a debug message
-- @param message string The message to log
function Logger:debug(message)
    if self.enabled and self.level <= levels.DEBUG then
        print("[DEBUG] " .. message)
    end
end

--- Log an info message
-- @param message string The message to log
function Logger:info(message)
    if self.enabled and self.level <= levels.INFO then
        print("[INFO] " .. message)
    end
end

--- Log a warning message
-- @param message string The message to log
function Logger:warn(message)
    if self.enabled and self.level <= levels.WARN then
        print("[WARN] " .. message)
    end
end

--- Log an error message
-- @param message string The message to log
function Logger:error(message)
    if self.enabled and self.level <= levels.ERROR then
        print("[ERROR] " .. message)
    end
end

return Logger
