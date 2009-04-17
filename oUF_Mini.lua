
oUF.Tags['[misswild]'] = function(u) return (not UnitAura(u, 'Gift of the Wild') and not UnitAura(u, 'Mark of the Wild')) and '|cffff33ff!|r' end
oUF.TagEvents['[misswild]'] = 'UNIT_AURA'

local function onEnter(self)
	self.Highlight:Show()
	UnitFrame_OnEnter(self)
end

local function onLeave(self)
	self.Highlight:Hide()
	UnitFrame_OnLeave(self)
end

local function colorThreat(self)
	local status = UnitThreatSituation(self.unit)
	if(status and status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.Health:SetStatusBarColor(r, g, b)
	else
		self.Health:SetStatusBarColor(0.25, 0.25, 0.25)
	end
end

local function colorBackground(self)
	local localized, class = UnitClass(self.unit)
	self.Health.bg:SetVertexColor(unpack(self.colors.class[class] or self.colors.health))
end

local function styleFunction(self, unit)
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', onEnter)
	self:SetScript('OnLeave', onLeave)

	self:SetAttribute('initial-height', 16)
	self:SetAttribute('initial-width', 20)

	self:SetBackdrop({bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=], insets = {top = -1, left = -1, bottom = -1, right = -1}})
	self:SetBackdropColor(0, 0, 0)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetAllPoints(self)
	self.Health:SetStatusBarTexture([=[Interface\AddOns\oUF_Mini\minimalist]=])
	self.Health:SetStatusBarColor(0.25, 0.25, 0.25)
	self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', colorThreat)

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
	table.insert(self.__elements, colorBackground)

	self.Highlight = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Highlight:SetTexture(1, 1, 0.6, 0.2)
	self.Highlight:SetAllPoints(self.Health)
	self.Highlight:Hide()
	
	local misswild = self.Health:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	misswild:SetPoint('CENTER')
	self:Tag(misswild, '[misswild]')

	self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
	self.ReadyCheck:SetAllPoints(self.Health)

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.OverrideUpdateHealth = function(self)
		self:SetAlpha((UnitIsDeadOrGhost(self.unit) or not UnitIsConnected(self.unit)) and 0.25 or 1)
	end
end

oUF:RegisterStyle('Mini', styleFunction)
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