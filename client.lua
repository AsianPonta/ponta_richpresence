local Framework = nil
local isESX = false
local isPlayerLoaded = false
local playerName = nil
local ID = GetPlayerServerId(PlayerId())

CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        Framework = exports['es_extended']:getSharedObject()
        isESX = true

        while not Framework.GetPlayerData().identifier do
            Wait(100)
        end

        isPlayerLoaded = true
        local PlayerData = Framework.GetPlayerData()
        playerName = PlayerData.firstName .. " " .. PlayerData.lastName

        RegisterNetEvent('esx:playerLoaded', function(xPlayer)
            isPlayerLoaded = true
            playerName = xPlayer.firstName .. " " .. xPlayer.lastName
        end)

        RegisterNetEvent('esx:onPlayerLogout', function()
            isPlayerLoaded = false
            playerName = nil
        end)
    elseif GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()

        while Framework.Functions.GetPlayerData().metadata == nil do
            Wait(100)
        end

        isPlayerLoaded = true
        local Player = Framework.Functions.GetPlayerData()
        playerName = Player.charinfo.firstname .. " " .. Player.charinfo.lastname

        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            isPlayerLoaded = true
            local Player = Framework.Functions.GetPlayerData()
            playerName = Player.charinfo.firstname .. " " .. Player.charinfo.lastname
        end)

        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            isPlayerLoaded = false
            playerName = nil
        end)
    end
end)

RegisterNetEvent('ponta_presence:client:SetCurrentPlayers', function(playerCount, maxPlayers)
    local topText = "Väljer Karaktär"
    if isPlayerLoaded and playerName then
        topText = "Rollspelar som: " .. playerName
    end

    SetRichPresence("ID: " .. ID .. " | " .. playerCount .. "/" .. maxPlayers .. "\n" .. topText)
end)

CreateThread(function()
    while true do
        SetDiscordAppId(Config.applicationId)
        SetDiscordRichPresenceAsset(Config.iconLarge)
        SetDiscordRichPresenceAssetText(Config.iconLargeHoverText)
        SetDiscordRichPresenceAssetSmall(Config.iconSmall)
        SetDiscordRichPresenceAssetSmallText(Config.iconSmallHoverText)

        TriggerServerEvent('ponta_presence:requestPlayerInfo')

        if Config.buttons and type(Config.buttons) == "table" then
            for i, v in pairs(Config.buttons) do
                SetDiscordRichPresenceAction(i - 1, v.text, v.url)
            end
        end

        Wait(Config.updateRate)
    end
end)