BetterChannelGlobalDB = BetterChannelGlobalDB or {
	blockedUsers = {},
	blockedKeywords = {},
	blockedRegExp = {}
};

BetterChannelCharacterDB = BetterChannelCharacterDB or {
	blockedUsers = {},
	blockedKeywords = {},
	blockedRegExp = {}
};

-- BetterChannelGlobalDB = {
-- 	blockedUsers = {},
-- 	blockedKeywords = {}
-- };

-- BetterChannelCharacterDB = {
-- 	blockedUsers = {},
-- 	blockedKeywords = {}
-- };

local global = select(2, ...);
local trim, split, setTimeout = global.util.trim, global.util.split, global.util.setTimeout;
local USER_SCOPE, GLOBAL_SCOPE = 'u', 'g';
local serverName = GetRealmName();
_G.channelLastTimeMap = {};
local TIME_LIMIT = 60;

-- 不能从0开始, 不知道为什么
SLASH_BC_ADD_USER1 = '/au';
SLASH_BC_DELETE_USER1 = '/du';
SLASH_BC_ADD_WORD1 = '/aw';
SLASH_BC_DELETE_WORD1 = '/dw';
SLASH_BC_LIST_USER1 = '/lsu';
SLASH_BC_LIST_WORD1 = '/lsw';

SlashCmdList.BC_ADD_USER = function (rawMsg, chatBox)
	local msg = trim(rawMsg);
	local rawUserName, rawScope = split(msg, '-');
	
	if rawScope ~= USER_SCOPE then
		rawScope = GLOBAL_SCOPE;
	end

	local userName, scope = trim(rawUserName), trim(rawScope);
	if #userName > 0 then
		if scope == USER_SCOPE then
			BetterChannelCharacterDB.blockedUsers[userName..'-'..serverName] = true;
			print('用户: '..userName..' 已在该角色下屏蔽');
		elseif scope == GLOBAL_SCOPE then
			BetterChannelGlobalDB.blockedUsers[userName..'-'..serverName] = true;
			print('用户: '..userName..' 已在所有角色下屏蔽');
		end
	end
end

SlashCmdList.BC_DELETE_USER = function (rawMsg, chatBox)
	local msg = trim(rawMsg);
	local rawUserName, rawScope = split(msg, '-');
	
	if rawScope ~= USER_SCOPE then
		rawScope = GLOBAL_SCOPE;
	end

	local userName, scope = trim(rawUserName), trim(rawScope);
	if #userName > 0 then
		if scope == USER_SCOPE then
			BetterChannelCharacterDB.blockedUsers[userName..'-'..serverName] = nil;
			print('用户: '..userName..' 已在该角色下解除屏蔽');
		elseif scope == GLOBAL_SCOPE then
			BetterChannelGlobalDB.blockedUsers[userName..'-'..serverName] = nil;
			print('用户: '..userName..' 已在所有角色下解除屏蔽');
		end
	end
end

SlashCmdList.BC_ADD_WORD = function (rawMsg, chatBox)
	local msg = trim(rawMsg);
	local rawKeyword, rawScope = split(msg, '-');
	
	if rawScope ~= USER_SCOPE then
		rawScope = GLOBAL_SCOPE;
	end

	local keyword, scope = trim(rawKeyword), trim(rawScope);
	if #keyword > 0 then
		if scope == USER_SCOPE then
			BetterChannelCharacterDB.blockedKeywords[keyword] = true;
			print('关键词: '..keyword..' 已在该角色下屏蔽');
		elseif scope == GLOBAL_SCOPE then
			BetterChannelGlobalDB.blockedKeywords[keyword] = true;
			print('关键词: '..keyword..' 已在所有角色下屏蔽');
		end
	end
end

SlashCmdList.BC_DELETE_WORD = function (rawMsg, chatBox)
	local msg = trim(rawMsg);
	local rawKeyword, rawScope = split(msg, '-');
	
	if rawScope ~= USER_SCOPE then
		rawScope = GLOBAL_SCOPE;
	end

	local keyword, scope = trim(rawKeyword), trim(rawScope);
	if #keyword > 0 then
		if scope == USER_SCOPE then
			BetterChannelCharacterDB.blockedKeywords[keyword] = nil;
			print('关键词: '..keyword..' 已在该角色下解除屏蔽');
		elseif scope == GLOBAL_SCOPE then
			BetterChannelGlobalDB.blockedKeywords[keyword] = nil;
			print('关键词: '..keyword..' 已在所有角色下解除屏蔽');
		end
	end
end

SlashCmdList.BC_LIST_USER = function (msg)
	print('已在该角色屏蔽如下用户:');
	for k, v in pairs(BetterChannelCharacterDB.blockedUsers) do
		print(k);
	end
	print('已在所有角色屏蔽如下用户:');
	for k, v in pairs(BetterChannelGlobalDB.blockedUsers) do
		print(k);
	end
end

SlashCmdList.BC_LIST_WORD = function (msg)
	print('已在该角色屏蔽如下关键词:');
	for k, v in pairs(BetterChannelCharacterDB.blockedKeywords) do
		print(k);
	end
	print('已在所有角色屏蔽如下关键词:');
	for k, v in pairs(BetterChannelGlobalDB.blockedKeywords) do
		print(k);
	end
end

function filter(chatFrame, event, msg, playerNameAndServer, arg0, channelIDAndChannel, player, arg1, arg2, channelID, channel, ...)
	local userNameAndServer = player..'-'..serverName;

	-- 世界频道节流
	if channelLastTimeMap[channel] == nil then
		channelLastTimeMap[channel] = {};
	end
	if event == 'CHAT_MSG_CHANNEL' then
		if channelLastTimeMap[channel][player] ~= nil and GetTime() - channelLastTimeMap[channel][player] < TIME_LIMIT then
			return true;
		end
		channelLastTimeMap[channel][player] = GetTime();
		setTimeout(function ()
			channelLastTimeMap[channel][player] = nil;
		end, 1000);
	end

	-- 用户名过滤
	if BetterChannelGlobalDB.blockedUsers[userNameAndServer] or BetterChannelCharacterDB.blockedUsers[userNameAndServer] then
		return true;
	end

	-- 关键字过滤
	for keyword, v in pairs(BetterChannelCharacterDB.blockedKeywords) do
		local lowerCaseMsg = msg:lower();
		if lowerCaseMsg:find(keyword:lower()) then
			return true;
		end
	end
	for keyword, v in pairs(BetterChannelGlobalDB.blockedKeywords) do
		local lowerCaseMsg = msg:lower();
		if lowerCaseMsg:find(keyword:lower()) then
			return true;
		end
	end

	-- TODO 正则表达式过滤 特定频道过滤 对重复添加屏蔽的关键词和用户增加友好提示

	return false, msg, playerNameAndServer, arg0, channelIDAndChannel, player, arg1, arg2, channelID, channel, ...;
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', filter);
ChatFrame_AddMessageEventFilter('CHAT_MSG_YELL', filter);
ChatFrame_AddMessageEventFilter('CHAT_MSG_WHISPER', filter);
