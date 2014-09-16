local szSource = "ABABABABBBABABAACDACD"

function lzwCode(szSource)
	local szOutput = ""
	local szPrefix = ""
	local tbToken = {}
	local nTokenNum = 0
	for szChar in string.gmatch(szSource, "%a") do
		if szPrefix == "" then
			szPrefix = szChar
		else
			if tbToken[szPrefix .. szChar] then
				szPrefix = tbToken[szPrefix .. szChar]
			else
				tbToken[szPrefix .. szChar] = nTokenNum
				nTokenNum = nTokenNum + 1
				szOutput = szOutput .. szPrefix
				szPrefix = szChar
			end
		end
	end
	return szOutput
end

print(szSource)
print(lzwCode(szSource))



