-- FISH DATA LOGGER - Advanced Catch Tracker
-- Menangkap data lengkap ikan setiap caught

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Tunggu sampai Fishing module tersedia
local Fishing
local FishingController

-- Fungsi untuk mendapatkan module dengan retry
local function getFishingModule()
    repeat
        Fishing = ReplicatedStorage:FindFirstChild("Fishing")
        if Fishing then
            FishingController = require(Fishing:WaitForChild("FishingController"))
            return true
        end
        wait(1)
    until false
end

-- Setup GUI (gunakan GUI yang sudah ada atau buat yang baru)
local function setupEnhancedLogger()
    -- GUI Setup mirip dengan yang sebelumnya
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishDataLogger"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 450, 0, 250)
    MainFrame.Position = UDim2.new(0, 470, 0, 100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 30)
    Title.Position = UDim2.new(0, 10, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = "🎣 FISH CATCH LOGGER"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame
    
    -- Stats Display
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, -20, 0, 60)
    StatsFrame.Position = UDim2.new(0, 10, 0, 40)
    StatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    StatsFrame.Parent = MainFrame
    
    local TotalCaught = Instance.new("TextLabel")
    TotalCaught.Size = UDim2.new(0.48, 0, 0, 25)
    TotalCaught.Position = UDim2.new(0, 5, 0, 5)
    TotalCaught.BackgroundTransparency = 1
    TotalCaught.Text = "Total: 0"
    TotalCaught.TextColor3 = Color3.fromRGB(200, 200, 200)
    TotalCaught.TextSize = 14
    TotalCaught.Font = Enum.Font.SourceSansBold
    TotalCaught.Parent = StatsFrame
    
    local LastFish = Instance.new("TextLabel")
    LastFish.Size = UDim2.new(0.48, 0, 0, 25)
    LastFish.Position = UDim2.new(0.52, 0, 0, 5)
    LastFish.BackgroundTransparency = 1
    LastFish.Text = "Last: None"
    LastFish.TextColor3 = Color3.fromRGB(200, 200, 200)
    LastFish.TextSize = 14
    LastFish.Font = Enum.Font.SourceSansBold
    LastFish.Parent = StatsFrame
    
    local BestFish = Instance.new("TextLabel")
    BestFish.Size = UDim2.new(1, -10, 0, 25)
    BestFish.Position = UDim2.new(0, 5, 0, 30)
    BestFish.BackgroundTransparency = 1
    BestFish.Text = "Best: None"
    BestFish.TextColor3 = Color3.fromRGB(200, 200, 200)
    BestFish.TextSize = 14
    BestFish.Font = Enum.Font.SourceSansBold
    BestFish.Parent = StatsFrame
    
    -- Log List
    local LogScroll = Instance.new("ScrollingFrame")
    LogScroll.Size = UDim2.new(1, -20, 1, -130)
    LogScroll.Position = UDim2.new(0, 10, 0, 105)
    LogScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    LogScroll.ScrollBarThickness = 6
    LogScroll.Parent = MainFrame
    
    local LogLayout = Instance.new("UIListLayout")
    LogLayout.Padding = UDim.new(0, 3)
    LogLayout.Parent = LogScroll
    
    return {
        ScreenGui = ScreenGui,
        TotalCaught = TotalCaught,
        LastFish = LastFish,
        BestFish = BestFish,
        LogScroll = LogScroll
    }
end

-- Data tracking
local fishLog = {}
local totalCaught = 0
local bestWeight = 0
local bestFishName = ""
local gui = setupEnhancedLogger()

-- Fungsi untuk menambahkan log
local function addCatchLog(fishData, color)
    totalCaught = totalCaught + 1
    
    -- Update stats
    gui.TotalCaught.Text = "Total: " .. totalCaught
    gui.LastFish.Text = "Last: " .. fishData.Name
    
    -- Check for best fish
    local weight = fishData.Weight or 0
    if weight > bestWeight then
        bestWeight = weight
        bestFishName = fishData.Name
        gui.BestFish.Text = "Best: " .. bestFishName .. " (" .. weight .. "kg)"
    end
    
    -- Create log entry
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, -10, 0, 35)
    Entry.BackgroundColor3 = color or Color3.fromRGB(20, 20, 30)
    Entry.Parent = gui.LogScroll
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    NameLabel.Position = UDim2.new(0, 5, 0, 5)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = fishData.Name
    NameLabel.TextColor3 = Color3.new(1, 1, 1)
    NameLabel.TextSize = 12
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Entry
    
    local DetailsLabel = Instance.new("TextLabel")
    DetailsLabel.Size = UDim2.new(0.38, 0, 0.5, 0)
    DetailsLabel.Position = UDim2.new(0.6, 5, 0, 5)
    DetailsLabel.BackgroundTransparency = 1
    DetailsLabel.Text = fishData.Rarity .. " | " .. (fishData.Weight or "?") .. "kg"
    DetailsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    DetailsLabel.TextSize = 11
    DetailsLabel.TextXAlignment = Enum.TextXAlignment.Right
    DetailsLabel.Parent = Entry
    
    local MutationLabel = Instance.new("TextLabel")
    MutationLabel.Size = UDim2.new(1, -10, 0.5, 0)
    MutationLabel.Position = UDim2.new(0, 5, 0.5, 0)
    MutationLabel.BackgroundTransparency = 1
    MutationLabel.Text = "Mutation: " .. (fishData.Mutation or "None")
    MutationLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    MutationLabel.TextSize = 11
    MutationLabel.TextXAlignment = Enum.TextXAlignment.Left
    MutationLabel.Parent = Entry
    
    -- Update scroll size
    task.wait()
    gui.LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 10)
    gui.LogScroll.CanvasPosition = Vector2.new(0, gui.LogScroll.CanvasSize.Y.Offset)
    
    -- Simpan ke log
    table.insert(fishLog, {
        Time = os.date("%H:%M:%S"),
        Data = fishData
    })
    
    -- Print ke console juga
    print(string.format("[FISH CAUGHT] %s | Rarity: %s | Weight: %skg | Mutation: %s | Time: %s",
        fishData.Name, fishData.Rarity, tostring(fishData.Weight), fishData.Mutation or "None", os.date("%H:%M:%S")))
end

-- Warna berdasarkan rarity
local rarityColors = {
    Common = Color3.fromRGB(150, 150, 150),
    Uncommon = Color3.fromRGB(100, 200, 100),
    Rare = Color3.fromRGB(100, 150, 255),
    Epic = Color3.fromRGB(200, 100, 255),
    Legendary = Color3.fromRGB(255, 215, 0),
    Mythical = Color3.fromRGB(255, 100, 100)
}

-- FUNGSI UTAMA: Hook FishCaught event
local function setupFishCaughtHook()
    getFishingModule() -- Pastikan module sudah di-load
    
    print("[FISH LOGGER] Initializing...")
    
    -- Method 1: Hook ke FishCaught event jika ada
    if FishingController.FishCaught then
        print("[FISH LOGGER] Hooking to FishCaught event...")
        
        -- Simpan fungsi asli
        local originalFishCaught = FishingController.FishCaught
        
        -- Override fungsi
        FishingController.FishCaught = function(fishData, ...)
            -- Log fish data
            if fishData and type(fishData) == "table" then
                -- Format data yang diterima
                local formattedData = {
                    Name = fishData.Name or fishData.FishName or "Unknown Fish",
                    Rarity = fishData.Rarity or fishData.Tier or "Common",
                    Weight = fishData.Weight or fishData.Size or fishData.Pounds,
                    Mutation = fishData.Mutation or fishData.Shiny or fishData.Variant or "None",
                    GUID = fishData.GUID or fishData.Id,
                    RawData = fishData -- Simpan data mentah
                }
                
                -- Get color berdasarkan rarity
                local color = rarityColors[formattedData.Rarity] or Color3.fromRGB(100, 200, 100)
                
                -- Tambah ke log
                addCatchLog(formattedData, color)
                
                -- Also add to your existing Fish Explorer GUI
                local explorerGui = player.PlayerGui:FindFirstChild("FishExplorer")
                if explorerGui then
                    local mainFrame = explorerGui:FindFirstChild("MainFrame")
                    if mainFrame then
                        local statusLabel = mainFrame:FindFirstChild("StatusLabel")
                        if statusLabel then
                            statusLabel.Text = string.format("Status: Caught %s (%s)", 
                                formattedData.Name, formattedData.Rarity)
                        end
                    end
                end
            end
            
            -- Panggil fungsi asli
            return originalFishCaught(fishData, ...)
        end
        
        print("[FISH LOGGER] Successfully hooked to FishCaught!")
    else
        print("[FISH LOGGER] FishCaught event not found, trying alternative methods...")
    end
    
    -- Method 2: Connect langsung ke RemoteEvent jika ada
    local fishingFolder = ReplicatedStorage:FindFirstChild("Fishing")
    if fishingFolder then
        for _, item in pairs(fishingFolder:GetChildren()) do
            if item:IsA("RemoteEvent") and (item.Name:find("Fish") or item.Name:find("Catch")) then
                print("[FISH LOGGER] Found RemoteEvent: " .. item.Name)
                
                -- Hook ke OnClientEvent
                item.OnClientEvent:Connect(function(fishData)
                    print("[FISH LOGGER] RemoteEvent triggered:", fishData)
                    
                    if fishData then
                        local formattedData = {
                            Name = fishData.Name or "Unknown",
                            Rarity = fishData.Rarity or "Common",
                            Weight = fishData.Weight or 0,
                            Mutation = fishData.Mutation or "None"
                        }
                        
                        local color = rarityColors[formattedData.Rarity] or Color3.fromRGB(100, 200, 100)
                        addCatchLog(formattedData, color)
                    end
                end)
            end
        end
    end
    
    -- Method 3: Monitor GetCurrentGUID untuk tracking
    task.spawn(function()
        while true do
            wait(2)
            
            -- Coba panggil GetCurrentGUID jika ada
            if FishingController.GetCurrentGUID then
                local success, currentGUID = pcall(FishingController.GetCurrentGUID)
                if success and currentGUID then
                    -- Track GUID untuk mengetahui ikan yang sedang di-hook
                    print("[FISH LOGGER] Current GUID:", currentGUID)
                end
            end
        end
    end)
    
    -- Method 4: Monitor attribute changes pada player
    player:GetAttributeChangedSignal("LastCaughtFish"):Connect(function()
        local fish = player:GetAttribute("LastCaughtFish")
        if fish then
            print("[FISH LOGGER] Attribute changed:", fish)
        end
    end)
    
    print("[FISH LOGGER] Setup complete! Ready to log catches.")
end

-- Export fungsi untuk memulai
return {
    Start = setupFishCaughtHook,
    GetLog = function() return fishLog end,
    GetStats = function() 
        return {
            Total = totalCaught,
            BestWeight = bestWeight,
            BestFish = bestFishName,
            Logs = fishLog
        }
    end
}
