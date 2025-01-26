local seuilDrift = 8.0
local multiplicateurDrift = 1.5

local estEnDrift = false
local pointsDrift = 0
local modeDriftActive = false

local function calculerAngleDrift(vehicule)
    local vitesse = GetEntityVelocity(vehicule)
    local vitesseTotale = math.sqrt(vitesse.x^2 + vitesse.y^2 + vitesse.z^2)
    local vecteurAvant = GetEntityForwardVector(vehicule)
    local produitScalaire = vitesse.x * vecteurAvant.x + vitesse.y * vecteurAvant.y + vitesse.z * vecteurAvant.z
    local angle = math.acos(produitScalaire / vitesseTotale) * (180 / math.pi)
    return angle
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local joueur = PlayerPedId()
        if IsPedInAnyVehicle(joueur, false) then
            local vehicule = GetVehiclePedIsIn(joueur, false)
            if IsControlPressed(0, 21) then -- Touche Shift gauche
                local angleDrift = calculerAngleDrift(vehicule)
                if angleDrift > seuilDrift then
                    if not estEnDrift then
                        estEnDrift = true
                        TriggerEvent('chat:addMessage', { args = { '^2Mode drift activé!' } })
                        modeDriftActive = true
                    end
                    pointsDrift = pointsDrift + math.floor(angleDrift * multiplicateurDrift)
                    TriggerEvent('chat:addMessage', { args = { 'Points de drift: ' .. pointsDrift } })
                else
                    if estEnDrift then
                        estEnDrift = false
                        TriggerEvent('chat:addMessage', { args = { '^1Mode drift désactivé!' } })
                        modeDriftActive = false
                    end
                end
            else
                if estEnDrift then
                    estEnDrift = false
                    TriggerEvent('chat:addMessage', { args = { '^1Mode drift désactivé!' } })
                    modeDriftActive = false
                end
            end
        else
            if estEnDrift then
                estEnDrift = false
                TriggerEvent('chat:addMessage', { args = { '^1Mode drift désactivé!' } })
                modeDriftActive = false
            end
        end
    end
end)
-- Créé par Meliodassge