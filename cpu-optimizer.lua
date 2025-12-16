-- ROBLOX EXTREME CPU OPTIMIZER SCRIPT
-- Script dengan opsi disable 3D render untuk CPU super rendah

local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- KONFIGURASI
local DISABLE_3D_RENDER = true 
local FPS_CAP = 25 

-- Matikan rendering yang tidak perlu
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01

-- Set FPS cap
setfpscap(FPS_CAP)

-- Nonaktifkan efek lighting
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100
    Lighting.Brightness = 1
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or 
           v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end
end)

-- DISABLE 3D RENDER
if DISABLE_3D_RENDER then
    -- Metode 1: Matikan semua render dengan RunService
    local cam = Workspace.CurrentCamera
    
    -- Disconnect render step
    RS:Set3dRenderingEnabled(false)
    
    -- Sembunyikan semua part di workspace
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Transparency = 1
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
                obj.Enabled = false
            end
        end)
    end
    
    -- Buat layar hitam untuk menutupi render
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CPUOptimizer"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0.2, 0)
    Label.Position = UDim2.new(0.25, 0, 0.4, 0)
    Label.BackgroundTransparency = 1
    Label.Text = "3D RENDER DISABLED\nCPU OPTIMIZER ACTIVE\n\nGame masih berjalan di background"
    Label.TextColor3 = Color3.new(0, 1, 0)
    Label.TextSize = 24
    Label.Font = Enum.Font.SourceSansBold
    Label.TextWrapped = true
    Label.Parent = Frame
    
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    print("✓ 3D Render DISABLED (Mode Ekstrem)")
    
else
    -- MODE OPTIMASI BIASA (dengan render)
    
    -- Optimasi terrain
    pcall(function()
        Workspace.Terrain.WaterReflectance = 0
        Workspace.Terrain.WaterTransparency = 0
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
        Workspace.Terrain.Decoration = false
    end)
    
    -- Kurangi detail parts
    local function optimizeParts()
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 0.5
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end)
        end
    end
    
    -- Nonaktifkan animasi pemain lain
    local function disableOtherPlayersAnimations()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                pcall(function()
                    local char = player.Character
                    if char then
                        for _, track in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
                            track:Stop()
                        end
                    end
                end)
            end
        end
    end
    
    -- Render hanya objek terdekat
    local function renderDistance()
        local char = Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local pos = char.HumanoidRootPart.Position
        for _, obj in pairs(Workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") and obj.Parent ~= char then
                    local dist = (obj.Position - pos).Magnitude
                    if dist > 100 then
                        obj.Transparency = 1
                        obj.CanCollide = false
                    else
                        if obj.Transparency == 1 then
                            obj.Transparency = 0
                            obj.CanCollide = true
                        end
                    end
                end
            end)
        end
    end
    
    optimizeParts()
    
    spawn(function()
        while wait(3) do
            pcall(disableOtherPlayersAnimations)
        end
    end)
    
    spawn(function()
        while wait(2) do
            pcall(renderDistance)
        end
    end)
    
    print("✓ Optimasi Normal Mode aktif")
end

print("✓ CPU Optimizer aktif!")
print("✓ FPS cap: " .. FPS_CAP)
print("✓ Quality: Minimum")
print("✓ 3D Render: " .. (DISABLE_3D_RENDER and "DISABLED" or "ENABLED"))
