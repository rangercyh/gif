local szSource = "ABABABABBBABABAACDACDADCABAAABAB"

function lzwCode(szSource)
	local tbOutput = {}
	local szPrefix = ""
	local tbToken = {}
	local nTokenNum = 6
	for szChar in string.gmatch(szSource, "%a") do
		if szPrefix == "" then
			szPrefix = szChar
		else
			if tbToken[szPrefix .. szChar] then
				szPrefix = tbToken[szPrefix .. szChar]
			else
				tbToken[szPrefix .. szChar] = nTokenNum
				nTokenNum = nTokenNum + 1
				table.insert(tbOutput, szPrefix)
				szPrefix = szChar
			end
		end
	end
	return tbOutput
end

print(szSource)
print(table.concat(lzwCode(szSource), ","))



