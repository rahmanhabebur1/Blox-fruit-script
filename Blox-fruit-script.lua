-- MD GAMER SCRIPT (Part 1 - Fruit ESP & Notification Restored)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local autoCollectEnabled = false
local fruitESPEnabled = false
local playerESPEnabled = false
local fpsBoostEnabled = false

local fastAttackEnabled = false
local bringMobEnabled = false
local selectWeaponType = "Melee"

-- PVP Options
local aimbotNearestEnabled = false
local ignoreMobsEnabled = false
local ignorePlayersEnabled = false
local killAuraEnabled = false

local fruitESPObjects = {}
local playerESPObjects = {}
local notifiedFruits = {}

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

local TabMainBtn = createTabBtn("Main / ESP")
local TabPvpBtn = createTabBtn("PVP ☠️")
local TabBossBtn = createTabBtn("BOSS LIST 👑")
local TabIslandBtn = createTabBtn("ISLAND 🏝️")
local TabFishingBtn = createTabBtn("FISHING 🎣")
local TabServerBtn = createTabBtn("SERVER 🌐")

TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
-- MD GAMER SCRIPT (Part 2 - Containers & Tab Switcher)
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

local BossContainer = Instance.new("ScrollingFrame")
BossContainer.Size = UDim2.new(1, -120, 1, -45)
BossContainer.Position = UDim2.new(0, 115, 0, 40)
BossContainer.BackgroundTransparency = 1
BossContainer.Visible = false
BossContainer.CanvasSize = UDim2.new(0, 0, 0, 350)
BossContainer.ScrollBarThickness = 3
BossContainer.Parent = MainFrame

local UIListLayoutBoss = Instance.new("UIListLayout")
UIListLayoutBoss.Parent = BossContainer
UIListLayoutBoss.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutBoss.Padding = UDim.new(0, 6)

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

local FishingContainer = Instance.new("ScrollingFrame")
FishingContainer.Size = UDim2.new(1, -120, 1, -45)
FishingContainer.Position = UDim2.new(0, 115, 0, 40)
FishingContainer.BackgroundTransparency = 1
FishingContainer.Visible = false
FishingContainer.CanvasSize = UDim2.new(0, 0, 0, 240)
FishingContainer.ScrollBarThickness = 3
FishingContainer.Parent = MainFrame

local UIListLayoutFishing = Instance.new("UIListLayout")
UIListLayoutFishing.Parent = FishingContainer
UIListLayoutFishing.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutFishing.Padding = UDim.new(0, 6)

local ServerContainer = Instance.new("ScrollingFrame")
ServerContainer.Size = UDim2.new(1, -120, 1, -45)
ServerContainer.Position = UDim2.new(0, 115, 0, 40)
ServerContainer.BackgroundTransparency = 1
ServerContainer.Visible = false
ServerContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
ServerContainer.ScrollBarThickness = 3
ServerContainer.Parent = MainFrame

local UIListLayoutServer = Instance.new("UIListLayout")
UIListLayoutServer.Parent = ServerContainer
UIListLayoutServer.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutServer.Padding = UDim.new(0, 6)

local function resetTabs()
    MainContainer.Visible = false
    PvpContainer.Visible = false
    BossContainer.Visible = false
    IslandContainer.Visible = false
    FishingContainer.Visible = false
    ServerContainer.Visible = false
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabPvpBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabPvpBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBossBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabBossBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabIslandBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabFishingBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabFishingBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabServerBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    TabServerBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
end

TabMainBtn.MouseButton1Click:Connect(function()
    resetTabs()
    MainContainer.Visible = true
    TabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabPvpBtn.MouseButton1Click:Connect(function()
    resetTabs()
    PvpContainer.Visible = true
    TabPvpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabPvpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabBossBtn.MouseButton1Click:Connect(function()
    resetTabs()
    BossContainer.Visible = true
    TabBossBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabBossBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabIslandBtn.MouseButton1Click:Connect(function()
    resetTabs()
    IslandContainer.Visible = true
    TabIslandBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabIslandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabFishingBtn.MouseButton1Click:Connect(function()
    resetTabs()
    FishingContainer.Visible = true
    TabFishingBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabFishingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

TabServerBtn.MouseButton1Click:Connect(function()
    resetTabs()
    ServerContainer.Visible = true
    TabServerBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    TabServerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
end)
-- MD GAMER SCRIPT (Part 3 - Boss List, Live HP & Cooldowns)
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

local activeBossFrames = {}
local bossCooldowns = {}

local trackedBossNames = {
    "The Gorilla King", "The Saw", "Bobby", "Yeti", "Mob Leader", "Vice Admiral",
    "Warden", "Chief Warden", "Swan", "Chief Petty Officer", "Fajita", "Smoke Admiral",
    "Awakened Ice Admiral", "Tide Keeper", "Don Swan", "Cursed Captain", "Darkbeard",
    "Order", "Awakened Diamond", "Cake Prince", "Dough King", "Rip_Indra", "Longma",
    "Beautiful Pirate", "Soul Reaper", "Tyrant", "Stone", "Island Boy", "Hydra Governor"
}

local function updateBossList()
    for _, frm in pairs(activeBossFrames) do
        if frm and frm.Parent then frm:Destroy() end
    end
    activeBossFrames = {}

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    local currentLiveBosses = {}

    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                if hum.MaxHealth > 4000 or string.find(enemy.Name, "Boss") or string.find(enemy.Name, "Captain") or string.find(enemy.Name, "Cursed") then
                    currentLiveBosses[enemy.Name] = {HRP = hrp, Humanoid = hum}
                    bossCooldowns[enemy.Name] = nil
                end
            end
        end
    end

    local totalHeight = 0
    local currentTime = tick()

    for _, bName in ipairs(trackedBossNames) do
        totalHeight = totalHeight + 42
        local bossFrame = Instance.new("Frame")
        bossFrame.Size = UDim2.new(1, -10, 0, 38)
        bossFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
        bossFrame.Parent = BossContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = bossFrame

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
        nameLabel.Position = UDim2.new(0, 10, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = bossFrame

        local actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(0.32, 0, 0.7, 0)
        actionBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
        actionBtn.Font = Enum.Font.GothamBold
        actionBtn.TextSize = 10
        actionBtn.Parent = bossFrame

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 5)
        btnCorner.Parent = actionBtn

        if currentLiveBosses[bName] then
            local bossData = currentLiveBosses[bName]
            nameLabel.Text = "👑 " .. bName .. "\n<font color=\"#00ffc8\">HP: " .. math.floor(bossData.Humanoid.Health) .. "</font>"
            nameLabel.RichText = true
            
            actionBtn.Text = "TP to Boss"
            actionBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            actionBtn.Active = true

            actionBtn.MouseButton1Click:Connect(function()
                if bossData.HRP and bossData.HRP.Parent then
                    flyTo(bossData.HRP.CFrame + Vector3.new(0, 5, 0))
                end
            end)
        else
            if not bossCooldowns[bName] then
                bossCooldowns[bName] = currentTime + 300
            end

            local remainingTime = math.floor(bossCooldowns[bName] - currentTime)
            if remainingTime < 0 then remainingTime = 0 end

            local mins = math.floor(remainingTime / 60)
            local secs = remainingTime % 60
            local timeFormatted = string.format("%d:%02d", mins, secs)

            nameLabel.Text = "⏳ " .. bName .. "\n<font color=\"#ff4444\">Respawn: " .. timeFormatted .. "</font>"
            nameLabel.RichText = true

            actionBtn.Text = "Respawning..."
            actionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            actionBtn.TextColor3 = Color3.fromRGB(150, 150, 170)
            actionBtn.Active = false
        end

        table.insert(activeBossFrames, bossFrame)
    end

    BossContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

task.spawn(function()
    while task.wait(1) do
        if BossContainer.Visible then
            pcall(updateBossList)
        end
    end
end)
-- MD GAMER SCRIPT (Part 4 - Fruit ESP, Notification, Fishing & Init)
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

-- Main ESP & Toggles
createToggleRow(MainContainer, "Fruit ESP", false, function(enabled)
    fruitESPEnabled = enabled
    updateFruitESP()
end)

createToggleRow(MainContainer, "Auto Fly Collect", false, function(enabled)
    autoCollectEnabled = enabled
end)

-- PVP Toggles
createToggleRow(PvpContainer, "Aimbot Nearest", false, function(enabled) aimbotNearestEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Mobs", false, function(enabled) ignoreMobsEnabled = enabled end)
createToggleRow(PvpContainer, "Ignore Players", false, function(enabled) ignorePlayersEnabled = enabled end)
createToggleRow(PvpContainer, "Kill Aura (No Anim)", false, function(enabled) killAuraEnabled = enabled end)

-- Fishing Toggles & Loops
local autoFishEnabled = false
local autoSellFishEnabled = false

createToggleRow(FishingContainer, "Auto Fish (Working)", false, function(enabled)
    autoFishEnabled = enabled
end)

createToggleRow(FishingContainer, "Auto Sell Fish", false, function(enabled)
    autoSellFishEnabled = enabled
end)

task.spawn(function()
    while task.wait(1.2) do
        if autoFishEnabled then
            pcall(function()
                local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                if commF then
                    commF:InvokeServer("FishBite")
                    task.wait(0.3)
                    commF:InvokeServer("CompleteFishingMiniGame", "Chest")
                    task.wait(0.2)
                    commF:InvokeServer("CompleteFishing", true)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(3) do
        if autoSellFishEnabled then
            pcall(function()
                local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
                if commF then commF:InvokeServer("SellAllFish") end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if autoCollectEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
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

Workspace.ChildAdded:Connect(function(obj)
    task.wait(0.5)
    if fruitESPEnabled then updateFruitESP() end
    checkFruitsForNotification(true)
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

sendNotification("🎮 MD GAMER SCRIPT", "Fully Loaded with Fruit ESP & Boss List!")
