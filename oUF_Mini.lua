
oUF.Tags['[wild]'] = function(u) return (UnitAura(u, 'Gift of the Wild') or UnitAura(u, 'Mark of the Wild')) and '|cffff33ff.|r' end
oUF.Tags['[inner]'] = function(u) return UnitAura(u, 'Innervate') and '|cff0080ff.|r' end

oUF.TagEvents['[wild]'] = 'UNIT_AURA'
oUF.TagEvents['[inner]'] = 'UNIT_AURA'

local function ColorThreat(self)
	local status = UnitThreatSituation(self.unit)
	if(status > 0) then
		local r, g, b = GetThreatStatusColor(status)
		self.Health:SetStatusBarColor(r, g, b)
	else
		self.Health:SetStatusBarColor(0.25, 0.25, 0.25)
	end
end

local function ColorBackground(self)
	local localized, class = UnitClass(self.unit)
	self.Health.bg:SetVertexColor(unpack(self.colors.class[class] or self.colors.health))
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
	self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', ColorThreat)

	self.Health.bg = self.Health:CreateTexture(nil, 'BACKGROUND')
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
	table.insert(self.__elements, ColorBackground)
	
	local wild = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormalHuge')
	wild:SetPoint('BOTTOMRIGHT', self.Health, 'TOPRIGHT', 1, -5)
	wild:SetShadowOffset(0, 0)
	self:Tag(wild, '[wild]')

	local inner = self.Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormalHuge')
	inner:SetPoint('BOTTOMLEFT', self.Health, -2, -2)
	inner:SetShadowOffset(0, 0)
	self:Tag(inner, '[inner]')

	self.ReadyCheck = self.Health:CreateTexture(nil, 'OVERLAY')
	self.ReadyCheck:SetAllPoints(self.Health)

	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.OverrideUpdateHealth = function(self)
		self:SetAlpha((UnitIsDeadOrGhost(self.unit) or not UnitIsConnected(self.unit)) and 0.25 or 1)
	end
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