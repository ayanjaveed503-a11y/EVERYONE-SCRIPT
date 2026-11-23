-- Universal Executor Compatibility & Services Check
local CoreGui = game:FindFirstChild("CoreGui") or game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Safe Parent determination for different executors
local guiParent = CoreGui
pcall(function()
	if gethui then
		guiParent = gethui()
	end
end)

-- Cleanup old GUI if exists
if guiParent:FindFirstChild("ShivSpammerGUI") then
	guiParent.ShivSpammerGUI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShivSpammerGUI"
ScreenGui.Parent = guiParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

----------------------------------------------------------------
-- 1. MAIN CRIMSON & EMERALD GLASS GUI WINDOW (Draggable)
----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 430, 0, 385)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -192)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 85, 50)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Clean Unblurred Background Image (107960099565624)
local BgImage = Instance.new("ImageLabel")
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.Position = UDim2.new(0, 0, 0, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = "rbxassetid://107960099565624"
BgImage.ImageTransparency = 0
BgImage.ScaleType = Enum.ScaleType.Stretch
BgImage.ZIndex = 1
BgImage.Parent = MainFrame

local BgCorner = Instance.new("UICorner")
BgCorner.CornerRadius = UDim.new(0, 20)
BgCorner.Parent = BgImage

-- Top Header Bar
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 48)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(28, 16, 36)
HeaderFrame.BackgroundTransparency = 0.25
HeaderFrame.BorderSizePixel = 0
HeaderFrame.ZIndex = 3
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 20)
HeaderCorner.Parent = HeaderFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "🔥 SHIV SPAMMER 🔥"
TitleLabel.TextColor3 = Color3.fromRGB(255, 165, 60)
TitleLabel.TextSize = 16
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = HeaderFrame

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -42, 0.5, -16)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 50)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.ZIndex = 5
MinimizeBtn.Parent = HeaderFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeBtn

----------------------------------------------------------------
-- 2. INPUT FIELDS (SINGLE TARGET & SYMBOL PATTERN)
----------------------------------------------------------------
local function createInput(labelText, placeholder, defaultText, posX, posY, accentColor)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 190, 0, 16)
	lbl.Position = UDim2.new(0, posX, 0, posY)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = labelText
	lbl.TextColor3 = accentColor
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 3
	lbl.Parent = MainFrame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 190, 0, 36)
	box.Position = UDim2.new(0, posX, 0, posY + 18)
	box.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
	box.BackgroundTransparency = 0.3
	box.BorderSizePixel = 0
	box.Font = Enum.Font.GothamMedium
	box.PlaceholderText = placeholder
	box.Text = defaultText
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.ZIndex = 3
	box.Parent = MainFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = 0.75
	stroke.Thickness = 1
	stroke.Parent = box

	return box
end

local TargetBox = createInput("🎯 SINGLE TARGET", "Target username...", "", 20, 62, Color3.fromRGB(255, 165, 60))
local SymbolBox = createInput("✦ SYMBOL PATTERN", "+++--- +++//===", "+++--- +++//===", 220, 62, Color3.fromRGB(255, 165, 60))

----------------------------------------------------------------
-- 3. SHIV ANTI-AFK ON/OFF & SLOW / FAST SPEED TOGGLE
----------------------------------------------------------------
local shivAfkActive = true

local AfkToggleBtn = Instance.new("TextButton")
AfkToggleBtn.Size = UDim2.new(0, 190, 0, 54)
AfkToggleBtn.Position = UDim2.new(0, 20, 0, 124)
AfkToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
AfkToggleBtn.BackgroundTransparency = 0.25
AfkToggleBtn.Font = Enum.Font.GothamBlack
AfkToggleBtn.Text = "🛡️ SHIV AFK: ON"
AfkToggleBtn.TextColor3 = Color3.fromRGB(80, 250, 123)
AfkToggleBtn.TextSize = 13
AfkToggleBtn.ZIndex = 4
AfkToggleBtn.Parent = MainFrame

local AfkBtnCorner = Instance.new("UICorner")
AfkBtnCorner.CornerRadius = UDim.new(0, 10)
AfkBtnCorner.Parent = AfkToggleBtn

local AfkBtnStroke = Instance.new("UIStroke")
AfkBtnStroke.Color = Color3.fromRGB(80, 250, 123)
AfkBtnStroke.Transparency = 0.35
AfkBtnStroke.Thickness = 1.2
AfkBtnStroke.Parent = AfkToggleBtn

AfkToggleBtn.MouseButton1Click:Connect(function()
	shivAfkActive = not shivAfkActive
	if shivAfkActive then
		AfkToggleBtn.Text = "🛡️ SHIV AFK: ON"
		AfkToggleBtn.TextColor3 = Color3.fromRGB(80, 250, 123)
		AfkBtnStroke.Color = Color3.fromRGB(80, 250, 123)
	else
		AfkToggleBtn.Text = "🛡️ SHIV AFK: OFF"
		AfkToggleBtn.TextColor3 = Color3.fromRGB(255, 95, 95)
		AfkBtnStroke.Color = Color3.fromRGB(255, 95, 95)
	end
end)

-- Slow / Fast Speed Button (Replaces Delay Speed)
local isFastMode = false

local SpeedModeBtn = Instance.new("TextButton")
SpeedModeBtn.Size = UDim2.new(0, 190, 0, 54)
SpeedModeBtn.Position = UDim2.new(0, 220, 0, 124)
SpeedModeBtn.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
SpeedModeBtn.BackgroundTransparency = 0.25
SpeedModeBtn.Font = Enum.Font.GothamBlack
SpeedModeBtn.Text = "🐢 SPEED: SLOW"
SpeedModeBtn.TextColor3 = Color3.fromRGB(80, 227, 194)
SpeedModeBtn.TextSize = 13
SpeedModeBtn.ZIndex = 4
SpeedModeBtn.Parent = MainFrame

local SpeedModeCorner = Instance.new("UICorner")
SpeedModeCorner.CornerRadius = UDim.new(0, 10)
SpeedModeCorner.Parent = SpeedModeBtn

local SpeedModeStroke = Instance.new("UIStroke")
SpeedModeStroke.Color = Color3.fromRGB(80, 227, 194)
SpeedModeStroke.Transparency = 0.35
SpeedModeStroke.Thickness = 1.2
SpeedModeStroke.Parent = SpeedModeBtn

SpeedModeBtn.MouseButton1Click:Connect(function()
	isFastMode = not isFastMode
	if isFastMode then
		SpeedModeBtn.Text = "⚡ SPEED: FAST"
		SpeedModeBtn.TextColor3 = Color3.fromRGB(255, 200, 60)
		SpeedModeStroke.Color = Color3.fromRGB(255, 200, 60)
	else
		SpeedModeBtn.Text = "🐢 SPEED: SLOW"
		SpeedModeBtn.TextColor3 = Color3.fromRGB(80, 227, 194)
		SpeedModeStroke.Color = Color3.fromRGB(80, 227, 194)
	end
end)

----------------------------------------------------------------
-- 4. AUTO SYMBOL & UNLIMITED TARGETS BUTTONS
----------------------------------------------------------------
local MultiBtn = Instance.new("TextButton")
MultiBtn.Size = UDim2.new(0, 190, 0, 40)
MultiBtn.Position = UDim2.new(0, 20, 0, 192)
MultiBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 66)
MultiBtn.BackgroundTransparency = 0.2
MultiBtn.Font = Enum.Font.GothamBold
MultiBtn.Text = "👥 UNLIMITED TARGETS"
MultiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiBtn.TextSize = 12
MultiBtn.ZIndex = 3
MultiBtn.Parent = MainFrame

local MultiBtnCorner = Instance.new("UICorner")
MultiBtnCorner.CornerRadius = UDim.new(0, 12)
MultiBtnCorner.Parent = MultiBtn

local AutoSymbolBtn = Instance.new("TextButton")
AutoSymbolBtn.Size = UDim2.new(0, 190, 0, 40)
AutoSymbolBtn.Position = UDim2.new(0, 220, 0, 192)
AutoSymbolBtn.BackgroundColor3 = Color3.fromRGB(45, 28, 66)
AutoSymbolBtn.BackgroundTransparency = 0.2
AutoSymbolBtn.Font = Enum.Font.GothamBold
AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: OFF"
AutoSymbolBtn.TextColor3 = Color3.fromRGB(255, 95, 95)
AutoSymbolBtn.TextSize = 12
AutoSymbolBtn.ZIndex = 3
AutoSymbolBtn.Parent = MainFrame

local AutoSymbolCorner = Instance.new("UICorner")
AutoSymbolCorner.CornerRadius = UDim.new(0, 12)
AutoSymbolCorner.Parent = AutoSymbolBtn

local autoSymbolsActive = false
AutoSymbolBtn.MouseButton1Click:Connect(function()
	autoSymbolsActive = not autoSymbolsActive
	if autoSymbolsActive then
		AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: ON"
		AutoSymbolBtn.TextColor3 = Color3.fromRGB(80, 250, 123)
	else
		AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: OFF"
		AutoSymbolBtn.TextColor3 = Color3.fromRGB(255, 95, 95)
	end
end)

----------------------------------------------------------------
-- 5. UNLIMITED TARGETS POPUP PANEL (SCROLL + ADD + ❌ DELETE)
----------------------------------------------------------------
local multiTargetList = {}

local MultiPanel = Instance.new("Frame")
MultiPanel.Size = UDim2.new(0, 340, 0, 265)
MultiPanel.Position = UDim2.new(0.5, -170, 0.5, -132)
MultiPanel.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
MultiPanel.BackgroundTransparency = 0.08
MultiPanel.BorderSizePixel = 0
MultiPanel.Visible = false
MultiPanel.ZIndex = 10
MultiPanel.Parent = ScreenGui

local MultiPanelCorner = Instance.new("UICorner")
MultiPanelCorner.CornerRadius = UDim.new(0, 16)
MultiPanelCorner.Parent = MultiPanel

local MultiPanelStroke = Instance.new("UIStroke")
MultiPanelStroke.Color = Color3.fromRGB(255, 165, 60)
MultiPanelStroke.Thickness = 2
MultiPanelStroke.Parent = MultiPanel

local MultiPanelTitle = Instance.new("TextLabel")
MultiPanelTitle.Size = UDim2.new(1, 0, 0, 34)
MultiPanelTitle.BackgroundTransparency = 1
MultiPanelTitle.Font = Enum.Font.GothamBold
MultiPanelTitle.Text = "🔥 SHIV UNLIMITED TARGETS 🔥"
MultiPanelTitle.TextColor3 = Color3.fromRGB(255, 165, 60)
MultiPanelTitle.TextSize = 13
MultiPanelTitle.ZIndex = 11
MultiPanelTitle.Parent = MultiPanel

local MultiInputBox = Instance.new("TextBox")
MultiInputBox.Size = UDim2.new(1, -20, 0, 36)
MultiInputBox.Position = UDim2.new(0, 10, 0, 36)
MultiInputBox.BackgroundColor3 = Color3.fromRGB(34, 24, 50)
MultiInputBox.BorderSizePixel = 0
MultiInputBox.Font = Enum.Font.Gotham
MultiInputBox.PlaceholderText = "Add target username..."
MultiInputBox.Text = ""
MultiInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiInputBox.TextSize = 12
MultiInputBox.ClearTextOnFocus = false
MultiInputBox.ZIndex = 11
MultiInputBox.Parent = MultiPanel

local MultiInputCorner = Instance.new("UICorner")
MultiInputCorner.CornerRadius = UDim.new(0, 8)
MultiInputCorner.Parent = MultiInputBox

local AddTargetBtn = Instance.new("TextButton")
AddTargetBtn.Size = UDim2.new(0, 150, 0, 32)
AddTargetBtn.Position = UDim2.new(0, 10, 0, 78)
AddTargetBtn.BackgroundColor3 = Color3.fromRGB(80, 227, 194)
AddTargetBtn.Font = Enum.Font.GothamBold
AddTargetBtn.Text = "➕ ADD TARGET"
AddTargetBtn.TextColor3 = Color3.fromRGB(10, 10, 15)
AddTargetBtn.TextSize = 11
AddTargetBtn.ZIndex = 11
AddTargetBtn.Parent = MultiPanel

local AddTargetCorner = Instance.new("UICorner")
AddTargetCorner.CornerRadius = UDim.new(0, 8)
AddTargetCorner.Parent = AddTargetBtn

local SavePanelBtn = Instance.new("TextButton")
SavePanelBtn.Size = UDim2.new(0, 150, 0, 32)
SavePanelBtn.Position = UDim2.new(1, -160, 0, 78)
SavePanelBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 60)
SavePanelBtn.Font = Enum.Font.GothamBold
SavePanelBtn.Text = "✔ SAVE & CLOSE"
SavePanelBtn.TextColor3 = Color3.fromRGB(10, 10, 15)
SavePanelBtn.TextSize = 11
SavePanelBtn.ZIndex = 11
SavePanelBtn.Parent = MultiPanel

local SavePanelCorner = Instance.new("UICorner")
SavePanelCorner.CornerRadius = UDim.new(0, 8)
SavePanelCorner.Parent = SavePanelBtn

local TargetScrollFrame = Instance.new("ScrollingFrame")
TargetScrollFrame.Size = UDim2.new(1, -20, 0, 135)
TargetScrollFrame.Position = UDim2.new(0, 10, 0, 118)
TargetScrollFrame.BackgroundColor3 = Color3.fromRGB(14, 10, 22)
TargetScrollFrame.BorderSizePixel = 0
TargetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TargetScrollFrame.ScrollBarThickness = 4
TargetScrollFrame.ZIndex = 11
TargetScrollFrame.Parent = MultiPanel

local TargetScrollCorner = Instance.new("UICorner")
TargetScrollCorner.CornerRadius = UDim.new(0, 10)
TargetScrollCorner.Parent = TargetScrollFrame

local TargetListLayout = Instance.new("UIListLayout")
TargetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TargetListLayout.Padding = UDim.new(0, 5)
TargetListLayout.Parent = TargetScrollFrame

MultiBtn.MouseButton1Click:Connect(function()
	MultiPanel.Visible = not MultiPanel.Visible
end)

SavePanelBtn.MouseButton1Click:Connect(function()
	MultiPanel.Visible = false
end)

AddTargetBtn.MouseButton1Click:Connect(function()
	local cleanName = MultiInputBox.Text:match("^%s*(.-)%s*$")
	if cleanName ~= "" then
		table.insert(multiTargetList, cleanName)

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -6, 0, 28)
		row.BackgroundColor3 = Color3.fromRGB(32, 22, 48)
		row.BorderSizePixel = 0
		row.ZIndex = 12
		row.Parent = TargetScrollFrame

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Size = UDim2.new(1, -34, 1, 0)
		nameLbl.Position = UDim2.new(0, 8, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Font = Enum.Font.Gotham
		nameLbl.Text = cleanName
		nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLbl.TextSize = 11
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.ZIndex = 13
		nameLbl.Parent = row

		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0, 24, 0, 22)
		delBtn.Position = UDim2.new(1, -28, 0.5, -11)
		delBtn.BackgroundColor3 = Color3.fromRGB(235, 64, 52)
		delBtn.Font = Enum.Font.GothamBold
		delBtn.Text = "❌"
		delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		delBtn.TextSize = 10
		delBtn.ZIndex = 13
		delBtn.Parent = row

		local delCorner = Instance.new("UICorner")
		delCorner.CornerRadius = UDim.new(0, 5)
		delCorner.Parent = delBtn

		delBtn.MouseButton1Click:Connect(function()
			for idx, val in ipairs(multiTargetList) do
				if val == cleanName then
					table.remove(multiTargetList, idx)
					break
				end
			end
			row:Destroy()
			TargetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TargetListLayout.AbsoluteContentSize.Y + 8)
		end)

		TargetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TargetListLayout.AbsoluteContentSize.Y + 8)
		MultiInputBox.Text = ""
	end
end)

----------------------------------------------------------------
-- 6. START / STOP BUTTON & FOOTER STATUS (WITH BOTTOM TIMER)
----------------------------------------------------------------
local SpamBtn = Instance.new("TextButton")
SpamBtn.Size = UDim2.new(0, 390, 0, 44)
SpamBtn.Position = UDim2.new(0, 20, 0, 248)
SpamBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
SpamBtn.Font = Enum.Font.GothamBlack
SpamBtn.Text = "▶ START SHIV SPAM"
SpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamBtn.TextSize = 14
SpamBtn.ZIndex = 3
SpamBtn.Parent = MainFrame

local SpamBtnCorner = Instance.new("UICorner")
SpamBtnCorner.CornerRadius = UDim.new(0, 12)
SpamBtnCorner.Parent = SpamBtn

-- Footer Left: Status
local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(0, 130, 0, 22)
StatusLbl.Position = UDim2.new(0, 20, 0, 312)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.Text = "● IDLE / READY"
StatusLbl.TextColor3 = Color3.fromRGB(220, 220, 235)
StatusLbl.TextSize = 11
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.ZIndex = 3
StatusLbl.Parent = MainFrame

-- Footer Center: SHIV AFK + Live Time Below It
local FooterAfkTitle = Instance.new("TextLabel")
FooterAfkTitle.Size = UDim2.new(0, 120, 0, 16)
FooterAfkTitle.Position = UDim2.new(0.5, -60, 0, 306)
FooterAfkTitle.BackgroundTransparency = 1
FooterAfkTitle.Font = Enum.Font.GothamBlack
FooterAfkTitle.Text = "SHIV AFK"
FooterAfkTitle.TextColor3 = Color3.fromRGB(255, 75, 75)
FooterAfkTitle.TextSize = 11
FooterAfkTitle.ZIndex = 3
FooterAfkTitle.Parent = MainFrame

local FooterTimeLbl = Instance.new("TextLabel")
FooterTimeLbl.Size = UDim2.new(0, 120, 0, 16)
FooterTimeLbl.Position = UDim2.new(0.5, -60, 0, 323)
FooterTimeLbl.BackgroundTransparency = 1
FooterTimeLbl.Font = Enum.Font.Code
FooterTimeLbl.Text = "000:00:00"
FooterTimeLbl.TextColor3 = Color3.fromRGB(80, 250, 123)
FooterTimeLbl.TextSize = 12
FooterTimeLbl.ZIndex = 3
FooterTimeLbl.Parent = MainFrame

-- Footer Right: Branding
local BrandLbl = Instance.new("TextLabel")
BrandLbl.Size = UDim2.new(0, 130, 0, 22)
BrandLbl.Position = UDim2.new(1, -150, 0, 312)
BrandLbl.BackgroundTransparency = 1
BrandLbl.Font = Enum.Font.GothamBold
BrandLbl.Text = "🔥 SHIV SPAMMER 🔥"
BrandLbl.TextColor3 = Color3.fromRGB(255, 165, 60)
BrandLbl.TextSize = 11
BrandLbl.TextXAlignment = Enum.TextXAlignment.Right
BrandLbl.ZIndex = 3
BrandLbl.Parent = MainFrame

----------------------------------------------------------------
-- 7. FLOATING DRAGGABLE BUBBLE TOGGLE (ID: 81340771428973)
----------------------------------------------------------------
local FloatBtn = Instance.new("ImageButton")
FloatBtn.Size = UDim2.new(0, 58, 0, 58)
FloatBtn.Position = UDim2.new(0, 24, 0.5, -29)
FloatBtn.BackgroundColor3 = Color3.fromRGB(28, 16, 36)
FloatBtn.BackgroundTransparency = 0.1
FloatBtn.BorderSizePixel = 0
FloatBtn.Image = "rbxassetid://81340771428973"
FloatBtn.ScaleType = Enum.ScaleType.Crop
FloatBtn.Visible = false
FloatBtn.ZIndex = 6
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 85, 50)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	FloatBtn.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

FloatBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = FloatBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

FloatBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

MinimizeBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	FloatBtn.Visible = false
end)

----------------------------------------------------------------
-- 8. ANTI-AFK ENGINE & LIVE TIMER LOOP
----------------------------------------------------------------
if LocalPlayer then
	LocalPlayer.Idled:Connect(function()
		if not shivAfkActive then return end
		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(0, 0))
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
				LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end)
end

local startTime = tick()
local pausedTime = 0
local lastTick = tick()

task.spawn(function()
	while ScreenGui and ScreenGui.Parent do
		local now = tick()
		if shivAfkActive then
			local activeElapsed = (now - startTime) - pausedTime
			local hours = math.floor(activeElapsed / 3600)
			local minutes = math.floor((activeElapsed % 3600) / 60)
			local seconds = math.floor(activeElapsed % 60)
			FooterTimeLbl.Text = string.format("%03d:%02d:%02d", hours, minutes, seconds)
		else
			pausedTime = pausedTime + (now - lastTick)
		end
		lastTick = now
		task.wait(1)
	end
end)

----------------------------------------------------------------
-- 9. UNIVERSAL CHAT SENDER & HEAVY SYMBOL SPAM ENGINE
----------------------------------------------------------------
local function sendChat(msg)
	local sent = false
	pcall(function()
		local generalChannel = TextChatService and TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if generalChannel then
			generalChannel:SendAsync(msg)
			sent = true
		end
	end)

	if not sent then
		pcall(function()
			local legacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
			if legacyChat and legacyChat:FindFirstChild("SayMessageRequest") then
				legacyChat.SayMessageRequest:FireServer(msg, "All")
				sent = true
			end
		end)
	end
end

-- Startup Chat Message
task.spawn(function()
	task.wait(1)
	sendChat("[🔥SHIV SPAMMER LOAD..🔥]")
end)

local function collectTargets()
	local list = {}
	for _, t in ipairs(multiTargetList) do
		table.insert(list, t)
	end
	local single = TargetBox.Text:match("^%s*(.-)%s*$")
	if single ~= "" then
		table.insert(list, single)
	end
	return list
end

-- Heavy & Extended Symbol Patterns
local symbolPatterns = {
	"+++---+++//===//===\\\\\\\\-+++---+++//===//===\\\\\\\\+++---+++//===//===\\\\\\\\+++---+++//===//===",
	"///===/\\==\\\\V//==\\\\\\\\==\\\\V//===/\\==\\\\V//===/\\==\\\\V//===/\\==\\\\V//===/\\==\\\\V//===/",
	"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@",
	"===///===\\\\\\===///===\\\\\\===///===\\\\\\===///===\\\\\\===///===\\\\\\===///===\\\\\\===///===",
	"###$$$%%%&&&***+++===---///\\\\\\###$$$%%%&&&***+++===---///\\\\\\###$$$%%%&&&***+++===---///\\\\\\",
	"<<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<<>>><<"
}

-- 10 Fresh High-Impact Messages
local shivMessages = {
	"TMK MARE⚡ GODZILA POWER SONIC BEEM UNLEASHED 100% MAXIMUM DESTRUCTION OVERLOAD 🔥💥",
	"TMX MEH 🦍 SUPER ULTRA BRAZIL TIGER GORILLA PUNCH COMING THROUGH WITH UNSTOPPABLE JUNGLE FURY RAGE 🐯🌪️",
	"TMK MARE 🌊 SUPER MEGA POWER WAVE TSUNAMI BLAST ACTIVATED ACROSS THE ENTIRE SERVER DIMENSION 💨🚀",
	"TMX MEH 🐅 ULTIMATE BEAST MODE ACTIVATED: GODZILA ROAR COMBINED WITH TIGER SPEED AND GORILLA SMASH 🦖🔥",
	"TMK MARE⚡ ULTIMATE SONIC BEEM DESTRUCTION RAY BURNING DOWN EVERYTHING IN SIGHT 💥⚡",
	"TMX MEH 🦍 BRAZIL TIGER HYPER DRIFT KICK MEETS GORILLA EARTHQUAKE SMASH COMBO OF DOOM 🌍💪",
	"TMK MARE 🌊 MEGA POWER WAVE IS OVERWHELMING THE ENTIRE SERVER WITH TIDAL WAVE TSUNAMI ENERGY ⚡🌊",
	"TMX MEH 🦖 WARNING: SHIV POWER IS COMPLETELY UNSTOPPABLE IN THE CHAT ROOM RIGHT NOW 👑📢",
	"TMK MARE 🦍 GORILLA PUNCH EARTHQUAKE SHAKE CAUSING MASSIVE DAMAGE EVERYWHERE 🌍📉💥",
	"TMX MEH ⚡ SONIC BEEM CHARGING UP TO MAXIMUM OVERDRIVE POWER LEVEL INFINITE LIGHTNING SPEED 🔋♾️"
}

local isRunning = false

SpamBtn.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	if isRunning then
		SpamBtn.Text = "■ STOP SHIV SPAM"
		SpamBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
		StatusLbl.Text = "● SPAMMING ACTIVE"
	else
		SpamBtn.Text = "▶ START SHIV SPAM"
		SpamBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
		StatusLbl.Text = "● IDLE / READY"
	end
end)

task.spawn(function()
	local targetIdx = 1
	local symIdx = 1

	while true do
		if isRunning then
			local targets = collectTargets()
			local delaySec = isFastMode and 0.35 or 1.5

			for _, baseMsg in ipairs(shivMessages) do
				if not isRunning then break end

				targets = collectTargets()
				local targetTag = ""
				if #targets > 0 then
					if targetIdx > #targets then targetIdx = 1 end
					targetTag = "[" .. targets[targetIdx] .. "] "
					targetIdx = targetIdx + 1
				end

				local activePattern = ""
				if autoSymbolsActive then
					activePattern = symbolPatterns[symIdx]
					symIdx = (symIdx % #symbolPatterns) + 1
				else
					local customSym = SymbolBox.Text
					if customSym == "" then
						activePattern = symbolPatterns[1]
					else
						local repeatCount = math.max(1, math.ceil(105 / #customSym))
						activePattern = string.sub(string.rep(customSym, repeatCount), 1, 110)
					end
				end

				local fullLine = activePattern .. " " .. targetTag .. baseMsg
				sendChat(fullLine)
				task.wait(delaySec)
			end
		else
			task.wait(0.5)
		end
	end
end)
