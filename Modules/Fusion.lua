local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Bypass = require(ReplicatedStorage:WaitForChild("Fsys", 600)).load
local Player = Players.LocalPlayer

local Fusion = {}

local function getFullgrownPets(mega: boolean): table
    local fullgrownTable = {}

    if mega then
        for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            if v.properties.age == 6 and v.properties.neon then
                if not fullgrownTable[v.id] then
                    fullgrownTable[v.id] = {["count"] = 0, ["unique"] = {}}
                else
                    table.insert(fullgrownTable[v.id]["unique"], v.unique)
                    fullgrownTable[v.id]["count"] += 1
                    if fullgrownTable[v.id]["count"] >= 4 then
                        break
                    end
                end
            end
        end

    else
        for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
            if v.properties.age == 6 and not v.properties.neon and not v.properties.mega_neon then
                if not fullgrownTable[v.id] then
                    fullgrownTable[v.id] = {["count"] = 0, ["unique"] = {}}
                else
                    table.insert(fullgrownTable[v.id]["unique"], v.unique)
                    fullgrownTable[v.id]["count"] += 1
                    if fullgrownTable[v.id]["count"] >= 4 then
                        break
                    end
                end
            end
        end
    end

    return fullgrownTable
end


function Fusion:MakeMega(bool: boolean)
    repeat
        local fusionReady = {}

        local fullgrownTable = getFullgrownPets(bool)

        for _, valueTable in fullgrownTable do
            if valueTable.count >= 4 then
                table.insert(fusionReady, valueTable.unique[1])
                table.insert(fusionReady, valueTable.unique[2])
                table.insert(fusionReady, valueTable.unique[3])
                table.insert(fusionReady, valueTable.unique[4])
                break
            end
        end

        if #fusionReady >= 4 then
            ReplicatedStorage.API:FindFirstChild("PetAPI/DoNeonFusion"):InvokeServer({unpack(fusionReady)})
        end

    until #fusionReady <= 3
    print("done fusion")
end

return Fusion