--[[
local function HasDType(unit, t)
	for i = 1, 40 do
		local name, _, _, _, dtype = UnitDebuff(unit, i)
		if(not name) then
			return
		elseif(dtype == t) then
			return true
		end
	end
end

local function UpdateBackdrop(self)
	for i = 1, 40 do
		local name, _, _, _, dtype = UnitDebuff(self.unit, i)
		if(not name and (dtype == 'Poison' or dtype == 'Curse')) then
			local color = DebuffTypeColor[dtype]
			self:SetBackdropColor(color.r, color.g, color.b)
		else
			self:SetBackdropColor(0, 0, 0)
		end
	end
end
--]]
local function OverrideUpdateHealth(self, event, unit, bar)
	local localized, english = UnitClass(unit)
	local color = self.colors.class[english]
	if(color) then bar.bg:SetVertexColor(unpack(color)) end
	self:SetAlpha(UnitIsDeadOrGhost(unit) and 0.25 or 1)
end

local function CreateStyle(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
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

	self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
	self.ReadyCheck:SetAllPoints(self.Health)

--	self:RegisterEvent('UNIT_AURA', UpdateBackdrop) -- needs to be fixed

	self.OverrideUpdateHealth = OverrideUpdateHealth
	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('Mini', CreateStyle)
oUF:SetActiveStyle('Mini')

local raid = oUF:Spawn('header', 'oUF_Mini', nil, '')
raid:SetPoint('TOP', Minimap, 'BOTTOM', 0, -15)
raid:SetManyAttributes(
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
raid:SetScale(1.03)
raid:Show()