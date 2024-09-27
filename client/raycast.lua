-- Import the configuration module
local Config = require 'shared.config'
local Logger = require 'shared.logger'

-- Define the Raycast class
local Raycast = {}
Raycast.__index = Raycast

--- Constructor for the Raycast class
-- @param distance number The distance for the raycast
-- @return Raycast A new instance of Raycast
function Raycast:new(distance)
    local self = setmetatable({}, Raycast)
    self.distance = distance or Config.RAYCAST_DISTANCE
    self.logger = Logger:new(Config.LOGGING_ENABLED, Config.LOGGING_LEVEL)
    return self
end

--- Perform the raycast from the player's view
-- @param callback function The function to call when an entity is hit
function Raycast:perform(callback)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local forwardVector = GetEntityForwardVector(playerPed)
        local destination = playerCoords + forwardVector * self.distance

        local hit, entityHit, endCoords, surfaceNormal, materialHash
        local success, err = pcall(function()
            hit, entityHit, endCoords, surfaceNormal, materialHash = lib.raycast.fromCoords(playerCoords, destination, 511, 4)
        end)

        if not success then
            self.logger:error("Error performing raycast: " .. err)
            return
        end

        if hit and entityHit and IsEntityAPed(entityHit) and not IsPedAPlayer(entityHit) then
            callback(true, entityHit, endCoords, surfaceNormal, materialHash)
        else
            callback(false)
        end
    end)
end

--- Check if the player is near any NPCs
-- @param playerPed number The player's ped
-- @param distance number The distance to check
-- @return boolean Whether the player is near any NPCs
function Raycast:isPlayerNearNPC(playerPed, distance)
    local playerCoords = GetEntityCoords(playerPed)
    local handle, ped = FindFirstPed()
    local success
    repeat
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            if #(playerCoords - pedCoords) <= distance then
                EndFindPed(handle)
                return true
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return false
end

return Raycast
