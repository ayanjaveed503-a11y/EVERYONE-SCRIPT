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
if guiParent:FindFirstChild("UmairSpammerGUI") then
	guiParent.UmairSpammerGUI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UmairSpammerGUI"
ScreenGui.Parent = guiParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

----------------------------------------------------------------
-- 1. COMPLETELY NEW OBSIDIAN & EMERALD GLASS GUI (Draggable)
----------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 440, 0, 390)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 15, 19)
MainFrame.BackgroundTransparency = 0.12
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 22)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(16, 185, 129)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Subtle Top Accent Strip
local TopGlowBar = Instance.new("Frame")
TopGlowBar.Size = UDim2.new(1, 0, 0, 4)
TopGlowBar.Position = UDim2.new(0, 0, 0, 0)
TopGlowBar.BackgroundColor3 = Color3.fromRGB(52, 211, 153)
TopGlowBar.BorderSizePixel = 0
TopGlowBar.ZIndex = 4
TopGlowBar.Parent = MainFrame

-- Top Header Bar
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, -24, 0, 44)
HeaderFrame.Position = UDim2.new(0, 12, 0, 10)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(18, 25, 31)
HeaderFrame.BackgroundTransparency = 0.25
HeaderFrame.BorderSizePixel = 0
HeaderFrame.ZIndex = 3
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = HeaderFrame

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Color3.fromRGB(16, 185, 129)
HeaderStroke.Transparency = 0.65
HeaderStroke.Thickness = 1
HeaderStroke.Parent = HeaderFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -85, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.Text = "⚡ UMAIR SPAMMER"
TitleLabel.TextColor3 = Color3.fromRGB(110, 231, 183)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 4
TitleLabel.Parent = HeaderFrame

local BadgeLabel = Instance.new("TextLabel")
BadgeLabel.Size = UDim2.new(0, 72, 0, 22)
BadgeLabel.Position = UDim2.new(1, -122, 0.5, -11)
BadgeLabel.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
BadgeLabel.BackgroundTransparency = 0.78
BadgeLabel.Font = Enum.Font.GothamBold
BadgeLabel.Text = "V2.5"
BadgeLabel.TextColor3 = Color3.fromRGB(167, 243, 208)
BadgeLabel.TextSize = 10
BadgeLabel.ZIndex = 4
BadgeLabel.Parent = HeaderFrame

Instance.new("UICorner", BadgeLabel).CornerRadius = UDim.new(0, 8)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -38, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(10, 15, 18)
MinimizeBtn.TextSize = 13
MinimizeBtn.ZIndex = 5
MinimizeBtn.Parent = HeaderFrame

Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(1, 0)

----------------------------------------------------------------
-- 2. LEFT COLUMN (TOGGLES) & RIGHT COLUMN (INPUTS)
----------------------------------------------------------------
local function createCardInput(labelText, placeholder, defaultText, posX, posY, width, labelColor)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(0, width, 0, 56)
	card.Position = UDim2.new(0, posX, 0, posY)
	card.BackgroundColor3 = Color3.fromRGB(17, 23, 29)
	card.BackgroundTransparency = 0.2
	card.BorderSizePixel = 0
	card.ZIndex = 3
	card.Parent = MainFrame

	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(55, 75, 88)
	stroke.Transparency = 0.55
	stroke.Thickness = 1
	stroke.Parent = card

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 0, 16)
	lbl.Position = UDim2.new(0, 10, 0, 4)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = labelText
	lbl.TextColor3 = labelColor
	lbl.TextSize = 10
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 4
	lbl.Parent = card

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -16, 0, 26)
	box.Position = UDim2.new(0, 8, 0, 22)
	box.BackgroundColor3 = Color3.fromRGB(10, 14, 18)
	box.BackgroundTransparency = 0.35
	box.BorderSizePixel = 0
	box.Font = Enum.Font.GothamMedium
	box.PlaceholderText = placeholder
	box.Text = defaultText
	box.TextColor3 = Color3.fromRGB(240, 253, 250)
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.ZIndex = 4
	box.Parent = card

	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	return box
end

local TargetBox = createCardInput("🎯 SINGLE TARGET", "Target username...", "", 226, 66, 202, Color3.fromRGB(110, 231, 183))
local SymbolBox = createCardInput("✦ SYMBOL PATTERN", "+++---+++//===//===\\\\\\-", "+++---+++//===//===\\\\\\-", 226, 132, 202, Color3.fromRGB(56, 189, 248))

-- Left Side: UMAIR AFK Toggle & SLOW/FAST Speed Toggle
local umairAfkActive = true

local AfkToggleBtn = Instance.new("TextButton")
AfkToggleBtn.Size = UDim2.new(0, 202, 0, 56)
AfkToggleBtn.Position = UDim2.new(0, 12, 0, 66)
AfkToggleBtn.BackgroundColor3 = Color3.fromRGB(17, 23, 29)
AfkToggleBtn.BackgroundTransparency = 0.2
AfkToggleBtn.Font = Enum.Font.GothamBlack
AfkToggleBtn.Text = "🛡️ UMAIR AFK: ON"
AfkToggleBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
AfkToggleBtn.TextSize = 12
AfkToggleBtn.ZIndex = 4
AfkToggleBtn.Parent = MainFrame

Instance.new("UICorner", AfkToggleBtn).CornerRadius = UDim.new(0, 12)

local AfkBtnStroke = Instance.new("UIStroke")
AfkBtnStroke.Color = Color3.fromRGB(74, 222, 128)
AfkBtnStroke.Transparency = 0.35
AfkBtnStroke.Thickness = 1.2
AfkBtnStroke.Parent = AfkToggleBtn

AfkToggleBtn.MouseButton1Click:Connect(function()
	umairAfkActive = not umairAfkActive
	if umairAfkActive then
		AfkToggleBtn.Text = "🛡️ UMAIR AFK: ON"
		AfkToggleBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
		AfkBtnStroke.Color = Color3.fromRGB(74, 222, 128)
	else
		AfkToggleBtn.Text = "🛡️ UMAIR AFK: OFF"
		AfkToggleBtn.TextColor3 = Color3.fromRGB(248, 113, 113)
		AfkBtnStroke.Color = Color3.fromRGB(248, 113, 113)
	end
end)

local isFastMode = false

local SpeedModeBtn = Instance.new("TextButton")
SpeedModeBtn.Size = UDim2.new(0, 202, 0, 56)
SpeedModeBtn.Position = UDim2.new(0, 12, 0, 132)
SpeedModeBtn.BackgroundColor3 = Color3.fromRGB(17, 23, 29)
SpeedModeBtn.BackgroundTransparency = 0.2
SpeedModeBtn.Font = Enum.Font.GothamBlack
SpeedModeBtn.Text = "🐢 SPEED: SLOW"
SpeedModeBtn.TextColor3 = Color3.fromRGB(56, 189, 248)
SpeedModeBtn.TextSize = 12
SpeedModeBtn.ZIndex = 4
SpeedModeBtn.Parent = MainFrame

Instance.new("UICorner", SpeedModeBtn).CornerRadius = UDim.new(0, 12)

local SpeedModeStroke = Instance.new("UIStroke")
SpeedModeStroke.Color = Color3.fromRGB(56, 189, 248)
SpeedModeStroke.Transparency = 0.35
SpeedModeStroke.Thickness = 1.2
SpeedModeStroke.Parent = SpeedModeBtn

SpeedModeBtn.MouseButton1Click:Connect(function()
	isFastMode = not isFastMode
	if isFastMode then
		SpeedModeBtn.Text = "⚡ SPEED: FAST"
		SpeedModeBtn.TextColor3 = Color3.fromRGB(250, 204, 21)
		SpeedModeStroke.Color = Color3.fromRGB(250, 204, 21)
	else
		SpeedModeBtn.Text = "🐢 SPEED: SLOW"
		SpeedModeBtn.TextColor3 = Color3.fromRGB(56, 189, 248)
		SpeedModeStroke.Color = Color3.fromRGB(56, 189, 248)
	end
end)

----------------------------------------------------------------
-- 3. MIDDLE ROW: UNLIMITED TARGETS & AUTO SYMBOL
----------------------------------------------------------------
local MultiBtn = Instance.new("TextButton")
MultiBtn.Size = UDim2.new(0, 202, 0, 42)
MultiBtn.Position = UDim2.new(0, 12, 0, 198)
MultiBtn.BackgroundColor3 = Color3.fromRGB(22, 34, 44)
MultiBtn.BackgroundTransparency = 0.2
MultiBtn.Font = Enum.Font.GothamBold
MultiBtn.Text = "👥 UNLIMITED TARGETS"
MultiBtn.TextColor3 = Color3.fromRGB(226, 232, 240)
MultiBtn.TextSize = 12
MultiBtn.ZIndex = 3
MultiBtn.Parent = MainFrame

Instance.new("UICorner", MultiBtn).CornerRadius = UDim.new(0, 12)

local AutoSymbolBtn = Instance.new("TextButton")
AutoSymbolBtn.Size = UDim2.new(0, 202, 0, 42)
AutoSymbolBtn.Position = UDim2.new(0, 226, 0, 198)
AutoSymbolBtn.BackgroundColor3 = Color3.fromRGB(22, 34, 44)
AutoSymbolBtn.BackgroundTransparency = 0.2
AutoSymbolBtn.Font = Enum.Font.GothamBold
AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: OFF"
AutoSymbolBtn.TextColor3 = Color3.fromRGB(248, 113, 113)
AutoSymbolBtn.TextSize = 12
AutoSymbolBtn.ZIndex = 3
AutoSymbolBtn.Parent = MainFrame

Instance.new("UICorner", AutoSymbolBtn).CornerRadius = UDim.new(0, 12)

local autoSymbolsActive = false
AutoSymbolBtn.MouseButton1Click:Connect(function()
	autoSymbolsActive = not autoSymbolsActive
	if autoSymbolsActive then
		AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: ON"
		AutoSymbolBtn.TextColor3 = Color3.fromRGB(74, 222, 128)
	else
		AutoSymbolBtn.Text = "⚡ AUTO SYMBOL: OFF"
		AutoSymbolBtn.TextColor3 = Color3.fromRGB(248, 113, 113)
	end
end)

----------------------------------------------------------------
-- 4. UNLIMITED TARGETS POPUP PANEL (SCROLL + ADD + ❌ DELETE)
----------------------------------------------------------------
local multiTargetList = {}

local MultiPanel = Instance.new("Frame")
MultiPanel.Size = UDim2.new(0, 340, 0, 265)
MultiPanel.Position = UDim2.new(0.5, -170, 0.5, -132)
MultiPanel.BackgroundColor3 = Color3.fromRGB(13, 19, 24)
MultiPanel.BackgroundTransparency = 0.06
MultiPanel.BorderSizePixel = 0
MultiPanel.Visible = false
MultiPanel.ZIndex = 10
MultiPanel.Parent = ScreenGui

Instance.new("UICorner", MultiPanel).CornerRadius = UDim.new(0, 16)

local MultiPanelStroke = Instance.new("UIStroke")
MultiPanelStroke.Color = Color3.fromRGB(16, 185, 129)
MultiPanelStroke.Thickness = 2
MultiPanelStroke.Parent = MultiPanel

local MultiPanelTitle = Instance.new("TextLabel")
MultiPanelTitle.Size = UDim2.new(1, 0, 0, 34)
MultiPanelTitle.BackgroundTransparency = 1
MultiPanelTitle.Font = Enum.Font.GothamBold
MultiPanelTitle.Text = "⚡ UMAIR UNLIMITED TARGETS ⚡"
MultiPanelTitle.TextColor3 = Color3.fromRGB(110, 231, 183)
MultiPanelTitle.TextSize = 13
MultiPanelTitle.ZIndex = 11
MultiPanelTitle.Parent = MultiPanel

local MultiInputBox = Instance.new("TextBox")
MultiInputBox.Size = UDim2.new(1, -20, 0, 36)
MultiInputBox.Position = UDim2.new(0, 10, 0, 36)
MultiInputBox.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
MultiInputBox.BorderSizePixel = 0
MultiInputBox.Font = Enum.Font.Gotham
MultiInputBox.PlaceholderText = "Add target username..."
MultiInputBox.Text = ""
MultiInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MultiInputBox.TextSize = 12
MultiInputBox.ClearTextOnFocus = false
MultiInputBox.ZIndex = 11
MultiInputBox.Parent = MultiPanel

Instance.new("UICorner", MultiInputBox).CornerRadius = UDim.new(0, 8)

local AddTargetBtn = Instance.new("TextButton")
AddTargetBtn.Size = UDim2.new(0, 150, 0, 32)
AddTargetBtn.Position = UDim2.new(0, 10, 0, 78)
AddTargetBtn.BackgroundColor3 = Color3.fromRGB(56, 189, 248)
AddTargetBtn.Font = Enum.Font.GothamBold
AddTargetBtn.Text = "➕ ADD TARGET"
AddTargetBtn.TextColor3 = Color3.fromRGB(10, 15, 20)
AddTargetBtn.TextSize = 11
AddTargetBtn.ZIndex = 11
AddTargetBtn.Parent = MultiPanel

Instance.new("UICorner", AddTargetBtn).CornerRadius = UDim.new(0, 8)

local SavePanelBtn = Instance.new("TextButton")
SavePanelBtn.Size = UDim2.new(0, 150, 0, 32)
SavePanelBtn.Position = UDim2.new(1, -160, 0, 78)
SavePanelBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
SavePanelBtn.Font = Enum.Font.GothamBold
SavePanelBtn.Text = "✔ SAVE & CLOSE"
SavePanelBtn.TextColor3 = Color3.fromRGB(10, 15, 20)
SavePanelBtn.TextSize = 11
SavePanelBtn.ZIndex = 11
SavePanelBtn.Parent = MultiPanel

Instance.new("UICorner", SavePanelBtn).CornerRadius = UDim.new(0, 8)

local TargetScrollFrame = Instance.new("ScrollingFrame")
TargetScrollFrame.Size = UDim2.new(1, -20, 0, 135)
TargetScrollFrame.Position = UDim2.new(0, 10, 0, 118)
TargetScrollFrame.BackgroundColor3 = Color3.fromRGB(9, 13, 17)
TargetScrollFrame.BorderSizePixel = 0
TargetScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
TargetScrollFrame.ScrollBarThickness = 4
TargetScrollFrame.ZIndex = 11
TargetScrollFrame.Parent = MultiPanel

Instance.new("UICorner", TargetScrollFrame).CornerRadius = UDim.new(0, 10)

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
		row.BackgroundColor3 = Color3.fromRGB(20, 28, 36)
		row.BorderSizePixel = 0
		row.ZIndex = 12
		row.Parent = TargetScrollFrame

		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

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
		delBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
		delBtn.Font = Enum.Font.GothamBold
		delBtn.Text = "❌"
		delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		delBtn.TextSize = 10
		delBtn.ZIndex = 13
		delBtn.Parent = row

		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 5)

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
-- 5. START / STOP BUTTON & FOOTER BAR (NO IMAGES)
----------------------------------------------------------------
local SpamBtn = Instance.new("TextButton")
SpamBtn.Size = UDim2.new(0, 416, 0, 46)
SpamBtn.Position = UDim2.new(0, 12, 0, 252)
SpamBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
SpamBtn.Font = Enum.Font.GothamBlack
SpamBtn.Text = "▶ START UMAIR SPAM"
SpamBtn.TextColor3 = Color3.fromRGB(10, 15, 18)
SpamBtn.TextSize = 14
SpamBtn.ZIndex = 3
SpamBtn.Parent = MainFrame

Instance.new("UICorner", SpamBtn).CornerRadius = UDim.new(0, 14)

local FooterDock = Instance.new("Frame")
FooterDock.Size = UDim2.new(0, 416, 0, 58)
FooterDock.Position = UDim2.new(0, 12, 0, 314)
FooterDock.BackgroundColor3 = Color3.fromRGB(16, 22, 28)
FooterDock.BackgroundTransparency = 0.25
FooterDock.BorderSizePixel = 0
FooterDock.ZIndex = 3
FooterDock.Parent = MainFrame

Instance.new("UICorner", FooterDock).CornerRadius = UDim.new(0, 14)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(0, 130, 0, 22)
StatusLbl.Position = UDim2.new(0, 12, 0.5, -11)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Font = Enum.Font.GothamBold
StatusLbl.Text = "● IDLE / READY"
StatusLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
StatusLbl.TextSize = 11
StatusLbl.TextXAlignment = Enum.TextXAlignment.Left
StatusLbl.ZIndex = 4
StatusLbl.Parent = FooterDock

local FooterAfkTitle = Instance.new("TextLabel")
FooterAfkTitle.Size = UDim2.new(0, 120, 0, 16)
FooterAfkTitle.Position = UDim2.new(0.5, -60, 0, 9)
FooterAfkTitle.BackgroundTransparency = 1
FooterAfkTitle.Font = Enum.Font.GothamBlack
FooterAfkTitle.Text = "UMAIR AFK"
FooterAfkTitle.TextColor3 = Color3.fromRGB(110, 231, 183)
FooterAfkTitle.TextSize = 11
FooterAfkTitle.ZIndex = 4
FooterAfkTitle.Parent = FooterDock

local FooterTimeLbl = Instance.new("TextLabel")
FooterTimeLbl.Size = UDim2.new(0, 120, 0, 18)
FooterTimeLbl.Position = UDim2.new(0.5, -60, 0, 28)
FooterTimeLbl.BackgroundTransparency = 1
FooterTimeLbl.Font = Enum.Font.Code
FooterTimeLbl.Text = "000:00:00"
FooterTimeLbl.TextColor3 = Color3.fromRGB(74, 222, 128)
FooterTimeLbl.TextSize = 13
FooterTimeLbl.ZIndex = 4
FooterTimeLbl.Parent = FooterDock

local BrandLbl = Instance.new("TextLabel")
BrandLbl.Size = UDim2.new(0, 130, 0, 22)
BrandLbl.Position = UDim2.new(1, -142, 0.5, -11)
BrandLbl.BackgroundTransparency = 1
BrandLbl.Font = Enum.Font.GothamBold
BrandLbl.Text = "⚡ UMAIR SPAMMER"
BrandLbl.TextColor3 = Color3.fromRGB(110, 231, 183)
BrandLbl.TextSize = 11
BrandLbl.TextXAlignment = Enum.TextXAlignment.Right
BrandLbl.ZIndex = 4
BrandLbl.Parent = FooterDock

----------------------------------------------------------------
-- 6. FLOATING DRAGGABLE BUTTON (NO IMAGE)
----------------------------------------------------------------
local FloatBtn = Instance.new("TextButton")
FloatBtn.Size = UDim2.new(0, 56, 0, 56)
FloatBtn.Position = UDim2.new(0, 24, 0.5, -28)
FloatBtn.BackgroundColor3 = Color3.fromRGB(15, 22, 28)
FloatBtn.BackgroundTransparency = 0.08
FloatBtn.BorderSizePixel = 0
FloatBtn.Font = Enum.Font.GothamBlack
FloatBtn.Text = "⚡"
FloatBtn.TextColor3 = Color3.fromRGB(110, 231, 183)
FloatBtn.TextSize = 24
FloatBtn.Visible = false
FloatBtn.ZIndex = 6
FloatBtn.Parent = ScreenGui

Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(16, 185, 129)
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
-- 7. ANTI-AFK ENGINE & LIVE TIMER LOOP
----------------------------------------------------------------
if LocalPlayer then
	LocalPlayer.Idled:Connect(function()
		if not umairAfkActive then return end
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
		if umairAfkActive then
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
-- 8. UNIVERSAL CHAT SENDER & 10-WORD RESERVED SYMBOL ENGINE
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
	sendChat("[⚡UMAIR SPAMMER LOAD..⚡]")
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

local symbolChunks = {
	"+++---+++//===//===\\\\\\-",
	"///===/\\==\\\\V//==\\\\\\\\==\\\\V",
	"@@@@@@@@@@@@@@@",
	"-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-",
	"+_+_+_+_+_+_+_+_+_+_+_+_+_+_+",
	"@_@_@_@_@_@_@_@_@_@_@_@"
}

local function buildFittedSymbol(baseSym, reservedLen)
	local maxSymLen = math.max(12, 185 - reservedLen)
	if baseSym == "" then
		baseSym = symbolChunks[1]
	end
	local reps = math.max(1, math.ceil(maxSymLen / #baseSym))
	return string.sub(string.rep(baseSym, reps), 1, maxSymLen)
end

-- 22 TMKx / TBKx Messages (Original 12 + 10 Newly Added)
local umairMessages = {
	"TMKx MARE 💫 SONIC BEEM LIGHTNING SPEED DASH ACROSS ALL SERVERS 👅✨",
	"TMKx MARE ⚡ BRAZIL TIGER JUNGLE KING DOMINATION REIGNING SUPREME OVER EVERYONE",
	"TMKx MARE 👑 MEGA POWER WAVE TIDAL WAVE ONSLAUGHT SWEEPING AWAY ALL DEFENSES ☄️✨",
	"TBKx MARE 🔥 ULTIMATE GODZILA HEAT RAY MELTDOWN CAUSING VOLCANIC ERUPTIONS EVERYWHERE 💫✨",
	"TMKx MARE ☠️ GORILLA POWER FIST OF FURY SMASHING THROUGH SOLID STEEL WALLS ✨💢",
	"TBKx MARE 😈 SONIC BEEM INFINITE ENERGY REACTOR CORE OVERLOAD 💫👅",
	"TMKx MEH 🤡 BRAZIL TIGER PHANTOM DASH STRIKE INVISIBLE TO THE NAKED EYE ✨💫",
	"TBKx MEH 💩 SUPER MEGA POWER WAVE HURRICANE FORCE WINDS TEARING DOWN THE SKIES ☄️☄️",
	"TMKx MEH 😍 GODZILA EARTH SHATTERING FOOTSTEP MAKING EVERYONE STUMBLE AND FALL 🍁👅",
	"TBKx MARE 🥶 GORILLA MEGA BRAWL CHAMPION UNDEFEATED TORNADO OF PURE DESTRUCTION ☄️✨",
	"TMKx MARE REX ULTIMATE GODZILA + GORILLA + TIGER COMBINED ALLIANCE FORCE 👽☄️",
	"TMKx MARE 💢 FINAL WARNING: SONIC BEEM + MEGA POWER WAVE TOTALLY DOMINATING THE GAME FOREVER ✨👅",
	"TMKx MARE ⚡ SONIC BEEM SHOCKWAVE BLASTING EVERY TARGET IN THE SERVER 💥💫",
	"TBKx MARE 🔥 BRAZIL TIGER FURY ROAR SHAKING THE ENTIRE ARENA GROUND 🐯⚡",
	"TMKx MARE 👑 MEGA POWER WAVE OVERDRIVE CRUSHING EVERY RIVAL STANDING 🌊💥",
	"TBKx MARE ☠️ GODZILA ATOMIC PULSE UNLEASHED WITH MAXIMUM HEAT ENERGY 🔥👑",
	"TMKx MARE 💫 GORILLA TITAN SLAM BREAKING ALL LIMITS ACROSS THE LOBBY 💪⚡",
	"TBKx MARE 😈 SONIC BEEM TURBO SURGE STRIKING AT LIGHTNING VELOCITY ⚡✨",
	"TMKx MEH 🤡 BRAZIL TIGER SHADOW STRIKE LEAVING EVERYONE BEHIND IN DUST 🌪️💫",
	"TBKx MEH 💩 MEGA POWER WAVE STORM SURGE SWEEPING ALL OPPONENTS AWAY 💥🌊",
	"TMKx MARE 🥶 GODZILA APEX ROAR DOMINATING THE WHOLE SERVER DIMENSION 🔥👑",
	"TBKx MARE ⚡ GORILLA + SONIC BEEM + POWER WAVE FULL OVERLOAD COMBO 💥⚡"
}

local isRunning = false

SpamBtn.MouseButton1Click:Connect(function()
	isRunning = not isRunning
	if isRunning then
		SpamBtn.Text = "■ STOP UMAIR SPAM"
		SpamBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
		SpamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		StatusLbl.Text = "● SPAMMING ACTIVE"
		StatusLbl.TextColor3 = Color3.fromRGB(74, 222, 128)
	else
		SpamBtn.Text = "▶ START UMAIR SPAM"
		SpamBtn.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
		SpamBtn.TextColor3 = Color3.fromRGB(10, 15, 18)
		StatusLbl.Text = "● IDLE / READY"
		StatusLbl.TextColor3 = Color3.fromRGB(148, 163, 184)
	end
end)

task.spawn(function()
	local targetIdx = 1
	local symIdx = 1

	while true do
		if isRunning then
			local targets = collectTargets()
			local delaySec = isFastMode and 0.35 or 1.5

			for _, baseMsg in ipairs(umairMessages) do
				if not isRunning then break end

				targets = collectTargets()
				local targetTag = ""
				if #targets > 0 then
					if targetIdx > #targets then targetIdx = 1 end
					targetTag = "[" .. targets[targetIdx] .. "] "
					targetIdx = targetIdx + 1
				end

				local rawSym = ""
				if autoSymbolsActive then
					rawSym = symbolChunks[symIdx]
					symIdx = (symIdx % #symbolChunks) + 1
				else
					rawSym = SymbolBox.Text:match("^%s*(.-)%s*$")
					if rawSym == "" then
						rawSym = symbolChunks[1]
					end
				end

				local reservedSpace = #targetTag + #baseMsg + 2
				local fittedSym = buildFittedSymbol(rawSym, reservedSpace)
				local fullLine = fittedSym .. " " .. targetTag .. baseMsg

				sendChat(fullLine)
				task.wait(delaySec)
			end
		else
			task.wait(0.5)
		end
	end
end)
