-- LocalScript

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ====== ESTADO ======
local nextHasGravity = true -- gravidade do próximo objeto

-- ====== GUI ======
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ShapeHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.35, 0.35)
frame.Position = UDim2.fromScale(0.325, 0.325)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local sizeBox = Instance.new("TextBox", frame)
sizeBox.Size = UDim2.fromScale(0.9, 0.2)
sizeBox.Position = UDim2.fromScale(0.05, 0.05)
sizeBox.PlaceholderText = "Tamanho (ex: 5)"
sizeBox.Text = "5"
sizeBox.TextScaled = true

local cubeBtn = Instance.new("TextButton", frame)
cubeBtn.Size = UDim2.fromScale(0.4, 0.2)
cubeBtn.Position = UDim2.fromScale(0.05, 0.3)
cubeBtn.Text = "CUBO"
cubeBtn.TextScaled = true

local ballBtn = Instance.new("TextButton", frame)
ballBtn.Size = UDim2.fromScale(0.4, 0.2)
ballBtn.Position = UDim2.fromScale(0.55, 0.3)
ballBtn.Text = "CÍRCULO"
ballBtn.TextScaled = true

local gravBtn = Instance.new("TextButton", frame)
gravBtn.Size = UDim2.fromScale(0.9, 0.2)
gravBtn.Position = UDim2.fromScale(0.05, 0.6)
gravBtn.TextScaled = true

local function updateGravText()
	gravBtn.Text = nextHasGravity and "GRAVIDADE: ON (próximo)" or "GRAVIDADE: OFF (próximo)"
end
updateGravText()

-- ====== FUNÇÕES ======
local function applyNoGravity(part)
	local bf = Instance.new("BodyForce")
	bf.Force = Vector3.new(0, part:GetMass() * workspace.Gravity, 0)
	bf.Parent = part
end

local function getSize()
	local n = tonumber(sizeBox.Text)
	if not n or n <= 0 then
		return 5
	end
	return math.clamp(n, 1, 100)
end

local function spawnShape(isBall)
	local size = getSize()

	local part = Instance.new("Part")
	part.Size = Vector3.new(size, size, size)
	part.Position = hrp.Position + hrp.CFrame.LookVector * 6 + Vector3.new(0,5,0)
	part.Anchored = false
	part.CanCollide = true
	part.Parent = workspace

	if isBall then
		part.Shape = Enum.PartType.Ball
	end

	if not nextHasGravity then
		applyNoGravity(part)
	end
end

-- ====== BOTÕES ======
cubeBtn.MouseButton1Click:Connect(function()
	spawnShape(false)
end)

ballBtn.MouseButton1Click:Connect(function()
	spawnShape(true)
end)

gravBtn.MouseButton1Click:Connect(function()
	nextHasGravity = not nextHasGravity
	updateGravText()
end)
