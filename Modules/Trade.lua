local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load

local Trade = {}

local function AcceptNegotiationAndConfirm(toggleName: string)
    if Bypass("ClientData").get_data()[Player.Name].in_active_trade then
        if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items == 0 then
            getgenv()[toggleName]:Set(false)
            ReplicatedStorage.API:FindFirstChild("TradeAPI/DeclineTrade"):FireServer()
            return
        end
    end
    ReplicatedStorage.API:FindFirstChild("TradeAPI/AcceptNegotiation"):FireServer()
    task.wait(3)
    ReplicatedStorage.API:FindFirstChild("TradeAPI/ConfirmTrade"):FireServer()
end


function Trade:sendTradeRequest(selectedPlayer: Instance)
    if not Player.PlayerGui.TradeApp.Frame.Visible then
        repeat
            print("trade sent to "..selectedPlayer.Name)
            ReplicatedStorage.API:FindFirstChild("TradeAPI/SendTradeRequest"):FireServer(selectedPlayer)
            task.wait(10)
        until Player.PlayerGui.TradeApp.Frame.Visible
    end
end

function Trade:AllPets(selectedPlayer: Instance)
    while getgenv().auto_trade_all_pets do

        Trade:sendTradeRequest(selectedPlayer)

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

        AcceptNegotiationAndConfirm("allPetsToggle")
        task.wait()
    end
end


function Trade:AllNeons(version: string, toggleName: string, selectedPlayer: Instance)
    while getgenv().auto_trade_all_neons do

        Trade:sendTradeRequest(selectedPlayer)
        
        pcall(function()
            for _, pet in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
                if pet.properties[version] then
                    ReplicatedStorage.API["TradeAPI/AddItemToOffer"]:FireServer(pet.unique)

                    if #Bypass("ClientData").get_data()[Player.Name].trade.sender_offer.items >= 18 then
                        break
                    end
                    task.wait(0.1)
                end
            end

            AcceptNegotiationAndConfirm(toggleName)
        end)
        task.wait()
    end
end

return Trade