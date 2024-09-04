local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load
local InventoryDB = Bypass("InventoryDB")

local Trade = {}

local lowTierRarity = {"common", "uncommon", "rare", "ultra_rare"}

function Trade:AcceptNegotiationAndConfirm()
    if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items == 0 then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/DeclineTrade"):FireServer()
            return false
        end
    end

    ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
    task.wait(3)
    ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
    return true
end


function Trade:SendTradeRequest(selectedPlayer: Instance)
    if not Player.PlayerGui.TradeApp.Frame.Visible then
        repeat
            print("trade sent to "..selectedPlayer.Name)
            ReplicatedStorage.API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(selectedPlayer)
            task.wait(10)
        until Player.PlayerGui.TradeApp.Frame.Visible
    end
end


function Trade:SelectTabAndTrade(tab: string, selectedItem: string)
    for _, item in Bypass("ClientData").get_data()[Player.Name].inventory[tab] do
        if item.id == selectedItem then
            ReplicatedStorage.API:FindFirstChild("TradeAPI/AddItemToOffer"):FireServer(item.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                break
            end
            task.wait(0.1)
        end
    end
end


function Trade:LowTiers()
    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.id == "practice_dog" then continue end
        if table.find(lowTierRarity, pet.rarity) and pet.properties.age <=5 and not pet.properties.neon and not pet.properties.mega_neon then
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                break
            end
            task.wait(0.1)
        end
    end
end


function Trade:Fullgrown()
    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.properties.age == 6 or (pet.properties.age == 6 and pet.properties.neon) or pet.properties.mega_neon then
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                break
            end
            task.wait(0.1)
        end
    end
end


function Trade:AllPetsOfSameRarity(rarity: string)
    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        for _, petDB in InventoryDB.pets do
            if pet.id == "practice_dog" then continue end
            if rarity == petDB.rarity and pet.id == petDB.id then
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
    if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
            return
        end
    end

    for _, item in Bypass("ClientData").get_data()[Player.Name].inventory[TabPassOn] do
        if item.id == "practice_dog" then continue end
        ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(item.unique)
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
            break
        end
        task.wait(0.1)
    end
end


function Trade:AllPets()
    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.id == "practice_dog" then continue end

        if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)
            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                break
            end
        end
        task.wait(0.1)
    end
end


function Trade:AllNeons(version: string)
    for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
        if pet.properties[version] then
            ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)

            if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                break
            end
            task.wait(0.1)
        end
    end
end

return Trade