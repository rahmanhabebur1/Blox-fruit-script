-- Blox Fruit Helper Script (HoHo Hub Style UI with FPS Boost Inside Main/ESP)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Global States
local autoCollectEnabled = false
local fruitESPEnabled = false
local playerESPEnabled = false
local fpsBoostEnabled = false

local fruitESPObjects = {}
local playerESPObjects = {}
local notifiedFruits = {}

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitHoHoUI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

-- Top-Right Notification Holder
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 180, 0, 200)
NotificationHolder.Position = UDim2.new(1, -190, 0, 10)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = ScreenGui

local UIListLayoutNotif = Instance.new("UIListLayout")
UIListLayoutNotif.Parent = NotificationHolder
UIListLayoutNotif.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutNotif.Padding = UDim.new(0, 6)

local function sendNotification(title, text)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 40)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
    notifFrame.Parent = NotificationHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 1
    stroke.Parent = notifFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 16)
    titleLabel.Position = UDim2.new(0, 8, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notifFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 0, 16)
    textLabel.Position = UDim2.new(0, 8, 0, 20)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    textLabel.TextSize = 11
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notifFrame

    task.spawn(function()
        task.wait(3.5)
        local fadeTween = TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
        TweenService:Create(titleLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        fadeTween:Play()
        fadeTween.Completed:Wait()
        notifFrame:Destroy()
    end)
end

-- Floating Open/Close Icon (HoHo Style Circular Button)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "OpenButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ToggleButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 170, 255)
BtnStroke.Thickness = 2
BtnStroke.Parent = ToggleButton

local BtnIcon = Instance.new("TextLabel")
BtnIcon.Size = UDim2.new(1, 0, 1, 0)
BtnIcon.BackgroundTransparency = 1
BtnIcon.Text = "🎅"
BtnIcon.TextSize = 22
BtnIcon.Parent = ToggleButton

-- Main HoHo Hub Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 10)
UICornerMain.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Top Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 10)
TitleBarCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -15, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "HOHO HUB <font color=\"#00ffff\">[Blox Fruit Helper]</font>"
TitleText.RichText = true
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 14
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Left Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Sidebar.Parent = MainFrame

local TabButton = Instance.new("TextButton")
TabButton.Size = UDim2.new(0.9, 0, 0, 32)
TabButton.Position = UDim2.new(0.05, 0, 0.05, 0)
TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabButton.Text = "Main / ESP"
TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TabButton.Font = Enum.Font.GothamBold
TabButton.TextSize = 12
TabButton.Parent = Sidebar

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 6)
TabCorner.Parent = TabButton

-- Container Area (Right Side)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -120, 1, -45)
Container.Position = UDim2.new(0, 115, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayoutContainer = Instance.new("UIListLayout")
UIListLayoutContainer.Parent = Container
UIListLayoutContainer.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutContainer.Padding = UDim.new(0, 8)

-- Function to Create HoHo Style Toggle Rows
local function createToggleRow(name, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 42)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.28, 0, 0.65, 0)
    toggleBtn.Position = UDim2.new(0.68, 0, 0.175, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 11
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = toggleBtn

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
        toggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        callback(state)
    end)
end

---------------------------------------------------------
-- CORE LOGIC & FEATURES
---------------------------------------------------------

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- FPS Boost Logic
local originalLighting = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

local function applyFPSBoost(enable)
    fpsBoostEnabled = enable
    if enable then
        -- Shadow & Fog Remove
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9

        -- Sky / Atmosphere / Clouds Cleanup
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
                obj.Enabled = false
            end
        end

        -- Water VFX Cleanup
        if Workspace:FindFirstChildOfClass("Terrain") then
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end

        -- Attack & World Particles Low
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
    else
        -- Restore Original Settings
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogStart = originalLighting.FogStart

        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then
                obj.Enabled = true
            end
        end

        if Workspace:FindFirstChildOfClass("Terrain") then
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            terrain.WaterWaveSize = 0.15
            terrain.WaterWaveSpeed = 10
            terrain.WaterReflectance = 0.05
            terrain.WaterTransparency = 0.5
        end

        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = true
            end
        end
    end
end

-- New Particle Spawns Disabled Automatically
Workspace.DescendantAdded:Connect(function(v)
    if fpsBoostEnabled then
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end)

local function isFruit(obj)
    if not (obj:IsA("Tool") or string.find(obj.Name, "Fruit")) then return false end
    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
    return handle ~= nil
end

local function checkFruitsForNotification(isNewSpawn)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) and not notifiedFruits[obj] then
            notifiedFruits[obj] = true
            if isNewSpawn then
                sendNotification("🍎 Fruit Spawned!", obj.Name)
            else
                sendNotification("🍇 Fruit Found:", obj.Name)
            end
        end
    end
end

-- ESP Functions
local function removeFruitESP()
    for _, item in ipairs(fruitESPObjects) do
        if item and item.Parent then item:Destroy() end
    end
    fruitESPObjects = {}
end

local function updateFruitESP()
    removeFruitESP()
    if not fruitESPEnabled then return end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) then
            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if handle then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = obj
                table.insert(fruitESPObjects, highlight)

                local bbGui = Instance.new("BillboardGui")
                bbGui.Name = "FruitESP"
                bbGui.Adornee = handle
                bbGui.Size = UDim2.new(0, 150, 0, 30)
                bbGui.StudsOffset = Vector3.new(0, 2, 0)
                bbGui.AlwaysOnTop = true
                bbGui.Parent = handle

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(0, 255, 200)
                label.TextStrokeTransparency = 0
                label.TextSize = 13
                label.Font = Enum.Font.GothamBold
                label.Text = "🍇 " .. obj.Name
                label.Parent = bbGui

                table.insert(fruitESPObjects, bbGui)
            end
        end
    end
end

local function removePlayerESP()
    for _, item in ipairs(playerESPObjects) do
        if item and item.Parent then item:Destroy() end
    end
    playerESPObjects = {}
end

local function updatePlayerESP()
    removePlayerESP()
    if not playerESPEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local char = player.Character
            local head = char.Head
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local pName = player.DisplayName or player.Name
                local levelText = "?"
                if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
                    levelText = tostring(player.Data.Level.Value)
                elseif player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then
                    levelText = tostring(player.leaderstats.Level.Value)
                end

                local bbGui = Instance.new("BillboardGui")
                bbGui.Name = "PlayerESP"
                bbGui.Adornee = head
                bbGui.Size = UDim2.new(0, 160, 0, 45)
                bbGui.StudsOffset = Vector3.new(0, 2.5, 0)
                bbGui.AlwaysOnTop = true
                bbGui.Parent = head

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 80, 80)
                label.TextStrokeTransparency = 0
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.Parent = bbGui

                table.insert(playerESPObjects, bbGui)

                task.spawn(function()
                    while playerESPEnabled and char and char.Parent and humanoid and humanoid.Health > 0 do
                        label.Text = string.format("%s [Lvl %s]\nHP: %d/%d", pName, levelText, math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        task.wait(0.5)
                    end
                    if bbGui then bbGui:Destroy() end
                end)
            end
        end
    end
end

-- Fly Function
local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local flySpeed = 250
    local duration = distance / flySpeed

    hrp.Velocity = Vector3.zero
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    
    tween:Play()
    return tween
end

-- Create UI Toggles in Main/ESP Container
createToggleRow("Fruit ESP", function(enabled)
    fruitESPEnabled = enabled
    updateFruitESP()
end)

createToggleRow("Player ESP", function(enabled)
    playerESPEnabled = enabled
    updatePlayerESP()
end)

createToggleRow("Auto Fly Collect", function(enabled)
    autoCollectEnabled = enabled
end)

createToggleRow("FPS Boost", function(enabled)
    applyFPSBoost(enabled)
end)

-- Fly Collect Loop
task.spawn(function()
    while task.wait(1) do
        if autoCollectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if isFruit(obj) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        local currentTween = flyTo(handle.CFrame)
                        if currentTween then
                            currentTween.Completed:Wait()
                        end
                        break
                    end
                end
            end
        end
    end
end)

-- Initial Checks & Auto Refresh
checkFruitsForNotification(false)

Workspace.ChildAdded:Connect(function(child)
    task.wait(0.5)
    if fruitESPEnabled then updateFruitESP() end
    checkFruitsForNotification(true)
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        if playerESPEnabled then updatePlayerESP() end
    end)
end)
