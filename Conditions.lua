--[[
	Copyright (C) 2007 Nymbia

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]

local BZ = AceLibrary("Babble-Zone-2.2")
local assert = assert
local pcall = pcall
local _G = getfenv(0)

local registerIntoModule
do
	local function trigger(self)
		local t = self.addons
		self:Disable()
		for k in pairs(t) do
			LoadAddOn(k)
		end
	end
	function registerIntoModule(modulename, addon)
		if AddonLoader:HasModule(modulename) then
			local module = AddonLoader:GetModule(modulename)
			if module.off then -- this module already triggered
				LoadAddOn(addon)
				return nil, true
			end
			module.addons[addon] = true
			return module, true
		else
			local module = AddonLoader:NewModule(modulename)
			module.addons = {[addon] = true}
			module.Trigger = trigger
			return module, false
		end
	end
end
AddonLoader.metadatafields = {
	-- Standard Triggers
	['X-LoadOn-AuctionHouse'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-AuctionHouse', addon)
		if not exists then
			function module:AUCTION_HOUSE_SHOW()
				self:Trigger()
			end
			module:RegisterEvent('AUCTION_HOUSE_SHOW')
		end
	end,
	['X-LoadOn-Arena'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Arena', addon)
		if not exists then
			function module:ZONE_CHANGED_NEW_AREA()
				if select(2, IsInInstance()) == "arena" then
					self:Trigger()
				end
			end
			module:RegisterEvent('ZONE_CHANGED_NEW_AREA')
			module:ZONE_CHANGED_NEW_AREA()
		end
	end,
	['X-LoadOn-Bank'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Bank', addon)
		if not exists then
			function module:BANKFRAME_OPENED()
				self:Trigger()
			end
			module:RegisterEvent('BANKFRAME_OPENED')
		end
	end,
	['X-LoadOn-Battleground'] = function(addon, metadata) --!!
		local module, exists = registerIntoModule('X-LoadOn-Battleground', addon)
		if not exists then
			function module:ZONE_CHANGED_NEW_AREA()
				if select(2, IsInInstance()) == "pvp" then
					self:Trigger()
				end
			end
			module:RegisterEvent('ZONE_CHANGED_NEW_AREA')
			module:ZONE_CHANGED_NEW_AREA()
		end
	end,
	['X-LoadOn-Instance'] = function(addon, metadata) --!!
		local module, exists = registerIntoModule('X-LoadOn-Instance', addon)
		if not exists then
			function module:ZONE_CHANGED_NEW_AREA()
				local instanceType = select(2, IsInInstance())
				if instanceType == 'party' or instanceType == 'raid' then
					self:Trigger()
				end
			end
			module:RegisterEvent('ZONE_CHANGED_NEW_AREA')
			module:ZONE_CHANGED_NEW_AREA()
		end
	end,	
	['X-LoadOn-Combat'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Combat', addon)
		if not exists then
			function module:PLAYER_REGEN_DISABLED()
				self:Trigger()
			end
			module:RegisterEvent('PLAYER_REGEN_DISABLED')
			if InCombatLockdown() then
				module:Trigger()
			end
		end
	end,
	['X-LoadOn-Crafting'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Crafting', addon)
		if not exists then
			function module:Open()
				self:Trigger()
			end
			module:RegisterEvent('TRADE_SKILL_SHOW', 'Open')
			module:RegisterEvent('CRAFT_SHOW', 'Open')
		end
	end,
	['X-LoadOn-Group'] = function(addon, metadata) --!!
		local module, exists = registerIntoModule('X-LoadOn-Group', addon)
		if not exists then
			function module:Changed()
				if GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0 then
					self:Trigger()
				end
			end
			module:RegisterEvent('PARTY_MEMBERS_CHANGED', 'Changed')
			module:RegisterEvent('RAID_ROSTER_UPDATE', 'Changed')
			module:Changed()
		end
	end,
	['X-LoadOn-Mailbox'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Mailbox', addon)
		if not exists then
			function module:MAIL_SHOW()
				self:Trigger()
			end
			module:RegisterEvent('MAIL_SHOW')
		end
	end,
	['X-LoadOn-Merchant'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Merchant', addon)
		if not exists then
			function module:MERCHANT_SHOW()
				self:Trigger()
			end
			module:RegisterEvent('MERCHANT_SHOW')
		end
	end,
	['X-LoadOn-NotResting'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-NotResting', addon)
		if not exists then
			function module:PLAYER_UPDATE_RESTING()
				if not IsResting() then
					self:Trigger()
				end
			end
			module:RegisterEvent('PLAYER_UPDATE_RESTING')
			module:PLAYER_UPDATE_RESTING()
		end
	end,
	['X-LoadOn-PvPFlagged'] = function(addon, metadata) --!!
		local module, exists = registerIntoModule('X-LoadOn-PvPFlagged', addon)
		if not exists then
			function module:UNIT_FACTION()
				if UnitIsPVP('player') then
					self:Trigger()
				end
			end
			module:RegisterEvent('UNIT_FACTION')
			module:UNIT_FACTION()
		end
	end,
	['X-LoadOn-Raid'] = function(addon, metadata) --!!
		local module, exists = registerIntoModule('X-LoadOn-Raid', addon)
		if not exists then
			function module:RAID_ROSTER_UPDATE()
				if GetNumRaidMembers() > 0 then
					self:Trigger()
				end
			end
			module:RegisterEvent('RAID_ROSTER_UPDATE')
			module:RAID_ROSTER_UPDATE()
		end
	end,
	['X-LoadOn-Resting'] = function(addon, metadata)
		local module, exists = registerIntoModule('X-LoadOn-Resting', addon)
		if not exists then
			function module:PLAYER_UPDATE_RESTING()
				if IsResting() then
					self:Trigger()
				end
			end
			module:RegisterEvent('PLAYER_UPDATE_RESTING')
			module:PLAYER_UPDATE_RESTING()
		end
	end,
	-- Special
	['X-LoadOn-Always'] = function(addon, metadata)
		if (metadata or ""):lower() ~= 'delayed' then
			LoadAddOn(addon)
			return
		end
		local module, exists = registerIntoModule('X-LoadOn-Delayed', addon)
		if not exists then
			module:ScheduleRepeatingEvent(function()
				local name = module.addons and next(module.addons)
				if name then
					LoadAddOn(name)
				end
			end, 1)
		end
	end,
	['X-LoadOn-Class'] = function(addon, metadata)
		local _, class = UnitClass('player')
		for loadclass in metadata:gmatch('(%w+)') do
			if loadclass:upper() == class then
				return LoadAddOn(addon)
			end
		end
	end,
	['X-LoadOn-Events'] = function(addon, metadata)
		local module
		if AddonLoader:HasModule(addon) then
			module = AddonLoader:GetModule(addon)
		else
			module = AddonLoader:NewModule(addon)
		end
		for event in metadata:gmatch('[^ ,]+') do
			local metadata = GetAddOnMetadata(addon, 'X-LoadOn-'..event)
			assert(metadata, addon..': X-LoadOn-'..event..' handler not found')
			assert(not module:IsEventRegistered(event), addon..': '..event..' already registered')
			local status, func, err = pcall(loadstring, metadata)
			if not func then
				return geterrorhandler()('## X-LoadOn-'..event..' ('..addon..'): '..err)
			end
			module:RegisterEvent(event, func)
		end
	end,
	['X-LoadOn-Execute'] = function(addon, metadata)
		for i = 2, 5 do
			local md = GetAddOnMetadata(addon, 'X-LoadOn-Execute'..i)
			if md then
				metadata = metadata..' '..md
			else
				break
			end
		end
		local status, closure, err = pcall(loadstring, metadata)
		if not closure then
			return geterrorhandler()('## X-LoadOn-Execute '..addon..': '..err)
		end
		status, err = pcall(closure)
		if not status then
			return geterrorhandler()('## X-LoadOn-Execute '..addon..': '..err)
		end
	end,
	['X-LoadOn-Guild'] = function(addon, metadata)
		if IsInGuild() then
			return LoadAddOn(addon)
		end
	end,
	['X-LoadOn-Hooks'] = function(addon, metadata)
		local module
		if AddonLoader:HasModule(addon) then
			module = AddonLoader:GetModule(addon)
		else
			module = AddonLoader:NewModule(addon)
		end
		for hook in metadata:gmatch('[^ ,]+') do
			local metadata = GetAddOnMetadata(addon, 'X-LoadOn-'..hook)
			assert(metadata, addon..': X-LoadOn-'..hook..' handler not found')
			assert(not module:IsHooked(hook), addon..': '..hook..' already registered')
			local status, func, err = pcall(loadstring, metadata)
			if not func then
				return geterrorhandler()('## X-LoadOn-'..hook..' ('..addon..'): '..err)
			end
			module:SecureHook(hook, func)
		end
	end,
	['X-LoadOn-Level'] = function(addon, metadata)
		local str = 'local level = UnitLevel("player") '
		for chunk in metadata:gmatch('([%d%p^,]+)') do
			if tonumber(chunk) then -- '68'
				str = str..(('if level == %d then return LoadAddOn(%q) end '):format(chunk, addon))
			elseif chunk:match('%+') then -- '40+'
				local low = chunk:match('%d+')
				str = str..(('if level >= %d then return LoadAddOn(%q) end '):format(low, addon))
			elseif chunk:match('%-$') then -- '30-'
				local high = chunk:match('%d+')
				str = str..(('if level <= %d then return LoadAddOn(%q) end '):format(high, addon))
			elseif chunk:match('%d+%-%d+') then -- '20-47'
				local low, high = chunk:match('(%d+)%-(%d+)')
				str = str..(('if level >= %d and level <= %d then return LoadAddOn(%q) end '):format(low, high, addon))
			else
				error('## X-LoadOn-Level '..addon..': Invalid level string ('..metadata..')')
			end
		end
		local f = loadstring(str)
		local module
		if AddonLoader:HasModule(addon) then
			module = AddonLoader:GetModule(addon)
		else
			module = AddonLoader:NewModule(addon)
		end
		module:RegisterEvent('PLAYER_LEVEL_UP',f)
		f()
	end,
	['X-LoadOn-Slash'] = function(addon, metadata)
		local addon_upper = addon:upper():gsub('[^%w]','')
		local slashes = AddonLoader.slashes
		local i = 0
		for slash in metadata:gmatch('([^, ]+)') do
			i = i + 1
			if slash:sub(1,1) ~= '/' then
				slash = '/'..slash
			end
			slashes[#slashes+1] = slash:upper()
			_G['SLASH_'..addon_upper..i] = slash
		end
		local run
		SlashCmdList[addon_upper] = function(text)
			local new = _G['SLASH_'..addon_upper..'1']
			
			if run then
				error('already loaded, this slash command should have been overwritten by this addon')
			end
			run = true
			
			SlashCmdList[addon_upper] = nil
			
			LoadAddOn(addon)
			
			for _, v in ipairs(AddonLoader.slashes) do
				hash_SlashCmdList[v] = nil
			end
			
			ChatFrame_OpenChat()
			ChatFrameEditBox:SetText(new..' '..text)
			ChatEdit_SendText(ChatFrameEditBox,1)
		end
	end,
	['X-LoadOn-Zone'] = function(addon, metadata)
		local zones = {}
		for zone in metadata:gmatch('(%w[^,]+%w)') do
			if BZ:HasTranslation(zone) then
				zones[BZ[zone]] = true
			else
				error(('## X-LoadOn-Zone '..addon..': Translation doesnt exist for %q'):format(zone))
			end
		end
		local module
		if AddonLoader:HasModule(addon) then
			module = AddonLoader:GetModule(addon)
		else
			module = AddonLoader:NewModule(addon)
		end
		function module:ZONE_CHANGED_NEW_AREA()
			if zones[GetRealZoneText()] then
				LoadAddOn(addon)
			end
		end
		module:RegisterEvent('ZONE_CHANGED_NEW_AREA')
		module:ZONE_CHANGED_NEW_AREA()
	end,
}
