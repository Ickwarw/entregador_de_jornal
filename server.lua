local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
raizen = {}
Tunnel.bindInterface("entregador_jornal", raizen)

function raizen.pagamentoItens()
    local source = source --source só existe em players é um identificador com o identificador consegue pegar o id do player.
    local user_id = vRP.vRP.getUserId(source) --  essa função volta o id precisa chamar ela no client
    vRPclient._playAnim(source, false,{{"taxi_hail", "hail_taxi"}}, true) --com a tunnelagem lá em cima é possivel setar uma animação da pasta vrp_animacoes
    SetTimeout(5000, function() --setando 5 segundos para a função de stopar a animação abaixo seja lido pelo programa.
        vRPclient._stopAnim(source, false) --parar qualquer animação
        for k, v in pairs(Config.itens) do --pegando os itens da tabela e a quantidade que ira receber
            local randomQuantidade = math.random(v.quantidade.min, v.quantidade.max) --randomizando a quantidade de itens que ira receber
            giveInventoryItem(user_id, v.item, randomQuantidade) --entregando o item
            TriggerClientEvent('Notify', source, "Aviso", "Você recebeu <b>".. v.item .."</b>".. randomQuantidade .. "x") --evento lá do client(notificando o item e quantidade)
        end   
    end)
end

function raizen.pagamentoDinheiro()
    local source = source
    local user_id = vRP.vRP.getUserId(source)
    vRPclient._playAnim(source, false,{{"amb@medic@standing@tendtodead@idle_a", "idle_a"}}, true) --com a tunnelagem lá em cima é possivel setar uma animação da pasta vrp_animacoes
    SetTimeout(5000, function() --setando 5 segundos para a função de stopar a animação abaixo seja lido pelo programa.
        vRPclient._stopAnim(source, false) --parar qualquer animação
        local randomPagamento = math.random(Config.pagamento.min, Config.pagamento.max ) -- randomizando o pagamento entre o maximo e o minimo
        vRP.giveMoney(user_id,randomPagamento) --função para entregar o dinheiro
        TriggerClientEvent('Notify', source, 'aviso', 'Você recebeu R$<b>'.. randomPagamento .. '</b>') --notificando o pagamento e a quantidade
    end)
end