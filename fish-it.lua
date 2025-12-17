-- SIMPLE FISH REMOTE HOOKER
-- Berdasarkan Remote Spy Logs Anda

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI Sederhana
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleFishHooker"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "🎣 Simple Fish Hooker"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- Log Area
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -20, 1, -120)
LogFrame.Position = UDim2.new(0, 10, 0, 70)
LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
LogFrame.BorderSizePixel = 0
LogFrame.ScrollBarThickness = 6
LogFrame.Parent = MainFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.Padding = UDim.new(0, 5)
LogLayout.Parent = LogFrame

-- Control Buttons
local StartBtn = Instance.new("TextButton")
StartBtn.Size = UDim2.new(0.48, -5, 0, 30)
StartBtn.Position = UDim2.new(0, 10, 1, -40)
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
StartBtn.Text = "▶️ Start Hook"
StartBtn.TextColor3 = Color3.new(1, 1, 1)
StartBtn.TextSize = 14
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.Parent = MainFrame

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.48, -5, 0, 30)
ClearBtn.Position = UDim2.new(0.52, 5, 1, -40)
ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
ClearBtn.Text = "🗑️ Clear"
ClearBtn.TextColor3 = Color3.new(1, 1, 1)
ClearBtn.TextSize = 14
ClearBtn.Font = Enum.Font.SourceSansBold
ClearBtn.Parent = MainFrame

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Size = UDim2.new(1, -20, 0, 30)
DestroyBtn.Position = UDim2.new(0, 10, 1, -80)
DestroyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
DestroyBtn.Text = "❌ Destroy Script"
DestroyBtn.TextColor3 = Color3.new(1, 1, 1)
DestroyBtn.TextSize = 14
DestroyBtn.Font = Enum.Font.SourceSansBold
DestroyBtn.Parent = MainFrame

-- Button corners
for _, btn in pairs({StartBtn, ClearBtn, DestroyBtn}) do
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn
end

-- Fungsi tambah log
local function addLog(text, color)
    local Entry = Instance.new("TextLabel")
    Entry.Size = UDim2.new(1, -10, 0, 0)
    Entry.AutomaticSize = Enum.AutomaticSize.Y
    Entry.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.CanvasSize.Y.Offset)
end

-- Data
local remoteConnections = {}
local caughtFish = {}
local totalCatches = 0

-- Cari remote berdasarkan logs Anda
local function findRemote(path)
    local current = ReplicatedStorage
    for part in path:gmatch("[^%.]+") do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- Setup hooks
local function setupHooks()
    addLog("🔍 Looking for remote events...", Color3.fromRGB(255, 255, 0))
    StatusLabel.Text = "Status: Searching remotes..."
    
    -- Coba beberapa path berdasarkan logs Anda
    local remotePaths = {
        -- Dari logs: sleitnick_net package
        "Packages._Index.sleitnick_net.net.RE.FishCaught",
        "Packages._Index.sleitnick_net@0.2.0.net.RE.FishCaught",
        
        -- Coba path langsung
        "Packages.sleitnick_net.RE.FishCaught",
        
        -- Cari di semua tempat
        "RE.FishCaught",
        "RemoteEvents.FishCaught",
        "Fishing.FishCaught"
    }
    
    local foundRemote = nil
    
    for _, path in ipairs(remotePaths) do
        local remote = findRemote(path)
        if remote and remote:IsA("RemoteEvent") then
            foundRemote = remote
            addLog("✅ Found: " .. path, Color3.fromRGB(0, 255, 150))
            break
        end
    end
    
    if not foundRemote then
        -- Coba cari dengan GetDescendants
        addLog("⚠️ Standard paths not found, searching all...", Color3.fromRGB(255, 200, 0))
        
        for _, item in pairs(ReplicatedStorage:GetDescendants()) do
            if item:IsA("RemoteEvent") then
                local name = item.Name:lower()
                if name:find("fish") and name:find("caught") then
                    foundRemote = item
                    addLog("✅ Found by name: " .. item:GetFullName(), Color3.fromRGB(0, 255, 150))
                    break
                end
            end
        end
    end
    
    if not foundRemote then
        addLog("❌ FishCaught remote not found!", Color3.fromRGB(255, 50, 50))
        StatusLabel.Text = "Status: Remote not found"
        return false
    end
    
    -- Hook ke remote
    addLog("🎣 Hooking to FishCaught remote...", Color3.fromRGB(255, 215, 0))
    
    local connection = foundRemote.OnClientEvent:Connect(function(...)
        local args = {...}
        local timestamp = os.date("%H:%M:%S")
        
        totalCatches = totalCatches + 1
        
        -- Log event
        addLog("⚡ FishCaught at " .. timestamp, Color3.fromRGB(255, 100, 100))
        
        -- Analyze arguments
        for i, arg in ipairs(args) do
            if type(arg) == "string" then
                -- Mungkin nama ikan
                if #arg > 2 and not arg:match("^%d+$") then
                    addLog("   🐟 Fish: " .. arg, Color3.fromRGB(100, 255, 200))
                    
                    -- Simpan data
                    table.insert(caughtFish, {
                        time = timestamp,
                        name = arg,
                        index = totalCatches
                    })
                    
                    StatusLabel.Text = "Caught: " .. arg .. " (#" .. totalCatches .. ")"
                end
            elseif type(arg) == "table" then
                -- Mungkin data weight
                addLog("   📦 Data table:", Color3.fromRGB(200, 200, 200))
                
                for k, v in pairs(arg) do
                    if type(v) == "string" or type(v) == "number" then
                        addLog("     " .. k .. " = " .. tostring(v), Color3.fromRGB(150, 150, 150))
                    end
                end
                
                if arg.Weight then
                    addLog("   ⚖️ Weight: " .. tostring(arg.Weight), Color3.fromRGB(100, 255, 200))
                end
            end
        end
        
        -- Print ke console
        print("[FISH CAUGHT] #" .. totalCatches .. " at " .. timestamp)
    end)
    
    table.insert(remoteConnections, connection)
    
    -- Juga cari ObtainedNewFishNotification
    addLog("🔍 Looking for ObtainedNewFishNotification...", Color3.fromRGB(200, 200, 255))
    
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("RemoteEvent") and item.Name == "ObtainedNewFishNotification" then
            local conn = item.OnClientEvent:Connect(function(...)
                local args = {...}
                addLog("📦 ObtainedNewFishNotification", Color3.fromRGB(255, 150, 100))
                
                -- Cek untuk fish data
                if #args >= 2 then
                    local itemId = args[1]
                    local weightData = args[2]
                    
                    if type(weightData) == "table" and weightData.Weight then
                        addLog("   🎣 Fish ID: " .. tostring(itemId), Color3.fromRGB(100, 255, 200))
                        addLog("   ⚖️ Weight: " .. tostring(weightData.Weight), Color3.fromRGB(100, 255, 200))
                    end
                end
            end)
            
            table.insert(remoteConnections, conn)
            addLog("✅ Hooked to ObtainedNewFishNotification", Color3.fromRGB(0, 255, 0))
            break
        end
    end
    
    addLog("✅ Successfully setup hooks!", Color3.fromRGB(0, 255, 150))
    addLog("📌 Total catches: 0", Color3.fromRGB(200, 200, 255))
    addLog("🎣 Start fishing to see logs!", Color3.fromRGB(200, 200, 255))
    
    StatusLabel.Text = "Status: Ready - Hooks active"
    return true
end

-- Button actions
StartBtn.MouseButton1Click:Connect(function()
    addLog("🔄 Setting up hooks...", Color3.fromRGB(255, 255, 0))
    setupHooks()
end)

ClearBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(LogFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    addLog("🗑️ Logs cleared!", Color3.fromRGB(255, 100, 100))
    StatusLabel.Text = "Status: Logs cleared"
end)

DestroyBtn.MouseButton1Click:Connect(function()
    addLog("⚠️ Destroying in 2 seconds...", Color3.fromRGB(255, 50, 50))
    StatusLabel.Text = "Status: Destroying..."
    
    for i = 2, 1, -1 do
        DestroyBtn.Text = "Destroying in " .. i
        task.wait(1)
    end
    
    -- Disconnect semua
    for _, conn in pairs(remoteConnections) do
        pcall(function() conn:Disconnect() end)
    end
    
    ScreenGui:Destroy()
    print("Simple Fish Hooker destroyed!")
end)

-- Auto-start
addLog("✅ Simple Fish Hooker Loaded!", Color3.fromRGB(0, 255, 200))
addLog("📌 Click 'Start Hook' to begin", Color3.fromRGB(200, 200, 255))
addLog("🎣 Based on your Remote Spy logs", Color3.fromRGB(200, 200, 255))

-- Auto-start setelah delay
task.spawn(function()
    task.wait(2)
    addLog("🔧 Auto-setting up hooks...", Color3.fromRGB(255, 200, 100))
    setupHooks()
end)

print("Simple Fish Hooker Loaded!")
