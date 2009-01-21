if GetLocale() ~= "zhTW" then return end

AddonLoader.L = {
	explain = "你可以重寫每個插件的載入條件. 重寫后需要重載界面才能應用新的條件. 現在插件列表中未載入的插件還保持原載入條件.",
	hideloading = "隱藏聊天框反饋",
	reset = "重置",
}
