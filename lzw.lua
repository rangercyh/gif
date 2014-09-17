local szSource = "AAABBBCCCDDD"
local nBeginCode = 6
local tbChar = {
	["A"] = true,
	["B"] = true,
	["C"] = true,
	["D"] = true,
}

function lzwCode(szSource)
	local tbOutput = {}
	local szPrefix = ""
	local tbToken = {}
	local nTokenCode = nBeginCode
	for szChar in string.gmatch(szSource, "%a") do
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
	table.insert(tbOutput, szPrefix)
	return tbOutput
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

function lzwDecode(tbCode, tbChar)
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
					tbToken[szPrefix .. tbDeCodeToken[tonumber(szCode)][1]] = nTokenCode
					tbDeCodeToken[nTokenCode] = { szPrefix, tbDeCodeToken[tonumber(szCode)][1] }
					nTokenCode = nTokenCode + 1
					--前缀放入输出流
					szSource = lzwDecodeToSource(szSource, tbDeCodeToken, szPrefix)
				else
					if tbChar[szPrefix] then
						tbToken[szPrefix .. szPrefix] = nTokenCode
						tbDeCodeToken[nTokenCode] = { szPrefix, szPrefix }
					else
						tbToken[szPrefix .. tbDeCodeToken[tonumber(szPrefix)][1]] = nTokenCode
						tbDeCodeToken[nTokenCode] = { szPrefix, tbDeCodeToken[tonumber(szPrefix)][1] }
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

print(szSource)
local tbCode = lzwCode(szSource)
print(table.concat(tbCode, ","))
print(lzwDecode(tbCode, tbChar))




