-- HUB DE ESTATÍSTICAS - MOBILE FRIENDLY
-- LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "StatsHub"
gui.ResetOnSpawn = false

-- BOTÃO +
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(40,40)
openBtn.Position = UDim2.new(0,10,0.5,-20)
openBtn.Text = "+"
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.TextScaled = true
openBtn.BorderSizePixel = 0
openBtn.Visible = true

-- HUB
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(320,380)
frame.Position = UDim2.new(0.5,-160,0.5,-190)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- TOPO
local top = Instance.new("Frame", frame)
top.Size = UDim2.new(1,0,0,35)
top.BackgroundColor3 = Color3.fromRGB(35,35,35)
top.BorderSizePixel = 0

-- BOTÕES
local close = Instance.new("TextButton", top)
close.Text = "X"
close.Size = UDim2.fromOffset(35,35)
close.Position = UDim2.new(1,-35,0,0)
close.BackgroundColor3 = Color3.fromRGB(150,50,50)
close.TextColor3 = Color3.new(1,1,1)
close.BorderSizePixel = 0

local minimize = Instance.new("TextButton", top)
minimize.Text = "-"
minimize.Size = UDim2.fromOffset(35,35)
minimize.Position = UDim2.new(1,-70,0,0)
minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
minimize.TextColor3 = Color3.new(1,1,1)
minimize.BorderSizePixel = 0

-- TEXTBOX NICK
local box = Instance.new("TextBox", frame)
box.PlaceholderText = "Nick (2 primeiras letras)"
box.Size = UDim2.new(1,-20,0,35)
box.Position = UDim2.new(0,10,0,45)
box.BackgroundColor3 = Color3.fromRGB(30,30,30)
box.TextColor3 = Color3.new(1,1,1)
box.TextTransparency = 0.3
box.ClearTextOnFocus = false
box.BorderSizePixel = 0

-- SCROLL
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0,10,0,90)
scroll.Size = UDim2.new(1,-20,1,-100)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarImageTransparency = 0.2
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

-- FUNÇÃO DE TEXTO
local function add(text)
	local l = Instance.new("TextLabel", scroll)
	l.Size = UDim2.new(1,-10,0,24)
	l.BackgroundTransparency = 1
	l.TextWrapped = true
	l.TextXAlignment = Left
	l.TextColor3 = Color3.new(1,1,1)
	l.Text = text
	l.Font = Enum.Font.SourceSans
	l.TextSize = 14
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

-- BOTÃO COPIAR ID
local function copyId(id)
	if setclipboard then
		setclipboard(tostring(id))
	end
end

-- BUSCAR PLAYER
local function getPlayerByLetters(txt)
	txt = txt:lower()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Name:lower():sub(1,#txt) == txt then
			return plr
		end
	end
end

-- ATUALIZAR
local function update(plr)
	scroll:ClearAllChildren()
	layout.Parent = scroll

	if not plr.Character then return end
	local hum = plr.Character:FindFirstChildOfClass("Humanoid")
	local root = plr.Character:FindFirstChild("HumanoidRootPart")

	add("Nick: "..plr.Name)
	add("Display: "..plr.DisplayName)
	add("UserId: "..plr.UserId.." (copiado)")
	copyId(plr.UserId)

	add("Conta criada há: "..plr.AccountAge.." dias")

	if hum then
		add("Vida: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth))
		add("Velocidade: "..hum.WalkSpeed)
		add("Pulo: "..hum.JumpPower)
	end

	if root and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
		add("Distância até você: "..math.floor(dist))
	end

	add("Amigo seu: "..(player:IsFriendsWith(plr.UserId) and "Sim" or "Não"))

	-- Leaderstats
	if plr:FindFirstChild("leaderstats") then
		for _,v in pairs(plr.leaderstats:GetChildren()) do
			add(v.Name..": "..v.Value)
		end
	end
end

-- EVENTOS
box.FocusLost:Connect(function()
	if box.Text == "" then return end
	local plr = getPlayerByLetters(box.Text)
	if plr then
		update(plr)
	end
end)

openBtn.MouseButton1Click:Connect(function()
	openBtn.Visible = false
	frame.Visible = true
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)
