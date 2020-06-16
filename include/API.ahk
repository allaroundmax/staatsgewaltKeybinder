
global SAMP_MAX_VEHICLES			:= 2000
global SAMP_PPOOL_VEHICLE_OFFSET	:= 0x1C
global VEHPOOL_iVehicleCount		:= 0x0
global VEHPOOL_iIsListed			:= 0x3074
global VEHPOOL_pGTA_Vehicle			:= 0x4FB4
global iRefreshVeh					:= 0
global oVehiclePoolData				:= []
global iUpdateTickVeh				:= 1000


getVehicleID() {
	if (!checkHandles())
		return -1
	
	vID := readMem(hGTA, readDWORD(hGTA, dwSAMP + 0x13C848) + 0x14, 2, "Short")
	if (ErrorLevel || !vID || vID > 2000)
		return -1
	
	return vID
}

GetVehicleModelIDByVPed(dwvPed) {
	checkHandles()
	id := readMem(hGTA, dwvPed + 0x22, 2, "Short")
	return id
}

getStreamedVehicles() {
	if (!checkHandles())
		return false
	
	if (iRefreshVeh + iUpdateTickVeh > A_TickCount)
		return true
	
	oVehiclePoolData := []
	iRefreshVeh := A_TickCount
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
	stVehiclePool := readDWORD(hGTA, dwAddress + 0x1C)
	vehicleoffset := 0
	
	Loop, % SAMP_MAX_VEHICLES
	{
		index := A_Index - 1, vehicleoffset += 4
		iIsListed := readDWORD(hGTA, stVehiclePool + VEHPOOL_iIsListed + index * 0x4)
		
		if (iIsListed == 0)
			continue
		
		ptrGTAVeh  := readDWORD(hGTA, stVehiclePool + VEHPOOL_pGTA_Vehicle + index * 0x4)
		
		if (ptrGTAVeh == 0)
			continue
		
		dwDriver := readDWORD(hGTA, ptrGTAVeh + 1120)
		occupied := dwDriver != 0 ? 1 : 0
		
		GTACARid := GetVehicleModelIDByVPed(ptrGTAVeh)
		sVehId := Round((vehicleoffset / 4) - 1)
		
		if (GTACARid > 400 && GTACARid < 611)
			oVehiclePoolData[index] := Object("PTR",  ptrGTAVeh, "SAMPID", sVehId, "CARNAME", ovehicleNames[GTACARid - 399], "OCCUPIED", occupied)
	}
	
	return true
}

getVehiclePointer(wID) {
	if (wID < 1 || wID > SAMP_MAX_VEHICLES || !checkHandles())
		return false
	
	var1 := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	
	var2 := readDWORD(hGTA, var1 + SAMP_PPOOLS_OFFSET)
	
	stVehiclePool := readDWORD(hGTA, var2 + SAMP_PPOOL_VEHICLE_OFFSET)
	
	if (stVehiclePool) {
		var3 := readDWORD(hGTA, stVehiclePool + 0x4FB4 + wID * 0x4)
		
		return var3
	} else {
		return false
	}
}

getVehicleNumberPlate() {
	if (!checkHandles())
		return ""
	
	dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
	
	if (ErrorLevel || dwVehPtr==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	vehpool := readDWORD(hGTA, dwAddress + 0x1C)
	
	if (ErrorLevel || vehpool==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	Loop, 2000
	{
		i := A_Index-1
		
		listed := readDWORD(hGTA, vehpool + 0x3074 + i*4)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return ""
		}
		
		if (listed==0)
			continue
		
		svehptr := readDWORD(hGTA, vehpool + 0x4FB4 + i*4)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return ""
		}
		
		if (svehptr==dwVehPtr) {
			sampveh := readDWORD(hGTA, vehpool + 0x1134 + i*4)
			
			if (ErrorLevel || sampveh==0) {
				ErrorLevel := ERROR_READ_MEMORY
				return ""
			}
			
			plate := readString(hGTA, sampveh + 0x93, 32)
			
			if (ErrorLevel) {
				ErrorLevel := ERROR_READ_MEMORY
				return ""
			}
			
			ErrorLevel := ERROR_OK
			return plate
		}
	}
	
	ErrorLevel := ERROR_OK
	return ""
}

getVehicleNumberPlateById(wID) {
	if (!checkHandles())
		return ""
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	vehpool := readDWORD(hGTA, dwAddress + 0x1C)
	
	if (ErrorLevel || vehpool==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	listed := readDWORD(hGTA, vehpool + 0x3074 + wID*4)
	
	if (ErrorLevel || listed==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	svehptr := readDWORD(hGTA, vehpool + 0x4FB4 + wID*4)
	
	if (ErrorLevel) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	sampveh := readDWORD(hGTA, vehpool + 0x1134 + wID*4)
	
	if (ErrorLevel || sampveh==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	plate := readString(hGTA, sampveh + 0x93, 32)
	
	if (ErrorLevel) {
		ErrorLevel := ERROR_READ_MEMORY
		return ""
	}
	
	ErrorLevel := ERROR_OK
	return plate
}

getVehiclePos(dwVehPtr = 0xBA18FC) {
	if (!checkHandles())
		return false
	
	if (dwVehPtr = ADDR_VEHICLE_PTR)
		dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
	
	dwAddress := readDWORD(hGTA, dwVehPtr + 0x14)
	
	if (!dwAddress)
		return false
	
	fX := readFloat(hGTA, dwAddress + 0x30)
	fY := readFloat(hGTA, dwAddress + 0x34)
	fZ := readFloat(hGTA, dwAddress + 0x38)
	
	vehicleID := readDWORD(hGTA, dwVehPtr + 0x22)
	
	return [fX, fY, fZ, vehicleID]
}

getVehicleRot(dwVehPtr = 0xBA18FC) {
	if (!checkHandles())
		return false
	
	if (dwVehPtr = ADDR_VEHICLE_PTR)
		dwVehPtr := readDWORD(hGTA, ADDR_VEHICLE_PTR)
	
	dwAddress := readDWORD(hGTA, dwVehPtr + 0x14)
	
	if (!dwAddress)
		return false
	
	rotX := readFloat(hGTA, dwAddress + 0x0)
	rotY := readFloat(hGTA, dwAddress + 0x4)
	rotZ := readFloat(hGTA, dwAddress + 0x8)
	
	vehicleID := readDWORD(hGTA, dwVehPtr + 0x22)
	
	return [rotX, rotY, rotZ, vehicleID]
}

getSeatIDs(errorMessage := true) {
	if (!checkHandles())
		return -1
	
	dw := readDWORD(hGTA, 0xBA18FC)
	
	if (dw) {
		driver := readDWORD(hGTA, dw + 0x460)
		psg1 := readDWORD(hGTA, dw + 0x464)
		psg2 := readDWORD(hGTA, dw + 0x468)
		psg3 := readDWORD(hGTA, dw + 0x46C)
		psg4 := readDWORD(hGTA, dw + 0x470)
		psg5 := readDWORD(hGTA, dw + 0x474)
		psg6 := readDWORD(hGTA, dw + 0x478)
		psg7 := readDWORD(hGTA, dw + 0x47C)
		psg8 := readDWORD(hGTA, dw + 0x480)
		psg9 := readDWORD(hGTA, dw + 0x484)
		
		return [getIdByPed(driver), getIdByPed(psg1), getIdByPed(psg2), getIdByPed(psg3), getIdByPed(psg4), getIdByPed(psg5), getIdByPed(psg6), getIdByPed(psg7), getIdByPed(psg8), getIdByPed(psg9)]
	} else if (errorMessage) {
		addChatMessage2(PREFIX . "Du befindest dich nicht in einem Fahrzeug!")
	}
	
	return false
}

GetVehicleColor_func := DllCall("GetProcAddress", UInt, hModule, Str, "API_GetVehicleColor")

GetVehicleColor(ByRef int_ColorFirst, ByRef int_ColorSecond) {
	global GetVehicleColor_func
	
	res := DllCall(GetVehicleColor_func, IntP, int_ColorFirst, IntP, int_ColorSecond)
	
	return res
}

createTextLabel(sText, dwColor, fX, fY, fZ, fDrawDistance := 50.0, bTestLOS := 0, wPlayerID := 0xFFFF, wVehicleID := 0xFFFF) {
	if (!checkHandles()) {
		return -1
	}
	
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0xC)
	
	Loop, 2048 {
		wID := A_Index - 1
	
		if (!readDWORD(hGTA, dwAddress + 0xE800 + wID * 4)) {
			return callWithParams2(hGTA, dwSAMP + 0x11C0, [["i", dwAddress], ["i", wID], ["s", sText], ["i", dwColor], ["f", fX], ["f", fY], ["f", fZ]
				, ["f", fDrawDistance], ["i", bTestLOS], ["i", wPlayerID], ["i", wVehicleID]], false, true) ? wID : -1
		}
	}
	
	return -1
}

updateTextLabel(wID, sText, dwColor) {
	if (wID < 0 || wID > 2047 || !checkHandles()) {
		return false
	}
	
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0xC)
	fX := readFloat(hGTA, dwAddress + wID * 0x1D + 0x8)
	fY := readFloat(hGTA, dwAddress + wID * 0x1D + 0xC)
	fZ := readFloat(hGTA, dwAddress + wID * 0x1D + 0x10)
	fDrawDistance := readFloat(hGTA, dwAddress + wID * 0x1D + 0x14)
	bTestLOS := readMem(hGTA, dwAddress + wID * 0x1D + 0x18, 1, "Byte")
	wPlayerID := readMem(hGTA, dwAddress + wID * 0x1D + 0x19, 2, "UShort")
	wVehicleID := readMem(hGTA, dwAddress + wID * 0x1D + 0x1B, 2, "UShort")
	
	return callWithParams2(hGTA, dwSAMP + 0x11C0, [["i", dwAddress], ["i", wID], ["s", sText], ["i", dwColor], ["f", fX], ["f", fY], ["f", fZ], ["f", fDrawDistance], ["i", bTestLOS], ["i", wPlayerID], ["i", wVehicleID]], false, true)
}

deleteTextLabel(ByRef wID) {
	if (!checkHandles()) {
		return false
	}
	
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0xC)
	if (callWithParams2(hGTA, dwSAMP + 0x12D0, [["i", dwAddress], ["i", wID]], false, true)) {
		wID := -1
		return true
	}
	
	return false
}



global SAMP_3DTEXT					:= 0x12C7BC

getLabelText() {
	if (!checkHandles()) {
		return -1
	}
	
	ADDR_3DText := readDWORD(hGTA, dwSAMP + SAMP_3DTEXT)
	TEXT_3DTEXT := readString(hGTA, ADDR_3DText, 512)
	
	return TEXT_3DTEXT
}

global iRefreshTL := 0
global oTextLabelData := ""
global iUpdateTickTL := 1000

updateTextLabelData() {
	if (!checkHandles())
		return 0
	
	if (iRefreshTL+iUpdateTickTL > A_TickCount)
		return 1
	
	oTextLabelData := []
	
	iRefreshTL := A_TickCount
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	dwTextLabels := readDWORD(hGTA, dwAddress + 12)
	
	if (ErrorLevel || dwTextDraws==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	Loop, % 2048
	{
		i := A_Index-1
		
		dwIsActive := readDWORD(hGTA, dwTextLabels + 59392 + i*4)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		if (dwIsActive==0)
			continue
		
		dwAddr := readDWORD(hGTA, dwTextLabels + i*29)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		if (dwAddr==0)
			continue
		
		sText := readString(hGTA, dwAddr, 256)
		
		if (ErrorLevel) {
				ErrorLevel := ERROR_READ_MEMORY
				return 0
		}
		
		fX := readFloat(hGTA, dwTextLabels + i*29 +8)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		fY := readFloat(hGTA, dwTextLabels + i*29 +12)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		fZ := readFloat(hGTA, dwTextLabels + i*29 +16)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		wPlayerID := readMem(hGTA, dwTextLabels + i * 0x1D + 0x19, 2, "UShort")
		wVehicleID := readMem(hGTA, dwTextLabels + i * 0x1D + 0x1B, 2, "UShort")
		
		oTextLabelData[i] := Object("TEXT", sText, "XPOS", fX , "YPOS", fY , "ZPOS", fZ, "PLAYERID", wPlayerID, "VEHICLEID", wVehicleID)
	}
	
	ErrorLevel := ERROR_OK
	return 1
}

countLabels() {
	if (!updateTextLabelData())
		return -1
	
	j := 0
	
	For i, o in oTextLabelData
	{
		j += 1
	}
	
	return j
}

printLabels() {
	if (!updateTextLabelData())
		return
	
	For i, o in oTextLabelData
	{
		addChatMessage2("ID: " . i . ", x:" . o.XPOS . ", y:" . o.YPOS . ", z:" . o.ZPOS . ", player: " . o.PLAYERID . ", vehicle: " . o.VEHICLEID)
		addChatMessage2("{FFFFFF}" . o.TEXT)
	}
}

; ------------------- ;
; TextDraw-Funktionen ;
; ------------------- ;
createTextDraw(sString, fX, fY, dwLetterColor := 0xFFFFFFFF, bFont := 3, fLetterWidth := 0.4, fLetterHeight := 1, bShadowSize := 0, bOutline := 1
	, dwShadowColor := 0xFF000000, bBox := 0, dwBoxColor := 0xFFFFFFFF, fBoxSizeX := 0.0, fBoxSizeY := 0.0, bLeft := 0, bRight := 0, bCenter := 1
	, bProportional := 1, wModel := 0, fXRot := 0.0, fYRot := 0.0, fZRot := 0.0, fZoom := 1.0, wColor1 := 0xFFFF, wColor2 := 0xFFFF) {
	if (StrLen(sString) > 800 || bFont > 5 || !checkHandles())
		return -1
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0x10)
	Loop, 2048 {
		wID := A_Index - 1
		if (!readDWORD(hGTA, dwAddress + wID * 4)) {
			VarSetCapacity(struct, 63, 0)
			NumPut((bBox ? 1 : 0) + (bLeft ? 2 : 0) + (bRight ? 4 : 0) + (bCenter ? 8 : 0) + (bProportional ? 16 : 0), &struct, 0, "Byte")
			NumPut(fLetterWidth, &struct, 1, "Float")
			NumPut(fLetterHeight, &struct, 5, "Float")
			NumPut(dwLetterColor, &struct, 9, "Int")
			NumPut(fBoxSizeX, &struct, 0xD, "Float")
			NumPut(fBoxSizeY, &struct, 0x11, "Float")
			NumPut(dwBoxColor, &struct, 0x15, "Int")
			NumPut(bShadowSize, &struct, 0x19, "Byte")
			NumPut(bOutline, &struct, 0x1A, "Byte")
			NumPut(dwShadowColor, &struct, 0x1B, "Int")
			NumPut(bFont, &struct, 0x1F, "Byte")
			NumPut(1, &struct, 0x20, "Byte")  ; should be 0/1 - TextDrawSelectable ?
			NumPut(fX, &struct, 0x21, "Float")
			NumPut(fY, &struct, 0x25, "Float")
			NumPut(wModel, &struct, 0x29, "Short")
			NumPut(fXRot, &struct, 0x2B, "Float")
			NumPut(fYRot, &struct, 0x2F, "Float")
			NumPut(fZRot, &struct, 0x33, "Float")
			NumPut(fZoom, &struct, 0x37, "Float")
			NumPut(wColor1, &struct, 0x3B, "Short")
			NumPut(wColor2, &struct, 0x3D, "Short")
			writeRaw(hGTA, pParam5, &struct, 63)
			if (ErrorLevel)
				return -1
			return callWithParams2(hGTA, dwSAMP + 0x1AE20, [["i", dwAddress], ["i", wID], ["i", pParam5], ["s", sString]], false, true) ? wID : -1
		}
	}
	return -1
}

moveTextDraw(wID, xPos, yPos) {
	if (wID < 0 || wID > 2047 || !checkHandles())
		return false
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0x10) + wID * 4 + (4 * (SAMP_MAX_PLAYERTEXTDRAWS + SAMP_MAX_TEXTDRAWS)))
	return writeMemory(hGTA, dwAddress + 0x98B, xPos, 4, "Float") && writeMemory(hGTA, dwAddress + 0x98F, yPos, 4, "Float")
}

updateTextDraw(wID, sString) {
	if (wID < 0 || wID > 2047 || StrLen(sString) > 800 || !checkHandles())
		return false
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0x10)
	return writeString(hGTA, readDWORD(hGTA, dwAddress + wID * 4 + (4 * (SAMP_MAX_PLAYERTEXTDRAWS + SAMP_MAX_TEXTDRAWS))), sString)
}

deleteTextDraw(ByRef wID) {
	if (wID < 0 || wID > 2047 || !checkHandles())
		return false
	dwAddress := readDWORD(hGTA, readDWORD(hGTA, readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) + SAMP_PPOOLS_OFFSET) + 0x10)
	if (callWithParams2(hGTA, dwSAMP + 0x1AD00, [["i", dwAddress], ["i", wID]], false, true)) {
		wID := -1
		return true
	}
	return false
}

global TEXT_DRAW_POOL_OFFSET				:= 0x10
global SAMP_MAX_PLAYERTEXTDRAWS				:= 256
global SAMP_MAX_TEXTDRAWS					:= 2048
global iRefreshTD := 0
global iUpdateTickTD := 1000
global oTextDraws := []

updateTextDraws() {
	if (!checkHandles())
		return 0
	
	if (iRefreshTD + iUpdateTickTD > A_TickCount)
		return 1
	
	oTextDraws := []
	iRefreshTD := A_TickCount
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)
	
	if (ErrorLevel || !dwAddress) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	dwAddress := readDWORD(hGTA, dwAddress + SAMP_PPOOLS_OFFSET)
	
	if (ErrorLevel || !dwAddress) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	dwTextDraw := readDWORD(hGTA, dwAddress + TEXT_DRAW_POOL_OFFSET)
	
	if (ErrorLevel || !dwTextDraw) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	Loop, % SAMP_MAX_TEXTDRAWS ; Normal TextDraws
	{
		i := A_Index - 1
		dwIsActive := readDWORD(hGTA, dwTextDraw + i * 4)
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		if (!dwIsActive)
			continue
		
		dwAddr := readDWORD(hGTA, dwTextDraw + i * 4 + (4 * (SAMP_MAX_PLAYERTEXTDRAWS + SAMP_MAX_TEXTDRAWS)))
		
		if (ErrorLevel) {
			ErrorLevel := ERROR_READ_MEMORY
			return 0
		}
		
		if (!dwAddr)
			continue
		
		sText := readString(hGTA, dwAddr, 800)
		
		if (ErrorLevel) {
				ErrorLevel := ERROR_READ_MEMORY
				return 0
		}
		
		oTextDraws[i] := sText
	}
	
	ErrorLevel := ERROR_OK
	return 1
}

printTextDraws() {
	if (!updateTextDraws())
		return
	
	oReplace := ["~s~", "~r~", "~w~", "~h~", "~g~", "~y~", "~n~", "~b~", "  ", "   "]
	
	For i, o in oTextDraws
	{
		Loop % oReplace.MaxIndex() {
			o := StrReplace(o, oReplace[A_Index], " ")
		}
		
		addChatMessage2(o)
	}
	return
}

getTextDrawBySubstring(substring) {
	if (!updateTextDraws())
		return
	
	oReplace := ["~s~", "~r~", "~w~", "~h~", "~g~", "~y~", "~n~", "~b~", "  ", "   "]
	
	For i, o in oTextDraws
	{
		if (!InStr(o, substring))
			continue
		
		Loop % oReplace.MaxIndex()
			o := StrReplace(o, oReplace[A_Index], " ")
		
		return o
	}
}

; ---------------- ;
; Relog-Funktionen ;
; ---------------- ;
restartGameEx() {
	if (!checkHandles())
		return -1
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) ;g_SAMP
	
	if (ErrorLevel || dwAddress == 0) {
		ErrorLevel := ERROR_READ_MEMORY
		return -1
	}
	
	dwFunc := dwSAMP + 0xA060
	
	VarSetCapacity(injectData, 11, 0) ;mov, call, retn
	
	NumPut(0xB9, injectData, 0, "UChar")		; mov ecx	0+1
	NumPut(dwAddress, injectData, 1, "UInt")	; 1+4
	NumPut(0xE8, injectData, 5, "UChar")		; call	5+1
	offset := dwFunc - (pInjectFunc + 10)
	NumPut(offset, injectData, 6, "Int")		; 6+4
	NumPut(0xC3, injectData, 10, "UChar")		; 10+1
	
	writeRaw(hGTA, pInjectFunc, &injectData, 11)
	
	if (ErrorLevel)
		return false
	
	hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
	
	if (ErrorLevel)
		return false
	
	waitForSingleObject(hThread, 0xFFFFFFFF)
	return true
}

disconnectEx() {
	if (!checkHandles())
		return 0
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET) ; g_SAMP
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	dwAddress := readDWORD(hGTA, dwAddress + 0x3c9) ; pRakClientInterface
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	ecx := dwAddress		;this
	
	dwAddress := readDWORD(hGTA, dwAddress) ; vtable
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		return 0
	}
	
	VarSetCapacity(injectData, 24, 0) ;mov, call, retn
	
	NumPut(0xB9, injectData, 0, "UChar")	;mov ecx	0+1
	NumPut(ecx, injectData, 1, "UInt")		;1+4
	
	NumPut(0xB8, injectData, 5, "UChar")	;mov eax	5+1
	NumPut(dwAddress, injectData, 6, "UInt")			;6+4
	
	;NumPut(0x006A006A, injectData, 10, "UInt")  ; 2x push		10+4
	
	NumPut(0x68, injectData, 10, "UChar")		;10 + 1	;push style
	NumPut(0, injectData, 11, "UInt")		;11 + 4
	
	NumPut(0x68, injectData, 15, "UChar")		;15 + 1	;push style
	NumPut(500, injectData, 16, "UInt")	;16 + 4
	
	NumPut(0x50FF, injectData, 20, "UShort")			;20 + 2
	NumPut(0x08, injectData, 22, "UChar")			;22 + 1
	
	NumPut(0xC3, injectData, 23, "UChar")	;retn		23+1
	
	writeRaw(hGTA, pInjectFunc, &injectData, 24)
	
	if (ErrorLevel)
		return false
	
	hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
	
	if (ErrorLevel)
		return false
	
	waitForSingleObject(hThread, 0xFFFFFFFF)
	return true
}
 
setRestart() {
	VarSetCapacity(old, 4, 0)
	
	dwAddress := readDWORD(hGTA, dwSAMP + SAMP_INFO_OFFSET)		;g_SAMP
	
	if (ErrorLevel || dwAddress==0) {
		ErrorLevel := ERROR_READ_MEMORY
		
		return 0
	}
	
	NumPut(9,old,0,"Int")
	writeRaw(hGTA, dwAddress + 957, &old, 4)
}

restart() {
	restartGameEx()
	Sleep, 2000
	disconnectEx()
	Sleep, 2000
	setRestart()
}

; ------------------- ;
; Sonstige Funktionen ;
; ------------------- ;
addChatMessage2(text, color := 0xFFFFFFFF, timestamp := true) {
	return !checkHandles() ? false : callWithParams2(hGTA, dwSAMP + 0x64010, [["i", readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)], ["i", timestamp ? 4 : 2]
		, ["s", text], ["i", 0], ["i", color], ["i", 0]], false, true)
}

global SAMP_CHAT_OFF			:= 0x0152
global SAMP_CHAT_SIZE			:= 144

readChatLine(line, color = 0) {
	if (!checkHandles())
		return 0
	
	dwPTR := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
	chat := readString(hGTA, dwPTR + SAMP_CHAT_OFF + SIZE_SAMP_CHATMSG * (99 - line), SAMP_CHAT_SIZE)
	
	if (!color)
		chat := RegExReplace(chat, "\{[a-fA-F0-9]{6}\}")
	
	return chat
}

setChatLine(line, text) {
	if (!checkHandles())
		return 0
	
	dwPTR := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
	result := writeString(hGTA, dwPTR + SAMP_CHAT_OFF + SIZE_SAMP_CHATMSG * (99 - line), text)
	
	return result
}

/*
SetChatLine(line, string) {
	if (!checkHandles())
		return false
	
	dwPTR := readDWORD(hGTA, dwSAMP + ADDR_SAMP_CHATMSG_PTR)
	
	writeString(hGTA, dwPTR + 0x136 + 0xfc*(99-line) + 0x1c, string)
	
	return
}
*/

getKills() {
	if (!checkHandles()) {
		return false
	}
	
	pedLocal := readDWORD(hGTA, 0xB6F5F0)
	if (!pedLocal) {
		return false
	}
	
	peds := getPeds()
	if (!peds) {
		return false
	}
	
	data := []
	
	for index, object in peds {
		state := readMem(hGTA, object.PED + 0x530, 4, "UInt")
		
		if ((pedStates[object.PED] == 55 || pedStates[object.PED] == 54) == (state == 55 || state == 54)) {
			Continue
		}
		
		pedStates[object.PED] := state
		
		if (object.PED && !object.ISNPC && (state == 55 || state == 54)) {
			pedMurderer := readDWORD(hGTA, object.PED + 0x764)
			murderer := false
			
			for index2, object2 in peds
			{
				if (object2.PED == pedMurderer) {
					murderer := object2
					Break
				}
			}
			
			weapon := readMem(hGTA, object.PED + 0x760, 4, "UInt")
			skin := readMem(hGTA, object.PED + 0x22, 2, "UShort")
			
			if (!murderer) {
				data.Push({victim: object, weapon: weapon, skin: skin})
			} else {
				data.Push({victim: object, murderer: murderer, weapon: weapon, skin: skin})
			}
		}
	}
	
	return data
}

getPeds() {
	if (!checkHandles()) {
		return false
	}
	
	if (!updateScoreboardDataEx()) {
		return false
	}
	
	dwAddress := readDWORD(hGTA, dwSAMP + 0x21A0F8)
	dwAddress := readDWORD(hGTA, dwAddress + 0x3CD)
	dwAddress := readDWORD(hGTA, dwAddress + 0x18)
	data := []
	wID := readMem(hGTA, dwAddress + 0x4, 2, "UShort")
	dwPed := readDWORD(hGTA, 0xB6F5F0)
	
	if (readDWORD(hGTA, dwAddress + 0x1A) <= 16) {
		sName := readString(hGTA, dwAddress + 0xA, 16)
	} else {
		sName := readString(hGTA, readDWORD(hGTA, dwAddress + 0xA), 20)
	}
	
	data.Push({LOCAL: true, ID: wID, PED: dwPed, ISNPC: false, NAME: sName})
	
	Loop % 1000 {
		i := A_Index - 1
		dwRemotePlayer := readDWORD(hGTA, dwAddress + 0x2E + i*4)
		
		if (!dwRemotePlayer) {
			Continue
		}
		
		dwRemotePlayerData := readDWORD(hGTA, dwRemotePlayer)
		dwRemotePlayerData := readDWORD(hGTA, dwRemotePlayerData)
		dwPed := readDWORD(hGTA, dwRemotePlayerData + 0x2A4)
		
		if (!dwPed) {
			Continue
		}
		
		dwIsNPC := readDWORD(hGTA, dwRemotePlayer + 0x4)
		
		if (readMem(hGTA, dwRemotePlayer + 0x1C, 4, "Int") <= 16) {
			sName := readString(hGTA, dwRemotePlayer + 0xC, 16)
		} else {
			sName := readString(hGTA, readDWORD(hGTA, dwRemotePlayer + 0xC), 20)
		}
		
		data.Push({LOCAL: false, ID: i, PED: dwPed, ISNPC: dwIsNPC, NAME: sName})
	}
	
	return data
}

global GAMETEXT_1					:= 0xBAAD40
global GAMETEXT_2					:= 0xBAADC0
global GAMETEXT_3					:= 0xBAAE40
global GAMETEXT_4					:= 0xBAAEC0
global GAMETEXT_5					:= 0xBAABC0

getGameText(type = 1, length = 68) {
	if (!checkHandles())
		return ""
	
	if (type == 1) {
		text := readString(hGTA, GAMETEXT_1, length)
	} else if (type == 2) {
		text := readString(hGTA, GAMETEXT_2, length)
	} else if (type == 3) {
		text := readString(hGTA, GAMETEXT_3, length)
	} else if (type == 4) {
		text := readString(hGTA, GAMETEXT_4, length)
	} else if (type == 5) {
		text := readString(hGTA, GAMETEXT_5, length)
	}
	
	return text
}

getPlayerFPS() {
	if (!checkHandles())
		return -1
	
	fFPS := readFloat(hGTA, 0xB7CB50)
	
	if (ErrorLevel) {
		ErrorLevel := ERROR_READ_MEMORY
		return -1
	}
	
	ErrorLevel := ERROR_OK
	return Round(fFPS)
}

getFPS() {
	if (!checkHandles())
		return 0
	
	static timev := A_TickCount
	static val   := readDWORD(hGTA, 0xB7CB4C)
	
	temp := readDWORD(hGTA, 0xB7CB4C)
	ret := (temp-val)/(A_TickCount-timev)*1000
	timev := A_TickCount
	val := temp
	
	return Round(ret)
}

instruction := 0

fpsUnlock() {
	if (!checkHandles())
		return 0
	
	global instruction
	
	instruction := readMem(hGTA, dwSAMP + 0x9D9D0, 4, "UInt")
	
	return writeMemory(hGTA, dwSAMP + 0x9D9D0, 0x5051FF15, 4, "UChar")
}

fpsLock() {
	if (!checkHandles())
		return 0
	
	global instruction
	
	if (instruction) {
		return writeMemory(hGTA, dwSAMP + 0x9D9D0, instruction, 4, "UInt")
	} else {
		return false
	}
}

blockDialog() {
	if (!checkHandles()) {
		ErrorLevel := ERROR_INVALID_HANDLE
		return false
	}
	
	VarSetCapacity(injectBytecode, 7, 0)
	
	Loop, 7 {
		NumPut(0x90, injectBytecode, A_Index - 1, "UChar")
	}
	
	return writeRaw(hGTA, dwSAMP + 0x6C014, &injectBytecode, 7)
}

unblockDialog() {
	if (!checkHandles()) {
		ErrorLevel := ERROR_INVALID_HANDLE
		return false
	}
	
	bytecodes := [0xC7, 0x46, 0x28, 0x1, 0x0, 0x0, 0x0]
	
	VarSetCapacity(injectBytecode, 7, 0)
	
	for i, o in bytecodes
		NumPut(o, injectBytecode, i - 1, "UChar")
	
	return writeRaw(hGTA, dwSAMP + 0x6C014, &injectBytecode, 7)
}

DownloadBin(url, byref buf) {
	if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
		return 0
	
	c := s := 0
	
	if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "ptr", 0, "uint", 0, "uint", 0x80003000, "ptr", 0, "ptr")) {
		while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s>0) {
			VarSetCapacity(b, c+s, 0)
			
			if (c>0)
				DllCall("RtlMoveMemory", "ptr", &b, "ptr", &buf, "ptr", c)
			
			DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b+c, "uint", s, "uint*", r)
			
			c += r
			
			VarSetCapacity(buf, c, 0)
			
			if (c>0)
				DllCall("RtlMoveMemory", "ptr", &buf, "ptr", &b, "ptr", c)
		}
		
		DllCall("wininet\InternetCloseHandle", "ptr", f)
	}
	
	DllCall("wininet\InternetCloseHandle", "ptr", h)
	
	return c
}

DownloadToString(url, head, encoding = "utf-8") {
	static a := "AutoHotkey/" A_AhkVersion
	
	if (!DllCall("LoadLibrary", "str", "wininet") || !(h := DllCall("wininet\InternetOpen", "str", a, "uint", 1, "ptr", 0, "ptr", 0, "uint", 0, "ptr")))
		return 0

	c := s := 0, o := ""
	
	if (f := DllCall("wininet\InternetOpenUrl", "ptr", h, "str", url, "str", head, "int", -1, "uint", 0x80083000, "ptr", 0, "ptr")) {
		while (DllCall("wininet\InternetQueryDataAvailable", "ptr", f, "uint*", s, "uint", 0, "ptr", 0) && s > 0) {
			VarSetCapacity(b, s, 0)
			DllCall("wininet\InternetReadFile", "ptr", f, "ptr", &b, "uint", s, "uint*", r)
			o .= StrGet(&b, r >> (encoding = "utf-16" || encoding = "cp1200"), encoding)
		}
		
		DllCall("wininet\InternetCloseHandle", "ptr", f)
	}
	
	DllCall("wininet\InternetCloseHandle", "ptr", h)
	return o
}

URLDownloadToVar(url, showerror := false) {
	hObject := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	
	try {
		hObject.Open("GET", url)
		hObject.SetTimeouts(0, 2000, 2000, 2000)
		hObject.Send()
		
		data := hObject.ResponseText
	} catch e {
		if (showerror == true) {
			addChatMessage2(PREFIX . "Aktuell liegt ein Fehler in der Verbindung zum Server vor!")
		}
		
		return "ERROR_CONNECTION"
	}
	
	return data
}

Unzip(sZip, sUnz) {
	fso := ComObjCreate("Scripting.FileSystemObject")
	psh := ComObjCreate("Shell.Application")
	zippedItems := psh.Namespace( sZip ).items().count
	
	psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
	
	Loop {
		Sleep, 50
		
		unzippedItems := psh.Namespace( sUnz ).items().count
		
		IfEqual, zippedItems, %unzippedItems%
			break
	}
}

; by Frank_Dilauro
SetChatLineRed(count, red) {
	checkHandles()
	offset := 0x639C
	dwAdress := readMem(hGTA, dwSAMP + 0x21A0E4, 4, "int")
	
	Loop %count%
		offset := offset - 0xFC
	
	WriteMemory_(hGTA, dwAdress, red, "char", 1, offset)
}

; by Frank_Dilauro
SetChatLineGreen(count, green) {
	checkHandles()
	offset := 0x639B
	dwAdress := readMem(hGTA, dwSAMP + 0x21A0E4, 4, "int")
	
	Loop %count%
		offset := offset - 0xFC
	
	WriteMemory_(hGTA, dwAdress, green, "char", 1, offset)
}

SetChatLineBlue(count, blue) {
	
	checkHandles()
	
	offset := 0x639A
	dwAdress := readMem(hGTA, dwSAMP + 0x21A0E4, 4, "int")
	
	Loop %count%
		offset := offset - 0xFC
	
	WriteMemory_(hGTA, dwAdress, blue, "char", 1, offset)
}

WriteMemory_(hwnd, address, writevalue, datatype = "int", length = 4, offset = 0) {
    VarSetCapacity(finalvalue, length, 0)
    NumPut(writevalue, finalvalue, 0, datatype)
    return DllCall("WriteProcessMemory", "Uint", hwnd, "Uint", address + offset,"Uint",&finalvalue,"Uint",length,"Uint",0)
}

PlayerInput(info) {
	
	KeyWait, Enter
	Suspend, On
	
	SendInput, t^a{backspace}/%info%
	Input, value, V,{enter}{esc}
	SendInput, ^a{backspace}{esc}
	
	Suspend, Off
	KeyWait, Enter
	
	return value
}	

getFullName(name, showerror := false) {
	if name is number
	{
		name := getPlayerNameById(name)
		
		if (name == "") {
			if (showerror)
				addChatMessage2(PREFIX . "Der Spieler mit der ID " . SECCOL . name . " {FFFFFF}ist nicht auf dem Server!")
			return ""
		} else {
			return name
		}
	} else {
		name := getPlayerIdByName(name)
		
		if (name == -1) {
			if (showerror)
				addChatMessage2(PREFIX . "Der Spieler " . SECCOL . name . " {FFFFFF}ist nicht auf dem Server!")
			return ""
		} else {
			return getPlayerNameById(name)
		}
	}
}

sendClientMessage(message) {
	if (StrLen(message) > 144) {
		subMessage := SubStr(message, 1, 141)
		
		if (RegExMatch(subMessage, "(.+)({\S{6}})(\s*)$", message_)) {
			addChatMessage2(message_1 . "...")
			sendClientMessage(message_2 . "..." . message_3 . SubStr(message, 142))
		} else if (RegExMatch(subMessage, "(.+)({\S{0,6})$", message_)) {
			addChatMessage2(message_1 . "...")
			
			subMessage2 := SubStr(message, 142)
			
			if (RegExMatch(subMessage2, "^(\S{0,6}})(.+)", message2_)) {
				sendClientMessage(message_2 . message2_1 . "..." . message2_2)
			} else {
				sendClientMessage("..." . subMessage2)
			}
		} else {
			addChatMessage2(subMessage . "...")
			
			color := ""
			
			if (RegExMatch(subMessage, "(.*)({\S{6}})(.*)", message_)) {
				color := message_2
			}
			
			sendClientMessage(color . "..." . SubStr(message, 142))
		}
	} else {
		addChatMessage2(message)
	}
}

getWeaponName(id) {
	weapons := {0: "Fist", 1: "Brass Knuckles", 2: "Golf Club", 3: "Nightstick", 4: "Knife", 5: "Baseball Bat", 6: "Shovel", 7: "Pool Cue", 8: "Katana", 9: "Chainsaw", 10: "Purple Dildo", 11: "Dildo", 12: "Vibrator", 13: "Silver Vibrator", 14: "Flowers", 15: "Cane", 16: "Grenade", 17: "Tear Gas", 18: "Molotov Cocktail", 22: "9mm", 23: "Silenced 9mm", 24: "Desert Eagle", 25: "Shotgun", 26: "Sawnoff Shotgun", 27: "Combat Shotgun", 28: "Micro SMG/Uzi", 29: "MP5", 30: "AK-47", 31: "M4", 32: "Tec-9", 33: "Country Rifle", 34: "Sniper Rifle", 35: "RPG", 36: "HS Rocket", 37: "Flamethrower", 38: "Minigun", 39: "Satchel Charge", 40: "Detonator", 41: "Spraycan", 42: "Fire Extinguisher", 43: "Camera", 44: "Night Vis Goggles", 45: "Thermal Goggles", 46: "Parachute", 47: "Fake Pistol", 49: "Vehicle", 50: "Helicopter Blades", 51: "Explosion", 53: "Drowned", 54: "Splat", 255: "Suicide"}
	
	if (weapons[id]) {
		return weapons[id]
	}
	
	return "Unknown"
}

getAttacker(bReset := false) {	
	if (!checkHandles())
		return 0
	
	dwLocalPED := readDWORD(hGTA, 0xB6F5F0)
	dwAttacker := readDWORD(hGTA, dwLocalPED + 0x764)
	
	if (!dwAttacker) {
		return -1
	}
	
	for i, o in oScoreboardData {
		if (!o.PED || o.ISNPC || dwAttacker != o.PED) {
			continue
		}
		
		if (bReset) {
			writeMemory(hGTA, dwLocalPED + 0x764, 0, 4, "UInt")
		}
		
		return o.ID
	}
	
	return -1
}

getAttackWeapon(bReset := false) {
	
	if (!checkHandles()) {
		return 0
	}
	
	dwLocalPED := readDWORD(hGTA, ADDR_CPED_PTR)
	dwAttackGun := readDWORD(hGTA, dwLocalPED + 0x760)
	
	if (!dwAttackGun) {
		return -1
	}
	
	weapon := readMem(hGTA, dwLocalPED + 0x760, 4, "UInt")
	return weapon
}

isPlayerCrouch() {
    if (!checkHandles()) {
        return -1
	}
	
    if (!CPed := readDWORD(hGTA, 0xB6F5F0)) {
        return -1
	}
	
    state := readMem(hGTA, CPed + 0x46F, 1, "byte")
    if (state == 132) {
        return 1
	}
	
    if (state == 128) {
        return 0
	}
	
    return -1
}

numberFormat(input_var) {
	StringReplace, output, input_var,.,,All
	return output
}

formatNumber(_number) {
	StringReplace, _number, _number, -
	
	IfEqual, ErrorLevel, 0, SetEnv Sign, -
	
	Loop, Parse, _number, .
		if (A_Index = 1) {
			len := StrLen(A_LoopField)
			
			Loop, Parse, A_LoopField
			if (Mod(len-A_Index,3) = 0 and A_Index != len) {
				x .= A_LoopField "."
			} else {
				x .= A_LoopField
			}
		} else {
			Return Sign x "." A_LoopField
		}
	Return Sign x
}

formatTime(time) {
	hours := Floor(time / 60 / 60)
	minutes := Floor(time / 60) - hours * 60
	seconds := time - minutes * 60 - hours * 60 * 60
	
	time := ""
	
	if (hours > 0) {
		time .= hours . "h"
		
		if (minutes > 0) {
			time .= ", "
		} else if (seconds > 0) {
			time .= ", "
		}
	}
	
	if (minutes > 0) {
		time .= minutes . "min"
		
		if (seconds > 0) {
			time .= ", "
		}
	}
	
	if (seconds > 0 || (minutes == 0 && hours == 0)) {
		time .= seconds . "s"
	}
	
	return time
}

getDayTime() {
	FormatTime, time,, HH
	
	if (time >= 11 && time < 18) {
		return "Tag"
	} else if (time >= 18) {
		return "Abend"
	} else if (time >= 0 && time < 11) {
		return "Morgen"
	}
	
	return ""
}

getUnixTimestamp(time_orig) {
	StringLeft, now_year, time_orig, 4
	StringMid, now_month, time_orig, 5, 2
	StringMid, now_day, time_orig, 7, 2
	StringMid, now_hour, time_orig, 9, 2
	StringMid, now_min, time_orig, 11, 2
	StringRight, now_sec, time_orig, 2
	
	;Get year seconds
	year_sec := 31536000 * (now_year - 1970)
	
	;Determine how many leap days
	leap_days := (now_year - 1972) / 4 + 1
	
	Transform, leap_days, Floor, %leap_days%
	
	;Determine if date is in a leap year, and if the leap day has been yet
	this_leap := now_year/4
	
	Transform, this_leap_round, Floor, %this_leap%
	
	if (this_leap = this_leap_round) {
		if (now_month <= 2) {
			leap_days--   ;subtracts 1 because this year's leap day hasn't been yet
		}
	}
	leap_sec := leap_days * 86400
	
	;Determine fully completed months
	if (now_month == 01)
		month_sec = 0
	if (now_month == 02)
		month_sec = 2678400
	if (now_month == 03)
		month_sec = 5097600
	if (now_month == 04)
		month_sec = 7776000
	if (now_month == 05)
		month_sec = 10368000
	if (now_month == 06)
		month_sec = 13046400
	if (now_month == 07)
		month_sec = 15638400
	if (now_month == 08)
		month_sec = 18316800
	if (now_month == 09)
		month_sec = 20995200
	if (now_month == 10)
		month_sec = 23587200
	if (now_month == 11)
		month_sec = 26265600
	if (now_month == 12)
		month_sec = 28857600
	
	
	;Determine fully completed days
	day_sec := (now_day - 1) * 86400
	
	;Determine fully completed hours
	hour_sec := now_hour * 3600 ;don't subtract 1 because it starts at 0
	
	;Determine fully completed minutes
	min_sec := now_min * 60
	
	;Calculate total seconds
	date_sec := year_sec + month_sec + day_sec + leap_sec + hour_sec + min_sec + now_sec
	
	return date_sec
}

getDistanceBetween(posX, posY, posZ, _posX, _posY, _posZ, _posRadius) {
	X := posX -_posX
	Y := posY -_posY
	Z := posZ -_posZ
	if (((X < _posRadius) && (X > -_posRadius)) && ((Y < _posRadius) && (Y > -_posRadius)) && ((Z < _posRadius) && (Z > -_posRadius)))
		return TRUE
	return FALSE
}

getDistanceToPoint(posX, posY, posZ, _posX, _posY, _posZ) {
	return Sqrt((posX - _posX) ** 2 + (posY - _posY) ** 2 + (posZ - _posZ) ** 2)
}

IniRead(fileName, section, key, default := 0) {
	IniRead, var, %fileName%, %section%, %key%, %default%
	return var
}

getUserFriendlyHotkeyName(hk) {
	StringUpper, hk, hk
	
	hk := StrReplace(hk, "~", "")
	hk := StrReplace(hk, "+", "UMSCHALT+")
	hk := StrReplace(hk, "^", "STRG+")
	hk := StrReplace(hk, "!", "ALT+")
	hk := StrReplace(hk, ".", ". (Punkt)")
	hk := StrReplace(hk, ",", ", (Komma)")
	
	return hk
}

min(var1, var2) {
	return var1 < var2 ? var1 : var2
}

max(var1, var2) {
	return var1 > var2 ? var1 : var2
}

compareVersions(v1, v2) {
	v1Parts := StrSplit(v1, ".")
	v2Parts := StrSplit(v2, ".")
	
	i := 0
	length := max(v1Parts.Length(), v2Parts.Length())
	
	Loop, %length%
	{
		v1Part := i < v1Parts.Length() ? v1Parts[A_Index] : 0
		v2Part := i < v2Parts.Length() ? v2Parts[A_Index] : 0
		
		if (v1Part < v2Part)
			return -1
		
		if (v1Part > v2Part)
			return 1
		
		i++
	}
	
	return 0
}

callWithParams2(hProcess, dwFunc, aParams, bCleanupStack = true, bThisCall = false, bReturn = false, sDatatype = "Char") {
	if (!hProcess || !dwFunc)
		return false
	dataOffset := 0
	i := aParams.MaxIndex()
	bytesUsed := 0
	bytesMax := 5120
	dwLen := i * 5 + bCleanupStack * 3 + bReturn * 5 + 6
	VarSetCapacity(injectData, dwLen, 0)
	while (i > 0) {
		if (aParams[i][1] == "i" || aParams[i][1] == "p" || aParams[i][1] == "f")
			value := aParams[i][2]
		else if (aParams[i][1] == "s") {
			if (bytesMax - bytesUsed < StrLen(aParams[i][2]))
				return false
			value := pMemory + bytesUsed
			writeString(hProcess, value, aParams[i][2])
			bytesUsed += StrLen(aParams[i][2]) + 1
			if (ErrorLevel)
				return false
		}
		else
			return false
		NumPut((bThisCall && i == 1 ? 0xB9 : 0x68), injectData, dataOffset, "UChar")
		NumPut(value, injectData, ++dataOffset, aParams[i][1] == "f" ? "Float" : "Int")
		dataOffset += 4
		i--
	}
	offset := dwFunc - (pInjectFunc + dataOffset + 5)
	NumPut(0xE8, injectData, dataOffset, "UChar")
	NumPut(offset, injectData, ++dataOffset, "Int")
	dataOffset += 4
	if (bReturn) {
		NumPut(sDatatype = "Char" ? 0xA2 : 0xA3, injectData, dataOffset, "UChar")
		NumPut(pParam1, injectData, ++dataOffset, "UInt")
		dataOffset += 4 
	}
	if (bCleanupStack) {
		NumPut(0xC483, injectData, dataOffset, "UShort")
		dataOffset += 2
		NumPut((aParams.MaxIndex() - bThisCall) * 4, injectData, dataOffset, "UChar")
		dataOffset++
	}
	NumPut(0xC3, injectData, dataOffset, "UChar")
	writeRaw(hGTA, pInjectFunc, &injectData, dwLen)
	if (ErrorLevel)
		return false
	hThread := createRemoteThread(hGTA, 0, 0, pInjectFunc, 0, 0, 0)
	if (ErrorLevel)
		return false
	waitForSingleObject(hThread, 0xFFFFFFFF)
	closeProcess(hThread)
	if (bReturn)
		return readMem(hGTA, pParam1, 4, sDatatype)
	return true
}

Convert(sFileFr = "", sFileTo = "", nQuality = "") {
	
	If	sFileTo  =
		sFileTo := A_ScriptDir . "\screen.bmp"
	
	SplitPath, sFileTo, , sDirTo, sExtTo, sNameTo
	
	If Not	hGdiPlus := DllCall("LoadLibrary", "str", "gdiplus.dll")
		Return	sFileFr+0 ? SaveHBITMAPToFile(sFileFr, sDirTo . "\" . sNameTo . ".bmp") : ""
	
	VarSetCapacity(si, 16, 0), si := Chr(1)
	DllCall("gdiplus\GdiplusStartup", "UintP", pToken, "Uint", &si, "Uint", 0)
	
	If	!sFileFr
	{
		DllCall("OpenClipboard", "Uint", 0)
		
		If	 DllCall("IsClipboardFormatAvailable", "Uint", 2) && (hBM:=DllCall("GetClipboardData", "Uint", 2))
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", hBM, "Uint", 0, "UintP", pImage)
			DllCall("CloseClipboard")
		}
		
		Else If	sFileFr Is Integer
			DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Uint", sFileFr, "Uint", 0, "UintP", pImage)
		Else	DllCall("gdiplus\GdipLoadImageFromFile", "Uint", Unicode4Ansi(wFileFr,sFileFr), "UintP", pImage)
			DllCall("gdiplus\GdipGetImageEncodersSize", "UintP", nCount, "UintP", nSize)
		
		VarSetCapacity(ci,nSize,0)
		DllCall("gdiplus\GdipGetImageEncoders", "Uint", nCount, "Uint", nSize, "Uint", &ci)
		
		Loop, %	nCount
			If	InStr(Ansi4Unicode(NumGet(ci,76*(A_Index-1)+44)), "." . sExtTo) {
				pCodec := &ci+76*(A_Index-1)
				Break
			}
			
		If	InStr(".JPG.JPEG.JPE.JFIF", "." . sExtTo) && nQuality<>"" && pImage && pCodec
		{
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "Uint", pImage, "Uint", pCodec, "UintP", nSize)
			VarSetCapacity(pi,nSize,0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "Uint", pImage, "Uint", pCodec, "Uint", nSize, "Uint", &pi)
			
			Loop, %	NumGet(pi)
				If	NumGet(pi,28*(A_Index-1)+20)=1 && NumGet(pi,28*(A_Index-1)+24)=6
				{
					pParam := &pi+28*(A_Index-1)
					NumPut(nQuality,NumGet(NumPut(4,NumPut(1,pParam+0)+20)))
					Break
				}
		}
		
		If	pImage
		pCodec	? DllCall("gdiplus\GdipSaveImageToFile", "Uint", pImage, "Uint", Unicode4Ansi(wFileTo,sFileTo), "Uint", pCodec, "Uint", pParam) : DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Uint", pImage, "UintP", hBitmap, "Uint", 0) . SetClipboardData(hBitmap), DllCall("gdiplus\GdipDisposeImage", "Uint", pImage)
		DllCall("gdiplus\GdiplusShutdown" , "Uint", pToken)
		DllCall("FreeLibrary", "Uint", hGdiPlus)
}

SaveHBITMAPToFile(hBitmap, sFile) {
	DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
	hFile:=	DllCall("CreateFile", "Uint", &sFile, "Uint", 0x40000000, "Uint", 0, "Uint", 0, "Uint", 2, "Uint", 0, "Uint", 0)
	DllCall("WriteFile", "Uint", hFile, "int64P", 0x4D42|14+40+NumGet(oi,44)<<16, "Uint", 6, "UintP", 0, "Uint", 0)
	DllCall("WriteFile", "Uint", hFile, "int64P", 54<<32, "Uint", 8, "UintP", 0, "Uint", 0)
	DllCall("WriteFile", "Uint", hFile, "Uint", &oi+24, "Uint", 40, "UintP", 0, "Uint", 0)
	DllCall("WriteFile", "Uint", hFile, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44), "UintP", 0, "Uint", 0)
	DllCall("CloseHandle", "Uint", hFile)
}

Unicode4Ansi(ByRef wString, sString) {
	nSize := DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2)
	DllCall("MultiByteToWideChar", "Uint", 0, "Uint", 0, "Uint", &sString, "int", -1, "Uint", &wString, "int", nSize)
	Return	&wString
}

Ansi4Unicode(pString) {
	nSize := DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "Uint", 0, "int",  0, "Uint", 0, "Uint", 0)
	VarSetCapacity(sString, nSize)
	DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "Uint", pString, "int", -1, "str", sString, "int", nSize, "Uint", 0, "Uint", 0)
	Return	sString
}

SetClipboardData(hBitmap) {
	DllCall("GetObject", "Uint", hBitmap, "int", VarSetCapacity(oi,84,0), "Uint", &oi)
	hDIB :=	DllCall("GlobalAlloc", "Uint", 2, "Uint", 40+NumGet(oi,44))
	pDIB :=	DllCall("GlobalLock", "Uint", hDIB)
	DllCall("RtlMoveMemory", "Uint", pDIB, "Uint", &oi+24, "Uint", 40)
	DllCall("RtlMoveMemory", "Uint", pDIB+40, "Uint", NumGet(oi,20), "Uint", NumGet(oi,44))
	DllCall("GlobalUnlock", "Uint", hDIB)
	DllCall("DeleteObject", "Uint", hBitmap)
	DllCall("OpenClipboard", "Uint", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "Uint", 8, "Uint", hDIB)
	DllCall("CloseClipboard")
}

convertData(unix, format) {
	
	timeZone := (A_Now - A_NowUTC) / 10000
	time += unix, s
	time += timeZone, h
	
	FormatTime, output, %time%, %format%
	return output
}
