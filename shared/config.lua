--- Configuration settings for the NPC interaction system.
-- @module Config

local Config = {}
Config.__index = Config

--- Default ray cast distance in meters.
Config.RAYCAST_DISTANCE = 6.0

--- Enable or disable logging.
Config.LOGGING_ENABLED = true

--- Set the logging level (DEBUG, INFO, WARN, ERROR).
Config.LOGGING_LEVEL = "DEBUG"

return Config
