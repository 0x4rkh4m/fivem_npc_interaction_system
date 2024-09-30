--- Initialization script for the NPC interaction system.
-- @module init

local Config = require 'shared.config'
local NPCInteraction = require 'client.npc_interaction'
local Logger = require 'shared.logger'

local logger = Logger:new(Config.LOGGING_ENABLED, Config.LOGGING_LEVEL)

Citizen.CreateThread(function()
    local npcManager = NPCInteraction:new(Config.RAYCAST_DISTANCE)
    logger:info("Starting NPC interaction system...")
    npcManager:start()
end)
