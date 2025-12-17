--[[
    ╔═══════════════════════════════════════════════╗
    ║   Advanced Dex Explorer                      ║
    ║   - Full object inspection                   ║
    ║   - Property viewer                          ║
    ║   - RemoteEvent spy                          ║
    ║   - Export to clipboard                      ║
    ╚═══════════════════════════════════════════════╝
]]

if getgenv().AdvancedDex then return end
getgenv().AdvancedDex = true

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- State
local currentPath = {}
local currentObject = game
local spyingEvents = {}
local eventLogs = {}

-- ============================================
-- UI CREATION
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedDexExplorer"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)
if not screenGui.Parent then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 850, 0, 600)
mainFrame.Position = UDim2.new(0.5, -425, 0.5, -300)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "🔍 Advanced Dex Explorer"
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -38, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -78, 0, 2.5)
minBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0
minBtn.Parent = header

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 6)
minBtnCorner.Parent = minBtn

-- Tab Bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -10, 0, 35)
tabBar.Position = UDim2.new(0, 5, 0, 45)
tabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 6)
tabBarCorner.Parent = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 3)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabBar

-- Content Container
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -10, 1, -90)
contentFrame.Position = UDim2.new(0, 5, 0, 85)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- ============================================
-- TAB SYSTEM
-- ============================================
local tabs = {}
local activeTab = nil

local function createTab(name, icon, onActivate)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 150, 1, -6)
    tab.Position = UDim2.new(0, 0, 0, 3)
    tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tab.TextColor3 = Color3.fromRGB(180, 180, 200)
    tab.Text = icon .. " " .. name
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 12
    tab.BorderSizePixel = 0
    tab.Parent = tabBar
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = contentFrame
    
    tab.MouseButton1Click:Connect(function()
        -- Deactivate all tabs
        for _, t in pairs(tabs) do
            t.tab.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            t.tab.TextColor3 = Color3.fromRGB(180, 180, 200)
            t.content.Visible = false
        end
        
        -- Activate this tab
        tab.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
        activeTab = {tab = tab, content = content, activate = onActivate}
        
        if onActivate then onActivate() end
    end)
    
    tabs[name] = {tab = tab, content = content, activate = onActivate}
    return content
end

-- ============================================
-- TAB 1: EXPLORER
-- ============================================
local explorerContent = createTab("Explorer", "📁", function()
    updateExplorer(currentObject)
end)

-- Path bar
local pathBar = Instance.new("Frame")
pathBar.Size = UDim2.new(1, 0, 0, 30)
pathBar.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
pathBar.BorderSizePixel = 0
pathBar.Parent = explorerContent

local pathCorner = Instance.new("UICorner")
pathCorner.CornerRadius = UDim.new(0, 6)
pathCorner.Parent = pathBar

local pathLabel = Instance.new("TextLabel")
pathLabel.Size = UDim2.new(1, -150, 1, 0)
pathLabel.Position = UDim2.new(0, 10, 0, 0)
pathLabel.BackgroundTransparency = 1
pathLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
pathLabel.Font = Enum.Font.Code
pathLabel.TextSize = 11
pathLabel.TextXAlignment = Enum.TextXAlignment.Left
pathLabel.Text = "game"
pathLabel.Parent = pathBar

-- Export current view button
local exportViewBtn = Instance.new("TextButton")
exportViewBtn.Size = UDim2.new(0, 70, 0, 24)
exportViewBtn.Position = UDim2.new(1, -140, 0, 3)
exportViewBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
exportViewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportViewBtn.Text = "📋 Copy"
exportViewBtn.Font = Enum.Font.Gotham
exportViewBtn.TextSize = 10
exportViewBtn.BorderSizePixel = 0
exportViewBtn.Parent = pathBar

local exportViewCorner = Instance.new("UICorner")
exportViewCorner.CornerRadius = UDim.new(0, 4)
exportViewCorner.Parent = exportViewBtn

-- Back button
local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.new(0, 60, 0, 24)
backBtn.Position = UDim2.new(1, -65, 0, 3)
backBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backBtn.Text = "← Back"
backBtn.Font = Enum.Font.Gotham
backBtn.TextSize = 10
backBtn.BorderSizePixel = 0
backBtn.Parent = pathBar

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 4)
backCorner.Parent = backBtn

-- Explorer list
local explorerList = Instance.new("ScrollingFrame")
explorerList.Size = UDim2.new(0.5, -5, 1, -35)
explorerList.Position = UDim2.new(0, 0, 0, 35)
explorerList.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
explorerList.BorderSizePixel = 0
explorerList.ScrollBarThickness = 6
explorerList.CanvasSize = UDim2.new(0, 0, 0, 0)
explorerList.Parent = explorerContent

local explorerCorner = Instance.new("UICorner")
explorerCorner.CornerRadius = UDim.new(0, 6)
explorerCorner.Parent = explorerList

local explorerLayout = Instance.new("UIListLayout")
explorerLayout.Padding = UDim.new(0, 2)
explorerLayout.SortOrder = Enum.SortOrder.Name
explorerLayout.Parent = explorerList

-- Properties panel
local propertiesPanel = Instance.new("ScrollingFrame")
propertiesPanel.Size = UDim2.new(0.5, -5, 1, -35)
propertiesPanel.Position = UDim2.new(0.5, 5, 0, 35)
propertiesPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
propertiesPanel.BorderSizePixel = 0
propertiesPanel.ScrollBarThickness = 6
propertiesPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
propertiesPanel.Parent = explorerContent

local propCorner = Instance.new("UICorner")
propCorner.CornerRadius = UDim.new(0, 6)
propCorner.Parent = propertiesPanel

local propLayout = Instance.new("UIListLayout")
propLayout.Padding = UDim.new(0, 2)
propLayout.SortOrder = Enum.SortOrder.Name
propLayout.Parent = propertiesPanel

-- ============================================
-- EXPLORER FUNCTIONS
-- ============================================
local function getIcon(obj)
    if obj:IsA("Folder") then return "📂"
    elseif obj:IsA("RemoteEvent") then return "📡"
    elseif obj:IsA("RemoteFunction") then return "⚡"
    elseif obj:IsA("ModuleScript") then return "📜"
    elseif obj:IsA("LocalScript") then return "📝"
    elseif obj:IsA("Script") then return "📄"
    elseif obj:IsA("Model") then return "🎭"
    elseif obj:IsA("Part") then return "🟦"
    elseif obj:IsA("MeshPart") then return "🎨"
    elseif obj:IsA("Tool") then return "🔧"
    elseif obj:IsA("Sound") then return "🔊"
    elseif obj:IsA("ParticleEmitter") then return "✨"
    elseif obj:IsA("Light") then return "💡"
    elseif obj:IsA("ScreenGui") then return "📱"
    else return "📦"
    end
end

local selectedObject = nil

function updateExplorer(obj)
    currentObject = obj
    
    -- Update path
    local path = obj:GetFullName()
    pathLabel.Text = path
    
    -- Clear explorer
    for _, child in pairs(explorerList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add children
    local children = obj:GetChildren()
    table.sort(children, function(a, b)
        return a.Name < b.Name
    end)
    
    for _, child in pairs(children) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, -8, 0, 25)
        entry.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        entry.BorderSizePixel = 0
        entry.Parent = explorerList
        
        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 4)
        entryCorner.Parent = entry
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.TextColor3 = Color3.fromRGB(220, 220, 240)
        btn.Text = getIcon(child) .. " " .. child.Name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.Parent = entry
        
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 8)
        padding.Parent = btn
        
        -- Click to navigate
        btn.MouseButton1Click:Connect(function()
            table.insert(currentPath, obj)
            updateExplorer(child)
            showProperties(child)
        end)
        
        -- Right click for options
        btn.MouseButton2Click:Connect(function()
            -- Reset all entries
            for _, e in pairs(explorerList:GetChildren()) do
                if e:IsA("Frame") then
                    e.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
                end
            end
            
            showProperties(child)
            selectedObject = child
            entry.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        end)
    end
    
    explorerList.CanvasSize = UDim2.new(0, 0, 0, explorerLayout.AbsoluteContentSize.Y + 5)
end

function showProperties(obj)
    selectedObject = obj
    
    -- Clear properties
    for _, child in pairs(propertiesPanel:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Title with copy button
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -8, 0, 35)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = propertiesPanel
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 4)
    titleCorner.Parent = titleFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = "Properties: " .. obj.Name
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame
    
    -- Copy properties button
    local copyPropBtn = Instance.new("TextButton")
    copyPropBtn.Size = UDim2.new(0, 70, 0, 28)
    copyPropBtn.Position = UDim2.new(1, -73, 0, 3.5)
    copyPropBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    copyPropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyPropBtn.Text = "📋 Copy"
    copyPropBtn.Font = Enum.Font.Gotham
    copyPropBtn.TextSize = 10
    copyPropBtn.BorderSizePixel = 0
    copyPropBtn.Parent = titleFrame
    
    local copyPropCorner = Instance.new("UICorner")
    copyPropCorner.CornerRadius = UDim.new(0, 4)
    copyPropCorner.Parent = copyPropBtn
    
    -- Get properties
    local props = {}
    for prop, value in pairs(getproperties and getproperties(obj) or {}) do
        table.insert(props, {name = prop, value = value})
    end
    
    -- Fallback if getproperties not available
    if #props == 0 then
        local commonProps = {"Name", "ClassName", "Parent"}
        for _, prop in pairs(commonProps) do
            pcall(function()
                local value = obj[prop]
                table.insert(props, {name = prop, value = value})
            end)
        end
    end
    
    table.sort(props, function(a, b)
        return a.name < b.name
    end)
    
    -- Copy properties function
    copyPropBtn.MouseButton1Click:Connect(function()
        local export = "-- Properties of: " .. obj:GetFullName() .. "\n"
        export = export .. "-- Class: " .. obj.ClassName .. "\n\n"
        
        for _, prop in pairs(props) do
            export = export .. prop.name .. " = " .. tostring(prop.value) .. "\n"
        end
        
        pcall(function()
            setclipboard(export)
        end)
        
        copyPropBtn.Text = "✅ Copied"
        task.wait(1)
        copyPropBtn.Text = "📋 Copy"
    end)
    
    -- Show properties
    for _, prop in pairs(props) do
        local propFrame = Instance.new("Frame")
        propFrame.Size = UDim2.new(1, -8, 0, 40)
        propFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
        propFrame.BorderSizePixel = 0
        propFrame.Parent = propertiesPanel
        
        local propCorner = Instance.new("UICorner")
        propCorner.CornerRadius = UDim.new(0, 4)
        propCorner.Parent = propFrame
        
        local propName = Instance.new("TextLabel")
        propName.Size = UDim2.new(0.4, 0, 0, 20)
        propName.Position = UDim2.new(0, 8, 0, 3)
        propName.BackgroundTransparency = 1
        propName.TextColor3 = Color3.fromRGB(100, 200, 255)
        propName.Text = prop.name
        propName.Font = Enum.Font.GothamBold
        propName.TextSize = 10
        propName.TextXAlignment = Enum.TextXAlignment.Left
        propName.Parent = propFrame
        
        local propValue = Instance.new("TextLabel")
        propValue.Size = UDim2.new(0.6, -16, 1, -6)
        propValue.Position = UDim2.new(0.4, 0, 0, 3)
        propValue.BackgroundTransparency = 1
        propValue.TextColor3 = Color3.fromRGB(200, 200, 220)
        propValue.Text = tostring(prop.value)
        propValue.Font = Enum.Font.Code
        propValue.TextSize = 9
        propValue.TextXAlignment = Enum.TextXAlignment.Left
        propValue.TextYAlignment = Enum.TextYAlignment.Top
        propValue.TextWrapped = true
        propValue.Parent = propFrame
    end
    
    propertiesPanel.CanvasSize = UDim2.new(0, 0, 0, propLayout.AbsoluteContentSize.Y + 5)
end

-- Back button
backBtn.MouseButton1Click:Connect(function()
    if #currentPath > 0 then
        local parent = table.remove(currentPath)
        updateExplorer(parent)
    end
end)

-- Export current view button
exportViewBtn.MouseButton1Click:Connect(function()
    exportViewBtn.Text = "⏳..."
    
    task.spawn(function()
        local function exportObjectDetailed(o, indent)
            indent = indent or 0
            local result = ""
            local prefix = string.rep("  ", indent)
            
            result = result .. prefix .. "-- " .. getIcon(o) .. " " .. o.Name .. " (" .. o.ClassName .. ")\n"
            result = result .. prefix .. "-- Path: " .. o:GetFullName() .. "\n"
            
            -- Important properties for scripting
            if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                result = result .. prefix .. "local " .. o.Name .. " = " .. o:GetFullName() .. "\n"
            end
            
            result = result .. "\n"
            return result
        end
        
        local export = "-- Explorer View Export\n"
        export = export .. "-- Current Object: " .. currentObject:GetFullName() .. "\n"
        export = export .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
        
        local children = currentObject:GetChildren()
        table.sort(children, function(a, b) return a.Name < b.Name end)
        
        for _, child in pairs(children) do
            export = export .. exportObjectDetailed(child, 0)
        end
        
        pcall(function()
            setclipboard(export)
        end)
        
        exportViewBtn.Text = "✅"
        task.wait(1)
        exportViewBtn.Text = "📋 Copy"
    end)
end)

-- ============================================
-- TAB 2: EVENT SPY
-- ============================================
local spyContent = createTab("RemoteSpy", "📡", nil)

-- Controls
local spyControls = Instance.new("Frame")
spyControls.Size = UDim2.new(1, 0, 0, 35)
spyControls.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
spyControls.BorderSizePixel = 0
spyControls.Parent = spyContent

local spyCorner = Instance.new("UICorner")
spyCorner.CornerRadius = UDim.new(0, 6)
spyCorner.Parent = spyControls

local startSpyBtn = Instance.new("TextButton")
startSpyBtn.Size = UDim2.new(0, 100, 0, 28)
startSpyBtn.Position = UDim2.new(0, 5, 0, 3.5)
startSpyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
startSpyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startSpyBtn.Text = "▶ Start Spy"
startSpyBtn.Font = Enum.Font.GothamBold
startSpyBtn.TextSize = 11
startSpyBtn.BorderSizePixel = 0
startSpyBtn.Parent = spyControls

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 4)
startCorner.Parent = startSpyBtn

local clearLogsBtn = Instance.new("TextButton")
clearLogsBtn.Size = UDim2.new(0, 100, 0, 28)
clearLogsBtn.Position = UDim2.new(0, 110, 0, 3.5)
clearLogsBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 50)
clearLogsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearLogsBtn.Text = "🗑️ Clear"
clearLogsBtn.Font = Enum.Font.GothamBold
clearLogsBtn.TextSize = 11
clearLogsBtn.BorderSizePixel = 0
clearLogsBtn.Parent = spyControls

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearLogsBtn

local exportLogsBtn = Instance.new("TextButton")
exportLogsBtn.Size = UDim2.new(0, 120, 0, 28)
exportLogsBtn.Position = UDim2.new(0, 215, 0, 3.5)
exportLogsBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
exportLogsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportLogsBtn.Text = "📋 Export Logs"
exportLogsBtn.Font = Enum.Font.GothamBold
exportLogsBtn.TextSize = 11
exportLogsBtn.BorderSizePixel = 0
exportLogsBtn.Parent = spyControls

local exportLogsCorner = Instance.new("UICorner")
exportLogsCorner.CornerRadius = UDim.new(0, 4)
exportLogsCorner.Parent = exportLogsBtn

-- Event logs
local eventLogsList = Instance.new("ScrollingFrame")
eventLogsList.Size = UDim2.new(1, 0, 1, -40)
eventLogsList.Position = UDim2.new(0, 0, 0, 40)
eventLogsList.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
eventLogsList.BorderSizePixel = 0
eventLogsList.ScrollBarThickness = 6
eventLogsList.CanvasSize = UDim2.new(0, 0, 0, 0)
eventLogsList.Parent = spyContent

local logsCorner = Instance.new("UICorner")
logsCorner.CornerRadius = UDim.new(0, 6)
logsCorner.Parent = eventLogsList

local logsLayout = Instance.new("UIListLayout")
logsLayout.Padding = UDim.new(0, 3)
logsLayout.SortOrder = Enum.SortOrder.LayoutOrder
logsLayout.Parent = eventLogsList

-- Spy functions
local spying = false

local function addEventLog(eventName, eventPath, args)
    local log = Instance.new("Frame")
    log.Size = UDim2.new(1, -8, 0, 100)
    log.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    log.BorderSizePixel = 0
    log.LayoutOrder = -tick()
    log.Parent = eventLogsList
    
    local logCorner = Instance.new("UICorner")
    logCorner.CornerRadius = UDim.new(0, 4)
    logCorner.Parent = log
    
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Size = UDim2.new(0, 70, 0, 16)
    timeLabel.Position = UDim2.new(0, 5, 0, 3)
    timeLabel.BackgroundTransparency = 1
    timeLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    timeLabel.Text = os.date("%H:%M:%S")
    timeLabel.Font = Enum.Font.Code
    timeLabel.TextSize = 9
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = log
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -80, 0, 18)
    nameLabel.Position = UDim2.new(0, 5, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    nameLabel.Text = "📡 " .. eventName
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = log
    
    local pathLabel = Instance.new("TextLabel")
    pathLabel.Size = UDim2.new(1, -10, 0, 14)
    pathLabel.Position = UDim2.new(0, 5, 0, 38)
    pathLabel.BackgroundTransparency = 1
    pathLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    pathLabel.Text = eventPath
    pathLabel.Font = Enum.Font.Code
    pathLabel.TextSize = 8
    pathLabel.TextXAlignment = Enum.TextXAlignment.Left
    pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
    pathLabel.Parent = log
    
    local argsLabel = Instance.new("TextLabel")
    argsLabel.Size = UDim2.new(1, -10, 0, 40)
    argsLabel.Position = UDim2.new(0, 5, 0, 54)
    argsLabel.BackgroundTransparency = 1
    argsLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    
    local argsStr = "Args: "
    pcall(function()
        argsStr = argsStr .. HttpService:JSONEncode(args)
    end)
    if argsStr == "Args: " then
        argsStr = argsStr .. tostring(args)
    end
    
    argsLabel.Text = argsStr:sub(1, 300)
    argsLabel.Font = Enum.Font.Code
    argsLabel.TextSize = 9
    argsLabel.TextXAlignment = Enum.TextXAlignment.Left
    argsLabel.TextYAlignment = Enum.TextYAlignment.Top
    argsLabel.TextWrapped = true
    argsLabel.Parent = log
    
    eventLogsList.CanvasSize = UDim2.new(0, 0, 0, logsLayout.AbsoluteContentSize.Y)
    eventLogsList.CanvasPosition = Vector2.new(0, eventLogsList.CanvasSize.Y.Offset)
end

local function startSpying()
    spying = true
    startSpyBtn.Text = "⏸ Stop Spy"
    startSpyBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 50)
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            pcall(function()
                local conn = obj.OnClientEvent:Connect(function(...)
                    if spying then
                        local args = {...}
                        addEventLog(obj.Name, obj:GetFullName(), args)
                        table.insert(eventLogs, {
                            event = obj:GetFullName(),
                            args = args,
                            time = os.time()
                        })
                    end
                end)
                spyingEvents[obj] = conn
            end)
        end
    end
    
    print("🔍 Spying on", #spyingEvents, "RemoteEvents")
end

local function stopSpying()
    spying = false
    startSpyBtn.Text = "▶ Start Spy"
    startSpyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
    
    for obj, conn in pairs(spyingEvents) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    spyingEvents = {}
end

startSpyBtn.MouseButton1Click:Connect(function()
    if spying then
        stopSpying()
    else
        startSpying()
    end
end)

clearLogsBtn.MouseButton1Click:Connect(function()
    for _, child in pairs(eventLogsList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    eventLogs = {}
end)

-- Export logs function
exportLogsBtn.MouseButton1Click:Connect(function()
    if #eventLogs == 0 then
        exportLogsBtn.Text = "⚠️ No logs"
        task.wait(1)
        exportLogsBtn.Text = "📋 Export Logs"
        return
    end
    
    exportLogsBtn.Text = "⏳ Exporting..."
    
    task.spawn(function()
        local export = "-- RemoteSpy Event Logs\n"
        export = export .. "-- Total Events: " .. #eventLogs .. "\n"
        export = export .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
        
        for i, log in ipairs(eventLogs) do
            export = export .. "-- Event #" .. i .. "\n"
            export = export .. "-- Time: " .. os.date("%H:%M:%S", log.time) .. "\n"
            export = export .. "-- Remote: " .. log.event .. "\n"
            export = export .. "-- Args: "
            
            local argsStr = ""
            pcall(function()
                argsStr = HttpService:JSONEncode(log.args)
            end)
            if argsStr == "" then
                argsStr = tostring(log.args)
            end
            
            export = export .. argsStr .. "\n\n"
            export = export .. "-- Example usage:\n"
            export = export .. "local remote = " .. log.event .. "\n"
            export = export .. "remote:FireServer(" .. argsStr .. ")\n\n"
            export = export .. string.rep("-", 50) .. "\n\n"
        end
        
        pcall(function()
            setclipboard(export)
        end)
        
        exportLogsBtn.Text = "✅ Copied!"
        task.wait(1.5)
        exportLogsBtn.Text = "📋 Export Logs"
    end)
end)

-- ============================================
-- TAB 3: EXPORT
-- ============================================
local exportContent = createTab("Export", "📤", nil)

-- Export options
local exportFrame = Instance.new("Frame")
exportFrame.Size = UDim2.new(1, -10, 0, 100)
exportFrame.Position = UDim2.new(0, 5, 0, 5)
exportFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
exportFrame.BorderSizePixel = 0
exportFrame.Parent = exportContent

local exportCorner = Instance.new("UICorner")
exportCorner.CornerRadius = UDim.new(0, 6)
exportCorner.Parent = exportFrame

local exportTitle = Instance.new("TextLabel")
exportTitle.Size = UDim2.new(1, -10, 0, 25)
exportTitle.Position = UDim2.new(0, 5, 0, 5)
exportTitle.BackgroundTransparency = 1
exportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
exportTitle.Text = "📤 Export Game Structure"
exportTitle.Font = Enum.Font.GothamBold
exportTitle.TextSize = 14
exportTitle.Parent = exportFrame

local exportDesc = Instance.new("TextLabel")
exportDesc.Size = UDim2.new(1, -10, 0, 35)
exportDesc.Position = UDim2.new(0, 5, 0, 30)
exportDesc.BackgroundTransparency = 1
exportDesc.TextColor3 = Color3.fromRGB(180, 180, 200)
exportDesc.Text = "Export full tree structure to clipboard for scripting reference.\nIncludes: All children, properties, and paths."
exportDesc.Font = Enum.Font.Gotham
exportDesc.TextSize = 11
exportDesc.TextWrapped = true
exportDesc.TextXAlignment = Enum.TextXAlignment.Left
exportDesc.TextYAlignment = Enum.TextYAlignment.Top
exportDesc.Parent = exportFrame

-- Export buttons
local exportRSBtn = Instance.new("TextButton")
exportRSBtn.Size = UDim2.new(0, 200, 0, 30)
exportRSBtn.Position = UDim2.new(0, 10, 0, 70)
exportRSBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
exportRSBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportRSBtn.Text = "📋 Export ReplicatedStorage"
exportRSBtn.Font = Enum.Font.GothamBold
exportRSBtn.TextSize = 12
exportRSBtn.BorderSizePixel = 0
exportRSBtn.Parent = exportFrame

local exportRSCorner = Instance.new("UICorner")
exportRSCorner.CornerRadius = UDim.new(0, 6)
exportRSCorner.Parent = exportRSBtn

local exportWSBtn = Instance.new("TextButton")
exportWSBtn.Size = UDim2.new(0, 200, 0, 30)
exportWSBtn.Position = UDim2.new(0, 220, 0, 70)
exportWSBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
exportWSBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportWSBtn.Text = "📋 Export Workspace"
exportWSBtn.Font = Enum.Font.GothamBold
exportWSBtn.TextSize = 12
exportWSBtn.BorderSizePixel = 0
exportWSBtn.Parent = exportFrame

local exportWSCorner = Instance.new("UICorner")
exportWSCorner.CornerRadius = UDim.new(0, 6)
exportWSCorner.Parent = exportWSBtn

local exportCurrentBtn = Instance.new("TextButton")
exportCurrentBtn.Size = UDim2.new(0, 200, 0, 30)
exportCurrentBtn.Position = UDim2.new(0, 430, 0, 70)
exportCurrentBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
exportCurrentBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exportCurrentBtn.Text = "📋 Export Selected Object"
exportCurrentBtn.Font = Enum.Font.GothamBold
exportCurrentBtn.TextSize = 12
exportCurrentBtn.BorderSizePixel = 0
exportCurrentBtn.Parent = exportFrame

local exportCurrentCorner = Instance.new("UICorner")
exportCurrentCorner.CornerRadius = UDim.new(0, 6)
exportCurrentCorner.Parent = exportCurrentBtn

-- Export preview
local exportPreview = Instance.new("ScrollingFrame")
exportPreview.Size = UDim2.new(1, -10, 1, -115)
exportPreview.Position = UDim2.new(0, 5, 0, 110)
exportPreview.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
exportPreview.BorderSizePixel = 0
exportPreview.ScrollBarThickness = 6
exportPreview.CanvasSize = UDim2.new(0, 0, 0, 0)
exportPreview.Parent = exportContent

local previewCorner = Instance.new("UICorner")
previewCorner.CornerRadius = UDim.new(0, 6)
previewCorner.Parent = exportPreview

local previewLabel = Instance.new("TextLabel")
previewLabel.Size = UDim2.new(1, -10, 1, 0)
previewLabel.Position = UDim2.new(0, 5, 0, 5)
previewLabel.BackgroundTransparency = 1
previewLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
previewLabel.Text = "Click export button to see preview..."
previewLabel.Font = Enum.Font.Code
previewLabel.TextSize = 10
previewLabel.TextXAlignment = Enum.TextXAlignment.Left
previewLabel.TextYAlignment = Enum.TextYAlignment.Top
previewLabel.TextWrapped = true
previewLabel.Parent = exportPreview

-- Export functions
local function exportObject(obj, indent)
    indent = indent or 0
    local result = ""
    local prefix = string.rep("  ", indent)
    
    result = result .. prefix .. "-- " .. getIcon(obj) .. " " .. obj.Name .. " (" .. obj.ClassName .. ")\n"
    result = result .. prefix .. "-- Path: " .. obj:GetFullName() .. "\n"
    
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        result = result .. prefix .. "local " .. obj.Name .. " = " .. obj:GetFullName() .. "\n"
    end
    
    local children = obj:GetChildren()
    table.sort(children, function(a, b) return a.Name < b.Name end)
    
    for _, child in pairs(children) do
        result = result .. exportObject(child, indent + 1)
    end
    
    return result
end

exportRSBtn.MouseButton1Click:Connect(function()
    exportRSBtn.Text = "⏳ Exporting..."
    
    task.spawn(function()
        local export = "-- ReplicatedStorage Structure Export\n"
        export = export .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
        
        export = export .. exportObject(ReplicatedStorage)
        
        pcall(function()
            setclipboard(export)
        end)
        
        previewLabel.Text = export
        exportPreview.CanvasSize = UDim2.new(0, 0, 0, previewLabel.TextBounds.Y + 10)
        
        exportRSBtn.Text = "✅ Copied!"
        task.wait(1.5)
        exportRSBtn.Text = "📋 Export ReplicatedStorage"
    end)
end)

exportWSBtn.MouseButton1Click:Connect(function()
    exportWSBtn.Text = "⏳ Exporting..."
    
    task.spawn(function()
        local export = "-- Workspace Structure Export\n"
        export = export .. "-- Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
        
        for _, child in pairs(Workspace:GetChildren()) do
            export = export .. exportObject(child, 0)
        end
        
        pcall(function()
            setclipboard(export)
        end)
        
        previewLabel.Text = export
        exportPreview.CanvasSize = UDim2.new(0, 0, 0, previewLabel.TextBounds.Y + 10)
        
        exportWSBtn.Text = "✅ Copied!"
        task.wait(1.5)
        exportWSBtn.Text = "📋 Export Workspace"
    end)
end)

exportCurrentBtn.MouseButton1Click:Connect(function()
    if not selectedObject then
        exportCurrentBtn.Text = "⚠️ Select object first!"
        task.wait(1.5)
        exportCurrentBtn.Text = "📋 Export Selected Object"
        return
    end
    
    exportCurrentBtn.Text = "⏳ Exporting..."
    
    task.spawn(function()
        local export = "-- Object Export: " .. selectedObject.Name .. "\n"
        export = export .. "-- Type: " .. selectedObject.ClassName .. "\n"
        export = export .. "-- Path: " .. selectedObject:GetFullName() .. "\n\n"
        
        export = export .. exportObject(selectedObject)
        
        pcall(function()
            setclipboard(export)
        end)
        
        previewLabel.Text = export
        exportPreview.CanvasSize = UDim2.new(0, 0, 0, previewLabel.TextBounds.Y + 10)
        
        exportCurrentBtn.Text = "✅ Copied!"
        task.wait(1.5)
        exportCurrentBtn.Text = "📋 Export Selected Object"
    end)
end)

-- ============================================
-- TAB 4: SCRIPTS
-- ============================================
local scriptsContent = createTab("Scripts", "📜", nil)

local scriptsList = Instance.new("ScrollingFrame")
scriptsList.Size = UDim2.new(1, 0, 1, 0)
scriptsList.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
scriptsList.BorderSizePixel = 0
scriptsList.ScrollBarThickness = 6
scriptsList.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsList.Parent = scriptsContent

local scriptsCorner = Instance.new("UICorner")
scriptsCorner.CornerRadius = UDim.new(0, 6)
scriptsCorner.Parent = scriptsList

local scriptsLayout = Instance.new("UIListLayout")
scriptsLayout.Padding = UDim.new(0, 3)
scriptsLayout.SortOrder = Enum.SortOrder.Name
scriptsLayout.Parent = scriptsList

local function scanScripts()
    for _, child in pairs(scriptsList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") or obj:IsA("ModuleScript") then
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, -8, 0, 50)
            entry.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            entry.BorderSizePixel = 0
            entry.Parent = scriptsList
            
            local entryCorner = Instance.new("UICorner")
            entryCorner.CornerRadius = UDim.new(0, 4)
            entryCorner.Parent = entry
            
            local icon = obj:IsA("LocalScript") and "📝" or (obj:IsA("Script") and "📄" or "📜")
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -10, 0, 20)
            nameLabel.Position = UDim2.new(0, 5, 0, 3)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            nameLabel.Text = icon .. " " .. obj.Name
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
            nameLabel.Parent = entry
            
            local pathLabel = Instance.new("TextLabel")
            pathLabel.Size = UDim2.new(1, -10, 0, 14)
            pathLabel.Position = UDim2.new(0, 5, 0, 23)
            pathLabel.BackgroundTransparency = 1
            pathLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
            pathLabel.Text = obj:GetFullName()
            pathLabel.Font = Enum.Font.Code
            pathLabel.TextSize = 9
            pathLabel.TextXAlignment = Enum.TextXAlignment.Left
            pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
            pathLabel.Parent = entry
            
            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(1, -10, 0, 12)
            statusLabel.Position = UDim2.new(0, 5, 0, 37)
            statusLabel.BackgroundTransparency = 1
            statusLabel.TextColor3 = obj.Disabled and Color3.fromRGB(200, 80, 80) or Color3.fromRGB(80, 200, 80)
            statusLabel.Text = obj.Disabled and "⏸️ Disabled" or "▶️ Enabled"
            statusLabel.Font = Enum.Font.Gotham
            statusLabel.TextSize = 9
            statusLabel.TextXAlignment = Enum.TextXAlignment.Left
            statusLabel.Parent = entry
        end
    end
    
    scriptsList.CanvasSize = UDim2.new(0, 0, 0, scriptsLayout.AbsoluteContentSize.Y)
end

tabs["Scripts"].activate = scanScripts

-- ============================================
-- INITIALIZE
-- ============================================
tabs["Explorer"].tab.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
tabs["Explorer"].tab.TextColor3 = Color3.fromRGB(255, 255, 255)
tabs["Explorer"].content.Visible = true
updateExplorer(game)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    stopSpying()
    getgenv().AdvancedDex = false
end)

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        mainFrame.Size = UDim2.new(0, 850, 0, 40)
        contentFrame.Visible = false
        tabBar.Visible = false
        minBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 850, 0, 600)
        contentFrame.Visible = true
        tabBar.Visible = true
        minBtn.Text = "—"
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🔍 Dex Explorer",
        Text = "Loaded! Browse, spy, and export objects",
        Duration = 4
    })
end)

print("════════════════════════════════")
print("🔍 Advanced Dex Explorer Loaded")
print("════════════════════════════════")
print("Features:")
print("  📁 Explorer - Browse all objects")
print("  📡 RemoteSpy - Monitor events")
print("  📤 Export - Copy structure to clipboard")
print("  📜 Scripts - View all scripts")
print("════════════════════════════════")
