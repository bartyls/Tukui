local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- just for creating text
T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(.5, -.5)
	return fs
end

-- datatext panel position
T.PP = function(p, obj)
	local left = TukuiChatBackgroundLeft
	local right = TukuiChatBackgroundRight
	local center = ICenterMid
	local mapleft = TukuiInfoLeftMinimap
	local mapright = TukuiInfoRightMinimap
	
	if p == 1 then
		obj:SetParent(left)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMLEFT", left, "BOTTOMLEFT",30, -1)
	elseif p == 2 then
		obj:SetParent(left)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOM", left, "BOTTOM", 0, -1)
	elseif p == 3 then
		obj:SetParent(left)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMRIGHT", left, "BOTTOMRIGHT", -30, -1)
	elseif p == 4 then
		obj:SetParent(right)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMLEFT", right, "BOTTOMLEFT", 30, -1)
	elseif p == 5 then
		obj:SetParent(right)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOM", right, "BOTTOM", 0, -1)
	elseif p == 6 then
		obj:SetParent(right)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMRIGHT", right, "BOTTOMRIGHT", -30, -1)
	elseif p == 7 then
		obj:SetParent(center)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMLEFT", center, "BOTTOMLEFT", 4, -1)
	elseif p == 8 then
		obj:SetParent(center)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOM", center, "BOTTOM", 0, -1)
	elseif p == 9 then
		obj:SetParent(center)
		obj:SetHeight(20)
		obj:SetPoint("BOTTOMRIGHT", center, "BOTTOMRIGHT", -4, -1)
	elseif p == 10 then
		obj:SetParent(mapleft)
		obj:SetHeight(mapleft:GetHeight())
		obj:SetPoint('TOP', mapleft, 0, 2)
		obj:SetPoint('BOTTOM', mapleft)
	elseif p == 11 then
		obj:SetParent(mapright)
		obj:SetHeight(mapright:GetHeight())
		obj:SetPoint('TOP', mapright, 0, 2)
		obj:SetPoint('BOTTOM', mapright)
	end
end

-- Classcolored Panel Text  -- SHAG
if C["datatext"].classpanel then
	C["media"].statcolor = T.oUF_colors.class[T.myclass]
	else
	C["media"].statcolor = C.datatext.statcolor
end

-- Classcolored Datatext
if C["datatext"].classcolored == true then
	C["datatext"].color = T.oUF_colors.class[T.myclass]
end

-- convert datatext color from rgb decimal to hex 
local dr, dg, db = unpack(C["datatext"].color)
T.panelcolor = ("|cff%.2x%.2x%.2x"):format(dr * 255, dg * 255, db * 255)

T.DataTextTooltipAnchor = function(self)
	local panel = self:GetParent()
	local anchor = "ANCHOR_TOP"
	local xoff = 0
	local yoff = T.Scale(5)
	
	if panel == TukuiChatBackgroundLeft then
		anchor = "ANCHOR_TOPLEFT"
		yoff = T.Scale(-TukuiChatBackgroundLeft:GetHeight() + 21)
	elseif panel == TukuiChatBackgroundRight then
		anchor = "ANCHOR_TOPRIGHT"
		yoff = T.Scale(-TukuiChatBackgroundRight:GetHeight() + 21)
	elseif panel == TukuiMinimapStatsLeft or panel == TukuiMinimapStatsRight then
		local position = TukuiMinimap:GetPoint()
		if position:match("LEFT") then
			anchor = "ANCHOR_BOTTOMRIGHT"
			yoff = T.Scale(-6)
			xoff = 0 - TukuiMinimapStatsRight:GetWidth()
		elseif position:match("RIGHT") then
			anchor = "ANCHOR_BOTTOMLEFT"
			yoff = T.Scale(-6)
			xoff = TukuiMinimapStatsRight:GetWidth()
		else
			anchor = "ANCHOR_BOTTOM"
			yoff = T.Scale(-6)
		end
	end
	
	return anchor, panel, xoff, yoff
end

T.TukuiShiftBarUpdate = function()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		icon = _G["ShapeshiftButton"..i.."Icon"]
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
			icon:SetTexture(texture)
			
			cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			
			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

T.TukuiPetBarUpdate = function(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		
		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
		
		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end			
		end
		
		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end
		
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end
		
		-- grid display
		if name then
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(1)
			end			
		else
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(0)
			end
		end
		
		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end
		
		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

-- Define action bar buttons size
T.buttonsize = T.Scale(C.actionbar.buttonsize)
T.buttonspacing = T.Scale(C.actionbar.buttonspacing)
T.petbuttonsize = T.Scale(C.actionbar.petbuttonsize)
T.petbuttonspacing = T.Scale(C.actionbar.buttonspacing)
T.buttonoffset = 0
if C.actionbar.bgPanel then T.buttonoffset = C.actionbar.buttonspacing end
T.Round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

T.RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--Return short value of a number
function T.ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

function T.CommaValue(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

--Add time before calling a function
--Usage T.Delay(seconds, functionToCall, ...)
local waitTable = {}
local waitFrame
function T.Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
				  tinsert(waitTable,i,{d-elapse,f,p})
				  i = i + 1
				else
				  count = count - 1
				  f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

function T.SetModifiedBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	self:SetBackdropColor(color.r*.15, color.g*.15, color.b*.15)
	self:SetBackdropBorderColor(color.r, color.g, color.b)
end

function T.SetOriginalBackdrop(self)
	local color = RAID_CLASS_COLORS[T.myclass]
	if C["general"].classcolortheme == true then
		self:SetBackdropBorderColor(color.r, color.g, color.b)
	else
		self:SetTemplate("Transparent")
	end
end

function T.update_alpha(self)
	if self.parent:GetAlpha() == 0 then 
		self.parent:Hide()
		self:Hide()
	end
end

function T.fadeOut(self) 
	UIFrameFadeOut(self,.4,1,0) 
	self.frame:Show() 
end

function T.fadeIn(p)
	p.frame = CreateFrame("Frame", nil , p)
	p.frame:Hide()
	p.frame.parent = p -- lol!
	p.frame:SetScript("OnUpdate",T.update_alpha)
	p:SetScript("OnShow", function() 
		p.frame:Hide() 
		UIFrameFadeIn(p,.4,0,1)
	end)
	p.fadeOut = T.fadeOut
end

function T.ApplyHover(self)
	self:HookScript("OnEnter", T.SetModifiedBackdrop)
	self:HookScript("OnLeave", T.SetOriginalBackdrop)
end
------------------------------------------------------------------------
--	unitframes Functions
------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

T.updateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

local Flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

T.SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif (self.unit:match("party")) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor")
	end
end

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local ShortValueNegative = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

T.PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
	else
		local r, g, b
		
	if C.unitframes.gradienthealth and C.unitframes.unicolor and C.unitframes.unicolorgradient then
		local r, g, b = oUF.ColorGradient(min/max, unpack(C["unitframes"].gradient))
		health:SetStatusBarColor(r, g, b)
	end
		-- overwrite healthbar color for enemy player (a tukui option if enabled), target vehicle/pet too far away returning unitreaction nil and friend unit not a player. (mostly for overwrite tapped for friendly)
		-- I don't know if we really need to call C["unitframes"].unicolor but anyway, it's safe this way.
		if (C["unitframes"].unicolor ~= true and C["unitframes"].enemyhcolor and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C["unitframes"].unicolor ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
			if c then 
				r, g, b = c[1], c[2], c[3]
				health:SetStatusBarColor(r, g, b)
			else
				-- if "c" return nil it's because it's a vehicle or pet unit too far away, we force friendly color
				-- this should fix color not updating for vehicle/pet too far away from yourself.
				r, g, b = 75/255,  175/255, 76/255
				health:SetStatusBarColor(r, g, b)
			end					
		end

		if min ~= max then
			local r, g, b
			r, g, b = oUF.ColorGradient(min/max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
				else
					health.value:SetFormattedText("|cffAF5050%d|r|cffD7BEA5-|r|cff%02x%02x%02x%d%%|r", min, r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			elseif unit == "target" or (unit and unit:find("boss%d")) then
				if C["unitframes"].showtotalhpmp == true then
					health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5|||r |cff559655%s|r", ShortValue(min), ShortValue(max))
				else
					health.value:SetFormattedText("|cffAF5050%s|r|cffD7BEA5-|r|cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
				end
			elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
				health.value:SetText("|cff559655"..ShortValue(min).."|r")
			else
				health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
			end
		else
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				health.value:SetText("|cff559655"..max.."|r")
			elseif unit == "target" or unit == "focus"  or unit == "focustarget" or (unit and unit:find("arena%d")) then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText(" ")
			end
		end
	end
end

-- highlight on raidframes by Hydra
T.PostUpdateHealthRaid = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_offline.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_dead.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L.unitframes_ouf_ghost.."|r")
		end
		health:SetStatusBarColor(.8, .3, .3) -- Red health if offline/dead/dc'd
	else
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
			health.bg:SetTexture(.1, .1, .1)
		end
		
		if C.unitframes.gradienthealth and C.unitframes.unicolor then
			if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
			if not health.classcolored then
				local r, g, b = oUF.ColorGradient(min/max, unpack(C["unitframes"].gradient))
				health:SetStatusBarColor(r, g, b)
			end
		end
		
		if min ~= max then
			health.value:SetText("|cff559655-"..ShortValueNegative(max-min).."|r")
		else
			health.value:SetText(" ")
		end
	end
end


T.PostUpdatePetColor = function(health, unit, min, max)
	-- doing this here to force friendly unit (vehicle or pet) very far away from you to update color correcly
	-- because if vehicle or pet is too far away, unitreaction return nil and color of health bar is white.
	if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C["unitframes"].unicolor ~= true then
		local c = T.oUF_colors.reaction[5]
		local r, g, b = c[1], c[2], c[3]

		if health then health:SetStatusBarColor(r, g, b) end
		if health.bg then health.bg:SetTexture(.1, .1, .1) end
	end
end

T.PostNamePosition = function(self)
	self.Name:ClearAllPoints()
	if (self.Power.value:GetText() and UnitIsEnemy("player", "target") and C["unitframes"].targetpowerpvponly == true) or (self.Power.value:GetText() and C["unitframes"].targetpowerpvponly == false) then
		self.Name:SetPoint("CENTER", self.panel, "CENTER", 0, 2)
	else
		self.Power.value:SetAlpha(0)
		self.Name:SetPoint("LEFT", self.panel, "LEFT", 6, 2)
	end
end

T.PreUpdatePower = function(power, unit)
	local _, pType = UnitPowerType(unit)
	
	local color = T.oUF_colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePower = function(power, unit, min, max)
	local self = power:GetParent()
	local pType, pToken = UnitPowerType(unit)
	local color = T.oUF_colors.power[pToken]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	--if not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
	if (not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit)) and not (unit and unit:find("boss%d")) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		power.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%%|cffD7BEA5-|r%s", floor(min / max * 100), ShortValue(max - (max - min)))
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%%", floor(min / max * 100))
					end
				elseif (unit and unit:find("arena%d")) or unit == "focus" or unit == "focustarget" then
					power.value:SetText(ShortValue(min))
				else
					if C["unitframes"].showtotalhpmp == true then
						power.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						power.value:SetFormattedText("%d%%|cffD7BEA5-|r%d", floor(min / max * 100), max - (max - min))
					end
				end
			else
				power.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" or unit == "focus" or unit == "focustarget" or (unit and unit:find("arena%d")) then
				power.value:SetText(ShortValue(min))
			else
				power.value:SetText(min)
			end
		end
	end
	if self.Name then
		if unit == "target" then T.PostNamePosition(self, power) end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "- " or "+", self.delay))
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / day))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				if self.timeLeft <= 5 then
					self.remaining:SetTextColor(0.99, 0.31, 0.31)
				else
					self.remaining:SetTextColor(1, 1, 1)
				end
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

T.PostCreateAura = function(element, button)
	button:SetTemplate("Transparent")
	
	button.remaining = T.SetFontString(button, C["media"].font, C["unitframes"].auratextscale, "THINOUTLINE")
	button.remaining:Point("CENTER", 1, 0)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	
	button.cd:SetReverse()
	button.icon:Point("TOPLEFT", 2, -2)
	button.icon:Point("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
	
	button.count:Point("BOTTOMRIGHT", 3, 3)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C["media"].font, 9, "THICKOUTLINE")
	button.count:SetTextColor(0.84, 0.75, 0.65)
	
	button.overlayFrame = CreateFrame("frame", nil, button, nil)
	button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
	button.cd:ClearAllPoints()
	button.cd:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
	button.cd:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)	   
	button.overlay:SetParent(button.overlayFrame)
	button.count:SetParent(button.overlayFrame)
	button.remaining:SetParent(button.overlayFrame)
			
	button.Glow = CreateFrame("Frame", nil, button)
	button.Glow:Point("TOPLEFT", button, "TOPLEFT", -3, 3)
	button.Glow:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 3, -3)
	button.Glow:SetFrameStrata("BACKGROUND")	
	button.Glow:SetBackdrop{edgeFile = C["media"].glowTex, edgeSize = 3, insets = {left = 0, right = 0, top = 0, bottom = 0}}
	button.Glow:SetBackdropColor(0, 0, 0, 0)
	button.Glow:SetBackdropBorderColor(0, 0, 0)
end

T.PostUpdateAura = function(icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(unpack(C["media"].bordercolor))
			icon.icon:SetDesaturated(true)
		else
			local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
			icon:SetBackdropBorderColor(color.r * 0.6, color.g * 0.6, color.b * 0.6)
			icon.icon:SetDesaturated(false)
		end
	else
		if (isStealable or ((T.myclass == "MAGE" or T.myclass == "PRIEST" or T.myclass == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
			icon:SetBackdropBorderColor(1, 0.85, 0, 1)
		else
			icon:SetBackdropBorderColor(unpack(C.media.bordercolor))
		end
	end
	
	if duration and duration > 0 then
		if C["unitframes"].auratimer == true then
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	if T.ReverseTimer and T.ReverseTimer[spellID] then 
		icon.reverse = true 
	else
		icon.reverse = false
	end	
	icon:SetScript("OnUpdate", CreateAuraTimer)
end

T.HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end
T.PortraitUpdate = function(self, unit)
	--Fucking Furries
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end
end
-- jasje castbar
T.PostCastStart = function(self, unit, name, rank, castid)
	if unit == "vehicle" then unit = "player" end
	--Fix blank castbar with opening text
	if name == "Opening" then
		self.Text:SetText("Opening")
	end

	if self.interrupt and unit ~= "player" then
		if UnitCanAttack("player", unit) then
			self:SetStatusBarColor(unpack(C["castbar"].nointerruptcolor))
		else
			self:SetStatusBarColor(unpack(C["castbar"].nointerruptcolor))	
		end
	else
        if C["castbar"].classcolor and (unit == "player" or unit == "target") then
            self:SetStatusBarColor(unpack(oUF.colors.class[select(2, UnitClass(unit))]))
        else
            self:SetStatusBarColor(unpack(C["castbar"].castbarcolor))
        end
	end
end

T.UpdateShards = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'SOUL_SHARDS')) then return end
	local num = UnitPower(unit, SPELL_POWER_SOUL_SHARDS)
	for i = 1, SHARD_BAR_NUM_SHARDS do
		if(i <= num) then
			self.SoulShards[i]:SetAlpha(1)
		else
			self.SoulShards[i]:SetAlpha(.2)
		end
	end
end

T.Phasing = function(self, event)
	local inPhase = UnitInPhase(self.unit)
	local picon = self.PhaseIcon

	if not UnitIsPlayer(self.unit) then picon:Hide() return end

	-- TO BE COMPLETED
end

T.UpdateHoly = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= 'HOLY_POWER')) then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	for i = 1, MAX_HOLY_POWER do
		if(i <= num) then
			self.HolyPower[i]:SetAlpha(1)
		else
			self.HolyPower[i]:SetAlpha(.2)
		end
	end
end

T.EclipseDirection = function(self)
	if ( GetEclipseDirection() == "sun" ) then
			self.Text:SetText("|cffE5994C"..L.unitframes_ouf_starfirespell.."|r")
	elseif ( GetEclipseDirection() == "moon" ) then
			self.Text:SetText("|cff4478BC"..L.unitframes_ouf_wrathspell.."|r")
	else
			self.Text:SetText("")
	end
end

T.DruidBarDisplay = function(self, login)
	local eb = self.EclipseBar
	local dm = self.DruidMana
	local txt = self.EclipseBar.Text
	local shadow = self.shadow
	local bg = self.DruidManaBackground
	local buffs = self.Buffs
	local flash = self.FlashInfo

	if login then
		dm:SetScript("OnUpdate", nil)
	end
	
	if eb:IsShown() or dm:IsShown() then
		if eb:IsShown() then
			txt:Show()
			flash:Hide()
		end
		shadow:Point("TOPLEFT", -4, 12)
		bg:SetAlpha(1)
		if T.lowversion then
			if buffs then buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 34) end
		else
			if buffs then buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 38) end
		end				
	else
		txt:Hide()
		flash:Show()
		shadow:Point("TOPLEFT", -4, 4)
		bg:SetAlpha(0)
		if T.lowversion then
			if buffs then buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 26) end
		else
			if buffs then buffs:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 30) end
		end
	end
end

T.MLAnchorUpdate = function (self)
	if self.Leader:IsShown() then
		self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
	else
		self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
	end
end

T.UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end

T.UpdateName = function(self,event)
	if self.Name then self.Name:UpdateTag(self.unit) end
end

local UpdateManaLevelDelay = 0
T.UpdateManaLevel = function(self, elapsed)
	UpdateManaLevelDelay = UpdateManaLevelDelay + elapsed
	if self.parent.unit ~= "player" or UpdateManaLevelDelay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	UpdateManaLevelDelay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if percMana <= C.unitframes.lowThreshold then
		self.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
		Flash(self, 0.3)
	else
		self.ManaLevel:SetText()
		StopFlash(self)
	end
end

T.UpdateDruidMana = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= C["unitframes"].lowThreshold then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..L.unitframes_ouf_lowmana.."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidManaText:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
				self.DruidManaText:SetFormattedText("|cffD7BEA5-|r  |cff4693FF%d%%|r|r", floor(min / max * 100))
			else
				self.DruidManaText:SetPoint("LEFT", self.panel, "LEFT", 4, 1)
				self.DruidManaText:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidManaText:SetText()
		end

		self.DruidManaText:SetAlpha(1)
	else
		self.DruidManaText:SetAlpha(0)
	end
end

T.UpdateThreat = function(self, event, unit)
	if (self.unit ~= unit) or (unit == "target" or unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget") then return end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		--if self.panel then
		--	self.panel:SetBackdropBorderColor(.69,.31,.31,1)
		    if self.HealthBorder then
		    self.HealthBorder:SetBackdropBorderColor(5 ,0, 0,1)
		else
			self.Name:SetTextColor(1,0.1,0.1)
		end
	else
		--if self.panel then
		--	self.panel:SetBackdropBorderColor(unpack(C["media"].altbordercolor))
		if self.HealthBorder then
  	        self.HealthBorder:SetBackdropBorderColor(unpack(C["media"].bordercolor))
		else
			self.Name:SetTextColor(1,1,1)
		end
	end 
end

--------------------------------------------------------------------------------------------
-- THE AURAWATCH FUNCTION ITSELF. HERE BE DRAGONS!
--------------------------------------------------------------------------------------------

T.countOffsets = {
	TOPLEFT = {8*C["unitframes"].gridscale, 1},
	TOPRIGHT = {-8*C["unitframes"].gridscale, 1},
	BOTTOMLEFT = {8*C["unitframes"].gridscale, 2},
	BOTTOMRIGHT = {-8*C["unitframes"].gridscale, 2},
	LEFT = {6*C["unitframes"].gridscale, 1},
	RIGHT = {-6*C["unitframes"].gridscale, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

T.CreateAuraWatchIcon = function(self, icon)
	icon:SetTemplate("Default")
	icon:SetFrameStrata("HIGH")
	icon.icon:Point("TOPLEFT", 1, -1)
	icon.icon:Point("BOTTOMRIGHT", -1, 1)
	icon.icon:SetTexCoord(.08, .92, .08, .92)
	icon.icon:SetDrawLayer("ARTWORK")
	if (icon.cd) then
		icon.cd:SetReverse()
	end
	icon.overlay:SetTexture()
end

T.createAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetFrameStrata("HIGH")
	auras:SetPoint("TOPLEFT", self.Health, 2, -2)
	auras:SetPoint("BOTTOMRIGHT", self.Health, -2, 4)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if (not C["unitframes"].auratimer) then
		auras.hideCooldown = true
	end

	local buffs = {}

	if (T.buffids["ALL"]) then
		for key, value in pairs(T.buffids["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if (T.buffids[T.myclass]) then
		for key, value in pairs(T.buffids[T.myclass]) do
			tinsert(buffs, value)
		end
	end

	-- "Cornerbuffs"
	if (buffs) then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon:Width(8*C["unitframes"].gridscale)
			icon:Height(8*C["unitframes"].gridscale)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C.media.blank)
			if (spell[3]) then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = icon:CreateFontString(nil, "OVERLAY")
			count:SetFont(C["media"].pixelfont, 10*C["unitframes"].gridscale, "MONOCHROMEOUTLINE")
			count:SetPoint("CENTER", unpack(T.countOffsets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end
	
	self.AuraWatch = auras
end

if C["unitframes"].raidunitdebuffwatch == true then
	-- Classbuffs { spell ID, position [, {r,g,b,a}][, anyUnit] }
	-- For oUF_AuraWatch
	do
		T.buffids = {
			PRIEST = {
				{6788, "TOPLEFT", {1, 0, 0}, true}, -- Weakened Soul
				{33076, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Prayer of Mending
				{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Renew
				{17, "BOTTOMRIGHT", {0.81, 0.85, 0.1}, true}, -- Power Word: Shield
			},
			DRUID = {
				{774, "TOPLEFT", {0.8, 0.4, 0.8}}, -- Rejuvenation
				{8936, "TOPRIGHT", {0.2, 0.8, 0.2}}, -- Regrowth
				{33763, "BOTTOMLEFT", {0.4, 0.8, 0.2}}, -- Lifebloom
				{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}}, -- Wild Growth
			},
			PALADIN = {
				{53563, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Beacon of Light
			},
			SHAMAN = {
				{61295, "TOPLEFT", {0.7, 0.3, 0.7}}, -- Riptide 
				{51945, "TOPRIGHT", {0.2, 0.7, 0.2}}, -- Earthliving
				{16177, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, -- Ancestral Fortitude
				{974, "BOTTOMRIGHT", {0.7, 0.4, 0}, true}, -- Earth Shield
			},
			WARLOCK = {
				{85767, "BOTTOMLEFT", {.804, .804, .804}}, -- Dark Intent Target
			},
			ALL = {
				{14253, "RIGHT", {0, 1, 0}}, -- Abolish Poison
				{23333, "LEFT", {1, 0, 0}}, -- Warsong flag xD
			},
		}
	end
		local _, ns = ...
	-- Raid debuffs (now using it with oUF_RaidDebuff instead of oUF_Aurawatch)
	do
		local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs

		if not ORD then return end
		
		ORD.ShowDispelableDebuff = true
		ORD.FilterDispellableDebuff = true
		ORD.MatchBySpellName = true
		
		local function SpellName(id)
			local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
			return name	
		end

		T.debuffids = {
		-- Other debuff
			SpellName(67479), -- Impale

		--CATA DEBUFFS
		--Firelands
			--Beth'tilac
			SpellName(99506), -- Widow's Kiss
			SpellName(97202), -- Fiery Web Spin
			SpellName(49026), -- Fixate
			SpellName(97079), -- Seeping Venom
		
			--Alysrazor
			SpellName(101296), -- Fiero Blast
			SpellName(100723), -- Gushing Wound
			SpellName(99389), -- Imprinted
			SpellName(101729), -- Blazing Claw
			
			--Shannox
			SpellName(99837), -- Crystal Prison
			SpellName(99937), -- Jagged Tear
			
			--Baleroc
			SpellName(99256), -- Tormented2
			SpellName(99403), -- Tormented
			SpellName(99252), -- Blaze of Glory
			SpellName(99516), -- Countdown
			
			--Lord Rhyolith
			--<< NONE KNOWN YET >>

			--Majordomo Staghelm
			SpellName(98450), -- Searing Seeds
			SpellName(98565), -- Burning Orb


			--Ragnaros
			SpellName(99399), -- Burning Wound
			SpellName(100293), -- Lava Wave
			SpellName(98313), -- Magma Blast
			SpellName(100675), -- Dreadflame
			
			--Trash
			SpellName(99532), -- Melt Armor
		
		--Baradin Hold
			--Occu'thar
			SpellName(96913), -- Searing Shadows
			--Argaloth
			SpellName(95173), -- Consuming Darkness
			

		--Blackwing Descent
			--Magmaw
			SpellName(91911), -- Constricting Chains
			SpellName(94679), -- Parasitic Infection
			SpellName(94617), -- Mangle

			--Omintron Defense System
			SpellName(79835), --Poison Soaked Shell
			SpellName(91433), --Lightning Conductor
			SpellName(91521), --Incineration Security Measure

			--Maloriak
			SpellName(77699), -- Flash Freeze
			SpellName(77760), -- Biting Chill

			--Atramedes
			SpellName(92423), -- Searing Flame
			SpellName(92485), -- Roaring Flame
			SpellName(92407), -- Sonic Breath

			--Chimaeron
			SpellName(82881), -- Break
			SpellName(89084), -- Low Health

			--Nefarian

			--Sinestra
			SpellName(92956), --Wrack

		--The Bastion of Twilight
			--Valiona & Theralion
			SpellName(92878), -- Blackout
			SpellName(86840), -- Devouring Flames
			SpellName(95639), -- Engulfing Magic

			--Halfus Wyrmbreaker
			SpellName(39171), -- Malevolent Strikes

			--Twilight Ascendant Council
			SpellName(92511), -- Hydro Lance
			SpellName(82762), -- Waterlogged
			SpellName(92505), -- Frozen
			SpellName(92518), -- Flame Torrent
			SpellName(83099), -- Lightning Rod
			SpellName(92075), -- Gravity Core
			SpellName(92488), -- Gravity Crush

			--Cho'gall
			SpellName(86028), -- Cho's Blast
			SpellName(86029), -- Gall's Blast

		--Throne of the Four Winds
			--Conclave of Wind
				--Nezir <Lord of the North Wind>
				SpellName(93131), --Ice Patch
				--Anshal <Lord of the West Wind>
				SpellName(86206), --Soothing Breeze
				SpellName(93122), --Toxic Spores
				--Rohash <Lord of the East Wind>
				SpellName(93058), --Slicing Gale
			--Al'Akir
				SpellName(93260), -- Ice Storm
				SpellName(93295), -- Lightning Rod
		}

		T.ReverseTimer = {
			[92956] = true, -- Sinestra (Wrack)
		},
		
		ORD:RegisterDebuffs(T.debuffids)
	end
end