local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local rwidth = T.InfoLeftRightWidth / 5 - 3.2
local font = C["media"].pixelfont
local font2 = C["media"].uffont
local Font = C["media"].font
local pixel2 = C["media"].pixelfont2
local empathTex = C["media"].empath2
local normTex = C["media"].normTex
local blankTex = C["media"].blank

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	-- here we create an invisible frame for all element we want to show over health/power.
	local InvFrame = CreateFrame("Frame", nil, self)
	InvFrame:SetFrameStrata("HIGH")
	InvFrame:SetFrameLevel(5)
	InvFrame:SetAllPoints()
	
	--self:SetBackdrop({bgFile = C["media"].blank, insets = {top = -T.mult, left = -T.mult, bottom = -T.mult, right = -T.mult}})
	--self:SetBackdropColor(0, 0, 0)
	self:HighlightUnit(0,.8,0) -- R,G,B
	local health = CreateFrame('StatusBar', nil, self)
	health:CreateBorder(false, true)
	health:SetPoint("TOPLEFT")
	health:SetPoint("TOPRIGHT")
	health:Height(22*C["unitframes"].gridscale*T.raidscale)
	if C["unitframes"].style == "Shag" then
	health:SetStatusBarTexture(normTex)
	elseif C["unitframes"].style == "Smelly" then
	health:SetStatusBarTexture(empathTex)
	end
	self.Health = health
	
	
	if C["unitframes"].gridhealthvertical == true then
		health:SetOrientation('VERTICAL')
	end
	
	health.bg = health:CreateTexture(nil, 'BORDER')
	health.bg:SetAllPoints(health)
	health.bg:SetTexture(empathTex)
	health.bg:SetTexture(.150, .150, .150)
	health.bg.multiplier = (0.3)
	self.Health.bg = health.bg
	
	local HealthBorder = CreateFrame("Frame", nil, health)
	HealthBorder:SetPoint("TOPLEFT", health, "TOPLEFT", T.Scale(-2), T.Scale(2))
	HealthBorder:SetPoint("BOTTOMRIGHT", health, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
	HealthBorder:SetTemplate("Default")
	HealthBorder:SetBackdropColor(0,0,0,1)
	--HealthBorder:CreateShadow("Default")
	HealthBorder:SetFrameLevel(2)
	self.HealthBorder = HealthBorder
		
	health.value = health:CreateFontString(nil, "OVERLAY")
	health.value:Point("CENTER", health, 1, -3)
	health.value:SetFont(font, 10, "THINOUTLINE")
	health.value:SetTextColor(1,1,1)
	health.value:SetShadowOffset(1, -1)
	self.Health.value = health.value
	
	health.PostUpdate = T.PostUpdateHealthRaid
	
	health.frequentUpdates = true
	
	if C.unitframes.unicolor and C.unitframes.style == "Smelly" then	
		health:SetStatusBarColor(.125, .125, .125)
	elseif C.unitframes.unicolor and C.unitframes.style == "Shag" then
		health:SetStatusBarColor(.155, .155, .155)
	end
	
	if C.unitframes.unicolor == true then
		health.colorDisconnected = false
		health.colorClass = false
		health.bg:SetVertexColor(0, 0, 0, 1)		
	else
		health.colorDisconnected = true
		health.colorClass = true
		health.colorReaction = true			
	end
		
	local power = CreateFrame("StatusBar", nil, self)
	power:CreateBorder(false, true)
	power:SetHeight(1.5*C["unitframes"].gridscale*T.raidscale)
	power:Point("TOPLEFT", self.Health, "BOTTOMLEFT", 2, 2)
	power:Point("TOPRIGHT", self.Health, "BOTTOMRIGHT", -2, 2)
	if C["unitframes"].style == "Shag" then
	power:SetStatusBarTexture(normTex)
	elseif C["unitframes"].style == "Smelly" then
	power:SetStatusBarTexture(empathTex)
	end
	--power:SetStatusBarTexture(C["media"].normTex)
	power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	self.Power = power

	power.frequentUpdates = true
	power.colorDisconnected = true

	power.bg = power:CreateTexture(nil, "BORDER")
	power.bg:SetAllPoints(power)
	power.bg:SetTexture(empathTex)
	power.bg:SetAlpha(1)
	power.bg.multiplier = .4
	--[[
	local PowerBorder = CreateFrame("Frame", nil, power)
	PowerBorder:SetPoint("TOPLEFT", power, "TOPLEFT", T.Scale(-2), T.Scale(2))
	PowerBorder:SetPoint("BOTTOMRIGHT", power, "BOTTOMRIGHT", T.Scale(2), T.Scale(-2))
	PowerBorder:SetTemplate("Default")
	PowerBorder:SetBackdropColor(0,0,0,1)
	--PowerBorder:CreateShadow("Default")
	PowerBorder:SetFrameLevel(power:GetFrameLevel() - 1)
	self.PowerBorder = PowerBorder
--]]	
	if C.unitframes.unicolor == true then
		power.colorClass = true
		power.bg.multiplier = 0.1				
	else
		power.colorPower = true
	end
	
	local name = self.Health:CreateFontString(nil, "OVERLAY")
   	name:SetPoint("TOP", 0, 10) 
	name:SetPoint("BOTTOM") 
	name:SetPoint("LEFT", 4, 0) 
	name:SetPoint("RIGHT")
	name:SetFont(font, 10, "THINOUTLINE")
	name:SetShadowOffset(.5, -.5)
	self:Tag(name, "[Tukui:getnamecolor][Tukui:nameshort]")
	self.Name = name
	
	local leader = InvFrame:CreateTexture(nil, "OVERLAY")
    leader:Height(12*T.raidscale)
    leader:Width(12*T.raidscale)
    leader:SetPoint("TOPLEFT", 0, 6)
	self.Leader = leader
	
	local LFDRole = InvFrame:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(15*T.raidscale)
    LFDRole:Width(15*T.raidscale)
	LFDRole:Point("TOPRIGHT", 0, 10)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
    local MasterLooter = InvFrame:CreateTexture(nil, "OVERLAY")
    MasterLooter:Height(12*T.raidscale)
    MasterLooter:Width(12*T.raidscale)
	self.MasterLooter = MasterLooter
    self:RegisterEvent("PARTY_LEADER_CHANGED", T.MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", T.MLAnchorUpdate)
	
	--[[ -- portraits 
	if (C["unitframes"].charportrait == true) then
		local portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
		portrait:SetFrameLevel(11)
		portrait:SetAlpha(0.20)
		portrait:SetAllPoints(health)
		table.insert(self.__elements, T.HidePortrait)
		self.Portrait = portrait
	end--]]
	
    if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
	end
		
	if C["unitframes"].showsymbols == true then
		local RaidIcon = InvFrame:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(14*T.raidscale)
		RaidIcon:Width(14*T.raidscale)
		RaidIcon:SetPoint('CENTER', self, 'TOP', 0, 2)
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = InvFrame:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:Width(12*C["unitframes"].gridscale*T.raidscale)
	ReadyCheck:SetPoint('BOTTOM') 	
	self.ReadyCheck = ReadyCheck
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture[[Interface\AddOns\Tukui\medias\textures\picon]]
	--picon.Override = T.Phasing
	--self.PhaseIcon = picon
	
	if not C["unitframes"].raidunitdebuffwatch == true then
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightBackdrop = true
		self.DebuffHighlightFilter = true
	end
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
		power.Smooth = true
	end
	
	if C["unitframes"].healcomm == true then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		if C["unitframes"].gridhealthvertical then
			mhpb:SetOrientation("VERTICAL")
			mhpb:SetPoint('BOTTOM', self.Health:GetStatusBarTexture(), 'TOP', 0, 0)
			mhpb:Width(66*C["unitframes"].gridscale*T.raidscale)
			mhpb:Height(50*C["unitframes"].gridscale*T.raidscale)		
		else
			mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			mhpb:Width(66*C["unitframes"].gridscale*T.raidscale)
		end				
		mhpb:SetStatusBarTexture(C["media"].normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		if C["unitframes"].gridhealthvertical then
			ohpb:SetOrientation("VERTICAL")
			ohpb:SetPoint('BOTTOM', mhpb:GetStatusBarTexture(), 'TOP', 0, 0)
			ohpb:Width(66*C["unitframes"].gridscale*T.raidscale)
			ohpb:Height(50*C["unitframes"].gridscale*T.raidscale)
		else
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			ohpb:Width(6*C["unitframes"].gridscale*T.raidscale)
		end
		ohpb:SetStatusBarTexture(C["media"].normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end
	--Resurrect Indicator
		local Resurrect = CreateFrame('Frame', nil, self)
		Resurrect:SetFrameLevel(20)

		local ResurrectIcon = Resurrect:CreateTexture(nil, "OVERLAY")
		ResurrectIcon:Point(health.value:GetPoint())
		ResurrectIcon:Size(25, 20)
		ResurrectIcon:SetDrawLayer('OVERLAY', 7)

		self.ResurrectIcon = ResurrectIcon

	if C["unitframes"].raidunitdebuffwatch == true then
		-- AuraWatch (corner icon)
		T.createAuraWatch(self,unit)
		
		-- Raid Debuffs (big middle icon)
		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(21*C["unitframes"].gridscale)
		RaidDebuffs:Width(21*C["unitframes"].gridscale)
		RaidDebuffs:Point('CENTER', health, 2,1)
		RaidDebuffs:SetFrameStrata(power:GetFrameStrata())
		RaidDebuffs:SetFrameLevel(power:GetFrameLevel() + 2)
		
		RaidDebuffs:SetTemplate("Default")
		
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.1,.9,.1,.9)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)
		
		-- just in case someone want to add this feature, uncomment to enable it
		if C["unitframes"].auratimer then
			RaidDebuffs.cd = CreateFrame('Cooldown', nil, RaidDebuffs)
			RaidDebuffs.cd:SetPoint("TOPLEFT", T.Scale(2), T.Scale(-2))
			RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", T.Scale(-2), T.Scale(2))
			RaidDebuffs.cd.noOCC = true -- remove this line if you want cooldown number on it
		end
		
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(C["media"].pixelfont, 10, "THINOUTLINE")
		RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		
		RaidDebuffs:FontString('time', C["media"].pixelfont, 10, "THINOUTLINE")
		RaidDebuffs.time:SetPoint('CENTER')
		RaidDebuffs.time:SetTextColor(1, .9, 0)
		
		self.RaidDebuffs = RaidDebuffs
    end

	return self
end
	
oUF:RegisterStyle('TukuiDpsR40', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("TukuiDpsR40")
	if C["unitframes"].gridonly ~= true then
		local raid = self:SpawnHeader("oUF_TukuiDpsRaid40", nil, "custom [@raid26,exists] show;hide", 
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', T.Scale(70*C["unitframes"].gridscale*T.raidscale),
			'initial-height', T.Scale(24*C["unitframes"].gridscale*T.raidscale),	
			"showRaid", true,
			"xoffset", T.Scale(7),
			"yOffset", T.Scale(-5),
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", T.Scale(7),
			"columnAnchorPoint", "TOP"
		)	
		raid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 18, -250*T.raidscale)
		
	else
		local raid = self:SpawnHeader("TukuiGrid", nil, "solo,raid,party",
			'oUF-initialConfigFunction', [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute('initial-width'))
				self:SetHeight(header:GetAttribute('initial-height'))
			]],
			'initial-width', rwidth,
			--'initial-width', T.Scale(70*C["unitframes"].gridscale*T.raidscale),
			'initial-height', T.Scale(22*C["unitframes"].gridscale*T.raidscale),  ---34
			"showParty", true,
			"showPlayer", C["unitframes"].showplayerinparty, 
			"showRaid", true, 
			"xoffset", T.Scale(6),  --7
			"point", "LEFT",
			"groupFilter", "1,2,3,4,5",
			"groupingOrder", "1,2,3,4,5,6,7,8",
			"groupBy", "GROUP",
			"maxColumns", 8,
			"unitsPerColumn", 5,
			"columnSpacing", 6,  --7
			"columnAnchorPoint", "BOTTOM",
			"showSolo", C["unitframes"].showsolo
		)
		
		local elapsed = 0
			raid:SetScript("OnUpdate",function(self, u)
			if InCombatLockdown() then return end
			elapsed = elapsed + u
			if elapsed > .5 then -- 2 seconds
			raid:ClearAllPoints()
			if not TukuiChatBackgroundLeft:IsVisible() then
			raid:SetPoint("BOTTOMLEFT", TukuiChatBackgroundLeft, "BOTTOMLEFT", 2, 24)
			else
			raid:SetPoint("BOTTOMLEFT", TukuiChatBackgroundLeft, "TOPLEFT", 2, 6)  --2,6
			end
			elapsed = 0
			end
			end)
		
		local pets = {} 
			pets[1] = oUF:Spawn('partypet1', 'oUF_TukuiPartyPet1') 
			pets[1]:Point('TOPLEFT', raid, 'TOPLEFT', 0, 50*C["unitframes"].gridscale*T.raidscale + -3)
			pets[1]:Size(66*C["unitframes"].gridscale*T.raidscale, 24*C["unitframes"].gridscale*T.raidscale)
		for i =2, 4 do 
			pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
			pets[i]:Point('LEFT', pets[i-1], 'RIGHT', 7, 0)
			pets[i]:Size(66*C["unitframes"].gridscale*T.raidscale, 24*C["unitframes"].gridscale*T.raidscale)
		end
		
		local ShowPet = CreateFrame("Frame")
		ShowPet:RegisterEvent("PLAYER_ENTERING_WORLD")
		ShowPet:RegisterEvent("RAID_ROSTER_UPDATE")
		ShowPet:RegisterEvent("PARTY_LEADER_CHANGED")
		ShowPet:RegisterEvent("PARTY_MEMBERS_CHANGED")
		ShowPet:SetScript("OnEvent", function(self)
			if InCombatLockdown() then
				self:RegisterEvent("PLAYER_REGEN_ENABLED")
			else
				self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				local numraid = GetNumRaidMembers()
				local numparty = GetNumPartyMembers()
				if numparty > 0 and numraid == 0 or numraid > 0 and numraid <= 5 then
					for i,v in ipairs(pets) do v:Disable() end
				else
					for i,v in ipairs(pets) do v:Disable() end
				end
			end
		end)		
	end
end)

-- only show 5 groups in raid (25 mans raid)
local MaxGroup = CreateFrame("Frame")
MaxGroup:RegisterEvent("PLAYER_ENTERING_WORLD")
MaxGroup:RegisterEvent("ZONE_CHANGED_NEW_AREA")
MaxGroup:SetScript("OnEvent", function(self)
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	if inInstance and instanceType == "raid" and maxPlayers ~= 40 then
		TukuiGrid:SetAttribute("groupFilter", "1,2,3,4,5")
	else
		TukuiGrid:SetAttribute("groupFilter", "1,2,3,4,5")
	end
end)