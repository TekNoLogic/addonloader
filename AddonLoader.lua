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
local L = AceLibrary("AceLocale-2.2"):new("AddonLoader")

AddonLoader = AceLibrary("AceAddon-2.0"):new("AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0", "AceModuleCore-2.0")
local AddonLoader = AddonLoader
AddonLoader.slashes = {}

AddonLoader:SetModuleMixins("AceEvent-2.0", "AceDB-2.0", "AceHook-2.1")
AddonLoader:RegisterDB("AddonLoaderDB")
local numaddons = GetNumAddOns()
local GetAddOnInfo = GetAddOnInfo
local GetAddOnMetadata = GetAddOnMetadata

local overridesvalidate = {
	L.None,
	L.Always,
	L.AuctionHouse,
	L.Arena,
	L.Bank,
	L.Battleground,
	L.Combat,
	L.Crafting,
	L.Group,
	L.Guild,
	L.Instance,
	L.Mailbox,
	L.Merchant,
	L.NotResting,
	L.PvPFlagged,
	L.Raid,
	L.Resting,
}

local overrides = {
	[L.Always] = 'X-LoadOn-Always',
	[L.AuctionHouse] = 'X-LoadOn-AuctionHouse',
	[L.Arena] = 'X-LoadOn-Arena',
	[L.Bank] = 'X-LoadOn-Bank',
	[L.Battleground] = 'X-LoadOn-Battleground',
	[L.Combat] = 'X-LoadOn-Combat',
	[L.Crafting] = 'X-LoadOn-Crafting',
	[L.Group] = 'X-LoadOn-Group',
	[L.Guild] = 'X-LoadOn-Guild',
	[L.Instance] = 'X-LoadOn-Instance',
	[L.Mailbox] = 'X-LoadOn-Mailbox',
	[L.Merchant] = 'X-LoadOn-Merchant',
	[L.NotResting] = 'X-LoadOn-NotResting',
	[L.PvPFlagged] = 'X-LoadOn-PvPFlagged',
	[L.Raid] = 'X-LoadOn-Raid',
	[L.Resting] = 'X-LoadOn-Resting',
}

local options = {
	type = 'group',
	args = {
		messages = {
			name = L["Messages"],
			desc = L["Show messages in the chat frame when addons are loaded"],
			type = 'toggle',
			get = function()
				return AddonLoader.db.profile.messages
			end,
			set = function(v)
				AddonLoader.db.profile.messages = v
			end,
		},
		overrides = {
			name = L["Overrides"],
			desc = L["Set alternate conditions for loading a given addon, overriding those in its toc file. NOTE: These settings do not take effect until a UI reload."],
			type = 'group',
			args = {}
		},
	},
}

function AddonLoader:ADDON_LOADED(addon)
	if addon=="ForkliftGnome" then	-- Keep ForkliftGnome from doing the same work as AddonLoader (and generating errors!)
		ForkliftGnome.OnEnable = function() end
	end
end

function AddonLoader:OnInitialize()
	self:RegisterDefaults('profile', {
		messages = true,
		overrides = {
			['*'] = false,
		},
	})
	self:RegisterChatCommand({'/addonloader','/aloader','/aload'}, options)
	self:RegisterEvent("ADDON_LOADED");
end

do
	local handleLoadAddOn
	do
		local loadattempted = {}
		function handleLoadAddOn(addon)
			if tonumber(addon) then
				addon = GetAddOnInfo(addon)
			end
			if loadattempted[addon] then
				return
			end
			loadattempted[addon] = true
			if options.args.overrides.args[addon] then
				if IsAddOnLoaded(addon) then
					if AddonLoader.db.profile.messages then
						AddonLoader:Print(L["Loaded %s."]:format(addon));
					end
				else
					local name, _,_, enabled = GetAddOnInfo(addon);
					if name and not enabled then
						-- don't complain
					else
						local _, reason = LoadAddOn(addon)
						AddonLoader:Print(L["Failed to load %s: %s."]:format(addon, reason));
					end
				end
			end
			for name, module in AddonLoader:IterateModules() do
				if not module.off then
					local t = module.addons
					if name == addon then
						module:Disable()
					elseif t and t[addon] then
						t[addon] = nil
						if not next(t) then
							module:Disable()
						end
					end
				end
			end
			for _, v in ipairs(AddonLoader.slashes) do
				hash_SlashCmdList[v] = nil
			end
		end
	end
	local function get(addon)
		local value = AddonLoader.db.profile.overrides[addon]
		if not value then
			return L.None
		end
		for k,v in pairs(overrides) do
			if v == value then
				return k
			end
		end
	end
	local function set(addon,v)
		if v == L.None then
			AddonLoader.db.profile.overrides[addon] = false
		else
			AddonLoader.db.profile.overrides[addon] = overrides[v]
		end
	end
	
	function AddonLoader:OnEnable(first)
		if not first then
			return
		end
		hooksecurefunc('LoadAddOn', handleLoadAddOn)
		local metadatafields = self.metadatafields
		local overrides = self.db.profile.overrides
		local options = options.args.overrides.args
		for i = 1, numaddons do
			if IsAddOnLoadOnDemand(i) then
				local name = GetAddOnInfo(i)
				local hasfield
				local alreadyloaded
				if overrides[name] and overrides[name] == 'X-LoadOn-Always' then
					metadatafields[overrides[name]](name)
					hasfield = true
				elseif overrides[name] then
					metadatafields[overrides[name]](name)
					local metadata = GetAddOnMetadata(i, 'X-LoadOn-Slash')
					if metadata then
						metadatafields['X-LoadOn-Slash'](name, metadata)
					end
					local metadata = GetAddOnMetadata(i, 'X-LoadOn-Execute')
					if metadata then
						metadatafields['X-LoadOn-Execute'](name, metadata)
					end
					hasfield = true
				else
					alreadyloaded = not not IsAddOnLoaded(i)
					for k,v in pairs(metadatafields) do
						local metadata = GetAddOnMetadata(i, k)
						if metadata then
							hasfield = true
							if not alreadyloaded then
								v(name, metadata)
							end
						end
					end
				end
				if hasfield then
					options[name] = {
						name = name,
						desc = L["Set the loading condition for %s.  NOTE: Does not take effect until a UI reload."]:format(name),
						type = 'text',
						get = get,
						set = set,
						validate = overridesvalidate,
						disabled = alreadyloaded,
						passValue = name,
					}
				end
			end
		end
		self.metadatafields = nil
	end
end

function AddonLoader.modulePrototype:Disable()
	self.off = true
	self.addons = nil
	self:UnregisterAllEvents()
	if self.UnhookAll then
		self:UnhookAll()
	end
end
