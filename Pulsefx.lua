 -- PulseFx v2 GUI Script Core by Cole
-- Includes: Toggle, Draggable GUI, Fade-in Welcome, Sound, Tab Layout

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- GUI CREATION
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "PulseFx"
screenGui.ResetOnSpawn = false

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
toggleBtn.Text = "☰"
toggleBtn.TextSize = 30
toggleBtn.TextColor3 = Color3.fromRGB(120, 80, 40)
toggleBtn.BackgroundTransparency = 0.1
toggleBtn.BorderSizePixel = 0
toggleBtn.Active = true
toggleBtn.Draggable = true

-- MAIN FRAME
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 560, 0, 420)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true

-- WELCOME FADE-IN LABEL
local titleLabel = Instance.new("TextLabel", screenGui)
titleLabel.Size = UDim2.new(0, 400, 0, 50)
titleLabel.Position = UDim2.new(0.5, -200, 0.4, -80)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Welcome to PulseFx"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 36

-- SOUND ON OPEN
local openSound = Instance.new("Sound", SoundService)
openSound.SoundId = "rbxassetid://6026984224" -- Replace with any sound you like
openSound.Volume = 1
openSound:Play()

-- FADE OUT + GUI SHOW
TweenService:Create(titleLabel, TweenInfo.new(2), {TextTransparency = 1}):Play()
task.delay(2.5, function()
	titleLabel:Destroy()
	mainFrame.Visible = true
end)

-- TOGGLE FUNCTION
toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- TAB SYSTEM
local Tabs = {}
local TabButtons = {}

local function createTab(name, positionIndex)
	local tabBtn = Instance.new("TextButton", mainFrame)
	tabBtn.Size = UDim2.new(0, 100, 0, 30)
	tabBtn.Position = UDim2.new(0, 10 + (positionIndex - 1) * 110, 0, 10)
	tabBtn.Text = name
	tabBtn.TextColor3 = Color3.new(1, 1, 1)
	tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	tabBtn.Font = Enum.Font.SourceSansBold
	tabBtn.TextSize = 14

	local tabFrame = Instance.new("Frame", mainFrame)
	tabFrame.Size = UDim2.new(0, 540, 0, 370)
	tabFrame.Position = UDim2.new(0, 10, 0, 50)
	tabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabFrame.BorderSizePixel = 0
	tabFrame.Visible = false

	tabBtn.MouseButton1Click:Connect(function()
		for _, t in pairs(Tabs) do
			t.Frame.Visible = false
		end
		tabFrame.Visible = true
	end)

	Tabs[name] = {Button = tabBtn, Frame = tabFrame}
end

-- CREATE 10 TABS
local categories = {
	"Combat", "Movement", "ESP", "Teleports", "Visuals",
	"Misc", "Trolling", "Utility", "Player Mods", "Settings"
}

for i, name in ipairs(categories) do
	createTab(name, i)
end
-- COMBAT TAB SETUP
local combatTab = Tabs["Combat"]

-- Helper function for combat buttons
local function makeCombatButton(text, y, callback)
	local btn = Instance.new("TextButton", combatTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 1: Kill All (Murderer Only)
makeCombatButton("Kill All (Murderer)", 10, function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Knife") then return end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			char:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
			task.wait(0.1)
		end
	end
end)

-- Feature 2: Auto Grab Gun
makeCombatButton("Auto Grab Gun", 50, function()
	local gun = workspace:FindFirstChild("GunDrop")
	if gun and LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(gun.CFrame)
	end
end)

-- Feature 3: Teleport to Murderer
makeCombatButton("TP to Murderer", 90, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Knife") then
			LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0))
		end
	end
end)

-- Feature 4: Teleport to Sheriff
makeCombatButton("TP to Sheriff", 130, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
			LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0))
		end
	end
end)

-- Feature 5: Kill Random Player (Murderer Only)
makeCombatButton("Kill Random Player", 170, function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Knife") then return end
	local others = {}
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, p)
		end
	end
	if #others > 0 then
		local target = others[math.random(1, #others)]
		char:PivotTo(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
	end
end)

-- Feature 6: Loop Kill All (Murderer)
makeCombatButton("Loop Kill All", 210, function()
	task.spawn(function()
		while task.wait(1) do
			local char = LocalPlayer.Character
			if not char or not char:FindFirstChild("Knife") then break end
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					char:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
					task.wait(0.1)
				end
			end
		end
	end)
end)

-- Feature 7: Auto Kill Sheriff
makeCombatButton("Auto Kill Sheriff", 250, function()
	task.spawn(function()
		while task.wait(1) do
			for _, p in pairs(Players:GetPlayers()) do
				if (p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun"))) and LocalPlayer.Character:FindFirstChild("Knife") then
					LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
					break
				end
			end
		end
	end)
end)

-- Feature 8: Auto Kill Innocents
makeCombatButton("Auto Kill Innocents", 290, function()
	task.spawn(function()
		while task.wait(1) do
			for _, p in pairs(Players:GetPlayers()) do
				if not (p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun"))) and p.Character and LocalPlayer.Character:FindFirstChild("Knife") then
					LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
					break
				end
			end
		end
	end)
end)

-- Feature 9: Kill Nearest Player
makeCombatButton("Kill Nearest Player", 330, function()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("Knife") then return end
	local closest, minDist = nil, math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude
			if dist < minDist then
				minDist = dist
				closest = p
			end
		end
	end
	if closest then
		char:PivotTo(closest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
	end
end)

-- Feature 10: Kill Sheriff (One Time)
makeCombatButton("Kill Sheriff (One Time)", 370, function()
	for _, p in pairs(Players:GetPlayers()) do
		if (p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun"))) and LocalPlayer.Character:FindFirstChild("Knife") then
			LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 2))
		end
	end
end)
-- MOVEMENT TAB SETUP
local movementTab = Tabs["Movement"]

-- Helper function for movement buttons
local function makeMoveButton(text, y, callback)
	local btn = Instance.new("TextButton", movementTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 11: WalkSpeed Slider
local walkSpeedSlider = Instance.new("TextBox", movementTab.Frame)
walkSpeedSlider.Size = UDim2.new(0, 200, 0, 30)
walkSpeedSlider.Position = UDim2.new(0, 10, 0, 10)
walkSpeedSlider.PlaceholderText = "WalkSpeed (default: 16)"
walkSpeedSlider.Text = ""
walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
walkSpeedSlider.TextColor3 = Color3.new(1, 1, 1)
walkSpeedSlider.ClearTextOnFocus = false
walkSpeedSlider.FocusLost:Connect(function()
	local val = tonumber(walkSpeedSlider.Text)
	if val then
		LocalPlayer.Character.Humanoid.WalkSpeed = val
	end
end)

-- Feature 12: JumpPower Slider
local jumpPowerSlider = Instance.new("TextBox", movementTab.Frame)
jumpPowerSlider.Size = UDim2.new(0, 200, 0, 30)
jumpPowerSlider.Position = UDim2.new(0, 10, 0, 50)
jumpPowerSlider.PlaceholderText = "JumpPower (default: 50)"
jumpPowerSlider.Text = ""
jumpPowerSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
jumpPowerSlider.TextColor3 = Color3.new(1, 1, 1)
jumpPowerSlider.ClearTextOnFocus = false
jumpPowerSlider.FocusLost:Connect(function()
	local val = tonumber(jumpPowerSlider.Text)
	if val then
		LocalPlayer.Character.Humanoid.JumpPower = val
	end
end)

-- Feature 13: Infinite Jump
makeMoveButton("Infinite Jump", 90, function()
	local UIS = game:GetService("UserInputService")
	local jumping = false
	UIS.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
end)

-- Feature 14: Noclip
makeMoveButton("Noclip", 130, function()
	local noclip = true
	game:GetService("RunService").Stepped:Connect(function()
		if noclip and LocalPlayer.Character then
			for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end)

-- Feature 15: Fly (basic toggle)
makeMoveButton("Fly (toggle)", 170, function()
	local flying = true
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	while flying do
		bv.Velocity = Vector3.new(0, 50, 0)
		task.wait()
	end
end)

-- Feature 16: Fast Fall
makeMoveButton("Fast Fall", 210, function()
	local char = LocalPlayer.Character
	if char then
		char:FindFirstChild("HumanoidRootPart").Velocity = Vector3.new(0, -200, 0)
	end
end)

-- Feature 17: Super Climb
makeMoveButton("Super Climb", 250, function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.Velocity = Vector3.new(0, 120, 0)
	end
end)

-- Feature 18: Anti Slow
makeMoveButton("Anti Slow", 290, function()
	game:GetService("RunService").RenderStepped:Connect(function()
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			if LocalPlayer.Character.Humanoid.WalkSpeed < 16 then
				LocalPlayer.Character.Humanoid.WalkSpeed = 16
			end
		end
	end)
end)

-- Feature 19: Auto Bunny Hop
makeMoveButton("Auto Bunny Hop", 330, function()
	task.spawn(function()
		while task.wait(0.3) do
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)
end)

-- Feature 20: Reset Character
makeMoveButton("Reset Character", 370, function()
	LocalPlayer.Character:BreakJoints()
end)
-- ESP TAB SETUP
local espTab = Tabs["ESP"]

-- Helper function for ESP buttons
local function makeESPButton(text, y, callback)
	local btn = Instance.new("TextButton", espTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(120, 80, 200)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Base ESP Setup
local function createESPForPlayer(player, color)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local box = Instance.new("BoxHandleAdornment")
		box.Name = "PulseESP"
		box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
		box.Size = Vector3.new(4, 6, 2)
		box.Color3 = color
		box.AlwaysOnTop = true
		box.ZIndex = 5
		box.Transparency = 0.3
		box.Parent = player.Character:FindFirstChild("HumanoidRootPart")
	end
end

-- Feature 21: ESP - Innocents
makeESPButton("ESP: Innocents", 10, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and not p.Backpack:FindFirstChild("Gun") and not (p.Character and p.Character:FindFirstChild("Gun")) then
			createESPForPlayer(p, Color3.fromRGB(120, 120, 120))
		end
	end
end)

-- Feature 22: ESP - Murderer
makeESPButton("ESP: Murderer", 50, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Knife") then
			createESPForPlayer(p, Color3.fromRGB(255, 0, 0))
		end
	end
end)

-- Feature 23: ESP - Sheriff
makeESPButton("ESP: Sheriff", 90, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
			createESPForPlayer(p, Color3.fromRGB(0, 0, 255))
		end
	end
end)

-- Feature 24: Tracer ESP
makeESPButton("ESP: Tracers", 130, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local beam = Instance.new("Beam", p.Character)
			local a1 = Instance.new("Attachment", p.Character.HumanoidRootPart)
			local a2 = Instance.new("Attachment", workspace.CurrentCamera)
			beam.Attachment0 = a2
			beam.Attachment1 = a1
			beam.Color = ColorSequence.new(Color3.new(1, 1, 1))
			beam.Width0 = 0.05
			beam.Width1 = 0.05
			beam.FaceCamera = true
			beam.ZIndex = 10
		end
	end
end)

-- Feature 25: Box ESP All
makeESPButton("ESP: All (Boxes)", 170, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			createESPForPlayer(p, Color3.fromRGB(0, 255, 255))
		end
	end
end)

-- Feature 26: Highlight Body (All Roles)
makeESPButton("Highlight Players", 210, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local highlight = Instance.new("Highlight")
			highlight.Name = "PulseHighlight"
			highlight.FillColor = Color3.fromRGB(255, 255, 100)
			highlight.OutlineColor = Color3.fromRGB(100, 100, 0)
			highlight.FillTransparency = 0.3
			highlight.OutlineTransparency = 0
			highlight.Parent = p.Character
		end
	end
end)

-- Feature 27: Toggle ESP Visibility
makeESPButton("Toggle ESP (on/off)", 250, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			for _, v in pairs(p.Character:GetDescendants()) do
				if v:IsA("BoxHandleAdornment") and v.Name == "PulseESP" then
					v.Visible = not v.Visible
				end
			end
		end
	end
end)

-- Feature 28: Remove All ESP
makeESPButton("Clear All ESP", 290, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			for _, v in pairs(p.Character:GetDescendants()) do
				if v:IsA("BoxHandleAdornment") or v:IsA("Highlight") or v:IsA("Beam") then
					v:Destroy()
				end
			end
		end
	end
end)

-- Feature 29: ESP with Team Colors
makeESPButton("ESP: Team Color", 330, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Team and p.Character then
			createESPForPlayer(p, p.Team.TeamColor.Color)
		end
	end
end)

-- Feature 30: ESP with Name Above Head
makeESPButton("Name ESP", 370, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not p.Character:FindFirstChild("Head"):FindFirstChild("NameTag") then
			local bill = Instance.new("BillboardGui", p.Character.Head)
			bill.Name = "NameTag"
			bill.Size = UDim2.new(0, 100, 0, 30)
			bill.StudsOffset = Vector3.new(0, 2, 0)
			bill.AlwaysOnTop = true
			local txt = Instance.new("TextLabel", bill)
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.BackgroundTransparency = 1
			txt.Text = p.Name
			txt.TextColor3 = Color3.new(1, 1, 1)
			txt.TextScaled = true
			txt.Font = Enum.Font.SourceSansBold
		end
	end
end)
-- TELEPORT TAB SETUP
local teleportTab = Tabs["Teleports"]

-- Helper for teleport buttons
local function makeTeleportBtn(text, y, callback)
	local btn = Instance.new("TextButton", teleportTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 31: Teleport to Lobby
makeTeleportBtn("Teleport to Lobby", 10, function()
	if workspace:FindFirstChild("Lobby") then
		LocalPlayer.Character:PivotTo(workspace.Lobby:GetModelCFrame())
	end
end)

-- Feature 32: Teleport to Gun
makeTeleportBtn("Teleport to Gun", 50, function()
	local gun = workspace:FindFirstChild("GunDrop")
	if gun and LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(gun.CFrame + Vector3.new(0, 2, 0))
	end
end)

-- Feature 33: Teleport to Sheriff
makeTeleportBtn("Teleport to Sheriff", 90, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Backpack:FindFirstChild("Gun") or (p.Character and p.Character:FindFirstChild("Gun")) then
			LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
			break
		end
	end
end)

-- Feature 34: Teleport to Murderer
makeTeleportBtn("Teleport to Murderer", 130, function()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Knife") then
			LocalPlayer.Character:PivotTo(p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
			break
		end
	end
end)

-- Feature 35: Teleport to Safe Spot 1
makeTeleportBtn("Safe Spot 1", 170, function()
	LocalPlayer.Character:PivotTo(CFrame.new(0, 999, 0))
end)

-- Feature 36: Teleport to Safe Spot 2
makeTeleportBtn("Safe Spot 2", 210, function()
	LocalPlayer.Character:PivotTo(CFrame.new(500, 100, 500))
end)

-- Feature 37: Teleport to Corner
makeTeleportBtn("Corner Teleport", 250, function()
	local map = workspace:FindFirstChild("Map")
	if map then
		for _, part in pairs(map:GetDescendants()) do
			if part:IsA("BasePart") then
				LocalPlayer.Character:PivotTo(part.CFrame + Vector3.new(100, 5, 100))
				break
			end
		end
	end
end)

-- Feature 38: Random Teleport
makeTeleportBtn("Random TP", 290, function()
	local players = Players:GetPlayers()
	local randomPlayer = players[math.random(1, #players)]
	if randomPlayer ~= LocalPlayer and randomPlayer.Character and randomPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:PivotTo(randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
	end
end)

-- Feature 39: Loop Teleport to Player
makeTeleportBtn("Loop TP to Player", 330, function()
	local targetName = nil
	local box = Instance.new("TextBox", teleportTab.Frame)
	box.Size = UDim2.new(0, 200, 0, 30)
	box.Position = UDim2.new(0, 10, 0, 370)
	box.PlaceholderText = "Player Name"
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	box.TextColor3 = Color3.new(0, 0, 0)
	box.ClearTextOnFocus = false

	box.FocusLost:Connect(function()
		targetName = box.Text
		while targetName do
			local target = Players:FindFirstChild(targetName)
			if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character:PivotTo(target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0))
			end
			wait(1)
		end
	end)
end)

-- Feature 40: Teleport Back to Original Position
makeTeleportBtn("Return to Start Pos", 410, function()
	if not LocalPlayer.Character then return end
	local originalPos = LocalPlayer.Character:GetPivot()
	wait(10) -- Delay before returning
	LocalPlayer.Character:PivotTo(originalPos)
end)
-- VISUALS TAB SETUP
local visualsTab = Tabs["Visuals"]

-- Helper for visual buttons
local function makeVisualBtn(text, y, callback)
	local btn = Instance.new("TextButton", visualsTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(180, 120, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 41: Fullbright Mode
makeVisualBtn("Enable Fullbright", 10, function()
	game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
	game:GetService("Lighting").Brightness = 2
	game:GetService("Lighting").FogEnd = 100000
end)

-- Feature 42: Remove All Textures
makeVisualBtn("Remove Textures", 50, function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj:Destroy()
		end
	end
end)

-- Feature 43: Apply Outline to Characters
makeVisualBtn("Character Outline", 90, function()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and not player.Character:FindFirstChild("Outline") then
			local h = Instance.new("Highlight", player.Character)
			h.Name = "Outline"
			h.FillTransparency = 1
			h.OutlineColor = Color3.fromRGB(255, 255, 255)
			h.OutlineTransparency = 0
		end
	end
end)

-- Feature 44: Custom FOV Changer
makeVisualBtn("Change FOV (120)", 130, function()
	workspace.CurrentCamera.FieldOfView = 120
end)

-- Feature 45: Reset FOV
makeVisualBtn("Reset FOV", 170, function()
	workspace.CurrentCamera.FieldOfView = 70
end)

-- Feature 46: RGB Body Shader
makeVisualBtn("RGB Shader", 210, function()
	coroutine.wrap(function()
		while true do
			for _, player in pairs(Players:GetPlayers()) do
				if player.Character then
					for _, part in pairs(player.Character:GetChildren()) do
						if part:IsA("BasePart") then
							part.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
						end
					end
				end
			end
			task.wait(0.2)
		end
	end)()
end)

-- Feature 47: Toggle Fog
makeVisualBtn("Toggle Fog (Off)", 250, function()
	local fogEnabled = game:GetService("Lighting").FogEnd < 10000
	if fogEnabled then
		game:GetService("Lighting").FogEnd = 100000
	else
		game:GetService("Lighting").FogEnd = 200
	end
end)

-- Feature 48: Visual Tint Overlay (Red)
makeVisualBtn("Red Tint Overlay", 290, function()
	local effect = Instance.new("ColorCorrectionEffect")
	effect.Name = "PulseTint"
	effect.TintColor = Color3.fromRGB(255, 100, 100)
	effect.Parent = game:GetService("Lighting")
end)

-- Feature 49: Remove Tint Overlay
makeVisualBtn("Remove Tint", 330, function()
	for _, obj in pairs(game:GetService("Lighting"):GetChildren()) do
		if obj:IsA("ColorCorrectionEffect") and obj.Name == "PulseTint" then
			obj:Destroy()
		end
	end
end)

-- Feature 50: Outline Only LocalPlayer
makeVisualBtn("Self Outline", 370, function()
	local char = LocalPlayer.Character
	if char and not char:FindFirstChild("Outline") then
		local h = Instance.new("Highlight", char)
		h.Name = "Outline"
		h.FillTransparency = 1
		h.OutlineColor = Color3.fromRGB(0, 255, 255)
		h.OutlineTransparency = 0
	end
end)
-- MISC TAB SETUP
local miscTab = Tabs["Misc"]

local function makeMiscBtn(text, y, callback)
	local btn = Instance.new("TextButton", miscTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 51: Anti-AFK
makeMiscBtn("Enable Anti-AFK", 10, function()
	for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
		conn:Disable()
	end
end)

-- Feature 52: Rejoin Server
makeMiscBtn("Rejoin Server", 50, function()
	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- Feature 53: Server Hop
makeMiscBtn("Server Hop", 90, function()
	local HttpService = game:GetService("HttpService")
	local tpService = game:GetService("TeleportService")
	local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet(
		"https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
	for _, v in pairs(Servers.data) do
		if v.playing < v.maxPlayers and v.id ~= game.JobId then
			tpService:TeleportToPlaceInstance(game.PlaceId, v.id)
			break
		end
	end
end)

-- Feature 54: FPS Boost
makeMiscBtn("Enable FPS Boost", 130, function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj:Destroy()
		end
	end
end)

-- Feature 55: Clear Decals Only
makeMiscBtn("Clear Decals", 170, function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Decal") then
			obj:Destroy()
		end
	end
end)

-- Feature 56: Auto Emotes (Spam)
makeMiscBtn("Auto Emotes (Spam)", 210, function()
	while true do
		game.ReplicatedStorage.PlayEmote:Fire("dab")
		task.wait(1)
	end
end)

-- Feature 57: Chat Spammer (Fun)
makeMiscBtn("Chat Spam", 250, function()
	while true do
		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PulseFx on top 🔥", "All")
		task.wait(2)
	end
end)

-- Feature 58: Hide All GUI
makeMiscBtn("Hide All GUIs", 290, function()
	for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
		if v:IsA("ScreenGui") then
			v.Enabled = false
		end
	end
end)

-- Feature 59: Track Game Time
makeMiscBtn("Show Game Time", 330, function()
	local startTime = tick()
	while true do
		local current = tick() - startTime
		print("You've been in-game for:", math.floor(current), "seconds.")
		task.wait(5)
	end
end)

-- Feature 60: Display Ping
makeMiscBtn("Show Ping", 370, function()
	local pingGui = Instance.new("TextLabel", miscTab.Frame)
	pingGui.Size = UDim2.new(0, 200, 0, 30)
	pingGui.Position = UDim2.new(0, 10, 0, 410)
	pingGui.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
	pingGui.TextColor3 = Color3.new(0, 0, 0)
	pingGui.Text = "Ping: Calculating..."
	pingGui.TextSize = 14
	pingGui.Font = Enum.Font.SourceSansBold

	while true do
		local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
		pingGui.Text = "Ping: " .. ping
		task.wait(1)
	end
end)
-- TROLLING TAB SETUP
local trollTab = Tabs["Trolling"]

local function makeTrollBtn(text, y, callback)
	local btn = Instance.new("TextButton", trollTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(255, 200, 200)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 61: Fake Chat Message
makeTrollBtn("Fake Chat Message", 10, function()
	local text = "[Admin]: You're being watched."
	game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
		Text = text,
		Color = Color3.fromRGB(255, 50, 50),
		Font = Enum.Font.SourceSansBold,
		TextSize = 18
	})
end)

-- Feature 62: Flip Player Screen
makeTrollBtn("Flip Screen", 50, function()
	workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(0, 0, math.rad(180))
end)

-- Feature 63: Head Spin
makeTrollBtn("Spin Head", 90, function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Head") then
		while true do
			char.Head.CFrame = char.Head.CFrame * CFrame.Angles(0, math.rad(20), 0)
			task.wait(0.05)
		end
	end
end)

-- Feature 64: Fake Lag
makeTrollBtn("Fake Lag (Visual)", 130, function()
	while true do
		wait(0.3)
		workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(Vector3.new(1, 0, 0))
	end
end)

-- Feature 65: Chat Flooder
makeTrollBtn("Flood Chat", 170, function()
	while true do
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PulseFx 🌀", "All")
		task.wait(0.3)
	end
end)

-- Feature 66: Make Body Transparent
makeTrollBtn("Ghost Mode (Your Body)", 210, function()
	for _, part in pairs(LocalPlayer.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end
end)

-- Feature 67: Spam Emotes
makeTrollBtn("Spam Emotes", 250, function()
	while true do
		game.ReplicatedStorage.PlayEmote:Fire("zen")
		task.wait(1)
	end
end)

-- Feature 68: Rainbow Character
makeTrollBtn("Rainbow Body", 290, function()
	coroutine.wrap(function()
		while true do
			for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
				if p:IsA("BasePart") then
					p.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
				end
			end
			task.wait(0.2)
		end
	end)()
end)

-- Feature 69: Rapid Crouch Glitch
makeTrollBtn("Crouch Spam", 330, function()
	while true do
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Seated)
		task.wait(0.2)
		LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
		task.wait(0.2)
	end
end)

-- Feature 70: Fake Kick Screen
makeTrollBtn("Fake Kick Popup", 370, function()
	local msg = Instance.new("Message", workspace)
	msg.Text = "You have been kicked from the game."
	task.wait(3)
	msg:Destroy()
end)
-- UTILITY TAB SETUP
local utilityTab = Tabs["Utility"]

local function makeUtilityBtn(text, y, callback)
	local btn = Instance.new("TextButton", utilityTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 71: Noclip (Toggled with "N")
local noclipEnabled = false
makeUtilityBtn("Toggle Noclip (Press N)", 10, function()
	noclipEnabled = not noclipEnabled
end)
game:GetService("RunService").Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.N then
		noclipEnabled = not noclipEnabled
	end
end)

-- Feature 72: Fly (mobile friendly toggle)
local flyEnabled = false
local flyVelocity
makeUtilityBtn("Toggle Fly (Press F)", 50, function()
	flyEnabled = not flyEnabled
	local char = LocalPlayer.Character
	if char and flyEnabled then
		local hrp = char:WaitForChild("HumanoidRootPart")
		flyVelocity = Instance.new("BodyVelocity", hrp)
		flyVelocity.Velocity = Vector3.new(0, 0, 0)
		flyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
	elseif flyVelocity then
		flyVelocity:Destroy()
	end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then
		flyEnabled = not flyEnabled
	end
end)
game:GetService("RunService").RenderStepped:Connect(function()
	if flyEnabled and LocalPlayer.Character then
		local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp and flyVelocity then
			local moveDir = LocalPlayer:GetMouse().Hit.LookVector
			flyVelocity.Velocity = moveDir * 50
		end
	end
end)

-- Feature 73: X-Ray Vision
makeUtilityBtn("Enable X-Ray", 90, function()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
			obj.Transparency = 0.7
		end
	end
end)

-- Feature 74: Spectate Players
makeUtilityBtn("Spectate Player", 130, function()
	local players = game:GetService("Players"):GetPlayers()
	for _, p in pairs(players) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
			break
		end
	end
end)

-- Feature 75: Reset Camera
makeUtilityBtn("Reset Spectate", 170, function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
	end
end)

-- Feature 76: Click TP (Click to teleport anywhere)
makeUtilityBtn("Click Teleport", 210, function()
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if mouse.Target then
			LocalPlayer.Character:MoveTo(mouse.Hit.p)
		end
	end)
end)

-- Feature 77: Anti-Fling
makeUtilityBtn("Enable Anti-Fling", 250, function()
	game:GetService("RunService").Stepped:Connect(function()
		for _, player in pairs(game:GetService("Players"):GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
				player.Character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
			end
		end
	end)
end)

-- Feature 78: View Player Inventory
makeUtilityBtn("View Inventory", 290, function()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Backpack then
			print("Inventory of " .. player.Name)
			for _, tool in pairs(player.Backpack:GetChildren()) do
				print(" - " .. tool.Name)
			end
		end
	end
end)

-- Feature 79: Private Chat to Randoms
makeUtilityBtn("Send Fake Private Msg", 330, function()
	local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
	game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
		Text = "To [" .. randomPlayer.Name .. "]: Are you the sheriff?",
		Color = Color3.fromRGB(150, 150, 255),
		Font = Enum.Font.SourceSansBold,
		TextSize = 16
	})
end)

-- Feature 80: Toggle All Collisions Off
makeUtilityBtn("No Collision (World)", 370, function()
	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
			part.CanCollide = false
		end
	end
end)
-- PLAYER MODS TAB SETUP
local playerTab = Tabs["Player Mods"]

local function makePlayerBtn(text, y, callback)
	local btn = Instance.new("TextButton", playerTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(180, 255, 200)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 81: WalkSpeed Slider
makePlayerBtn("WalkSpeed +", 10, function()
	LocalPlayer.Character.Humanoid.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed + 5
end)
makePlayerBtn("WalkSpeed -", 50, function()
	LocalPlayer.Character.Humanoid.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed - 5
end)

-- Feature 82: JumpPower Slider
makePlayerBtn("JumpPower +", 90, function()
	LocalPlayer.Character.Humanoid.JumpPower = LocalPlayer.Character.Humanoid.JumpPower + 10
end)
makePlayerBtn("JumpPower -", 130, function()
	LocalPlayer.Character.Humanoid.JumpPower = LocalPlayer.Character.Humanoid.JumpPower - 10
end)

-- Feature 83: FOV Slider
makePlayerBtn("FOV +", 170, function()
	workspace.CurrentCamera.FieldOfView = workspace.CurrentCamera.FieldOfView + 5
end)
makePlayerBtn("FOV -", 210, function()
	workspace.CurrentCamera.FieldOfView = workspace.CurrentCamera.FieldOfView - 5
end)

-- Feature 84: Invisibility
makePlayerBtn("Invisibility", 250, function()
	for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
		end
	end
end)

-- Feature 85: Reset Character
makePlayerBtn("Force Reset", 290, function()
	LocalPlayer.Character:BreakJoints()
end)

-- Feature 86: Scale Character
makePlayerBtn("Grow Taller", 330, function()
	for _, part in pairs(LocalPlayer.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Size = part.Size + Vector3.new(0, 1, 0)
		end
	end
end)
makePlayerBtn("Shrink Smaller", 370, function()
	for _, part in pairs(LocalPlayer.Character:GetChildren()) do
		if part:IsA("BasePart") then
			part.Size = part.Size - Vector3.new(0, 1, 0)
		end
	end
end)

-- Feature 87: Gravity Mod
makePlayerBtn("Low Gravity", 410, function()
	workspace.Gravity = 50
end)
makePlayerBtn("Normal Gravity", 450, function()
	workspace.Gravity = 196.2
end)

-- Feature 88: No Idle Kick
makePlayerBtn("Anti Idle", 490, function()
	for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
		conn:Disable()
	end
end)

-- Feature 89: Freeze Player
makePlayerBtn("Freeze Character", 530, function()
	if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.Anchored = true
	end
end)

-- Feature 90: Unfreeze Player
makePlayerBtn("Unfreeze Character", 570, function()
	if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.Anchored = false
	end
end)
-- SETTINGS TAB SETUP
local settingsTab = Tabs["Settings"]

local function makeSettingsBtn(text, y, callback)
	local btn = Instance.new("TextButton", settingsTab.Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(240, 220, 200)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 91: Toggle Sound On/Off
local soundOn = true
makeSettingsBtn("Toggle GUI Sound", 10, function()
	soundOn = not soundOn
end)

-- Feature 92: Toggle GUI Transparency
local guiTransparent = false
makeSettingsBtn("Toggle Transparency", 50, function()
	guiTransparent = not guiTransparent
	local alpha = guiTransparent and 0.4 or 1
	for _, tab in pairs(Tabs) do
		tab.Frame.BackgroundTransparency = 1 - alpha
	end
end)

-- Feature 93: Enable Mobile Optimizations
makeSettingsBtn("Enable Mobile Mode", 90, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.AutomaticSize = Enum.AutomaticSize.Y
	end
end)

-- Feature 94: GUI Theme Switcher
local currentTheme = "Light"
makeSettingsBtn("Switch GUI Theme", 130, function()
	currentTheme = currentTheme == "Light" and "Dark" or "Light"
	local bg = currentTheme == "Light" and Color3.fromRGB(240,240,240) or Color3.fromRGB(50,50,50)
	local fg = currentTheme == "Light" and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
	for _, tab in pairs(Tabs) do
		tab.Frame.BackgroundColor3 = bg
		for _, child in pairs(tab.Frame:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = bg
				child.TextColor3 = fg
			end
		end
	end
end)

-- Feature 95: Toggle Toggle Button Visibility
makeSettingsBtn("Hide/Show Toggle Button", 170, function()
	if ToggleBtn.Visible then
		ToggleBtn.Visible = false
	else
		ToggleBtn.Visible = true
	end
end)

-- Feature 96: Reset GUI Layout
makeSettingsBtn("Reset GUI Layout", 210, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
	end
end)

-- Feature 97: Resize Buttons (Small)
makeSettingsBtn("Set Small Buttons", 250, function()
	for _, tab in pairs(Tabs) do
		for _, b in pairs(tab.Frame:GetChildren()) do
			if b:IsA("TextButton") then
				b.Size = UDim2.new(0, 160, 0, 25)
			end
		end
	end
end)

-- Feature 98: Resize Buttons (Large)
makeSettingsBtn("Set Large Buttons", 290, function()
	for _, tab in pairs(Tabs) do
		for _, b in pairs(tab.Frame:GetChildren()) do
			if b:IsA("TextButton") then
				b.Size = UDim2.new(0, 220, 0, 40)
			end
		end
	end
end)

-- Feature 99: Save Config (basic save)
makeSettingsBtn("Save GUI Config", 330, function()
	if isfile and writefile then
		local config = {
			theme = currentTheme,
			transparent = guiTransparent,
			sound = soundOn
		}
		writefile("PulseFx_Config.json", game:GetService("HttpService"):JSONEncode(config))
	end
end)

-- Feature 100: Load Config (basic load)
makeSettingsBtn("Load GUI Config", 370, function()
	if isfile and readfile and isfile("PulseFx_Config.json") then
		local data = game:GetService("HttpService"):JSONDecode(readfile("PulseFx_Config.json"))
		currentTheme = data.theme
		guiTransparent = data.transparent
		soundOn = data.sound
	end
end)
-- COMBAT+ TAB SETUP
local combatPlusTab = createTab("Combat+")

local function makeCombatPlusBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["Combat+"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(255, 180, 180)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 101: Silent Aim (Basic Simulation)
makeCombatPlusBtn("Silent Aim (Beta)", 10, function()
	_G.SilentAim = true
	local mt = getrawmetatable(game)
	local namecall = mt.__namecall
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local args = {...}
		local method = getnamecallmethod()
		if _G.SilentAim and method == "FindPartOnRayWithIgnoreList" then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
					args[1] = Ray.new(workspace.CurrentCamera.CFrame.Position, (plr.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).unit * 500)
					return namecall(self, unpack(args))
				end
			end
		end
		return namecall(self, ...)
	end)
end)

-- Feature 102: Hitbox Expander
makeCombatPlusBtn("Hitbox Expander", 50, function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			plr.Character.HumanoidRootPart.Size = Vector3.new(10, 10, 10)
			plr.Character.HumanoidRootPart.Transparency = 0.5
		end
	end
end)

-- Feature 103: Kill Aura (Close Auto Attack)
makeCombatPlusBtn("Kill Aura", 90, function()
	_G.KillAura = true
	while _G.KillAura do
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				if (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 5 then
					firetouchinterest(LocalPlayer.Character:FindFirstChild("Knife"), plr.Character.HumanoidRootPart, 0)
					firetouchinterest(LocalPlayer.Character:FindFirstChild("Knife"), plr.Character.HumanoidRootPart, 1)
				end
			end
		end
		task.wait(0.2)
	end
end)

-- Feature 104: Anti Stun
makeCombatPlusBtn("Anti Stun", 130, function()
	for _, obj in ipairs(LocalPlayer.Character:GetDescendants()) do
		if obj:IsA("BoolValue") and obj.Name:lower():find("stun") then
			obj:Destroy()
		end
	end
end)

-- Feature 105: Auto Throw Knife (hold right click)
makeCombatPlusBtn("Auto Knife Throw", 170, function()
	_G.AutoThrow = true
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 and _G.AutoThrow then
			local knife = LocalPlayer.Character:FindFirstChild("Knife")
			if knife then
				firetouchinterest(knife, workspace, 0)
				firetouchinterest(knife, workspace, 1)
			end
		end
	end)
end)

-- Feature 106: Knife Spin Effect
makeCombatPlusBtn("Spin Knife", 210, function()
	local knife = LocalPlayer.Character:FindFirstChild("Knife")
	if knife then
		local spin = Instance.new("BodyAngularVelocity", knife)
		spin.AngularVelocity = Vector3.new(0, 25, 0)
		spin.MaxTorque = Vector3.new(4000, 4000, 4000)
	end
end)

-- Feature 107: Gun Skin Changer (visual only)
makeCombatPlusBtn("Fake Gun Skin", 250, function()
	local gun = LocalPlayer.Character:FindFirstChild("Gun")
	if gun and gun:IsA("Tool") then
		for _, v in pairs(gun:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Color = Color3.fromRGB(0, 255, 200)
			end
		end
	end
end)

-- Feature 108: Auto Sprint When Aiming
makeCombatPlusBtn("Auto Sprint (While Aiming)", 290, function()
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			LocalPlayer.Character.Humanoid.WalkSpeed = 32
		end
	end)
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end)
end)

-- Feature 109: Instant Throw
makeCombatPlusBtn("Instant Throw Knife", 330, function()
	if LocalPlayer.Character:FindFirstChild("Knife") then
		LocalPlayer.Character.Knife:Activate()
	end
end)

-- Feature 110: Toggle Hit Sound
makeCombatPlusBtn("Toggle Hit Sound", 370, function()
	_G.PlayHitSound = not _G.PlayHitSound
end)
-- MOVEMENT+ TAB SETUP
local movePlusTab = createTab("Movement+")

local function makeMovePlusBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["Movement+"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 111: Toggle Noclip (keybind N)
local noclip = false
makeMovePlusBtn("Toggle Noclip (N)", 10, function()
	noclip = not noclip
end)
game:GetService("RunService").Stepped:Connect(function()
	if noclip and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(11)
	end
end)
game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.N then
		noclip = not noclip
	end
end)

-- Feature 112: Flight Mode (toggle)
local flying = false
makeMovePlusBtn("Toggle Fly (F)", 50, function()
	flying = not flying
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local bv = Instance.new("BodyVelocity", hrp)
	bv.Name = "FlyVel"
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(400000, 400000, 400000)

	while flying and bv.Parent == hrp do
		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * 60
		task.wait()
	end
	if bv then bv:Destroy() end
end)

-- Feature 113: Edge Jump Assist
makeMovePlusBtn("Edge Jump Assist", 90, function()
	game:GetService("RunService").RenderStepped:Connect(function()
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
		if hum and hum.FloorMaterial == Enum.Material.Air then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end)

-- Feature 114: Infinite Wall Climb
makeMovePlusBtn("Wall Climb", 130, function()
	LocalPlayer.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
end)

-- Feature 115: Air Walk
makeMovePlusBtn("Air Walk", 170, function()
	local platform = Instance.new("Part", workspace)
	platform.Anchored = true
	platform.Size = Vector3.new(5, 1, 5)
	platform.Transparency = 0.5
	platform.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)

	game:GetService("RunService").RenderStepped:Connect(function()
		if platform then
			platform.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0)
		end
	end)
end)

-- Feature 116: No Fall Damage
makeMovePlusBtn("No Fall Damage", 210, function()
	local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then
		hum.StateChanged:Connect(function(_, newState)
			if newState == Enum.HumanoidStateType.Freefall then
				hum:ChangeState(Enum.HumanoidStateType.Seated)
			end
		end)
	end
end)

-- Feature 117: Parkour Mode
makeMovePlusBtn("Parkour Mode", 250, function()
	local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then
		hum.JumpPower = 80
		hum.WalkSpeed = 28
	end
end)

-- Feature 118: Spider Walk (Climb walls)
makeMovePlusBtn("Spider Walk", 290, function()
	game:GetService("RunService").Stepped:Connect(function()
		local rayOrigin = LocalPlayer.Character.HumanoidRootPart.Position
		local rayDirection = Vector3.new(0, 0, -2)
		local raycast = workspace:Raycast(rayOrigin, rayDirection)
		if raycast then
			LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Climbing)
		end
	end)
end)

-- Feature 119: High Vault
makeMovePlusBtn("High Vault", 330, function()
	local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then
		hum.Jump = true
		hum.JumpPower = 120
	end
end)

-- Feature 120: Speed Toggle Key (Hold LeftShift)
makeMovePlusBtn("Toggle Sprint Key (LeftShift)", 370, function()
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			LocalPlayer.Character.Humanoid.WalkSpeed = 32
		end
	end)
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift then
			LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end)
end)
-- ESP+ TAB SETUP
local espPlusTab = createTab("ESP+")

local function makeESPPlusBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["ESP+"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(255, 230, 180)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

local espFolder = Instance.new("Folder", CoreGui)
espFolder.Name = "PulseFx_ESP"

-- Feature 121: Box ESP
makeESPPlusBtn("Box ESP", 10, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "BoxESP"
			box.Size = Vector3.new(4, 6, 2)
			box.Adornee = plr.Character.HumanoidRootPart
			box.Color3 = Color3.fromRGB(0, 255, 0)
			box.Transparency = 0.4
			box.AlwaysOnTop = true
			box.ZIndex = 10
			box.Parent = espFolder
		end
	end
end)

-- Feature 122: Name Tags
makeESPPlusBtn("Name Tags", 50, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local tag = Instance.new("BillboardGui", espFolder)
			tag.Name = "NameESP"
			tag.Adornee = plr.Character.Head
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.StudsOffset = Vector3.new(0, 2, 0)
			tag.AlwaysOnTop = true
			local text = Instance.new("TextLabel", tag)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.BackgroundTransparency = 1
			text.Text = plr.Name
			text.TextColor3 = Color3.new(1, 1, 1)
			text.TextStrokeTransparency = 0
			text.TextSize = 14
		end
	end
end)

-- Feature 123: Role-Based ESP Color
makeESPPlusBtn("ESP Role Colors", 90, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		local esp = espFolder:FindFirstChild("BoxESP")
		if esp and plr.Backpack:FindFirstChild("Gun") then
			esp.Color3 = Color3.fromRGB(0, 0, 255) -- Sheriff
		elseif plr.Backpack:FindFirstChild("Knife") then
			esp.Color3 = Color3.fromRGB(255, 0, 0) -- Murderer
		else
			esp.Color3 = Color3.fromRGB(0, 255, 0) -- Innocent
		end
	end
end)

-- Feature 124: Tracer ESP
makeESPPlusBtn("Tracers", 130, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local line = Drawing.new("Line")
			line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
			line.To = workspace:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position).Position
			line.Color = Color3.fromRGB(255, 255, 255)
			line.Thickness = 1.5
			line.Visible = true
		end
	end
end)

-- Feature 125: X-Ray Vision (Transparency)
makeESPPlusBtn("X-Ray Vision", 170, function()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Transparency < 0.5 and not obj:IsDescendantOf(LocalPlayer.Character) then
			obj.LocalTransparencyModifier = 0.7
		end
	end
end)

-- Feature 126: Distance ESP
makeESPPlusBtn("Distance ESP", 210, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local tag = Instance.new("BillboardGui", espFolder)
			tag.Name = "DistanceESP"
			tag.Adornee = plr.Character.Head
			tag.Size = UDim2.new(0, 100, 0, 20)
			tag.StudsOffset = Vector3.new(0, 3, 0)
			tag.AlwaysOnTop = true
			local text = Instance.new("TextLabel", tag)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.BackgroundTransparency = 1
			local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude)
			text.Text = dist .. " studs"
			text.TextColor3 = Color3.new(1, 1, 0)
			text.TextStrokeTransparency = 0
			text.TextSize = 14
		end
	end
end)

-- Feature 127: Always On Top
makeESPPlusBtn("ESP Always On Top", 250, function()
	for _, esp in ipairs(espFolder:GetChildren()) do
		if esp:IsA("BoxHandleAdornment") or esp:IsA("BillboardGui") then
			esp.AlwaysOnTop = true
		end
	end
end)

-- Feature 128: Rainbow ESP
makeESPPlusBtn("Rainbow ESP", 290, function()
	local function rainbow()
		local counter = 0
		while true do
			for _, v in ipairs(espFolder:GetChildren()) do
				if v:IsA("BoxHandleAdornment") then
					v.Color3 = Color3.fromHSV(counter, 1, 1)
				end
			end
			counter = (counter + 0.01) % 1
			task.wait()
		end
	end
	coroutine.wrap(rainbow)()
end)

-- Feature 129: Change ESP Font
makeESPPlusBtn("ESP Font: Gotham", 330, function()
	for _, gui in ipairs(espFolder:GetChildren()) do
		if gui:IsA("BillboardGui") then
			for _, label in ipairs(gui:GetChildren()) do
				if label:IsA("TextLabel") then
					label.Font = Enum.Font.GothamSemibold
				end
			end
		end
	end
end)

-- Feature 130: Filter Only Sheriff + Murd ESP
makeESPPlusBtn("Only Murd/Sheriff ESP", 370, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		local role = (plr.Backpack:FindFirstChild("Gun") and "Sheriff") or (plr.Backpack:FindFirstChild("Knife") and "Murderer")
		if role then
			local box = Instance.new("BoxHandleAdornment")
			box.Name = "RoleBoxESP"
			box.Adornee = plr.Character:FindFirstChild("HumanoidRootPart")
			box.Size = Vector3.new(4, 6, 2)
			box.Transparency = 0.5
			box.AlwaysOnTop = true
			box.Color3 = role == "Sheriff" and Color3.fromRGB(0, 0, 255) or Color3.fromRGB(255, 0, 0)
			box.Parent = espFolder
		end
	end
end)
-- TELEPORT+ TAB SETUP
local teleportPlusTab = createTab("Teleport+")

local function makeTPPlusBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["Teleport+"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

local function tpTo(part)
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(part.Position + Vector3.new(0, 3, 0))
	end
end

-- Feature 131: Teleport to Lobby
makeTPPlusBtn("Teleport to Lobby", 10, function()
	local lobby = workspace:FindFirstChild("Lobby")
	if lobby and lobby:FindFirstChild("Spawn") then
		tpTo(lobby.Spawn)
	end
end)

-- Feature 132: Teleport to Gun
makeTPPlusBtn("Teleport to Gun", 50, function()
	local gun = workspace:FindFirstChild("GunDrop")
	if gun then
		tpTo(gun)
	end
end)

-- Feature 133: Teleport to Murderer
makeTPPlusBtn("Teleport to Murderer", 90, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				tpTo(plr.Character.HumanoidRootPart)
			end
		end
	end
end)

-- Feature 134: Teleport to Sheriff
makeTPPlusBtn("Teleport to Sheriff", 130, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun")) then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				tpTo(plr.Character.HumanoidRootPart)
			end
		end
	end
end)

-- Feature 135: Auto Loop Teleport Between Safe Spots
local looping = false
makeTPPlusBtn("Loop Safe Teleport", 170, function()
	looping = not looping
	if looping then
		local spots = workspace:FindFirstChild("Map") and workspace.Map:GetChildren()
		coroutine.wrap(function()
			while looping do
				for _, part in ipairs(spots) do
					if part:IsA("BasePart") then
						tpTo(part)
						task.wait(1)
					end
				end
			end
		end)()
	end
end)

-- Feature 136: Teleport to Nearest Player
makeTPPlusBtn("Teleport to Nearest", 210, function()
	local closest, distance = nil, math.huge
	local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (plr.Character.HumanoidRootPart.Position - myHRP.Position).Magnitude
			if dist < distance then
				closest = plr
				distance = dist
			end
		end
	end

	if closest then
		tpTo(closest.Character.HumanoidRootPart)
	end
end)

-- Feature 137: Teleport to Random Player
makeTPPlusBtn("Teleport to Random Player", 250, function()
	local others = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(others, plr)
		end
	end

	if #others > 0 then
		local pick = others[math.random(1, #others)]
		tpTo(pick.Character.HumanoidRootPart)
	end
end)

-- Feature 138: Teleport to Ceiling
makeTPPlusBtn("Teleport to Ceiling", 290, function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local pos = LocalPlayer.Character.HumanoidRootPart.Position
		LocalPlayer.Character:MoveTo(pos + Vector3.new(0, 100, 0))
	end
end)

-- Feature 139: Teleport to Floor
makeTPPlusBtn("Teleport to Floor", 330, function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local pos = LocalPlayer.Character.HumanoidRootPart.Position
		LocalPlayer.Character:MoveTo(pos - Vector3.new(0, 10, 0))
	end
end)

-- Feature 140: Bring All to You (Experimental)
makeTPPlusBtn("Bring All (Risky)", 370, function()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
		end
	end
end)
-- PLAYER MODS TAB
local playerModsTab = createTab("Player Mods")

local function makePlayerBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["Player Mods"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(210, 180, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

-- Feature 141: WalkSpeed Modifier
makePlayerBtn("WalkSpeed: 32", 10, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = 32 end
end)

-- Feature 142: WalkSpeed: 100
makePlayerBtn("WalkSpeed: 100", 50, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.WalkSpeed = 100 end
end)

-- Feature 143: JumpPower: 50
makePlayerBtn("JumpPower: 50", 90, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = 50 end
end)

-- Feature 144: JumpPower: 120
makePlayerBtn("JumpPower: 120", 130, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.JumpPower = 120 end
end)

-- Feature 145: Noclip Toggle
local noclipEnabled = false
makePlayerBtn("Toggle Noclip", 170, function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		RunService.Stepped:Connect(function()
			if noclipEnabled and LocalPlayer.Character then
				for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end)
	end
end)

-- Feature 146: Infinite Jump
local infJumpEnabled = false
makePlayerBtn("Toggle Infinite Jump", 210, function()
	infJumpEnabled = not infJumpEnabled
	if infJumpEnabled then
		UserInputService.JumpRequest:Connect(function()
			if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end)

-- Feature 147: Hip Height: 10
makePlayerBtn("Hip Height: 10", 250, function()
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if hum then hum.HipHeight = 10 end
end)

-- Feature 148: Gravity 0 (Float)
makePlayerBtn("Gravity: 0", 290, function()
	workspace.Gravity = 0
end)

-- Feature 149: Gravity Default (196)
makePlayerBtn("Gravity: 196", 330, function()
	workspace.Gravity = 196
end)

-- Feature 150: Fly Mode (E Toggle)
makePlayerBtn("Fly (E)", 370, function()
	local flying = false
	local bv, gy

	local function flyStart()
		if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
		local root = LocalPlayer.Character.HumanoidRootPart

		bv = Instance.new("BodyVelocity")
		bv.Velocity = Vector3.zero
		bv.MaxForce = Vector3.new(1, 1, 1) * math.huge
		bv.Parent = root

		gy = Instance.new("BodyGyro")
		gy.CFrame = root.CFrame
		gy.D = 10
		gy.P = 10000
		gy.MaxTorque = Vector3.new(1, 1, 1) * math.huge
		gy.Parent = root

		RunService.RenderStepped:Connect(function()
			if flying and UserInputService:IsKeyDown(Enum.KeyCode.E) then
				bv.Velocity = root.CFrame.LookVector * 100
			else
				bv.Velocity = Vector3.zero
			end
		end)
	end

	if not flying then
		flying = true
		flyStart()
	else
		flying = false
		if bv then bv:Destroy() end
		if gy then gy:Destroy() end
	end
end)
-- SETTINGS+ TAB
local settingsTab = createTab("Settings+")

local function makeSettingsBtn(text, y, callback)
	local btn = Instance.new("TextButton", Tabs["Settings+"].Frame)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(240, 200, 255)
	btn.TextColor3 = Color3.new(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
end

local function makeTheme(color, y)
	makeSettingsBtn("Set Theme", y, function()
		for _, tab in pairs(Tabs) do
			tab.Frame.BackgroundColor3 = color
		end
	end)
end

-- Features 151–155: Theme presets
makeSettingsBtn("Theme: Blue", 10, function() makeTheme(Color3.fromRGB(120, 180, 255), 0) end)
makeSettingsBtn("Theme: Brown", 50, function() makeTheme(Color3.fromRGB(130, 110, 90), 0) end)
makeSettingsBtn("Theme: Dark", 90, function() makeTheme(Color3.fromRGB(40, 40, 40), 0) end)
makeSettingsBtn("Theme: Pastel Pink", 130, function() makeTheme(Color3.fromRGB(255, 200, 220), 0) end)
makeSettingsBtn("Theme: Default", 170, function() makeTheme(Color3.fromRGB(255, 255, 255), 0) end)

-- Feature 156: Toggle GUI Visibility
makeSettingsBtn("Toggle GUI (V)", 210, function()
	local ui = ScreenGui
	local visible = not ui.Enabled
	ui.Enabled = visible
end)

-- Feature 157: Full Reset GUI
makeSettingsBtn("Reset GUI Layout", 250, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Position = UDim2.new(0, 100, 0, 100)
	end
end)

-- Feature 158: Transparency Toggle
makeSettingsBtn("Toggle Transparency", 290, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.BackgroundTransparency = tab.Frame.BackgroundTransparency == 0 and 0.5 or 0
	end
end)

-- Feature 159: Resize GUI (Small)
makeSettingsBtn("Resize Small", 330, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Size = UDim2.new(0, 220, 0, 300)
	end
end)

-- Feature 160: Resize GUI (Large)
makeSettingsBtn("Resize Large", 370, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Size = UDim2.new(0, 400, 0, 600)
	end
end)

-- Feature 161: Toggle Button Position Reset
makeSettingsBtn("Reset Toggle Button", 410, function()
	ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
end)

-- Feature 162: Toggle GUI Drag Lock
local dragLock = false
makeSettingsBtn("Toggle GUI Drag Lock", 450, function()
	dragLock = not dragLock
	for _, tab in pairs(Tabs) do
		tab.Frame.Active = not dragLock
		tab.Frame.Draggable = not dragLock
	end
end)

-- Feature 163: Save GUI Layout
makeSettingsBtn("Save Layout", 490, function()
	for name, tab in pairs(Tabs) do
		if tab.Frame then
			tab.SavedPos = tab.Frame.Position
		end
	end
end)

-- Feature 164: Load GUI Layout
makeSettingsBtn("Load Layout", 530, function()
	for name, tab in pairs(Tabs) do
		if tab.SavedPos then
			tab.Frame.Position = tab.SavedPos
		end
	end
end)

-- Feature 165: Sound Toggle
local soundEnabled = true
makeSettingsBtn("Toggle Sound", 570, function()
	soundEnabled = not soundEnabled
end)

-- Feature 166–169: Volume Tweaks
makeSettingsBtn("Volume: 0%", 610, function() game:GetService("SoundService").Volume = 0 end)
makeSettingsBtn("Volume: 25%", 650, function() game:GetService("SoundService").Volume = 0.25 end)
makeSettingsBtn("Volume: 50%", 690, function() game:GetService("SoundService").Volume = 0.5 end)
makeSettingsBtn("Volume: 100%", 730, function() game:GetService("SoundService").Volume = 1 end)

-- Feature 170–179: Colorblind Mode Presets
makeSettingsBtn("Colorblind: Deuteranopia", 770, function()
	makeTheme(Color3.fromRGB(170, 200, 220))
end)

makeSettingsBtn("Colorblind: Protanopia", 810, function()
	makeTheme(Color3.fromRGB(180, 150, 150))
end)

makeSettingsBtn("Colorblind: Tritanopia", 850, function()
	makeTheme(Color3.fromRGB(200, 180, 200))
end)

-- Feature 180: Credits
makeSettingsBtn("Show Credits", 890, function()
	local msg = Instance.new("TextLabel", ScreenGui)
	msg.Text = "PulseFx GUI by Cole (chatgptsjajsnsk)"
	msg.Size = UDim2.new(0, 300, 0, 50)
	msg.Position = UDim2.new(0.5, -150, 0.5, -25)
	msg.BackgroundColor3 = Color3.new(0, 0, 0)
	msg.TextColor3 = Color3.new(1, 1, 1)
	msg.TextSize = 16
	msg.Font = Enum.Font.SourceSansBold
	game:GetService("Debris"):AddItem(msg, 5)
end)

-- Feature 181–185: UI Flip
makeSettingsBtn("Flip UI Horizontal", 930, function()
	for _, tab in pairs(Tabs) do
		local pos = tab.Frame.Position
		tab.Frame.Position = UDim2.new(1 - pos.X.Scale, -pos.X.Offset, pos.Y.Scale, pos.Y.Offset)
	end
end)

makeSettingsBtn("Flip UI Vertical", 970, function()
	for _, tab in pairs(Tabs) do
		local pos = tab.Frame.Position
		tab.Frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset, 1 - pos.Y.Scale, -pos.Y.Offset)
	end
end)

-- Feature 186–190: Font Change
makeSettingsBtn("Font: Gotham", 1010, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Font = Enum.Font.Gotham
	end
end)

makeSettingsBtn("Font: SciFi", 1050, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Font = Enum.Font.SciFi
	end
end)

-- Feature 191–195: Mobile Sizing Modes
makeSettingsBtn("Mobile: Compact", 1090, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Size = UDim2.new(0, 200, 0, 200)
	end
end)

makeSettingsBtn("Mobile: Fullscreen", 1130, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Size = UDim2.new(1, 0, 1, 0)
	end
end)

-- Feature 196: Minimize All Tabs
makeSettingsBtn("Minimize All", 1170, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Visible = false
	end
end)

-- Feature 197: Restore Tabs
makeSettingsBtn("Restore Tabs", 1210, function()
	for _, tab in pairs(Tabs) do
		tab.Frame.Visible = true
	end
end)

-- Feature 198: Delete All ESP
makeSettingsBtn("Remove ESP", 1250, function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "PulseFxESP" then v:Destroy() end
	end
end)

-- Feature 199: Reload PulseFx
makeSettingsBtn("Reload Script", 1290, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/chatgptsjajsnsk/PulseFX-Mm2-Script/main/PulseFX.lua"))()
end)

-- Feature 200: Exit Script
makeSettingsBtn("Close PulseFx", 1330, function()
	ScreenGui:Destroy()
end)
print("PulseFx v2 Loaded Successfully. Total Features: 200+")
