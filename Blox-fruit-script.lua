-- MD GAMER SCRIPT (Blox Fruit Helper Script with Original FPS Boost)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Global States
local autoCollectEnabled = false
local fruitESPEnabled = false
local playerESPEnabled = false
local fpsBoostEnabled = false

-- Aimbot States
local aimbotEnabled = false
local aimTargetMode = "Players" -- "Players" or "NPCs"
local targetLowestHP = true
local fovRadius = 150
local showFOV = false

local fruitESPObjects = {}
local playerESPObjects = {}
local notifiedFruits = {}

-- FOV Circle Creation
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.NumSides = 30
FOVCircle.Radius = fovRadius
FOVCircle.Visible = false

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MD_GAMER_SCRIPT_UI"
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui or LocalPlayer:WaitForChild("PlayerGui")
end

-- Notification System
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

-- Floating Open/Close Icon
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
BtnIcon.Text = "🎮"
BtnIcon.TextSize = 22
BtnIcon.Parent = ToggleButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 430, 0, 270)
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
TitleText.Text = "MD GAMER <font color=\"#00ffff\">[SCRIPT HUB]</font>"
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

local UIListLayoutSidebar = Instance.new("UIListLayout")
UIListLayoutSidebar.Parent = Sidebar
UIListLayoutSidebar.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutSidebar.Padding = UDim.new(0, 5)

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 8)
SidebarPadding.PaddingLeft = UDim.new(0, 5)
SidebarPadding.Parent = Sidebar

-- Tab Buttons Creator
local function createTabBtn(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local TabMainBtn = createTabBtn("Main / ESP")
local TabAimbotBtn = createTabBtn("AIMBOT 🎯")
local TabIslandBtn = createTabBtn("ISLAND 🏝️")

TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Containers
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(1, -120, 1, -45)
MainContainer.Position = UDim2.new(0, 115, 0, 40)
MainContainer.BackgroundTransparency = 1
MainContainer.Parent = MainFrame

local UIListLayoutMain = Instance.new("UIListLayout")
UIListLayoutMain.Parent = MainContainer
UIListLayoutMain.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutMain.Padding = UDim.new(0, 6)

local AimbotContainer = Instance.new("ScrollingFrame")
AimbotContainer.Size = UDim2.new(1, -120, 1, -45)
AimbotContainer.Position = UDim2.new(0, 115, 0, 40)
AimbotContainer.BackgroundTransparency = 1
AimbotContainer.Visible = false
AimbotContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
AimbotContainer.ScrollBarThickness = 3
AimbotContainer.Parent = MainFrame

local UIListLayoutAim = Instance.new("UIListLayout")
UIListLayoutAim.Parent = AimbotContainer
UIListLayoutAim.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutAim.Padding = UDim.new(0, 6)

local IslandContainer = Instance.new("ScrollingFrame")
IslandContainer.Size = UDim2.new(1, -120, 1, -45)
IslandContainer.Position = UDim2.new(0, 115, 0, 40)
IslandContainer.BackgroundTransparency = 1
IslandContainer.Visible = false
IslandContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
IslandContainer.ScrollBarThickness = 3
IslandContainer.Parent = MainFrame

local UIListLayoutIsland = Instance.new("UIListLayout")
UIListLayoutIsland.Parent = IslandContainer
UIListLayoutIsland.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutIsland.Padding = UDim.new(0, 6)

-- Tab Switch Logic
local function resetTabs()
    MainContainer.Visible = false
    AimbotContainer.Visible = false
    IslandContainer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabAimbotBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabAimbotBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabIslandBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

TabMainBtn.MouseButton1Click:Connect(function()
    resetTabs()
    MainContainer.Visible = true
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabAimbotBtn.MouseButton1Click:Connect(function()
    resetTabs()
    AimbotContainer.Visible = true
    TabAimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabAimbotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabIslandBtn.MouseButton1Click:Connect(function()
    resetTabs()
    IslandContainer.Visible = true
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabIslandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Function to Create Toggle Rows
local function createToggleRow(parentContainer, name, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    frame.Parent = parentContainer

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
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.28, 0, 0.65, 0)
    toggleBtn.Position = UDim2.new(0.68, 0, 0.175, 0)
    toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
    toggleBtn.Text = defaultState and "ON" or "OFF"
    toggleBtn.TextColor3 = defaultState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 10
    toggleBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = toggleBtn

    local state = defaultState
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
        toggleBtn.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        callback(state)
    end)
end
---------------------------------------------------------
-- ORIGINAL REAL WORKING FPS BOOST (SHADOW, FOG & VFX REMOVER)
---------------------------------------------------------

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function removeVFX(v)
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
        v.Enabled = false
    elseif v:IsA("Beam") or v:IsA("Trail") then
        v.Enabled = false
    end
end

local function processFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then
            obj.Enabled = false
        end
    end

    local cam = Workspace.CurrentCamera
    if cam then
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("BlurEffect") then
                obj.Enabled = false
            end
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        removeVFX(v)
        if v:IsA("BasePart") then
            v.CastShadow = false
        end
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if fpsBoostEnabled then
            pcall(processFPSBoost)
        end
    end
end)

Workspace.DescendantAdded:Connect(function(v)
    if fpsBoostEnabled then
        task.wait()
        removeVFX(v)
        if v:IsA("BasePart") then
            v.CastShadow = false
        end
    end
end)

---------------------------------------------------------
-- AIMBOT ENGINE
---------------------------------------------------------

local function getClosestTarget()
    local closest = nil
    local shortestDist = fovRadius
    local lowestHP = math.huge

    local camera = Workspace.CurrentCamera
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    if aimTargetMode == "Players" then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist <= fovRadius then
                            if targetLowestHP then
                                if hum.Health < lowestHP then
                                    lowestHP = hum.Health
                                    closest = player.Character.HumanoidRootPart
                                end
                            else
                                if dist < shortestDist then
                                    shortestDist = dist
                                    closest = player.Character.HumanoidRootPart
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        for _, npc in ipairs(Workspace.Enemies:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChildOfClass("Humanoid") then
                local hum = npc:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(npc.HumanoidRootPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist <= fovRadius then
                            if dist < shortestDist then
                                shortestDist = dist
                                closest = npc.HumanoidRootPart
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = fovRadius
    FOVCircle.Visible = showFOV

    if aimbotEnabled then
        local target = getClosestTarget()
        if target then
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)

---------------------------------------------------------
-- AIMBOT UI SETUP
---------------------------------------------------------

createToggleRow(AimbotContainer, "Silent Aim / Lock", false, function(enabled)
    aimbotEnabled = enabled
    if enabled then sendNotification("🎮 MD GAMER", "Aimbot Activated!") end
end)

createToggleRow(AimbotContainer, "Show FOV Circle", false, function(enabled)
    showFOV = enabled
end)

createToggleRow(AimbotContainer, "Prioritize Low HP", true, function(enabled)
    targetLowestHP = enabled
end)

-- Mode Switcher
local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, -10, 0, 36)
modeFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
modeFrame.Parent = AimbotContainer

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 6)
modeCorner.Parent = modeFrame

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(0.5, 0, 1, 0)
modeLabel.Position = UDim2.new(0, 10, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Target Mode"
modeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
modeLabel.Font = Enum.Font.GothamSemibold
modeLabel.TextSize = 11
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = modeFrame

local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(0.4, 0, 0.65, 0)
modeBtn.Position = UDim2.new(0.56, 0, 0.175, 0)
modeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
modeBtn.Text = "Players"
modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 10
modeBtn.Parent = modeFrame

local modeBtnCorner = Instance.new("UICorner")
modeBtnCorner.CornerRadius = UDim.new(0, 5)
modeBtnCorner.Parent = modeBtn

modeBtn.MouseButton1Click:Connect(function()
    if aimTargetMode == "Players" then
        aimTargetMode = "NPCs"
        modeBtn.Text = "NPCs / Mobs"
        modeBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    else
        aimTargetMode = "Players"
        modeBtn.Text = "Players"
        modeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)

-- FOV Size Switcher
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, -10, 0, 36)
fovFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
fovFrame.Parent = AimbotContainer

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.5, 0, 1, 0)
fovLabel.Position = UDim2.new(0, 10, 0, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Size"
fovLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fovLabel.Font = Enum.Font.GothamSemibold
fovLabel.TextSize = 11
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = fovFrame

local fovBtn = Instance.new("TextButton")
fovBtn.Size = UDim2.new(0.4, 0, 0.65, 0)
fovBtn.Position = UDim2.new(0.56, 0, 0.175, 0)
fovBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
fovBtn.Text = "Medium (150)"
fovBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
fovBtn.Font = Enum.Font.GothamBold
fovBtn.TextSize = 10
fovBtn.Parent = fovFrame

local fovBtnCorner = Instance.new("UICorner")
fovBtnCorner.CornerRadius = UDim.new(0, 5)
fovBtnCorner.Parent = fovBtn

fovBtn.MouseButton1Click:Connect(function()
    if fovRadius == 150 then
        fovRadius = 250
        fovBtn.Text = "Large (250)"
    elseif fovRadius == 250 then
        fovRadius = 100
        fovBtn.Text = "Small (100)"
    else
        fovRadius = 150
        fovBtn.Text = "Medium (150)"
    end
end)

---------------------------------------------------------
-- SAFE FLY TELEPORT FUNCTIONALITY
---------------------------------------------------------

local currentFlyTween = nil

local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local safeTargetCFrame = targetCFrame + Vector3.new(0, 150, 0)
    
    local distance = (hrp.Position - safeTargetCFrame.Position).Magnitude
    local flySpeed = 250
    local duration = distance / flySpeed

    if currentFlyTween then currentFlyTween:Cancel() end

    hrp.Velocity = Vector3.zero
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentFlyTween = TweenService:Create(hrp, tweenInfo, {CFrame = safeTargetCFrame})
    currentFlyTween:Play()
    
    currentFlyTween.Completed:Wait()
    
    local finalTween = TweenService:Create(hrp, TweenInfo.new(0.8, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 5, 0)})
    finalTween:Play()
    
    return finalTween
end

---------------------------------------------------------
-- ISLAND DATA & TELEPORT UI
---------------------------------------------------------

local seaIslands = {
    [2753915549] = {
        ["Starter Island"] = Vector3.new(1090, 16, 1400),
        ["Jungle"] = Vector3.new(-1240, 12, 380),
        ["Pirate Village"] = Vector3.new(-1120, 4, 3850),
        ["Desert"] = Vector3.new(1090, 6, 4360),
        ["Middle Town"] = Vector3.new(-650, 15, 1500),
        ["Frozen Village"] = Vector3.new(1150, 7, -1150),
        ["Marine Ford"] = Vector3.new(-4800, 20, 4200),
        ["Skypiea"] = Vector3.new(-4850, 718, -2620),
        ["Prison"] = Vector3.new(4850, 5, 740),
        ["Colosseum"] = Vector3.new(-1450, 7, -2750),
        ["Magma Village"] = Vector3.new(-5250, 8, 8500),
        ["Underwater City"] = Vector3.new(3860, 5, -1920),
        ["Fountain City"] = Vector3.new(5120, 4, 4100)
    },
    [4442272183] = {
        ["Cafe"] = Vector3.new(-380, 73, 300),
        ["Kingdom of Rose"] = Vector3.new(-450, 73, 1500),
        ["Ushapp's Island"] = Vector3.new(4800, 8, 2800),
        ["Green Zone"] = Vector3.new(-2400, 73, -3200),
        ["Graveyard"] = Vector3.new(-5400, 48, -750),
        ["Snow Mountain"] = Vector3.new(1300, 400, -1300),
        ["Hot and Cold"] = Vector3.new(-6100, 15, -5000),
        ["Cursed Ship"] = Vector3.new(900, 125, 3300),
        ["Ice Castle"] = Vector3.new(5500, 28, -6200),
        ["Forgotten Island"] = Vector3.new(-3050, 235, -10150)
    },
    [7449423635] = {
        ["Port Town"] = Vector3.new(-2900, 15, 5300),
        ["Great Tree"] = Vector3.new(2250, 25, -7200),
        ["Floating Turtle"] = Vector3.new(-13200, 330, -7600),
        ["Castle on the Sea"] = Vector3.new(-5000, 315, -3000),
        ["Haunted Castle"] = Vector3.new(-9500, 140, 5500),
        ["Chocolate Land"] = Vector3.new(100, 25, -12100),
        ["Ice Cream Land"] = Vector3.new(-900, 65, -11000),
        ["Tiki Outpost"] = Vector3.new(-16200, 10, 500)
    }
}

local currentSeaIslands = seaIslands[game.PlaceId] or seaIslands[2753915549]
local totalIslands = 0

for islandName, pos in pairs(currentSeaIslands) do
    totalIslands = totalIslands + 1
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.Text = "  📍 " .. islandName
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = IslandContainer

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        sendNotification("🏝️ Flying Safely...", islandName)
        flyTo(CFrame.new(pos))
    end)
end

IslandContainer.CanvasSize = UDim2.new(0, 0, 0, totalIslands * 38)

---------------------------------------------------------
-- ESP & HELPER FUNCTIONS
---------------------------------------------------------

local function isFruit(obj)
    if not (obj:IsA("Tool") or string.find(obj.Name, "Fruit")) then return false end
    return (obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
end

local function checkFruitsForNotification(isNewSpawn)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) and not notifiedFruits[obj] then
            notifiedFruits[obj] = true
            sendNotification(isNewSpawn and "🍎 Fruit Spawned!" or "🍇 Fruit Found:", obj.Name)
        end
    end
end

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

-- Create UI Toggles in Main Container
createToggleRow(MainContainer, "Fruit ESP", false, function(enabled)
    fruitESPEnabled = enabled
    updateFruitESP()
end)

createToggleRow(MainContainer, "Player ESP", false, function(enabled)
    playerESPEnabled = enabled
    updatePlayerESP()
end)

createToggleRow(MainContainer, "Auto Fly Collect", false, function(enabled)
    autoCollectEnabled = enabled
end)

createToggleRow(MainContainer, "FPS Boost", false, function(enabled)
    fpsBoostEnabled = enabled
    if enabled then
        pcall(processFPSBoost)
        sendNotification("🚀 FPS Boost", "Shadows, Fog & Attack VFX Removed!")
    end
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
                        if currentTween then currentTween.Completed:Wait() end
                        break
                    end
                end
            end
        end
    end
end)

checkFruitsForNotification(false)

Workspace.ChildAdded:Connect(function()
    task.wait(0.5)
    if fruitESPEnabled then updateFruitESP() end
    checkFruitsForNotification(true)
end)

sendNotification("😎 MD GAMER SCRIPT 😎", "Successfully Loaded!")
