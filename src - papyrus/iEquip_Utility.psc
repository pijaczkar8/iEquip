scriptname iEquip_Utility hidden

import StringUtil

int function CountEmpty(string[] Array) global native
function StringCopyTo(string[] Array, string[] Output, int StartIndex = 0, int EndIndex = -1, bool AllowEmpty = true) global native

string[] function IncreaseString(int by, string[] Array) global
	int len = Array.Length
	if by < 1 || (len+by > 128)
		return Array
	elseIf len == 0
		return StringArray(by)
	endIf
	string[] Output = StringArray(len+by)
	StringCopyTo(Array, Output)
	return Output
endFunction

string[] function PushString(string var, string[] Array) global
	int len = Array.Length
	if len >= 128
		return Array
	endIf
	string[] Output = IncreaseString(1, Array)
	Output[len] = var
	return Output
endFunction

string[] function ArgString(string args, string delimiter = ",") global
	string[] Output
	if args == ""
		return Output
	endIf
	int Next = StringUtil.Find(args, delimiter)
	if Next == -1
		return PushString(args, Output)
	endIf
	args += delimiter
	int Len = StringUtil.GetLength(args)
	int Count
	while Next != -1 && Next < Len
		Count += 1
		Next = StringUtil.Find(args, delimiter, (Next + 1))
	endWhile
	int i
	Output = StringArray(Count)
	int DelimLen = StringUtil.GetLength(delimiter)
	int Prev
	Next = StringUtil.Find(args, delimiter)
	while Next != -1 && Next < Len
		Output[i] = Trim(StringUtil.SubString(args, Prev, (Next - Prev)))
		Prev = Next + DelimLen
		Next = StringUtil.Find(args, delimiter, Prev)
		i += 1
	endWhile
	return Output
endFunction

string function Trim(string var) global
	if StringUtil.GetNthChar(var, 0) == " "
		return StringUtil.SubString(var, 1)
	endIf
	return var
endFunction

string[] function StringArray(int size) global
	if size < 8
		if size == 0
			string[] Empty
			return Empty
		elseIf size == 1
			return new string[1]
		elseIf size == 2
			return new string[2]
		elseIf size == 3
			return new string[3]
		elseIf size == 4
			return new string[4]
		elseIf size == 5
			return new string[5]
		elseIf size == 6
			return new string[6]
		else
			return new string[7]
		endIf
	elseIf size < 16
		if size == 8
			return new string[8]
		elseIf size == 9
			return new string[9]
		elseIf size == 10
			return new string[10]
		elseIf size == 11
			return new string[11]
		elseIf size == 12
			return new string[12]
		elseIf size == 13
			return new string[13]
		elseIf size == 14
			return new string[14]
		else
			return new string[15]
		endIf
	elseIf size < 24
		if size == 16
			return new string[16]
		elseIf size == 17
			return new string[17]
		elseIf size == 18
			return new string[18]
		elseIf size == 19
			return new string[19]
		elseIf size == 20
			return new string[20]
		elseIf size == 21
			return new string[21]
		elseIf size == 22
			return new string[22]
		else
			return new string[23]
		endIf
	elseIf size < 32
		if size == 24
			return new string[24]
		elseIf size == 25
			return new string[25]
		elseIf size == 26
			return new string[26]
		elseIf size == 27
			return new string[27]
		elseIf size == 28
			return new string[28]
		elseIf size == 29
			return new string[29]
		elseIf size == 30
			return new string[30]
		else
			return new string[31]
		endIf
	elseIf size < 40
		if size == 32
			return new string[32]
		elseIf size == 33
			return new string[33]
		elseIf size == 34
			return new string[34]
		elseIf size == 35
			return new string[35]
		elseIf size == 36
			return new string[36]
		elseIf size == 37
			return new string[37]
		elseIf size == 38
			return new string[38]
		else
			return new string[39]
		endIf
	elseIf size < 48
		if size == 40
			return new string[40]
		elseIf size == 41
			return new string[41]
		elseIf size == 42
			return new string[42]
		elseIf size == 43
			return new string[43]
		elseIf size == 44
			return new string[44]
		elseIf size == 45
			return new string[45]
		elseIf size == 46
			return new string[46]
		else
			return new string[47]
		endIf
	elseIf size < 56
		if size == 48
			return new string[48]
		elseIf size == 49
			return new string[49]
		elseIf size == 50
			return new string[50]
		elseIf size == 51
			return new string[51]
		elseIf size == 52
			return new string[52]
		elseIf size == 53
			return new string[53]
		elseIf size == 54
			return new string[54]
		else
			return new string[55]
		endif
	elseIf size < 64
		if size == 56
			return new string[56]
		elseIf size == 57
			return new string[57]
		elseIf size == 58
			return new string[58]
		elseIf size == 59
			return new string[59]
		elseIf size == 60
			return new string[60]
		elseIf size == 61
			return new string[61]
		elseIf size == 62
			return new string[62]
		else
			return new string[63]
		endIf
	elseIf size < 72
		if size == 64
			return new string[64]
		elseIf size == 65
			return new string[65]
		elseIf size == 66
			return new string[66]
		elseIf size == 67
			return new string[67]
		elseIf size == 68
			return new string[68]
		elseIf size == 69
			return new string[69]
		elseIf size == 70
			return new string[70]
		else
			return new string[71]
		endif
	elseIf size < 80
		if size == 72
			return new string[72]
		elseIf size == 73
			return new string[73]
		elseIf size == 74
			return new string[74]
		elseIf size == 75
			return new string[75]
		elseIf size == 76
			return new string[76]
		elseIf size == 77
			return new string[77]
		elseIf size == 78
			return new string[78]
		else
			return new string[79]
		endIf
	elseIf size < 88
		if size == 80
			return new string[80]
		elseIf size == 81
			return new string[81]
		elseIf size == 82
			return new string[82]
		elseIf size == 83
			return new string[83]
		elseIf size == 84
			return new string[84]
		elseIf size == 85
			return new string[85]
		elseIf size == 86
			return new string[86]
		else
			return new string[87]
		endif
	elseIf size < 96
		if size == 88
			return new string[88]
		elseIf size == 89
			return new string[89]
		elseIf size == 90
			return new string[90]
		elseIf size == 91
			return new string[91]
		elseIf size == 92
			return new string[92]
		elseIf size == 93
			return new string[93]
		elseIf size == 94
			return new string[94]
		else
			return new string[95]
		endIf
	elseIf size < 104
		if size == 96
			return new string[96]
		elseIf size == 97
			return new string[97]
		elseIf size == 98
			return new string[98]
		elseIf size == 99
			return new string[99]
		elseIf size == 100
			return new string[100]
		elseIf size == 101
			return new string[101]
		elseIf size == 102
			return new string[102]
		else
			return new string[103]
		endif
	elseIf size < 112
		if size == 104
			return new string[104]
		elseIf size == 105
			return new string[105]
		elseIf size == 106
			return new string[106]
		elseIf size == 107
			return new string[107]
		elseIf size == 108
			return new string[108]
		elseIf size == 109
			return new string[109]
		elseIf size == 110
			return new string[110]
		else
			return new string[111]
		endif
	elseIf size < 120
		if size == 112
			return new string[112]
		elseIf size == 113
			return new string[113]
		elseIf size == 114
			return new string[114]
		elseIf size == 115
			return new string[115]
		elseIf size == 116
			return new string[116]
		elseIf size == 117
			return new string[117]
		elseIf size == 118
			return new string[118]
		else
			return new string[119]
		endif
	else
		if size == 120
			return new string[120]
		elseIf size == 121
			return new string[121]
		elseIf size == 122
			return new string[122]
		elseIf size == 123
			return new string[123]
		elseIf size == 124
			return new string[124]
		elseIf size == 125
			return new string[125]
		elseIf size == 126
			return new string[126]
		elseIf size == 127
			return new string[127]
		else
			return new string[128]
		endIf
	endIf
endFunction

Bool function isSKSEActive(Float minimumVersion) global

	return skse.GetVersionRelease() as Float >= minimumVersion
endFunction

Bool function contains(String name, String stringToFind) global

	if stringutil.Find(name, stringToFind, 0) > -1
		return true
	endIf
	return false
endFunction

