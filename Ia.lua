-- HUB COM LOADING + TOGGLE
-- LocalScript | StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "BlackLoadingHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- FUNDO PRETO
local bg = Instance.new("Frame", gui)
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BorderSizePixel = 0

-- LOADING TEXTO
local loadingText = Instance.new("TextLabel", bg)
loadingText.Size = UDim2.new(0.4,0,0.08,0)
loadingText.Position = UDim2.new(0.3,0,0.45,0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextScaled = true
loadingText.Text = "Carregando... 0%"

-- LOADING BAR
local barBack = Instance.new("Frame", bg)
barBack.Size = UDim2.new(0.5,0,0.03,0)
barBack.Position = UDim2.new(0.25,0,0.55,0)
barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBack.BorderSizePixel = 0

local bar = Instance.new("Frame", barBack)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(0,170,255)
bar.BorderSizePixel = 0

-- LOADING (15s até 200%)
task.spawn(function()
	for i = 0,200 do
		bar.Size = UDim2.new(i/200,0,1,0)
		loadingText.Text = "Carregando... "..i.."%"
		task.wait(15/200)
	end

	bg:Destroy()
end)

-- HUB
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.fromOffset(200,120)
hub.Position = UDim2.new(0.5,-100,0.5,-60)
hub.BackgroundColor3 = Color3.fromRGB(20,20,20)
hub.Visible = false
hub.Active = true
hub.Draggable = true
hub.BorderSizePixel = 0

-- MOSTRAR HUB APÓS LOADING
task.delay(15, function()
	hub.Visible = true
end)

-- BOTÃO
local toggle = Instance.new("TextButton", hub)
toggle.Size = UDim2.new(0.8,0,0.5,0)
toggle.Position = UDim2.new(0.1,0,0.25,0)
toggle.Text = "OFF"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextScaled = true
toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BorderSizePixel = 0

-- ESTADO
local enabled = false

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled

	if enabled then
		toggle.Text = "ON"
		toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
		-- aqui você liga o que quiser (local)
	else
		toggle.Text = "OFF"
		toggle.BackgroundColor3 = Color3.fromRGB(170,0,0)
		-- aqui você desliga
	end
end)

-- ANTI-KICK BÁSICO (local)
pcall(function()
	local mt = getrawmetatable(game)
	setreadonly(mt,false)

	local old = mt.__namecall
	mt.__namecall = newcclosure(function(self,...)
		local method = getnamecallmethod()
		if method == "Kick" then
			return
		end
		return old(self,...)
	end)

	setreadonly(mt,true)
end)
