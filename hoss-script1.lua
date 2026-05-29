-- [[ HOSS MENU v3 - قايمة حوس المطور مع الـ Skeleton ESP والـ FOV ]] --
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
ScreenGui.Name = "HossMenuV3"
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
Title.Text = "★ قايمة حوس V3 | SKELETON ★"
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

-- 2. زرار الـ Skeleton & Inventory ESP
local EspBtn = CreateButton("Skeleton ESP: OFF", UDim2.new(0.05, 0, 0.55, 0), nil, function(btn)
    _G.EspInventory = not _G.EspInventory
    if _G.EspInventory then
        btn.Text = "Skeleton ESP: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        btn.Text = "Skeleton ESP: OFF"
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

--- [[ نظام الـ Skeleton ESP والـ Silent Aim البرمجي ]] ---

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

-- تعديل مسار الطلقات
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

-- مصفوفة للاحتفاظ بخطوط الهيكل العظمي لكل لاعب
local Skeletons = {}

local function CreateLine()
    local Line = Drawing.new("Line")
    Line.Thickness = 2
    Line.Color = Color3.fromRGB(0, 255, 100) -- اللون الأخضر الفوسفوري
    Line.Transparency = 1
    Line.Visible = false
    return Line
end

local function ClearSkeleton(player)
    if Skeletons[player] then
        for _, line in pairs(Skeletons[player].Lines) do
            line:Destroy()
        end
        if Skeletons[player].Text then
            Skeletons[player].Text:Destroy()
        end
        Skeletons[player] = nil
    end
end

-- ميكانيكية رسم وتحديث الهيكل العظمي مع الحركة
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if _G.EspInventory and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local char = player.Character
                
                -- تجهيز الخطوط لو مش موجودة
                if not Skeletons[player] then
                    Skeletons[player] = {
                        Lines = {
                            HeadToTorso = CreateLine(),
                            LeftArm = CreateLine(),
                            RightArm = CreateLine(),
                            LeftLeg = CreateLine(),
                            RightLeg = CreateLine(),
                            Spine = CreateLine()
                        },
                        Text = Drawing.new("Text")
                    }
                    Skeletons[player].Text.Size = 14
                    Skeletons[player].Text.Color = Color3.fromRGB(255, 255, 255)
                    Skeletons[player].Text.Center = true
                    Skeletons[player].Text.Outline = true
                    Skeletons[player].Text.OutlineColor = Color3.fromRGB(0, 0, 0)
                end
                
                local lines = Skeletons[player].Lines
                local text = Skeletons[player].Text
                
                -- تحديد المفاصل حسب نوع الشخصية R6 أو R15
                local head = char:FindFirstChild("Head")
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                local leftShoulder = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rightShoulder = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local leftHip = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rightHip = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                local lowerTorso = char:FindFirstChild("LowerTorso") or torso
                
                if head and torso and leftShoulder and rightShoulder and leftHip and rightHip then
                    -- تحويل الإحداثيات من العالم الافتراضي إلى الشاشة
                    local headPos, headOn = Camera:WorldToViewportPoint(head.Position)
                    local torsoPos, torsoOn = Camera:WorldToViewportPoint(torso.Position)
                    local leftArmPos, leftArmOn = Camera:WorldToViewportPoint(leftShoulder.Position)
                    local rightArmPos, rightArmOn = Camera:WorldToViewportPoint(rightShoulder.Position)
                    local leftLegPos, leftLegOn = Camera:WorldToViewportPoint(leftHip.Position)
                    local rightLegPos, rightLegOn = Camera:WorldToViewportPoint(rightHip.Position)
                    local bTorsoPos, bTorsoOn = Camera:WorldToViewportPoint(lowerTorso.Position)
                    
                    if headOn or torsoOn then
                        -- رسم الخطوط وتوصيل المفاصل ببعضها
                        lines.HeadToTorso.From = Vector2.new(headPos.X, headPos.Y)
                        lines.HeadToTorso.To = Vector2.new(torsoPos.X, torsoPos.Y)
                        lines.HeadToTorso.Visible = true
                        
                        lines.Spine.From = Vector2.new(torsoPos.X, torsoPos.Y)
                        lines.Spine.To = Vector2.new(bTorsoPos.X, bTorsoPos.Y)
                        lines.Spine.Visible = true
                        
                        lines.LeftArm.From = Vector2.new(torsoPos.X, torsoPos.Y)
                        lines.LeftArm.To = Vector2.new(leftArmPos.X, leftArmPos.Y)
                        lines.LeftArm.Visible = true
                        
                        lines.RightArm.From = Vector2.new(torsoPos.X, torsoPos.Y)
                        lines.RightArm.To = Vector2.new(rightArmPos.X, rightArmPos.Y)
                        lines.RightArm.Visible = true
                        
                        lines.LeftLeg.From = Vector2.new(bTorsoPos.X, bTorsoPos.Y)
                        lines.LeftLeg.To = Vector2.new(leftLegPos.X, leftLegPos.Y)
                        lines.LeftLeg.Visible = true
                        
                        lines.RightLeg.From = Vector2.new(bTorsoPos.X, bTorsoPos.Y)
                        lines.RightLeg.To = Vector2.new(rightLegPos.X, rightLegPos.Y)
                        lines.RightLeg.Visible = true
                        
                        -- تحديث نص السلاح والمسافة والاسم تحت الهيكل العظمي
                        local tool = char:FindFirstChildOfClass("Tool")
                        local weapon = tool and tool.Name or "قبضة اليد ✊"
                        local distance = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) or 0)
                        
                        text.Position = Vector2.new(bTorsoPos.X, bTorsoPos.Y + 20)
                        text.Text = string.format("%s\n[ سلاح: %s ]\n[ %d م ]", player.Name, weapon, distance)
                        text.Visible = true
                    else
                        -- إخفاء الخطوط لو اللاعب برة الشاشة
                        for _, line in pairs(lines) do line.Visible = false end
                        text.Visible = false
                    end
                else
                    for _, line in pairs(lines) do line.Visible = false end
                    text.Visible = false
                end
            else
                ClearSkeleton(player)
            end
        end
    end
end)

-- تنظيف البيانات لو لاعب خرج من السيرفر
Players.PlayerRemoving:Connect(ClearSkeleton)
