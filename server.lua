RegisterNetEvent('ponta_presence:requestPlayerInfo', function()
    local src = source
    local playerCount = GetNumPlayerIndices()
    local maxClients = tonumber(GetConvar("sv_maxclients", "32"))
    TriggerClientEvent('ponta_presence:client:SetCurrentPlayers', src, playerCount, maxClients)
end)