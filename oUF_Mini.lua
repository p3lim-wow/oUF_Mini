local function OnEnter(...)
	if(not InCombatLockdown()) then
		UnitFrame_OnEnter(...)
	end
end

local function OverrideUpdateHealth(self, event, unit, bar)
	local localized, english = UnitClass(unit)
	bar.bg:SetVertexColor(unpack(self.colors.class[english]))
	self:SetAlpha(UnitIsDeadOrGhost(unit) and 0.25 or 1)
end

local function CreateStyle(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetAttribute('initial-height', 16)
	self:SetAttribute('initial-width', 20)

	self:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, left = -1, bottom = -1, right = -1}})
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture([=[Interface\AddOns\oUF_Mini\minimalist]=])
	self.Health:SetStatusBarColor(0.25, 0.25, 0.25)

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])

	self.OverrideUpdateHealth = OverrideUpdateHealth
	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('Mini', CreateStyle)
oUF:SetActiveStyle('Mini')

local grid = oUF:Spawn('header', 'oUF_Mini')
grid:SetPoint('TOP', Minimap, 'BOTTOM', 0, -15)
grid:SetManyAttributes(
	'showRaid', true,
	'xOffset', 5,
	'point', 'LEFT',
	'groupingOrder', '1,2,3,4,5',
	'groupBy', 'GROUP',
	'maxColumns', 5,
	'unitsPerColumn', 5,
	'columnSpacing', 5,
	'columnAnchorPoint', 'TOP'
)
grid:Show()