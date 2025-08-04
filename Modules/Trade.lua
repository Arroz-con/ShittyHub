--!strict

-----------------------------
-- SERVICES --
-----------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-----------------------------
-- MODULES --
-----------------------------
local Bypass = require(ReplicatedStorage:WaitForChild("Fsys")).load :: any
local ClientData = Bypass("ClientData")
local RouterClient = Bypass("RouterClient")

-----------------------------
-- VARIABLES --
-----------------------------
local Trade = {}
local AllowOrDenyList = {
    Denylist = {
        "practice_dog",
        "starter_egg",
        "dog",
        "cat",
        "cracked_egg",
        "basic_egg_2022_ant",
        "basic_egg_2022_mouse",
        "spring_2025_minigame_spiked_kaijunior",
        "spring_2025_minigame_scorching_kaijunior",
        "spring_2025_minigame_toxic_kaijunior",
        "spring_2025_minigame_spotted_kaijunior",
        "beach_2024_mahi_spinning_rod_temporary",
        "sandwich-default",
        "squeaky_bone_default",
        "trade_license"
    },

    Allowlist = {
        "ice_dimension_2025_frostbite_bear",
    },
}

local localPlayer = Players.LocalPlayer

-----------------------------
-- PRIVATE FUNCTIONS --
-----------------------------

local function waitForActiveTrade()
    local timeOut = 60
    
    while not ClientData.get_data()[localPlayer.Name].in_active_trade do
        task.wait(1)
        timeOut -= 1
        if timeOut <= 0 then return false, print("⚠️ waiting for trade timedout ⚠️") end
    end
    return true
end

-----------------------------
-- PUBLIC FUNCTIONS --
-----------------------------

-- sender_offer is then one who send the trade
-- recipient_offer is the one who got the trade
function Trade.AcceptNegotiationAndConfirm()
    local timeOut = 30
    repeat
        task.wait(1)
        if ClientData.get_data()[localPlayer.Name].in_active_trade then
            if ClientData.get_data()[localPlayer.Name].trade.current_stage == "negotiation" then
                if not ClientData.get_data()[localPlayer.Name].trade.sender_offer.negotiated then
                    RouterClient.get("TradeAPI/AcceptNegotiation"):FireServer()
                end
            end

            if
                #ClientData.get_data()[localPlayer.Name].trade.sender_offer.items == 0
                and #ClientData.get_data()[localPlayer.Name].trade.recipient_offer.items == 0
            then
                RouterClient.get("TradeAPI/DeclineTrade"):FireServer()
                return false
            end

            if ClientData.get_data()[localPlayer.Name].trade.current_stage == "confirmation" then
                if not ClientData.get_data()[localPlayer.Name].trade.sender_offer.confirmed then
                    RouterClient.get("TradeAPI/ConfirmTrade"):FireServer()
                end
            end
        end

        timeOut -= 1
    until not ClientData.get_data()[localPlayer.Name].in_active_trade or timeOut <= 0

    return true
end

function Trade.SendTradeRequest(player: Player): boolean
    while true do
        local TradeApp = localPlayer:WaitForChild("PlayerGui"):WaitForChild("TradeApp") :: ScreenGui
        local TradeFrame = TradeApp:WaitForChild("Frame") :: Frame
        if TradeFrame.Visible then return true end

        if ClientData.get_data()[player.Name] and not ClientData.get_data()[player.Name].in_active_trade then
            RouterClient.get("TradeAPI/SendTradeRequest"):FireServer(player)
        end
        task.wait(5)
    end
end

local function getPetByLevelOrder(petId: string, maxAmount: number, isNeon: boolean|nil)
    if #ClientData.get_data()[localPlayer.Name].trade.sender_offer.items >= maxAmount then
        return
    end

    local level = 5
    local waitForAdded = 0
    while level > 0 do
        for _, pet in ClientData.get_data()[localPlayer.Name].inventory.pets do
            if table.find(AllowOrDenyList.Denylist, pet.id) then
                continue
            end
            if pet.id == petId and pet.properties.age == level and pet.properties.neon == isNeon then
                if not ClientData.get_data()[localPlayer.Name].in_active_trade then
                    return
                end
                RouterClient.get("TradeAPI/AddItemToOffer"):FireServer(pet.unique)
                waitForAdded += 1
                repeat
                    task.wait(0.1)
                until #ClientData.get_data()[localPlayer.Name].trade.sender_offer.items >= waitForAdded
                    or not ClientData.get_data()[localPlayer.Name].in_active_trade
                
                if #ClientData.get_data()[localPlayer.Name].trade.sender_offer.items >= maxAmount then
                    return
                end
                task.wait(0.1)
            end
        end
        level -= 1
    end
end

function Trade.NewbornToPostteenByPetId(petId: string, maxAmount: number)
    if not waitForActiveTrade() then return end

    getPetByLevelOrder(petId, maxAmount, true)
    getPetByLevelOrder(petId, maxAmount, nil)
end

function Trade.AutoAcceptTrade()
    if ClientData.get_data()[localPlayer.Name].in_active_trade then
        if ClientData.get_data()[localPlayer.Name].trade.sender_offer.negotiated then
            RouterClient.get("TradeAPI/AcceptNegotiation"):FireServer()
        end

        if ClientData.get_data()[localPlayer.Name].trade.sender_offer.confirmed then
            RouterClient.get("TradeAPI/ConfirmTrade"):FireServer()
        end
    end
end

-----------------------------
-- MAIN --
-----------------------------
export type Trade = typeof(Trade)

return Trade
