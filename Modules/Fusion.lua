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
                end
                table.insert(fullgrownTable[v.id]["unique"], v.unique)
                if #fullgrownTable[v.id]["unique"] >= 4 then
                    break
                end
            end
        end
    end

    return fullgrownTable
end


function Fusion:MakeNeon()
    local fusionReady = {}

    local fullgrownTable = getFullgrownPets(true)

    for _, valueTable in fullgrownTable do
        if valueTable.count >= 4 then
            table.insert(valueTable.unique[1])
            table.insert(valueTable.unique[2])
            table.insert(valueTable.unique[3])
            table.insert(valueTable.unique[4])
            break
        end
    end

    if #fusionReady >= 4 then
        print("fusion")
        ReplicatedStorage.API:FindFirstChild("PetAPI/DoNeonFusion"):InvokeServer({unpack(fusionReady)})
    end
    print("finished")
    -- for _, v in Bypass("ClientData").get_data()[Player.Name].inventory.pets do
    --     if v.id == maketoneon[1] and v.properties.age == 6 and not v.properties.neon and not v.properties.mega_neon then
    --         table.insert(maketoneonnow, v.unique)
    --         fullgrownCounter = fullgrownCounter + 1
    --         if fullgrownCounter == 4 then
    --             fullgrownCounter = 0
    --             break
    --         end
    --     end
    -- end

    
    -- ReplicatedStorage.API:FindFirstChild("PetAPI/DoNeonFusion"):InvokeServer({unpack(maketoneonnow)})

end


return Fusion