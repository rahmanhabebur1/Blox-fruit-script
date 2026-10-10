-- MD GAMER SCRIPT (Part 1 - Fixed Toggle & FPS)
_G.autoFarmEnabled = false
_G.autoCollectEnabled = false
_G.fruitESPEnabled = false
_G.playerESPEnabled = false
_G.fpsBoostEnabled = false

_G.aimbotNearestEnabled = false
_G.ignoreMobsEnabled = false
_G.ignorePlayersEnabled = false
_G.killAuraEnabled = false

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

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

function sendNotification(title, text)
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

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 280)
MainFrame.Position = UDim2.new(0, 3, 0.3, 0)
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

-- Live FPS Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "OpenButton"
ToggleButton.Size = UDim2.new(0, 75, 0, 36)
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Text = "FPS: --"
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 200)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = ToggleButton

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 170, 255)
BtnStroke.Thickness = 1.5
BtnStroke.Parent = ToggleButton

-- Toggle Main UI visibility on click
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Real-time FPS Calculator
local frameCount = 0
local lastTick = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTick = tick()
    if currentTick - lastTick >= 1 then
        local fps = math.floor(frameCount / (currentTick - lastTick))
        ToggleButton.Text = "FPS: " .. tostring(fps)
        frameCount = 0
        lastTick = currentTick
    end
end)

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

_G.TabMainBtn = createTabBtn("Main / ESP")
_G.TabPvpBtn = createTabBtn("PVP ☠️")
_G.TabFarmBtn = createTabBtn("FARM ⚔️")
_G.TabIslandBtn = createTabBtn("ISLAND 🏝️")

_G.TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
_G.TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
-- MD GAMER SCRIPT (Part 2)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = CoreGui:FindFirstChild("MD_GAMER_SCRIPT_UI") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("MD_GAMER_SCRIPT_UI")
local MainFrame = ScreenGui and ScreenGui:FindFirstChild("MainFrame")

local MainContainer = Instance.new("ScrollingFrame")
MainContainer.Size = UDim2.new(1, -120, 1, -45)
MainContainer.Position = UDim2.new(0, 115, 0, 40)
MainContainer.BackgroundTransparency = 1
MainContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
MainContainer.ScrollBarThickness = 3
MainContainer.Parent = MainFrame

local UIListLayoutMain = Instance.new("UIListLayout")
UIListLayoutMain.Parent = MainContainer
UIListLayoutMain.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutMain.Padding = UDim.new(0, 6)

local PvpContainer = Instance.new("ScrollingFrame")
PvpContainer.Size = UDim2.new(1, -120, 1, -45)
PvpContainer.Position = UDim2.new(0, 115, 0, 40)
PvpContainer.BackgroundTransparency = 1
PvpContainer.Visible = false
PvpContainer.CanvasSize = UDim2.new(0, 0, 0, 220)
PvpContainer.ScrollBarThickness = 3
PvpContainer.Parent = MainFrame

local UIListLayoutPvp = Instance.new("UIListLayout")
UIListLayoutPvp.Parent = PvpContainer
UIListLayoutPvp.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutPvp.Padding = UDim.new(0, 6)

local FarmContainer = Instance.new("ScrollingFrame")
FarmContainer.Size = UDim2.new(1, -120, 1, -45)
FarmContainer.Position = UDim2.new(0, 115, 0, 40)
FarmContainer.BackgroundTransparency = 1
FarmContainer.Visible = false
FarmContainer.CanvasSize = UDim2.new(0, 0, 0, 150)
FarmContainer.ScrollBarThickness = 3
FarmContainer.Parent = MainFrame

local UIListLayoutFarm = Instance.new("UIListLayout")
UIListLayoutFarm.Parent = FarmContainer
UIListLayoutFarm.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutFarm.Padding = UDim.new(0, 6)

local IslandContainer = Instance.new("ScrollingFrame")
IslandContainer.Size = UDim2.new(1, -120, 1, -45)
IslandContainer.Position = UDim2.new(0, 115, 0, 40)
IslandContainer.BackgroundTransparency = 1
IslandContainer.Visible = false
IslandContainer.CanvasSize = UDim2.new(0, 0, 0, 500)
IslandContainer.ScrollBarThickness = 3
IslandContainer.Parent = MainFrame

local UIListLayoutIsland = Instance.new("UIListLayout")
UIListLayoutIsland.Parent = IslandContainer
UIListLayoutIsland.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutIsland.Padding = UDim.new(0, 6)

local function resetTabs()
    MainContainer.Visible = false
    PvpContainer.Visible = false
    FarmContainer.Visible = false
    IslandContainer.Visible = false
    _G.TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    _G.TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    _G.TabPvpBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    _G.TabPvpBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    _G.TabFarmBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    _G.TabFarmBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    _G.TabIslandBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    _G.TabIslandBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

_G.TabMainBtn.MouseButton1Click:Connect(function()
    resetTabs()
    MainContainer.Visible = true
    _G.TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    _G.TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

_G.TabPvpBtn.MouseButton1Click:Connect(function()
    resetTabs()
    PvpContainer.Visible = true
    _G.TabPvpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    _G.TabPvpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

_G.TabFarmBtn.MouseButton1Click:Connect(function()
    resetTabs()
    FarmContainer.Visible = true
    _G.TabFarmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    _G.TabFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

_G.TabIslandBtn.MouseButton1Click:Connect(function()
    resetTabs()
    IslandContainer.Visible = true
    _G.TabIslandBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    _G.TabIslandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

function createToggleRow(parentContainer, name, defaultState, callback)
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

createToggleRow(PvpContainer, "Aimbot Nearest", false, function(enabled) _G.aimbotNearestEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Mobs", false, function(enabled) _G.ignoreMobsEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Players", false, function(enabled) _G.ignorePlayersEnabled = enabled end)
createToggleRow(PvpContainer, "Kill Aura (No Anim)", false, function(enabled) _G.killAuraEnabled = enabled end)

createToggleRow(FarmContainer, "Auto Farm Level", false, function(enabled) _G.autoFarmEnabled = enabled end)

_G.MainContainer = MainContainer
_G.IslandContainer = IslandContainer
-- MD GAMER SCRIPT (Part 3)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local fruitESPObjects = {}
local playerESPObjects = {}
local notifiedFruits = {}

local function cleanLagEffects(v)
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") or v:IsA("Beam") or v:IsA("Trail") or v:IsA("Highlight") then
        v:Destroy()
    elseif v:IsA("BasePart") then
        v.CastShadow = false
    end
end

local function executeBalancedFPSBoost()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("SunRaysEffect") then
            obj:Destroy()
        end
    end

    local cam = Workspace.CurrentCamera
    if cam then
        for _, obj in ipairs(cam:GetChildren()) do
            if obj:IsA("PostEffect") or obj:IsA("DepthOfFieldEffect") or obj:IsA("BlurEffect") then
                obj:Destroy()
            end
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do
        pcall(function() cleanLagEffects(v) end)
    end
end

task.spawn(function()
    while true do
        task.wait(3)
        if _G.fpsBoostEnabled then pcall(executeBalancedFPSBoost) end
    end
end)

local function flyTo(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = char.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local flySpeed = 250
    local duration = distance / flySpeed

    local startTime = tick()
    local startCFrame = hrp.CFrame
    local connection

    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local alpha = math.clamp(elapsed / duration, 0, 1)
        
        if hrp and hrp.Parent then
            hrp.Velocity = Vector3.zero
            hrp.CFrame = startCFrame:Lerp(targetCFrame, alpha)
        end

        if alpha >= 1 or not hrp or not hrp.Parent then
            connection:Disconnect()
        end
    end)

    task.wait(duration)
    if connection then connection:Disconnect() end
end

local seaIslands = {
    [2753915549] = {
        ["Starter Island"] = Vector3.new(1090, 16, 1400), 
        ["Jungle"] = Vector3.new(-1240, 12, 380),
        ["Pirate Village"] = Vector3.new(-1120, 4, 3850), 
        ["Desert"] = Vector3.new(1090, 6, 4360),
        ["Middle Town"] = Vector3.new(-650, 15, 1500), 
        ["Frozen Village"] = Vector3.new(1150, 7, -1150),
        ["Marine Ford"] = Vector3.new(-4800, 20, 4200), 
        ["Skypiea"] = Vector3.new(-4720, 855, -2630),
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

if _G.IslandContainer then
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
        btn.Parent = _G.IslandContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseButton1Click:Connect(function()
            if sendNotification then sendNotification("🏝️ Flying...", islandName) end
            flyTo(CFrame.new(pos))
        end)
    end
    _G.IslandContainer.CanvasSize = UDim2.new(0, 0, 0, totalIslands * 38)
end

local function isFruit(obj)
    if not (obj:IsA("Tool") or string.find(obj.Name, "Fruit")) then return false end
    return (obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")) ~= nil
end

local function checkFruitsForNotification(isNewSpawn)
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isFruit(obj) and not notifiedFruits[obj] then
            notifiedFruits[obj] = true
            if sendNotification then sendNotification(isNewSpawn and "🍎 Fruit Spawned!" or "🍇 Fruit Found:", obj.Name) end
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
    if not _G.fruitESPEnabled then return end

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
    if not _G.playerESPEnabled then return end

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

                local nameColor = Color3.fromRGB(255, 80, 80)
                if player.Team and (player.Team.Name == "Marines" or player.Team.Name == "Marine") then
                    nameColor = Color3.fromRGB(135, 206, 235)
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
                label.TextColor3 = nameColor
                label.TextSize = 12
                label.Font = Enum.Font.GothamBold
                label.Parent = bbGui

                table.insert(playerESPObjects, bbGui)

                task.spawn(function()
                    while _G.playerESPEnabled and char and char.Parent and humanoid and humanoid.Health > 0 do
                        label.Text = string.format("%s [Lvl %s]\nHP: %d/%d", pName, levelText, math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                        task.wait(0.5)
                    end
                    if bbGui then bbGui:Destroy() end
                end)
            end
        end
    end
end

if _G.MainContainer and createToggleRow then
    createToggleRow(_G.MainContainer, "Fruit ESP", false, function(enabled)
        _G.fruitESPEnabled = enabled
        updateFruitESP()
    end)

    createToggleRow(_G.MainContainer, "Player ESP", false, function(enabled)
        _G.playerESPEnabled = enabled
        updatePlayerESP()
    end)

    createToggleRow(_G.MainContainer, "Auto Fly Collect", false, function(enabled)
        _G.autoCollectEnabled = enabled
    end)

    createToggleRow(_G.MainContainer, "FPS Boost", false, function(enabled)
        _G.fpsBoostEnabled = enabled
        if enabled then
            pcall(executeBalancedFPSBoost)
            if sendNotification then sendNotification("🚀 FPS Boost", "Balanced Mode Active!") end
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        if _G.autoCollectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if isFruit(obj) then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        flyTo(handle.CFrame)
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
    if _G.fruitESPEnabled then updateFruitESP() end
    checkFruitsForNotification(true)
end)

if sendNotification then sendNotification("🎮 MD GAMER SCRIPT", "UI & Toggle Fully Fixed!") end
