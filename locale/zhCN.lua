if GetLocale() ~= "zhCN" then return end

AddonLoader.L = {
	explain = "你可以重写每个插件的载入条件. 重写后需要重载界面才能应用新的条件. 现在插件列表中未载入的插件还保持原载入条件.",
	hideloading = "隐藏聊天框反馈",
	reset = "重置",
}
