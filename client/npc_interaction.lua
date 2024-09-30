--- NPCInteraction class for managing NPC interactions.
-- @classmod NPCInteraction

local Config = require 'shared.config'
local Raycast = require 'client.raycast'
local Logger = require 'shared.logger'

local NPCInteraction = {}
NPCInteraction.__index = NPCInteraction

--- Constructor for the NPCInteraction class.
-- @param distance number The distance for the raycast.
-- @return NPCInteraction A new instance of NPCInteraction.
function NPCInteraction:new(distance)
    local self = setmetatable({}, NPCInteraction)
    self.distance = distance or Config.RAYCAST_DISTANCE
    self.targetNPC = nil
    self.isNPCStopped = false
    self.logger = Logger:new(Config.LOGGING_ENABLED, Config.LOGGING_LEVEL)
    return self
end

--- Start the NPC interaction manager.
function NPCInteraction:start()
    local raycast = Raycast:new(self.distance)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            self:checkForNPCInteraction(raycast)
        end
    end)
end

--- Check for NPC interaction.
-- @param raycast Raycast The raycast instance.
function NPCInteraction:checkForNPCInteraction(raycast)
    local playerPed = PlayerPedId()
    if raycast:isPlayerNearNPC(playerPed, self.distance) then
        raycast:perform(function(hit, entityHit, endCoords, surfaceNormal, materialHash)
            self:handleRaycastResult(hit, entityHit, endCoords, surfaceNormal, materialHash)
        end)
    else
        self.logger:info("No NPCs nearby.")
    end
end

--- Handle the result of the raycast.
-- @param hit boolean Whether the raycast hit an entity.
-- @param entityHit number The entity hit by the raycast.
-- @param endCoords vector3 The end coordinates of the raycast.
-- @param surfaceNormal vector3 The surface normal at the hit point (optional).
-- @param materialHash number The material hash at the hit point (optional).
function NPCInteraction:handleRaycastResult(hit, entityHit, endCoords, surfaceNormal, materialHash)
    if hit and entityHit then
        self.logger:info("Raycast hit entity ID: " .. entityHit)
        self.logger:info("Raycast end coordinates: " .. tostring(endCoords))

        if surfaceNormal then
            self.logger:info("Surface normal: " .. tostring(surfaceNormal))
        end

        if materialHash then
            self.logger:info("Material hash: " .. tostring(materialHash))
        end

        if self.targetNPC ~= entityHit then
            self:stopAndTurnNPC(entityHit)
            self.targetNPC = entityHit
            self.isNPCStopped = true
        else
            self:keepFacingPlayer(entityHit)
        end
    else
        if self.targetNPC and self.isNPCStopped then
            self:resumeNPC(self.targetNPC)
            self.targetNPC = nil
            self.isNPCStopped = false
        end
    end
end

--- Stop the NPC and make it turn towards the player.
-- @param entityHit number The entity hit by the raycast.
function NPCInteraction:stopAndTurnNPC(entityHit)
    if entityHit and DoesEntityExist(entityHit) then
        self.logger:info("Stopping NPC with ID: " .. entityHit)
        TaskStandStill(entityHit, -1)
        self:keepFacingPlayer(entityHit)
    else
        self.logger:error("Error: Invalid entity or entity does not exist.")
    end
end

--- Ensure the NPC keeps facing the player.
-- @param entityHit number The entity hit by the raycast.
function NPCInteraction:keepFacingPlayer(entityHit)
    if entityHit and DoesEntityExist(entityHit) then
        local playerPed = PlayerPedId()
        TaskTurnPedToFaceEntity(entityHit, playerPed, 2000)
    else
        self.logger:error("Error: Invalid entity or entity does not exist.")
    end
end

--- Resume the NPC's normal behavior.
-- @param entityHit number The NPC that was being looked at.
function NPCInteraction:resumeNPC(entityHit)
    if entityHit and DoesEntityExist(entityHit) then
        self.logger:info("Resuming NPC with ID: " .. entityHit)
        ClearPedTasks(entityHit)
    else
        self.logger:error("Error: Invalid entity or entity does not exist.")
    end
end

return NPCInteraction
