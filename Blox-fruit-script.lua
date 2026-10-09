-- Combined Blox Fruit Helper (Clean Main/ESP + Auto Sea Islands)
local P, W, T, L, CG = game:GetService("Players"), game:GetService("Workspace"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("CoreGui")
local LP = P.LocalPlayer

-- Remove Old UI if exists
if CG:FindFirstChild("HoHoMainUI") then
    CG.HoHoMainUI:Destroy()
end

local flags = {fruitESP = false, playerESP = false, autoCollect = false, fpsBoost = false}
local fESP, pESP, origL = {}, {}, {Shadows = L.GlobalShadows, FogEnd = L.FogEnd}

-- Island Teleport Data (1st, 2nd, 3rd Sea)
local SeaIslands = {
    [2753915549] = {{"Starter Island", Vector3.new(1095,16,1425)},{"Jungle", Vector3.new(-1612,37,148)},{"Pirate Village", Vector3.new(-1135,5,3828)},{"Desert", Vector3.new(1093,6,4373)},{"Middle Town", Vector3.new(-655,8,1510)},{"Frozen Village", Vector3.new(1185,27,-1325)},{"Marine Ford", Vector3.new(-4805,21,4280)},{"Prison", Vector3.new(4850,6,735)},{"Colosseum", Vector3.new(-1430,7,-2750)},{"Magma Village", Vector3.new(-5250,9,8500)},{"Underwater City", Vector3.new(3860,5,-1925)},{"Skypiea 1", Vector3.new(-4880,718,-2630)},{"Skypiea 2", Vector3.new(-7860,5545,-380)},{"Fountain City", Vector3.new(5120,4,4100)}},
    [4442206426] = {{"Cafe", Vector3.new(-380,73,2950)},{"Usoap Island", Vector3.new(4800,8,2850)},{"Green Zone", Vector3.new(-2400,73,-3200)},{"Graveyard", Vector3.new(-5400,8,-700)},{"Snow Mountain", Vector3.new(600,400,-5300)},{"Hot & Cold", Vector3.new(-6000,15,-5000)},{"Cursed Ship", Vector3.new(900,125,33000)},{"Ice Castle", Vector3.new(5500,28,-6200)},{"Forgotten Island", Vector3.new(-3050,235,-10150)},{"Dark Arena", Vector3.new(3800,12,-3500)}},
    [7449423635] = {{"Port Town", Vector3.new(-2900,15,5300)},{"Hydra Island", Vector3.new(5700,600,200)},{"Great Tree", Vector3.new(2200,25,-7200)},{"Floating Turtle", Vector3.new(-13200,330,-7600)},{"Castle on Sea", Vector3.new(-5000,300,-3000)},{"Haunted Castle", Vector3.new(-9500,140,5500)},{"Sea of Treats", Vector3.new(-2100,60,-12200)}}
}

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "HoHoMainUI"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or CG

local notifHolder = Instance.new("Frame", gui)
notifHolder.Size, notifHolder.Position, notifHolder.BackgroundTransparency = UDim2.new(0, 180, 0, 200), UDim2.new(1, -190, 0, 10), 1
Instance.new("UIListLayout", notifHolder).Padding = UDim.new(0, 5)

local function sendNotif(t, txt)
    local f = Instance.new("Frame", notifHolder)
    f.Size, f.BackgroundColor3 = UDim2.new(1, 0, 0, 36), Color3.fromRGB(15, 15, 26)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l1 = Instance.new("TextLabel", f)
    l1.Size, l1.Position, l1.Text, l1.TextColor3, l1.Font, l1.TextSize = UDim2.new(1, -8, 0, 16), UDim2.new(0, 6, 0, 2), t, Color3.fromRGB(0, 170, 255), Enum.Font.GothamBold, 11
    local l2 = Instance.new("TextLabel", f)
    l2.Size, l2.Position, l2.Text, l2.TextColor3, l2.Font, l2.TextSize = UDim2.new(1, -8, 0, 16), UDim2.new(0, 6, 0, 18), txt, Color3.fromRGB(220, 220, 220), Enum.Font.Gotham, 10
    task.spawn(function() task.wait(3) f:Destroy() end)
end

-- Open/Close Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size, toggleBtn.Position, toggleBtn.Text, toggleBtn.BackgroundColor3 = UDim2.new(0, 45, 0, 45), UDim2.new(0.02, 0, 0.2, 0), "HOHO", Color3.fromRGB(15, 15, 26)
toggleBtn.TextColor3, toggleBtn.Font, toggleBtn.TextSize = Color3.fromRGB(0, 170, 255), Enum.Font.GothamBold, 11
toggleBtn.Active, toggleBtn.Draggable = true, true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Color, btnStroke.Thickness = Color3.fromRGB(0, 170, 255), 2

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size, main.Position, main.Visible, main.Active, main.Draggable = UDim2.new(0, 410, 0, 260), UDim2.new(0.3, 0, 0.3, 0), false, true, true
main.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", main)
title.Size, title.Text, title.TextColor3, title.RichText = UDim2.new(1, -10, 0, 32), " HOHO HUB <font color=\"#00ffff\">[Blox Fruit]</font>", Color3.fromRGB(255, 255, 255), true
title.Font, title.TextSize, title.TextXAlignment = Enum.Font.GothamBold, 13, Enum.TextXAlignment.Left

-- Sidebar & Tabs
local sidebar = Instance.new("Frame", main)
sidebar.Size, sidebar.Position, sidebar.BackgroundColor3 = UDim2.new(0, 100, 1, -32), UDim2.new(0, 0, 0, 32), Color3.fromRGB(18, 18, 28)
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 5)

local container = Instance.new("Frame", main)
container.Size, container.Position, container.BackgroundTransparency = UDim2.new(1, -110, 1, -38), UDim2.new(0, 105, 0, 35), 1

local mainTab = Instance.new("ScrollingFrame", container)
mainTab.Size, mainTab.BackgroundTransparency, mainTab.ScrollBarThickness, mainTab.Visible = UDim2.new(1, 0, 1, 0), 1, 2, true
Instance.new("UIListLayout", mainTab).Padding = UDim.new(0, 6)

local islandsTab = Instance.new("ScrollingFrame", container)
islandsTab.Size, islandsTab.BackgroundTransparency, islandsTab.ScrollBarThickness, islandsTab.Visible = UDim2.new(1, 0, 1, 0), 1, 2, false
Instance.new("UIListLayout", islandsTab).Padding = UDim.new(0, 6)

toggleBtn.MouseButton1Click:Connect(function() 
    main.Visible = not main.Visible 
end)

local function makeTabBtn(txt, isMain)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size, btn.Text, btn.Font, btn.TextSize = UDim2.new(0.92, 0, 0, 30), txt, Enum.Font.GothamBold, 11
    btn.BackgroundColor3 = isMain and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(28, 28, 40)
    btn.TextColor3 = isMain and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local b1 = makeTabBtn("Main / ESP", true)
local b2 = makeTabBtn("Islands", false)

b1.MouseButton1Click:Connect(function()
    mainTab.Visible, islandsTab.Visible = true, false
    b1.BackgroundColor3, b2.BackgroundColor3 = Color3.fromRGB(0, 170, 255), Color3.fromRGB(28, 28, 40)
end)

b2.MouseButton1Click:Connect(function()
    mainTab.Visible, islandsTab.Visible = false, true
    b2.BackgroundColor3, b1.BackgroundColor3 = Color3.fromRGB(0, 170, 255), Color3.fromRGB(28, 28, 40)
end)

-- Toggle Builder
local function addToggle(txt, parent, callback)
    local f = Instance.new("Frame", parent)
    f.Size, f.BackgroundColor3 = UDim2.new(1, -6, 0, 38), Color3.fromRGB(22, 22, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position, lbl.Text, lbl.TextColor3 = UDim2.new(0.65, 0, 1, 0), UDim2.new(0, 8, 0, 0), txt, Color3.fromRGB(220, 220, 220)
    lbl.Font, lbl.TextSize, lbl.TextXAlignment = Enum.Font.GothamSemibold, 11, Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", f)
    btn.Size, btn.Position, btn.Text, btn.BackgroundColor3 = UDim2.new(0.28, 0, 0.65, 0), UDim2.new(0.68, 0, 0.175, 0), "OFF", Color3.fromRGB(40, 40, 55)
    btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(180, 180, 180), Enum.Font.GothamBold, 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local st = false
    btn.MouseButton1Click:Connect(function()
        st = not st
        btn.Text = st and "ON" or "OFF"
        btn.BackgroundColor3 = st and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 55)
        btn.TextColor3 = st and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        callback(st)
    end)
end

-- ESP Helper Logic
local function isFruit(o)
    return (o:IsA("Tool") or string.find(o.Name, "Fruit")) and (o:FindFirstChild("Handle") or o:FindFirstChildOfClass("BasePart"))
end

local function updateFruitESP()
    for _, v in ipairs(fESP) do if v then v:Destroy() end end
    fESP = {}
    if not flags.fruitESP then return end
    for _, obj in ipairs(W:GetChildren()) do
        if isFruit(obj) then
            local h = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if h then
                local hl = Instance.new("Highlight", obj)
                hl.FillColor = Color3.fromRGB(0, 170, 255)
                table.insert(fESP, hl)

                local bb = Instance.new("BillboardGui", h)
                bb.Size, bb.AlwaysOnTop, bb.StudsOffset = UDim2.new(0, 120, 0, 25), true, Vector3.new(0, 2, 0)
                local tx = Instance.new("TextLabel", bb)
                tx.Size, tx.BackgroundTransparency, tx.Text, tx.TextColor3 = UDim2.new(1,0,1,0), 1, "Fruit: " .. obj.Name, Color3.fromRGB(0, 255, 200)
                tx.Font, tx.TextSize = Enum.Font.GothamBold, 12
                table.insert(fESP, bb)
            end
        end
    end
end

-- Toggles In Main/ESP
addToggle("Fruit ESP", mainTab, function(v) flags.fruitESP = v updateFruitESP() end)
addToggle("Player ESP", mainTab, function(v) flags.playerESP = v end)
addToggle("Auto Collect", mainTab, function(v) flags.autoCollect = v end)
addToggle("FPS Boost", mainTab, function(v)
    flags.fpsBoost = v
    L.GlobalShadows = not v
    L.FogEnd = v and 9e9 or origL.FogEnd
    if v then sendNotif("FPS Boost", "Effects Disabled!") end
end)

-- Auto Detect Current Sea & Load Its Islands
local curSeaIslands = SeaIslands[game.PlaceId] or SeaIslands[2753915549]
for _, data in ipairs(curSeaIslands) do
    local f = Instance.new("Frame", islandsTab)
    f.Size, f.BackgroundColor3 = UDim2.new(1, -6, 0, 38), Color3.fromRGB(22, 22, 35)
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size, lbl.Position, lbl.Text, lbl.TextColor3 = UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 8, 0, 0), data[1], Color3.fromRGB(220, 220, 220)
    lbl.Font, lbl.TextSize, lbl.TextXAlignment = Enum.Font.GothamSemibold, 11, Enum.TextXAlignment.Left

    local tp = Instance.new("TextButton", f)
    tp.Size, tp.Position, tp.Text, tp.BackgroundColor3 = UDim2.new(0.32, 0, 0.65, 0), UDim2.new(0.64, 0, 0.175, 0), "Teleport", Color3.fromRGB(0, 170, 255)
    tp.TextColor3, tp.Font, tp.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.GothamBold, 10
    Instance.new("UICorner", tp).CornerRadius = UDim.new(0, 4)

    tp.MouseButton1Click:Connect(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(data[2] + Vector3.new(0, 5, 0))
            sendNotif("Teleported", data[1])
        end
    end)
end

W.ChildAdded:Connect(function()
    task.wait(0.5)
    if flags.fruitESP then updateFruitESP() end
end)
