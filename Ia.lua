-- HUB DE ESTATÍSTICAS (SEM IA)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- BOTÃO +
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromScale(0.06,0.08)
openBtn.Position = UDim2.fromScale(0.02,0.4)
openBtn.Text = "+"
openBtn.TextScaled = true

-- HUB
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.fromScale(0.45,0.45)
hub.Position = UDim2.fromScale(0.28,0.25)
hub.BackgroundColor3 = Color3.fromRGB(25,25,25)
hub.Visible = false
hub.Active = true

-- HEADER
local header = Instance.new("Frame", hub)
header.Size = UDim2.fromScale(1,0.15)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(0.7,1)
title.Text = "ESTATÍSTICAS"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", header)
close.Size = UDim2.fromScale(0.15,1)
close.Position = UDim2.fromScale(0.85,0)
close.Text = "X"
close.TextScaled = true

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.fromScale(0.15,1)
minimize.Position = UDim2.fromScale(0.7,0)
minimize.Text = "-"
minimize.TextScaled = true

-- INPUT
local input = Instance.new("TextBox", hub)
input.Position = UDim2.fromScale(0.05,0.2)
input.Size = UDim2.fromScale(0.9,0.1)
input.PlaceholderText = "Digite 2 letras do nick"
input.BackgroundTransparency = 0.5
input.TextScaled = true

-- INFO
local info = Instance.new("TextLabel", hub)
info.Position = UDim2.fromScale(0.05,0.35)
info.Size = UDim2.fromScale(0.9,0.6)
info.TextWrapped = true
info.TextYAlignment = Enum.TextYAlignment.Top
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextScaled = true
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)

-- FUNÇÃO BUSCAR PLAYER
local function findPlayer(prefix)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Name:lower():sub(1,#prefix) == prefix then
			return plr
		end
	end
end

-- ATUALIZAR INFO
RunService.RenderStepped:Connect(function()
	local txt = input.Text:lower()
	if #txt < 2 then return end

	local target = findPlayer(txt)
	if not target or not target.Character then
		info.Text = "Player não encontrado."
		return
	end

	local hum = target.Character:FindFirstChildOfClass("Humanoid")
	local root = target.Character:FindFirstChild("HumanoidRootPart")
	local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

	local dist = (root and myRoot) and math.floor((root.Position - myRoot.Position).Magnitude) or 0

	info.Text =
		"Nick: "..target.Name..
		"\nDisplay: "..target.DisplayName..
		"\nUserId: "..target.UserId..
		"\nVida: "..(hum and math.floor(hum.Health) or "N/A")..
		"\nDistância: "..dist..
		"\nIdade da conta: "..target.AccountAge.." dias"..
		"\nTempo no server: "..math.floor(target:GetNetworkPing()*1000).." ms"
end)

-- BOTÕES
openBtn.MouseButton1Click:Connect(function()
	hub.Visible = true
	openBtn.Visible = false
end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	hub.Visible = false
	openBtn.Visible = true
end)
