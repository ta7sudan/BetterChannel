local global = select(2, ...);
local waitTable = {};
local waitFrame = nil;

global.util = {
	trim = function (str)
		return (str:gsub("^%s*(.-)%s*$", "%1"));
	end,
	split = function (str, sep)
		local array = {};
		if sep == nil or #sep == 0 then
			sep = '%s';
		end
		for part in str:gmatch('([^'..sep..']+)') do
			table.insert(array, part);
		end
		return unpack(array);
	end,
	tableToString = function (t)
		local mark   = {}
		local assign = {}
		
		local function serialize(tbl, parent)
			mark[tbl] = parent
			local tmp = {}
			for k, v in pairs(tbl) do
				local typek = type(k)
				local typev = type(v)

				local key = typek == "number" and "[" .. k .."]" or k

				if typev == "table" then
					local dotkey = parent .. (typek == "number" and key or "." .. key)
					if mark[v] then
						table.insert(assign, dotkey .. "=" .. mark[v])
					else
						if typek == "number" then
							table.insert(tmp, serialize(v,dotkey))
						else
							table.insert(tmp, key .. "=" .. serialize(v, dotkey))
						end
					end
				else
					if typev == "string" then
						v = string.gsub(v, "\n", "\\n")
						if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
							v = "'" .. v .. "'"
						else
							v = '"' .. v .. '"'
						end
					else
						v = tostring(v)
					end
					if typek == "number" then
						table.insert(tmp, v)
					else
						table.insert(tmp, key .. "=" .. v)
					end
				end
			end
			return "{" .. table.concat(tmp, ",") .. "}"
		end
		return serialize(t, "ret") .. table.concat(assign," ")
	end,

	setTimeout = function (cb, time, ...)
		if(type(time)~='number' or type(cb)~='function') then
			return false;
		end

		if(waitFrame == nil) then
			waitFrame = CreateFrame('Frame','WaitFrame', UIParent);
			waitFrame:SetScript('onUpdate', function (self, elapse)
				local count = #waitTable;
				local i = 1;
				while(i<=count) do
					local waitRecord = tremove(waitTable, i);
					local d = tremove(waitRecord, 1);
					local f = tremove(waitRecord, 1);
					local p = tremove(waitRecord, 1);
					if(d>elapse) then
						tinsert(waitTable, i, { d-elapse, f, p });
						i = i + 1;
					else
						count = count - 1;
						f(unpack(p));
					end
				end
			end);
		end
		tinsert(waitTable,{time, cb, {...}});
		return true;
	end
};