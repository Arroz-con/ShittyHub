local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local InventoryDB = Bypass("InventoryDB")

local Trade = {}

local lowTierRarity = {"common", "uncommon", "rare", "ultra_rare"}

local function inActiveTrade()
    local timeOut = 60
    repeat
        task.wait(1)
        timeOut -= 1
    until Bypass("ClientData").get_data()[Player.Name].in_active_trade or timeOut <= 0

    if timeOut <= 0 then
        print("timeOut is 0, no trade window")
        return
    end

    if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
        return
    end
end

-- sender_offer is then one who send the trade
-- recipient_offer is the one who got the trade
function Trade:AcceptNegotiationAndConfirm()
    local timeOut = 30
    repeat
        if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
            if Bypass("ClientData").get_data()[Player.Name].trade.current_stage == "negotiation" then
                if not Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.negotiated then
                    ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
                end
            end

            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items == 0 and #Bypass("ClientData").get_data()[Player.Name].trade.recipient_offer.items == 0 then
                ReplicatedStorage.API:FindFirstChild("TradeAPI/DeclineTrade"):FireServer()
                return false
            end

            if Bypass("ClientData").get_data()[Player.Name].trade.current_stage == "confirmation" then
                if not Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.confirmed then
                    ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
                end
            end
        end

        task.wait(1)
        timeOut -= 1
        print("active trade")
    until not Bypass("ClientData").get_data()[Player.Name].in_active_trade or timeOut <= 0
    print("no active trade")
    return true
end


function Trade:SendTradeRequest(selectedPlayer: Instance)
    if not Player.PlayerGui.TradeApp.Frame.Visible then
        repeat
            ReplicatedStorage.API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(selectedPlayer)
            task.wait(10)
        until Player.PlayerGui.TradeApp.Frame.Visible or not Players[selectedPlayer.Name]
    end
end




function Trade:SelectTabAndTrade(tab: string, selectedItem: string)
    inActiveTrade()
    for _, item in Bypass("ClientData").get_data()[Player.Name].inventory[tab] do
        if item.id == selectedItem then
            if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
            ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(item.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                return
            end
            task.wait(0.1)
        end
    end
end


function Trade:NeonNewbornToPostteen()
    inActiveTrade()

    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do 
        if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
        if pet.properties.age <=5 and pet.properties.neon then
            if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                return
            end
            task.wait(0.1)
        end
    end
end


function Trade:LowTiers()
    inActiveTrade()

    for _, petDB in InventoryDB.pets do
        for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do 
            if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
            if petDB.id == pet.id and table.find(lowTierRarity, petDB.rarity) and pet.properties.age <=5 and not pet.properties.neon and not pet.properties.mega_neon then
                if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
                ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
                if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                    return
                end
                task.wait(0.1)
            end
        end
    end
end


function Trade:NewbornToPostteen(rarity: string)
    inActiveTrade()

    for _, petDB in InventoryDB.pets do
        for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
            if petDB.id == pet.id and petDB.rarity == rarity and pet.properties.age <=5 and not pet.properties.neon and not pet.properties.mega_neon then
                if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
                ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique) 
                if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                    return
                end
                task.wait(0.1)
            end
        end
    end
end


function Trade:NewbornToPostteenByPetId(petIds: table)
    if typeof(petIds) ~= "table" then print("not a table") return end

    inActiveTrade()

    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
        if table.find(petIds, pet.id) and pet.properties.age <=5 and not pet.properties.mega_neon then
            if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                return
            end
            task.wait(0.1)
        end
    end
end


function Trade:Fullgrown()
    inActiveTrade()

    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.properties.age == 6 or (pet.properties.age == 6 and pet.properties.neon) or pet.properties.mega_neon then
            if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                return
            end
            task.wait(0.1)
        end
    end
end


function Trade:AllPetsOfSameRarity(rarity: string)
    inActiveTrade()

    for _, petDB in InventoryDB.pets do
        for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do     
            if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
            if petDB.id == pet.id and petDB.rarity == rarity then
                if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
                ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
                if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                    return
                end
                task.wait(0.1)
            end
        end
    end
end


function Trade:AutoAcceptTrade()
    if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
        if Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.negotiated then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
        end

        if Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.confirmed then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
        end
    end
end


function Trade:AllInventory(TabPassOn: string) -- need to test
    inActiveTrade()

    for _, item in Bypass("ClientData").get_data()[Player.Name].inventory[TabPassOn] do
        if item.id == "practice_dog" or item.id == "starter_egg" then continue end
        if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
        ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(item.unique)
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
            return
        end
        task.wait(0.1)
    end
end


function Trade:AllPets()
    inActiveTrade()

    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.id == "practice_dog" or pet.id == "starter_egg" then continue end
        if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
        ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
            return
        end
       
        task.wait(0.1)
    end
end


function Trade:AllNeons(version: string)
    inActiveTrade()

    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.properties[version] then
            if not Bypass("ClientData").get_data()[Player.Name].in_active_trade then return end
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                return
            end
            task.wait(0.1)
        end
    end
end


return Trade