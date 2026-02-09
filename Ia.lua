local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ========= FUNÇÃO DE DRAG MOBILE =========
local function enableDrag(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ========= GUI BASE =========
local gui = Instance.new("ScreenGui")
gui.Name = "FantasmaHub"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local function criarAba(titulo, pos)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromOffset(220,120)
    frame.Position = pos
    frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    frame.BorderSizePixel = 0
    frame.Active = true

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.Text = titulo
    title.TextColor3 = Color3.fromRGB(200,200,200)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    enableDrag(frame)
    return frame
end

-- ========= WALK SPEED =========
local wsValue = 16

local wsFrame = criarAba("WalkSpeed", UDim2.fromScale(0.1,0.25))

local wsBox = Instance.new("TextBox", wsFrame)
wsBox.Size = UDim2.fromOffset(180,40)
wsBox.Position = UDim2.fromOffset(20,50)
wsBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
wsBox.TextColor3 = Color3.new(1,1,1)
wsBox.PlaceholderText = "fantasma"
wsBox.ClearTextOnFocus = false
wsBox.Font = Enum.Font.Gotham
wsBox.TextSize = 14

wsBox.FocusLost:Connect(function()
    local v = tonumber(wsBox.Text)
    if v then wsValue = v end
end)

-- ========= SUPER JUMP =========
local jumpValue = 50

local jumpFrame = criarAba("Super Jump", UDim2.fromScale(0.4,0.25))

local jumpBox = Instance.new("TextBox", jumpFrame)
jumpBox.Size = UDim2.fromOffset(180,40)
jumpBox.Position = UDim2.fromOffset(20,50)
jumpBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.PlaceholderText = "fantasma"
jumpBox.ClearTextOnFocus = false
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextSize = 14

jumpBox.FocusLost:Connect(function()
    local v = tonumber(jumpBox.Text)
    if v then jumpValue = v end
end)

-- ========= NOCLIP =========
local noclip = false

local noclipFrame = criarAba("Noclip", UDim2.fromScale(0.7,0.25))

local noclipBtn = Instance.new("TextButton", noclipFrame)
noclipBtn.Size = UDim2.fromOffset(180,40)
noclipBtn.Position = UDim2.fromOffset(20,50)
noclipBtn.Text = "OFF"
noclipBtn.Font = Enum.Font.GothamBold
noclipBtn.TextSize = 16
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        noclipBtn.Text = "OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    end
end)

-- ========= LOOP ANTI-RESET =========
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = wsValue
        hum.JumpPower = jumpValue
    end

    if noclip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)
