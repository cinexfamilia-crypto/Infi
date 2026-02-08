-- =========================
-- IA HUB OFFLINE (PRO)
-- =========================

-- SERVIÇOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- DEBUG
warn("IA HUB INICIADO")

-- =========================
-- MEMÓRIA DA IA (SESSÃO)
-- =========================
local memory = {
	history = {},
	words = {},
	conhecimento = {
		["roblox"] = "Roblox é uma plataforma de criação de jogos.",
		["lua"] = "Lua é a linguagem usada no Roblox."
	}
}

-- =========================
-- GUI
-- =========================
local gui = Instance.new("ScreenGui")
gui.Name = "IAHubGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local hub = Instance.new("Frame")
hub.Parent = gui
hub.Size = UDim2.fromScale(0.8, 0.6)
hub.Position = UDim2.fromScale(0.1, 0.2)
hub.BackgroundColor3 = Color3.fromRGB(20,20,20)
hub.Active = true

local corner = Instance.new("UICorner", hub)
corner.CornerRadius = UDim.new(0,12)

-- HEADER
local header = Instance.new("Frame", hub)
header.Size = UDim2.fromScale(1,0.1)
header.BackgroundColor3 = Color3.fromRGB(35,35,35)

local hcorner = Instance.new("UICorner", header)
hcorner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.BackgroundTransparency = 1
title.Text = "IA HUB OFFLINE"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold

-- CHAT
local chat = Instance.new("ScrollingFrame", hub)
chat.Position = UDim2.fromScale(0,0.1)
chat.Size = UDim2.fromScale(1,0.7)
chat.CanvasSize = UDim2.new(0,0,0,0)
chat.ScrollBarImageTransparency = 0.3
chat.BackgroundTransparency = 1
chat.AutomaticCanvasSize = Enum.AutomaticSize.None

local layout = Instance.new("UIListLayout", chat)
layout.Padding = UDim.new(0,8)

-- INPUT
local input = Instance.new("TextBox", hub)
input.Position = UDim2.fromScale(0.02,0.82)
input.Size = UDim2.fromScale(0.76,0.08)
input.PlaceholderText = "Digite em português..."
input.Text = ""
input.TextScaled = true
input.ClearTextOnFocus = false
input.BackgroundColor3 = Color3.fromRGB(30,30,30)
input.TextColor3 = Color3.new(1,1,1)
input.Font = Enum.Font.Gotham

local icorner = Instance.new("UICorner", input)
icorner.CornerRadius = UDim.new(0,8)

-- BOTÃO ENVIAR
local send = Instance.new("TextButton", hub)
send.Position = UDim2.fromScale(0.8,0.82)
send.Size = UDim2.fromScale(0.18,0.08)
send.Text = "Enviar"
send.TextScaled = true
send.BackgroundColor3 = Color3.fromRGB(60,60,60)
send.TextColor3 = Color3.new(1,1,1)
send.Font = Enum.Font.GothamBold

local scorner = Instance.new("UICorner", send)
scorner.CornerRadius = UDim.new(0,8)

-- =========================
-- FUNÇÃO CHAT
-- =========================
local function addMessage(text, isAI)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-12,0,0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.TextWrapped = true
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextSize = 18
	label.Font = Enum.Font.Gotham

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
	chat.CanvasPosition = Vector2.new(0, math.max(0, chat.CanvasSize.Y.Offset - chat.AbsoluteWindowSize.Y))
end

-- =========================
-- IA OFFLINE
-- =========================
local function aprender(msg)
	for word in msg:gmatch("%w+") do
		memory.words[word] = (memory.words[word] or 0) + 1
	end
end

local function pensar(msg)
	msg = msg:lower()
	table.insert(memory.history, msg)
	aprender(msg)

	-- ENSINAR
	if msg:sub(1,8) == "aprenda " then
		local k,v = msg:match("aprenda (.+) = (.+)")
		if k and v then
			memory.conhecimento[k] = v
			return "Aprendi isso."
		end
	end

	-- RESPONDER CONHECIMENTO
	for k,v in pairs(memory.conhecimento) do
		if msg:find(k) then
			return v
		end
	end

	-- CONTEXTO SIMPLES
	if #memory.history > 1 then
		return "Entendi. Continua."
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
	addMessage(pensar(msg),true)
end)

-- ENTER NO PC
input.FocusLost:Connect(function(enter)
	if enter then
		send:Activate()
	end
end)

-- =========================
-- DRAG (MOBILE + PC)
-- =========================
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = i.Position
		startPos = hub.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = i.Position - dragStart
		hub.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- MENSAGEM INICIAL
addMessage("Olá. Sou uma IA offline. Pode falar.", true)
