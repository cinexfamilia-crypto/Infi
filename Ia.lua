-- LOCAL SCRIPT

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- HUB FRAME
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.fromScale(0.8, 0.6)
hub.Position = UDim2.fromScale(0.1, 0.2)
hub.BackgroundColor3 = Color3.fromRGB(25,25,25)
hub.BorderSizePixel = 0
hub.Active = true
hub.Draggable = false

-- HEADER
local header = Instance.new("Frame", hub)
header.Size = UDim2.fromScale(1, 0.1)
header.BackgroundColor3 = Color3.fromRGB(40,40,40)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.fromScale(1,1)
title.Text = "IA HUB"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

-- CHAT AREA
local chat = Instance.new("ScrollingFrame", hub)
chat.Position = UDim2.fromScale(0,0.1)
chat.Size = UDim2.fromScale(1,0.75)
chat.CanvasSize = UDim2.new(0,0,0,0)
chat.ScrollBarImageTransparency = 0.3
chat.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", chat)
layout.Padding = UDim.new(0,8)

-- INPUT
local input = Instance.new("TextBox", hub)
input.Position = UDim2.fromScale(0.02,0.87)
input.Size = UDim2.fromScale(0.76,0.1)
input.PlaceholderText = "Digite aqui..."
input.Text = ""
input.TextColor3 = Color3.new(1,1,1)
input.BackgroundColor3 = Color3.fromRGB(35,35,35)
input.TextScaled = true

local send = Instance.new("TextButton", hub)
send.Position = UDim2.fromScale(0.8,0.87)
send.Size = UDim2.fromScale(0.18,0.1)
send.Text = "Enviar"
send.TextScaled = true
send.BackgroundColor3 = Color3.fromRGB(60,60,60)
send.TextColor3 = Color3.new(1,1,1)

-- FUNÇÃO DE MENSAGEM
local function addMessage(text, fromAI)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-10,0,0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.TextWrapped = true
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.TextScaled = false
	label.TextSize = 18
	label.BackgroundTransparency = 1

	if fromAI then
		label.TextColor3 = Color3.fromRGB(0,200,255)
		label.Text = "IA: "..text
	else
		label.TextColor3 = Color3.new(1,1,1)
		label.Text = "Você: "..text
	end

	label.Parent = chat
	task.wait()
	chat.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
	chat.CanvasPosition = Vector2.new(0, chat.CanvasSize.Y.Offset)
end

-- CHAMADA IA (EXEMPLO)
local function askAI(prompt)
	-- EXEMPLO DE PAYLOAD
	local data = {
		model = "gpt-3.5-turbo",
		messages = {
			{role="user", content=prompt}
		}
	}

	local headers = {
		["Content-Type"] = "application/json",
		["Authorization"] = "Bearer SUA_API_KEY_AQUI"
	}

	local success, response = pcall(function()
		return HttpService:PostAsync(
			"https://api.openai.com/v1/chat/completions",
			HttpService:JSONEncode(data),
			Enum.HttpContentType.ApplicationJson,
			false,
			headers
		)
	end)

	if success then
		local decoded = HttpService:JSONDecode(response)
		return decoded.choices[1].message.content
	else
		return "Erro ao conectar na IA."
	end
end

-- BOTÃO
send.MouseButton1Click:Connect(function()
	if input.Text == "" then return end
	local msg = input.Text
	input.Text = ""

	addMessage(msg,false)

	task.spawn(function()
		local resposta = askAI(msg)
		addMessage(resposta,true)
	end)
end)

-- DRAG MOBILE
local dragging = false
local dragStart, startPos

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = hub.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		hub.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
