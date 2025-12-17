-- ADVANCED FISH CATCH ANALYZER
-- Berdasarkan Remote Spy Logs dari game Anda

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FishRemoteAnalyzer"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 500)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 100, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 50)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "🔍 FISH REMOTE ANALYZER"
Title.TextColor3 = Color3.fromRGB(255, 100, 150)
Title.TextSize = 24
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -20, 0, 20)
SubTitle.Position = UDim2.new(0, 10, 0, 55)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Based on Remote Spy Logs - Real Data"
SubTitle.TextColor3 = Color3.fromRGB(180, 180, 255)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Parent = MainFrame

-- Tab System
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -20, 0, 35)
TabsFrame.Position = UDim2.new(0, 10, 0, 80)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local Tabs = {
    "Real Data",
    "Remote Hooks", 
    "Stats Viewer",
    "Auto Logger"
}

local currentTab = "Real Data"
local tabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Tab"
    tabBtn.Size = UDim2.new(1/#Tabs, -2, 1, 0)
    tabBtn.Position = UDim2.new((i-1)/#Tabs, 0, 0, 0)
    tabBtn.BackgroundColor3 = tabName == "Real Data" and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 60)
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.SourceSansBold
    tabBtn.Parent = TabsFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = tabBtn
    
    tabButtons[tabName] = tabBtn
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -160)
ContentFrame.Position = UDim2.new(0, 10, 0, 120)
ContentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- ScrollFrame
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 8
ScrollFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = ScrollFrame

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -60)
StatusBar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
StatusBar.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 5, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- Control Buttons
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(1, -20, 0, 25)
ControlFrame.Position = UDim2.new(0, 10, 1, -25)
ControlFrame.BackgroundTransparency = 1
ControlFrame.Parent = MainFrame

local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.24, -5, 1, 0)
StartBtn.Position = UDim2.new(0, 0, 0, 0)
StartBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
StartBtn.Text = "▶️ Start"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.TextSize = 13
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.Parent = ControlFrame

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.24, -5, 1, 0)
ClearBtn.Position = UDim2.new(0.25, 5, 0, 0)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ClearBtn.Text = "🗑️ Clear"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.TextSize = 13
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.Parent = ControlFrame

local ExportBtn = Instance.new("TextButton")
ExportBtn.Size = UDim2.new(0.24, -5, 1, 0)
ExportBtn.Position = UDim2.new(0.5, 5, 0, 0)
ExportBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
ExportBtn.Text = "💾 Export"
ExportBtn.TextColor3 = Color3.new(1, 1, 1)
ExportBtn.TextSize = 13
ExportBtn.Font = Enum.Font.SourceSansBold
ExportBtn.Parent = ControlFrame

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(0.24, -5, 1, 0)
DestroyBtn.Position = UDim2.new(0.75, 5, 0, 0)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.Text = "❌ Destroy"
DestroyBtn.TextColor3 = Color3.new(1, 1, 1)
DestroyBtn.TextSize = 13
DestroyBtn.Font = Enum.Font.SourceSansBold
DestroyBtn.Parent = ControlFrame

-- Button corners
for _, btn in pairs({StartBtn, ClearBtn, ExportBtn, DestroyBtn}) do
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
end

-- Data storage
local fishCaughtData = {}
local remoteConnections = {}
local fishDatabase = {}
local statistics = {
    totalCatches = 0,
    lastFish = "",
    heaviestFish = {Name = "", Weight = 0}
}

-- Rarity map berdasarkan ID dari logs
local fishRarityMap = {
    [139] = {Name = "Silver Tuna", Rarity = 1, Color = Color3.fromRGB(150, 150, 150)}, -- Common
    [183] = {Name = "Catfish", Rarity = 2, Color = Color3.fromRGB(100, 200, 100)} -- Uncommon
}

-- Fungsi untuk menambahkan log
local function addLog(text, color, icon)
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, 0, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Entry.Parent = ScrollFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Entry
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.PaddingRight = UDim.new(0, 10)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    Padding.Parent = Entry
    
    local Content = Instance.new("TextLabel")
    Content.Size = UDim2.new(1, -20, 0, 0)
    Content.AutomaticSize = Enum.AutomaticSize.Y
    Content.BackgroundTransparency = 1
    Content.Text = (icon or "") .. " " .. text
    Content.TextColor3 = color or Color3.new(1, 1, 1)
    Content.TextSize = 13
    Content.Font = Enum.Font.SourceSans
    Content.TextXAlignment = Enum.TextXAlignment.Left
    Content.TextYAlignment = Enum.TextYAlignment.Top
    Content.TextWrapped = true
    Content.Parent = Entry
    
    task.wait()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
    ScrollFrame.CanvasPosition = Vector2.new(0, ScrollFrame.CanvasSize.Y.Offset)
end

-- Fungsi clear content
local function clearContent()
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- TAB 1: REAL DATA ANALYSIS
local function showRealData()
    clearContent()
    StatusLabel.Text = "Analyzing Remote Spy Data..."
    
    addLog("=== REAL FISH DATA FROM REMOTE SPY ===", Color3.fromRGB(255, 100, 150), "🔍")
    
    -- Analisis dari logs Remote Spy Anda
    addLog("📊 ANALYSIS OF YOUR REMOTE SPY LOGS:", Color3.fromRGB(255, 255, 0))
    
    -- Key findings dari logs
    addLog("🎯 KEY FINDINGS:", Color3.fromRGB(100, 255, 200))
    
    addLog("1. FishCaught RemoteEvent ditemukan!", Color3.fromRGB(0, 255, 150))
    addLog("   Path: ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught", Color3.fromRGB(150, 200, 255))
    addLog("   Format: [FishName, {Weight: number}]", Color3.fromRGB(150, 200, 255))
    
    addLog("2. Data ikan yang tertangkap:", Color3.fromRGB(0, 255, 150))
    
    -- Data dari logs
    local sampleData = {
        {FishName = "Silver Tuna", Weight = 7, ID = 139, Rarity = 1},
        {FishName = "Silver Tuna", Weight = 7.1, ID = 139, Rarity = 1},
        {FishName = "Silver Tuna", Weight = 6.9, ID = 139, Rarity = 1},
        {FishName = "Catfish", Weight = 45.1, ID = 183, Rarity = 2}
    }
    
    for _, fish in ipairs(sampleData) do
        local rarityInfo = fishRarityMap[fish.ID] or {Color = Color3.fromRGB(200, 200, 200)}
        addLog("   🐟 " .. fish.FishName .. " | Weight: " .. fish.Weight .. " | ID: " .. fish.ID, rarityInfo.Color)
    end
    
    addLog("3. Inventory System ditemukan:", Color3.fromRGB(0, 255, 150))
    addLog("   - Item ID: 139 (Silver Tuna)", Color3.fromRGB(150, 150, 150))
    addLog("   - Item ID: 183 (Catfish)", Color3.fromRGB(100, 200, 100))
    addLog("   - Metadata menyimpan Weight", Color3.fromRGB(150, 200, 255))
    
    addLog("4. Statistics System:", Color3.fromRGB(0, 255, 150))
    addLog("   - FishCaught: 638,711+", Color3.fromRGB(200, 200, 200))
    addLog("   - MonthlyFishCaught: 265,119+", Color3.fromRGB(200, 200, 200))
    addLog("   - Mastery tracking per fish", Color3.fromRGB(200, 200, 200))
    
    addLog("5. Modifiers System:", Color3.fromRGB(0, 255, 150))
    addLog("   - Golden modifier: 5-8", Color3.fromRGB(255, 215, 0))
    addLog("   - Rainbow modifier: 38-40", Color3.fromRGB(255, 50, 255))
    
    -- Contoh kode berdasarkan logs
    addLog("=== EXAMPLE CODE FROM LOGS ===", Color3.fromRGB(255, 200, 100), "💻")
    
    addLog("-- FishCaught event contoh:", Color3.fromRGB(150, 150, 255))
    addLog("local FishCaughtRemote = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught", Color3.fromRGB(200, 200, 200))
    addLog("FishCaughtRemote:FireServer('Silver Tuna', {Weight = 7})", Color3.fromRGB(200, 200, 200))
    
    addLog("-- ObtainedNewFishNotification:", Color3.fromRGB(150, 150, 255))
    addLog("local ObtainedRemote = ReplicatedStorage.Packages._Index.sleitnick_net@0.2.0.net.RE/ObtainedNewFishNotification", Color3.fromRGB(200, 200, 200))
    addLog("ObtainedRemote:FireServer(139, {Weight = 7}, {...}, false)", Color3.fromRGB(200, 200, 200))
    
    addLog("=== RECOMMENDED HOOKING ===", Color3.fromRGB(255, 100, 100), "🎣")
    
    addLog("✅ HOOK ke: FishCaught RemoteEvent", Color3.fromRGB(0, 255, 150))
    addLog("   Format data: [FishName, {Weight: number}]", Color3.fromRGB(150, 150, 150))
    
    addLog("✅ HOOK ke: ObtainedNewFishNotification", Color3.fromRGB(0, 255, 150))
    addLog("   Format data: [ItemID, {Weight: number}, InventoryData, false]", Color3.fromRGB(150, 150, 150))
    
    StatusLabel.Text = "Real data analysis complete"
end

-- TAB 2: REMOTE HOOKS
local function setupRemoteHooks()
    clearContent()
    StatusLabel.Text = "Setting up remote hooks..."
    
    addLog("=== REMOTE EVENT HOOKS ===", Color3.fromRGB(255, 100, 150), "🎣")
    
    -- Cari remote events berdasarkan logs
    local remotesToHook = {
        "FishCaught",
        "ObtainedNewFishNotification", 
        "CaughtFishVisual",
        "FishingStopped"
    }
    
    local netPath = "Packages._Index.sleitnick_net@0.2.0.net.RE/"
    
    for _, remoteName in ipairs(remotesToHook) do
        local remotePath = netPath .. remoteName
        
        -- Coba dapatkan remote
        local current = ReplicatedStorage
        local found = true
        
        for part in remotePath:gmatch("[^/]+") do
            current = current:FindFirstChild(part)
            if not current then
                found = false
                break
            end
        end
        
        if found and current:IsA("RemoteEvent") then
            addLog("🎯 Found: " .. remoteName, Color3.fromRGB(255, 215, 0))
            
            -- Hook ke remote
            local connection = current.OnClientEvent:Connect(function(...)
                local args = {...}
                local timestamp = os.date("%H:%M:%S")
                
                -- Log remote trigger
                addLog("⚡ " .. remoteName .. " at " .. timestamp, Color3.fromRGB(255, 150, 100))
                
                -- Special handling untuk FishCaught
                if remoteName == "FishCaught" then
                    if #args >= 2 then
                        local fishName = args[1]
                        local weightData = args[2]
                        
                        if fishName and type(weightData) == "table" and weightData.Weight then
                            local weight = weightData.Weight
                            statistics.totalCatches = statistics.totalCatches + 1
                            statistics.lastFish = fishName
                            
                            if weight > statistics.heaviestFish.Weight then
                                statistics.heaviestFish = {Name = fishName, Weight = weight}
                            end
                            
                            -- Simpan data
                            table.insert(fishCaughtData, {
                                Time = timestamp,
                                Name = fishName,
                                Weight = weight,
                                Remote = remoteName
                            })
                            
                            -- Tampilkan dengan warna
                            local fishColor = Color3.fromRGB(100, 255, 200)
                            if fishName == "Silver Tuna" then
                                fishColor = Color3.fromRGB(150, 150, 150)
                            elseif fishName == "Catfish" then
                                fishColor = Color3.fromRGB(100, 200, 100)
                            end
                            
                            addLog("   🐟 CAUGHT: " .. fishName .. " (" .. weight .. ")", fishColor)
                            StatusLabel.Text = "Caught: " .. fishName .. " (" .. weight .. ")"
                            
                            -- Print ke console
                            print("=== FISH CAUGHT (REMOTE) ===")
                            print("Time:", timestamp)
                            print("Name:", fishName)
                            print("Weight:", weight)
                            print("==================")
                        end
                    end
                    
                -- Handling untuk ObtainedNewFishNotification
                elseif remoteName == "ObtainedNewFishNotification" then
                    if #args >= 3 then
                        local itemId = args[1]
                        local weightData = args[2]
                        local inventoryData = args[3]
                        
                        if itemId and type(weightData) == "table" and weightData.Weight then
                            local fishName = fishRarityMap[itemId] and fishRarityMap[itemId].Name or "Fish ID: " .. itemId
                            local weight = weightData.Weight
                            
                            addLog("   📦 INVENTORY: " .. fishName .. " (ID: " .. itemId .. ")", Color3.fromRGB(255, 215, 0))
                            addLog("   ⚖️ Weight: " .. weight, Color3.fromRGB(200, 200, 200))
                            
                            if type(inventoryData) == "table" and inventoryData.InventoryItem then
                                addLog("   📝 UUID: " .. (inventoryData.InventoryItem.UUID or "?"), Color3.fromRGB(150, 150, 150))
                            end
                        end
                    end
                end
                
                -- Log semua arguments
                for i, arg in ipairs(args) do
                    local argType = type(arg)
                    if argType == "table" then
                        addLog("   📦 Arg " .. i .. ": [TABLE]", Color3.fromRGB(200, 200, 200))
                        
                        -- Coba extract data dari table
                        for k, v in pairs(arg) do
                            if type(v) == "string" or type(v) == "number" then
                                addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(150, 150, 150))
                            end
                        end
                    else
                        addLog("   📄 Arg " .. i .. ": " .. tostring(arg) .. " (" .. argType .. ")", Color3.fromRGB(200, 200, 200))
                    end
                end
            end)
            
            table.insert(remoteConnections, connection)
            addLog("✅ Hooked to: " .. remoteName, Color3.fromRGB(0, 255, 0))
            
        else
            addLog("❌ Not found: " .. remoteName, Color3.fromRGB(255, 100, 100))
        end
    end
    
    -- Juga hook ke replion remotes untuk stats
    addLog("=== REPLION REMOTES FOR STATS ===", Color3.fromRGB(150, 100, 255), "📊")
    
    local replionRemotes = {
        "Set",
        "Update",
        "ArrayUpdate"
    }
    
    local replionPath = "Packages._Index.ytrev_replion@2.0.0-rc.3.replion.Remotes."
    
    for _, remoteName in ipairs(replionRemotes) do
        local remotePath = replionPath .. remoteName
        
        local current = ReplicatedStorage
        local found = true
        
        for part in remotePath:gmatch("[^.]+") do
            current = current:FindFirstChild(part)
            if not current then
                found = false
                break
            end
        end
        
        if found and current:IsA("RemoteEvent") then
            addLog("📡 Found: " .. remoteName, Color3.fromRGB(150, 200, 255))
            
            local connection = current.OnClientEvent:Connect(function(...)
                local args = {...}
                
                -- Cek jika ini stats update
                if #args >= 2 then
                    local key = args[2]
                    if type(key) == "table" and #key >= 2 then
                        if key[1] == "Statistics" then
                            local statName = key[2]
                            local value = args[3]
                            
                            if statName == "FishCaught" or statName == "MonthlyFishCaught" then
                                addLog("📈 STATS: " .. statName .. " = " .. tostring(value), Color3.fromRGB(100, 255, 200))
                            end
                        end
                    end
                end
            end)
            
            table.insert(remoteConnections, connection)
        end
    end
    
    if #remoteConnections > 0 then
        addLog("✅ Successfully hooked to " .. #remoteConnections .. " remote events", Color3.fromRGB(0, 255, 150))
        addLog("📌 Now fishing will be logged automatically!", Color3.fromRGB(200, 200, 255))
    else
        addLog("❌ No remote events were hooked", Color3.fromRGB(255, 50, 50))
    end
    
    StatusLabel.Text = "Remote hooks setup complete"
end

-- TAB 3: STATS VIEWER
local function showStatsViewer()
    clearContent()
    StatusLabel.Text = "Loading statistics..."
    
    addLog("=== FISHING STATISTICS ===", Color3.fromRGB(255, 100, 150), "📊")
    
    addLog("📈 CURRENT STATS:", Color3.fromRGB(255, 255, 0))
    
    addLog("🎣 Total Catches: " .. statistics.totalCatches, Color3.fromRGB(100, 255, 200))
    addLog("🐟 Last Fish: " .. (statistics.lastFish ~= "" and statistics.lastFish or "None"), Color3.fromRGB(100, 255, 200))
    
    if statistics.heaviestFish.Name ~= "" then
        addLog("🏆 Heaviest Fish: " .. statistics.heaviestFish.Name .. " (" .. statistics.heaviestFish.Weight .. ")", 
               Color3.fromRGB(255, 215, 0))
    else
        addLog("🏆 Heaviest Fish: None yet", Color3.fromRGB(150, 150, 150))
    end
    
    -- Show caught fish history
    if #fishCaughtData > 0 then
        addLog("=== RECENT CATCHES ===", Color3.fromRGB(200, 200, 255), "📋")
        
        local showCount = math.min(10, #fishCaughtData)
        local startIdx = math.max(1, #fishCaughtData - showCount + 1)
        
        for i = #fishCaughtData, startIdx, -1 do
            local catch = fishCaughtData[i]
            if catch then
                local fishColor = Color3.fromRGB(100, 255, 200)
                if catch.Name == "Silver Tuna" then
                    fishColor = Color3.fromRGB(150, 150, 150)
                elseif catch.Name == "Catfish" then
                    fishColor = Color3.fromRGB(100, 200, 100)
                end
                
                addLog(catch.Time .. " - " .. catch.Name .. " (" .. catch.Weight .. ")", fishColor)
            end
        end
    else
        addLog("📭 No catches logged yet", Color3.fromRGB(255, 150, 50))
    end
    
    -- Known fish database dari logs
    addLog("=== KNOWN FISH DATABASE ===", Color3.fromRGB(100, 200, 255), "🐠")
    
    for id, fishInfo in pairs(fishRarityMap) do
        addLog("ID " .. id .. ": " .. fishInfo.Name, fishInfo.Color)
    end
    
    -- Statistics dari logs Remote Spy
    addLog("=== LOGS STATISTICS ===", Color3.fromRGB(255, 200, 100), "📜")
    
    addLog("📊 Total events in logs: 79", Color3.fromRGB(200, 200, 200))
    addLog("🎣 Fish caught in logs: 4", Color3.fromRGB(200, 200, 200))
    addLog("⚡ Events per second: ~15", Color3.fromRGB(200, 200, 200))
    addLog("📦 Inventory updates: 4", Color3.fromRGB(200, 200, 200))
    
    StatusLabel.Text = "Statistics loaded"
end

-- TAB 4: AUTO LOGGER
local function setupAutoLogger()
    clearContent()
    StatusLabel.Text = "Auto logger setup..."
    
    addLog("=== AUTO FISH CATCH LOGGER ===", Color3.fromRGB(255, 100, 150), "🤖")
    
    addLog("🎯 TARGET REMOTES:", Color3.fromRGB(255, 215, 0))
    addLog("1. FishCaught - Primary catch event", Color3.fromRGB(100, 255, 200))
    addLog("2. ObtainedNewFishNotification - Inventory update", Color3.fromRGB(100, 255, 200))
    addLog("3. CaughtFishVisual - Visual effect", Color3.fromRGB(100, 255, 200))
    
    -- Simulasi data dari logs
    addLog("=== SIMULATION MODE ===", Color3.fromRGB(150, 200, 255), "🎮")
    
    local SimulateBtn = Instance.new("TextButton")
    SimulateBtn.Size = UDim2.new(0.8, 0, 0, 40)
    SimulateBtn.Position = UDim2.new(0.1, 0, 0, 120)
    SimulateBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SimulateBtn.Text = "🎣 Simulate Fish Catch"
    SimulateBtn.TextColor3 = Color3.new(1, 1, 1)
    SimulateBtn.TextSize = 14
    SimulateBtn.Font = Enum.Font.SourceSansBold
    SimulateBtn.Parent = ScrollFrame
    
    local SimCorner = Instance.new("UICorner")
    SimCorner.CornerRadius = UDim.new(0, 8)
    SimCorner.Parent = SimulateBtn
    
    SimulateBtn.MouseButton1Click:Connect(function()
        addLog("🤖 SIMULATING FISH CATCH...", Color3.fromRGB(255, 215, 0))
        
        -- Coba temukan remote sebenarnya
        local fishCaughtRemote = nil
        local current = ReplicatedStorage
        
        for part in "Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught":gmatch("[^/]+") do
            current = current:FindFirstChild(part)
            if not current then break end
        end
        
        if current and current:IsA("RemoteEvent") then
            fishCaughtRemote = current
            addLog("✅ Found real FishCaught remote", Color3.fromRGB(0, 255, 150))
        end
        
        -- Simulasi data
        local testFish = {
            {Name = "Silver Tuna", Weight = 7.5, ID = 139},
            {Name = "Catfish", Weight = 42.3, ID = 183},
            {Name = "Test Fish", Weight = 10.0, ID = 999}
        }
        
        local randomFish = testFish[math.random(1, #testFish)]
        
        if fishCaughtRemote then
            -- Fire ke remote sebenarnya
            fishCaughtRemote:FireServer(randomFish.Name, {Weight = randomFish.Weight})
            addLog("🔥 Fired to real remote: " .. randomFish.Name, Color3.fromRGB(255, 100, 100))
        else
            -- Simulasi saja
            addLog("🎣 SIMULATED CATCH: " .. randomFish.Name .. " (" .. randomFish.Weight .. ")", Color3.fromRGB(100, 255, 200))
            
            -- Update stats
            statistics.totalCatches = statistics.totalCatches + 1
            statistics.lastFish = randomFish.Name
            
            if randomFish.Weight > statistics.heaviestFish.Weight then
                statistics.heaviestFish = {Name = randomFish.Name, Weight = randomFish.Weight}
            end
            
            table.insert(fishCaughtData, {
                Time = os.date("%H:%M:%S"),
                Name = randomFish.Name,
                Weight = randomFish.Weight,
                Remote = "Simulation"
            })
            
            StatusLabel.Text = "Simulated: " .. randomFish.Name
        end
    end)
    
    -- Auto-logger settings
    addLog("=== AUTO-LOGGER SETTINGS ===", Color3.fromRGB(200, 200, 255), "⚙️")
    
    addLog("✅ Auto-log all FishCaught events", Color3.fromRGB(0, 255, 150))
    addLog("✅ Auto-log inventory updates", Color3.fromRGB(0, 255, 150))
    addLog("✅ Track statistics automatically", Color3.fromRGB(0, 255, 150))
    addLog("✅ Color-coded by fish type", Color3.fromRGB(0, 255, 150))
    
    addLog("📌 Logger is ready!", Color3.fromRGB(255, 255, 0))
    addLog("Go fishing or click 'Simulate' to test", Color3.fromRGB(200, 200, 255))
    
    StatusLabel.Text = "Auto logger ready"
end

-- Tab switching
local function switchTab(tabName)
    currentTab = tabName
    
    -- Update tab buttons
    for name, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = name == tabName and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(40, 40, 60)
    end
    
    -- Load tab content
    if tabName == "Real Data" then
        showRealData()
    elseif tabName == "Remote Hooks" then
        setupRemoteHooks()
    elseif tabName == "Stats Viewer" then
        showStatsViewer()
    elseif tabName == "Auto Logger" then
        setupAutoLogger()
    end
end

-- Button connections
for tabName, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        switchTab(tabName)
    end)
end

-- Control buttons
StartBtn.MouseButton1Click:Connect(function()
    -- Setup hooks otomatis
    if #remoteConnections == 0 then
        addLog("🔄 Setting up remote hooks...", Color3.fromRGB(255, 255, 0))
        setupRemoteHooks()
    else
        addLog("✅ Hooks already active", Color3.fromRGB(0, 255, 150))
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    clearContent()
    addLog("🗑️ Log cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Log cleared"
end)

ExportBtn.MouseButton1Click:Connect(function()
    addLog("💾 Exporting data to console...", Color3.fromRGB(100, 255, 100))
    
    print("=== FISH REMOTE ANALYZER EXPORT ===")
    print("Based on Remote Spy Logs Analysis")
    print("=================================")
    print("Total catches logged:", statistics.totalCatches)
    print("Last fish:", statistics.lastFish)
    print("Heaviest fish:", statistics.heaviestFish.Name, "(" .. statistics.heaviestFish.Weight .. ")")
    print("Remote connections:", #remoteConnections)
    print("")
    
    -- Export fish database
    print("=== FISH DATABASE ===")
    for id, fishInfo in pairs(fishRarityMap) do
        print("ID " .. id .. ": " .. fishInfo.Name .. " (Rarity: " .. fishInfo.Rarity .. ")")
    end
    
    -- Export caught history
    if #fishCaughtData > 0 then
        print("\n=== CATCH HISTORY ===")
        for i, catch in ipairs(fishCaughtData) do
            print(string.format("%s - %s (Weight: %s, Source: %s)", 
                catch.Time, catch.Name, catch.Weight, catch.Remote))
        end
    end
    
    StatusLabel.Text = "Data exported to console"
end)

DestroyBtn.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying script in 3 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: DESTROYING..."
    
    for i = 3, 1, -1 do
        DestroyBtn.Text = "Destroying in " .. i .. "..."
        task.wait(1)
    end
    
    -- Disconnect semua remote connections
    for _, conn in pairs(remoteConnections) do
        pcall(function() conn:Disconnect() end)
    end
    
    ScreenGui:Destroy()
    
    print("Fish Remote Analyzer destroyed!")
end)

-- Auto-start dengan Real Data tab
switchTab("Real Data")

-- Initial message berdasarkan logs Remote Spy
addLog("✅ Fish Remote Analyzer Loaded!", Color3.fromRGB(255, 100, 150))
addLog("🎣 Primary remote: FishCaught", Color3.fromRGB(200, 200, 255))

-- Auto-setup hooks setelah delay
task.spawn(function()
    task.wait(3)
    if #remoteConnections == 0 then
        addLog("🔧 Auto-setting up remote hooks...", Color3.fromRGB(255, 200, 100))
        setupRemoteHooks()
    end
end)

print("=== FISH REMOTE ANALYZER ===")
print("Based on your Remote Spy logs:")
print("- FishCaught remote: Packages._Index.sleitnick_net@0.2.0.net.RE/FishCaught")
print("- Item ID 139: Silver Tuna (Common)")
print("- Item ID 183: Catfish (Uncommon)")
print("=============================")
