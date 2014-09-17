function lzwCode(szSource, nBeginCode)
	local tbOutput = {}
	local tbChar = {}
	local szPrefix = ""
	local tbToken = {}
	local nTokenCode = nBeginCode
	for szChar in string.gmatch(szSource, ".") do
		tbChar[szChar] = true
		if szPrefix == "" then
			szPrefix = szChar
		else
			if tbToken[szPrefix .. szChar] then
				szPrefix = tbToken[szPrefix .. szChar]
			else
				tbToken[szPrefix .. szChar] = nTokenCode
				nTokenCode = nTokenCode + 1
				table.insert(tbOutput, szPrefix)
				szPrefix = szChar
			end
		end
	end
	if szPrefix~= "" then
		table.insert(tbOutput, szPrefix)
	end
	return tbOutput, tbChar
end

function lzwFindFirstNormalChar(tbDeCodeToken, szCode)
	local szNormalChar = szCode
	while (tbDeCodeToken[tonumber(szNormalChar)]) do
		szNormalChar = tbDeCodeToken[tonumber(szNormalChar)][1]
	end
	return szNormalChar
end

function lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
	local tbPrefix = { szPrefix }
	while #tbPrefix ~= 0 do
		local szFirst = table.remove(tbPrefix, 1)
		local tbDecode = tbDeCodeToken[tonumber(szFirst)]
		if tbDecode then
			table.insert(tbPrefix, 1, tbDecode[2])
			table.insert(tbPrefix, 1, tbDecode[1])
		else
			szSource = szSource .. szFirst
		end
	end
	return szSource
end

function lzwDecode(tbCode, tbChar, nBeginCode)
	local szSource = ""
	local szPrefix = ""
	local tbToken = {}
	local tbDeCodeToken = {}
	local nTokenCode = nBeginCode
	for _, szCode in ipairs(tbCode) do
		if szPrefix ~= "" then
			if tbChar[szCode] then	--判断后缀是否是正常后缀
				tbToken[szPrefix .. szCode] = nTokenCode
				tbDeCodeToken[nTokenCode] = { szPrefix, szCode }
				nTokenCode = nTokenCode + 1
				--前缀放入输出流
				szSource = lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
			else
				if tbDeCodeToken[tonumber(szCode)] then
					local szSuffix = lzwFindFirstNormalChar(tbDeCodeToken, tbDeCodeToken[tonumber(szCode)][1])
					tbToken[szPrefix .. szSuffix] = nTokenCode
					tbDeCodeToken[nTokenCode] = { szPrefix, szSuffix }
					nTokenCode = nTokenCode + 1
					--前缀放入输出流
					szSource = lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
				else
					if tbChar[szPrefix] then
						tbToken[szPrefix .. szPrefix] = nTokenCode
						tbDeCodeToken[nTokenCode] = { szPrefix, szPrefix }
					else
						local szSuffix = lzwFindFirstNormalChar(tbDeCodeToken, tbDeCodeToken[tonumber(szPrefix)][1])
						tbToken[szPrefix .. szSuffix] = nTokenCode
						tbDeCodeToken[nTokenCode] = { szPrefix, szSuffix }
					end
					nTokenCode = nTokenCode + 1
					--前缀放入输出流
					szSource = lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
				end
			end
		end
		szPrefix = szCode
	end
	szSource = lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
	return szSource
end

--[[字符串测试
local szSource = "dsfakfjljsds  sdf\ \tfg\\ \ "
local nBeginCode = 6
print(szSource)
local tbCode, tbChar = lzwCode(szSource, nBeginCode)
print(table.concat(tbCode, ","))
print(lzwDecode(tbCode, tbChar, nBeginCode))
]]

--[[文件测试
local hFile = io.open("1.txt", "r")
local szStr = hFile:read("*a")
print("origin length = ", string.len(szStr))
local tbCode, tbChar = lzwCode(szStr, 6)
local hOutputFile = io.open("2.txt", "w")
hOutputFile:write(table.concat(tbCode, ","))
print("output length = ", #tbCode)
local hDecodeFile = io.open("3.txt", "w")
hDecodeFile:write(lzwDecode(tbCode, tbChar, 6))
]]
