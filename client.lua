local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

vRP = Proxy.getInterface("vRP")

raizen = Tunnel.getInterface("entregador_jornal") --conectar criando tunel 

local coordBlip = Config.blip --Puxando info da config
local coordVehicle = Config.vehicleCoords --puxando info da config
local x,y,z = coordBlip.x, coordBlip.y, coordBlip.z --puxando info da config

local servico
local veiculo

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId() --native do five m para pegar entidade
        local player = GetEntityCoords(ped) --pegar a coordenada de uma entidade
        local distancia = #(player - blip) --calculo para verificar a distancia entre duas coords
        if distancia < 5 then
            texto3D() --função para aparecer o texto
            DrawMarker(6, x, y, z-1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255, 255, 0, 0, 2, 1) --criar blip
            if distancia < 0.5 then
                if IsControlJustPressed(0, 38) and not servico then --not esta verificando se servico é um valor falso
                    TriggerEvent('Notify', "Sucesso", "Você entrou em Serviço", 1000) --chamando evento de notify
                    servico = true
                    spawnVeiculo()
                    emServico()
                end
            end
        end
    end
end)

--função para criar um texto 3D
function texto3D()
    local screen,coordX,coordY = GetScreenCoordFromWorldCoord(x, y, z) --pegar coordenada da tela e verificar se estou olhando para a coordenada.
    if screen then
        SetTextFont(1) --tipo de fonte
        SetTextScale(0.4, 0.4) --tamanho da foonte
        SetTextColour(255, 255, 255, 255) --mudar cor rgba do texto
        SetTextCentre(1) --alinhar o texto
        SetTextEntry("STRING") --setar um tipo de valor ao texto
        AddTextComponentString('[E] Para entrar em Serviço') --mensagem de texto
        DrawText(coordX,coordY) --local onde o texto irá ficar
    end
end
--função spawn veiculo
function spawnVeiculo()
    local hash = GetHashKey(tribike3) --pegar a hash de algum objeto ou veiculo
    while not HasModelLoades() do --verificar se o objeto foi carregado
        Wait(10)
        RequestModel(hash)
    end
    veiculo = CreateVehicle(hash, coordVehicle.x, coordVehicle.y, coordVehicle.z, 162.00, true, true) --spawn do veiculo
    setVehiclleNumberPlateText(veiculo, vRP.getRegistrationNumber()) --setar uma placa no nome da pessoa
end

function emServico()
    CreateThread(function()
        while servico do
            for k, v in pairs(Config.locais) do --estamos pegando todas as coordenadas as locais...
                local ped = PlayerPedId()
                local playerCoords = GetEntityCoords(ped)
                if Config.locais[k] then
                   local coordLocais = vec3(v.x, v.y, v.z)
                   local distancia = #(playerCoords - coordLocais)
                   if distancia < 10 then
                        DrawMarker(1, coordLocais.x, coordLocais.y, coordLocais.z-1, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 255, true, false, 2, false)
                        if distancia < 0.5 then
                            if IsControlJustPressed(0, 38) then --verificando o ultimo carro que o player estava tem que ser a hash ali citada se não n continua. se esta fora de veiculo da continuidade
                                if IsVehicleModel(GetVehiclePedIsIn(ped, true), GetHashKey("tribike3")) and not IsPedInAnyVehicle(ped, true) then
                                    raizen.pagamentoItens()
                                    TriggerEvent('Notify', "Sucesso", "Você entregou o jornal", 1000) --chamando evento de notify
                                    Config.locais[k] = nil
                                    SetTimeout(5000, function() --settimeout não interrompe o codigo diferente do wait
                                        Config.locais[k] = v
                                    end)
                                end
                            end
                        end
                    end
                end
            end
            Wait(5)
        end
    end)
end

function sairDoServico()
    CreateThread(function()
        while servico do
            if IsControlJustPressed(0, 168) then
                servico = false
                DeleteEntity(veiculo)
                TriggerEvent('Notify', 'aviso', 'Você saiu de Serviço')
            end
            Wait(5)
        end
    end)    
end


--[[function texto3D()
    local screen,coordX,coordY = GetScreenCoordFromWorldCoord(blip.x, blip.y, blip.z)
    if screen then
        SetTextFont(1)
        SetTextScale(0.4, 0.4)
        SetTextColour(255, 255, 255, 255)
        SetTextCentre(1)
        SetTextEntry("STRING")
        AddTextComponentString('[F] Para sair do Serviço')
        DrawText(coordX,coordY)
    end
end]]