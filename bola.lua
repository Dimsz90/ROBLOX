-- SIMPLE FISH CAUGHT DETECTOR
-- Hook ke FishCaught function untuk mendapatkan data ikan

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleFishLogger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🎣 Simple Fish Logger"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Log Area
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 1, -100)
LogFrame.Position = UDim2.new(0, 10, 0, 40)
LogFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
LogFrame.ScrollBarThickness = 6
LogFrame.Parent = MainFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Padding = UDim.new(0, 5)
LogLayout.Parent = LogFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 1, -50)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- DESTROY BUTTON
local DestroyButton = Instance.new("TextButton")
DestroyButton.Size = UDim2.new(0.5, -10, 0, 25)
DestroyButton.Position = UDim2.new(0.5, 5, 1, -25)
DestroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyButton.Text = "❌ Destroy Script"
DestroyButton.TextColor3 = Color3.new(1, 1, 1)
DestroyButton.TextSize = 14
DestroyButton.Font = Enum.Font.SourceSansBold
DestroyButton.Parent = MainFrame

local DestroyCorner = Instance.new("UICorner")
DestroyCorner.CornerRadius = UDim.new(0, 6)
DestroyCorner.Parent = DestroyButton

-- Fungsi tambah log
local function addLog(text, color)
    local Entry = Instance.new("TextLabel")
    Entry.Size = UDim2.new(1, -10, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Entry.Text = text
    Entry.TextColor3 = color or Color3.new(1, 1, 1)
    Entry.TextSize = 13
    Entry.Font = Enum.Font.SourceSans
    Entry.TextXAlignment = Enum.TextXAlignment.Left
    Entry.TextYAlignment = Enum.TextYAlignment.Top
    Entry.TextWrapped = true
    Entry.Parent = LogFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Entry
    
    task.wait()
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 10)
end

-- DESTROY FUNCTION
DestroyButton.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying script in 2 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: DESTROYING..."
    
    for i = 2, 1, -1 do
        DestroyButton.Text = "Destroying in " .. i .. "..."
        task.wait(1)
    end
    
    -- Restore original function jika ada
    if originalFishCaught then
        pcall(function()
            fishingController.FishCaught = originalFishCaught
        end)
    end
    
    ScreenGui:Destroy()
    print("Simple Fish Logger Destroyed!")
end)

-- Map rarity
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
    [1] = Color3.fromRGB(150, 150, 150),
    [2] = Color3.fromRGB(100, 200, 100),
    [3] = Color3.fromRGB(100, 150, 255),
    [4] = Color3.fromRGB(200, 100, 255),
    [5] = Color3.fromRGB(255, 215, 0),
    [6] = Color3.fromRGB(255, 100, 100),
    [7] = Color3.fromRGB(255, 50, 255)
}

-- Cari FishingController
local fishingController = nil
local originalFishCaught = nil

addLog("🔍 Mencari FishingController...", Color3.fromRGB(255, 255, 0))
StatusLabel.Text = "Status: Looking for FishingController..."

-- Coba beberapa lokasi
local possiblePaths = {
    "Controllers.ClassicGroupFishingController",
    "Fishing.FishingController",
    "FishingController",
    "Modules.FishingController",
    "GameModules.FishingController"
}

for _, path in pairs(possiblePaths) do
    local module = ReplicatedStorage
    local success = true
    
    for part in path:gmatch("[^.]+") do
        module = module:FindFirstChild(part)
        if not module then
            success = false
            break
        end
    end
    
    if success and module:IsA("ModuleScript") then
        addLog("✅ Found: " .. path, Color3.fromRGB(0, 255, 150))
        
        local success, data = pcall(function()
            return require(module)
        end)
        
        if success then
            fishingController = data
            addLog("📦 Successfully loaded FishingController", Color3.fromRGB(0, 255, 0))
            break
        else
            addLog("❌ Failed to load: " .. tostring(data), Color3.fromRGB(255, 50, 50))
        end
    end
end

if not fishingController then
    addLog("❌ FishingController tidak ditemukan!", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: ERROR - Controller not found"
    return
end

-- Cek jika FishCaught ada
addLog("🔍 Checking for FishCaught function...", Color3.fromRGB(255, 200, 0))

if fishingController.FishCaught and type(fishingController.FishCaught) == "function" then
    addLog("🎯 FOUND FishCaught function!", Color3.fromRGB(0, 255, 150))
    
    -- Simpan fungsi asli
    originalFishCaught = fishingController.FishCaught
    
    -- Hook ke FishCaught
    fishingController.FishCaught = function(...)
        local args = {...}
        
        -- Panggil fungsi asli dulu (jaga-jaga)
        local result = originalFishCaught(...)
        
        -- Log bahwa FishCaught dipanggil
        addLog("⚡ FishCaught TRIGGERED!", Color3.fromRGB(255, 100, 100))
        
        -- Analisis argumen
        for i, arg in ipairs(args) do
            local argType = type(arg)
            addLog("   Arg " .. i .. ": " .. argType, Color3.fromRGB(200, 200, 200))
            
            if argType == "table" then
                -- INI YANG PENTING: Extract fish data dari table
                addLog("   📦 Table detected - checking for fish data...", Color3.fromRGB(150, 200, 255))
                
                -- Cari semua key di table
                local fishData = {}
                for key, value in pairs(arg) do
                    local valueType = type(value)
                    
                    if valueType == "string" or valueType == "number" then
                        -- Simpan data penting
                        fishData[key] = value
                        addLog("     " .. key .. " = " .. tostring(value), Color3.fromRGB(100, 255, 200))
                    elseif valueType == "table" then
                        addLog("     " .. key .. ": [nested table]", Color3.fromRGB(150, 150, 150))
                    end
                end
                
                -- Cek jika ini fish data
                if fishData.Name or fishData.FishName or fishData.name then
                    local fishName = fishData.Name or fishData.FishName or fishData.name or "Unknown Fish"
                    local rarityNum = fishData.Rarity or fishData.rarity or fishData.Tier or fishData.tier
                    local weight = fishData.Weight or fishData.weight or fishData.Size or fishData.size
                    local mutation = fishData.Mutation or fishData.mutation or fishData.Shiny or fishData.shiny
                    
                    -- Convert rarity
                    local rarityName = "Unknown"
                    if rarityNum then
                        rarityName = rarityMap[tonumber(rarityNum)] or "Rarity " .. tostring(rarityNum)
                    end
                    
                    local rarityColor = rarityColors[tonumber(rarityNum)] or Color3.fromRGB(200, 200, 200)
                    
                    -- Log fish caught
                    addLog("🎣🎣🎣 FISH CAUGHT! 🎣🎣🎣", rarityColor)
                    addLog("   Name: " .. fishName, rarityColor)
                    addLog("   Rarity: " .. rarityName .. " (" .. tostring(rarityNum or "?") .. ")", rarityColor)
                    
                    if weight then
                        addLog("   Weight: " .. tostring(weight), rarityColor)
                    end
                    
                    if mutation then
                        addLog("   Mutation: " .. tostring(mutation), rarityColor)
                    end
                    
                    addLog("   Time: " .. os.date("%H:%M:%S"), rarityColor)
                    
                    -- Print ke console juga
                    print("=== FISH CAUGHT ===")
                    print("Name:", fishName)
                    print("Rarity:", rarityName, "(" .. tostring(rarityNum or "?") .. ")")
                    if weight then print("Weight:", weight) end
                    if mutation then print("Mutation:", mutation) end
                    print("==================")
                    
                    -- Update status
                    StatusLabel.Text = "Status: Caught " .. fishName
                end
                
            elseif argType == "string" then
                -- Mungkin nama ikan langsung?
                if #arg > 2 and not arg:match("^%d+$") then -- Bukan angka
                    addLog("   🐟 Possible fish name: " .. arg, Color3.fromRGB(255, 215, 0))
                end
                
            elseif argType == "number" then
                -- Mungkin rarity atau weight?
                if arg >= 1 and arg <= 7 then
                    addLog("   ⭐ Possible rarity: " .. arg .. " (" .. (rarityMap[arg] or "Unknown") .. ")", 
                           Color3.fromRGB(200, 255, 200))
                elseif arg > 10 then
                    addLog("   ⚖️ Possible weight: " .. arg, Color3.fromRGB(200, 200, 255))
                end
            end
        end
        
        return result
    end
    
    addLog("✅ Successfully hooked to FishCaught!", Color3.fromRGB(0, 255, 0))
    addLog("📌 Now go fishing! All catches will be logged.", Color3.fromRGB(200, 200, 255))
    StatusLabel.Text = "Status: Ready - Hooked to FishCaught"
    
else
    addLog("❌ FishCaught function not found in controller", Color3.fromRGB(255, 50, 50))
    
    -- Coba cari fungsi lain yang mungkin
    addLog("🔍 Looking for other catch-related functions...", Color3.fromRGB(255, 200, 0))
    
    for key, value in pairs(fishingController) do
        if type(value) == "function" then
            local keyLower = key:lower()
            if keyLower:find("catch") or keyLower:find("fish") then
                addLog("🎯 Found: " .. key, Color3.fromRGB(255, 215, 0))
                
                -- Coba hook ke fungsi ini juga
                local originalFunc = value
                fishingController[key] = function(...)
                    local args = {...}
                    
                    addLog("⚡ " .. key .. " triggered!", Color3.fromRGB(255, 150, 100))
                    
                    -- Check args for fish data
                    for i, arg in ipairs(args) do
                        if type(arg) == "table" then
                            if arg.Name or arg.FishName then
                                local fishName = arg.Name or arg.FishName
                                addLog("🎣 Found fish in " .. key .. ": " .. fishName, Color3.fromRGB(0, 255, 150))
                            end
                        end
                    end
                    
                    return originalFunc(...)
                end
                
                addLog("✅ Hooked to " .. key, Color3.fromRGB(0, 255, 0))
            end
        end
    end
end

-- Test: Coba panggil GetCurrentGUID jika ada
if fishingController.GetCurrentGUID and type(fishingController.GetCurrentGUID) == "function" then
    addLog("🔑 GetCurrentGUID available", Color3.fromRGB(150, 150, 255))
    
    -- Coba get GUID
    local success, guid = pcall(fishingController.GetCurrentGUID)
    if success then
        addLog("   Current GUID: " .. tostring(guid), Color3.fromRGB(100, 255, 200))
    end
end

-- Setup auto-check untuk fishing status
task.spawn(function()
    while true do
        task.wait(5)
        
        if fishingController.OnCooldown ~= nil then
            local isOnCooldown = fishingController.OnCooldown
            if isOnCooldown then
                StatusLabel.Text = "Status: On Cooldown"
            else
                StatusLabel.Text = "Status: Ready to fish"
            end
        end
    end
end)

addLog("✅ Simple Fish Logger Ready!", Color3.fromRGB(0, 255, 0))
print("Simple Fish Logger Activated - Hooked to FishCaught!")
