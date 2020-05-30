#NoEnv

API_ERROR_NONE 								:= 0
API_ERROR_SNAPSHOT_FAILED 					:= 1
API_ERROR_SAMP_NOT_FOUND 					:= 2
API_ERROR_REMOTE_MEMORY_ALLOCATION_FAILED 	:= 3
API_ERROR_WRITEPROCESSMEMORY_FAILED 		:= 4
API_ERROR_GETPROCADDRESS_FAILED 			:= 5
API_ERROR_REMOTETHREAD_FAILED 				:= 6
API_ERROR_INVALID_GTA_HANDLE				:= 7
API_ERROR_PIPE_DOESNT_RESPOND 				:= 8
API_ERROR_STRING_TOO_LONG					:= 9


PATH_API := RelToAbs(A_ScriptDir, "bin\overlay.dll")

dllModule := DllCall("LoadLibrary", Str, PATH_API)
if(dllModule == -1 || dllModule == 0)
{
	MsgBox, 16, API - Fehler, Die overlay.dll konnte nicht gefunden werden.`nDer Keybinder wird nun beendet.`n`nUm den Fehler zu beheben, versuche die All in One Runtimes von hier zu installieren: http://bit.ly/AiOR
	ExitApp
}

Init_func 				:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_Init")
SetParam_func 			:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_SetParam")
ReadMemory_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ReadMemory")
WriteMemory_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_WriteMemory")
GetBasePointer_func 	:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_GetBasePointer")
GetCommandLine_func 	:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_GetCommandLine")
GetLastError_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_GetLastError")
SetLastError_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_SetLastError")

TextCreate_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextCreate")
TextDestroy_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextDestroy")
TextSetShadow_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextSetShadow")
TextSetShown_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextSetShown")
TextSetColor_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextSetColor")
TextSetPos_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextSetPos")
TextSetString_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextSetString")
TextUpdate_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_TextUpdate")

BoxCreate_func 			:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxCreate")
BoxDestroy_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxDestroy")
BoxSetShown_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetShown")
BoxSetBorder_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetBorder")
BoxSetBorderColor_func 	:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetBorderColor")
BoxSetColor_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetColor")
BoxSetHeight_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetHeight")
BoxSetPos_func			:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetPos")
BoxSetWidth_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_BoxSetWidth")

LineCreate_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineCreate")
LineDestroy_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineDestroy")
LineSetShown_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineSetShown")
LineSetColor_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineSetColor")
LineSetWidth_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineSetWidth")
LineSetPos_func			:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_LineSetPos")

ImageCreate_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageCreate")
ImageDestroy_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageDestroy")
ImageSetShown_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageSetShown")
ImageSetAlign_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageSetAlign")
ImageSetPos_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageSetPos")
ImageSetRotation_func	:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ImageSetRotation")

DestroyAllVisual_func	:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_DestroyAllVisual")
ShowAllVisual_func		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_ShowAllVisual")
HideAllVisual_func 		:= DllCall("GetProcAddress", UInt, dllModule, Str, "API_HideAllVisual")

Init()
{
	global Init_func
	res := DllCall(Init_func)
	return res
}

SetParam(str_Name, str_Value)
{
	global SetParam_func
	res := DllCall(SetParam_func, Str, str_Name, Str, str_Value)
	return res
}

ReadMemory(addr, size, ByRef data)
{
	global ReadMemory_func
	VarSetCapacity(data,size)
	res := DllCall(ReadMemory_func, UInt, addr, UInt, size, StrP, data)
	return res
}

GetBasePointer(dll)
{
	global GetBasePointer_func
	res :=DllCall(GetBasePointer_func, Str, dll)
	return res
}

GetCommandLine(ByRef line)
{
	global GetCommandLine_func
	VarSetCapacity(line,512,0)
	res := DllCall(GetCommandLine_func, StrP, line)
	return res
}

GetLastError()
{
	global GetLastError_func
	res:=DllCall(GetLastError_func)
	return res
}

SetLastError(error)
{
	global SetLastError_func
	res := DllCall(SetLastError_func, Int, error)
	return res
}

TextCreate(Font, fontsize, bold, italic, x, y, color, text, shadow, show)
{
	global TextCreate_func
	res := DllCall(TextCreate_func,Str,Font,Int,fontsize,UChar,bold,UChar,italic,Int,x,Int,y,UInt,color,Str,text,UChar,shadow,UChar,show)
	return res
}

TextDestroy(id)
{
	global TextDestroy_func
	res := DllCall(TextDestroy_func,Int,id)
	return res
}

TextSetShadow(id, shadow)
{
	global TextSetShadow_func
	res := DllCall(TextSetShadow_func,Int,id,UChar,shadow)
	return res
}

TextSetShown(id, show)
{
	global TextSetShown_func
	res := DllCall(TextSetShown_func,Int,id,UChar,show)
	return res
}

TextSetColor(id,color)
{
	global TextSetColor_func
	res := DllCall(TextSetColor_func,Int,id,UInt,color)
	return res
}

TextSetPos(id,x,y)
{
	global TextSetPos_func
	res := DllCall(TextSetPos_func,Int,id,Int,x,Int,y)
	return res
}

TextSetString(id,Text)
{
	global TextSetString_func
	res := DllCall(TextSetString_func,Int,id,Str,Text)
	return res
}

TextUpdate(id,Font,Fontsize,bold,italic)
{
	global TextUpdate_func
	res := DllCall(TextUpdate_func,Int,id,Str,Font,int,Fontsize,UChar,bold,UChar,italic)
	return res
}

BoxCreate(x,y,width,height,Color,show)
{
	global BoxCreate_func
	res := DllCall(BoxCreate_func,Int,x,Int,y,Int,width,Int,height,UInt,Color,UChar,show)
	return res
}

BoxDestroy(id)
{
	global BoxDestroy_func
	res := DllCall(BoxDestroy_func,Int,id)
	return res
}

BoxSetShown(id,Show)
{
	global BoxSetShown_func 
	res := DllCall(BoxSetShown_func,Int,id,UChar,Show)
	return res
}
	
BoxSetBorder(id,height,Show)
{
	global BoxSetBorder_func
	res := DllCall(BoxSetBorder_func,Int,id,Int,height,Int,Show)
	return res
}


BoxSetBorderColor(id,Color)
{
	global BoxSetBorderColor_func 
	res := DllCall(BoxSetBorderColor_func,Int,id,UInt,Color)
	return res
}

BoxSetColor(id,Color)
{
	global BoxSetColor_func
	res := DllCall(BoxSetColor_func,Int,id,UInt,Color)
	return res
}

BoxSetHeight(id,height)
{
	global BoxSetHeight_func
	res := DllCall(BoxSetHeight_func,Int,id,Int,height)
	return res
}

BoxSetPos(id,x,y)
{
	global BoxSetPos_func	
	res := DllCall(BoxSetPos_func,Int,id,Int,x,Int,y)
	return res
}

BoxSetWidth(id,width)
{
	global BoxSetWidth_func
	res := DllCall(BoxSetWidth_func,Int,id,Int,width)
	return res
}

LineCreate(x1,y1,x2,y2,width,color,show)
{
	global LineCreate_func
	res := DllCall(LineCreate_func,Int,x1,Int,y1,Int,x2,Int,y2,Int,Width,UInt,color,UChar,show)
	return res
}

LineDestroy(id)
{
	global LineDestroy_func
	res := DllCall(LineDestroy_func,Int,id)
	return res
}

LineSetShown(id,show)
{
	global LineSetShown_func
	res := DllCall(LineSetShown_func,Int,id,UChar,show)
	return res
}

LineSetColor(id,color)
{
	global LineSetColor_func
	res := DllCall(LineSetColor_func,Int,id,UInt,color)
	return res
}

LineSetWidth(id, width)
{
	global LineSetWidth_func
	res := DllCall(LineSetWidth_func,Int,id,Int,width)
	return res
}

LineSetPos(id,x1,y1,x2,y2)
{
	global LineSetPos_func
	res := DllCall(LineSetPos_func,Int,id,Int,x1,Int,y1,Int,x2,Int,y2)
	return res
}

ImageCreate(path, x, y, rotation, align, show)
{
	global ImageCreate_func
	res := DllCall(ImageCreate_func, Str, path, Int, x, Int, y, Int, rotation, Int, align, UChar, show)
	return res
}

ImageDestroy(id)
{
	global ImageDestroy_func
	res := DllCall(ImageDestroy_func,Int,id)
	return res
}

ImageSetShown(id,show)
{
	global ImageSetShown_func
	res := DllCall(ImageSetShown_func,Int,id,UChar,show)
	return res
}

ImageSetAlign(id,align)
{
	global ImageSetAlign_func
	res := DllCall(ImageSetAlign_func,Int,id,Int,align)
	return res
}

ImageSetPos(id, x, y)
{
	global ImageSetPos_func
	res := DllCall(ImageSetPos_func,Int,id,Int,x, Int, y)
	return res
}

ImageSetRotation(id, rotation)
{
	global ImageSetRotation_func
	res := DllCall(ImageSetRotation_func,Int,id,Int, rotation)
	return res
}

DestroyAllVisual()
{
	global DestroyAllVisual_func
	res := DllCall(DestroyAllVisual_func)
	return res 
}

ShowAllVisual()
{
	global ShowAllVisual_func
	res := DllCall(ShowAllVisual_func)
	return res
}

HideAllVisual()
{
	global HideAllVisual_func
	res := DllCall(HideAllVisual_func )
	return res
}

DecimalToHex(Var){
	SetFormat, IntegerFast, hex
	Dec2Hex += Var ; Sets Dec2Hex (which previously contained 11) to be 0xb.
	Dec2Hex .= "" ; Necessary due to the "fast" mode.
	SetFormat, IntegerFast, d
	StringTrimLeft, Dec2Hex, Dec2Hex, 2 ; removes 0x from the string
	StringUpper, Dec2Hex, Dec2Hex ; makes it all caps
	sDec2Hex .= Dec2Hex
	return sDec2Hex
}

RelToAbs(root, dir, s = "\") {
	pr := SubStr(root, 1, len := InStr(root, s, "", InStr(root, s . s) + 2) - 1)
		, root := SubStr(root, len + 1), sk := 0
	If InStr(root, s, "", 0) = StrLen(root)
		StringTrimRight, root, root, 1
	If InStr(dir, s, "", 0) = StrLen(dir)
		StringTrimRight, dir, dir, 1
	Loop, Parse, dir, %s%
	{
		If A_LoopField = ..
			StringLeft, root, root, InStr(root, s, "", 0) - 1
		Else If A_LoopField =
			root =
		Else If A_LoopField != .
			Continue
		StringReplace, dir, dir, %A_LoopField%%s%
	}
	Return, pr . root . s . dir
}
