local __DARKLUA_BUNDLE_MODULES

__DARKLUA_BUNDLE_MODULES = {
    cache = {},
    load = function(m)
        if not __DARKLUA_BUNDLE_MODULES.cache[m] then
            __DARKLUA_BUNDLE_MODULES.cache[m] = {
                c = __DARKLUA_BUNDLE_MODULES[m](),
            }
        end

        return __DARKLUA_BUNDLE_MODULES.cache[m].c
    end,
}

do
    function __DARKLUA_BUNDLE_MODULES.a()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Players = game:GetService('Players')
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local localPlayer = Players.LocalPlayer
        local Fusion = {}

        local function getFullgrownPets(mega)
            local fullgrownTable = {}

            if mega then
                for _, v in ClientData.get_data()[localPlayer.Name].inventory.pets do
                    if v.properties.age == 6 and v.properties.neon then
                        if not fullgrownTable[v.id] then
                            fullgrownTable[v.id] = {
                                ['count'] = 0,
                                ['unique'] = {},
                            }
                        end

                        fullgrownTable[v.id]['count'] += 1

                        table.insert(fullgrownTable[v.id]['unique'], v.unique)

                        if fullgrownTable[v.id]['count'] >= 4 then
                            break
                        end
                    end
                end
            else
                for _, v in ClientData.get_data()[localPlayer.Name].inventory.pets do
                    if v.properties.age == 6 and not v.properties.neon and not v.properties.mega_neon then
                        if not fullgrownTable[v.id] then
                            fullgrownTable[v.id] = {
                                ['count'] = 0,
                                ['unique'] = {},
                            }
                        end

                        fullgrownTable[v.id]['count'] += 1

                        table.insert(fullgrownTable[v.id]['unique'], v.unique)

                        if fullgrownTable[v.id]['count'] >= 4 then
                            break
                        end
                    end
                end
            end

            return fullgrownTable
        end

        function Fusion:MakeMega(bool)
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
                    ReplicatedStorage.API:FindFirstChild('PetAPI/DoNeonFusion'):InvokeServer({
                        unpack(fusionReady),
                    })
                end
            until #fusionReady <= 3
        end

        return Fusion
    end
    function __DARKLUA_BUNDLE_MODULES.b()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Players = game:GetService('Players')
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local InventoryDB = require(ReplicatedStorage:WaitForChild('ClientDB'):WaitForChild('Inventory'):WaitForChild('InventoryDB'))
        local localPlayer = Players.LocalPlayer
        local GetInventory = {}

        function GetInventory:TabId(tabId)
            local inventoryTable = {}

            for _, v in ClientData.get_data()[localPlayer.Name].inventory[tabId]do
                if v.id == 'practice_dog' then
                    continue
                end
                if table.find(inventoryTable, v.id) then
                    continue
                end

                table.insert(inventoryTable, v.id)
            end

            table.sort(inventoryTable)

            return inventoryTable
        end
        function GetInventory:GetPetFriendship()
            local level = 0
            local petUnique = nil

            for _, pet in ClientData.get_data()[localPlayer.Name].inventory.pets do
                if pet.id ~= 'practice_dog' then
                    continue
                end
                if pet.properties.friendship_level > level then
                    level = pet.properties.friendship_level
                    petUnique = pet.unique
                end
            end

            if not petUnique then
                return false
            end

            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(petUnique, {})

            getgenv().PetCurrentlyFarming = petUnique

            return true
        end
        function GetInventory:PetRarityAndAge(rarity, age)
            local PetageCounter = age or 5
            local isNeon = true
            local petFound = false

            while not petFound do
                for _, pet in ClientData.get_data()[localPlayer.Name].inventory.pets do
                    for _, petDB in InventoryDB.pets do
                        if rarity == petDB.rarity and pet.id == petDB.id and pet.id ~= 'practice_dog' and pet.properties.age == PetageCounter and pet.properties.neon == isNeon then
                            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(pet.unique, {})

                            getgenv().PetCurrentlyFarming = pet.unique

                            return true
                        end
                    end
                end

                PetageCounter -= 1

                if PetageCounter <= 0 and isNeon then
                    PetageCounter = age or 5
                    isNeon = nil
                elseif PetageCounter <= 0 and isNeon == nil then
                    return false
                end

                task.wait()
            end

            return false
        end
        function GetInventory:GetUniqueId(tabId, nameId)
            for _, v in ClientData.get_data()[localPlayer.Name].inventory[tabId]do
                if v.id == nameId then
                    return v.unique
                end
            end

            return nil
        end
        function GetInventory:PriorityEgg()
            for _, v in ipairs(getgenv().SETTINGS.HATCH_EGG_PRIORITY_NAMES)do
                for _, v2 in ClientData.get_data()[localPlayer.Name].inventory.pets do
                    if v == v2.id and v2.id ~= 'practice_dog' then
                        ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v2.unique, {
                            ['use_sound_delay'] = true,
                        })

                        getgenv().PetCurrentlyFarming = v2.unique

                        return true
                    end
                end
            end

            return false
        end
        function GetInventory:GetPetEggs()
            local eggs = {}

            for i, v in InventoryDB.pets do
                if v.is_egg then
                    table.insert(eggs, v.id)
                end
            end

            return eggs
        end
        function GetInventory:GetNeonPet()
            local Petage = 5
            local isNeon = true
            local found_pet = false

            while not found_pet do
                for _, v in ClientData.get_data()[localPlayer.Name].inventory.pets do
                    if v.id ~= 'practice_dog' and v.properties.age == Petage and v.properties.neon == isNeon then
                        ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v.unique, {
                            ['use_sound_delay'] = true,
                        })

                        getgenv().PetCurrentlyFarming = v.unique

                        return true
                    end
                end

                if not found_pet then
                    Petage = Petage - 1

                    if Petage == 0 and isNeon == true then
                        return false
                    end
                end

                task.wait()
            end

            return false
        end
        function GetInventory:PriorityPet()
            local Petage = 5
            local isNeon = true
            local found_pet = false

            while found_pet == false do
                for _, v in ipairs(getgenv().SETTINGS.PET_ONLY_PRIORITY_NAMES)do
                    for _, v2 in pairs(ClientData.get_data()[localPlayer.Name].inventory.pets)do
                        if v == v2.id and v2.id ~= 'practice_dog' and v2.properties.age == Petage and v2.properties.neon == isNeon then
                            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v2.unique, {
                                ['use_sound_delay'] = true,
                            })

                            getgenv().PetCurrentlyFarming = v2.unique

                            return true
                        end
                    end
                end

                if found_pet == false then
                    Petage = Petage - 1

                    if Petage == 0 and isNeon == true then
                        Petage = 5
                        isNeon = nil
                    elseif Petage == 0 and isNeon == nil then
                        return false
                    end
                end

                task.wait()
            end

            return false
        end

        return GetInventory
    end
    function __DARKLUA_BUNDLE_MODULES.c()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Workspace = game:GetService('Workspace')
        local Players = game:GetService('Players')
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local CollisionsClient = require(ReplicatedStorage.ClientModules.Game.CollisionsClient)
        local Player = Players.LocalPlayer
        local getconstants = getconstants or debug.getconstants
        local getgc = getgc or get_gc_objects or debug.getgc
        local get_thread_identity = get_thread_identity or gti or getthreadidentity or getidentity or syn.get_thread_identity or fluxus.get_thread_identity
        local set_thread_identity = set_thread_context or sti or setthreadcontext or setidentity or syn.set_thread_identity or fluxus.set_thread_identity
        local SetLocationTP
        local rng = Random.new()
        local Teleport = {}

        for _, v in pairs(getgc())do
            if type(v) == 'function' then
                if getfenv(v).script == ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
                    if table.find(getconstants(v), 'LocationAPI/SetLocation') then
                        SetLocationTP = v

                        break
                    end
                end
            end
        end

        local function SetLocationFunc(a, b, c)
            local k = get_thread_identity()

            set_thread_identity(2)
            SetLocationTP(a, b, c)
            set_thread_identity(k)
        end

        function Teleport.PlaceFloorAtFarmingHome()
            if Workspace:FindFirstChild('FarmingHomeLocation') then
                return
            end

            local part = Instance.new('Part')
            local SurfaceGui = Instance.new('SurfaceGui')
            local TextLabel = Instance.new('TextLabel')

            part.Position = Vector3.new(1000, 0, 1000)
            part.Size = Vector3.new(200, 2, 200)
            part.Anchored = true
            part.Transparency = 1
            part.Name = 'FarmingHomeLocation'
            part.Parent = Workspace
            SurfaceGui.Parent = part
            SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            SurfaceGui.AlwaysOnTop = false
            SurfaceGui.CanvasSize = Vector2.new(600, 600)
            SurfaceGui.Face = Enum.NormalId.Top
            TextLabel.Parent = SurfaceGui
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.BorderSizePixel = 0
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = '\u{1f3e1}'
            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14
            TextLabel.TextWrapped = true
        end
        function Teleport.PlaceFloorAtCampSite()
            if Workspace:FindFirstChild('CampingLocation') then
                return
            end

            local campsite = Workspace.StaticMap.Campsite.CampsiteOrigin
            local part = Instance.new('Part')

            part.Position = campsite.Position + Vector3.new(0, -1, 0)
            part.Size = Vector3.new(200, 2, 200)
            part.Anchored = true
            part.Transparency = 1
            part.Name = 'CampingLocation'
            part.Parent = Workspace
        end
        function Teleport.PlaceFloorAtBeachParty()
            if Workspace:FindFirstChild('BeachPartyLocation') then
                return
            end

            local part = Instance.new('Part')

            part.Position = Workspace.StaticMap.Beach.BeachPartyAilmentTarget.Position + Vector3.new(0, 
-10, 0)
            part.Size = Vector3.new(200, 2, 200)
            part.Anchored = true
            part.Transparency = 1
            part.Name = 'BeachPartyLocation'
            part.Parent = Workspace
        end
        function Teleport.placeFloorOnJoinZone()
            for _, v in Workspace:GetChildren()do
                if v.Name == 'FloorPart2' then
                    return
                end
            end

            local part = Instance.new('Part')

            part.Position = game.Workspace.Interiors:WaitForChild('Halloween2024Shop'):WaitForChild('TileSkip'):WaitForChild('JoinZone'):WaitForChild('EmitterPart').Position + Vector3.new(0, 
-2, 0)
            part.Size = Vector3.new(100, 2, 100)
            part.Anchored = true
            part.Name = 'FloorPart2'
            part.Parent = Workspace
        end
        function Teleport.DeleteWater()
            if Workspace:FindFirstChildWhichIsA('Terrain') then
                Workspace.Terrain:Clear()
            end
        end
        function Teleport.FarmingHome()
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true
            Player.Character.HumanoidRootPart.CFrame = Workspace.FarmingHomeLocation.CFrame * CFrame.new(rng:NextInteger(1, 40), 10, rng:NextInteger(1, 40))
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            Teleport.DeleteWater()
        end
        function Teleport.MainMap()
            local isAlreadyOnMainMap = Workspace:FindFirstChild('Interiors'):FindFirstChild('center_map_plot', true)

            if isAlreadyOnMainMap then
                return
            end

            CollisionsClient.set_collidable(false)

            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            SetLocationFunc('MainMap', 'Neighborhood/MainDoor', {})
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            Player.Character.PrimaryPart.CFrame = Workspace:WaitForChild('StaticMap'):WaitForChild('Campsite'):WaitForChild('CampsiteOrigin').CFrame + Vector3.new(math.random(1, 5), 10, math.random(1, 5))
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            Teleport.DeleteWater()
            task.wait(2)
        end
        function Teleport.Nursery()
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            SetLocationFunc('Nursery', 'MainDoor', {})
            task.wait(1)
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            Player.Character.PrimaryPart.CFrame = Workspace.Interiors.Nursery:WaitForChild('GumballMachine'):WaitForChild('Root').CFrame + Vector3.new(
-8, 10, 0)
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end
        function Teleport.CampSite()
            Teleport.DeleteWater()
            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('MainMap', Player, ClientData.get_data()[Player.Name].LiveOpsMapType)
            task.wait(1)

            Player.Character.PrimaryPart.CFrame = Workspace.CampingLocation.CFrame + Vector3.new(rng:NextInteger(1, 30), 5, rng:NextInteger(1, 30))

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end
        function Teleport.BeachParty()
            Teleport.DeleteWater()
            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('MainMap', Player, ClientData.get_data()[Player.Name].LiveOpsMapType)
            task.wait(1)

            Player.Character.PrimaryPart.CFrame = Workspace.BeachPartyLocation.CFrame + Vector3.new(math.random(1, 30), 5, math.random(1, 30))

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end
        function Teleport.PlayGround(vec)
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            SetLocationFunc('MainMap', 'Neighborhood/MainDoor', {})
            task.wait(1)
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            Player.Character.PrimaryPart.CFrame = Workspace:WaitForChild('StaticMap'):WaitForChild('Park'):WaitForChild('Roundabout').PrimaryPart.CFrame + vec
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            Teleport.DeleteWater()
        end
        function Teleport.DownloadMainMap()
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            SetLocationFunc('MainMap', 'Neighborhood/MainDoor', {})
            task.wait(1)
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            Player.Character.PrimaryPart.CFrame = Workspace:WaitForChild('StaticMap'):WaitForChild('Park'):WaitForChild('Roundabout').PrimaryPart.CFrame + Vector3.new(20, 10, math.random(15, 30))
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            Teleport.DeleteWater()
        end
        function Teleport.SkyCastle()
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            local isAlreadyOnSkyCastle = Workspace:WaitForChild('Interiors'):FindFirstChild('SkyCastle')

            if not isAlreadyOnSkyCastle then
                SetLocationFunc('SkyCastle', 'MainDoor', {})
            end

            task.wait(1)
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            local skyCastle = Workspace.Interiors:FindFirstChild('SkyCastle')

            if not skyCastle then
                return
            end

            skyCastle:WaitForChild('Potions')
            skyCastle.Potions:WaitForChild('GrowPotion')
            skyCastle.Potions.GrowPotion:WaitForChild('Part')

            Player.Character.PrimaryPart.CFrame = skyCastle.Potions.GrowPotion.Part.CFrame + Vector3.new(math.random(1, 5), 10, math.random(
-5, -1))
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end
        function Teleport.Neighborhood()
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = true

            SetLocationFunc('Neighborhood', 'MainDoor', {})
            task.wait(1)
            Workspace.Interiors:WaitForChild(tostring(Workspace.Interiors:FindFirstChildWhichIsA('Model')))

            if not Workspace.Interiors:FindFirstChild('Neighborhood!Fall') then
                return
            end

            Workspace.Interiors['Neighborhood!Fall']:WaitForChild('InteriorOrigin')

            Player.Character.PrimaryPart.CFrame = Workspace.Interiors['Neighborhood!Fall'].InteriorOrigin.CFrame + Vector3.new(0, 
-10, 0)
            Player.Character:WaitForChild('HumanoidRootPart').Anchored = false

            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end

        return Teleport
    end
    function __DARKLUA_BUNDLE_MODULES.d()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Workspace = game:GetService('Workspace')
        local Players = game:GetService('Players')
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local GetInventory = __DARKLUA_BUNDLE_MODULES.load('b')
        local Teleport = __DARKLUA_BUNDLE_MODULES.load('c')
        local localPlayer = Players.LocalPlayer
        local doctorId = nil
        local Ailments = {}

        local function FoodAilments(FoodPassOn)
            local hasFood = false

            for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
                if v.id == FoodPassOn then
                    hasFood = true

                    ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v.unique, {})
                    task.wait(1)

                    if not ClientData.get('pet_char_wrappers')[1] then
                        print('\u{26a0}\u{fe0f} Trying to feed pet but no pet equipped \u{26a0}\u{fe0f}')

                        return
                    end

                    local args = {
                        [1] = '__Enum_PetObjectCreatorType_2',
                        [2] = {
                            ['pet_unique'] = ClientData.get('pet_char_wrappers')[1].pet_unique,
                            ['unique_id'] = v.unique,
                        },
                    }

                    ReplicatedStorage.API['PetObjectAPI/CreatePetObject']:InvokeServer(unpack(args))

                    return
                end
            end

            if not hasFood then
                ReplicatedStorage.API['ShopAPI/BuyItem']:InvokeServer('food', FoodPassOn, {})
                task.wait(1)
                FoodAilments(FoodPassOn)
            end
        end
        local function useToolOnBaby(uniqueId)
            ReplicatedStorage.API['ToolAPI/ServerUseTool']:FireServer(uniqueId, 'END')
        end
        local function PianoAilment(pianoId, petCharOrPlayerChar)
            local args = {
                localPlayer,
                pianoId,
                'Seat1',
                {
                    ['cframe'] = localPlayer.Character.HumanoidRootPart.CFrame,
                },
                petCharOrPlayerChar,
            }

            task.spawn(function()
                ReplicatedStorage.API:FindFirstChild('HousingAPI/ActivateFurniture'):InvokeServer(unpack(args))
            end)
        end
        local function furnitureAilments(nameId, petCharOrPlayerChar)
            task.spawn(function()
                ReplicatedStorage.API['HousingAPI/ActivateFurniture']:InvokeServer(localPlayer, nameId, 'UseBlock', {
                    ['cframe'] = localPlayer.Character.HumanoidRootPart.CFrame,
                }, petCharOrPlayerChar)
            end)
        end
        local function isDoctorLoaded()
            local stuckCount = 0
            local isStuck = false
            local doctor = Workspace.HouseInteriors.furniture:FindFirstChild('Doctor', true)

            if not doctor then
                repeat
                    task.wait(1)

                    doctor = Workspace.HouseInteriors.furniture:FindFirstChild('Doctor', true)

                    stuckCount += 1

                    isStuck = if stuckCount > 30 then true else false
                until doctor or isStuck
            end
            if isStuck then
                return false
            end

            return true
        end
        local function getDoctorId()
            if doctorId then
                print(`Doctor Id: {doctorId}`)

                return
            end

            local stuckCount = 0
            local isStuck = false

            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('Hospital')
            task.wait(1)

            local doctor = Workspace.HouseInteriors.furniture:FindFirstChild('Doctor', true)

            if not doctor then
                repeat
                    task.wait(1)

                    doctor = Workspace.HouseInteriors.furniture:FindFirstChild('Doctor', true)

                    stuckCount += 1

                    isStuck = if stuckCount > 30 then true else false
                until doctor or isStuck
            end
            if isStuck then
                return
            end
            if doctor then
                doctorId = doctor:GetAttribute('furniture_unique')
            end
        end
        local function useStroller()
            local args = {
                [1] = ClientData.get('pet_char_wrappers')[1].char,
                [2] = localPlayer.Character.StrollerTool.ModelHandle.TouchToSits.TouchToSit,
            }

            ReplicatedStorage.API:FindFirstChild('AdoptAPI/UseStroller'):InvokeServer(unpack(args))
        end
        local function babyJump()
            if localPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                return
            end

            localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        local function getUpFromSitting()
            ReplicatedStorage.API['AdoptAPI/BabyJump']:FireServer(localPlayer.Character)
            task.wait(0.1)
        end
        local function reEquipPet()
            local hasPetChar = false
            local EquipTimeout = 0

            ReplicatedStorage.API['ToolAPI/Unequip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})
            task.wait(1)
            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})

            repeat
                task.wait(1)

                hasPetChar = if ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char']then true else false

                EquipTimeout += 1
            until hasPetChar or EquipTimeout >= 10

            if EquipTimeout >= 10 then
                reEquipPet()
            end
        end
        local function babyGetFoodAndEat(FoodPassOn)
            local hasFood = false

            for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
                if v.id == FoodPassOn then
                    hasFood = true

                    ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v.unique, {})
                    task.wait(1)
                    useToolOnBaby(v.unique)

                    return
                end
            end

            if not hasFood then
                ReplicatedStorage.API['ShopAPI/BuyItem']:InvokeServer('food', FoodPassOn, {})
                task.wait(1)
                babyGetFoodAndEat(FoodPassOn)
            end
        end
        local function pickMysteryTask(mysteryId, petUnique)
            local ailmentsList = {}

            for i, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique][mysteryId]['components']['mystery']['components']do
                table.insert(ailmentsList, i)
            end

            for i = 1, 3 do
                for _, ailment in ailmentsList do
                    ReplicatedStorage.API['AilmentsAPI/ChooseMysteryAilment']:FireServer(mysteryId, i, ailment)
                    task.wait(3)

                    if not ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique][mysteryId] then
                        return
                    end
                end
            end
        end
        local function waitForTaskToFinish(ailment, petUnique)
            local count = 0

            repeat
                task.wait(5)

                local taskActive = if ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique] and ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique][ailment]then true else false

                count += 5
            until not taskActive or count >= 60

            if count >= 60 then
            end
        end
        local function waitForJumpingToFinish(ailment, petUnique)
            local stuckCount = tick()
            local isStuck = false

            repeat
                babyJump()
                task.wait(0.2)

                local taskActive = if ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique] and ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique][ailment]then true else false

                task.wait(0.1)

                isStuck = if(tick() - stuckCount) >= 120 then true else false
            until not taskActive or isStuck
        end
        local function babyWaitForTaskToFinish(ailment)
            local count = 0

            repeat
                task.wait(5)

                local taskActive = if ClientData.get_data()[localPlayer.Name].ailments_manager.baby_ailments and ClientData.get_data()[localPlayer.Name].ailments_manager.baby_ailments[ailment]then true else false

                count += 5
            until not taskActive or count >= 60
        end

        function Ailments:HungryAilment()
            FoodAilments('icecream')
        end
        function Ailments:ThirstyAilment()
            FoodAilments('water')
        end
        function Ailments:SickAilment()
            if doctorId then
                ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('Hospital')

                if not isDoctorLoaded() then
                    print(`\u{1fa79}\u{26a0}\u{fe0f} Doctor didnt load \u{1fa79}\u{26a0}\u{fe0f}`)

                    return
                end

                local args = {
                    [1] = doctorId,
                    [2] = 'UseBlock',
                    [3] = 'Yes',
                    [4] = game:GetService('Players').LocalPlayer.Character,
                }

                ReplicatedStorage.API:FindFirstChild('HousingAPI/ActivateInteriorFurniture'):InvokeServer(unpack(args))
            else
                getDoctorId()
            end
        end
        function Ailments:SalonAilment(ailment, petUnique)
            reEquipPet()
            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('Salon')
            waitForTaskToFinish(ailment, petUnique)
        end
        function Ailments:PizzaPartyAilment(ailment, petUnique)
            reEquipPet()
            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('PizzaShop')
            waitForTaskToFinish(ailment, petUnique)
        end
        function Ailments:SchoolAilment(ailment, petUnique)
            reEquipPet()
            ReplicatedStorage.API['LocationAPI/SetLocation']:FireServer('School')
            waitForTaskToFinish(ailment, petUnique)
        end
        function Ailments:BoredAilment(pianoId, petUnique)
            reEquipPet()

            if pianoId then
                if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                    return
                end

                PianoAilment(pianoId, ClientData.get('pet_char_wrappers')[1]['char'])
            else
                Teleport.PlayGround(Vector3.new(20, 10, math.random(15, 30)))
            end

            waitForTaskToFinish('bored', petUnique)
        end
        function Ailments:SleepyAilment(bedId, petUnique)
            reEquipPet()

            if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                return
            end

            furnitureAilments(bedId, ClientData.get('pet_char_wrappers')[1]['char'])
            waitForTaskToFinish('sleepy', petUnique)
        end
        function Ailments:DirtyAilment(showerId, petUnique)
            reEquipPet()

            if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                return
            end

            furnitureAilments(showerId, ClientData.get('pet_char_wrappers')[1]['char'])
            waitForTaskToFinish('dirty', petUnique)
        end
        function Ailments:ToiletAilment(litterBoxId, petUnique)
            reEquipPet()

            if litterBoxId then
                if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                    return
                end

                furnitureAilments(litterBoxId, ClientData.get('pet_char_wrappers')[1]['char'])
            else
                Teleport.DownloadMainMap()
                task.wait(5)

                localPlayer.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.furniture:FindFirstChild('AilmentsRefresh2024FireHydrant', true).PrimaryPart.CFrame + Vector3.new(5, 5, 5)

                task.wait(2)
                reEquipPet()
            end

            waitForTaskToFinish('toilet', petUnique)
        end
        function Ailments:BeachPartyAilment(petUnique)
            ReplicatedStorage.API['ToolAPI/Unequip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})
            Teleport.BeachParty()
            task.wait(2)
            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})
            waitForTaskToFinish('beach_party', petUnique)
        end
        function Ailments:CampingAilment(petUnique)
            ReplicatedStorage.API['ToolAPI/Unequip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})
            Teleport.CampSite()
            task.wait(2)
            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(ClientData.get_data()[localPlayer.Name].last_equipped_pets[1], {})
            waitForTaskToFinish('camping', petUnique)
        end
        function Ailments:WalkAilment(petUnique)
            reEquipPet()

            if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                return
            end

            ReplicatedStorage.API['AdoptAPI/HoldBaby']:FireServer(ClientData.get('pet_char_wrappers')[1]['char'])
            waitForJumpingToFinish('walk', petUnique)

            if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                return
            end

            ReplicatedStorage.API:FindFirstChild('AdoptAPI/EjectBaby'):FireServer(ClientData.get('pet_char_wrappers')[1]['char'])
        end
        function Ailments:RideAilment(strollerId, petUnique)
            reEquipPet()
            ReplicatedStorage.API:FindFirstChild('ToolAPI/Equip'):InvokeServer(strollerId, {})
            task.wait(1)
            useStroller()
            waitForJumpingToFinish('ride', petUnique)

            if not ClientData.get('pet_char_wrappers')[1] and ClientData.get('pet_char_wrappers')[1]['char'] then
                return
            end

            ReplicatedStorage.API:FindFirstChild('AdoptAPI/EjectBaby'):FireServer(ClientData.get('pet_char_wrappers')[1]['char'])
        end
        function Ailments:PlayAilment(ailment, petUnique)
            reEquipPet()

            local toyId = GetInventory:GetUniqueId('toys', 'raw_bone')

            if not toyId then
                ReplicatedStorage.API:FindFirstChild('ShopAPI/BuyItem'):InvokeServer('toys', 'raw_bone', {})
                task.wait(3)

                toyId = GetInventory:GetUniqueId('toys', 'raw_bone')

                if not toyId then
                    print(`\u{26a0}\u{fe0f} Doesn't have raw bone so exiting \u{26a0}\u{fe0f}`)

                    return
                end
            end

            local args = {
                [1] = '__Enum_PetObjectCreatorType_1',
                [2] = {
                    ['reaction_name'] = 'ThrowToyReaction',
                    ['unique_id'] = toyId,
                },
            }
            local count = 0

            repeat
                ReplicatedStorage.API:FindFirstChild('PetObjectAPI/CreatePetObject'):InvokeServer(unpack(args))
                task.wait(10)

                local taskActive = if ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique] and ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique][ailment]then true else false

                count += 1
            until not taskActive or count >= 6

            if count >= 6 then
                reEquipPet()

                return
            end
        end
        function Ailments:MysteryAilment(mysteryId, petUnique)
            pickMysteryTask(mysteryId, petUnique)
        end
        function Ailments:BabyHungryAilment()
            local stuckCount = 0

            repeat
                babyGetFoodAndEat('icecream')

                stuckCount += 1

                task.wait(1)
            until not ClientData.get_data()[localPlayer.Name].ailments_manager.baby_ailments['hungry'] or stuckCount >= 30
        end
        function Ailments:BabyThirstyAilment()
            local stuckCount = 0

            repeat
                babyGetFoodAndEat('lemonade')

                stuckCount += 1

                task.wait(1)
            until not ClientData.get_data()[localPlayer.Name].ailments_manager.baby_ailments['thirsty'] or stuckCount >= 30
        end
        function Ailments:BabyBoredAilment(pianoId)
            getUpFromSitting()

            if pianoId then
                PianoAilment(pianoId, localPlayer.Character)
            else
                Teleport.PlayGround(Vector3.new(20, 10, math.random(15, 30)))
            end

            babyWaitForTaskToFinish('bored')
            getUpFromSitting()
        end
        function Ailments:BabySleepyAilment(bedId)
            getUpFromSitting()
            furnitureAilments(bedId, localPlayer.Character)
            babyWaitForTaskToFinish('sleepy')
            getUpFromSitting()
        end
        function Ailments:BabyDirtyAilment(showerId)
            getUpFromSitting()
            furnitureAilments(showerId, localPlayer.Character)
            babyWaitForTaskToFinish('dirty')
            getUpFromSitting()
        end

        return Ailments
    end
    function __DARKLUA_BUNDLE_MODULES.e()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Players = game:GetService('Players')
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local localPlayer = Players.LocalPlayer
        local StatsGuis2 = {}

        StatsGuis2.__index = StatsGuis2

        local function formatTime(currentTime)
            local hours = math.floor(currentTime / 3600)
            local minutes = math.floor((currentTime % 3600) / 60)
            local seconds = currentTime % 60

            if hours > 10 then
                game:Shutdown()
            end

            return string.format('%02d:%02d:%02d', hours, minutes, seconds)
        end
        local function formatNumber(num)
            if num >= 1e6 then
                return string.format('%.2fM', num / 1e6)
            elseif num >= 1e3 then
                return string.format('%.1fK', num / 1e3)
            else
                return tostring(num)
            end
        end
        local function bucksAmount()
            return ClientData.get_data()[localPlayer.Name].money or 0
        end
        local function gingerbreadAmount()
            return ClientData.get_data()[localPlayer.Name].gingerbread_2024 or 0
        end
        local function foodItemCount(nameId)
            local count = 0

            for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
                if v.id == nameId then
                    count += 1
                end
            end

            return count
        end

        function StatsGuis2.new(name)
            local self = setmetatable({}, StatsGuis2)

            self.label = Instance.new('TextLabel')
            self.UICorner = Instance.new('UICorner')
            self.label.Name = name
            self.label.BackgroundColor3 = Color3.fromRGB(250, 129, 47)
            self.label.BackgroundTransparency = 0.25
            self.label.BorderColor3 = Color3.fromRGB(0, 0, 0)
            self.label.BorderSizePixel = 0
            self.label.Size = UDim2.new(0.330000013, 0, 0.486617982, 0)
            self.label.Font = Enum.Font.FredokaOne
            self.label.RichText = false
            self.label.Text = 'label'
            self.label.TextColor3 = Color3.fromRGB(255, 255, 255)
            self.label.TextScaled = true
            self.label.TextSize = 14
            self.label.TextStrokeTransparency = 0
            self.label.TextWrapped = true
            self.label.Parent = Players.LocalPlayer.PlayerGui.StatsGui.MainFrame.MiddleFrame
            self.UICorner.CornerRadius = UDim.new(0, 16)
            self.UICorner.Parent = self.label

            return self
        end
        function StatsGuis2.Setup()
            local StatsGui = Instance.new('ScreenGui')
            local MainFrame = Instance.new('Frame')
            local TimeLabel = Instance.new('TextLabel')
            local UICorner = Instance.new('UICorner')
            local MiddleFrame = Instance.new('Frame')
            local UIGridLayout = Instance.new('UIGridLayout')
            local TextButton = Instance.new('TextButton')

            StatsGui.Name = 'StatsGui'
            StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            StatsGui.Parent = Players.LocalPlayer:WaitForChild('PlayerGui')
            MainFrame.Name = 'MainFrame'
            MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MainFrame.BackgroundTransparency = 1
            MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            MainFrame.BorderSizePixel = 0
            MainFrame.Position = UDim2.new(0.276041657, 0, 0.0577475652, 0)
            MainFrame.Size = UDim2.new(0.674468458, 0, 0.795313776, 0)
            MainFrame.Parent = StatsGui
            TimeLabel.Name = 'TimeLabel'
            TimeLabel.BackgroundColor3 = Color3.fromRGB(250, 129, 47)
            TimeLabel.BackgroundTransparency = 0.25
            TimeLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TimeLabel.BorderSizePixel = 0
            TimeLabel.Size = UDim2.new(1, 0, 0.200000018, 0)
            TimeLabel.Font = Enum.Font.FredokaOne
            TimeLabel.RichText = false
            TimeLabel.Text = '\u{23f1}\u{fe0f} time'
            TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TimeLabel.TextScaled = true
            TimeLabel.TextSize = 14
            TimeLabel.TextStrokeTransparency = 0
            TimeLabel.TextWrapped = true
            TimeLabel.Parent = MainFrame
            UICorner.CornerRadius = UDim.new(0, 16)
            UICorner.Parent = TimeLabel
            MiddleFrame.Name = 'MiddleFrame'
            MiddleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MiddleFrame.BackgroundTransparency = 1
            MiddleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            MiddleFrame.BorderSizePixel = 0
            MiddleFrame.Position = UDim2.new(0, 0, 0.219711155, 0)
            MiddleFrame.Size = UDim2.new(0.999243617, 0, 0.55549103, 0)
            MiddleFrame.Parent = MainFrame
            UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIGridLayout.CellPadding = UDim2.new(0.00999999978, 0, 0.00999999978, 0)
            UIGridLayout.CellSize = UDim2.new(0.242, 0, 0.5, 0)
            UIGridLayout.FillDirectionMaxCells = 0
            UIGridLayout.Parent = MiddleFrame
            TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
            TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.BackgroundTransparency = 1
            TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            TextButton.BorderSizePixel = 0
            TextButton.Position = UDim2.new(0.33, 0, 0.018, 0)
            TextButton.Size = UDim2.new(0.1, 0, 0.1, 0)
            TextButton.Font = Enum.Font.FredokaOne
            TextButton.Text = '\u{1f648}'
            TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextButton.TextScaled = true
            TextButton.TextSize = 14
            TextButton.TextWrapped = true
            TextButton.TextXAlignment = Enum.TextXAlignment.Left
            TextButton.Parent = StatsGui

            local TIME_SAVED = nil

            TimeLabel.MouseEnter:Connect(function()
                TIME_SAVED = TimeLabel.Text
                TimeLabel.Text = `\u{1f916} {localPlayer.Name}`
            end)
            TimeLabel.MouseLeave:Connect(function()
                TimeLabel.Text = TIME_SAVED
            end)

            local isVisible = true

            TextButton.Activated:Connect(function()
                isVisible = not isVisible
                MainFrame.Visible = isVisible
            end)
        end
        function StatsGuis2:UpdateTextFor(labelName, amount)
            if labelName == 'TimeLabel' then
                local currentTime = DateTime.now().UnixTimestamp
                local timeElapsed = currentTime - amount

                Players.LocalPlayer.PlayerGui.StatsGui.MainFrame.TimeLabel.Text = `\u{23f1}\u{fe0f} {formatTime(timeElapsed)}`
            elseif labelName == 'TempPotions' then
                self.label.Text = `\u{1f9ea} {formatNumber(amount)}`
            elseif labelName == 'TempTinyPotions' then
                self.label.Text = `\u{2697}\u{fe0f} {formatNumber(amount)}`
            elseif labelName == 'TempBucks' then
                self.label.Text = `\u{1f4b0} {formatNumber(amount)}`
            elseif labelName == 'TempGingerbreads' then
                self.label.Text = `\u{1f36a} {formatNumber(amount)}`
            elseif labelName == 'TotalPotions' then
                local formatted = formatNumber(foodItemCount('pet_age_potion'))

                self.label.Text = `\u{1f9ea} {formatted}`
            elseif labelName == 'TotalTinyPotions' then
                local formatted = formatNumber(foodItemCount('tiny_pet_age_potion'))

                self.label.Text = `\u{2697}\u{fe0f} {formatted}`
            elseif labelName == 'TotalBucks' then
                local formatted = formatNumber(bucksAmount())

                self.label.Text = `\u{1f4b0} {formatted}`
            elseif labelName == 'TotalGingerbreads' then
                local formatted = formatNumber(gingerbreadAmount())

                self.label.Text = `\u{1f36a} {formatted}`
            elseif labelName == 'TotalWinterBaits' then
                local formatted = formatNumber(foodItemCount('winter_2024_winter_deer_bait'))

                self.label.Text = `\u{2744}\u{fe0f} {formatted}`
            end
        end

        return StatsGuis2
    end
    function __DARKLUA_BUNDLE_MODULES.f()
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Workspace = game:GetService('Workspace')
        local localPlayer = game:GetService('Players').LocalPlayer
        local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
        local Christmas2024 = {}
        local gingerbeadIds = {
            ['Winter2024Shop'] = {
                '{0f2ada20-90cd-44b4-932d-68815f8f7b65}',
                '{f88ddb65-d569-42ff-afb8-5b11b0e799d9}',
                '{3c91f411-3ccd-4e66-a565-5a17c453f628}',
                '{8032d531-f7da-47e1-bac5-59349becee8c}',
                '{4f351ee6-eb60-4a35-b25a-14c7c9aaa897}',
                '{84ff7975-dea6-42e6-ace8-adda29a12206}',
                '{71f01b8c-9ef9-44e9-ac55-26d8cdbaf409}',
                '{2497f3e9-e6c8-447a-bce3-42f0b0ba08ac}',
                '{848f5737-038c-46f1-bf44-d169384a905f}',
                '{f27432d9-4337-4179-a132-ade6ee5eae8a}',
                '{3bcbc022-0414-4e70-a18a-20fdb849f699}',
                '{fd4f7786-ba8d-4951-80e0-7bebb9b8937c}',
                '{5d148c2c-7767-4f4f-9cb3-875953695021}',
                '{fa97c9f8-adda-488f-b10f-374590f5500d}',
                '{0cc116a7-8cb4-4baa-ba21-e9c7a3107f1b}',
                '{b2526631-e0e4-419e-9f72-1cb554a071bd}',
                '{1a9611f2-d868-4473-8255-2cc42846e961}',
                '{dd3957b4-dc18-4bd0-8fcd-32c208bb6419}',
                '{47202484-5e98-40ab-ad22-2de071895667}',
                '{b35535e9-feec-48ea-9296-a4077835f8b7}',
                '{1358288e-cc02-428a-937b-d2241fcae709}',
                '{361460b4-6309-43e1-81dc-d3772ff6f5b4}',
                '{0b06408f-84d3-4420-b5b7-ecbd9dce3600}',
                '{81a5d5dc-4f69-4bae-bf19-5cd29e0f0d5b}',
                '{466c42d8-6c81-4c5d-945c-febea46cc71e}',
                '{fa78cbd6-e690-4adc-9305-b7ddc90c27f2}',
                '{c469bdc6-d2a0-4926-b8a4-8f6334e7252f}',
                '{82da849f-0ce2-4690-8f8c-b8353b6ef1c5}',
                '{21a06a15-47e9-49e6-872e-5d09b34074df}',
                '{5cbca7c9-02ab-4cf7-812b-da773f4451bc}',
                '{0aaf71f0-7573-43a3-ae5b-f2e97f445347}',
                '{158c6156-4811-4be5-b9a4-b7b768ea973a}',
                '{43d9c602-9b1d-4013-9e78-36b12843c0c9}',
                '{acdcf0fd-c411-4932-bbda-bda88630f45f}',
                '{76f34a6f-185a-4ab2-8775-ae7dcdc84576}',
                '{ff592ec8-6c7f-4afc-94ce-a3e25b078927}',
                '{d2f2e3bc-5e46-4e8c-9ac6-ce750e88f40c}',
                '{4576b5f7-377b-471f-9c5a-f5d4338c6c70}',
                '{29c1cd09-4531-4fd4-95d5-e00c82909b5f}',
                '{5ca5e508-c9ed-45cd-b935-9e7154ecf9fe}',
                '{b4361bb2-2d2f-4458-9dc7-271542edbd0a}',
                '{c1678b43-f01d-4b8a-b44f-07c566a509f0}',
                '{4390612f-f8c2-420a-b45d-c8a5319455d8}',
                '{23005b2a-613d-4c54-8457-c7f468dcbac6}',
                '{85d067e0-3c07-4587-b427-e66b4d11fc80}',
                '{a948993e-2367-4b69-9be5-af5c0b5c320a}',
                '{e88cb67b-24ae-49d3-ac52-b44c6d84d1aa}',
            },
            ['MainMap!Snow'] = {
                '{29580925-384D-4CF6-810A-5B2FBEBE14EF}',
                '{AFFECD3D-9FCD-4822-BDF8-1B7F589620DD}',
                '{2BEB302F-EB22-4403-B2E7-F4239A306A9C}',
                '{53C81678-DDD1-410F-9476-0A1AFD17B22D}',
                '{96EB009D-84A2-464B-925E-41E269B5D7E4}',
                '{C61B5F35-B5E6-4DDE-B9CA-8C5CDE82D3F5}',
                '{FE0C85D8-2E11-46BA-BE97-9EC67E96ABB8}',
                '{487EE748-30B2-40A5-AEAC-2724E29C6C6D}',
                '{54E9E593-8C0E-4120-9637-83B0BA891573}',
                '{28F6FD49-55C2-4E45-88F3-E62344AEE010}',
                '{677BBA18-0BDA-4A19-92F9-8C8DF6A11E30}',
                '{4B0E202F-743E-46C3-A538-CAAABE3D6A76}',
                '{1CA3C55C-E6FF-4632-B023-4AFABBD3175F}',
                '{A6482191-3E6B-45E0-B1F6-5BE8600C0D46}',
                '{B097C8D5-6034-42F2-ABE1-4CEFE35E76FB}',
                '{8743B7A9-257B-48DF-8DB0-0F4FD057A4B0}',
                '{FD974ABC-023F-4238-BB26-EA963179D61F}',
                '{1479F2D4-D712-4B53-8B24-546270239BE7}',
                '{E8749084-B9C2-4C1C-8DCA-8DD601B57E99}',
                '{600EB06A-F13D-411D-BEB3-E04E93ED4276}',
                '{FD6318F0-8A5F-41CF-9B91-64EBBBCB3E98}',
                '{437F2FA1-230F-498F-9276-DE0EF87C3AE1}',
                '{D1B20364-78F5-4CCC-A510-E40A8D625D16}',
                '{F72AED52-624E-43BA-AF8E-7C3C311B93D7}',
                '{0836BB00-2107-49A6-8544-72FC3EECC742}',
                '{2883E3B9-AEB4-4577-A1E6-D75BD7D00042}',
                '{8B70133A-0EDA-439B-B41D-26B9EE5B824D}',
                '{5FD5BDBD-5847-4EFD-9DF1-0AB7B94A3548}',
                '{3DE5F28B-8893-4BD0-B742-6096E9DDEDB6}',
                '{B6510D79-459E-40A7-88A1-06EECF7DFEDD}',
                '{850FA732-1759-41FD-8D11-A966F663DC54}',
                '{A76214EC-C75E-4E91-B515-32CF008CA73F}',
                '{11496169-8138-4EB2-9883-9F0453297D84}',
                '{D356DB30-2CDC-48D8-AB28-F9E1C4C8E82D}',
                '{51E924AC-12DF-46F8-A77C-C2756C38AD3B}',
                '{A33B95DC-4636-4FB9-81E1-098C819359A8}',
                '{0DBD86AB-EDAD-4C5F-B64A-E879935418FD}',
                '{69372C32-4F4E-4786-B973-36405115DC84}',
                '{C4194D7B-54B5-4B35-B262-1B700143DB56}',
                '{1F5105D1-7F27-4C3F-88F8-DAB5AC6F80A7}',
                '{E774C005-3B66-4736-8E35-421710DB25FB}',
                '{058EE9BE-D9A9-4660-9729-60E2FF891783}',
                '{71CB1A2A-6433-496F-A75D-79B57EA2020D}',
                '{45912694-2CF8-4B46-9222-B4E052EC74FC}',
                '{A6C07949-FE1D-4C8A-9234-782981398813}',
                '{CC47FF49-48FD-444E-8F70-BFB36EB4E1DE}',
                '{6C05E92C-38EB-4033-B610-4503E5262FDF}',
                '{7A2585D3-0477-40CD-B6FF-BD781A3B5777}',
                '{248879AA-6B47-4BCF-AFC0-161C2EBFF6AD}',
                '{537FCB8D-0868-463D-B2A1-A85E3F9507A3}',
                '{8897445D-6138-4BD6-8DA1-1F02ECFE5898}',
                '{4112DDAB-4A73-4C16-A75C-DD260D6D0155}',
                '{65EF0557-0D8E-4B74-AFD8-FC5DB243EDB8}',
                '{39592C2B-0CC3-4BDD-9E64-00846F06C629}',
                '{14F3C7DB-D67E-4288-9D94-AB33653FD928}',
                '{DD193776-16EC-4550-B696-19E19CE313D4}',
                '{4FE802B6-9D8D-4CAA-B07A-775154792D1A}',
                '{87A78497-E137-47E5-AE8A-5E4C0F30D90A}',
                '{40D33237-E99B-4BA3-A0BE-7AEE3AD7B607}',
                '{08D592C6-8F94-435E-98CD-D038E23CF236}',
                '{F0B27251-FFE7-4A70-9077-80D73E10BD1E}',
                '{439925AF-0A96-40F3-8707-D5A65AA605AF}',
                '{381C38F4-4B07-4F2E-A12E-AF6328F96A54}',
                '{25DA2E1D-7191-4B7F-AB26-5EFECB267307}',
                '{154F7871-BCA0-4691-9210-AD6D76103119}',
                '{808A9B20-FA50-412A-9A5D-D728B1D355A9}',
                '{AE2F9B5B-589F-4A12-B4A5-0912FFE8C463}',
                '{04A431CF-78AD-4200-9B3E-8DA02A6DA347}',
                '{F0F44CAC-FF90-4B94-A996-5094CECF1531}',
                '{069AFA82-D910-45A2-AF24-7F33E0237182}',
                '{24236D55-6152-4783-B736-9CAA56F6F655}',
                '{33430CD2-A47B-4987-ACEA-5EA4ABF9AAE0}',
                '{FC8810F5-8C12-46AC-9260-12E9276199B2}',
                '{177D7587-F672-49D5-85D1-090AA2AAAB29}',
                '{1B7E9043-B129-4341-BDB9-FA83CE503F5C}',
                '{82B7AF91-D7FD-48D5-BEA1-A7048595647E}',
                '{1A218809-DBE4-4542-80B2-2B585D33CEC6}',
                '{449145AC-B3DC-4FDD-9C9F-5FFF5F2FA183}',
                '{4A3B540E-FC78-4095-AFDA-F560F263AD13}',
                '{8F6C3881-F732-42C9-936A-5852D3A194B4}',
                '{D5EBC9DB-8E7A-45AD-BF8F-F93703B61F20}',
                '{6F890B4D-2BB8-446F-A492-21C61EC7D36D}',
                '{9B4F9569-4463-47AB-B753-0DBF64B56883}',
                '{30189A3D-F6CE-4B86-A19C-C71E64541796}',
                '{4F764D10-CC2B-447E-9876-DC9259316804}',
                '{45E5C75E-DB43-4196-9B2A-6A3C044C6095}',
                '{AB788250-8C62-45AF-BE63-6493F5363116}',
                '{D194622B-F101-47D3-8974-7610FB3830AE}',
                '{3C929F9E-9C60-4844-B6A6-C5AB16B89030}',
                '{48BB1D7E-0B33-4171-A423-A911FE9A4972}',
                '{A5D4CB92-D091-41DF-A0F5-968778175398}',
                '{B0390D1A-AAFF-45F9-823E-9DBF1EE671DF}',
                '{5E5EAA7A-C7C4-4AB0-AB22-DBFD967098BF}',
                '{0217C4CB-EBE3-4EAD-BAA8-801D1DD0BD8F}',
                '{6DEDCEB2-62B4-4259-BDFF-A3FA56DF71A7}',
                '{93479D49-84B0-4410-B39D-D2553FFFFCF0}',
                '{CBE7FE13-7C12-4469-8F0E-B32E7B224B20}',
                '{505165ED-12ED-4FC3-8E0B-DE786471F388}',
                '{F8FAEF3D-A8EC-4FC6-B6DA-9900D9F01089}',
                '{27AE43F6-30C5-477C-BD53-2511CD23C5CA}',
                '{2EEF9B08-10D5-40A6-B563-94FF012868D9}',
                '{2FAC02AF-1E80-4890-BC34-C5D8F22F12F2}',
                '{51F28E59-3CEC-46F4-84C3-5D6FD3FBCCF1}',
                '{80612A9C-FDE0-4CEE-B5F8-8B7DE2E9DC39}',
                '{1E4A9A9E-F945-4A6A-A777-EA765AC9892D}',
                '{5C9A79E8-A97B-4DD9-8B8B-7DAD80B541E0}',
                '{316F5213-D48B-4F4B-8AFB-D18E44ACDDCB}',
                '{084B9A25-9B24-461B-8FEB-1A071D2800FB}',
                '{40475233-9A85-4BE4-B20F-4C7A2C04C67E}',
                '{832B63F3-FBA5-4380-99DB-78CFB9F87D6F}',
                '{E8AD7C9A-C60C-4DE2-A111-A3E8AD26B1D0}',
                '{8BEADFD7-FB96-4F3D-A2A3-32FC758A60CE}',
                '{137708F4-430A-4C0D-A63C-B75A59C5EB2E}',
                '{9989159C-CF88-4D53-A30D-037A337969D3}',
                '{DEB255CE-6405-43A3-81AD-DCAA8A0A707C}',
                '{81E888FB-BEF4-4F79-AE22-C5F438EF0E4E}',
                '{85A9AEA7-5427-4144-AFC1-12DCE9D5ECB7}',
                '{60E33537-47D5-4212-958D-307C17501331}',
                '{E58BFD84-62BE-4A62-A2C8-5D088FB0E6BF}',
                '{B484E83E-396E-4ACA-828E-0E1121708E88}',
                '{FCE711AB-1097-47DF-AFD5-E3D8BA0B4BA5}',
                '{20619AAB-74D9-4F8D-AB89-62DB4130C6A9}',
                '{94D2643C-32DC-4D5F-9350-BA5BD54BCA23}',
                '{F11CFC7D-3222-4856-AB81-532ADB118D34}',
                '{2FA1E614-9B22-495E-8543-A28A449662C0}',
                '{65E06DD8-CCCB-4DFC-ADED-EC29B7890D53}',
                '{21119F02-5EB6-4308-B15A-AE086F9605EC}',
                '{FB967ED2-445C-4B78-8576-5D99AB7AA4B9}',
                '{569DD3EB-30D5-4CDD-85B6-5AA6C886D51C}',
                '{63E116B6-1955-4B06-B28F-3113E0760583}',
                '{C8380520-D52C-46F1-A257-ADA9BC410E79}',
                '{0F4D8710-8B26-4D9C-92EC-FFAB5CFEDA15}',
                '{0447C188-1620-4CE4-897D-E34CDBE3F30D}',
                '{D0A52723-FF4A-40E5-A6B7-16FC57BF9B9E}',
                '{5926D161-4B98-4901-8A66-6178F21B616C}',
                '{ED15A0DF-DEA5-4EE5-91D4-568CF3D13D20}',
                '{9E8B22FE-410D-4005-8610-B5BEE9058A01}',
                '{6DAB765F-B559-4BB5-B70B-C868947D1C56}',
                '{50BC1E72-EE91-4332-B707-B24E1622A214}',
                '{CF994B67-FA40-453E-ADEA-859E4B2C48A3}',
                '{D07D63E3-184C-41E1-9664-4DD8E26237C6}',
                '{DD2C92B9-881C-4128-B11D-A92E8873472E}',
                '{93F23433-BA8C-49CF-B1A8-D8FDA736623A}',
                '{5A651C27-4680-40DB-968C-71B89B56F3D0}',
                '{301B6795-D383-41BC-AB6C-6A4C4CAA8EDF}',
                '{5F3EECB5-14F4-4481-BA0D-86EED34D4597}',
                '{B6709EA9-0B13-47F5-9022-524426FC2B20}',
                '{6147E9F3-8FDA-45AF-AF7B-96245CA32096}',
                '{57CF0C2B-CB8F-430A-AE09-6A271E46447D}',
                '{F72BD7C6-B22D-4E5C-AA9C-C0FE8F034E43}',
                '{081D2B7B-79A6-4330-93EC-C36DF19BBC93}',
                '{D85AC2E0-131F-4316-B8CF-0CD0BFAC639D}',
                '{374FCE6C-D73A-4E68-AA7F-8954D47A913E}',
                '{0FBAF510-CE97-44B5-B5EE-43B31B642530}',
                '{9A475EE6-2AA9-407F-96B8-AFD73C904E9C}',
                '{1F104AAC-B4CF-4B9E-8ACA-C72F3B7601D7}',
                '{82062F93-CB93-48AF-9DEB-AB5385F67173}',
                '{F6D9E4BE-9433-4563-A10A-9E3684407E20}',
                '{A2CBBB92-06FB-4CB3-A81F-6926203BD34E}',
                '{EB9C2171-5D89-43AB-BA09-2F6439BF805D}',
            },
        }

        local function createLobby()
            return ReplicatedStorage.API['MinigameAPI/LobbyCreate']:InvokeServer('frostclaws_revenge')
        end
        local function startLobby()
            ReplicatedStorage.API['MinigameAPI/LobbyStart']:FireServer()
        end
        local function getMinigameId()
            local gameId
            local model = Workspace.Interiors:FindFirstChildWhichIsA('Model')

            if not model then
                local count = 0

                repeat
                    task.wait(1)

                    count += 1

                    model = Workspace.Interiors:FindFirstChildWhichIsA('Model')
                until model or count > 120

                print(`model name: {model.Name}`)

                if count > 120 then
                    print('couldnt get model')

                    return nil
                end
            end
            if model then
                local count = 0

                repeat
                    if model.Name:match('FrostclawsRevengeInterior') then
                        gameId = model.Name:split('::')[2]
                    end

                    count += 1

                    task.wait(1)
                until gameId or count > 30
            end
            if not gameId then
                return nil
            end

            print(`game id: {gameId}`)

            return gameId
        end
        local function hitEnemy(name, gameId)
            local args = {
                [1] = 'frostclaws_revenge::' .. gameId,
                [2] = 'hit_enemies',
                [3] = {[1] = name},
                [4] = 'sword_slash',
            }

            ReplicatedStorage.API['MinigameAPI/MessageServer']:FireServer(unpack(args))
        end

        function Christmas2024.CreateAndStartLobby()
            if not createLobby() then
                createLobby()
            end

            local count = 0
            local name

            repeat
                startLobby()

                count += 1

                task.wait(2)

                local model = Workspace.Interiors:FindFirstChildWhichIsA('Model')

                if model then
                    name = model.Name:match('FrostclawsRevengeInterior')
                end
            until name == 'FrostclawsRevengeInterior' or count > 30

            if count > 30 then
                return false
            end

            print('STEP 1', name)

            return true
        end
        function Christmas2024.StartGame()
            local minigameId = getMinigameId()

            if not minigameId then
                return
            end

            print('STEP 2', minigameId)

            local isGameActive = true

            while isGameActive do
                if not Workspace.Minigames:FindFirstChild(`FrostclawsRevengeInterior::{minigameId}`) then
                    print(`\u{26a0}\u{fe0f} NO FrostclawsRevengeInterior Folder with id found \u{26a0}\u{fe0f}`)

                    return
                end

                for _, v in Workspace.Minigames[`FrostclawsRevengeInterior::{minigameId}`]:WaitForChild('FrostclawsRevengeEnemies'):GetChildren()do
                    hitEnemy(v.Name, minigameId)
                end

                local minigameStateFolder = Workspace.StaticMap:FindFirstChild(`frostclaws_revenge::{minigameId}_minigame_state`)

                if not minigameStateFolder then
                    print('game over or no folder')

                    break
                end

                isGameActive = minigameStateFolder:WaitForChild('is_game_active').Value

                task.wait()
            end

            local count = 0

            repeat
                count += 1

                task.wait(1)
            until not Workspace.Minigames:FindFirstChild(`FrostclawsRevengeInterior::{minigameId}`) or count > 60

            print(`STEP 3  Count: {count}`)
            task.wait()
        end
        function Christmas2024.getGingerbread()
            local gingerbreadCaptured = ClientData.get_data()[localPlayer.Name].winter_2024_ice_skating_manager.gingerbread_captured_set_by_interior

            for _, id in gingerbeadIds['Winter2024Shop']do
                if not gingerbreadCaptured['Winter2024Shop'] or not gingerbreadCaptured['Winter2024Shop'][id] then
                    ReplicatedStorage.API:FindFirstChild('WinterEventAPI/PickUpGingerbread'):InvokeServer('Winter2024Shop', id)
                    task.wait()
                end
            end
            for _, id in gingerbeadIds['MainMap!Snow']do
                if not gingerbreadCaptured['MainMap!Snow'] or not gingerbreadCaptured['MainMap!Snow'][id] then
                    ReplicatedStorage.API:FindFirstChild('WinterEventAPI/PickUpGingerbread'):InvokeServer('MainMap!Snow', id)
                    task.wait()
                end
            end

            ReplicatedStorage.API:FindFirstChild('WinterEventAPI/RedeemPendingGingerbread'):FireServer()
            print('Redeemed Gingerbread')
        end
        function Christmas2024:LeaveMinigame()
            local minigameId = getMinigameId()

            if not minigameId then
                return
            end

            print('Leaving frostclaw minigame')

            local args = {
                [1] = `frostclaws_revenge::{minigameId}`,
                [2] = false,
            }

            ReplicatedStorage.API['MinigameAPI/AttemptJoin']:FireServer(unpack(args))
        end
        function Christmas2024.init()
            localPlayer.PlayerGui.FrostclawsRevengeUpgradeApp.Background.Upgrades.ChildAdded:Connect(function(
                child
            )
                if child.Name ~= 'Upgrade1' then
                    return
                end

                child:WaitForChild('Icon')
                child.Icon:WaitForChild('Container')
                child.Icon.Container:WaitForChild('Button')

                local count = 0

                repeat
                    firesignal(child.Icon.Container.Button.Activated)

                    count += 1

                    task.wait(1)
                until not localPlayer.PlayerGui.FrostclawsRevengeUpgradeApp.Enabled or count > 15
            end)
        end

        return Christmas2024
    end
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end
if game.PlaceId ~= 920587237 then
    return
end

local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local UserGameSettings = UserSettings():GetService('UserGameSettings')
local VirtualUser = game:GetService('VirtualUser')
local CoreGui = game:GetService('CoreGui')
local StarterGui = game:GetService('StarterGui')

game:GetService('HttpService')

local localPlayer = Players.LocalPlayer

if not localPlayer:WaitForChild('PlayerGui', 300) then
    localPlayer:Kick('\u{1f6ab} Player took to long to load \u{1f6ab}')
end

localPlayer.PlayerGui:WaitForChild('NewsApp')

local PickColorConn
local RoleChooserDialogConnection
local RobuxProductDialogConnection1
local RobuxProductDialogConnection2
local banMessageConnection
local DailyClaimConnection
local counter = 0
local isTradingMule = false
local isInMiniGame = false
local isBuyingOrAging = false
local discordCooldown = false
local startTime
local startPotionAmount = 0
local startTinyPotionAmount = 0
local startGingerbreadAmount
local potionsGained = 0
local tinyPotionsGained = 0
local bucksGained = 0
local gingerbreadsGained = 0
local Bed
local Shower
local Piano
local NormalLure
local LitterBox
local strollerId
local baitId

getgenv().auto_accept_trade = false
getgenv().auto_trade_all_pets = false
getgenv().auto_trade_fullgrown_neon_and_mega = false
getgenv().auto_trade_custom = false
getgenv().auto_trade_semi_auto = false
getgenv().auto_trade_lowtier_pets = false
getgenv().auto_trade_rarity_pets = false
getgenv().auto_farm = false
getgenv().auto_make_neon = false
getgenv().auto_trade_Legendary = false
getgenv().auto_trade_custom_gifts = false
getgenv().auto_trade_all_neons = false
getgenv().auto_trade_eggs = false
getgenv().auto_trade_all_inventory = false
getgenv().feedAgeUpPotionToggle = false
getgenv().PetCurrentlyFarming = ''

local Egg2Buy = getgenv().SETTINGS.PET_TO_BUY
local TestGui = Instance.new('ScreenGui')
local DailyRewardTable = {
    [9] = 'reward_1',
    [30] = 'reward_2',
    [90] = 'reward_3',
    [140] = 'reward_4',
    [180] = 'reward_5',
    [210] = 'reward_6',
    [230] = 'reward_7',
    [280] = 'reward_8',
    [300] = 'reward_9',
    [320] = 'reward_10',
    [360] = 'reward_11',
    [400] = 'reward_12',
    [460] = 'reward_13',
    [500] = 'reward_14',
    [550] = 'reward_15',
    [600] = 'reward_16',
    [660] = 'reward_17',
}
local DailyRewardTable2 = {
    [9] = 'reward_1',
    [65] = 'reward_2',
    [120] = 'reward_3',
    [180] = 'reward_4',
    [225] = 'reward_5',
    [280] = 'reward_6',
    [340] = 'reward_7',
    [400] = 'reward_8',
    [450] = 'reward_9',
    [520] = 'reward_10',
    [600] = 'reward_11',
    [660] = 'reward_12',
}
local ClientData = require(ReplicatedStorage:WaitForChild('ClientModules'):WaitForChild('Core'):WaitForChild('ClientData'))
local RouterClient = require(ReplicatedStorage.ClientModules.Core:WaitForChild('RouterClient'):WaitForChild('RouterClient'))
local CollisionsClient = require(ReplicatedStorage.ClientModules.Game:WaitForChild('CollisionsClient'))
local Fusion = __DARKLUA_BUNDLE_MODULES.load('a')
local GetInventory = __DARKLUA_BUNDLE_MODULES.load('b')
local Teleport = __DARKLUA_BUNDLE_MODULES.load('c')
local Ailments = __DARKLUA_BUNDLE_MODULES.load('d')
local StatsGuis2 = __DARKLUA_BUNDLE_MODULES.load('e')
local Christmas2024 = __DARKLUA_BUNDLE_MODULES.load('f')

StatsGuis2.Setup()

local TempPotions = StatsGuis2.new('TempPotions')
local TempTinyPotions = StatsGuis2.new('TempTinyPotions')
local TempBucks = StatsGuis2.new('TempBucks')
local TempGingerbreads = StatsGuis2.new('TempGingerbreads')
local TotalPotions = StatsGuis2.new('TotalPotions')
local TotalTinyPotions = StatsGuis2.new('TotalTinyPotions')
local TotalBucks = StatsGuis2.new('TotalBucks')
local TotalGingerbreads = StatsGuis2.new('TotalGingerbreads')
local TotalWinterBaits = StatsGuis2.new('TotalWinterBaits')
local petsTable = GetInventory:TabId('pets')

if #petsTable == 0 then
    petsTable = {
        'Nothing',
    }
end

local giftsTable = GetInventory:TabId('gifts')

if #giftsTable == 0 then
    giftsTable = {
        'Nothing',
    }
end

local toysTable = GetInventory:TabId('toys')

if #toysTable == 0 then
    toysTable = {
        'Nothing',
    }
end

local foodTable = GetInventory:TabId('food')

if #foodTable == 0 then
    foodTable = {
        'Nothing',
    }
end

local function fireButton(button)
    print(`fire button: {button}`)

    local success, errorMessage = pcall(function()
        firesignal(button.MouseButton1Down)
        firesignal(button.MouseButton1Click)
        firesignal(button.MouseButton1Up)
    end)

    print(button, success, errorMessage)
end
local function findButton(text, dialogFramePassOn)
    task.wait()

    local dialogFrame = dialogFramePassOn or 'NormalDialog'

    for _, v in localPlayer.PlayerGui.DialogApp.Dialog[dialogFrame].Buttons:GetDescendants()do
        if v:IsA('TextLabel') then
            if v.Text == text then
                fireButton(v.Parent.Parent)

                break
            end
        end
    end
end
local function findFurniture()
    if Bed and Piano and LitterBox and NormalLure then
        return
    end

    print('getting furniture ids')

    for key, value in ClientData.get_data()[localPlayer.Name].house_interior.furniture do
        if value.id == 'basiccrib' then
            Bed = key
        elseif value.id == 'stylishshower' or value.id == 'modernshower' then
            Shower = key
        elseif value.id == 'piano' then
            Piano = key
        elseif value.id == 'lures_2023_normal_lure' then
            NormalLure = key
        elseif value.id == 'ailments_refresh_2024_litter_box' then
            LitterBox = key
        end
    end
end
local function buyFurniture(furnitureId)
    print(`\u{1f4b8} No {furnitureId}, so buying it \u{1f4b8}`)

    local args = {
        {
            {
                ['kind'] = furnitureId,
                ['properties'] = {
                    ['cframe'] = CFrame.new(14, 2, -22) * CFrame.Angles(-0, 8.7, 3.8),
                },
            },
        },
    }

    ReplicatedStorage:WaitForChild('API'):WaitForChild('HousingAPI/BuyFurnitures'):InvokeServer(unpack(args))
end
local function grabDailyReward()
    print('getting daily rewards')

    local Daily = ClientData.get('daily_login_manager')

    if Daily.prestige % 2 == 0 then
        for i, v in pairs(DailyRewardTable)do
            if i < Daily.stars or i == Daily.stars then
                if not Daily.claimed_star_rewards[v] then
                    print('grabbing dialy reward!')
                    print(ReplicatedStorage.API:FindFirstChild('DailyLoginAPI/ClaimStarReward'):InvokeServer(v))
                end
            end
        end
    else
        for i, v in pairs(DailyRewardTable2)do
            if i < Daily.stars or i == Daily.stars then
                if not Daily.claimed_star_rewards[v] then
                    print('grabbing dialy reward!')
                    print(ReplicatedStorage.API:FindFirstChild('DailyLoginAPI/ClaimStarReward'):InvokeServer(v))
                end
            end
        end
    end
end
local function placeBaitOrPickUp(baitIdPasson)
    if not NormalLure then
        return
    end

    print('placing bait or picking up')

    local args = {
        [1] = game:GetService('Players').LocalPlayer,
        [2] = NormalLure,
        [3] = 'UseBlock',
        [4] = {
            ['bait_unique'] = baitIdPasson,
        },
        [5] = game:GetService('Players').LocalPlayer.Character,
    }
    local success, errorMessage = pcall(function()
        ReplicatedStorage.API:FindFirstChild('HousingAPI/ActivateFurniture'):InvokeServer(unpack(args))
    end)

    print('FIRING BAITBOX', success, errorMessage)
end
local function agePotionCount(nameId)
    local count = 0

    for _, v in ClientData.get_data()[localPlayer.Name].inventory.food do
        if v.id == nameId then
            count += 1
        end
    end

    return count
end
local function gingerbreadAmount()
    return ClientData.get_data()[localPlayer.Name].gingerbread_2024 or 0
end
local function updateStatsGui()
    StatsGuis2:UpdateTextFor('TimeLabel', startTime)

    potionsGained = agePotionCount('pet_age_potion') - startPotionAmount

    if potionsGained < 0 then
        potionsGained = 0
    end

    TempPotions:UpdateTextFor('TempPotions', potionsGained)

    tinyPotionsGained = agePotionCount('tiny_pet_age_potion') - startTinyPotionAmount

    if tinyPotionsGained < 0 then
        tinyPotionsGained = 0
    end

    TempTinyPotions:UpdateTextFor('TempTinyPotions', tinyPotionsGained)

    local currentGingerbread = gingerbreadAmount()

    if currentGingerbread >= startGingerbreadAmount then
        gingerbreadsGained += (currentGingerbread - startGingerbreadAmount)

        startGingerbreadAmount = currentGingerbread
    elseif currentGingerbread < startGingerbreadAmount then
        startGingerbreadAmount = currentGingerbread
    end

    TempGingerbreads:UpdateTextFor('TempGingerbreads', gingerbreadsGained)
    TotalPotions:UpdateTextFor('TotalPotions')
    TotalBucks:UpdateTextFor('TotalBucks')
    TotalGingerbreads:UpdateTextFor('TotalGingerbreads')
    TotalWinterBaits:UpdateTextFor('TotalWinterBaits')
end
local function findBait(baitPassOn)
    local bait

    for _, v in pairs(ClientData.get_data()[localPlayer.Name].inventory.food)do
        if v.id == baitPassOn then
            bait = v.unique

            return bait
        end
    end

    return nil
end
local function getEgg()
    for _, v in pairs(ClientData.get_data()[localPlayer.Name].inventory.pets)do
        if v.id == Egg2Buy and v.id ~= 'practice_dog' and v.properties.age ~= 6 and not v.properties.mega_neon then
            ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(v.unique, {
                ['use_sound_delay'] = true,
            })

            PetCurrentlyFarming = v.unique

            return true
        end
    end

    local BuyEgg = ReplicatedStorage.API['ShopAPI/BuyItem']:InvokeServer('pets', Egg2Buy, {})

    if BuyEgg == 'too little money' then
        return false
    end

    task.wait(1)

    return false
end
local function getPet()
    if getgenv().SETTINGS.FOCUS_FARM_AGE_POTION then
        if GetInventory:GetPetFriendship() then
            return
        end
        if GetInventory:PetRarityAndAge('common', 6) then
            return
        end
        if GetInventory:PetRarityAndAge('legendary', 6) then
            return
        end
        if GetInventory:PetRarityAndAge('ultra_rare', 6) then
            return
        end
        if GetInventory:PetRarityAndAge('rare', 6) then
            return
        end
        if GetInventory:PetRarityAndAge('uncommon', 6) then
            return
        end
    end
    if getgenv().SETTINGS.PET_NEON_PRIORITY then
        if GetInventory:GetNeonPet() then
            return
        end
    end
    if getgenv().SETTINGS.PET_ONLY_PRIORITY then
        if GetInventory:PriorityPet() then
            return
        end
    end
    if getgenv().SETTINGS.HATCH_EGG_PRIORITY then
        if GetInventory:PriorityEgg() then
            return
        end

        ReplicatedStorage.API['ShopAPI/BuyItem']:InvokeServer('pets', getgenv().SETTINGS.HATCH_EGG_PRIORITY_NAMES[1], {})

        return
    end
    if GetInventory:PetRarityAndAge('legendary', 5) then
        return
    end
    if GetInventory:PetRarityAndAge('ultra_rare', 5) then
        return
    end
    if GetInventory:PetRarityAndAge('rare', 5) then
        return
    end
    if GetInventory:PetRarityAndAge('uncommon', 5) then
        return
    end
    if GetInventory:PetRarityAndAge('common', 5) then
        return
    end
    if getEgg() then
        return
    end
end
local function removeHandHeldItem()
    local tool = localPlayer.Character:FindFirstChildOfClass('Tool')

    if tool then
        ReplicatedStorage.API['ToolAPI/Unequip']:InvokeServer(tool.unique.Value, {})
    end
end
local function CheckifEgg()
    local PetUniqueID = ClientData.get('pet_char_wrappers')[1]['pet_unique']
    local PetAge = ClientData.get('pet_char_wrappers')[1]['pet_progression']['age']

    if PetUniqueID == PetCurrentlyFarming then
        return
    end
    if PetAge ~= 1 then
        return
    end

    getPet()
end
local function SwitchOutFullyGrown()
    if isBuyingOrAging then
        return
    end
    if ClientData.get('pet_char_wrappers')[1] == nil or false then
        getPet()

        return
    end

    local PetAge = ClientData.get('pet_char_wrappers')[1]['pet_progression']['age']

    if PetAge == 6 then
        getPet()

        return
    elseif PetAge == 1 then
        CheckifEgg()
    end
end
local function PlaceFloorAtSpleefMinigame()
    if Workspace:FindFirstChild('SpleefLocation') then
        return
    end

    local interiorOrigin = Workspace:WaitForChild('Interiors'):WaitForChild('SpleefMinigame'):WaitForChild('InteriorOrigin')
    local part = Instance.new('Part')

    part.Position = interiorOrigin.Position
    part.Size = Vector3.new(200, 2, 200)
    part.Anchored = true
    part.Transparency = 0
    part.Name = 'SpleefLocation'
    part.Parent = Workspace
end
local function removeGameOverButton()
    task.wait()
    localPlayer.PlayerGui.MinigameRewardsApp.Body.Button:WaitForChild('Face')

    for _, v in pairs(localPlayer.PlayerGui.MinigameRewardsApp.Body.Button:GetDescendants())do
        if v.Name == 'TextLabel' then
            if v.Text == 'NICE!' then
                fireButton(v.Parent.Parent)

                break
            end
        end
    end
end
local function onTextChangedMiniGame()
    if getgenv().SETTINGS.EVENT.DO_FROSTCLAW_MINIGAME then
        findButton('No')

        return
    end
    if getgenv().SETTINGS.EVENT and getgenv().SETTINGS.EVENT.DO_MINIGAME then
        findButton('Yes')
    else
        findButton('No')
    end
end
local function completeBabyAilments()
    for key, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.baby_ailments do
        if key == 'hungry' then
            Ailments:BabyHungryAilment()

            return
        elseif key == 'thirsty' then
            Ailments:BabyThirstyAilment()

            return
        elseif key == 'bored' then
            Ailments:BabyBoredAilment(Piano)

            return
        elseif key == 'sleepy' then
            Ailments:BabySleepyAilment(Bed)

            return
        elseif key == 'dirty' then
            Ailments:BabyDirtyAilment(Shower)

            return
        end
    end
end
local function checkIfPetEquipped()
    if not ClientData.get('pet_char_wrappers')[1] then
        print('no pet so requipping')
        ReplicatedStorage.API['ToolAPI/Unequip']:InvokeServer(PetCurrentlyFarming, {})
        task.wait(1)
        ReplicatedStorage.API['ToolAPI/Equip']:InvokeServer(PetCurrentlyFarming, {})

        local count = 0

        repeat
            count += 1

            task.wait(1)
        until ClientData.get_data()[localPlayer.Name].pet_char_wrappers[1] or count > 10

        if count > 10 then
            checkIfPetEquipped()
        end
    end
end
local function CompletePetAilments()
    checkIfPetEquipped()

    local petUnique = ClientData.get_data()[localPlayer.Name].pet_char_wrappers[1].pet_unique

    if not ClientData.get_data()[localPlayer.Name].ailments_manager then
        return false
    end
    if not ClientData.get_data()[localPlayer.Name].ailments_manager.ailments then
        return false
    end
    if not ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique] then
        return false
    end

    for key, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique]do
        if key == 'hungry' then
            Ailments:HungryAilment()
            task.wait(1)

            return true
        elseif key == 'thirsty' then
            Ailments:ThirstyAilment()

            return true
        elseif key == 'sick' then
            Ailments:SickAilment()

            return true
        end
    end
    for key, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique]do
        if key == 'salon' then
            Ailments:SalonAilment(key, petUnique)

            return true
        elseif key == 'pizza_party' then
            Ailments:PizzaPartyAilment(key, petUnique)

            return true
        elseif key == 'school' then
            Ailments:SchoolAilment(key, petUnique)

            return true
        elseif key == 'bored' then
            Ailments:BoredAilment(Piano, petUnique)

            return true
        elseif key == 'sleepy' then
            Ailments:SleepyAilment(Bed, petUnique)
            task.wait(3)
            placeBaitOrPickUp(baitId)

            return true
        elseif key == 'dirty' then
            Ailments:DirtyAilment(Shower, petUnique)

            return true
        elseif key == 'walk' then
            Ailments:WalkAilment(petUnique)

            return true
        elseif key == 'toilet' then
            if not LitterBox then
                print('DOEST HAVE LITTER BOX')
            end

            Ailments:ToiletAilment(LitterBox, petUnique)

            return true
        elseif key == 'ride' then
            Ailments:RideAilment(strollerId, petUnique)

            return true
        elseif key == 'play' then
            Ailments:PlayAilment(key, petUnique)

            return true
        end
    end
    for key, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique]do
        if key == 'beach_party' then
            Teleport.PlaceFloorAtBeachParty()
            Ailments:BeachPartyAilment(petUnique)
            Teleport.FarmingHome()

            return true
        elseif key == 'camping' then
            Teleport.PlaceFloorAtCampSite()
            Ailments:CampingAilment(petUnique)
            Teleport.FarmingHome()

            return true
        end
    end
    for key, _ in ClientData.get_data()[localPlayer.Name].ailments_manager.ailments[petUnique]do
        if key:match('mystery') then
            Ailments:MysteryAilment(key, petUnique)

            return true
        end
    end

    return false
end
local function autoFarm()
    if not getgenv().auto_farm then
        return
    end

    CollisionsClient.set_collidable(false)
    Teleport.PlaceFloorAtFarmingHome()
    Teleport.PlaceFloorAtCampSite()
    Teleport.PlaceFloorAtBeachParty()
    Teleport.FarmingHome()
    task.delay(30, function()
        while true do
            if isInMiniGame then
                local count = 0

                repeat
                    print(`\u{23f1}\u{fe0f} Waiting for 10 secs [inside minigame] \u{23f1}\u{fe0f}`)

                    count += 10

                    task.wait(10)
                until not isInMiniGame or count > 120

                isInMiniGame = false
            end

            removeHandHeldItem()

            if not CompletePetAilments() then
                completeBabyAilments()
            end

            updateStatsGui()
            task.wait(5)
        end
    end)

    if getgenv().SETTINGS.PET_AUTO_FUSION then
        task.spawn(function()
            Fusion:MakeMega(false)
            Fusion:MakeMega(true)
        end)
    end

    task.wait()
    getPet()
    task.wait()
end
local function startAutoFarm()
    if getgenv().SETTINGS.EVENT.DO_FROSTCLAW_MINIGAME then
        return
    end

    counter += 1

    if getgenv().SETTINGS.ENABLE_AUTO_FARM then
        findFurniture()

        if Bed then
            getgenv().auto_farm = true

            autoFarm()
        end
    end
end
local function SendMessage(url, message, userId)
    local http = game:GetService('HttpService')
    local headers = {
        ['Content-Type'] = 'application/json',
    }
    local data = {
        ['content'] = `<@{userId}> {message}`,
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = 'POST',
        Headers = headers,
        Body = body,
    })

    for i, v in response do
        print(i, v)
    end
end
local function dailyLoginAppClick()
    task.wait(0.1)

    if not localPlayer.PlayerGui.DailyLoginApp.Enabled then
        return
    end

    localPlayer.PlayerGui.DailyLoginApp:WaitForChild('Frame')
    localPlayer.PlayerGui.DailyLoginApp.Frame:WaitForChild('Body')
    localPlayer.PlayerGui.DailyLoginApp.Frame.Body:WaitForChild('Buttons')

    for _, v in localPlayer.PlayerGui.DailyLoginApp.Frame.Body.Buttons:GetDescendants()do
        if v.Name == 'TextLabel' then
            if v.Text == 'CLOSE' then
                print('pressed Close on daily login')
                fireButton(v.Parent.Parent)
                task.wait(1)
                grabDailyReward()
            elseif v.Text == 'CLAIM!' then
                print('pressed claim on daily login')
                fireButton(v.Parent.Parent)
                task.wait()
                fireButton(v.Parent.Parent)
                grabDailyReward()
            end
        end
    end
end
local function onTextChangedNormalDialog()
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Be careful when trading') then
        findButton('Okay')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('This trade seems unbalanced') then
        findButton('Next')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('sent you a trade request') then
        findButton('Accept')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Any items lost') then
        findButton('I understand')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('4.5%% Legendary') then
        findButton('Okay')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Welcome to Adopt Me!') then
        print('doing tutorial')
        task.wait(1)
        print('doing trade license')
        task.wait(1)
        findButton('Next')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match("Let's start the day") then
        findButton('Start')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Are you subscribed') then
        findButton('Yes')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('your inventory!') then
        findButton('Awesome!')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Gingerbread!') then
        findButton('Awesome!')
    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Thanks for') then
        findButton('Okay')
    end
end
local function pickColorTutorial()
    local colorButton = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog:WaitForChild('Info'):WaitForChild('Response'):WaitForChild('ColorTemplate')

    if not colorButton then
        return
    end

    fireButton(colorButton)
    task.wait(5)

    local doneButton = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog:WaitForChild('Buttons'):WaitForChild('ButtonTemplate')

    if not doneButton then
        return
    end

    fireButton(doneButton)
end

localPlayer.Idled:Connect(function()
    VirtualUser:ClickButton2(Vector2.new())
end)
localPlayer.PlayerGui.HintApp.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
)
    if localPlayer.PlayerGui.HintApp.TextLabel.Text:match('Bucks') then
        local text = localPlayer.PlayerGui.HintApp.TextLabel.Text

        if not text then
            return
        end

        print(text)

        local amount = text:split('+')[2]:split(' ')[1]

        bucksGained += tonumber(amount)

        TempBucks:UpdateTextFor('TempBucks', bucksGained)
    elseif localPlayer.PlayerGui.HintApp.TextLabel.Text:match('aged up!') then
        if getgenv().feedAgeUpPotionToggle then
            return
        end
        if getgenv().SETTINGS.PET_AUTO_FUSION then
            Fusion:MakeMega(false)
            Fusion:MakeMega(true)
        end

        task.wait(2)

        if not getgenv().SETTINGS.FOCUS_FARM_AGE_POTION then
            SwitchOutFullyGrown()
        end
    end
end)

PickColorConn = localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Visible then
        print('picking color')
        pickColorTutorial()

        if PickColorConn then
            PickColorConn:Disconnect()

            PickColorConn = nil
        end
    end
end)
banMessageConnection = localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Visible then
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:WaitForChild('Info')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info:WaitForChild('TextLabel')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
        )
            if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('ban') then
                findButton('Okay')

                if banMessageConnection then
                    banMessageConnection:Disconnect()

                    banMessageConnection = nil
                end
            elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('You have been awarded') then
                findButton('Awesome!')
            end
        end)
    end
end)
RoleChooserDialogConnection = localPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    task.wait()

    if localPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Visible then
        firesignal(localPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby.MouseButton1Click)

        if RoleChooserDialogConnection then
            RoleChooserDialogConnection:Disconnect()

            RoleChooserDialogConnection = nil
        end
    end
end)
RobuxProductDialogConnection1 = localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if not localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then
        return
    end

    localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog:WaitForChild('Buttons')
    task.wait()

    for _, v in localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetDescendants()do
        if v.Name == 'TextLabel' then
            if v.Text == 'No Thanks' then
                firesignal(v.Parent.Parent.MouseButton1Click)

                if RobuxProductDialogConnection1 then
                    RobuxProductDialogConnection1:Disconnect()

                    RobuxProductDialogConnection1 = nil
                end
            end
        end
    end
end)
RobuxProductDialogConnection2 = localPlayer.PlayerGui.DialogApp.Dialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if not localPlayer.PlayerGui.DialogApp.Dialog.Visible then
        return
    end

    localPlayer.PlayerGui.DialogApp.Dialog:WaitForChild('RobuxProductDialog')

    if not localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then
        return
    end

    localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog:WaitForChild('Buttons')
    task.wait()

    for _, v in localPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetDescendants()do
        if v.Name == 'TextLabel' then
            if v.Text == 'No Thanks' then
                firesignal(v.Parent.Parent.MouseButton1Click)

                if RobuxProductDialogConnection2 then
                    RobuxProductDialogConnection2:Disconnect()

                    RobuxProductDialogConnection2 = nil
                end
            end
        end
    end
end)
DailyClaimConnection = localPlayer.PlayerGui.DailyLoginApp:GetPropertyChangedSignal('Enabled'):Connect(function(
)
    dailyLoginAppClick()

    if DailyClaimConnection then
        DailyClaimConnection:Disconnect()

        DailyClaimConnection = nil
    end
end)

localPlayer.PlayerGui.DialogApp.Dialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if not localPlayer.PlayerGui.DialogApp.Dialog.Visible then
        return
    end

    localPlayer.PlayerGui.DialogApp.Dialog:WaitForChild('HeaderDialog')

    if not localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Visible then
        return
    end

    localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog:WaitForChild('Info')
    localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info:WaitForChild('TextLabel')
    localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
    )
        if localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info.TextLabel.Text:match('sent you a trade request') then
            findButton('Accept', 'HeaderDialog')
        end
    end)
end)
localPlayer.PlayerGui.DialogApp.Dialog.ChildAdded:Connect(function(Child)
    if Child.Name ~= 'HeaderDialog' then
        return
    end

    Child:GetPropertyChangedSignal('Visible'):Connect(function()
        if not Child.Visible then
            return
        end

        Child:WaitForChild('Info')
        Child.Info:WaitForChild('TextLabel')
        Child.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function()
            if Child.Info.TextLabel.Text:match('sent you a trade request') then
                findButton('Accept', 'HeaderDialog')
            end
        end)
    end)
end)
localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Visible then
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:WaitForChild('Info')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info:WaitForChild('TextLabel')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(onTextChangedNormalDialog)
    end
end)
localPlayer.PlayerGui.DialogApp.Dialog.ChildAdded:Connect(function(Child)
    if Child.Name ~= 'NormalDialog' then
        return
    end

    Child:GetPropertyChangedSignal('Visible'):Connect(function()
        if not Child.Visible then
            return
        end

        Child:WaitForChild('Info')
        Child.Info:WaitForChild('TextLabel')
        Child.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(onTextChangedNormalDialog)
    end)
end)

if getgenv().SETTINGS.WEBHOOK and getgenv().SETTINGS.WEBHOOK.URL and #getgenv().SETTINGS.WEBHOOK.URL >= 1 and localPlayer.Name == getgenv().SETTINGS.TRADE_COLLECTOR_NAME then
    localPlayer.PlayerGui.DialogApp.Dialog:GetPropertyChangedSignal('Visible'):Connect(function(
    )
        if discordCooldown then
            return
        end

        discordCooldown = true

        localPlayer.PlayerGui.DialogApp.Dialog:WaitForChild('HeaderDialog')
        localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog:GetPropertyChangedSignal('Visible'):Connect(function(
        )
            if not localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Visible then
                return
            end

            localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog:WaitForChild('Info')
            localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info:WaitForChild('TextLabel')
            localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
            )
                SendMessage(getgenv().SETTINGS.WEBHOOK.URL, localPlayer.PlayerGui.DialogApp.Dialog.HeaderDialog.Info.TextLabel.Text, getgenv().SETTINGS.WEBHOOK.USER_ID)
                task.wait(1)

                discordCooldown = false
            end)
        end)
    end)
end

localPlayer.PlayerGui.MinigameInGameApp:GetPropertyChangedSignal('Enabled'):Connect(function(
)
    if localPlayer.PlayerGui.MinigameInGameApp.Enabled then
        localPlayer.PlayerGui.MinigameInGameApp:WaitForChild('Body')
        localPlayer.PlayerGui.MinigameInGameApp.Body:WaitForChild('Middle')
        localPlayer.PlayerGui.MinigameInGameApp.Body.Middle:WaitForChild('Container')
        localPlayer.PlayerGui.MinigameInGameApp.Body.Middle.Container:WaitForChild('TitleLabel')

        if localPlayer.PlayerGui.MinigameInGameApp.Body.Middle.Container.TitleLabel.Text:match('MELT OFF') then
            isInMiniGame = true

            PlaceFloorAtSpleefMinigame()
            task.wait(2)

            localPlayer.Character.PrimaryPart.CFrame = Workspace:WaitForChild('SpleefLocation').CFrame + Vector3.new(0, 5, 0)
        end
    end
end)
localPlayer.PlayerGui.DialogApp.Dialog.ChildAdded:Connect(function(
    NormalDialogChild
)
    if NormalDialogChild.Name == 'NormalDialog' then
        NormalDialogChild:GetPropertyChangedSignal('Visible'):Connect(function()
            if NormalDialogChild.Visible then
                NormalDialogChild:WaitForChild('Info')
                NormalDialogChild.Info:WaitForChild('TextLabel')
                NormalDialogChild.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
                )
                    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Melt Off') then
                        onTextChangedMiniGame()
                    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('invitation') then
                    elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('You found a') then
                        findButton('Okay')
                    end
                end)
            end
        end)
    end
end)
localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Visible then
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog:WaitForChild('Info')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info:WaitForChild('TextLabel')
        localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel:GetPropertyChangedSignal('Text'):Connect(function(
        )
            if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Melt Off') then
                onTextChangedMiniGame()
            elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('invitation') then
            elseif localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('You found a') then
                findButton('Okay')
            end
        end)
    end
end)
Workspace.StaticMap.spleef_minigame_minigame_state.players_loading:GetPropertyChangedSignal('Value'):Connect(function(
)
    if Workspace.StaticMap.spleef_minigame_minigame_state.players_loading.Value then
        task.wait(1)

        if getgenv().SETTINGS.EVENT.DO_FROSTCLAW_MINIGAME then
            return
        end

        ReplicatedStorage.API:FindFirstChild('MinigameAPI/AttemptJoin'):FireServer('spleef_minigame', true)
    end
end)
localPlayer.PlayerGui.MinigameRewardsApp.Body:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.MinigameRewardsApp.Body.Visible then
        localPlayer.PlayerGui.MinigameRewardsApp.Body:WaitForChild('Button')
        localPlayer.PlayerGui.MinigameRewardsApp.Body.Button:WaitForChild('Face')
        localPlayer.PlayerGui.MinigameRewardsApp.Body.Button.Face:WaitForChild('TextLabel')
        localPlayer.PlayerGui.MinigameRewardsApp.Body:WaitForChild('Reward')
        localPlayer.PlayerGui.MinigameRewardsApp.Body.Reward:WaitForChild('TitleLabel')

        if localPlayer.PlayerGui.MinigameRewardsApp.Body.Button.Face.TextLabel.Text:match('NICE!') then
            localPlayer.Character.HumanoidRootPart.Anchored = false

            removeGameOverButton()

            isInMiniGame = false

            if not getgenv().SETTINGS.EVENT.DO_FROSTCLAW_MINIGAME then
                Teleport.FarmingHome()
            end
        end
    end
end)
localPlayer.PlayerGui.BattlePassApp.Body:GetPropertyChangedSignal('Visible'):Connect(function(
)
    if localPlayer.PlayerGui.BattlePassApp.Body.Visible then
        localPlayer.PlayerGui.BattlePassApp.Body:WaitForChild('InnerBody')
        localPlayer.PlayerGui.BattlePassApp.Body.InnerBody:WaitForChild('ScrollingFrame')
        localPlayer.PlayerGui.BattlePassApp.Body.InnerBody.ScrollingFrame:WaitForChild('21')

        if localPlayer.PlayerGui.BattlePassApp.Body.InnerBody.ScrollingFrame[21] then
            for _, v in localPlayer.PlayerGui.BattlePassApp.Body.InnerBody.ScrollingFrame:GetChildren()do
                if not v:FindFirstChild('ButtonFrame') then
                    continue
                end
                if v.ButtonFrame:FindFirstChild('ClaimButton') then
                end
            end
        end
    end
end)

repeat
    task.wait(5)
until localPlayer.PlayerGui.NewsApp.Enabled or localPlayer.Character or localPlayer.PlayerGui.DialogApp.Dialog.ThemeColorDialog.Visible

startTime = DateTime.now().UnixTimestamp
startPotionAmount = agePotionCount('pet_age_potion')
startTinyPotionAmount = agePotionCount('tiny_pet_age_potion')
startGingerbreadAmount = gingerbreadAmount()

StatsGuis2:UpdateTextFor('TimeLabel', startTime)
TempPotions:UpdateTextFor('TempPotions', potionsGained)
TempTinyPotions:UpdateTextFor('TempTinyPotions', tinyPotionsGained)
TempBucks:UpdateTextFor('TempBucks', bucksGained)
TempGingerbreads:UpdateTextFor('TempGingerbreads', gingerbreadsGained)
TotalPotions:UpdateTextFor('TotalPotions')
TotalTinyPotions:UpdateTextFor('TotalTinyPotions')
TotalBucks:UpdateTextFor('TotalBucks')
TotalGingerbreads:UpdateTextFor('TotalGingerbreads')
TotalWinterBaits:UpdateTextFor('TotalWinterBaits')
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Captures, false)

if gethui then
    TestGui.Parent = gethui()
elseif syn.protect_gui then
    syn.protect_gui(TestGui)

    TestGui.Parent = CoreGui
elseif CoreGui:FindFirstChild('RobloxGui') then
    TestGui.Parent = CoreGui:FindFirstChild('RobloxGui')
else
    TestGui.Parent = CoreGui
end

TestGui.Name = 'TestGui'
TestGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UserGameSettings.GraphicsQualityLevel = 1
UserGameSettings.MasterVolume = 0

for i, v in debug.getupvalue(RouterClient.init, 7)do
    v.Name = i
end

if localPlayer.PlayerGui.NewsApp.Enabled then
    local AbsPlay = localPlayer.PlayerGui.NewsApp:WaitForChild('EnclosingFrame'):WaitForChild('MainFrame'):WaitForChild('Contents'):WaitForChild('PlayButton')

    fireButton(AbsPlay)
end
if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Visible then
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('ban') then
        task.wait(1)
        findButton('Okay')

        if banMessageConnection then
            banMessageConnection:Disconnect()

            banMessageConnection = nil
        end
    end
end
if localPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Visible then
    task.wait(1)
    firesignal(localPlayer.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby.MouseButton1Click)

    if RoleChooserDialogConnection then
        RoleChooserDialogConnection:Disconnect()

        RoleChooserDialogConnection = nil
    end
end
if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Visible then
    if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('4.5%% Legendary') then
        task.wait(1)
        findButton('Okay')
    end
end

findFurniture()

if not Bed then
    buyFurniture('basiccrib')
end

task.wait(1)

if not Piano then
    buyFurniture('piano')
end

task.wait(1)

if not LitterBox then
    buyFurniture('ailments_refresh_2024_litter_box')
end

task.wait(1)

if not NormalLure then
    buyFurniture('lures_2023_normal_lure')
end

task.wait(1)

baitId = findBait('winter_2024_winter_deer_bait')

if not baitId then
    baitId = findBait('lures_2023_campfire_cookies')
end

print(`\u{1f36a} Found baitId: {baitId} \u{1f36a}`)
placeBaitOrPickUp(baitId)
task.wait(1)
placeBaitOrPickUp(baitId)

strollerId = GetInventory:GetUniqueId('strollers', 'stroller-default')

findFurniture()
print(`Has Bed: {Bed} \u{1f6cf}\u{fe0f} | Has Piano: {Piano} \u{1f3b9} | Has LitterBox: {LitterBox} \u{1f4a9} | Has Lure: {NormalLure}`)
ReplicatedStorage:WaitForChild('API'):WaitForChild('HousingAPI/SetDoorLocked'):InvokeServer(true)

if not localPlayer.Character then
    localPlayer.CharacterAdded:Wait()
end
if localPlayer.Character:WaitForChild('HumanoidRootPart') then
    ReplicatedStorage.API['TeamAPI/ChooseTeam']:InvokeServer('Babies', {
        ['dont_send_back_home'] = true,
    })
end
if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('Thanks for subscribing!') then
    findButton('Okay')
end
if localPlayer.PlayerGui.DialogApp.Dialog.NormalDialog.Info.TextLabel.Text:match('You have been awarded') then
    findButton('Awesome!')
end

Teleport.PlaceFloorAtFarmingHome()
Teleport.PlaceFloorAtCampSite()
Teleport.PlaceFloorAtBeachParty()
dailyLoginAppClick()

if getgenv().SETTINGS.PET_AUTO_FUSION then
    print('FUSING PETS IF THERES ANY TO DO')
    Fusion:MakeMega(false)
    Fusion:MakeMega(true)
    print('DONE FUSING')
end

isBuyingOrAging = false

if DailyClaimConnection then
    DailyClaimConnection:Disconnect()

    DailyClaimConnection = nil
end

task.delay(5, function()
    if Players.LocalPlayer.Name == getgenv().SETTINGS.TRADE_COLLECTOR_NAME and getgenv().SETTINGS.ENABLE_TRADE_COLLECTOR == true then
        task.spawn(function()
            getgenv().AutoTradeToggle:Set(true)
        end)
    end
end)
task.wait(2)
startAutoFarm()

if getgenv().SETTINGS.ENABLE_AUTO_FARM and getgenv().SETTINGS.EVENT.DO_FROSTCLAW_MINIGAME then
    Christmas2024.init()
    localPlayer.Idled:Connect(function()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    task.spawn(function()
        while true do
            if isTradingMule then
                repeat
                    task.wait(5)
                until not isTradingMule
            end

            print('running frostclaw event')
            updateStatsGui()

            if Christmas2024.CreateAndStartLobby() then
                Christmas2024.StartGame()
            end

            baitId = findBait('winter_2024_winter_deer_bait')

            if not baitId then
                baitId = findBait('lures_2023_campfire_cookies')
            end

            task.wait(2)
            placeBaitOrPickUp(baitId)
            task.wait(2)
            placeBaitOrPickUp(baitId)
            task.wait(5)
        end
    end)
end

print('Loaded. lastest update 1/6/2025  mm/dd/yyyy')
