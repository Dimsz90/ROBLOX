-- ADVANCED FISH CATCH DETECTOR with DESTROY UI
-- Berdasarkan struktur: ReplicatedStorage.Controllers.ClassicGroupFishingController

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishCatcher"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0, 50, 0, 150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🎣 FISH CATCH DETECTOR"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 20
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Recent Catches
local RecentFrame = Instance.new("Frame")
RecentFrame.Size = UDim2.new(1, -20, 0, 60)
RecentFrame.Position = UDim2.new(0, 10, 0, 75)
RecentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
RecentFrame.Parent = MainFrame

local RecentTitle = Instance.new("TextLabel")
RecentTitle.Size = UDim2.new(1, -10, 0, 20)
RecentTitle.Position = UDim2.new(0, 5, 0, 5)
RecentTitle.BackgroundTransparency = 1
RecentTitle.Text = "Recent Catches"
RecentTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
RecentTitle.TextSize = 14
RecentTitle.Font = Enum.Font.SourceSansBold
RecentTitle.Parent = RecentFrame

local LastCatch = Instance.new("TextLabel")
LastCatch.Size = UDim2.new(0.48, 0, 0, 30)
LastCatch.Position = UDim2.new(0, 5, 0, 25)
LastCatch.BackgroundTransparency = 1
LastCatch.Text = "Last: None"
LastCatch.TextColor3 = Color3.fromRGB(200, 200, 200)
LastCatch.TextSize = 13
LastCatch.Font = Enum.Font.SourceSans
LastCatch.TextXAlignment = Enum.TextXAlignment.Left
LastCatch.Parent = RecentFrame

local TotalCaught = Instance.new("TextLabel")
TotalCaught.Size = UDim2.new(0.48, 0, 0, 30)
TotalCaught.Position = UDim2.new(0.52, 0, 0, 25)
TotalCaught.BackgroundTransparency = 1
TotalCaught.Text = "Total: 0"
TotalCaught.TextColor3 = Color3.fromRGB(200, 200, 200)
TotalCaught.TextSize = 13
TotalCaught.Font = Enum.Font.SourceSans
TotalCaught.TextXAlignment = Enum.TextXAlignment.Right
TotalCaught.Parent = RecentFrame

-- Log Area
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 0, 200)
LogFrame.Position = UDim2.new(0, 10, 0, 145)
LogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 6
LogFrame.Parent = MainFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Padding = UDim.new(0, 5)
LogLayout.Parent = LogFrame

-- Control Buttons Frame
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 40)
ControlFrame.Position = UDim2.new(0, 10, 1, -50)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

-- Clear Logs Button
local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, -5, 1, 0)
ClearButton.Position = UDim2.new(0, 0, 0, 0)
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
ClearButton.Text = "🗑️ Clear Logs"
ClearButton.TextColor3 = Color3.new(1, 1, 1)
ClearButton.TextSize = 14
ClearButton.Font = Enum.Font.SourceSansBold
ClearButton.Parent = ControlFrame

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

-- DESTROY SCRIPT BUTTON
local DestroyButton = Instance.new("TextButton")
DestroyButton.Size = UDim2.new(0.48, -5, 1, 0)
DestroyButton.Position = UDim2.new(0.52, 5, 0, 0)
DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyButton.Text = "❌ Destroy Script"
DestroyButton.TextColor3 = Color3.new(1, 1, 1)
DestroyButton.TextSize = 14
DestroyButton.Font = Enum.Font.SourceSansBold
DestroyButton.Parent = ControlFrame

local DestroyCorner = Instance.new("UICorner")
DestroyCorner.CornerRadius = UDim.new(0, 6)
DestroyCorner.Parent = DestroyButton

-- Fungsi untuk menambahkan log
local catchLogs = {}
local totalCatches = 0

local function addLog(text, color)
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, -10, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Entry.Parent = LogFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Entry
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 0)
    Label.Position = UDim2.new(0, 5, 0, 5)
    Label.AutomaticSize = Enum.AutomaticSize.Y
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = color or Color3.new(1, 1, 1)
    Label.TextSize = 12
    Label.Font = Enum.Font.SourceSans
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextYAlignment = Enum.TextYAlignment.Top
    Label.TextWrapped = true
    Label.Parent = Entry
    
    task.wait()
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 10)
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.CanvasSize.Y.Offset)
    
    -- Simpan ke log
    table.insert(catchLogs, {
        Time = os.date("%H:%M:%S"),
        Text = text,
        Color = color
    })
end

-- Clear logs function
ClearButton.MouseButton1Click:Connect(function()
    for _, child in pairs(LogFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    catchLogs = {}
    addLog("🗑️ Logs cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Status: Logs cleared"
end)

-- DESTROY SCRIPT FUNCTION
DestroyButton.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying script in 3 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: DESTROYING..."
    
    -- Countdown
    for i = 3, 1, -1 do
        DestroyButton.Text = "❌ Destroying in " .. i .. "..."
        task.wait(1)
    end
    
    -- Destroy semua UI
    ScreenGui:Destroy()
    
    -- Hapus semua connections jika ada
    if connections then
        for _, conn in pairs(connections) do
            pcall(function() conn:Disconnect() end)
        end
    end
    
    -- Hapus semua hooks
    if originalFunctions then
        for name, func in pairs(originalFunctions) do
            pcall(function()
                if fishingController then
                    fishingController[name] = func
                end
            end)
        end
    end
    
    print("Fish Catcher Script Destroyed!")
    
    -- Hapus script dari memory
    script = nil
    collectgarbage()
end)

-- Map rarity number to name
local rarityMap = {
    [1] = "Common",
    [2] = "Uncommon", 
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "SECRET"
}

local rarityColors = {
    [1] = Color3.fromRGB(150, 150, 150),      -- Common
    [2] = Color3.fromRGB(100, 200, 100),      -- Uncommon
    [3] = Color3.fromRGB(100, 150, 255),      -- Rare
    [4] = Color3.fromRGB(200, 100, 255),      -- Epic
    [5] = Color3.fromRGB(255, 215, 0),        -- Legendary
    [6] = Color3.fromRGB(255, 100, 100),      -- Mythic
    [7] = Color3.fromRGB(255, 50, 255)        -- SECRET
}

-- Cari FishingController
local fishingController = nil
local connections = {}
local originalFunctions = {}

-- Fungsi utama untuk setup detection
local function setupFishCatchDetection()
    addLog("🔍 Looking for FishingController...", Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Status: Searching for FishingController..."
    
    -- Method 1: Coba di ReplicatedStorage.Controllers
    local controllersFolder = ReplicatedStorage:FindFirstChild("Controllers")
    if controllersFolder then
        addLog("✅ Found Controllers folder", Color3.fromRGB(0, 255, 150))
        
        local controllerModule = controllersFolder:FindFirstChild("ClassicGroupFishingController")
        if controllerModule then
            addLog("🎯 Found ClassicGroupFishingController!", Color3.fromRGB(0, 255, 0))
            
            local success, moduleData = pcall(function()
                return require(controllerModule)
            end)
            
            if success then
                fishingController = moduleData
                addLog("📦 Successfully loaded FishingController", Color3.fromRGB(0, 255, 150))
                
                -- Analyze module
                addLog("--- MODULE ANALYSIS ---", Color3.fromRGB(255, 200, 100))
                
                local fishCatchFunctions = {}
                local events = {}
                
                for key, value in pairs(moduleData) do
                    local keyLower = key:lower()
                    
                    if type(value) == "function" then
                        if keyLower:find("catch") or keyLower:find("fish") or keyLower:find("caught") then
                            table.insert(fishCatchFunctions, key)
                            addLog("🎣 Function: " .. key, Color3.fromRGB(100, 255, 200))
                        end
                    elseif typeof(value) == "RBXScriptSignal" then
                        if keyLower:find("catch") or keyLower:find("fish") or keyLower:find("caught") then
                            table.insert(events, key)
                            addLog("⚡ Event: " .. key, Color3.fromRGB(255, 100, 100))
                        end
                    end
                end
                
                -- Hook ke fungsi yang ditemukan
                if #fishCatchFunctions > 0 then
                    for _, funcName in ipairs(fishCatchFunctions) do
                        originalFunctions[funcName] = fishingController[funcName]
                        
                        fishingController[funcName] = function(...)
                            local args = {...}
                            
                            -- Log trigger
                            local logText = "⚡ " .. funcName .. " triggered!"
                            addLog(logText, Color3.fromRGB(255, 200, 100))
                            
                            -- Analyze arguments for fish data
                            for i, arg in ipairs(args) do
                                if type(arg) == "table" then
                                    -- Check if this is fish data
                                    local fishName = arg.Name or arg.FishName or arg.fishName
                                    local rarityNum = arg.Rarity or arg.rarity or arg.Tier or arg.tier
                                    local weight = arg.Weight or arg.weight or arg.Size or arg.size
                                    local mutation = arg.Mutation or arg.mutation or arg.Shiny or arg.shiny or arg.Variant or arg.variant
                                    
                                    if fishName then
                                        -- Convert rarity number to name
                                        local rarityName = rarityMap[rarityNum] or tostring(rarityNum or "?")
                                        local rarityColor = rarityColors[rarityNum] or Color3.fromRGB(200, 200, 200)
                                        
                                        totalCatches = totalCatches + 1
                                        
                                        local catchText = string.format("🎣 CAUGHT: %s", fishName)
                                        local detailsText = string.format("   ├─ Rarity: %s (%s)", rarityName, rarityNum or "?")
                                        local weightText = string.format("   ├─ Weight: %s", tostring(weight or "?"))
                                        local mutationText = string.format("   └─ Mutation: %s", tostring(mutation or "None"))
                                        
                                        addLog(catchText, rarityColor)
                                        addLog(detailsText, rarityColor)
                                        addLog(weightText, rarityColor)
                                        addLog(mutationText, rarityColor)
                                        
                                        -- Update UI
                                        LastCatch.Text = "Last: " .. fishName
                                        TotalCaught.Text = "Total: " .. totalCatches
                                        StatusLabel.Text = "Status: Caught " .. fishName
                                        
                                        -- Print to console too
                                        print(string.format("[FISH CAUGHT] %s | Rarity: %s (%s) | Weight: %s | Mutation: %s", 
                                            fishName, rarityName, rarityNum or "?", tostring(weight or "?"), tostring(mutation or "None")))
                                    end
                                end
                            end
                            
                            -- Call original function
                            return originalFunctions[funcName](...)
                        end
                        
                        addLog("✅ Hooked to function: " .. funcName, Color3.fromRGB(0, 255, 0))
                    end
                else
                    addLog("⚠️ No fish catch functions found in module", Color3.fromRGB(255, 150, 50))
                end
                
            else
                addLog("❌ Failed to load module: " .. tostring(moduleData), Color3.fromRGB(255, 50, 50))
            end
        else
            addLog("❌ ClassicGroupFishingController not found", Color3.fromRGB(255, 50, 50))
        end
    else
        addLog("❌ Controllers folder not found", Color3.fromRGB(255, 50, 50))
    end
    
    -- Method 2: Cari RemoteEvents untuk fish caught
    addLog("--- SEARCHING FOR REMOTEEVENTS ---", Color3.fromRGB(200, 200, 255))
    
    local remoteEvents = {}
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("RemoteEvent") then
            local nameLower = item.Name:lower()
            if nameLower:find("fish") or nameLower:find("catch") or nameLower:find("caught") then
                table.insert(remoteEvents, item)
                addLog("📡 Found RemoteEvent: " .. item.Name, Color3.fromRGB(150, 200, 255))
            end
        end
    end
    
    -- Connect to remote events
    for _, remote in ipairs(remoteEvents) do
        local connection = remote.OnClientEvent:Connect(function(...)
            local args = {...}
            
            addLog("⚡ RemoteEvent: " .. remote.Name .. " fired", Color3.fromRGB(255, 150, 100))
            
            -- Check for fish data
            for i, arg in ipairs(args) do
                if type(arg) == "table" then
                    local fishName = arg.Name or arg.FishName
                    local rarityNum = arg.Rarity or arg.Tier
                    
                    if fishName then
                        local rarityName = rarityMap[rarityNum] or tostring(rarityNum or "?")
                        local rarityColor = rarityColors[rarityNum] or Color3.fromRGB(200, 200, 200)
                        
                        totalCatches = totalCatches + 1
                        
                        local catchText = string.format("🎣 REMOTE CAUGHT: %s", fishName)
                        addLog(catchText, rarityColor)
                        
                        LastCatch.Text = "Last: " .. fishName
                        TotalCaught.Text = "Total: " .. totalCatches
                        
                        -- Print data details
                        for k, v in pairs(arg) do
                            if type(v) == "string" or type(v) == "number" then
                                addLog("   " .. k .. ": " .. tostring(v), Color3.fromRGB(150, 150, 150))
                            end
                        end
                    end
                end
            end
        end)
        
        table.insert(connections, connection)
        addLog("✅ Connected to: " .. remote.Name, Color3.fromRGB(0, 255, 0))
    end
    
    -- Method 3: Monitor PlayerGui for catch notifications
    addLog("--- MONITORING PLAYERGUI ---", Color3.fromRGB(200, 255, 200))
    
    local guiConnection = player.PlayerGui.ChildAdded:Connect(function(child)
        task.wait(0.1)
        
        -- Check for catch notifications
        for _, descendant in pairs(child:GetDescendants()) do
            if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                local text = descendant.Text
                if text and (text:lower():find("caught") or text:lower():find("you got") or text:lower():find("captured")) then
                    addLog("📱 GUI Notification: " .. text, Color3.fromRGB(255, 215, 0))
                    StatusLabel.Text = "Status: " .. text
                end
            end
        end
    end)
    
    table.insert(connections, guiConnection)
    
    -- Method 4: Monitor attributes
    addLog("--- MONITORING ATTRIBUTES ---", Color3.fromRGB(255, 200, 150))
    
    local function monitorAttribute(attrName)
        player:GetAttributeChangedSignal(attrName):Connect(function()
            local value = player:GetAttribute(attrName)
            if value then
                if type(value) == "table" then
                    if value.Name or value.FishName then
                        addLog("🎣 Attribute " .. attrName .. " updated with fish data", Color3.fromRGB(100, 255, 200))
                    end
                else
                    addLog("📊 Attribute " .. attrName .. " = " .. tostring(value), Color3.fromRGB(200, 200, 200))
                end
            end
        end)
    end
    
    -- Monitor common fish attributes
    local fishAttributes = {"CaughtFish", "LastFish", "CurrentFish", "Fish", "Catch"}
    for _, attr in ipairs(fishAttributes) do
        pcall(monitorAttribute, attr)
    end
    
    -- Load fish database for reference
    addLog("--- LOADING FISH DATABASE ---", Color3.fromRGB(150, 150, 255))
    
    local fishDatabase = {}
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("ModuleScript") and item.Name:match("%a+%s?%a+") then -- Simple name check
            local success, data = pcall(function()
                return require(item)
            end)
            
            if success and type(data) == "table" then
                -- Check if this is fish data
                for key, value in pairs(data) do
                    if type(value) == "table" then
                        local fishName = value.Name or value.FishName or tostring(key)
                        local rarityNum = value.Rarity or value.Tier
                        
                        if fishName and rarityNum then
                            fishDatabase[fishName] = {
                                Name = fishName,
                                Rarity = rarityNum,
                                RarityName = rarityMap[rarityNum] or "Unknown",
                                Weight = value.Weight or value.Size,
                                Mutation = value.Mutation or value.Shiny
                            }
                        end
                    end
                end
            end
        end
    end
    
    addLog("📚 Loaded " .. #fishDatabase .. " fish references", Color3.fromRGB(0, 255, 150))
    
    -- Setup auto fish detection
    StatusLabel.Text = "Status: Ready - Monitoring for fish catches"
    addLog("✅ Fish Catch Detector Ready!", Color3.fromRGB(0, 255, 0))
    addLog("📌 Now go fishing! All catches will be logged here.", Color3.fromRGB(200, 200, 255))
    
    print("=== FISH CATCH DETECTOR ACTIVE ===")
    print("Monitoring: FishingController, RemoteEvents, GUI, Attributes")
    print("Ready to log all fish catches!")
end

-- Start the detection
setupFishCatchDetection()

-- Auto-cleanup jika player keluar
player:GetPropertyChangedSignal("Parent"):Connect(function()
    if not player.Parent then
        pcall(function()
            ScreenGui:Destroy()
        end)
    end
end)
