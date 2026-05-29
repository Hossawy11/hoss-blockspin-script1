-- [[ HOSS MENU v4 - قايمة حوس المطور مع الـ Box ESP والـ FOV ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

-- حالات التشغيل الإفتراضية
_G.SilentAim = false
_G.EspInventory = false
_G.FovRadius = 100

-- إنشاء دائرة الـ FOV
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = false
FovCircle.Thickness = 1.5
FovCircle.Color = Color3.fromRGB(0, 255, 100)
FovCircle.Filled = false
FovCircle.Transparency = 0.8
FovCircle.Radius = _G.FovRadius

-- إنشاء الواجهة الرسومية (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HossMenuV4"
ScreenGui.Parent = game:CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.4, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 100)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "★ قايمة حوس V4 | BOX ESP ★"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local function CreateButton(text, pos, size, callback)
    local Button = Instance.new("TextButton")
    Button.Size = size or UDim2.new(0.9, 0, 0, 40)
    Button.Position = pos
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 15
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = MainFrame
    
    Button.MouseButton1Click:Connect(function()
        callback(Button)
    end)
    return Button
end

-- 1. زرار الـ Silent Aim
local SilentBtn = CreateButton("Silent Aim: OFF", UDim2.new(0.05, 0, 0.15, 0), nil, function(btn)
    _G.SilentAim = not _G.SilentAim
    FovCircle.Visible = _G.SilentAim
    if _G.SilentAim then
        btn.Text = "Silent Aim: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        btn.Text = "Silent Aim: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0.9, 0, 0, 25)
FovLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "حجم دائرة الـ FOV: " .. _G.FovRadius
FovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FovLabel.TextSize = 14
FovLabel.Font = Enum.Font.SourceSans
FovLabel.Parent = MainFrame

-- أزرار الفوف
local IncreaseFov = CreateButton("+ تكبير الفوف", UDim2.new(0.05, 0, 0.38, 0), UDim2.new(0.42, 0, 0, 35), function()
    if _G.FovRadius < 500 then
        _G.FovRadius = _G.FovRadius + 20
        FovCircle.Radius = _G.FovRadius
        FovLabel.Text = "حجم دائرة الـ FOV: " .. _G.FovRadius
    end
end)

local DecreaseFov = CreateButton("- تصغير الفوف", UDim2.new(0.53, 0, 0.38, 0), UDim2.new(0.42, 0, 0, 35), function()
    if _G.FovRadius > 20 then
        _G.FovRadius = _G.FovRadius - 20
        FovCircle.Radius = _G.FovRadius
        FovLabel.Text = "حجم دائرة الـ FOV: " .. _G.FovRadius
    end
end)

-- 2. زرار الـ Box & Inventory ESP
local EspBtn = CreateButton("Box ESP: OFF", UDim2.new(0.05, 0, 0.55, 0), nil, function(btn)
    _G.EspInventory = not _G.EspInventory
    if _G.EspInventory then
        btn.Text = "Box ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        btn.Text = "Box ESP: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- 3. زرار إغلاق القائمة
local CloseBtn = CreateButton("إغلاق القائمة (إخفاء)", UDim2.new(0.05, 0, 0.78, 0), nil, function()
    MainFrame.Visible = false
end)

-- زرار الفتح الخارجي
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 80, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "فتح حوس"
OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
OpenBtn.Parent = ScreenGui
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
end)

--- [[ نظام الـ Box ESP والـ Silent Aim البرمجي ]] ---

RunService.RenderStepped:Connect(function()
    FovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

local function getClosestPlayerInFov()
    local closestPlayer = nil
    local shortestDistance = _G.FovRadius
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- تعديل مسار الطلقات (Silent Aim)
local Namecall
Namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" or method == "Raycast") then
        local target = getClosestPlayerInFov()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            if method == "Raycast" then
                args[2] = (target.Character.Head.Position - args[1]).Unit * 1000
            else
                args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
            end
            return Namecall(self, unpack(args))
        end
    end
    return Namecall(self, ...)
end)

-- مصفوفة للاحتفاظ بالمربعات (Boxes) لكل لاعب
local Boxes = {}

local function CreateSquare()
    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Color = Color3.fromRGB(0, 255, 100) -- اللون الأخضر
    Box.Filled = false
    Box.Transparency = 1
    Box.Visible = false
    return Box
end

local function ClearBox(player)
    if Boxes[player] then
        if Boxes[player].Box then Boxes[player].Box:Destroy() end
        if Boxes[player].Text then Boxes[player].Text:Destroy() end
        Boxes[player] = nil
    end
end

-- ميكانيكية رسم المربع وتحديثه حول العدو
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.EspInventory and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local char = player.Character
                
                if not Boxes[player] then
                    Boxes[player] = {
                        Box = CreateSquare(),
                        Text = Drawing.new("Text")
                    }
                    Boxes[player].Text.Size = 14
                    Boxes[player].Text.Color = Color3.fromRGB(255, 255, 255)
                    Boxes[player].Text.Center = true
                    Boxes[player].Text.Outline = true
                    Boxes[player].Text.OutlineColor = Color3.fromRGB(0, 0, 0)
                end
                
                local box = Boxes[player].Box
                local text = Boxes[player].Text
                
                -- حساب زوايا المربع بناءً على مكان اللاعب وحجم جسمه
                local head = char.Head
                local hrp = char.HumanoidRootPart
                
                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    -- حساب الطول والعرض للمربع ليناسب حجم اللاعب حسب بعده وقربه
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 1.5
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(hrpPos.X - width / 2, hrpPos.Y - height / 2)
                    box.Visible = true
                    
                    -- تحديث بيانات الأسلحة والمسافة تحت المربع
                    local tool = char:FindFirstChildOfClass("Tool")
                    local weapon = tool and tool.Name or "قبضة اليد ✊"
                    local distance = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or 0)
                    
                    text.Position = Vector2.new(hrpPos.X, hrpPos.Y + (height / 2) + 5)
                    text.Text = string.format("%s\n[ سلاح: %s ]\n[ %d م ]", player.Name, weapon, distance)
                    text.Visible = true
                else
                    box.Visible = false
                    text.Visible = false
                end
            else
                ClearBox(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(ClearBox)
