local L = AceLibrary("AceLocale-2.2"):new("AddonLoader")
L:RegisterTranslations("enUS", function()
	return {
		
		["Messages"] = true,
		["Show messages in the chat frame when addons are loaded"] = true,
		
		["Loaded %s."] = true,
		["Failed to load %s: %s."] = true,
		
		["Overrides"] = true,
		["Set alternate conditions for loading a given addon, overriding those in its toc file. NOTE: These settings do not take effect until a UI reload."] = true,
		["Set the loading condition for %s.  NOTE: Does not take effect until a UI reload."] = true,
		
		["Always"] = true,
		["AuctionHouse"] = true,
		["Arena"] = true,
		["Bank"] = true,
		["Battleground"] = true,
		["Combat"] = true,
		["Crafting"] = true,
		["Group"] = true,
		["Guild"] = true,
		["Instance"] = true,
		["Mailbox"] = true,
		["Merchant"] = true,
		["None"] = true,
		["NotResting"] = true,
		["PvPFlagged"] = true,
		["Raid"] = true,
		["Resting"] = true,
	}
end)
