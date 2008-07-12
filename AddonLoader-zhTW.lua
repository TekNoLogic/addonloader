local L = AceLibrary("AceLocale-2.2"):new("AddonLoader")
L:RegisterTranslations("zhTW", function()
	return {
		
		["Messages"] = "訊息",
		["Show messages in the chat frame when addons are loaded"] = "在聊天視窗顯示載入插件訊息",
		
		["Loaded %s."] = "已載入「%s」。",
		["Failed to load %s: %s."] = "載入「%s」失敗: %s。",
		
		["Overrides"] = "置換",
		["Set alternate conditions for loading a given addon, overriding those in its toc file. NOTE: These settings do not take effect until a UI reload."] = "無視toc檔案的設定，設定替代載入條件。注意: 需要重載介面。",
		["Set the loading condition for %s.  NOTE: Does not take effect until a UI reload."] = "設定載入「%s」的條件。注意: 需要重載介面。",
		
		["Always"] = "總是",
		["AuctionHouse"] = "拍賣場",
		["Arena"] = "競技場",
		["Bank"] = "銀行",
		["Battleground"] = "戰場",
		["Combat"] = "戰鬥",
		["Crafting"] = "製造",
		["Group"] = "團體",
		["Guild"] = "公會",
		["Instance"] = "副本",
		["Mailbox"] = "郵箱",
		["Merchant"] = "商人",
		["None"] = "無",
		["NotResting"] = "非休息中",
		["PvPFlagged"] = "PvP",
		["Raid"] = "團隊",
		["Resting"] = "休息中",
	}
end)
