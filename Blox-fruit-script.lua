-- Blox Fruit Helper Script (HoHo Hub Style UI)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Global States
local autoCollectEnabled = false
local fruitESPEnabled = false
local fpsBoostEnabled = false

local fruitESPObjects = {}
local notifiedFruits = {}

-- Store original settings for FPS Boost toggle off
local originalLightingSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

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
        task.wait(4)
        local fadeTween = TweenService:Create(notifFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1})
        TweenService:Create(titleLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(textLabel, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
        fadeTween:Play()
        fadeTween.Completed:Wait()
        notifFrame:Destroy()
    end)
end

-- Smooth & Safe Dragging Function
local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Floating Open/Close Icon
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "OpenButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
ToggleButton.Active = true
ToggleButton.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ToggleButton

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Color = Color3.fromRGB(0, 170, 255)
UIStrokeBtn.Thickness = 1.5
UIStrokeBtn.Parent = ToggleButton

makeDraggable(ToggleButton)

-- Main Frame UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 26)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 8)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(0, 170, 255)
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = MainFrame

makeDraggable(MainFrame)

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Blox Fruit Helper"
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Container for Toggles
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -40)
Container.Position = UDim2.new(0, 10, 0, 35)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayoutContainer = Instance.new("UIListLayout")
UIListLayoutContainer.Parent = Container
UIListLayoutContainer.Padding = UDim.new(0, 6)

local function createToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    btn.Parent = Container

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.TextColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(200, 200, 200)
        callback(state)
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Auto Collect Fruit
createToggle("Auto Collect Fruit", function(enabled)
    autoCollectEnabled = enabled
    if enabled then
        task.spawn(function()
            while autoCollectEnabled do
                task.wait(1)
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if autoCollectEnabled and obj:IsA("Tool") and string.find(obj.Name, "Fruit") then
                        local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
                        if handle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = handle.CFrame
                        end
                    end
                end
            end
        end)
    end
end)

-- Fruit ESP & Spawn Notification Tracker
createToggle("Fruit ESP", function(enabled)
    fruitESPEnabled = enabled
    if not enabled then
        for _, items in pairs(fruitESPObjects) do
            if type(items) == "table" then
                for _, element in ipairs(items) do
                    if element then element:Destroy() end
                end
            end
        end
        fruitESPObjects = {}
    else
        task.spawn(function()
            while fruitESPEnabled do
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj:IsA("Tool") and string.find(obj.Name, "Fruit") then
                        
                        -- Send Corner Notification when new fruit spawns/drops
                        if not notifiedFruits[obj] then
                            notifiedFruits[obj] = true
                            sendNotification("Fruit Spawned!", obj.Name .. " is now available!")
                        end

                        -- Add ESP Highlight + Name Label
                        if not fruitESPObjects[obj] then
                            local createdElements = {}

                            -- 1. Glow Highlight
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(0, 170, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.Parent = obj
                            table.insert(createdElements, highlight)

                            -- 2. Fruit Name Billboard Label (ESP)
                            local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("Part")
                            if handle then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Adornee = handle
                                billboard.Size = UDim2.new(0, 140, 0, 30)
                                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                                billboard.AlwaysOnTop = true
                                billboard.Parent = handle

                                local textLabel = Instance.new("TextLabel")
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.Text = obj.Name
                                textLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
                                textLabel.TextStrokeTransparency = 0
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextSize = 12
                                textLabel.Parent = billboard

                                table.insert(createdElements, billboard)
                            end

                            fruitESPObjects[obj] = createdElements
                        end
                    end
                end
                task.wait(1.5)
            end
        end)
    end
end)

-- FPS Boost
createToggle("FPS Boost", function(enabled)
    fpsBoostEnabled = enabled
    if enabled then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    else
        Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
        Lighting.FogEnd = originalLightingSettings.FogEnd
        Lighting.FogStart = originalLightingSettings.FogStart
    end
end)

sendNotification("Blox Fruit Helper", "Loaded successfully!")
