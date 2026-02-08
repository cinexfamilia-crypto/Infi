-- =========================
-- IA OFFLINE HUB (COMPLETO)
-- =========================

-- SERVIÇOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- =========================
-- MEMÓRIA DA IA
-- =========================
local memory = {
	history = {},
	words = {},
	preferencias = {},
	conhecimento = {
		["roblox"] = "Roblox é uma plataforma de criação de jogos.",
		["lua"] = "Lua é a linguagem usada no Roblox."
	}
}

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local hub = Instance.new("Frame", gui)
hub.Size = UDim2.fromScale(0.8,0.6)
hub.Position = UDim2.fromScale(0.1,0.2)
hub.BackgroundColor3 = Color3.fromRGB(20,20,20)
hub.Active = true

local header = Instance.new("Frame", hub)
header.Size = UDim2.fromScale(1,0.1)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "IA HUB OFFLINE"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

local chat = Instance.new("ScrollingFrame", hub)
chat.Position = UDim2.fromScale(0,0.1)
chat.Size = UDim2.fromScale(1,0.7)
chat.CanvasSize = UDim2.new(0,0,0,0)
chat.ScrollBarImageTransparency = 0.4
chat.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", chat)
layout.Padding = UDim.new(0,6)

local input = Instance.new("TextBox", hub)
input.Position = UDim2.fromScale(0.02,0.82)
input.Size = UDim2.fromScale(0.76,0.08)
input.PlaceholderText = "Digite algo..."
input.TextScaled = true
input.BackgroundColor3 = Color3.fromRGB(30,30,30)
input.TextColor3 = Color3.new(1,1,1)
input.ClearTextOnFocus = false

local send = Instance.new("TextButton", hub)
send.Position = UDim2.fromScale(0.8,0.82)
send.Size = UDim2.fromScale(0.18,0.08)
send.Text = "Enviar"
send.TextScaled = true
send.BackgroundColor3 = Color3.fromRGB(60,60,60)
send.TextColor3 = Color3.new(1,1,1)

-- BOTÕES
local clear = Instance.new("TextButton", hub)
clear.Position = UDim2.fromScale(0.02,0.92)
clear.Size = UDim2.fromScale(0.36,0.06)
clear.Text = "Limpar Chat"
clear.TextScaled = true

local reset = Instance.new("TextButton", hub)
reset.Position = UDim2.fromScale(0.42,0.92)
reset.Size = UDim2.fromScale(0.36,0.06)
reset.Text = "Resetar IA"
reset.TextScaled = true

-- =========================
-- CHAT
-- =========================
local function addMessage(text, isAI)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-10,0,0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.TextWrapped = true
	label.BackgroundTransparency = 1
	label.TextXAlignment = Left
	label.TextYAlignment = Top
	label.TextSize = 18

	if isAI then
		label.TextColor3 = Color3.fromRGB(0,200,255)
		label.Text = "IA: "..text
	else
		label.TextColor3 = Color3.new(1,1,1)
		label.Text = "Você: "..text
	end

	label.Parent = chat
	task.wait()
	chat.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
	chat.CanvasPosition = Vector2.new(0,chat.CanvasSize.Y.Offset)
end

-- =========================
-- IA
-- =========================
local function learn(msg)
	for word in msg:gmatch("%w+") do
		memory.words[word] = (memory.words[word] or 0) + 1
	end
end

local function think(msg)
	msg = msg:lower()
	table.insert(memory.history, msg)
	learn(msg)

	-- ENSINAR
	if msg:sub(1,8) == "aprenda " then
		local k,v = msg:match("aprenda (.+) = (.+)")
		if k and v then
			memory.conhecimento[k] = v
			return "Aprendi."
		end
	end

	-- PREFERÊNCIAS
	if msg:find("eu gosto de") then
		local g = msg:match("eu gosto de (.+)")
		if g then
			memory.preferencias["gosto"] = g
			return "Ok. Vou lembrar."
		end
	end

	-- RESPONDER CONHECIMENTO
	for k,v in pairs(memory.conhecimento) do
		if msg:find(k) then
			return v
		end
	end

	-- CONTEXTO
	if #memory.history > 1 then
		return "Você já falou disso antes. Continua."
	end

	return "Não sei ainda. Me ensina usando: aprenda pergunta = resposta"
end

-- =========================
-- EVENTOS
-- =========================
send.MouseButton1Click:Connect(function()
	if input.Text == "" then return end
	local msg = input.Text
	input.Text = ""
	addMessage(msg,false)
	task.wait(0.1)
	addMessage(think(msg),true)
end)

clear.MouseButton1Click:Connect(function()
	chat:ClearAllChildren()
	layout.Parent = chat
end)

reset.MouseButton1Click:Connect(function()
	memory = {
		history = {},
		words = {},
		preferencias = {},
		conhecimento = {}
	}
	addMessage("IA resetada.", true)
end)

-- =========================
-- DRAG (MOBILE + PC)
-- =========================
local dragging, dragStart, startPos

header.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = hub.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local d = i.Position - dragStart
		hub.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + d.X,
			startPos.Y.Scale, startPos.Y.Offset + d.Y
		)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
