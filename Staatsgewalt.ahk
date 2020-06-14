#IfWinActive, GTA:SA:MP
#SingleInstance, force

#Persistent
#NoEnv

#Include, include/UDF.ahk
#Include, include/API.ahk
#Include, include/JSON.ahk


SetWorkingDir, %A_ScriptDir%
/*
if (!A_IsAdmin) {
	try {
		Run *RunAs "%A_ScriptFullPath%"
	} catch {
		MsgBox, 48, Administratorenrechte, Der Keybinder benötigt Administratorenrechte und wird nun beendet. Führe den Keybinder als Administrator aus!, 5
		ExitApp
	}
}
*/

IfExist update.bat
{
	FileDelete update.bat
}

IfNotExist, bin
{
	FileCreateDir, bin	
}

IfNotExist, bin/overlay.dll
{
	URLDownloadToFile, https://staatsgewalt.jameschans.de/keybinder/download/bin/overlay.dll, bin/overlay.dll
}

#Include, include/Overlay.ahk

global projectName 			:= "Staatsgewalt"
global fullProjectName 		:= "Staatsgewalt"

global version 				:= "4.2.1"
global keybinderStart 		:= 0
global rank					:= 0
global userFraction			:= 1
global baseURL 				:= "https://staatsgewalt.jameschans.de/keybinder/"

global cwhite				:= "{FFFFFF}"
global cblue				:= "{2090B3}"
global cgrey				:= "{BDBDBD}"
global cred					:= "{CC0000}"
global cwanted				:= "{FF4000}"
global cgreen				:= "{00962B}"
global cyellow				:= "{FFEE00}"
global corange				:= "{FF8100}"

IfNotExist, ini
	FileCreateDir, ini

IfExist, Hotkeys.ini
	FileMove, Hotkeys.ini, ini/Hotkeys.ini

IfExist, Login.ini
	FileMove, Login.ini, ini/Login.ini

IfExist, Stats.ini
	FileMove, Stats.ini, ini/Stats.ini

IfExist, Settings.ini
	FileMove, Settings.ini, ini/Settings.ini

IfExist, Frags.ini
	FileMove, Frags.ini, ini/Frags.ini

IniRead, username, ini/Login.ini, login, username, %A_Space%
IniRead, password, ini/Login.ini, login, password, %A_Space%	

if (username != "" && password != "") {
	Sleep, 100

	loginResult := URLDownloadToVar(baseURL . "api/keybinder.php?type=login&username=" . username . "&password=" . password . "&version=" . version . "&project=" . projectName)

	FormatTime, time, , dd.MM.yyyy HH:mm:ss

	if (loginResult == "true") {
		Goto, Start
	} else if (loginResult == "false") {
		MsgBox, 16, Account deaktiviert, Dein Account wurde deaktiviert, bitte wende dich an deinen Leader / Administrator.
		ExitApp
	} else {
		MsgBox, 16, Falsche Accountdaten, Der Account konnte nicht gefunden werden.`nBitte neue Daten eingeben.
		Goto, LoginGUI
	}
} else {
	Goto, LoginGUI
}
return

LoginGUI:
{
	Gui, Add, Text, x12 y9 w530 h60 +BackgroundTrans +Center, Staatsgewalt - Login
	Gui, Add, Text, x12 y49 w100 h20 +BackgroundTrans, Benutzername
	Gui, Add, Text, x12 y79 w100 h20 +BackgroundTrans, Passwort

	if (username) {
		Gui, Add, Edit, x112 y49 w180 h20 vusername, %username%
	} else {
		Gui, Add, Edit, x112 y49 w180 h20 vusername,
	}
	
	if (password) {
		Gui, Add, Edit, x112 y79 w180 h20 +Password vpassword, %password%
	} else {
		Gui, Add, Edit, x112 y79 w180 h20 +Password vpassword,
	}
	Gui, Add, Button, x442 y189 w100 h30 gdoLogin, Login
	Gui, Show, w564 h236, Login
}
return

doLogin:
{
	GuiControlGet, username
	GuiControlGet, password
	
	IniWrite, %username%, ini/Login.ini, login, username
	IniWrite, %password%, ini/Login.ini, login, password
	
	Reload
}
return

Start:
{
	keybinderStart := A_Hour . ":" . A_Min . ":" . A_Sec
	
	newversion :=  URLDownloadToVar(baseURL . "api/getsetting?key=version")
	rank := URLDownloadToVar(baseURL . "api/getUserInfo?username=" . username . "&info=rank")
	userFraction := URLDownloadToVar(baseURL . "api/getUserInfo?username=" . username . "&info=fraction")
	
	fraction := getFractionName()
	
	if (newversion > version) {		
		MsgBox, 68, %projectName% Keybinder - Version %version%, Es wurde eine neue Keybinderversion (Version %newversion%) veröffentlicht!`nMöchtest du diese nun herunterladen?`n`nÄnderungen sind im Forum im Thread!
		
		IfMsgBox, Yes
		{
			Progress, 25, Lädt neue Version herunter, Der Keybinder wird nun geupdated..., Update
			
			UrlDownloadToFile, %baseURL%download/version/%newversion%/%projectName%.exe, %projectName%.new.exe
			
			Progress, 75, Installiere Update, Der Keybinder wird nun geupdated..., Update
			
			Sleep, 500
			
			updateBat =
				(LTrim
					ping 127.0.0.1 -n 2 > nul
					Del "%projectName%.exe"
					Rename "%projectName%.new.exe" "%projectName%.exe"
					"%projectName%.exe"
				)
			
			FileAppend, %updateBat%, update.bat
		
			Sleep, 1000
			
			Run, update.bat, , hide
			
			Progress, 100, Abgeschlossen, Der Keybinder wird nun geupdated..., Update
			ExitApp
		}
	}
	
	IfNotExist, images
		FileCreateDir, images
	
	IfNotExist, images/overlay
		FileCreateDir, images/overlay
	
	IfNotExist, images/LogoSmallFBI.png
		URLDownloadToFile, %baseURL%download/images/LogoSmallFBI.png, images\LogoSmallFBI.png
	
	IfNotExist, images/LogoSmallLSPD.png
		URLDownloadToFile, %baseURL%download/images/LogoSmallLSPD.png, images\LogoSmallLSPD.png	
	
	IfNotExist, images/LogoSmallArmy.png
		URLDownloadToFile, %baseURL%download/images/LogoSmallArmy.png, images\LogoSmallArmy.png	
	
	IfNotExist, images/campfire.png
		URLDownloadToFile, %baseURL%download/bin/overlay/campfire.png, images\Overlay\campfire.png
	
	IfNotExist, images/canister.png
		URLDownloadToFile, %baseURL%download/bin/overlay/canister.png, images\Overlay\canister.png
	
	IfNotExist, images/firstaid.png
		URLDownloadToFile, %baseURL%download/bin/overlay/firstaid.png, images\Overlay\firstaid.png
	
	IfNotExist, images/fishCooked.png
		URLDownloadToFile, %baseURL%download/bin/overlay/fishCooked.png, images\Overlay\fishCooked.png
	
	IfNotExist, images/fishUncooked.png
		URLDownloadToFile, %baseURL%download/bin/overlay/fishUncooked.png, images\Overlay\fishUncooked.png
	
	IfNotExist, images/phoneOn.png
		URLDownloadToFile, %baseURL%download/bin/overlay/phoneOn.png, images\Overlay\phoneOn.png
		
	IfNotExist, images/phoneOff.png
		URLDownloadToFile, %baseURL%download/bin/overlay/phoneOff.png, images\Overlay\phoneOff.png
	
	IfNotExist, sounds
		FileCreateDir, sounds
	
	IfNotExist, sounds/bk.mp3
		URLDownloadToFile, %baseURL%download/sounds/bk.mp3, sounds\bk.mp3
		
	IfNotExist, sounds/call.mp3
		URLDownloadToFile, %baseURL%download/sounds/call.mp3, sounds\call.mp3
	
	IfNotExist, sounds/sms.mp3
		URLDownloadToFile, %baseURL%download/sounds/sms.mp3, sounds\sms.mp3
	
	IfNotExist, sounds/double.mp3
		URLDownloadToFile, %baseURL%download/sounds/double.mp3, sounds\double.mp3
		
	IfNotExist, sounds/triple.mp3
		URLDownloadToFile, %baseURL%download/sounds/triple.mp3, sounds\triple.mp3
		
	IfNotExist, sounds/quadra.mp3
		URLDownloadToFile, %baseURL%download/sounds/quadra.mp3, sounds\quadra.mp3
	
	IfNotExist, sounds/penta.mp3
		URLDownloadToFile, %baseURL%download/sounds/penta.mp3, sounds\penta.mp3
		
	IfNotExist, sounds/hexa.mp3
		URLDownloadToFile, %baseURL%download/sounds/hexa.mp3, sounds\hexa.mp3

	UnBlockChatInput()
	
	chatLogFile := FileOpen(A_MyDocuments . "\GTA San Andreas User Files\SAMP\chatlog.txt", "r")
	firstChatLogRun := true
	chatLogLines := []
	
	FormatTime, time, , dd.MM.yyyy HH:mm:ss
	
	IfNotExist, images
		FileCreateDir, images

	; Settings
	IniRead, autoLock, ini/Settings.ini, settings, autoLock, 0
	IniRead, autoEngine, ini/Settings.ini, settings, autoEngine, 0
	IniRead, autoFill, ini/Settings.ini, settings, autoFill, 0
	IniRead, autoLotto, ini/Settings.ini, settings, autoLotto, 0
	IniRead, antiSpam, ini/Settings.ini, settings, antiSpam, 0
	IniRead, autoUncuff, ini/Settings.ini, settings, autoUncuff, 0
	IniRead, autoFrisk, ini/Settings.ini, settings, autoFrisk, 0
	IniRead, autoTake, ini/Settings.ini, settings, autoTake, 0
	IniRead, autoWanted, ini/Settings.ini, settings, autoWanted, 0
	IniRead, autoCustoms, ini/Settings.ini, settings, autoCustoms, 0
	IniRead, autoLocal, ini/Settings.ini, settings, autoLocal, 0
	IniRead, autoUse, ini/Settings.ini, settings, autoUse, 0
	IniRead, fishMode, ini/Settings.ini, settings, fishMode, 0
	IniRead, autoHeal, ini/Settings.ini, settings, autoHeal, 0
	IniRead, autoDrugs, ini/Settings.ini, settings, autoDrugs, 0
	IniRead, admin, ini/Settings.ini, settings, admin, 0
	IniRead, autoCook, ini/Settings.ini, settings, autoCook, 0
	IniRead, autoEquip, ini/Settings.ini, settings, autoEquip, 0
	IniRead, autoGate, ini/Settings.ini, settings, autoGate, 0
	IniRead, autoExecute, ini/Settings.ini, settings, autoExecute, 0
	IniRead, autoFish, ini/Settings.ini, settings, autoFish, 0
	IniRead, taxes, ini/Settings.ini, settings, taxes, 1
	IniRead, max_kmh, ini/Settings.ini, settings, max_kmh, 0
	IniRead, lottoNumber, ini/Settings.ini, settings, lottoNumber, %A_Space%
	IniRead, department, ini/Settings.ini, settings, department, %A_Space%
	IniRead, primaryColor, ini/Settings.ini, settings, primaryColor, %A_Space%
	IniRead, secondaryColor, ini/Settings.ini, settings, secondaryColor, %A_Space%
	IniRead, ownprefix, ini/Settings.ini, settings, ownprefix, %A_Space%
	IniRead, killMessage, ini/Settings.ini, settings, killMessage, %A_Space%
	IniRead, deathMessage, ini/Settings.ini, settings, deathMessage, %A_Space%
	IniRead, killText, ini/Settings.ini, settings, killText, 0
	IniRead, deathText, ini/Settings.ini, settings, deathText, 0
	IniRead, overlay, ini/settings.ini, settings, overlay, 1
	
	if ((fraction != "" || fraction != " " || fraction != "ERROR") && (department == "" || department == " " || department == "ERROR")) {
		department := fraction
	}
	
	; Sounds
	IniRead, smsSound, ini/Settings.ini, sounds, smsSound, 0
	IniRead, callSound, ini/Settings.ini, sounds, callSound, 0
	IniRead, killSound, ini/Settings.ini, sounds, killSound, 0
	IniRead, deathSound, ini/Settings.ini, sounds, deathSound, 0
	IniRead, backupSound, ini/Settings.ini, sounds, backupSound, 0
	IniRead, emergencySound, ini/Settings.ini, sounds, emergencySound, 0
	IniRead, leagueSound, ini/Settings.ini, sounds, leagueSound, 0

	; Infos
	IniRead, damageInfo, ini/Settings.ini, infos, damageInfo, 0
	IniRead, paintInfo, ini/Settings.ini, infos, paintInfo, 0
	IniRead, wantedInfo, ini/Settings.ini, infos, wantedInfo, 0
	IniRead, paketInfo, ini/Settings.ini, infos, paketInfo, 0
	IniRead, laserInfo, ini/Settings.ini, infos, laserInfo, 0
	IniRead, memberInfo, ini/Settings.ini, infos, memberInfo, 0
	IniRead, spotifyPrivacy, ini/Settings.ini, infos, spotifyPrivacy, 0
	IniRead, spotifyPublic, ini/Settings.ini, infos, spotifyPublic, 0
	IniRead, refillInfo, ini/Settings.ini, infos, refillInfo, 0
	IniRead, taskInfo, ini/Settings.ini, infos, taskInfo, 0
	IniRead, escInfo, ini/Settings.ini, infos, escInfo, 0
	IniRead, afkInfo, ini/Settings.ini, infos, afkInfo, 0

	; Overlay
	IniRead, spotifyOv, ini/settings.ini, overlay, spotifyOv, 1
	IniRead, spotifyFont, ini/settings.ini, Overlay, spotifyFont, Arial
	IniRead, spotifySize, ini/settings.ini, Overlay, spotifySize, 9
	IniRead, spotifyBold, ini/settings.ini, Overlay, spotifyBold, true
	IniRead, spotifyItal, ini/settings.ini, Overlay, spotifyItal, false
	IniRead, spotifyXPos, ini/settings.ini, Overlay, spotifyXPos, 3
	IniRead, spotifyYPos, ini/settings.ini, Overlay, spotifyYPos, 586
	IniRead, spotifyColor, ini/settings.ini, Overlay, spotifyColor, FFFFFF	
	IniRead, spotifyColorOn, ini/settings.ini, Overlay, spotifyColorOn, 1
	IniRead, spotifySongColor, ini/settings.ini, Overlay, spotifySongColor, 00962B

	IniRead, cooldownOv, ini/settings.ini, overlay, cooldownOv, 1	
	IniRead, cooldownFont, ini/settings.ini, Overlay, cooldownFont, Arial
	IniRead, cooldownSize, ini/settings.ini, Overlay, cooldownSize, 9
	IniRead, cooldownBold, ini/settings.ini, Overlay, cooldownBold, true
	IniRead, cooldownItal, ini/settings.ini, Overlay, cooldownItal, false
	IniRead, cooldownXPos, ini/settings.ini, Overlay, cooldownXPos, 645
	IniRead, cooldownYPos, ini/settings.ini, Overlay, cooldownYPos, 474
	IniRead, cooldownColorOn, ini/settings.ini, Overlay, cooldownColorOn, true
	IniRead, cooldownColor, ini/settings.ini, Overlay, cooldownColor, FFA600	

	IniRead, pingOv, ini/settings.ini, overlay, pingOv, 1
	IniRead, pingFont, ini/settings.ini, Overlay, pingFont, Arial
	IniRead, pingSize, ini/settings.ini, Overlay, pingSize, 7
	IniRead, pingBold, ini/settings.ini, Overlay, pingBold, true
	IniRead, pingItal, ini/settings.ini, Overlay, pingItal, false
	IniRead, pingXPos, ini/settings.ini, Overlay, pingXPos, 695
	IniRead, pingYPos, ini/settings.ini, Overlay, pingYPos, 75
	IniRead, pingColor, ini/settings.ini, Overlay, pingColor, FFFFFFF	
	IniRead, pingColorOn, ini/settings.ini, Overlay, pingColorOn, true
	IniRead, pingAlertColorOn, ini/settings.ini, Overlay, pingAlertColorOn, true

	IniRead, infoPhone, ini/settings.ini, overlay, infoPhone, 1
	IniRead, infoFirstaid, ini/settings.ini, overlay, infoFirstaid, 1
	IniRead, infoCanister, ini/settings.ini, overlay, infoCanister, 1
	IniRead, infoCampfire, ini/settings.ini, overlay, infoCampfire, 1
	IniRead, infoDrugs, ini/settings.ini, overlay, infoDrugs, 1
	IniRead, infoFishCooked, ini/settings.ini, overlay, infoFishCooked, 1
	IniRead, infoFishUncooked, ini/settings.ini, overlay, infoFishUncooked, 1
	IniRead, infoOv, ini/settings.ini, overlay, infoOv, 1
	IniRead, infoPhoneX, ini/settings.ini, overlay, infoPhoneX, 26
	IniRead, infoPhoneY, ini/settings.ini, overlay, infoPhoneY, 460
	IniRead, infoFirstaidX, ini/settings.ini, overlay, infoFirstaidX, 193
	IniRead, infoFirstaidY, ini/settings.ini, overlay, infoFirstaidY, 558
	IniRead, infoCanisterX, ini/settings.ini, overlay, infoCanisterX, 296
	IniRead, infoCanisterY, ini/settings.ini, overlay, infoCanisterY, 518
	IniRead, infoCampfireX, ini/settings.ini, overlay, infoCampfireX, 223
	IniRead, infoCampfireY, ini/settings.ini, overlay, infoCampfireY, 558
	IniRead, infoDrugsX, ini/settings.ini, overlay, infoDrugsX, 253
	IniRead, infoDrugsY, ini/settings.ini, overlay, infoDrugsY, 558
	IniRead, infoFishCookedX, ini/settings.ini, overlay, infoFishCookedX, 765
	IniRead, infoFishCookedY, ini/settings.ini, overlay, infoFishCookedY, 350	
	IniRead, infoFishUncookedX, ini/settings.ini, overlay, infoFishUncookedX, 765
	IniRead, infoFishUncookedY, ini/settings.ini, overlay, infoFishUncookedY, 385

	IniRead, alertOv, ini/settings.ini, overlay, alertOv, 1
	IniRead, alertXPos, ini/settings.ini, overlay, alertXPos, 25
	IniRead, alertYPos, ini/settings.ini, overlay, alertYPos, 250
	IniRead, alertItal, ini/settings.ini, overlay, alertItal, false
	IniRead, alertFont, ini/settings.ini, overlay, alertFont, Arial
	IniRead, alertSize, ini/settings.ini, overlay, alertSize, 7
	IniRead, alertBold, ini/settings.ini, overlay, alertBold, true
	IniRead, alertColor, ini/settings.ini, overlay, alertColor, FFFFFF

	IniRead, partnerOv, ini/settings.ini, overlay, partnerOv, 1
	IniRead, partnerX, ini/settings.ini, overlay, partnerX, 660
	IniRead, partnerY, ini/settings.ini, overlay, partnerY, 250
	IniRead, partnerItal, ini/settings.ini, overlay, partnerItal, false
	IniRead, partnerFont, ini/settings.ini, overlay, partnerFont, Arial
	IniRead, partnerSize, ini/settings.ini, overlay, partnerSize, 8
	IniRead, partnerBold, ini/settings.ini, overlay, partnerBold, true
	IniRead, partnerColor, ini/settings.ini, overlay, partnerColor, 00962B

	IniRead, arrestLimitUnix, ini/Settings.ini, UnixTime, arrestLimitUnix, 0
	IniRead, commitmentUnix, ini/Settings.ini, UnixTime, commitmentUnix, 0
	IniRead, commitmentTime, ini/Settings.ini, UnixTime, commitmentTime, 0
	
	IniRead, drugs, ini/Settings.ini, Items, drugs, 0
	IniRead, firstaid, ini/Settings.ini, Items, firstaid, 0
	IniRead, canister, ini/Settings.ini, Items, canister, 0
	IniRead, campfire, ini/Settings.ini, Items, campfire, 0
	IniRead, mobilePhone, ini/Settings.ini, Items, mobilePhone, 0
	
	IniRead, fishcooldown, ini/Settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, ini/Settings.ini, Cooldown, pakcooldown, 0
	
	IniRead, job, ini/Settings.ini, job, job, %A_Space%
	IniRead, jobLine, ini/Settings.ini, job, jobLine, %A_Space%

	registeredHotkeys := Object()
	defaultHotkeysArray := Object()
	
	defaultHotkeysArray["atkWanteds"] 					:= "!Numpad1"
	defaultHotkeysArray["escapeWanteds"] 				:= "!Numpad2"
	defaultHotkeysArray["refusalWanteds"] 				:= "!Numpad3"
	defaultHotkeysArray["obstructionWanteds"] 			:= "!Numpad4"
	defaultHotkeysArray["possessionWanteds"] 			:= "!Numpad5"
	defaultHotkeysArray["drugConsumptionWanteds"] 		:= "!Numpad6"
	defaultHotkeysArray["escapeAidWanteds"] 			:= "!Numpad7"
	defaultHotkeysArray["tradeWanteds"] 				:= "!Numpad8"
	defaultHotkeysArray["unauthorizedEnterWanteds"] 	:= "!Numpad9"
	defaultHotkeysArray["customsEscapeWanteds"] 		:= "!Z"
	defaultHotkeysArray["vehicleTheftWanteds"] 			:= "!K"
	defaultHotkeysArray["insultingWanteds"] 			:= "!H"
	defaultHotkeysArray["useOfWeaponsWanteds"] 			:= "!I"
	defaultHotkeysArray["possessionOfWeaponsWanteds"] 	:= "!U"
	defaultHotkeysArray["briberyWanteds"] 				:= "!B"
	defaultHotkeysArray["escWanteds"] 					:= "!E"
	defaultHotkeysArray["kidnapWanteds"] 				:= "!G"
	defaultHotkeysArray["roadHazardPoints"] 			:= "~^Numpad1"
	defaultHotkeysArray["wrongSitePoints"] 				:= "~^Numpad2"
	defaultHotkeysArray["speedPoints"] 					:= "~^Numpad3"
	defaultHotkeysArray["offsitePoints"]		 		:= "~^Numpad5"
	defaultHotkeysArray["lightPoints"] 					:= "~^Numpad6"
	defaultHotkeysArray["noParkingPoints"] 				:= "~^Numpad7"
	defaultHotkeysArray["clearPoints"] 					:= "!-"
	defaultHotkeysArray["clearWanteds"] 				:= "~-"
	
	defaultHotkeysArray["motorSystem"]	 				:= "~1"
	defaultHotkeysArray["lock"] 						:= "~Y"
	defaultHotkeysArray["light"] 						:= "~L"
	defaultHotkeysArray["uclight"] 						:= "~B"
	defaultHotkeysArray["uca"] 							:= "~J"
	defaultHotkeysArray["tempomat"] 					:= "~^t"
	defaultHotkeysArray["repeat"]			 			:= "~ä"
	defaultHotkeysArray["thanks"] 						:= "~ü"
	defaultHotkeysArray["sorry"] 						:= "~+"
	defaultHotkeysArray["megaFollow"] 					:= "~Numpad0"
	defaultHotkeysArray["megaControl"] 					:= "~Numpad1"
	defaultHotkeysArray["megaStop"] 					:= "~Numpad2"
	defaultHotkeysArray["megaByName"] 					:= "~Numpad3"
	defaultHotkeysArray["megaGetOutOfCar"] 				:= "~Numpad4"
	defaultHotkeysArray["megaClear"] 					:= "~Numpad5"
	defaultHotkeysArray["megaWeapons"] 					:= "~Numpad6"
	defaultHotkeysArray["megaLeave"] 					:= "~Numpad9"
	defaultHotkeysArray["megaStopFollow"] 				:= "!NumpadEnter"
	defaultHotkeysArray["megaRoadTrafficAct"] 			:= "~NumpadDot"
	defaultHotkeysArray["equip"] 						:= "!F4"
	defaultHotkeysArray["heal"] 						:= "~^H"
	defaultHotkeysArray["equipProfile1"] 				:= "F4"
	defaultHotkeysArray["equipProfile2"] 				:= "F5"
	defaultHotkeysArray["equipProfile3"] 				:= "F6"
	defaultHotkeysArray["members"] 						:= "~M"
	defaultHotkeysArray["crewmembers"]	 				:= "~O"
	defaultHotkeysArray["backup"] 						:= "~NumpadAdd"
	defaultHotkeysArray["backupWh"] 					:= "~^NumpadAdd"
	defaultHotkeysArray["noBackup"] 					:= "!NumpadAdd"
	defaultHotkeysArray["position"] 					:= "~P"
	defaultHotkeysArray["fPosition"] 					:= "!P"
	defaultHotkeysArray["rPosition"] 					:= "~^P"
	defaultHotkeysArray["acceptJob"] 					:= "~´"
	defaultHotkeysArray["doneJob"] 						:= "!´"
	
	defaultHotkeysArray["giveQuickTicket"] 				:= "~!t"
	defaultHotkeysArray["giveQUickTicketAuto"]          := "~."
	defaultHotkeysArray["autoAcceptEmergency"] 			:= "~^"
	defaultHotkeysArray["acceptEmergency"] 				:= "~+^"
	defaultHotkeysArray["autoImprison"] 				:= "~#"
	defaultHotkeysArray["imprison"]		 				:= "~Numpad8"
	defaultHotkeysArray["arrestSlots"] 					:= "!#"
	defaultHotkeysArray["resetArrestSlots"] 			:= "F9"
	defaultHotkeysArray["arrest"] 						:= "~Numpad7"
	defaultHotkeysArray["uncuff"] 						:= "~U"
	defaultHotkeysArray["check"] 						:= "~K"
	defaultHotkeysArray["askCheck"] 					:= "~2"
	defaultHotkeysArray["openTrunk"] 					:= "^K"
	defaultHotkeysArray["checkTrunk"] 					:= "~^L"
	defaultHotkeysArray["askTrunkOpen"] 				:= "~ß"
	defaultHotkeysArray["askPapers"] 					:= "~3"
	defaultHotkeysArray["cooperation"] 					:= "~4"
	defaultHotkeysArray["getOutOfCar"] 					:= "~5"
	defaultHotkeysArray["notAllowedToGoInCar"] 			:= "~!5"
	defaultHotkeysArray["arrestedCar"] 					:= "~6"
	defaultHotkeysArray["arrestedByName"] 				:= "~7"
	defaultHotkeysArray["putWeaponsAway"] 				:= "~I"
	defaultHotkeysArray["grab"] 						:= "~9"
	defaultHotkeysArray["manuellGrab"] 					:= "~!9"
	defaultHotkeysArray["togCellphone"] 				:= "!F1"
	defaultHotkeysArray["useDrugs"] 					:= "F1"
	defaultHotkeysArray["eatFish"] 						:= "F2"
	defaultHotkeysArray["firstAid"]	 					:= "F3"
	defaultHotkeysArray["countdown"] 					:= "~End"
	defaultHotkeysArray["stopwatch"] 					:= "~`,"
	defaultHotkeysArray["stopAutomaticSystems"] 		:= "~<"
	defaultHotkeysArray["openDoor"] 					:= "~NumpadSub"
	defaultHotkeysArray["openCustoms"] 					:= "!NumpadSub"
	defaultHotkeysArray["closeCustomsControl"] 			:= "~sc135"
	defaultHotkeysArray["openCustomsControl"] 			:= "!sc135"
	defaultHotkeysArray["govClosedCustoms"] 			:= "~NumpadMult"
	defaultHotkeysArray["govOpenedCustoms"] 			:= "!NumpadMult"
	defaultHotkeysArray["ram"] 							:= "~8"
	defaultHOtkeysArray["refuse"] 						:= "~r"
	defaultHotkeysArray["zivic"]						:= "~!X"
	defaultHotkeysArray["jobexecute"]					:= "~!j"
	defaultHotkeysArray["pause"] 						:= "~Pause"
	
	if (admin) {
		defaultHotkeysArray["accept1"] 					:= "~+Numpad1"
		defaultHotkeysArray["accept2"] 					:= "~+Numpad2"
		defaultHotkeysArray["accept3"] 					:= "~+Numpad3"
		defaultHotkeysArray["accept4"] 					:= "~+Numpad4"
		defaultHotkeysArray["accept5"] 					:= "~+Numpad5"
		defaultHotkeysArray["accept6"] 					:= "~+Numpad6"
		defaultHotkeysArray["accept7"] 					:= "~+Numpad7"
		defaultHotkeysArray["accept8"] 					:= "~+Numpad8"
		defaultHotkeysArray["accept9"] 					:= "~+Numpad9"
		defaultHotkeysArray["acceptMain"] 				:= "~+Numpad0"
	}
		
	IfNotExist, ini/Hotkeys.ini
	{
		for key, value in defaultHotkeysArray {
			IniWrite, %value%, ini/Hotkeys.ini, Hotkeys, %key%
		}
	}
	
	for key, value in defaultHotkeysArray {
		IniRead, hk, ini/Hotkeys.ini, Hotkeys, %key%, %A_Space%
		
		if (!hk) {
			alreadyRegistered := false
			
			for k, v in registeredHotkeys {
				hk2 := StrReplace(value, "~", "")
				v2 := StrReplace(v, "~", "")
				
				if (hk2 = v2 && StrLen(hk2) == StrLen(v2)) {
					alreadyRegistered := true
					alreadyRegisteredKey := k
					alreadyRegisteredValue := v
					break
				}
			}
			
			if (!alreadyRegistered) {
				Hotkey, %value%, %key%Label
				StringReplace, %key%NoMods, value, ~
				
				registeredHotkeys[key] := value
			}
		} else if (hk != "---") {
			alreadyRegistered := false
			
			for k, v in registeredHotkeys {
				hk2 := StrReplace(hk, "~", "")
				v2 := StrReplace(v, "~", "")
				
				if (hk2 = v2 && StrLen(hk2) == StrLen(v2)) {
					alreadyRegistered := true
					alreadyRegisteredKey := k
					alreadyRegisteredValue := v
					break
				}
			}
			
			if (!alreadyRegistered) {
				Hotkey, %hk%, %key%Label
				StringReplace, %key%NoMods, hk, ~
				
				registeredHotkeys[key] := hk
			}
		}
	}
	
	global ownHotkeyCount := 48
	
	Loop, %ownHotkeyCount% {
		outerIndex := A_Index
		
		IniRead, ownHotkey%outerIndex%Active, ownhotkeys.ini, %outerIndex%, Active, 0
		IniRead, ownHotkey%outerIndex%Text, ownhotkeys.ini, %outerIndex%, Text, %A_Space%
		IniRead, hk, ownhotkeys.ini, %outerIndex%, Hotkey, %A_Space%
		
		ownHotkey%outerIndex%Text := StrReplace(ownHotkey%outerIndex%Text, "~", "`n")
		
		if (hk) {
			alreadyRegistered := false
			
			for key, value in registeredHotkeys {
				hk2 := StrReplace(hk, "~", "")
				value2 := StrReplace(value, "~", "")
				
				if (hk2 = value2 && StrLen(hk2) == StrLen(value2)) {
					alreadyRegistered := true
					alreadyRegisteredKey := key
					alreadyRegisteredValue := value
					break
				}
			}
			
			StringReplace, ownHotkey%outerIndex%NoMods, hk, ~
			
			if (!alreadyRegistered) {
				if (ownHotkey%outerIndex%Active) {
					Hotkey, %hk%, ownHotkey%outerIndex%Label
					
					registeredHotkeys["ownHotkey" . outerIndex] := hk
				}
			}
		}
	}

	Loop, 3 {
		profileID := A_Index
		
		Loop, 6 {
			IniRead, profile%profileID%_%A_Index%, ini/Settings.ini, Ausrüstungsprofile, Profil%profileID%_%A_Index%, %A_Space%
		}
	}
	
	IniRead, ucSkin, ini/Settings.ini, Ausrüstungsprofile, UCSkin, 0
	IniRead, equipArmour, ini/Settings.ini, Ausrüstungsprofile, Schutzweste, 0
	
	primaryColor := StrReplace(primaryColor, "{", "")
	primaryColor := StrReplace(primaryColor, "}", "")
	secondaryColor := StrReplace(secondaryColor, "{", "")
	secondaryColor := StrReplace(secondaryColor, "}", "")
	
	if (primaryColor == "") {
		primaryColor := "21BBE8"
	}
	
	if (secondaryColor == "") {
		secondaryColor := "CC0000"
	}
	
	global primcol := "{" . primaryColor . "}"
	global csecond := "{" . secondaryColor . "}"
	global prefix := "|" . primcol . projectName . cwhite . "| "
	
	if (ownprefix != "") {
		prefix := ownprefix . " "
	}

	global tasks 				:= []
	global chat 				:= []
	global partners 			:= []
	global grabList 			:= []
	global arrestList 			:= []
	global tickets	 			:= []
	global wantedTickets 		:= []
	global wantedPlayers 		:= []
	global ticketPlayers 		:= []
	global checkingPlayers 		:= []	
	global outbreaks			:= []
	global bankrobs				:= []
	global storerobs			:= []
	global backups				:= []
	global trashcan 			:= []
	
	global pedStates 			:= {}
	
	global tempo 				:= 80
	
	global giveMaxTicket		:= 3
	
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
	global admission			:= 0
	global deathArrested 		:= 0
	global lastSpeed 			:= 0	
	global hasEquip				:= 0
	global isZivil				:= 0
	global getOldKomplex		:= 0
	global oldFriskTime			:= 0
	global oldLocalTime			:= 0
	global pbKillStreak 		:= 0
	global currentSpeed 		:= 0
	global countdownRunning 	:= 0
	global autoFindMode		 	:= 0
	global stopwatchTime 		:= 0
	global IsPayday				:= 0
	global drugcooldown			:= 0
	global healcooldown			:= 0
	global admincooldown		:= 0
	global ooccooldown			:= 0
	global findcooldown			:= 0
	
	global oldWanted            := -1
	global agentID 				:= -1
	global oldHour 				:= -1
	global oldVehicle			:= -1
	global targetid				:= -1
	global wantedIA				:= -1
	global wantedContracter		:= -1
	
	global wantedIAReason		:= ""
	global oldInviteAsk			:= ""
	global target				:= ""
	global lastSpeedUser 		:= ""
	global lastTicketReason 	:= ""
	global lastTicketPlayer 	:= ""
	global requestName			:= ""
	global oldFrisk				:= ""
	global oldLocal				:= ""
	global cooldownString		:= ""
	
	
	global fillTimeout_ 		:= true
	global canisterTimeout_ 	:= true
	global mautTimeout_ 		:= true
	global healTimeout_ 		:= true
	global cookTimeout_ 		:= true
	global equipTimeout_ 		:= true
	global jailgateTimeout_ 	:= true 
	global GateTimeout_ 		:= true
	global fishTimeout_ 		:= true
	global localTimeout_ 		:= true
	global garbageTimeout_		:= true 
	global fishSellTimeout_		:= true

	global overlayEnabled		:= false
	global spotifyOvEnabled		:= false 
	global cooldownOvEnabled 	:= false
	global pingOvEnabled 		:= false
	global infoOvEnabled 		:= false
	global alertOvEnabled 		:= false
	global partnerOvEnabled		:= false
	global isInVehicle			:= false
	global agentTog				:= false
	global startOverlay			:= false
	global pauseOverlay			:= false
	global isArrested			:= false
	global isCuffed				:= false
	global firstStart			:= false
	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
	global gotPoisened			:= false
	
	global ovMoveMode			:= false
	global alertActive  		:= false
	
	global alertString 			:= ""
	global oldSpotifyTrack		:= ""
	global oldVehicleName		:= "none"
	
	if (spotifyOv) {
		ov_Spotify()
		
		spotifyOvEnabled := true
	}	

	if (cooldownOv) {
		ov_Cooldown()
		
		cooldownOvEnabled := true
	}

	if (pingOv) {
		ov_Ping()
		
		pingOvEnabled := true
	}

	if (infoOv) {
		ov_Info()
		
		infoOvEnabled := true
	}

	if (alertOv) {
		ov_Alert()
		
		alertOvEnabled := true
	}
	
	if (partnerOv) {
		ov_Partner()
		
		partnerOvEnabled := true
	}
	
	/*
	trashcan[1]  := [2058.767578, -1050.120239, 27.710558, "Las Colinas", -1, 1]
	trashcan[2]  := [2119.865479, -1062.000977, 25.857998, "Las Colinas", -1, 2]
	trashcan[3]  := [2246.809326, -1153.964966, 26.459375, "Las Colinas", -1, 3]
	trashcan[4]  := [2545.130615, -1120.289917, 62.752769, "Las Colinas", -1, 4]
	trashcan[5]  := [2699.683350, -1106.541870, 70.159241, "Las Colinas", -1, 5]
	trashcan[6]  := [2790.593506, -1096.344116, 31.318750, "Las Colinas", -1, 6]
	trashcan[7]  := [2802.270020, -1195.662964, 26.091354, "East Beach", -1, 7]
	trashcan[8]  := [2769.613037, -1374.365356, 40.351383, "East Beach", -1, 8]
	trashcan[9]  := [2786.151367, -1427.741455, 31.053125, "East Beach", -1, 9]
	trashcan[10] := [2793.253906, -1625.652344, 11.521875, "East Beach", -1, 10]
	trashcan[11] := [2758.034180, -2020.873657, 14.161955, "Playa del Seville", -1, 11]
	trashcan[12] := [2627.479980, -1984.546997, 14.146875, "Willowfield", -1, 12]
	trashcan[13] := [2441.379150, -1964.233765, 14.146875, "Willowfield", -1, 13]
	trashcan[14] := [2439.517090, -1900.352295, 14.153357, "Willowfield", -1, 14]
	trashcan[15] := [2368.265869, -2032.633179, 14.097355, "Willowfield", -1, 15]
	trashcan[16] := [2340.841553, -2154.718262, 14.146875, "Ocean Docks", -1, 16]
	trashcan[17] := [2182.485107, -2249.278320, 13.928430, "Ocean Docks", -1, 17]
	trashcan[18] := [2123.285156, -2282.549072, 14.077246, "Ocean Docks", -1, 18]
	trashcan[19] := [1998.914795, -2136.649902, 14.146875, "Willowfield", -1, 19]
	trashcan[20] := [2052.302490, -2146.937744, 14.232813, "Willowfield", -1, 20]
	trashcan[21] := [1990.136108, -2014.769043, 14.146875, "Willowfield", -1, 21]
	trashcan[22] := [1731.480713, -2055.552979, 14.174515, "El Corona", -1, 22]
	trashcan[23] := [1629.833496, -1911.320313, 14.149103, "Verdant Bluffs", -1, 23]
	trashcan[24] := [1614.523560, -1841.383301, 14.127308, "Commerce", -1, 24]
	trashcan[25] := [1592.933960, -1784.566040, 13.877789, "Commerce", -1, 25]
	trashcan[26] := [1809.678711, -1688.933716, 14.151469, "Little Mexico", -1, 26]
	trashcan[27] := [1907.996826, -1572.763306, 14.200819, "Idlewood", -1, 27]
	trashcan[28] := [2003.734619, -1551.829468, 14.246980, "Idlewood", -1, 28]
	trashcan[29] := [1397.024292, -1894.318481, 14.089090, "Verdant Bluffs", -1, 29]
	trashcan[30] := [1372.502930, -1720.065063, 13.601456, "Commerce", -1, 30]
	trashcan[31] := [1342.739746, -1680.794189, 14.182812, "Commerce", -1, 31]
	trashcan[32] := [1641.281250, -1679.334106, 14.137456, "Commerce", -1, 32]
	trashcan[33] := [1594.332886, -1559.761353, 14.765665, "Commerce", -1, 33]
	trashcan[34] := [1721.005859, -1472.314453, 14.151341, "Commerce", -1, 34]
	trashcan[35] := [1611.727905, -1201.589478, 20.409513, "Downtown Los Santos", -1, 35]
	trashcan[36] := [1830.586792, -1149.416382, 24.450518, "Glen Park", -1, 36]
	trashcan[37] := [1616.220215, -993.336365, 24.666773, "Mulholland Intersection", -1, 37]
	trashcan[38] := [1296.652222, -979.811829, 33.295311, "Temple", -1, 38]
	trashcan[39] := [1201.949097, -976.933716, 44.076561, "Temple", -1, 39]
	trashcan[40] := [1284.726318, -1252.247681, 14.146875, "Market", -1, 40]
	trashcan[41] := [1132.987183, -1345.027100, 14.584375, "Market", -1, 41]
	trashcan[42] := [1084.256714, -1224.599243, 16.420313, "Market", -1, 42]
	trashcan[43] := [1015.644287, -1005.409424, 32.701561, "Temple", -1, 43]
	trashcan[44] := [856.674438, -974.783020, 36.115143, "Vinewood", -1, 44]
	trashcan[45] := [783.716736, -1013.634827, 26.959375, "Richman", -1, 45]
	trashcan[46] := [777.521851, -1121.635010, 24.428125, "Vinewood", -1, 46]
	trashcan[47] := [811.763245, -1269.233765, 14.184126, "Vinewood", -1, 47]
	trashcan[48] := [733.994995, -1337.045410, 14.134808, "Vinewood", -1, 48]
	trashcan[49] := [877.909180, -1363.699951, 14.146875, "Market", -1, 49]
	trashcan[50] := [707.066956, -1474.307983, 6.068750, "Marina", -1, 50]
	trashcan[51] := [587.353088, -1554.240967, 16.212440, "Rodeo", -1, 51]
	trashcan[52] := [412.291962, -1808.504761, 6.146875, "Santa Maria Beach", -1, 52]
	trashcan[53] := [309.993774, -1436.890381, 28.529688, "Rodeo", -1, 53]
	trashcan[54] := [412.914490, -1304.481445, 15.568627, "Rodeo", -1, 54]
	trashcan[55] := [1082.914307, -1666.565552, 14.138750, "Verona Beach", -1, 55]
	trashcan[56] := [1229.145264, -1609.433594, 14.146875, "Verona Beach", -1, 56]
	trashcan[57] := [1010.867615, -1270.720703, 15.787210, "Market", -1, 57]
	trashcan[58] := [1029.465820, -1363.808350, 14.171368, "Market", -1, 58]
	trashcan[59] := [1964.835938, -1307.474854, 24.378319, "Glen Park", -1, 59]
	trashcan[60] := [2384.933350, -1485.982300, 24.600000, "East Los Santos", -1, 60]
	trashcan[61] := [2345.070801, -1948.613281, 14.156754, "Willowfield", -1, 61]
	trashcan[62] := [2384.503418, -1940.051514, 14.146875, "Willowfield", -1, 62]
	trashcan[63] := [2590.447021, -1321.253174, 40.518929, "Los Flores", -1, 63]
	trashcan[64] := [2416.958252, -1577.622559, 24.431389, "East Los Santos", -1, 64]
	trashcan[65] := [2442.497559, -1760.444946, 14.191413, "Ganton", -1, 65]
	trashcan[66] := [2453.276611, -2543.011230, 14.256072, "Ocean Docks", -1, 66]
	trashcan[67] := [2513.634033, -2640.555908, 14.243263, "Ocean Docks", -1, 67]
	trashcan[68] := [2200.565918, -2632.509521, 14.146875, "Los Santos International", -1, 68]
	trashcan[69] := [2199.586182, -2600.765137, 14.140907, "Los Santos International", -1, 69]
	trashcan[70] := [2735.4619, -2446.2249, 13.6432, "Ocean Docks", -1, 70]
	trashcan[71] := [2547.7144, -1290.5468, 41.1641, "East Los Santos", -1, 71]
	trashcan[72] := [2281.9441, -2046.9819, 13.5469, "Willowfield", -1, 72]
	trashcan[73] := [2209.1743, -1343.6583, 23.9844, "Jefferson", -1, 73]
	UpdateRest()	
	*/
	Loop, 5 {
		fishName_%A_Index% := "nichts"
		fishLBS_%A_Index% := 0
		fishHP_%A_Index% := 0
	}

	Loop, 5 {
		fishName%A_Index% := "nichts"
		fishHP%A_Index% := 0
		fishPrice%A_Index% := 0
	}
	
	if (admin) {
		IfNotExist Tickets
			FileCreateDir, Tickets
		
		global respawnCarsRunning := false
	}
	
	SetTimer, ArrestTimer, 100
	SetTimer, ChatTimer, 200	
	SetTimer, MainTimer, 200
	SetTimer, KillTimer, 500
	SetTimer, SecondTimer, 1000

	if (taskInfo) {
		SetTimer, TaskCheckTimer, 5000
	}
	
	if (autoUncuff) {
		SetTimer, UncuffTimer, 500
	}

	if (wantedInfo) {
		SetTimer, WantedTimer, 1000
	}

	if (admin) {
		SetTimer, TicketTimer, 1000
	}
	
	if (autoLotto) {
		SetTimer, LottoTimer, 2000
	}
	
	if (autoUse) {
		SetTimer, SyncTimer, 60000
	}
	
    SetParam("use_window", "1")
    SetParam("window", "GTA:SA:MP")	
	
	Gui, Color, white
	Gui, Font, s32 CDefault, Verdana
		
	Gui, Add, Text, x245 y12 w460 h55 , %fullProjectName%
		
	if (userFraction == 2) {
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallFBI.png
	} else if (userFraction == 1) {
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallLSPD.png
	} else if (userFraction == 3) {
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallArmy.png
	}
	
	Gui, Font, s10 CDefault, Verdana

	Gui, Add, GroupBox, x-8 y75 w210 h460, 
	Gui, Add, Button, x12 y89 w170 h30 gSettingsGUI, Settings
	Gui, Add, Button, x12 y129 w170 h30 gHotkeysGUI, Hotkeys
	Gui, Add, Button, x12 y169 w170 h30 gNewsGUI, News
	Gui, Add, Button, x12 y209 w170 h30 gHelpGUI, Hilfen
	Gui, Add, Button, x12 y249 w170 h30 gSupport, Fehler melden
	Gui, Add, Button, x12 y379 w170 h30 gKeyControl, Keybinder CP
	Gui, Add, Button, x12 y419 w170 h30 gRPGConnect, RPG - Connect
	Gui, Add, Button, x12 y459 w170 h30 gTeamSpeak, FBI/LSPD - TS Connect

	Gui, Add, GroupBox, x232 y89 w560 h190, Neuigkeiten (Version %version%)
	changelog := URLDownloadToVar(baseURL . "api/getupdatelog?version=" . version . "")
	StringReplace, update, msg, ', `r`n, All
	Gui, Add, Edit, x242 y109 w540 h160 ReadOnly, %changelog%

	Gui, Add, GroupBox, x232 y289 w560 h190, User-Informationen 

	
	if (rank is number) {
		if (rank == 0) {
			rankinfo := "Du bist kein Beamter"
		} else {
			rankinfo := "Rang: " . rank . "!"
		}
	} else {
		rankinfo := "Du bist kein Beamter"
	}
	
	fractionName := getFractionName()
	
	info =
	(
Name: %username%
%rankinfo%
	
	
	
	
Aktuelle Keybinderversion: %version%
Fraktion: %fractionName%

Eingeloggt seit: %keybinderStart% Uhr
	)
	Gui, Add, Text, x242 y309 w540 h160, %info%

	Gui, Show, w818 h505, %fullProjectName% - Version %version%
}
return

GuiClose:
{
	destroyOverlay()
	
    logoutResult := URLDownloadToVar(baseURL . "api/keybinder.php?type=logout&username=" . username . "&password=" . password . "&version=" . version . "&project=" . projectName)
	ExitApp
}
return

TeamSpeak:
{	
	run, ts3server://lspd.lennartf.com
}
return

Support:
{
	Run, https://staatsgewalt.jameschans.de/feedback
}
return

ControlPanel:
{
	Run, https://cp.rpg-city.de/
}
return

SettingsGUI:
{
	Gui, Settings: Destroy
	
	Gui, Settings: Color, white
	Gui, Settings: Font, S10 CDefault, Verdana
	
	Gui, Settings: Add, Button, x10 y730 w130 h40 gequipProfiles, Ausrüstprofile
	Gui, Settings: Add, Button, x150 y730 w130 h40 gvariables, Variablen
	Gui, Settings: Add, Button, x290 y730 w130 h40 goverlaySettings, Overlay
	Gui, Settings: Add, Button, x520 y730 w130 h40 gSettingsGuiClose, Schließen

	Gui, Settings: Add, GroupBox, x10 y10 w640 h230, Allgemeine Einstellungen

	Gui, Settings: Add, CheckBox, x20 y30 w190 h20 vautoLock checked%autoLock%, /lock beim Einsteigen
	Gui, Settings: Add, CheckBox, x20 y60 w190 h20 vautoEngine checked%autoEngine%, /motor beim Aussteigen
	Gui, Settings: Add, CheckBox, x20 y90 w190 h20 vautoFill checked%autoFill%, Schnelles Tanken
	Gui, Settings: Add, CheckBox, x20 y120 w190 h20 vautoLotto checked%autoLotto%, Auto-Lotto System
	Gui, Settings: Add, CheckBox, x20 y150 w190 h20 vantiSpam checked%antiSpam%, Spamschutz System
	Gui, Settings: Add, CheckBox, x20 y180 w190 h20 vautoUncuff checked%autoUncuff%, Uncuff bei Explosion
	Gui, Settings: Add, CheckBox, x20 y210 w190 h20 vautoFrisk checked%autoFrisk%, Durchsuchen bei Cuff

	Gui, Settings: Add, CheckBox, x210 y30 w190 h20 vautoTake checked%autoTake%, Auto-Drogen/Mats Take
	Gui, Settings: Add, CheckBox, x210 y60 w190 h20 vautoWanted checked%autoWanted%, Auto-Wanted Vergabe
	Gui, Settings: Add, CheckBox, x210 y90 w190 h20 vautoCustoms checked%autoCustoms%, Schnelles Zollöffnen
	Gui, Settings: Add, CheckBox, x210 y120 w190 h20 vautoLocal checked%autoLocal%, Schnelle Ketteneinnahme
	Gui, Settings: Add, CheckBox, x210 y150 w190 h20 vautoUse checked%autoUse%, Pak/Fische auf W A S D
	Gui, Settings: Add, CheckBox, x210 y180 w190 h20 vfishMode checked%fishMode%, Billigsten Fisch wegwerfen
	Gui, Settings: Add, CheckBox, x210 y210 w185 h20 vautoHeal checked%autoHeal%, Schnelles Healen

	Gui, Settings: Add, CheckBox, x420 y30 w190 h20 vautoDrugs checked%autoDrugs%, Drogen use auf W A S D
	Gui, Settings: Add, CheckBox, x420 y60 w190 h20 vadmin checked%admin%, Admin-Modus
	Gui, Settings: Add, CheckBox, x420 y90 w190 h20 vautoCook checked%autoCook%, Schnelles Kochen
	Gui, Settings: Add, CheckBox, x420 y120 w190 h20 vautoEquip checked%autoEquip%, Schnelles Ausrüsten
	Gui, Settings: Add, CheckBox, x420 y150 w190 h20 vautoExecute checked%autoExecute%, Schnell O-Amt WTD
	Gui, Settings: Add, CheckBox, x420 y180 w190 h20 vautoGate checked%autoGate%, Schnelles Tor-System
	Gui, Settings: Add, CheckBox, x420 y210 w190 h20 vautoFish checked%autoFish%, Schnelles Angeln
	
	Gui, Settings: Add, GroupBox, x10 y250 w640 h80, Sounds
	Gui, Settings: Add, CheckBox, x20 y270 w190 h20 vsmsSound Checked%smsSound%, SMS Sound
	Gui, Settings: Add, CheckBox, x20 y300 w190 h20 vleagueSound Checked%leagueSound%, Killstreak Sound
	Gui, Settings: Add, CheckBox, x220 y270 w190 h20 vcallSound Checked%callSound%, Call Sound
	Gui, Settings: Add, CheckBox, x220 y300 w190 h20 vemergencySound Checked%emergencySound%, Bankrob Sound
	Gui, Settings: Add, CheckBox, x420 y300 w190 h20 vbackupSound Checked%backupSound%, Backup Sound
	
	Gui, Settings: Add, GroupBox, x10 y340 w640 h140, Diverse Nachrichten
	Gui, Settings: Add, CheckBox, x20 y360 w190 h20 vdamageInfo checked%damageInfo%, Erlittener Schaden
	Gui, Settings: Add, CheckBox, x20 y390 w190 h20 vpaintInfo checked%paintInfo%, Paintballkillstreak
	Gui, Settings: Add, CheckBox, x20 y420 w190 h20 vwantedInfo checked%wantedInfo%, Wantednachrichten
	Gui, Settings: Add, CheckBox, x20 y450 w190 h20 vescInfo checked%escInfo%, /a bei ESC WTD

	Gui, Settings: Add, CheckBox, x210 y360 w190 h20 vpaketInfo checked%paketInfo%, Paket Danksagung
	Gui, Settings: Add, CheckBox, x210 y390 w190 h20 vlaserInfo checked%laserInfo%, Radarkontrollenansage
	Gui, Settings: Add, CheckBox, x210 y420 w190 h20 vmemberInfo checked%memberInfo%, Member begrüßen?
	Gui, Settings: Add, CheckBox, x210 y450 w190 h20 vafkInfo checked%afkInfo%, AFK-Chatmeldung
	
	Gui, Settings: Add, CheckBox, x420 y360 w190 h20 vspotifyPublic checked%spotifyPublic%, Spotify-Tracks (public)
	Gui, Settings: Add, CheckBox, x420 y390 w190 h20 vspotifyPrivacy checked%spotifyPrivacy%, Spotify-Tracks (privat)
	Gui, Settings: Add, CheckBox, x420 y420 w190 h20 vrefillInfo checked%refillInfo%, Tank-Warnungen
	Gui, Settings: Add, CheckBox, x210 y450 w190 h20 vtaskInfo checked%taskInfo%, Task-Meldungen
	
	Gui, Settings: Add, GroupBox, x10 y490 w640 h230, Sonstiges
	Gui, Settings: Add, Text, x20 y510 w280 h20, Lottozahl:
	Gui, Settings: Add, Edit, x130 y510 w110 h20 vlottoNumber, %lottoNumber%
	
	Gui, Settings: Add, CheckBox, x280 y510 w110 h20 vkillText checked%killText%, Killspruch:
	Gui, Settings: Add, Edit, x400 y510 w240 h20 vkillMessage, %killMessage%

	Gui, Settings: Add, Text, x20 y540 w280 h20, Rang:
	Gui, Settings: Add, Edit, x130 y540 w110 h20 vrank, %rank%
	
	Gui, Settings: Add, CheckBox, x280 y540 w110 h20 vdeathText checked%deathText%, Todesspruch:
	Gui, Settings: Add, Edit, x400 y540 w240 h20 vdeathMessage, %deathMessage%
	
	Gui, Settings: Add, Text, x20 y570 w280 h20, Fraktion:
	Gui, Settings: Add, Edit, x130 y570 w110 h20 vfraction, %fraction%

	Gui, Settings: Add, Text, x20 y600 w280 h20, Abteilung:
	Gui, Settings: Add, Edit, x130 y600 w110 h20 vdepartment, %department%

	Gui, Settings: Add, Text, x20 y630 w280 h20, Primärfarbe:
	Gui, Settings: Add, Edit, x130 y630 w110 h20 vprimaryColor, %primaryColor%

	Gui, Settings: Add, Text, x20 y660 w280 h20, Sekundärfarbe:
	Gui, Settings: Add, Edit, x130 y660 w110 h20 vsecondaryColor, %secondaryColor%

	Gui, Settings: Add, Text, x20 y690 w280 h20, Eigener Prefix:
	Gui, Settings: Add, Edit, x130 y690 w110 h20 vownprefix, %ownprefix%

	Gui, Settings: Show, h780 w660, %projectName% - Einstellungen - Version %version%
}
return

overlaySettings:
{
	Gui, overlaySettings: Destroy
	Gui, overlaySettings: Color, white
	Gui, overlaySettings: Font, ,
	Gui, overlaySettings: Font, S10,	

	Gui, overlaySettings: Add, GroupBox, x12 y9 w290 h250, Spotify Overlay
	{
		Gui, overlaySettings: Add, Text, x22 y29 w110 h20, aktivieren?
		Gui, overlaySettings: Add, CheckBox, x132 y29 w20 h20 vspotifyOv checked%spotifyOv%,
		
		Gui, overlaySettings: Add, Text, x22 y49 w140 h20, Koordinaten:
		Gui, overlaySettings: Add, Text, x162 y49 w40 h20, X:
		Gui, overlaySettings: Add, Text, x162 y79 w40 h20, Y:
		Gui, overlaySettings: Add, Edit, x202 y49 w90 h20 vspotifyXPos, %spotifyXPos%
		Gui, overlaySettings: Add, Edit, x202 y79 w90 h20 vspotifyYPos, %spotifyYPos%
		
		Gui, overlaySettings: Add, Text, x22 y79 w100 h20, Fett:
		Gui, overlaySettings: Add, CheckBox, x122 y79 w20 h20 vspotifyBold checked%spotifyBold%,
		
		Gui, overlaySettings: Add, Text, x22 y109 w100 h20, Kursiv:
		Gui, overlaySettings: Add, CheckBox, x122 y109 w20 h20 vspotifyItal checked%spotifyItal%, 
		
		Gui, overlaySettings: Add, Text, x162 y109 w110 h20, Farbe an:
		Gui, overlaySettings: Add, CheckBox, x272 y109 w20 h20 vspotifyColorOn checked%spotifyColorOn%
		
		Gui, overlaySettings: Add, Text, x112 y139 w90 h20, Font:
		Gui, overlaySettings: Add, Edit, x202 y139 w90 h20 vspotifyFont, %spotifyFont%
		
		Gui, overlaySettings: Add, Text, x112 y169 w90 h20, Fontgröße:
		Gui, overlaySettings: Add, Edit, x202 y169 w90 h20 vspotifySize, %spotifySize%
		
		Gui, overlaySettings: Add, Text, x112 y199 w90 h20, Primärfarbe:
		Gui, overlaySettings: Add, Edit, x202 y199 w90 h20 vspotifyColor, %spotifyColor%
		
		Gui, overlaySettings: Add, Text, x112 y229 w90 h20, Songfarbe:
		Gui, overlaySettings: Add, Edit, x202 y229 w90 h20 vspotifySongColor, %spotifySongColor%
	}
	
	Gui, overlaySettings: Add, GroupBox, x312 y9 w290 h250, Ping/FPS  Overlay
	{
		Gui, overlaySettings: Add, Text, x322 y29 w110 h20, aktivieren?
		Gui, overlaySettings: Add, CheckBox, x432 y29 w20 h20 vpingOv checked%pingOv%,
		
		Gui, overlaySettings: Add, Text, x322 y49 w140 h20, Koordinaten:
		Gui, overlaySettings: Add, Text, x462 y49 w40 h20, X:
		Gui, overlaySettings: Add, Text, x462 y79 w40 h20, Y:
		Gui, overlaySettings: Add, Edit, x502 y49 w90 h20 vpingXPos, %pingXPos%
		Gui, overlaySettings: Add, Edit, x502 y79 w90 h20 vpingYPos, %pingYPos%
		
		Gui, overlaySettings: Add, Text, x322 y79 w100 h20, Fett:
		Gui, overlaySettings: Add, CheckBox, x422 y79 w20 h20 vpingBold checked%pingBold%, 
		
		Gui, overlaySettings: Add, Text, x322 y109 w100 h20, Kursiv:
		Gui, overlaySettings: Add, CheckBox, x422 y109 w20 h20 vpingItal checked%pingItal%, 
		
		Gui, overlaySettings: Add, Text, x462 y109 w110 h20, Farbe an:
		Gui, overlaySettings: Add, CheckBox, x572 y109 w20 h20 vpingColorOn checked%pingColorOn%,
		
		Gui, overlaySettings: Add, Text, x412 y139 w90 h20, Font:
		Gui, overlaySettings: Add, Edit, x502 y139 w90 h20 vpingFont, %pingFont%
		
		Gui, overlaySettings: Add, Text, x412 y169 w90 h20, Fontgröße:
		Gui, overlaySettings: Add, Edit, x502 y169 w90 h20 vpingSize, %pingSize%
		
		Gui, overlaySettings: Add, Text, x412 y199 w90 h20, Primärfarbe:
		Gui, overlaySettings: Add, Edit, x502 y199 w90 h20 vpingColor, %pingColor%
		
		Gui, overlaySettings: Add, Text, x322 y229 w160 h20, low FPS: rot z.B.:
		Gui, overlaySettings: Add, CheckBox, x482 y229 w20 h20 vpingAlertColorOn checked%pingAlertColorOn%, 
	}
	
	Gui, overlaySettings: Add, GroupBox, x12 y259 w290 h260, Cooldown Overlay
	{
		Gui, overlaySettings: Add, Text, x22 y279 w110 h20, aktivieren?
		Gui, overlaySettings: Add, CheckBox, x132 y279 w20 h20 vcooldownOv checked%cooldownOv% 
		
		Gui, overlaySettings: Add, Text, x22 y299 w140 h20, Koordinaten:
		Gui, overlaySettings: Add, Text, x162 y299 w40 h20, X:
		Gui, overlaySettings: Add, Text, x162 y329 w40 h20, Y:

		Gui, overlaySettings: Add, Edit, x202 y299 w90 h20 vcooldownXPos, %cooldownXPos%
		Gui, overlaySettings: Add, Edit, x202 y329 w90 h20 vcooldownYPos, %cooldownYPos%
		
		Gui, overlaySettings: Add, Text, x22 y329 w100 h20, Fett:
		Gui, overlaySettings: Add, CheckBox, x122 y329 w20 h20 vcooldownBold checked%cooldownBold%, 
		
		Gui, overlaySettings: Add, Text, x22 y359 w100 h20, Kursiv:
		Gui, overlaySettings: Add, CheckBox, x122 y359 w20 h20 vcooldownItal checked%cooldownItal%, 
		
		Gui, overlaySettings: Add, Text, x162 y359 w110 h20, Farbe an:
		Gui, overlaySettings: Add, CheckBox, x272 y359 w20 h20 vcooldownColorOn checked%cooldownColorOn%, 
		
		Gui, overlaySettings: Add, Text, x112 y389 w90 h20, Font:
		Gui, overlaySettings: Add, Edit, x202 y389 w90 h20 vcooldownFont, %cooldownFont%
		
		Gui, overlaySettings: Add, Text, x112 y419 w90 h20, Fontgröße:
		Gui, overlaySettings: Add, Edit, x202 y419 w90 h20 vcooldownSize, %cooldownSize%
		
		Gui, overlaySettings: Add, Text, x112 y449 w90 h20, Farbe:
		Gui, overlaySettings: Add, Edit, x202 y449 w90 h20 vcooldownColor, %cooldownColor%
	}
	
	Gui, overlaySettings: Add, GroupBox, x312 y259 w290 h260, Info Overlay
	{
		Gui, overlaySettings: Add, Text, x322 y279 w110 h20, aktivieren?
		Gui, overlaySettings: Add, CheckBox, x432 y279 w20 h20 vinfoOv checked%infoOv%, 
		
		Gui, overlaySettings: Add, CheckBox, x322 y309 w110 h20 vinfoPhone checked%infoPhone%, Handy-Status:
		Gui, overlaySettings: Add, Text, x442 y309 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y309 w50 h20 vinfoPhoneX, %infoPhoneX%
		Gui, overlaySettings: Add, Text, x522 y309 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y309 w50 h20 vinfoPhoneY, %infoPhoneY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y339 w110 h20 vinfoFirstaid checked%infoFirstaid%, Erste-Hilfe:
		Gui, overlaySettings: Add, Text, x442 y339 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y339 w50 h20 vinfoFirstaidX, %infoFirstaidX%
		Gui, overlaySettings: Add, Text, x522 y339 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y339 w50 h20 vinfoFirstaidY, %infoFirstaidY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y369 w110 h20 vinfoCampfire checked%infoCampfire%, Lagerfeuer:
		Gui, overlaySettings: Add, Text, x442 y369 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y369 w50 h20 vinfoCampfireX, %infoCampfireX%
		Gui, overlaySettings: Add, Text, x522 y369 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y369 w50 h20 vinfoCampfireY, %infoCampfireY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y399 w110 h20 vinfoCanister checked%infoCanister%, Kanister:
		Gui, overlaySettings: Add, Text, x442 y399 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y399 w50 h20 vinfoCanisterX, %infoCanisterX%
		Gui, overlaySettings: Add, Text, x522 y399 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y399 w50 h20 vinfoCanisterY, %infoCanisterY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y429 w110 h20 vinfoDrugs checked%infoDrugs%, Drogen:
		Gui, overlaySettings: Add, Text, x442 y429 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y429 w50 h20 vinfoDrugsX, %infoDrugsX%
		Gui, overlaySettings: Add, Text, x522 y429 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y429 w50 h20 vinfoDrugsY, %infoDrugsY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y459 w110 h20 vinfoFishUncooked checked%infoFishUncooked%, Fische (Roh):
		Gui, overlaySettings: Add, Text, x442 y459 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y459 w50 h20 vinfoFishUncookedX, %infoFishUncookedX%
		Gui, overlaySettings: Add, Text, x522 y459 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y459 w50 h20 vinfoFishUncookedY, %infoFishUncookedY%
		
		Gui, overlaySettings: Add, CheckBox, x322 y489 w110 h20 vinfoFishCooked checked%infoFishCooked%, Fische:
		Gui, overlaySettings: Add, Text, x442 y489 w20 h20, X:
		Gui, overlaySettings: Add, Edit, x462 y489 w50 h20 vinfoFishCookedX, %infoFishCookedX%
		Gui, overlaySettings: Add, Text, x522 y489 w20 h20, Y:
		Gui, overlaySettings: Add, Edit, x542 y489 w50 h20 vinfoFishCookedY, %infoFishCookedY%
	}

	Gui, overlaySettings: Add, GroupBox, x12 y519 w290 h250, Alarm Overlay
	{
		Gui, overlaySettings: Add, Text, x22 y539 w110 h20, aktivieren?
		Gui, overlaySettings: Add, CheckBox, x132 y539 w20 h20 valertOv checked%alertOv%, 
		
		Gui, overlaySettings: Add, Text, x22 y559 w140 h20 , Koordinaten:
		Gui, overlaySettings: Add, Text, x162 y559 w40 h20 , X:
		Gui, overlaySettings: Add, Text, x162 y589 w40 h20 , Y:
		Gui, overlaySettings: Add, Edit, x202 y559 w90 h20 valertXPos, %alertXPos%
		Gui, overlaySettings: Add, Edit, x202 y589 w90 h20 valertYPos, %alertYPos%
		
		Gui, overlaySettings: Add, Text, x22 y589 w100 h20, Fett:
		Gui, overlaySettings: Add, CheckBox, x122 y589 w20 h20 valertBold checked%alertBold%, 
		
		Gui, overlaySettings: Add, Text, x22 y619 w100 h20, Kursiv:
		Gui, overlaySettings: Add, CheckBox, x122 y619 w20 h20 valertItal checked%alertItal%, 

		Gui, overlaySettings: Add, Text, x112 y649 w90 h20, Font:
		Gui, overlaySettings: Add, Edit, x202 y649 w90 h20 valertFont, %alertFont%
		
		Gui, overlaySettings: Add, Text, x112 y679 w90 h20, Fontgröße:
		Gui, overlaySettings: Add, Edit, x202 y679 w90 h20 valertSize, %alertSize%
	}
	
	Gui, overlaySettings: Add, Button, x472 y719 w130 h40 goverlaySettingsClose, Schließen
	Gui, overlaySettings: Show, w620 h792, %keybinder% - Overlay - Version: %currentVersion%
}
return

overlaySettingsClose:
{
	Gui, overlaySettings: Submit, NoHide
	
	IniWrite, % spotifyOv, ini/settings.ini, overlay, spotifyOv
	IniWrite, % spotifyXPos, ini/settings.ini, Overlay, spotifyXPos
	IniWrite, % spotifyYPos, ini/settings.ini, Overlay, spotifyYPos
	IniWrite, % spotifyBold, ini/settings.ini, Overlay, spotifyBold
	IniWrite, % spotifyItal, ini/settings.ini, Overlay, spotifyItal
	IniWrite, % spotifyFont, ini/settings.ini, Overlay, spotifyFont
	IniWrite, % spotifySize, ini/settings.ini, Overlay, spotifySize
	IniWrite, % spotifyColor, ini/settings.ini, Overlay, spotifyColor
	IniWrite, % spotifyColorOn, ini/settings.ini, Overlay, spotifyColorOn
	IniWrite, % spotifySongColor, ini/settings.ini, Overlay, spotifySongColor
	
	IniWrite, % pingOv, ini/settings.ini, overlay, pingOv
	IniWrite, % pingFont, ini/settings.ini, Overlay, pingFont
	IniWrite, % pingSize, ini/settings.ini, Overlay, pingSize
	IniWrite, % pingBold, ini/settings.ini, Overlay, pingBold
	IniWrite, % pingItal, ini/settings.ini, Overlay, pingItal
	IniWrite, % pingXPos, ini/settings.ini, Overlay, pingXPos
	IniWrite, % pingYPos, ini/settings.ini, Overlay, pingYPos
	IniWrite, % pingColorOn, ini/settings.ini, Overlay, pingColorOn
	IniWrite, % pingAlertColorOn, ini/settings.ini, Overlay, pingAlertColorOn
	IniWrite, % pingColor, ini/settings.ini, Overlay, pingColor		
	
	IniWrite, % cooldownOv, ini/settings.ini, overlay, cooldownOv	
	IniWrite, % cooldownFont, ini/settings.ini, Overlay, cooldownFont
	IniWrite, % cooldownSize, ini/settings.ini, Overlay, cooldownSize
	IniWrite, % cooldownBold, ini/settings.ini, Overlay, cooldownBold
	IniWrite, % cooldownItal, ini/settings.ini, Overlay, cooldownItal
	IniWrite, % cooldownXPos, ini/settings.ini, Overlay, cooldownXPos
	IniWrite, % cooldownYPos, ini/settings.ini, Overlay, cooldownYPos
	IniWrite, % cooldownColorOn, ini/settings.ini, Overlay, cooldownColorOn
	IniWrite, % cooldownColor, ini/settings.ini, Overlay, cooldownColor

	IniWrite, % cooldownBoxOv, ini/settings.ini, Overlay, cooldownBoxOv
	IniWrite, % cooldownBoxX, ini/settings.ini, Overlay, cooldownBoxX
	IniWrite, % cooldownBoxY, ini/settings.ini, Overlay, cooldownBoxY
	IniWrite, % cooldownBoxBorderColor, ini/settings.ini, Overlay, cooldownBoxBorderColor		
	
	IniWrite, % infoOv, ini/settings.ini, overlay, infoOv
	IniWrite, % infoPhoneX, ini/settings.ini, overlay, infoPhoneX
	IniWrite, % infoPhoneY, ini/settings.ini, overlay, infoPhoneY
	IniWrite, % infoFirstaidX, ini/settings.ini, overlay, infoFirstaidX
	IniWrite, % infoFirstaidY, ini/settings.ini, overlay, infoFirstaidY
	IniWrite, % infoCanisterX, ini/settings.ini, overlay, infoCanisterX
	IniWrite, % infoCanisterY, ini/settings.ini, overlay, infoCanisterY
	IniWrite, % infoCampfireX, ini/settings.ini, overlay, infoCampfireX
	IniWrite, % infoCampfireY, ini/settings.ini, overlay, infoCampfireY
	IniWrite, % infoDrugsX, ini/settings.ini, overlay, infoDrugsX
	IniWrite, % infoDrugsY, ini/settings.ini, overlay, infoDrugsY
	IniWrite, % infoFishCookedX, ini/settings.ini, overlay, infoFishCookedX
	IniWrite, % infoFishCookedY, ini/settings.ini, overlay, infoFishCookedY
	IniWrite, % infoFishUncookedX, ini/settings.ini, overlay, infoFishUncookedX
	IniWrite, % infoFishUncookedY, ini/settings.ini, overlay, infoFishUncookedY
	IniWrite, % infoPhone, ini/settings.ini, overlay, infoPhone
	IniWrite, % infoFirstaid, ini/settings.ini, overlay, infoFirstaid
	IniWrite, % infoCanister, ini/settings.ini, overlay, infoCanister
	IniWrite, % infoCampfire, ini/settings.ini, overlay, infoCampfire
	IniWrite, % infoDrugs, ini/settings.ini, overlay, infoDrugs
	IniWrite, % infoFishCooked, ini/settings.ini, overlay, infoFishCooked
	IniWrite, % infoFishUncooked, ini/settings.ini, overlay, infoFishUncooked	
	
	IniWrite, % alertOv, ini/settings.ini, overlay, alertOv
	IniWrite, % alertXPos, ini/settings.ini, overlay, alertXPos
	IniWrite, % alertYPos, ini/settings.ini, overlay, alertYPos
	IniWrite, % alertItal, ini/settings.ini, overlay, alertItal
	IniWrite, % alertFont, ini/settings.ini, overlay, alertFont
	IniWrite, % alertSize, ini/settings.ini, overlay, alertSize
	IniWrite, % alertBold, ini/settings.ini, overlay, alertBold
	
	Gui, overlaySettings: Destroy
	
	destroyOverlay()
	reload	
}
return

SettingsGuiClose:
{
	Gui, Settings: Submit, NoHide

	IniWrite, % autoLock, ini/Settings.ini, settings, autoLock
	IniWrite, % autoEngine, ini/Settings.ini, settings, autoEngine
	IniWrite, % autoFill, ini/Settings.ini, settings, autoFill
	IniWrite, % autoLotto, ini/Settings.ini, settings, autoLotto
	IniWrite, % antiSpam, ini/Settings.ini, settings, antiSpam
	IniWrite, % autoUncuff, ini/Settings.ini, settings, autoUncuff
	IniWrite, % autoFrisk, ini/Settings.ini, settings, autoFrisk
	IniWrite, % autoTake, ini/Settings.ini, settings, autoTake
	IniWrite, % autoWanted, ini/Settings.ini, settings, autoWanted
	IniWrite, % autoCustoms, ini/Settings.ini, settings, autoCustoms
	IniWrite, % autoLocal, ini/Settings.ini, settings, autoLocal
	IniWrite, % autoUse, ini/Settings.ini, settings, autoUse
	IniWrite, % fishMode, ini/Settings.ini, settings, fishMode
	Iniwrite, % autoHeal, ini/Settings.ini, settings, autoHeal
	Iniwrite, % autoDrugs, ini/Settings.ini, settings, autoDrugs
	IniWrite, % admin, ini/Settings.ini, settings, admin
	IniWrite, % autoCook, ini/Settings.ini, settings, autoCook
	IniWrite, % autoEquip, ini/Settings.ini, settings, autoEquip
	IniWrite, % autoExecute, ini/Settings.ini, settings, autoExecute
	IniWrite, % autoGate, ini/Settings.ini, settings, autoGate
	IniWrite, % autoFish, ini/Settings.ini, settings, autoFish

	IniWrite, % smsSound, ini/Settings.ini, sounds, smsSound
	IniWrite, % callSound, ini/Settings.ini, sounds, callSound
	IniWrite, % killSound, ini/Settings.ini, sounds, killSound
	IniWrite, % deathSound, ini/Settings.ini, sounds, deathSound
	IniWrite, % backupSound, ini/Settings.ini, sounds, backupSound
	IniWrite, % emergencySound, ini/Settings.ini, sounds, emergencySound
	IniWrite, % leagueSound, ini/Settings.ini, sounds, leagueSound
	
	IniWrite, % damageInfo, ini/Settings.ini, infos, damageInfo
	IniWrite, % paintInfo, ini/Settings.ini, infos, paintInfo
	IniWrite, % wantedInfo, ini/Settings.ini, infos, wantedInfo
	IniWrite, % paketInfo, ini/Settings.ini, infos, paketInfo
	IniWrite, % laserInfo, ini/Settings.ini, infos, laserInfo
	IniWrite, % memberInfo, ini/Settings.ini, infos, memberInfo
	IniWrite, % spotifyPublic, ini/Settings.ini, infos, spotifyPublic
	IniWrite, % spotifyPrivacy, ini/Settings.ini, infos, spotifyPrivacy
	IniWrite, % refillInfo, ini/Settings.ini, infos, refillInfo
	IniWrite, % taskInfo, ini/Settings.ini, infos, taskInfo
	IniWrite, % escInfo, ini/Settings.ini, infos, escInfo
	IniWrite, % afkInfo, ini/Settings.ini, infos, afkInfo

	IniWrite, % lottoNumber, ini/Settings.ini, settings, lottoNumber
	IniWrite, % department, ini/Settings.ini, settings, department
	IniWrite, % ownprefix, ini/Settings.ini, settings, ownprefix
	IniWrite, % primaryColor, ini/Settings.ini, settings, primaryColor
	IniWrite, % secondaryColor, ini/Settings.ini, settings, secondaryColor
	IniWrite, % killMessage, ini/Settings.ini, settings, killMessage
	IniWrite, % deathMessage, ini/Settings.ini, settings, deathMessage
	IniWrite, % killText, ini/Settings.ini, settings, killText
	IniWrite, % deathText, ini/Settings.ini, settings, deathText
	
	if (ownprefix != "") {
		prefix := ownprefix . " "
	}
	
	global primcol := "{" . primaryColor . "}"
	global csecond := "{" . secondaryColor . "}"
	global prefix := "|" . primcol . projectName . cwhite . "| "

	Gui, Settings: Destroy
	reload
}
return

Variables:
{
	Gui, Variables: Destroy

	Gui, Variables: Color, white
	Gui, Variables: Font, S10 CDefault, Verdana
	
	Gui, Variables: Add, Edit, x12 y9 w570 h520 +ReadOnly,
	(
Folgende Variablen können im Killspruch verwendet werden:

| -> Trennvariable für mehrere Chatzeilen
[SLEEP (Zeit in Millisekunden)] -> für Verzögerungen
[LOCAL] -> Im eigenen Chat senden (SendClientMessage())
[ENTER] -> Sendet den Killspruch ab
[Name] -> Aktueller Name
[ID] -> Aktuelle ID
[FPS] -> Aktuelle FPS
[PING] -> Aktueller Ping
[SCORE] -> Aktuelles Level
[CITY] -> Aktuelle Stadt o man ist
[ZONE] -> Aktuelle Zone wo man ist
[POS] -> Aktuelle Stadt & Zone oder Interior wo man ist
[HP] -> Lebensenergie
[VICTIM] -> Getötetes Opfer
[VICTIMFRAK] -> Fraktion des getöteten
[VICTIMWEAP] -> Mit welcher Waffe du ihn getötet hast
[VICTIMWEAPART] -> Artikel (eine, einer, einem (( bezogen auf Waffe )) )
[KILLPLACE] -> Ort des Kills (Kurz)
[KILLPLACEFULL] -> Ort des Kills (mit Fahrzeug)
[MURDERER] -> Dein Mörder
[MURDERERFRAK] -> Fraktion des Mörders
[MURDERERWEAP] -> Waffe des Mörders
[MURDERERWEAPART] -> Artikel (eine, einer, einem (( bezogen auf Waffe )) )
[DEATHPLACE] -> Todesort (Kurz)
[DEATHPLACEFULL] -> Todesort (mit Fahrzeug)
[KILLS] -> Alle Kills
[DEATHS] -> Alle Tode
[DKILLS] -> Tages-Kills
[DDEATHS] -> Tages-Tode
[KD] -> K/D anzeigen
[DKD] -> Tages-KD anzeigen
	)
	Gui, Variables: Add, Button, x12 y549 w130 h40 gVariablesClose, Schließen
	Gui, Variables: Show, w600 h600, %Keybinder%
}
return

VariablesClose:
{
	Gui, Variables: Destroy
}
return

overlay:
{
	Gui, overlay: Destroy

	Gui, overlay: Color, white
	Gui, overlay: Font, S10 CDefault, Verdana
}
return

equipProfiles:
{
	Gui, Equip: Destroy

	Gui, Equip: Color, white
	Gui, Equip: Font, S10 CDefault, Verdana

	Gui, Equip: Add, GroupBox, x10 y10 w600 h280, Ausrüstungsprofile
	Gui, Equip: Add, Text, x20 y30 w580 h115, Hier kannst du dir drei Ausrüsten-Profile zusammenstellen und direkt Ingame abrufen.`nDie ersten beiden Profile sind für den normalen Streifendienst gedacht und können standardmäßig mit F4 bzw. F5 ausgewählt werden.`nIm dritten Profil kann zusätzlich ein UC-Skin gewählt werden und du kannst entscheiden`, ob du mit einer Schutzweste auf Streife gehen möchtest oder nicht.`nDie UC-Ausrüstung kannst du standardmäßig mit F6 auswählen.`nGehealt wirst du aber in jedem Fall.

	Gui, Equip: Add, Text, x30 y160 w70 h20, Profil 1:
	Gui, Equip: Add, DropDownList, x100 y160 w75 h120 vprofile1_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x183 y160 w75 h120 vprofile1_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x266 y160 w75 h120 vprofile1_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x349 y160 w75 h120 vprofile1_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x432 y160 w75 h120 vprofile1_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x515 y160 w75 h120 vprofile1_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Equip: Choose, profile1_1, %profile1_1%
	GuiControl, Equip: Choose, profile1_2, %profile1_2%
	GuiControl, Equip: Choose, profile1_3, %profile1_3%
	GuiControl, Equip: Choose, profile1_4, %profile1_4%
	GuiControl, Equip: Choose, profile1_5, %profile1_5%
	GuiControl, Equip: Choose, profile1_6, %profile1_6%

	Gui, Equip: Add, Text, x30 y190 w70 h20 , Profil 2:
	Gui, Equip: Add, DropDownList, x100 y190 w75 h120 vprofile2_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x183 y190 w75 h120 vprofile2_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x266 y190 w75 h120 vprofile2_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x349 y190 w75 h120 vprofile2_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x432 y190 w75 h120 vprofile2_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x515 y190 w75 h120 vprofile2_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Equip: Choose, profile2_1, %profile2_1%
	GuiControl, Equip: Choose, profile2_2, %profile2_2%
	GuiControl, Equip: Choose, profile2_3, %profile2_3%
	GuiControl, Equip: Choose, profile2_4, %profile2_4%
	GuiControl, Equip: Choose, profile2_5, %profile2_5%
	GuiControl, Equip: Choose, profile2_6, %profile2_6%

	Gui, Equip: Add, Text, x30 y220 w70 h20 , UC-Profil:
	Gui, Equip: Add, DropDownList, x100 y220 w75 h120 vprofile3_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x183 y220 w75 h120 vprofile3_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x266 y220 w75 h120 vprofile3_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x349 y220 w75 h120 vprofile3_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x432 y220 w75 h120 vprofile3_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Equip: Add, DropDownList, x515 y220 w75 h120 vprofile3_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Equip: Choose, profile3_1, %profile3_1%
	GuiControl, Equip: Choose, profile3_2, %profile3_2%
	GuiControl, Equip: Choose, profile3_3, %profile3_3%
	GuiControl, Equip: Choose, profile3_4, %profile3_4%
	GuiControl, Equip: Choose, profile3_5, %profile3_5%
	GuiControl, Equip: Choose, profile3_6, %profile3_6%
	Gui, Equip: Add, Text, x30 y260 w110 h20, UC-Skin (1-39):
	Gui, Equip: Add, Edit, x150 y260 w75 h20 vucSkin, %ucSkin%
	Gui, Equip: Add, CheckBox, x266 y260 w110 h20 vequipArmour Checked%equipArmour%, Schutzweste

	Gui, Equip: Add, Button, x480 y300 w130 h40 gEquipClose, Schließen
	Gui, Equip: Show, h360 w660, %projectName% - Ausrüstprofile - Version %version%
}
return

EquipClose:
{
	Gui, Equip: Submit, NoHide

	IniWrite, %profile1_1%, ini/Settings.ini, Ausrüstungsprofile, Profil1_1
	IniWrite, %profile1_2%, ini/Settings.ini, Ausrüstungsprofile, Profil1_2
	IniWrite, %profile1_3%, ini/Settings.ini, Ausrüstungsprofile, Profil1_3
	IniWrite, %profile1_4%, ini/Settings.ini, Ausrüstungsprofile, Profil1_4
	IniWrite, %profile1_5%, ini/Settings.ini, Ausrüstungsprofile, Profil1_5
	IniWrite, %profile1_6%, ini/Settings.ini, Ausrüstungsprofile, Profil1_6
	
	IniWrite, %profile2_1%, ini/Settings.ini, Ausrüstungsprofile, Profil2_1
	IniWrite, %profile2_2%, ini/Settings.ini, Ausrüstungsprofile, Profil2_2
	IniWrite, %profile2_3%, ini/Settings.ini, Ausrüstungsprofile, Profil2_3
	IniWrite, %profile2_4%, ini/Settings.ini, Ausrüstungsprofile, Profil2_4
	IniWrite, %profile2_5%, ini/Settings.ini, Ausrüstungsprofile, Profil2_5
	IniWrite, %profile2_6%, ini/Settings.ini, Ausrüstungsprofile, Profil2_6
	
	IniWrite, %profile3_1%, ini/Settings.ini, Ausrüstungsprofile, Profil3_1
	IniWrite, %profile3_2%, ini/Settings.ini, Ausrüstungsprofile, Profil3_2
	IniWrite, %profile3_3%, ini/Settings.ini, Ausrüstungsprofile, Profil3_3
	IniWrite, %profile3_4%, ini/Settings.ini, Ausrüstungsprofile, Profil3_4
	IniWrite, %profile3_5%, ini/Settings.ini, Ausrüstungsprofile, Profil3_5
	IniWrite, %profile3_6%, ini/Settings.ini, Ausrüstungsprofile, Profil3_6
	
	IniWrite, %ucSkin%, ini/Settings.ini, Ausrüstungsprofile, UCSkin
	IniWrite, %equipArmour%, ini/Settings.ini, Ausrüstungsprofile, Schutzweste
	
	Gui, Equip: Destroy
	reload
}
return

HotkeysGUI:
{
	Gui, Hotkeys: Destroy
	
	Gui, Hotkeys: Color, white
	Gui, Hotkeys: Font, S10 CDefault, Verdana
	
	Gui, Hotkeys: Add, Button, x10 y550 w130 h40 gOwnHotkeysGUI, Eigene Hotkeys
	Gui, Hotkeys: Add, Button, x150 y550 w130 h40 gResetHotkeys, Zurücksetzen
	Gui, Hotkeys: Add, Button, x480 y550 w130 h40 gHotkeysGuiClose, Schließen
	
	if (admin) {
		Gui, Hotkeys: Add, Tab, x0 y0 w620 h540, Seite 1|Seite 2|Seite 3|Seite 4|Seite 5|Admin
	} else {
		Gui, Hotkeys: Add, Tab, x0 y0 w620 h540, Seite 1|Seite 2|Seite 3|Seite 4|Seite 5
	}
	
	Gui, Hotkeys: Tab, Seite 1
	Gui, Hotkeys: Add, Text, x10 y30 w170 h20 , Wtds: Angriff
	Gui, Hotkeys: Add, Text, x10 y60 w170 h20 , Wtds: Flucht
	Gui, Hotkeys: Add, Text, x10 y90 w170 h20 , Wtds: Verweigerung
	Gui, Hotkeys: Add, Text, x10 y120 w170 h20 , Wtds: Behinderung
	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , Wtds: Mats/Drogen
	Gui, Hotkeys: Add, Text, x10 y180 w170 h20 , Wtds: Drogenkonsum
	Gui, Hotkeys: Add, Text, x10 y210 w170 h20 , Wtds: Beihilfe
	Gui, Hotkeys: Add, Text, x10 y240 w170 h20 , Wtds: Handel
	Gui, Hotkeys: Add, Text, x10 y270 w170 h20 , Wtds: Einbruch
	Gui, Hotkeys: Add, Text, x10 y300 w170 h20 , Wtds: Zollflucht
	Gui, Hotkeys: Add, Text, x10 y330 w170 h20 , Wtds: Fahrzeugdiebstahl
	Gui, Hotkeys: Add, Text, x10 y360 w170 h20 , Wtds: Beleidigung
	Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Wtds: Waffengebrauch
	Gui, Hotkeys: Add, Text, x10 y420 w170 h20 , Wtds: Waffenbesitz
	Gui, Hotkeys: Add, Text, x10 y450 w170 h20 , Wtds: Bestechung
	Gui, Hotkeys: Add, Text, x10 y480 w170 h20 , Wtds: ESC-Flucht
	Gui, Hotkeys: Add, Text, x10 y510 w170 h20 , Wtds: Entführung
	Gui, Hotkeys: Add, Hotkey, x190 y30 w120 h20 vatkWantedsHotkey gSaveHotkeyLabel, %atkWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y60 w120 h20 vescapeWantedsHotkey gSaveHotkeyLabel, %escapeWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y90 w120 h20 vrefusalWantedsHotkey gSaveHotkeyLabel, %refusalWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y120 w120 h20 vobstructionWantedsHotkey gSaveHotkeyLabel, %obstructionWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y150 w120 h20 vpossessionWantedsHotkey gSaveHotkeyLabel, %possessionWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y180 w120 h20 vdrugConsumptionWantedsHotkey gSaveHotkeyLabel, %drugConsumptionWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y210 w120 h20 vescapeAidWantedsHotkey gSaveHotkeyLabel, %escapeAidWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y240 w120 h20 vtradeWantedsHotkey gSaveHotkeyLabel, %tradeWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y270 w120 h20 vunauthorizedEnterWantedsHotkey gSaveHotkeyLabel, %unauthorizedEnterWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y300 w120 h20 vcustomsEscapeWantedsHotkey gSaveHotkeyLabel, %customsEscapeWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y330 w120 h20 vvehicleTheftWantedsHotkey gSaveHotkeyLabel, %vehicleTheftWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y360 w120 h20 vinsultingWantedsHotkey gSaveHotkeyLabel, %insultingWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y390 w120 h20 vuseOfWeaponsWantedsHotkey gSaveHotkeyLabel, %useOfWeaponsWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y420 w120 h20 vpossessionOfWeaponsWantedsHotkey gSaveHotkeyLabel, %possessionOfWeaponsWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y450 w120 h20 vbriberyWantedsHotkey gSaveHotkeyLabel, %briberyWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y480 w120 h20 vescWantedsHotkey gSaveHotkeyLabel, %escWantedsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y510 w120 h20 vkidnapWantedsHotkey gSaveHotkeyLabel, %kidnapWantedsNoMods%
	Gui, Hotkeys: Add, Text, x320 y30 w170 h20 , Punkte: SVG
	Gui, Hotkeys: Add, Text, x320 y60 w170 h20 , Punkte: Falsche Seite
	Gui, Hotkeys: Add, Text, x320 y90 w170 h20 , Punkte: Geschwindigkeit
	Gui, Hotkeys: Add, Text, x320 y120 w170 h20 , Punkte: Abseits
	Gui, Hotkeys: Add, Text, x320 y150 w170 h20 , Punkte: Licht
	Gui, Hotkeys: Add, Text, x320 y180 w170 h20 , Punkte: Parkverbot
	Gui, Hotkeys: Add, Text, x320 y210 w170 h20 , Wanted Ticket (manuell)
	Gui, Hotkeys: Add, Text, x320 y240 w170 h20 , Wanted Ticket (autom.)
	Gui, Hotkeys: Add, Text, x320 y270 w170 h20 , Punkte clearen
	Gui, Hotkeys: Add, Text, x320 y300 w170 h20 , Wanteds clearen	
	Gui, Hotkeys: Add, Text, x320 y330 w170 h20 , Notruf auto. ann.
	Gui, Hotkeys: Add, Text, x320 y360 w170 h20 , Notruf ann.
	Gui, Hotkeys: Add, Text, x320 y390 w170 h20 , Autom. Systeme beend.
	Gui, Hotkeys: Add, Text, x320 y420 w170 h20 , Keybinder pausieren	
	Gui, Hotkeys: Add, Text, x320 y450 w170 h20 , Zivil / Duty gehen
	Gui, Hotkeys: Add, Text, x320 y480 w170 h20 , Job-Befehle
	Gui, Hotkeys: Add, Hotkey, x490 y30 w120 h20 vroadHazardPointsHotkey gSaveHotkeyLabel, %roadHazardPointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y60 w120 h20 vwrongSitePointsHotkey gSaveHotkeyLabel, %wrongSitePointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y90 w120 h20 vspeedPointsHotkey gSaveHotkeyLabel, %speedPointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y120 w120 h20 voffsitePointsHotkey gSaveHotkeyLabel, %offsitePointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y150 w120 h20 vlightPointsHotkey gSaveHotkeyLabel, %lightPointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y180 w120 h20 vnoParkingPointsHotkey gSaveHotkeyLabel, %noParkingPointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y210 w120 h20 vgiveQuickTicketHotkey gSaveHotkeyLabel, %giveQuickTicketNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y240 w120 h20 vgiveQUickTicketAutoHotkey gSaveHotkeyLabel, %giveQUickTicketAutoNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y270 w120 h20 vclearPointsHotkey gSaveHotkeyLabel, %clearPointsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y300 w120 h20 vclearWantedsHotkey gSaveHotkeyLabel, %clearWantedsNoMods%	
	Gui, Hotkeys: Add, Edit, x490 y330 w120 h20 ReadOnly, %autoAcceptEmergencyNoMods%
	acceptEmergencyNoMods := StrReplace(acceptEmergencyNoMods, "+", "UMSCHALT + ")
	Gui, Hotkeys: Add, Edit, x490 y360 w120 h20 ReadOnly, %acceptEmergencyNoMods%	
	Gui, Hotkeys: Add, Hotkey, x490 y390 w120 h20 vstopAutomaticSystemsHotkey gSaveHotkeyLabel, %stopAutomaticSystemsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y420 w120 h20 vpauseHotkey gSaveHotkeyLabel, %pauseNoMods%	
	Gui, Hotkeys: Add, Hotkey, x490 y450 w120 h20 vzivicHotkey gSaveHotkeyLabel, %zivicNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y480 w120 h20 vjobexecuteHotkey gSaveHotkeyLabel, %jobexecuteNoMods%

	Gui, Hotkeys: Tab, Seite 2
	Gui, Hotkeys: Add, Text, x10 y30 w170 h20 , Motorsystem
	Gui, Hotkeys: Add, Text, x10 y60 w170 h20 , Fahrzeugtür
	Gui, Hotkeys: Add, Text, x10 y90 w170 h20 , Fahrzeuglichter
	Gui, Hotkeys: Add, Text, x10 y120 w170 h20 , UC-Licht
	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , UCA-Licht
	Gui, Hotkeys: Add, Text, x10 y180 w170 h20 , Tempomat de-/aktivieren
	Gui, Hotkeys: Add, Text, x10 y210 w170 h20 , Frakmember anzeigen
	Gui, Hotkeys: Add, Text, x10 y240 w170 h20 , Crewmember anzeigen
	Gui, Hotkeys: Add, Text, x10 y270 w170 h20 , Handy an-/ausschalten
	Gui, Hotkeys: Add, Text, x10 y300 w170 h20 , Drogen usen
	Gui, Hotkeys: Add, Text, x10 y330 w170 h20 , Fische essen
	Gui, Hotkeys: Add, Text, x10 y360 w170 h20 , Erste-Hilfe-Paket ben.
	Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Countdown starten
	Gui, Hotkeys: Add, Text, x10 y420 w170 h20 , Stoppuhr starten	
	Gui, Hotkeys: Add, Text, x10 y450 w170 h20 , Dankeschön!
	Gui, Hotkeys: Add, Text, x10 y480 w170 h20 , Entschuldigung!
	Gui, Hotkeys: Add, Text, x10 y510 w170 h20 , Eingabe wiederholen
	Gui, Hotkeys: Add, Hotkey, x190 y30 w120 h20 vmotorSystemHotkey gSaveHotkeyLabel, %motorSystemNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y60 w120 h20 vlockHotkey gSaveHotkeyLabel, %lockNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y90 w120 h20 vlightHotkey gSaveHotkeyLabel, %lightNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y120 w120 h20 vuclightHotkey gSaveHotkeyLabel, %uclightNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y150 w120 h20 vucaHotkey gSaveHotkeyLabel, %ucaNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y180 w120 h20 vtempomatHotkey gSaveHotkeyLabel, %tempomatNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y210 w120 h20 vmembersHotkey gSaveHotkeyLabel, %membersNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y240 w120 h20 vcrewmembersHotkey gSaveHotkeyLabel, %crewmembersNoMods%	
	Gui, Hotkeys: Add, Hotkey, x190 y270 w120 h20 vtogCellphoneHotkey gSaveHotkeyLabel, %togCellphoneNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y300 w120 h20 vuseDrugsHotkey gSaveHotkeyLabel, %useDrugsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y330 w120 h20 veatFishHotkey gSaveHotkeyLabel, %eatFishNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y360 w120 h20 vfirstAidHotkey gSaveHotkeyLabel, %firstAidNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y390 w120 h20 vcountdownHotkey gSaveHotkeyLabel, %countdownNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y420 w120 h20 vstopwatchHotkey gSaveHotkeyLabel, %stopwatchNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y450 w120 h20 vthanksHotkey gSaveHotkeyLabel, %thanksNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y480 w120 h20 vsorryHotkey gSaveHotkeyLabel, %sorryNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y510 w120 h20 vrepeatHotkey gSaveHotkeyLabel, %repeatNoMods%
	Gui, Hotkeys: Add, Text, x320 y30 w170 h20 , Heilen
	Gui, Hotkeys: Add, Text, x320 y60 w170 h20 , Ausrüsten
	Gui, Hotkeys: Add, Text, x320 y90 w170 h20 , Ausrüsten (Profil 1)
	Gui, Hotkeys: Add, Text, x320 y120 w170 h20 , Ausrüsten (Profil 2)
	Gui, Hotkeys: Add, Text, x320 y150 w170 h20 , Ausrüsten (Profil 3)
	Gui, Hotkeys: Add, Text, x320 y180 w170 h20 , Backup anfordern
	Gui, Hotkeys: Add, Text, x320 y210 w170 h20 , Backup (WH) anfordern
	Gui, Hotkeys: Add, Text, x320 y240 w170 h20 , BK nicht mehr benötigt	
	Gui, Hotkeys: Add, Text, x320 y270 w170 h20 , Kofferraum öffnen
	Gui, Hotkeys: Add, Text, x320 y300 w170 h20 , Kofferraum durchsuchen
	Gui, Hotkeys: Add, Text, x320 y330 w170 h20 , Kofferr. öffnen lassen
	Gui, Hotkeys: Add, Text, x320 y360 w170 h20 , /auf
	Gui, Hotkeys: Add, Text, x320 y390 w170 h20 , Zoll öffnen
	Gui, Hotkeys: Add, Text, x320 y420 w170 h20 , Zollstation schließen
	Gui, Hotkeys: Add, Text, x320 y450 w170 h20 , Zollstation öffnen
	Gui, Hotkeys: Add, Text, x320 y480 w170 h20 , Zollst. geschl. (/gov)
	Gui, Hotkeys: Add, Text, x320 y510 w170 h20 , Zollst. geöffnet (/gov)
	Gui, Hotkeys: Add, Hotkey, x490 y30 w120 h20 vhealHotkey gSaveHotkeyLabel, %healNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y60 w120 h20 vequipHotkey gSaveHotkeyLabel, %equipNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y90 w120 h20 vequipProfile1Hotkey gSaveHotkeyLabel, %equipProfile1NoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y120 w120 h20 vequipProfile2Hotkey gSaveHotkeyLabel, %equipProfile2NoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y150 w120 h20 vequipProfile3Hotkey gSaveHotkeyLabel, %equipProfile3NoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y180 w120 h20 vbackupHotkey gSaveHotkeyLabel, %backupNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y210 w120 h20 vbackupWhHotkey gSaveHotkeyLabel, %backupWhNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y240 w120 h20 vnoBackupHotkey gSaveHotkeyLabel, %noBackupNoMods%	
	Gui, Hotkeys: Add, Hotkey, x490 y270 w120 h20 vopenTrunkHotkey gSaveHotkeyLabel, %openTrunkNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y300 w120 h20 vcheckTrunkHotkey gSaveHotkeyLabel, %checkTrunkNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y330 w120 h20 vaskTrunkOpenHotkey gSaveHotkeyLabel, %askTrunkOpenNoMods%	
	Gui, Hotkeys: Add, Hotkey, x490 y360 w120 h20 vopenDoorHotkey gSaveHotkeyLabel, %openDoorNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y390 w120 h20 vopenCustomsHotkey gSaveHotkeyLabel, %openCustomsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y420 w120 h20 vcloseCustomsControlHotkey gSaveHotkeyLabel, %closeCustomsControlNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y450 w120 h20 vopenCustomsControlHotkey gSaveHotkeyLabel, %openCustomsControlNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y480 w120 h20 vgovClosedCustomsHotkey gSaveHotkeyLabel, %govClosedCustomsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y510 w120 h20 vgovOpenedCustomsHotkey gSaveHotkeyLabel, %govOpenedCustomsNoMods%
	
	Gui, Hotkeys: Tab, Seite 3
	Gui, Hotkeys: Add, Text, x10 y30 w170 h20 , Megafon: Folgen
	Gui, Hotkeys: Add, Text, x10 y60 w170 h20 , Megafon: Kontrolle
	Gui, Hotkeys: Add, Text, x10 y90 w170 h20 , Megafon: Anhalten
	Gui, Hotkeys: Add, Text, x10 y120 w170 h20 , Megafon: Schießen
	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , Megafon: Aussteigen
	Gui, Hotkeys: Add, Text, x10 y180 w170 h20 , Megafon: Straße räumen
	Gui, Hotkeys: Add, Text, x10 y210 w170 h20 , Megafon: Waffen weg
	Gui, Hotkeys: Add, Text, x10 y240 w170 h20 , Megafon: Verlassen
	Gui, Hotkeys: Add, Text, x10 y270 w170 h20 , Megafon: Verfolung
	Gui, Hotkeys: Add, Text, x10 y300 w170 h20 , Megafon: StVO
	Gui, Hotkeys: Add, Text, x10 y330 w170 h20 , /refuse
	Gui, Hotkeys: Add, Text, x10 y360 w170 h20 , /ram
	Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Position (/d)
	Gui, Hotkeys: Add, Text, x10 y420 w170 h20 , Position (/f)
	Gui, Hotkeys: Add, Text, x10 y450 w170 h20 , Position (/r)
	Gui, Hotkeys: Add, Text, x10 y480 w170 h20 , Auftrag übernehmen
	Gui, Hotkeys: Add, Text, x10 y510 w170 h20 , Auftrag erledigt
	Gui, Hotkeys: Add, Hotkey, x190 y30 w120 h20 vmegaFollowHotkey gSaveHotkeyLabel, %megaFollowNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y60 w120 h20 vmegaControlHotkey gSaveHotkeyLabel, %megaControlNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y90 w120 h20 vmegaStopHotkey gSaveHotkeyLabel, %megaStopNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y120 w120 h20 vmegaByNameHotkey gSaveHotkeyLabel, %megaByNameNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y150 w120 h20 vmegaGetOutOfCarHotkey gSaveHotkeyLabel, %megaGetOutOfCarNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y180 w120 h20 vmegaClearHotkey gSaveHotkeyLabel, %megaClearNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y210 w120 h20 vmegaWeaponsHotkey gSaveHotkeyLabel, %megaWeaponsNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y240 w120 h20 vmegaLeaveHotkey gSaveHotkeyLabel, %megaLeaveNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y270 w120 h20 vmegaStopFollowHotkey gSaveHotkeyLabel, %megaStopFollowNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y300 w120 h20 vmegaRoadTrafficActHotkey gSaveHotkeyLabel, %megaRoadTrafficActNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y330 w120 h20 vrefuse gSaveHotkeyLabel, %refuseNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y360 w120 h20 vramHotkey gSaveHotkeyLabel, %ramNoMods%	
	Gui, Hotkeys: Add, Hotkey, x190 y390 w120 h20 vpositionHotkey gSaveHotkeyLabel, %positionNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y420 w120 h20 vfPositionHotkey gSaveHotkeyLabel, %fPositionNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y450 w120 h20 vrPositionHotkey gSaveHotkeyLabel, %rPositionNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y480 w120 h20 vacceptJobHotkey gSaveHotkeyLabel, %acceptJobNoMods%
	Gui, Hotkeys: Add, Hotkey, x190 y510 w120 h20 vdoneJobHotkey gSaveHotkeyLabel, %doneJobNoMods%
	Gui, Hotkeys: Add, Text, x320 y30 w170 h20 , Einsperren (auto)
	Gui, Hotkeys: Add, Text, x320 y60 w170 h20 , Einsperren
	Gui, Hotkeys: Add, Text, x320 y90 w170 h20 , Verbrecherliste anzeigen
	Gui, Hotkeys: Add, Text, x320 y120 w170 h20 , Verbr.liste zurücksetzen
	Gui, Hotkeys: Add, Text, x320 y150 w170 h20 , Festnehmen
	Gui, Hotkeys: Add, Text, x320 y180 w170 h20 , Freilassen (/uncuff)
	Gui, Hotkeys: Add, Text, x320 y210 w170 h20 , Kontrollieren
	Gui, Hotkeys: Add, Text, x320 y240 w170 h20 , Kontrolle anfordern
	Gui, Hotkeys: Add, Text, x320 y270 w170 h20 , Scheine anfordern
	Gui, Hotkeys: Add, Text, x320 y300 w170 h20 , Vielen Dank Koop.
	Gui, Hotkeys: Add, Text, x320 y330 w170 h20 , Aus dem Auto aussteigen
	Gui, Hotkeys: Add, Text, x320 y360 w170 h20 , Im Auto bleiben
	Gui, Hotkeys: Add, Text, x320 y390 w170 h20 , Festgenommen: Fahrzeug
	Gui, Hotkeys: Add, Text, x320 y420 w170 h20 , Festgenommen: Zellen
	Gui, Hotkeys: Add, Text, x320 y450 w170 h20 , Waffen einstecken
	Gui, Hotkeys: Add, Text, x320 y480 w170 h20 , Automatisches Grab
	Gui, Hotkeys: Add, Text, x320 y510 w170 h20 , /grab
	Gui, Hotkeys: Add, Hotkey, x490 y30 w120 h20 vautoImprisonHotkey gSaveHotkeyLabel, %autoImprisonNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y60 w120 h20 vimprisonHotkey gSaveHotkeyLabel, %imprisonNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y90 w120 h20 varrestSlotsHotkey gSaveHotkeyLabel, %arrestSlotsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y120 w120 h20 vresetArrestSlotsHotkey gSaveHotkeyLabel, %resetArrestSlotsNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y150 w120 h20 varrestHotkey gSaveHotkeyLabel, %arrestNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y180 w120 h20 vuncuffHotkey gSaveHotkeyLabel, %uncuffNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y210 w120 h20 vcheckHotkey gSaveHotkeyLabel, %checkNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y240 w120 h20 vaskCheckHotkey gSaveHotkeyLabel, %askCheckNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y270 w120 h20 vaskPapersHotkey gSaveHotkeyLabel, %askPapersNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y300 w120 h20 vcooperationHotkey gSaveHotkeyLabel, %cooperationNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y330 w120 h20 vgetOutOfCarHotkey gSaveHotkeyLabel, %getOutOfCarNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y360 w120 h20 vnotAllowedToGoInCarHotkey gSaveHotkeyLabel, %notAllowedToGoInCarNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y390 w120 h20 varrestedCarHotkey gSaveHotkeyLabel, %arrestedCarNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y420 w120 h20 varrestedByName gSaveHotkeyLabel, %arrestedByNameNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y450 w120 h20 vputWeaponsAwayHotkey gSaveHotkeyLabel, %putWeaponsAwayNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y480 w120 h20 vgrabHotkey gSaveHotkeyLabel, %grabNoMods%
	Gui, Hotkeys: Add, Hotkey, x490 y510 w120 h20 vmanuellGrabHotkey gSaveHotkeyLabel, %manuellGrabNoMods%
	
	Gui, Hotkeys: Tab, Seite 4

	Gui, Hotkeys: Add, Text, x10 y30 w170 h20 , /wanted
	Gui, Hotkeys: Add, Text, x10 y60 w170 h20 , /wanted LS
	Gui, Hotkeys: Add, Text, x10 y90 w170 h20 , /wanted SF
	Gui, Hotkeys: Add, Text, x10 y120 w170 h20 , /wanted LV
	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , /wanted INT
	
	Gui, Hotkeys: Add, Edit, x190 y30 w120 h20 +ReadOnly, LWin
	Gui, Hotkeys: Add, Edit, x190 y60 w120 h20 +ReadOnly, LWin + 1
	Gui, Hotkeys: Add, Edit, x190 y90 w120 h20 +ReadOnly, LWin + 2
	Gui, Hotkeys: Add, Edit, x190 y120 w120 h20 +ReadOnly, LWin + 3
	Gui, Hotkeys: Add, Edit, x190 y150 w120 h20 +ReadOnly, LWin + 4
	
	Gui, Hotkeys: Tab, Seite 5

	Gui, Hotkeys: Add, GroupBox, x10 y30 w600 h100, Information
	
	Gui, Hotkeys: Add, Text, x20 y45 w580 h80, Diese Wantedvergaben sind nicht die Gewöhnlichen, bei Drücken der Kombination erhält der Spieler, welcher sich auf /afind befindet automatsich Wanteds bzg. der jeweiligen Hotkeytaste. ACHTUNG: Du musst hierbei Numpad nutzen.`nDiese Hotkeys können nicht geändert werden. Ebenfalls sind nicht alle, nur die Wichtigsten, enthalten.

	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , Wtds: Angriff
	Gui, Hotkeys: Add, Edit, x190 y150 w120 h20 ReadOnly, STRG + ALT + 1 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y180 w170 h20 , Wtds: Flucht
	Gui, Hotkeys: Add, Edit, x190 y180 w120 h20 ReadOnly, STRG + ALT + 2 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y210 w170 h20 , Wtds: Verweigerung
	Gui, Hotkeys: Add, Edit, x190 y210 w120 h20 ReadOnly, STRG + ALT + 3 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y240 w170 h20 , Wtds: Behinderung
	Gui, Hotkeys: Add, Edit, x190 y240 w120 h20 ReadOnly, STRG + ALT + 4 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y270 w170 h20 , Wtds: Drogenkonsum
	Gui, Hotkeys: Add, Edit, x190 y270 w120 h20 ReadOnly, STRG + ALT + 6 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y300 w170 h20 , Wtds: Auto. Beihilfe
	Gui, Hotkeys: Add, Edit, x190 y300 w120 h20 ReadOnly, STRG + ALT + 7 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y330 w170 h20 , Wtds: Handel 
	Gui, Hotkeys: Add, Edit, x190 y330 w120 h20 ReadOnly, STRG + ALT + 8 (Zehnertastatur)
	
	Gui, Hotkeys: Add, Text, x10 y360 w170 h20 , Wtds: Zollflucht 
	Gui, Hotkeys: Add, Edit, x190 y360 w120 h20 ReadOnly, STRG + ALT + Z
	
	Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Wtds: Waffengebrauch 
	Gui, Hotkeys: Add, Edit, x190 y390 w120 h20 ReadOnly, STRG + ALT + I		
	
	Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Wtds: Waffenbesitz 
	Gui, Hotkeys: Add, Edit, x190 y390 w120 h20 ReadOnly, STRG + ALT + U		
	
	Gui, Hotkeys: Add, Text, x10 y420 w170 h20 , Wtds: Beleidigung 
	Gui, Hotkeys: Add, Edit, x190 y420 w120 h20 ReadOnly, STRG + ALT + H		

	Gui, Hotkeys: Add, Text, x10 y450 w170 h20 , Wtds: ESC Flucht 
	Gui, Hotkeys: Add, Edit, x190 y450 w120 h20 ReadOnly, STRG + ALT + E	
	
	if (admin) {
		Gui, Hotkeys: Tab, Admin
	
		Gui, Hotkeys: Add, GroupBox, x10 y30 w600 h100, Information
		
		Gui, Hotkeys: Add, Text, x20 y45 w580 h80, Diese Funktionen sind einschließlich Teammitgliedern vorenthalten. Die Ticket Keys können, wie alle anderen auch, selbst definiert werden. Jedoch dürfen diese sich nicht überschneiden!
	
		Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , Ticket 1 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y150 w120 h20 vaccept1Hotkey gSaveHotkeyLabel, %accept1NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y180 w170 h20 , Ticket 2 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y180 w120 h20 vaccept2Hotkey gSaveHotkeyLabel, %accept2NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y210 w170 h20 , Ticket 3 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y210 w120 h20 vaccept3Hotkey gSaveHotkeyLabel, %accept3NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y240 w170 h20 , Ticket 4 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y240 w120 h20 vaccept4Hotkey gSaveHotkeyLabel, %accept4NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y270 w170 h20 , Ticket 5 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y270 w120 h20 vaccept5Hotkey gSaveHotkeyLabel, %accept5NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y300 w170 h20 , Ticket 6 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y300 w120 h20 vaccept6Hotkey gSaveHotkeyLabel, %accept6NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y330 w170 h20 , Ticket 7 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y330 w120 h20 vaccept7Hotkey gSaveHotkeyLabel, %accept7NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y360 w170 h20 , Ticket 8 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y360 w120 h20 vaccept8Hotkey gSaveHotkeyLabel, %accept8NoMods%
		
		Gui, Hotkeys: Add, Text, x10 y390 w170 h20 , Ticket 9 annehmen
		Gui, Hotkeys: Add, Hotkey, x190 y390 w120 h20 vaccept9Hotkey gSaveHotkeyLabel, %accept9NoMods%
	}

	
	Menu, MenuBar, Add, &Informationen, HotkeyInformations
	
	Gui, Hotkeys: Menu, MenuBar
	
	Gui, Hotkeys: Show, h600 w620, %projectName% - Hotkeys - Version %version%
}
return

HotkeysGuiClose:
{
	Gui, Hotkeys: Destroy
}
return

HotkeyInformations:
{
	MsgBox, 64, Informationen zu Hotkeys, 
	(LTrim
		Hier können die Hotkeys selbstständig definiert werden.
		
		Manche Hotkeys können nicht im GUI verändert/definiert werden, da AHK nicht die Möglichkeit dazu gibt (oder diese einfach nicht angezeigt werden können).
		Stattdessen können diese alternativ in der ini/Hotkeys.ini eingetragen werden.
		Beispielsweise können so auch die Maustasten "xButton1" und "xButton2" belegt werden, was hier im GUI nicht möglich ist.
		
		Ein Speichern ist nicht notwendig, da dies automatisch geschieht.
		Solltest du aber manuelle Änderungen in der ini/Hotkeys.ini durchgeführt haben, musst du den Keybinder neustarten!
	)
}
return

ResetHotkeys:
{
	FileDelete, ini/Hotkeys.ini
	MsgBox, 64, Zurücksetzen erfolgreich, Die Hotkeys wurden erfolgreich auf die Standardbelegungen zurückgesetzt, der Keybinder startet nun neu!
	Reload
}
return

SaveHotkeyLabel:
{
	Gui, Hotkeys: Submit, NoHide
	
	name := SubStr(A_GuiControl, 1, -6)
	hk := %A_GuiControl%
	
	if hk in +,^,!,+^,+!,^!,+^!
		return
	
	if (registeredHotkeys.HasKey(name)) {
		oldKey := registeredHotkeys[name]
		
		Hotkey, %oldKey%, %name%Label, Off
		
		registeredHotkeys.Delete(name)
	}
	
	%name%NoMods := ""
	
	if (hk == "") {
		IniWrite, ---, ini/Hotkeys.ini, Hotkeys, %name%
	} else {
		alreadyRegistered := false
		
		for key, value in registeredHotkeys {
			hk2 := StrReplace(hk, "~", "")
			value2 := StrReplace(value, "~", "")
			
			if (hk2 = value2 && StrLen(hk2) == StrLen(value2)) {
				alreadyRegistered := true
				alreadyRegisteredKey := key
				break
			}
		}
		
		if (!InStr(hk, "F") && !InStr(hk, "!"))
			hk := "~" . hk
		
		if (!alreadyRegistered) {
			Hotkey, %hk%, %name%Label
			StringReplace, %name%NoMods, hk, ~
			IniWrite, %hk%, ini/Hotkeys.ini, Hotkeys, %name%
			
			registeredHotkeys[name] := hk
		} else {
			IniWrite, ---, ini/Hotkeys.ini, Hotkeys, %name%
			GuiControl, Hotkeys: , %A_GuiControl%, 
			
			if (RegExMatch(alreadyRegisteredKey, "ownHotkey(\d+)", key_)) {
				hotkeyName := "eigenen Hotkey " . key_1
			} else {
				hotkeyName := "Hotkey " . alreadyRegisteredKey
			}
			
			message := "Der Hotkey für " . name . " (" . getUserFriendlyHotkeyName(hk) . ") konnte nicht aktiviert werden, da er bereits für den " . hotkeyName . " registriert ist!"
			
			MsgBox, 64, Speicherung, %message%
		}
	}
}
return

OwnHotkeysGUI:
{
	Gui, OwnHotkeys: Destroy
	
	Gui, OwnHotkeys: Color, white
	Gui, OwnHotkeys: Font, S10 CDefault, Verdana
	
	Gui, OwnHotkeys: Add, Button, x10 y530 w130 h40 gOwnHotkeysSave, Speichern
	Gui, OwnHotkeys: Add, Button, x870 y530 w130 h40 gOwnHotkeysGuiClose, Schließen
	
	Gui, OwnHotkeys: Add, Tab, x10 y10 w990 h510, Seite 1|Seite 2|Seite 3
	
	Gui, OwnHotkeys: Tab, Seite 1
	
	Loop, 8 {
		index := A_Index
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x20 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x20 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x130 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Loop, 8 {
		index := A_Index + 8
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x510 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x510 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x620 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Gui, OwnHotkeys: Tab, Seite 2
	
	Loop, 8 {
		index := A_Index + 16
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x20 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x20 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x130 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Loop, 8 {
		index := A_Index + 24
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x510 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x510 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x620 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Gui, OwnHotkeys: Tab, Seite 3
	
	Loop, 8 {
		index := A_Index + 32
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x20 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x20 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x130 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Loop, 8 {
		index := A_Index + 40
		active := ownHotkey%index%Active
		y1 := -20 + (A_Index * 60)
		y2 := 10 + (A_Index * 60)
		
		Gui, OwnHotkeys: Add, CheckBox, x510 y%y1% w100 h20 vownHotkey%index%Active Checked%active%, Hotkey %index%
		Gui, OwnHotkeys: Add, Hotkey, x510 y%y2% w100 h20 vownHotkey%index%,% ownHotkey%index%NoMods
		Gui, OwnHotkeys: Add, Edit, x620 y%y1% w370 h50 vownHotkey%index%Text,% ownHotkey%index%Text
	}
	
	Menu, OwnHotkeysInformations, Add, &Informationen, OwnHotkeysInformations
	
	Gui, OwnHotkeys: Menu, OwnHotkeysInformations
	
	Gui, OwnHotkeys: Show, h580 w1010, %projectName% - Eigene Hotkeys - Version %version%
}
return

OwnHotkeysInformations:
{
	MsgBox, 64, Informationen zu eigenen Hotkeys, 
	(LTrim
		Hier können eigene Hotkeys definiert werden.
		
		Das Setzen eines Hakens an der entsprechendene Stelle aktiviert den Hotkey. Im Feld darunter kann der Hotkey eingegeben werden, welcher Ingame gedrückt werden muss, damit der Text in dem Feld daneben ausgeführt wird. Im großen Textfeld daneben kann der Text eingegeben werden, welcher beim Ausführen Ingame an den Chat gesendet wird. Jede Zeile entspricht einer Chat-Nachricht.
		
		Es können folgende Platzhalter verwendet werden:
		[name] - Dein Name
		[id] - Deine ID
		[ping] - Dein Ping
		[fps] - Deine FPS
		[hp] - Deine HP
		[armour] - Deine Armour
		[zone] - Deine Zone
		[city] - Deine Stadt
		[location] - Dein Autenthaltsort (Zone+Stadt)
		[money] - Dein Bargeld
		[skin] - Deine Skin-ID
		[weaponid] - Weapon-ID der aktuellen Waffe
		[weapon] - Name der aktuellen Waffe
		[freezed] - ja/nein, ob man gefreezed ist
		[vhealth] - Fahrzeugzustand in Prozent
		[vmodelid] - Fahrzeug-Modell-ID
		[vmodel] - Fahrzeug-Modell-Name
		[vspeed] - Fahrzeug-Geschwindigkeit
		[fishtime] - Fisch-Zeit
		
		[motor] - Führt das Motor-System aus
		[usepak] - Benutzt ein Erste-Hilfe-Paket (nur wenn weniger als 95 HP)
		[eatfish] - Isst den nächsten Fisch (Nummer wird auch erhöht)
		
		[sleep Zeit] - Macht eine Pause, Zeitangabe in Millisekunden, [sleep 1000] = 1 Sekunde Pause
		[local] - Führt die Nachricht dahinter lokal aus (nur die aktuelle Zeile)
	)
}
return

OwnHotkeysSave:
{
	Gui, OwnHotkeys: Submit, NoHide
	
	saveErrors := ""
	
	Loop, %ownHotkeyCount% {
		outerIndex := A_Index
		
		savedOwnHotkey%outerIndex%Text := StrReplace(ownHotkey%outerIndex%Text, "`n", "~")
		
		IniWrite,% ownHotkey%outerIndex%Active, ownhotkeys.ini, %outerIndex%, Active
		IniWrite,% savedOwnHotkey%outerIndex%Text, ownhotkeys.ini, %outerIndex%, Text
		
		name := "ownHotkey" . outerIndex
		hk := %name%
		
		if hk in +,^,!,+^,+!,^!,+^!
			return
		
		if (registeredHotkeys.HasKey(name)) {
			oldKey := registeredHotkeys[name]
			
			Hotkey, %oldKey%, %name%Label, Off
		}
		
		%name%NoMods := ""
		
		if (hk == "") {
			if (registeredHotkeys.HasKey(name)) {
				registeredHotkeys.Delete(name)
			}
			
			IniDelete, ownhotkeys.ini, %outerIndex%, Hotkey
		} else {
			alreadyRegistered := false
			
			for key, value in registeredHotkeys {
				hk2 := StrReplace(hk, "~", "")
				value2 := StrReplace(value, "~", "")
				
				if (hk2 = value2 && StrLen(hk2) == StrLen(value2)) {
					if (name != key) {
						alreadyRegistered := true
						alreadyRegisteredKey := key
						break
					}
				}
			}
			
			if (!InStr(hk, "F") && !InStr(hk, "!"))
				hk := "~" . hk
			
			StringReplace, %name%NoMods, hk, ~
			IniWrite, %hk%, ownhotkeys.ini, %outerIndex%, Hotkey
			
			if (!alreadyRegistered) {
				if (ownHotkey%outerIndex%Active) {
					Hotkey, %hk%, %name%Label
					
					registeredHotkeys[name] := hk
				}
			} else {
				if (RegExMatch(alreadyRegisteredKey, "ownHotkey(\d+)", key_)) {
					hotkeyName := "Eigener Hotkey " . key_1
				} else {
					hotkeyName := alreadyRegisteredKey
				}
				
				saveErrors .= "`nEigener Hotkey " . outerIndex . " (" . getUserFriendlyHotkeyName(hk) . ") belegt bei: " . hotkeyName
			}
		}
	}
	
	if (saveErrors != "") {
		message := "Die Daten wurden gespeichert, jedoch können folgende Hotkeys nicht aktiviert werden, da sie bereits belegt sind:`n" . saveErrors
	} else {
		message := "Alle Eingaben und Daten wurden erfolgreich gespeichert!"
	}
	
	MsgBox, 64, Speicherung, %message%
	
	Gui, OwnHotkeys: Destroy
}
return

OwnHotkeysGuiClose:
{
	Gui, OwnHotkeys: Destroy
}
return

ownHotkey1Label:
	ownHotkey(1)
return
ownHotkey2Label:
	ownHotkey(2)
return
ownHotkey3Label:
	ownHotkey(3)
return
ownHotkey4Label:
	ownHotkey(4)
return
ownHotkey5Label:
	ownHotkey(5)
return
ownHotkey6Label:
	ownHotkey(6)
return
ownHotkey7Label:
	ownHotkey(7)
return
ownHotkey8Label:
	ownHotkey(8)
return
ownHotkey9Label:
	ownHotkey(9)
return
ownHotkey10Label:
	ownHotkey(10)
return
ownHotkey11Label:
	ownHotkey(11)
return
ownHotkey12Label:
	ownHotkey(12)
return
ownHotkey13Label:
	ownHotkey(13)
return
ownHotkey14Label:
	ownHotkey(14)
return
ownHotkey15Label:
	ownHotkey(15)
return
ownHotkey16Label:
	ownHotkey(16)
return
ownHotkey17Label:
	ownHotkey(17)
return
ownHotkey18Label:
	ownHotkey(18)
return
ownHotkey19Label:
	ownHotkey(19)
return
ownHotkey20Label:
	ownHotkey(20)
return
ownHotkey21Label:
	ownHotkey(21)
return
ownHotkey22Label:
	ownHotkey(22)
return
ownHotkey23Label:
	ownHotkey(23)
return
ownHotkey24Label:
	ownHotkey(24)
return
ownHotkey25Label:
	ownHotkey(25)
return
ownHotkey26Label:
	ownHotkey(26)
return
ownHotkey27Label:
	ownHotkey(27)
return
ownHotkey28Label:
	ownHotkey(28)
return
ownHotkey29Label:
	ownHotkey(29)
return
ownHotkey30Label:
	ownHotkey(30)
return
ownHotkey31Label:
	ownHotkey(31)
return
ownHotkey32Label:
	ownHotkey(32)
return
ownHotkey33Label:
	ownHotkey(33)
return
ownHotkey34Label:
	ownHotkey(34)
return
ownHotkey35Label:
	ownHotkey(35)
return
ownHotkey36Label:
	ownHotkey(36)
return
ownHotkey37Label:
	ownHotkey(37)
return
ownHotkey38Label:
	ownHotkey(38)
return
ownHotkey39Label:
	ownHotkey(39)
return
ownHotkey40Label:
	ownHotkey(40)
return
ownHotkey41Label:
	ownHotkey(41)
return
ownHotkey42Label:
	ownHotkey(42)
return
ownHotkey43Label:
	ownHotkey(43)
return
ownHotkey44Label:
	ownHotkey(44)
return
ownHotkey45Label:
	ownHotkey(45)
return
ownHotkey46Label:
	ownHotkey(46)
return
ownHotkey47Label:
	ownHotkey(47)
return
ownHotkey48Label:
	ownHotkey(48)
return

HelpGUI:
{
	Gui, Help: Destroy
	
	Gui, Help: Default
	
	Gui, Help: Color, white
	Gui, Help: Font, S10 CDefault, Verdana
	
	Gui, Help: Add, Edit, x10 y10 r30 w700 +ReadOnly,
	(
.:: Zollsystem ::.
/zollhelp -> Keys / Befehle für Zollsachen anzeigen
/zollinfo -> Alle Zollstationen auflisten

.:: Deathmatch ::. 
/kd -> K/D für sich anzeigen
/fkd -> K/D im /f anzeigen
/dkd -> K/D im /d anzeigen
/jkd -> K/D im /j anzeigen
/ckd -> K/D im /crew anzeigen
/setkd -> K/D setzen (über Stats)
/resetdkd -> Tages K/D zurückgesetzen
/bossmode -> Bossmodus aktivieren
/items -> Zeigt alle Items an
/messer -> Zum Messer erstellen

.:: Punkte / Scheine / Tickets / Takes ::.
/setkmh -> Blitzergeschwindigkeit (max. erlaubt) einstellen 

/tst -> Strafpunkte löschen
/cws -> Waffenschein entsperren
/cfs -> Flugschein entsperren
/cds -> Führerschein entsperren

/top -> Möchten Sie ein Ticket o. Strafpunkte?
/tot -> Möchten Sie ein Ticket o. Scheinentzug?

/stvo -> Ticket oder Punkte für StVO Vergehen anfragen
/stvof -> Ticket für Flugschein anbieten
/stvow -> Ticket für Waffenschein anbieten
/stvob -> Ticket für Bootschein anbieten
/speed -> Ticket oder Punkte für Geschw. Vergehen anfragen

/fst -> Flugscheinticket geben
/wst -> Waffenscheinticket geben
/bst -> Bootscheinticket geben

/aticket -> Automatisch Ticket vergebene (/stvo, /speed etc...)
/apunkte -> Automatisch Ticket vergeben (/stvo, /speed etc...)

/nt -> nächstes Ticket anbieten

/wtd -> Möchten Sie ein Ticket für Ihre Wanteds?
/dtd -> Möchten Sie ein Ticket für Ihre Drogen?

/twd -> Ticket für Wanteds anbieten
/tdd -> Ticket für Drogen anbieten

/tw -> Waffen wegnehmen
/td -> Drogen wegnehmen
/tm -> Materialien wegnehmen
/tall -> Waffen, Drogen, Mats wegnehmen
/tfs -> Flugschein wegnehmen
/tws -> Waffenschein wegnehmen
/tbs -> Bootschein wegnehmen

.:: Streifendienst ::.
/arrestlist -> Arrest-Liste anzeigen
/cufflist -> Cuff-Liste anzeigen

/partner -> Partner eintragen
/partners -> Alle Partner anzeigen
/rpartners -> Alle Partner zurücksetzen

/af -> Spieler automatisch finden
/as -> Spieler einen anderen Spieler anzeigen
/fahrer -> Fahrer eintragen für Find (/as)

/rew -> Re-Wanted geben
/sb -> Sachbeschdägigung geben (wtd)
/entf -> Entführung geben (wtd)
/coop -> Optimale Wanteds zum clearen anzeigen
/wafk -> Spieler mit Wanteds AFK melden

/rz /razzia -> Razzia ankündigen (/m)
/weiter -> Alle Personen WEITERFAHREN (/m)
/cd -> Countdown starten
/fahrt -> Gute Weiterfahrt wünschen
/passieren -> Sie dürfen passieren!
/beweise -> Haben Sie dafür beweise?
/zeuge -> Zeugen zählen dabei nicht!
/warte -> Der Fall wird geprüft!
/beschwerde -> Sie haben das Recht eine Beschwerde zu schreiben!
/rechte -> Rechte vorlesen!
/hdf -> Sein Sie bitte still
/tuch -> Möchten Sie ein Taschentuch?
/runter -> Runter von dem Fahrzeug!

/hat -> Hat jemand bereits xxx gefangen?
/wo -> Wo befindet ihr euch, was ist das Problem? (/d)
/nbk -> Wird Verstärkung weiterhin gefordert? (/d)
/ver -> Habe verstanden! (/d)
/fver -> Habe verstanden! (/f)
/rver -> Habe verstanden! (/r)
/abholung -> Erbitte Abholung in ... (/d)
/kabholung -> Benötige keine Abholug mehr (/d)
/go -> Einsatzleiter erlaubt Zugriff! (/d & /hq)
/fgo -> Einsatzleiter erlaubt Zugriff (/f)
/rgo -> Einsatzleiter erlaubt Zugriff (/r)
/mrob -> Es findet ein Matstransport überfall statt! (/f & /hq)
/mats -> Es findet ein Matstransport statt! (/f & /hq)
/einsatz -> Ansatz im F-Chat ankündigen 
/ziel -> Einsatzziel ankündigen (/hq & /f)
/verf -> Unterstützung für Verfolgung anfragen (/d)
/ort -> Letzten Ort des Verbrechers ansagen (/d)
/air -> Fordere Luftüberwachung (/d)
/wagen -> Benötige eine Streife in ... (/d)
/sani -> Benötige einen RTW in ... + /service (/d)
/abschlepp /oamt -> Benötige einen Abschleppwagen in ... + /service (/d)

/oa -> Spieler offline einsperren
/da -> Spieler tot einsperren
/op -> Spieler offline ins Prison sperren
/dp -> Spieler tot ins Prison sperren

/wasser -> Wasser-Modus an/ausschalten
/luft -> Luft-Modus an/ausschalten

/rb -> Straßensperre aufbauen
/db -> Straßensperre abbauen
/dba -> Alle Straßensperren abbauen
/bc -> Roadbarrier aufbauen
/bd -> Roadbarrier delete
/bda -> Roadbarrier deleteall

/sperrzone -> Sperrzone ankündigen
/ksperrzone -> Sperrzone aufheben

/rs -> Restaurantkette einbringen
/sr -> Restaurantketten anzeigen

/ci -> Fahrzeuginformationen anzeigen
/pi -> Spielerinformationen anzeigen
/uc -> Undercover gehen
/auc -> Random Undercover Skin
/sbd -> Dienstmarke zeigen
/einweisung -> Einweisungsmodus aktivieren (weniger Spam)

/gk -> Gebäudekomplex aufrufen
/sgk -> Letzten Robstore anzeigen
/showgk -> Gebäudekomplex auf Karte anzeigen
/addgk -> Gebäudekomplex in .txt Speichern

/afk -> Sich afk / anwesend melden
/afklist -> Alle afk gemeldeten anzeigen

/tasks -> Alle verfügbaren Aufgaben anzeigen
/ontasks -> Alle verfügbaren Aufgaben anzeigen die online sind 
/addtask -> Aufgabe hinzugefügen
/deltask -> Aufgabe entfernen

.:: MauMau System ::. 
/mr -> /mauready
/mn -> /maunext
/md -> /maudraw
/am -> /accept maumau
/ml -> /mauleave
/maumodus -> MauModus anschalten
/mhelp -> MauMau Hilfen

.:: Overlay ::.
/ovall -> Alle Overlays an/ausschalten
/ov /overlay -> Overlay einzeln an/abschalten
/ovmove /moveov -> Overlay bewegen
/ovsave /saveov -> Overlay speichern
/ovedit /editov -> Overlayteile de/aktivieren
/resetovpos -> Overlaypositionen zurückesetzen

.:: Allgemeines ::.
/thx -> Vielen Dank!
/sry -> Entschuldigung!
/np -> Kein Problem!
/geld -> Sehe ich aus wie ein Geldautomat?
/taxi -> Sehe ich aus wie ein Taxi?
/jas -> Ja Sir, was kann ich für Sie tun?
/jam -> Ja Mam, was kann ich für Sie tun?
/ja -> Ja, was kann ich für Sie tun?
/tag -> Guten Tag, wie kann ich helfen?
/bye -> Ich wünsche Ihnen einen schönen Tag!

/p -> Anruf annehmen
/h -> Anruf beenden
/ab -> Anrufbeantworter
/re -> Auf letzte SMS antworten
/read -> Auf letzte AD antworten
/ksms -> Spieler per Name SMS senden
/kcall -> Spieler per Name anrufen
/calarm -> Spieler vor Abschleppung des O-Amts warnen

/ap -> Erste-Hilfe-Paket kaufen
/fg -> Festgeld anlegen
/ac -> Aktitivätsbonus anzeigen
/ga -> Gps deaktivieren
/pb -> Abkürzung für /paintball
/gf -> Gangfights anzeigen

/to -> Kofferraum öffnen
/tc -> Kofferraum durchsuchen
/tput -> Etwas in Kofferraum legen
/tcm -> Mats aus dem Kofferraum taken
/tcd -> Drogen aus Kofferraum taken
/cpos -> Position in Crew-Chat anzeigen

/hi -> In allen Chats "Hi" sagen
/dep -> Department (für Vorwarnung) eintragen
/settax -> Steuerklasse setzen
/tempo -> Geschwindigkeit für Tempomat setzen
/payday -> PayDay Geld anzeigen
/resetpayday -> PayDay Geld resetten
/alotto -> Lotto spielen (mit der eingestellten Zahl)
/fan -> Spieler Autogramm geben
/savestats -> Stats screenen und speichern
/fill -> Schnelles tanken
/minuten -> Sekunden in Minuten umnrechnen
/link -> Letzten Link ausm Chat kopieren
/savechat -> Chatlog speichern
/cc -> Chat säubern
/checkpoint -> manuellen Checkpoint setzen
/coords -> aktuelle Koordinaten anzeigen
/restart -> Keybinder reloaden
/relog -> Ingame reloggen
/fpsunlock -> FPS Beschränkung aufheben / setzen

/afish -> Schnelles fischen
/asell -> Schnelles Fische verkaufen
/acook -> Schnelles Fische kochen
/fischtyp -> Fisch-Typ setzen (Gewicht, Wert)
/fische -> Ungekochte Fische checken
/hp -> Gekochte Fische checken
/sellfish -> Jemanden deine gekochten Fische schenken


.:: Überarbeite Serverbefehle ::. 
/q -> Setzt Variablen zurück 
/pbexit -> Gibt Armour nach PB wieder
/heal -> Healcooldown
/erstehilfe -> First-Aid Cooldown
/time -> Knast / KH Zeit anzeigen
/paintball -> Spielerzahl anzeigen
/fill -> An /tanken angepasst
/findcar /fc -> Zeigt Position an
)
	Gui, Help: Add, Button, x550 y650 w160 h40 gHelpGuiClose, Schließen
	Gui, Help: Show, h700 w720, %projectName% - Hilfe - Version: %version%
}
return

HelpGuiClose:
{
	Gui, Help: Destroy
}
return

NewsGUI:
{
	Gui, News: Destroy
	
	Gui, News: Color, white
	Gui, News: Font, S10 CDefault, Verdana
	
	Gui, News: Add, Button, x470 y450 w140 h40 gNewsGuiClose, Schließen
	
	Gui, News: Add, Groupbox, x10 y10 w600 h430, Neuigkeiten und Informationen
	Gui, News: Add, Edit, x20 y30 w580 h400 ReadOnly, 
(
23.05.2020
Keybinder erst mal als offline Version in Betrieb genommen.
)
	Gui, News: Show, w620 h500, %projectName% - News - Version: %version%
}
return

NewsGuiClose:
{
	Gui, News: Destroy
}
return

KeyControl:
{
	run, https://staatsgewalt.jameschans.de/
}
return

RPGConnect:
{
	RegRead GTA_SA_EXE, HKEY_CURRENT_USER, Software\SAMP, gta_sa_exe
	SplitPath, GTA_SA_EXE,, PFAD
	
	run, %PFAD%\samp.exe samp.rpg-city.de, %PFAD%
}
return

~Up::
{
	if (ovMoveMode) {
		if (ovMoveMode == 1) {
			spotifyYPos -= 1
		} else if (ovMoveMode == 2) {
			cooldownYPos -= 1
			cooldownBoxY -= 1
		} else if (ovMoveMode == 3) {
			alertYPos -= 1
		} else if (ovMoveMode == 4) {
			pingYPos -= 1
		} else if (ovMoveMode == 5) {
			infoPhoneY -= 1
		} else if (ovMoveMode == 6) {
			infoFirstaidY -= 1
		} else if (ovMoveMode == 7) {
			infoCanisterY -= 1
		} else if (ovMoveMode == 8) {
			infoFishCookedY -= 1
		} else if (ovMoveMode == 9) {
			infoFishUncookedY -= 1
		} else if (ovMoveMode == 10) {
			infoCampfireY -= 1
		} else if (ovMoveMode == 11) {
			infoDrugsY -= 1
		} else if (ovMoveMode == 12) {
			partnerY -= 1
		}
		
		ov_UpdatePosition(ovMoveMode)
	}
}
return

~Down::
{
	if (ovMoveMode) {
		if (ovMoveMode == 1) {
			spotifyYPos += 1
		} else if (ovMoveMode == 2) {
			cooldownYPos += 1
			cooldownBoxY += 1
		} else if (ovMoveMode == 3) {
			alertYPos += 1
		} else if (ovMoveMode == 4) {
			pingYPos += 1
		} else if (ovMoveMode == 5) {
			infoPhoneY += 1
		} else if (ovMoveMode == 6) {
			infoFirstaidY += 1
		} else if (ovMoveMode == 7) {
			infoCanisterY += 1
		} else if (ovMoveMode == 8) {
			infoFishCookedY += 1
		} else if (ovMoveMode == 9) {
			infoFishUncookedY += 1
		} else if (ovMoveMode == 10) {
			infoCampfireY += 1
		} else if (ovMoveMode == 11) {
			infoDrugsY += 1
		} else if (ovMoveMode == 12) {
			partnerY += 1
		}
		
		ov_UpdatePosition(ovMoveMode)
	}
}
return

~Left::
{
	if (ovMoveMode) {
		if (ovMoveMode == 1) {
			spotifyXPos -= 1
		} else if (ovMoveMode == 2) {
			cooldownXPos -= 1
			cooldownBoxX -= 1
		} else if (ovMoveMode == 3) {
			alertXPos -=1
		} else if (ovMoveMode == 4) {
			pingXPos -= 1
		} else if (ovMoveMode == 5) {
			infoPhoneX -= 1
		} else if (ovMoveMode == 6) {
			infoFirstaidX -= 1
		} else if (ovMoveMode == 7) {
			infoCanisterX -= 1
		} else if (ovMoveMode == 8) {
			infoFishCookedX -= 1
		} else if (ovMoveMode == 9) {
			infoFishUncookedX -= 1
		} else if (ovMoveMode == 10) {
			infoCampfireX -= 1
		} else if (ovMoveMode == 11) {
			infoDrugsX -= 1
		} else if (ovMoveMode == 12) {
			partnerX -= 1
		}
		
		ov_UpdatePosition(ovMoveMode)
	}
}
return

~Right::
{
	if (ovMoveMode) {
		if (ovMoveMode == 1) {
			spotifyXPos += 1
		} else if (ovMoveMode == 2) {
			cooldownXPos += 1
			cooldownBoxX += 1
		} else if (ovMoveMode == 3) {
			alertXPos += 1
		} else if (ovMoveMode == 4) {
			pingXPos += 1
		} else if (ovMoveMode == 5) {
			infoPhoneX += 1
		} else if (ovMoveMode == 6) {
			infoFirstaidX += 1
		} else if (ovMoveMode == 7) {
			infoCanisterX += 1
		} else if (ovMoveMode == 8) {
			infoFishCookedX += 1
		} else if (ovMoveMode == 9) {
			infoFishUncookedX += 1
		} else if (ovMoveMode == 10) {
			infoCampfireX += 1
		} else if (ovMoveMode == 11) {
			infoDrugsX += 1
		} else if (ovMoveMode == 12) {
			partnerX += 1
		}
		
		ov_UpdatePosition(ovMoveMode)
	}
}
return

~xButton1::
{
	if (isBlocked() || tv) {
		return
	}	
	
	if (!IsPlayerInAnyVehicle()) {
		ped := getTargetPed()
		pedID := getIdByPed(ped)
		
		if (pedID > -1 && oldWanted != pedID) {
			oldWanted := pedID
			
			giveWanteds(pedID, "Angriff/Beschuss auf Beamte/Zivilisten", 2)
		}
	}
}
return

~Enter::
{
	if (isBlocked() || tv) {
		return
	}	
	
	if (!isPlayerInAnyVehicle()) {
		if (isPlayerInRangeOfPoint(901.2969, -1203.0950, 16.9832, 3)) {
			if (getPlayerMoney() >= 2500) {
				if (getPlayerArmor()) {
					SendChat("/zivil")
					Sleep, 200
				}
				
				SendChat("/pbenter")
			} else {
				SendInfo("Du benötigst mindestens 2.500$.")
			}
		}
	}
}
return

~D::
~S::
~A::
~W::
{
	IniRead, autoUse, ini/Settings.ini, settings, autoUse, 0
	IniRead, pakcooldown, ini/Settings.ini, Cooldown, pakcooldown, 0
	
	if (isBlocked() || isPaintball || !autoUse || isPlayerInAnyVehicle() || getPlayerArmor() >= 46) {
		return
	}

	IniRead, firstaid, ini/Settings.ini, Items, firstaid, 0
	IniRead, drugs, ini/Settings.ini, Items, drugs, 0

	if (getPlayerHealth() <= 75 && getPlayerArmor() < 30) {		
		if (firstaid && !pakcooldown) {
			usePaket()
		}

		if (autoDrugs) {
			if (drugs > 0 && !getPlayerArmor()) {
				if (!drugCooldown) {
					useDrugs()
				}
			}
		}
	}	
	
	Loop, 5 {
		fishLBS := fishLBS_%A_Index%
		lostHP := getPlayerHealth()
		lostHP += fishHP_%A_Index%
		
		if (fishHP_%A_Index% > 0 && fishLBS_%A_Index% && fishName_%A_Index% != "nichts") {			
			if (lostHP <= 90 && fishLBS > 0) {
				SendChat("/eat " . A_Index)
				
				fishName_%A_Index% := "nichts"
				fishLBS_%A_Index% := 0
				fishHP_%A_Index% := 0
				return
			}
		}
	}
}
return

~^R::
{
	if (isBlocked()) {
		return
	}
	
	reconnectRPG()
}
return

jobexecuteLabel:
{
	if (isBlocked()) {
		return
	}
	
	if ((job == "") || (job <= 1)) {
		SendError("Du hast keinen Job gesetzt. Verwende '" . csecond . "/setjob" . cwhite . "'.")
	} else if (job == 4) {
		if ((jobLine == "") || (jobLine <= 1)) {
			SendError("Du hast keine Linie gesetzt. Verwende '" . csecond . "/setlinie" . cwhite . "'.")
			
			SendChat("/linie")
		} else {
			busLine := jobLine - 1
			
			selectLine(busLine)
		}
	}
}
return

tempomatLabel:
{
	if (isBlocked()) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			if (tempomat) {
				SendInput, {W up}
				
				tempomat := false
				
				SendInfo("Du hast den Tempomat " . cred . "deaktiviert" . cwhite . ".")
			} else {
				if (!tempomat) {
					tempomat := true
					
					SetTimer, TempoTimer, 100
					
					SendInfo("Du hast den Tempomat " . cgreen . "aktiviert" . cwhite . " (Tempo: " . csecond . tempo . " km/h" . cwhite . ").")
				}
			}
		} else {
			SendError("Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendError("Du befindest dich in keinem Fahrzeug.")
	}
}
return

closeCustomsControlLabel:
{
	if (isBlocked()) {
		return
	}
		
	if (rank > 4) {
		SendInput, t/zollcontrol  zu{left 3}
	} else if (rank < 5) {
		zoll := PlayerInput("Zoll Nummer: ")
		if (zoll == "" || zoll == " ") {
			return
		}
			
		SendChat("/d HQ: Bitte Zollstation " . zoll . " schließen!")
	}
}
return

openCustomsControlLabel:
{
	if (isBlocked()) {
		return
	}
		
	if (rank > 3) {
		SendInput, t/zollcontrol  auf{left 4}
	} else if (rank < 4) {
		zoll := PlayerInput("Zoll Nummer: ")
		if (zoll == "" || zoll == " ") {
			return
		}
		
		SendChat("/d HQ: Bitte Zollstation " . zoll . " öffnen!")
	}
}
return

govClosedCustomsLabel:
{
	if (isBlocked()) {
		return
	}
	
	SendInfo("Welche Zollstation soll als 'geschlossen' angekündigt werden (1-13)?")
	
	zollID := PlayerInput("Zoll-ID: ")
	if (zollID == "" || zollID == " ") {
		return
	} else if (zollID is not number) {
		SendError("Die Zoll-ID muss eine Zahl sein.")
		return
	} else if (zollID > 13 || zollID < 1) {
		SendError("Die Zoll-ID darf nicht höher als 13 und niedriger als 1 sein.")
		return
	} else if (rank < 7) {
		SendError("Du benötigst Rang 7.")
		return
	}
	
	if (zollID >= 1 && zollID <= 9) {
		a := "Die" 
		b := "Zollstation "
		c := zollID . " "
		d := "(" . costumStation(zollID) . ") "
		e := "ist"
	} else if (zollID >= 10 && zollID <= 12) {
		a := "Die" 
		b := "Zollstationen "
		c := "um "
		d := "" . costumStation(zollID) . " "
		e := "sind"
	} else if (zollID == 13) {
		a := "Alle" 
		b := "Zollstationen"
		c := ""
		d := ""
		e := "sind"
	}
	
	SendChat("/gov " . a . " " . b . "" . c . "" . d . "" . e . " zurzeit geschlossen!")
}
return

govOpenedCustomsLabel:
{
	if (isBlocked()) {
		return
	}
	
	SendInfo("Welche Zollstation soll als 'offen' angekündigt werden (1-13)?")
	
	zollID := PlayerInput("Zoll-ID: ")
	if (zollID == "" || zollID == " ") {
		return
	} else if (zollID is not number) {
		SendError("Die Zoll-ID muss eine Zahl sein.")
		return
	} else if (zollID > 13 || zollID < 1) {
		SendError("Die Zoll-ID darf nicht höher als 13 und niedriger als 1 sein.")
		return
	} else if (rank < 7) {
		SendError("Du benötigst Rang 7.")
		return
	}
	
	if (zollID >= 1 && zollID <= 9) {
		a := "Die" 
		b := "Zollstation "
		c := zollID . " "
		d := "(" . costumStation(zollID) . ") "
		e := "ist"
	} else if (zollID >= 10 && zollID <= 12) {
		a := "Die" 
		b := "Zollstationen "
		c := "um "
		d := "" . costumStation(zollID) . " "
		e := "sind"
	} else if (zollID == 13) {
		a := "Alle" 
		b := "Zollstationen"
		c := ""
		d := ""
		e := "sind"
	}
	
	SendChat("/gov " . a . " " . b . "" . c . "" . d . "" . e . " nun nicht mehr geschlossen!")
}
return

openCustomsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (isPlayerAtMaut()) {
		openMaut()
	} else {
		SendInfo("Du bist an keiner Zollstation.")
	}
}
return

openDoorLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	openGate()
}
return

LWin::
{
	if (isBlocked()) {
		return
	}

	SendChat("/wanted")
}
return

LWin & 1::
{
	if (isBlocked()) {
		return
	}
		
	SendChat("/wanted ls")
}
return

LWin & 2::
{
	if (isBlocked()) {
		return
	}

	SendChat("/wanted sf")
}
return

LWin & 3::
{
	if (isBlocked()) {
		return
	}
		
	SendChat("/wanted lv")
}
return

LWin & 4::
{
	if (isBlocked()) {
		return
	}
		
	SendChat("/wanted int")
}
return

zivicLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/zivil")
}
return

megaFollowLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	useMegaphone(1)
}
return

megaControlLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(2)
	} else {
		SendInfo("Mau-Modus: Mau 1 wird gelegt:")
		SendChat("/mau 1")
	}
}
return

megaStopLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(3)
	} else {
		SendInfo("Mau-Modus: Mau 2 wird gelegt:")
		SendChat("/mau 2")
	}
}
return

megaByNameLabel:
{
	if (isBlocked() || tv) {
		return
	}
		
	if (!maumode) {
		useMegaphone(4)
	} else {
		SendInfo("Mau-Modus: Mau 3 wird gelegt:")
		SendChat("/mau 3")
	}
}
return

megaGetOutOfCarLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(5)
	} else {
		SendInfo("Mau-Modus: Mau 4 wird gelegt:")
		SendChat("/mau 4")
	}
}
return

megaClearLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(6)
	} else {
		SendInfo("Mau-Modus: Mau 5 wird gelegt:")
		SendChat("/mau 5")
	}
}
return

megaWeaponsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(7)
	} else {
		SendInfo("Mau-Modus: Mau 6 wird gelegt:")
		SendChat("/mau 6")
	}
}
return

megaLeaveLabel:
{	
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		useMegaphone(8)
	} else {
		SendInfo("Mau-Modus: Mau 9 wird gelegt:")
		SendChat("/mau 9")
	}
}
return

megaStopFollowLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	useMegaphone(9)
}
return

megaRoadTrafficActLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	useMegaphone(10)
}
return

atkWantedsLabel:
{
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Angriff/Beschuss: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Angriff/Beschuss auf Beamte/Zivilisten", 2)
	}
}
return

~^!Numpad1::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}

	giveWanteds(playerToFind, "Angriff/Beschuss auf Beamte/Zivilisten", 2)
}
return

escapeWantedsLabel:
{
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Flucht/Fluchtversuch: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Flucht/Fluchtversuch", 2)
		
		playerToFind := name
		autoFindMode := 2

		findPlayer()
		findInfo(playerToFind)
	}
}
return

~^!Numpad2::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Flucht/Fluchtversuch", 2)
}
return

escapeAidWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Beihilfe zur Flucht: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Beihilfe zur Flucht", 2)
	}
}
return

refusalWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Verweigerung: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Verweigerung von Anweisungen", 1)
	}
}
return

~^!Numpad3::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Verweigerung von Anweisungen", 1)
}
return

obstructionWantedsLabel:
{
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Behinderung der Justiz: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Behinderung der Justiz", 1)
	}
}
return

~^!Numpad4::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Behinderung der Justiz", 1)
}
return

possessionWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Besitz von illegalen Gegenständen: ")
	name := getFullName(name)
	
	if (name != "") {
		SendInfo("Materialien/Pakete: " . cSecond . "1" . cWhite . ", Drogen/Samen: " . cSecond . "2")
		
		wantedType := PlayerInput("Typ: ")
		if (wantedType == 2) {
			giveWanteds(name, "Besitz von Marihuana(samen)", 2)
		} else if (wantedType == 1) {
			giveWanteds(name, "Besitz von Materialien/Materialpakete", 2)
		}
	}
}
return

tradeWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Handel mit illegalen Gegenständen: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Handel mit illegalen Wertgegenständen", 2)
	}
}
return

~^!Numpad8::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Handel mit illegalen Wertgegenständen", 2)
}
return

drugConsumptionWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Drogenkonsum: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Verstoß gegen das BtmG", 2)
	}
}
return

~^!Numpad6::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Verstoß gegen das BtmG", 2)
}
return

unauthorizedEnterWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Unbefugter Betritt: ")
	name := getFullName(name)
	
	if (name != "") {
		if (getPlayerInteriorId() == 0) {
			giveWanteds(name, "Unautorisiertes Betreten eines Geländes", 2)
		} else {
			giveWanteds(name, "Unautorisiertes Betreten eines Dienstfahrzeuges", 2)
		}
	}
}
return

customsEscapeWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Zollflucht: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Zollflucht", 2)
	}
}
return

~^!Z::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Zollflucht", 2)
}
return

vehicleTheftWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Diebstahl: ")
	name := getFullName(name)
	
	if (name != "") {
		SendInfo("1: " . cwhite . "Privatfahrzeug, " . csecond . "2: " . cwhite . "Dienstfahrzeug, " . csecond . "3: " . cwhite . "gep./bew. Dienstfahrzeug")
		
		wantedType := PlayerInput("Typ: ")
		
		if (wantedType == "1") {
			giveWanteds(name, "Diebstahl von Privatfahrzeugen", 2)
		} else if (wantedType == "2") {
			giveWanteds(name, "Diebstahl von Dienstfahrzeugen", 4)
		} else if (wantedType == "3") {
			giveWanteds(name, "Diebstahl von schweren Dienstfahrzeugen", 6)
		}
	}
}
return

insultingWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Beamtenbeleidigung: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Beamtenbeleidigung", 1)
	}
}
return

~^!H::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Beamtenbeleidigung", 1)
}
return

useOfWeaponsWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Waffengebrauch: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Waffengebrauch i.d. Öffentlichkeit", 2)
	}
}
return

~^!I::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Waffengebrauch i.d. Öffentlichkeit", 2)
}
return

possessionOfWeaponsWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Waffenbesitz: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Waffenbesitz ohne Waffenschein", 2)
	}
}
return

~^!U::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	giveWanteds(playerToFind, "Waffenbesitz ohne Waffenschein", 2)
}
return

briberyWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	name := PlayerInput("Beamtenbestechung: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Beamtenbestechung", 1)
	}
}
return

escWantedsLabel:
{
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("ESC-Flucht: ")
	name := getFullName(name)
	
	if (name != "") {
		if (escInfo) {
			SendChat("/a " . name . " (ID: " getPlayerIdByName(name) . ") ESC Flucht / Buguse vor Cops!!!")
		}
		
		giveWanteds(name, "ESC-Flucht", 4)
	}
}
return

~^!E::
{
	if (isBlocked()) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}
	
	if (escInfo) {
		SendChat("/a " . getFullName(playerToFind) . " (ID: " getPlayerIdByName(getFullName(playerToFind)) . ") ESC Flucht / Buguse vor Cops!!!")
	}

	giveWanteds(playerToFind, "ESC-Flucht", 4)
}
return

kidnapWantedsLabel:
{
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Entführer: ")
	name := getFullName(name)
	
	if (name == "") {
		SendError("Der angegebene Spieler ist offline.")
		return
	} else if (name == getUserName()) {
		SendError("Du kannst dir selber keine Wanteds eintragen.")
		return
	}
	
	SendInfo(csecond . "1" . cWhite . ": Bürger, " . csecond . "2" . cWhite . ": Staatsbeamter")
		
	wantedType := PlayerInput("Typ: ")
		
	if (wantedType == "1") {
		giveWanteds(name, "Entführung", 2)
	} else if (wantedType == "2") {
		giveWanteds(name, "Entführung von Beamten", 4)
	} else {
		SendError("Es gibt nur Typ 1 (normal) und Typ 2 (Beamter).")
	}
}
return

clearWantedsLabel:
{
	if (isBlocked()) {
		return
	}

	SendInput, t/clear{Space}
}
return

roadHazardPointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Gefährdung: ")
	name := getFullName(name)
	
	if (name != "") {
		givePoints(name, "Gefährdung des Straßenverkehrs", 1)
	}
}
return

wrongSitePointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Falsche Seite: ")
	name := getFullName(name) 
	
	if (name != "") {
		givePoints(name, "Fahren auf falscher Fahrbahn", 1)
	}
}
return

speedPointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Höchstgeschwindigkeit: ")
	name := getFullName(name) 
	
	if (name != "") {
		givePoints(name, "Missachtung des Tempolimits", 1)
	}
}
return

offsitePointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Abseits: ")
	name := getFullName(name) 
	
	if (name != "") {
		givePoints(name, "Fahren abseits der Straße", 1)
	}
}
return

lightPointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Licht: ")
	name := getFullName(name) 
	
	if (name != "") {
		givePoints(name, "Fahren ohne Licht", 1, " (" . A_Hour . ":" . A_Min . ")")
	}
}
return

noParkingPointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Parkverbot: ")
	name := getFullName(name) 
	
	if (name != "") {		
		givePoints(name, "Parken im Parkverbot", 1, " (" . getPlayerZone() . ")")
	}
}
return

clearPointsLabel:
{	
	if (isBlocked()) {
		return
	}
	
	name := PlayerInput("Spieler: ")
	if (name == "" || name == " ") {
		return
	} else if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	amount := PlayerInput("Anzahl: ")
	if (amount == "" || amount == " ") {
		return
	} else if (amount is not number) {
		SendError("Du musst eine Zahl angeben.")
		return
	}
	
	SendChat("/licunban " . name . " points " . amount)
	Sleep, 200
	
	Loop, 5 {
		if (InStr(readChatLine(A_Index - 1), "Dieser Befehl ist ab Rang 9.")) {
			SendChat("/d HQ: " . getFullName(name) . " bitte " . amount . " Strafpunkte löschen!")
			break
		}
	}
}
return

equipLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/ausruesten")
}
return

healLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	healPlayer()
}
return

equipProfile1Label:
{
	if (isBlocked()) {
		return
	}
	
	equipment := ""
	
	Loop, 6 {
		if (profile1_%A_Index% != "") {
			equipment .= " " . profile1_%A_Index%
		}
	}
	
	SendChat("/ausruesten" . equipment)
	Sleep, 250
	
	healPlayer()
}
return

equipProfile2Label:
{
	if (isBlocked() || tv) {
		return
	}
	
	equipment := ""
	
	Loop, 6 {
		if (profile2_%A_Index% != "") {
			equipment .= " " . profile2_%A_Index%
		}
	}
	
	SendChat("/ausruesten" . equipment)
	Sleep, 250
	
	healPlayer()
}
return

equipProfile3Label:
{
	if (isBlocked() || tv) {
		return
	}

	equipment := ""
	
	Loop, 6 {
		if (profile3_%A_Index% != "") {
			equipment .= " " . profile3_%A_Index%
		}
	}
	
	SendChat("/ausruesten" . equipment)

	if (equipArmour) {
		SendChat("/undercover " . ucSkin)
		
		if (!admin) {
			Sleep, 250
		}
		
		healPlayer()
	} else {
		SendChat("/heal")
		
		if (!admin) {
			Sleep, 200
		}
		
		SendChat("/undercover " . ucSkin)
		checkHealMessage()
	}
}
return

backupLabel:
{
	if (isBlocked() || tv) {
		return
	}
	

	
	if (!bk) {
		if (admission && rank > 6) {
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
		}		
		
		Sleep, 250
		
		SendChat("/bk")
		
		bk := 1
		return
	}
	
	if (admission) {
		bkchat := "r"
	} else {
		bkchat := "d"
	}
	
	SendChat("/" . bkchat . " HQ: Ich benötige DRINGEND Verstärkung in " . getLocation() . "! (HP: " . getPlayerHealth() . ", AM: " . getPlayerArmor() . ")")
}
return

backupWhLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!bk) {
		if (admission && rank > 6) {
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
		}			
		
		SendChat("/bk")
		
		bk := 1
	}
	
	if (admission) {
		bkchat := "r"
	} else {
		bkchat := "d"
	}	
	
	SendChat("/" . bkchat . " HQ: Ich benötige DRIGEND Verstärkung in " . getLocation() . ", verfolge Wheelman!")
}
return

noBackupLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (bk) {
		bk := 0
		
		SendChat("/bk")
		
		if (admission) {
			bkchat := "r"
		} else {
			bkchat := "d"
		}
		
		SendChat("/" . bkchat . " HQ: Verstärkung wird NICHT mehr benötigt!")
		
		Sleep, 250
		
		if (admission && rank > 6) {
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
			SendChat("/hq +++ Einweisung - nicht Beachten! +++")
		}				
	} else {
		SendInfo("Du hast keine Verstärkung angefordert.")
	}
}
return

autoImprisonLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	indexRemove := -1
	
	for index, arrestName in arrestList {
		suspectID := getPlayerIdByName(getFullName(arrestName), true)
		
		if (suspectID != -1) {
			SendChat("/arrest " . arrestName)
			arrestList.RemoveAt(index)
		}
	}
}
return

imprisonLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		name := PlayerInput("Einsperren: ")
		if (name == "" || name == " ") {
			return
		} else if (getFullName(name) == "") {
			SendError("Dieser Spieler ist nicht online.")
			return
		}		
		
		SendChat("/arrest " . name)
		
		for index, arrestName in arrestList {
			if (arrestName == name) {
				arrestList.RemoveAt(index)
			}
		}
	} else {
		SendInfo("Mau-Modus: Mau 8 wird gelegt:")
		SendChat("/mau 8")
	}
}
return

arrestLabel:
{
	if (isBlocked() || tv) {
		return
	}

	if (!maumode) {
		name := PlayerInput("Verhaften: ")
		if (name == "" || name == " ") {
			return
		}
		
		if (getFullName(name) == "") {
			SendError("Dieser Spieler ist nicht online.")
			return
		}

		SendChat("/waffen " . name)
		
		if (!admin) {
			Sleep, 100
		}
		
		SendChat("/cuff " . name)
		
		if (autoFrisk) {
			if (!admin) {
				Sleep, 400
			}
			
			checkResult := check(name)
			
			if (checkResult != -1 && autoWanted) {
				if (checkResult[1] || checkResult[2]) {
					if (!admin) {
						Sleep, 700
					}
					
					giveWanteds(name, "Besitz von Marihuana(samen)", 2)
				}
				
				if (checkResult[3] || checkResult[4] || checkResult[5]) {
					if (!admin) {
						Sleep, 700
					}
					
					giveWanteds(name, "Besitz von Materialien/Materialpaketen", 2)
				}
			}
		}
	} else {
		SendInfo("Mau-Modus: Mau 7 wird gelegt:")
		SendChat("/mau 7")
	}
}
return

uncuffLabel:
{
	if (isBlocked() || tv) {
		return
	}

	name := PlayerInput("Uncuff-ID: ")
	if (name == "" || name == " ") {
		return
	}

	name := getFullName(name)
	if (name == "") {
		SendError("Der Spieler ist nicht online.")
		return
	}
	
	SendChat("/uncuff " . name)
	
	indexRemove := -1
	
	for index, arrestName in arrestList {
		if (arrestName == name) {
			arrestList.RemoveAt(index)
		}
	}
}
return

arrestSlotsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	arrestCount := 0
	
	SendInfo("Verbrecher in der Arrestliste:")
	
	for index, arrestName in arrestList {
		SendInfo("ID: " . getPlayerIdByName(getFullName(arrestName), 1) . " - " . csecond . getFullName(arrestName))
		arrestCount ++
	}
	
	if (!arrestCount) {
		SendInfo("Es sind aktuell keine Spieler in deiner Arrest-Liste.")
	} else {
		SendInfo("Spieler in Arrest-Liste: " . csecond . arrestCount)
	}
}
return

resetArrestSlotsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	arrestList := []
	
	SendInfo("Arrestslots zurückgesetzt.")
}
return

checkLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	frisk_name := PlayerInput("Kontrolle: ")
	if (frisk_name == "" || frisk_name == " ") {
		return
	}

	if (getFullName(frisk_name) == "") {
		SendError("Der angegebene Spieler ist nicht online.")
		return
	}
	
	if (getFullName(frisk_name) == getUserName()) {
		SendError("Du kannst dich nicht selber durchsuchen.")
		return
	}

	checkResult := check(frisk_name)
	
	if (checkResult == -1) {
		return
	}
		
	if (!admin) {
		Sleep, 1000
	}
		
	SendChat("/waffen " . frisk_name)
	
	addControlsToStats(getFullName(frisk_name))
	
	Sleep, 300

	if (autoWanted) {
		if (checkResult[1] || checkResult[2]) {
			if (!admin) {
				Sleep, 1000
			}
			
			giveWanteds(frisk_name, "Besitz von Marihauan(samen)", 2)
		}
		
		if (checkResult[3] || checkResult[4] || checkResult[5]) {
			if (!admin) {
				Sleep, 1000
			}
			
			giveWanteds(frisk_name, "Besitz von Materialien/Materialpakete", 2)
		}
	}
}
return

askCheckLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/l Hallo, dies ist eine allgemeine Personenkontrolle!")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("/l Dürfen wir Sie auf Gegenstände, Waffen und Alkohol kontrollieren?")

	if (!admin) {
		Sleep, 750
	}


	SendChat("/l Falls Sie verweigern, erhalten Sie einen Wanted und werden festgenommen.")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("/l Antworten Sie bitte nur mit Ja oder Nein.")
}
return

askPapersLabel:
{
	if (isBlocked() || tv) {
		return
	}

	id := getId()
	
	if (getPlayerSkinID() == 285) {
		SendError("Du kannst im SWAT Modus nicht deine Scheine anfordern.")
		return
	}
	
	if (id == "-1") {
		id := getUserName()
	}
	
	SendChat("/l Bitte zeigen Sie mir Ihre Scheine (( /scheine " . id . " ))")
}
return

cooperationLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	Random, tmp, 1, 2
	
	if (tmp == 1) {
		SendChat("/l Vielen Dank für Ihre Kooperation!")
	} else if (tmp == 2) {
		SendChat("/l Wir danken Ihnen für Ihre Kooperation!")
	}
}
return

getOutOfCarLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	Random, tmp, 1, 3
	
	if (tmp == 1) {		
		SendChat("/l Steigen Sie bitte aus Ihrem Fahrzeug!")
	} else if (tmp == 2) {
		SendChat("/l Bitte steigen Sie aus Ihrem Fahrzeug!")
	} else if (tmp == 3) {
		SendChat("/l Verlassen Sie bitte Ihr Fahrzeug!")
	}
}
return

notAllowedToGoInCarLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/l Ich habe nicht gesagt, dass Sie wieder einsteigen dürfen!")
}
return

openTrunkLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/trunk open")
}
return

checkTrunkLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	checkTrunk()
}
return

askTrunkOpenLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/l Dürfte ich nun Ihren Kofferraum kontrollieren?")
}
return

arrestedCarLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (getPlayerInteriorId() != 0) {
		SendChat("/s Sie sind vorläufig festgenommen")
		
		if (oldVehicleName != "none") {
			SendChat("/s Verlassen Sie das Gebäude und steigen SOFORT in das Dienstfahrzeug (( " . oldVehicleName . " ))")
		} else {
			SendChat("/s Verlassen Sie das Gebäude und steigen SOFORT in das Dienstfahrzeug")
		}
	} else {
		SendChat("/s Sie sind vorläufig festgenommen,")
	
		if (oldVehicleName != "none") {
			SendChat("/s Steigen Sie SOFORT in das Dienstfahrzeug (( " . oldVehicleName . " ))")
		} else {
			SendChat("/s Steigen Sie SOFORT in das Dienstfahrzeug")
		}
		
		SetTimer, ShotAllowedCar, 30000
		SetTimer, ShotAllowedBike, 5000
		SetTimer, TazerAllowed, 5000
	}
}
return

arrestedByNameLabel:
{
	if (isBlocked() || tv) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendError("Du hast keinen Spieler auf Find.")
		return
	}	
	
	if (getPlayerInteriorId() != 0) {
		SendChat("/s @ " . getFullName(playerToFind) . ",  Sie sind vorläufig festgenommen")
		
		if (oldVehicleName != "none") {
			SendChat("/s Verlassen Sie das Gebäude und steigen SOFORT in das Dienstfahrzeug (( " . oldVehicleName . " ))")
		} else {
			SendChat("/s Verlassen Sie das Gebäude und steigen SOFORT in das Dienstfahrzeug")
		}
	} else {
		SendChat("/s @ " . getFullName(playerToFind) . ", Sie sind vorläufig festgenommen,")
	
		if (oldVehicleName != "none") {
			SendChat("/s Steigen Sie SOFORT in das Dienstfahrzeug (( " . oldVehicleName . " ))")
		} else {
			SendChat("/s Steigen Sie SOFORT in das Dienstfahrzeug")
		}
		
		SetTimer, ShotAllowedCar, 30000
		SetTimer, ShotAllowedBike, 5000
		SetTimer, TazerAllowed, 5000
	}
}
return

ramLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		SendError("Du darfst dich in keinem Fahrzeug befinden.")
		return
	}
	
	if (getPlayerInteriorId()) {
		SendError("Du befindest dich in einem Gebäude.")
		return
	}
	
	SendChat("/ram")
}
return

refuseLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/refuse")
}
return

grabLabel:
{
	if (isBlocked() || tv) {
		return
	}
		
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			playerID := getCoordinates()
			x := playerID[1]
			y := playerID[2]
			z := playerID[3]				
			
			for index, grabName in grabList {
				grabID := getPlayerIdByName(grabName)

				if (grabID > -1) {
					ped := getPedById(grabID)
					pedCoords := getPedCoordinates(ped)
					
					if (getDistanceToPoint(x, y, z, pedCoords[1], pedCoords[2], pedCoords[3]) < 5) {
						seatID := getSeatIDs()
						
						if (getVehicleType() == 1 || getVehicleType == 5) {
							if (seatID[2] == -1) {
								SendChat("/grab " . grabName . " 1")
								return
							}
							
							if (seatID[3] == -1) {
								SendChat("/grab " . grabName . " 2")
								return
							}
							
							if (seatID[3] == -1) {
								SendChat("/grab " . grabName . " 3")
								return
							}
							
							SendInfo("Es ist kein Platz im Fahrzeug frei.")
						} else if (getVehicleType() == 4) {
							if (seatID[2] == -1) {
								SendChat("/grab " . grabName . " 1")
								return
							}
							
							SendInfo("Es ist kein Platz auf dem Motorrad frei.")
						}
					}
					
					SendInput, t/grab{space}
					SendInfo("Es sind keine gecufften Spieler in deiner Nähe.")
					return
				}
			}
		} else {
			SendError("Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")	
	}
}
return

manuellGrabLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendInput, t/grab{space}
		} else {
			SendError("Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendError("Du bist nicht in einem Fahrzeug.")
	}
}
return

motorSystemLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			if (getVehicleEngineState()) {
				SendChat("/motor")
				Sleep, 200

				if (autoLock) {
					SendChat("/lock")
				}
			} else {
				if (autoLock) {
					if (!getVehicleLockState()) {
						SendChat("/lock")
					}
				}
				
				SendChat("/motor")
				Sleep, 200
				SendChat("/licht")
			}
		} else {
			SendError("Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")
	}
}
return

~LButton::
{
	if (isBlocked())
		return	
	
	/*
	if (IsDialogOpen()) {
		OnDialogResponse()
	}
	*/
}
return

~F::
{
	if (isBlocked() || tv || getVehicleType() == 6) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		if (autoEngine && isPlayerDriver() && getVehicleEngineState()) {
			SendChat("/motor")
		}
	} else {
		if (autoLock) {
			Loop {
				if (isPlayerDriver() && !getVehicleLockState()) {
					Sleep, 200
					
					if (!getVehicleLockState())
						SendChat("/lock")
					
					break
				}
			}
		}
	}
}
return

lockLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendChat("/lock")
		} else {
			SendError("Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")
	}
}
return

lightLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendChat("/licht")
		} else {
			SendError("Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")
	}
}
return

uclightLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendChat("/uclight")
		} else {
			SendError("Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")
	}
}
return

ucaLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendChat("/uca")
		} else {
			SendError("Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendError("Du bist in keinem Fahrzeug.")
	}
}
return

stopAutomaticSystemsLabel:
{
	if (isBlocked()) {
		return
	}
	
	stoppedAnything := false
	
	if (countdownRunning) {
		SetTimer, CountdownTimer, Off
		
		stoppedAnything := true
		countdownRunning := 0
		
		if (!tv) {
			SendChat("/" . cdChat . " Der Countdown wurde abgebrochen!")
		}
	}
	
	stopFinding()
	
	if (respawnCarsRunning) {
		SetTimer, RespawnCarTimer, Off
		
		stoppedAnything := true
		respawnCarsRunning := false
		
		SendChat("/announce Der Fahrzeug-Respawn wurde abgebrochen!")
	}
	
	if (!stoppedAnything) {
		SendInfo("Es laufen keine Systeme.")
	}
}
return

positionLabel:
{
	sendPosition("d")
}
return

fPositionLabel:
{
	sendPosition("f")
}
return

rPositionLabel:
{
	sendPosition("r")
}
return

acceptJobLabel:
{
	if (isBlocked()) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/d HQ: Wagen " . getVehicleID() . " übernimmt den Auftrag!")
		} else {
			SendChat("/d HQ: Wagen " . getVehicleModelId() . " übernimmt den Auftrag!")
		}
	} else {
		SendChat("/d HQ: " . getFractionTitle() . " " . getUserName() . " übernimmt den Auftrag!")
	}
}
return

doneJobLabel:
{
	if (isBlocked()) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/d HQ: Wagen " . getVehicleID() . " hat den Auftrag ausgeführt!")
		} else {
			SendChat("/d HQ: Wagen " . getVehicleModelId() . " hat den Auftrag ausgeführt!")
		}
	} else {
		SendChat("/d HQ: " . getFractionTitle() . " " . getUserName() . " hat den Auftrag ausgeführt!")
	}
}
return

putWeaponsAwayLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	Random, tmp, 1, 4
	
	if (tmp == 1) {
		SendChat("/s Bitte stecken Sie umgehend Ihre Waffen ein")
	} else if (tmp == 2) {
		SendChat("/s Stecken Sie SOFORT Ihre Waffen ein")
	} else if (tmp == 3) {
		SendChat("/s Legen Sie SOFORT Ihre Waffe weg")
	} else if (tmp == 4) {
		SendChat("/s Nehmen Sie sofort die Waffe runter")
	}
}
return

repeatLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	SendInput, t{up}{enter}
}
return

giveQUickTicketAutoLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	if (!updateTextLabelData()) {
		return
	}	
	
	currentTicket := 0
	
	for i, o in oTextLabelData {
		if (o.PLAYERID != 65535 && o.VEHICLEID == 65535) {	
			pedID := getPedById(o.PLAYERID)
			playerPed := getPedCoordinates(pedID)
			
			if (getDistanceToPoint(getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], playerPed[1], playerPed[2], playerPed[3]) <= 8) {
				if (RegExMatch(o.TEXT, "\[(\d+)\] (\S+)\nWantedlevel: (\d+)\nGrund: (.+)", label_)) {
					if (label_3 > 0) {
						if (label_3 <= 4) {
							if (currentTicket < giveMaxTicket) {
								currentTicket ++
								
								SendChat("/ticket " . label_1 . " " . (label_3 * 750) " Wanted-Ticket (" . label_3 . " Wanted" . (label_3 == 1 ? "" : "s") . ")")
							}
						}
					}
				}
			}
		}
	}
}
return

giveQuickTicketLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	playerForTicket := PlayerInput("Spieler: ")
	if (playerForTicket == "" || playerForTicket == " ") {
		return
	}
	
	if (getFullName(playerForTicket) == "") {
		SendError("Der angegebene Spieler ist nicht online.")
		return
	}
	
	if (getFullName(playerForTicket) == getUserName()) {
		SendError("Der angegebene Spieler ist nicht online.")
		return
	}
		
	playerForTicket := getFullName(playerForTicket)
	
	wantedCount := PlayerInput("Wanteds: ")
	if (wantedCount == "" || wantedCount == " ") {
		return
	}
	
	if (wantedCount is not number) {
		SendError("Ungültiger Wert.")
		return
	}
	
	if (wantedCount > 4 || wantedCount < 1) {
		SendError("Die Wantedanzahl darf nicht höher als 4 und muss mind. 1 sein.")
		return
	}

	SendChat("/ticket " . playerForTicket . " " . (wantedCount * 750) " Wanted-Ticket (" . wantedCount . " Wanted" . (wantedCount == 1 ? "" : "s") . ")")
}
return

autoAcceptEmergencyLabel:
{
	if (isBlocked()) {
		return 
	}

	i := 0
		
	Loop {
		if (i > 150) {
			SendError("Es wurde kein freier Notruf gefunden.")
			break
		}
		
		chat := readChatLine(i)
		
		if (RegExMatch(chat, "Anrufer: (\S+) \(\/notruf (\d+)\), Nummer: (\d+)", emergency)) {
			acceptedByPlayer := 0
			j := i
			
			Loop {
				j--
				
				if (j < 0) {
					break
				}
				
				acceptedChat := readChatLine(j)
				
				if (RegExMatch(acceptedChat, "HQ: (.+) (\S+) übernimmt den Notruf von (\S+)\.", accepted)) {
					takeowerName := accepted2
					
					if (accepted3 == emergency1) {
						acceptedByPlayer := 1
					}
				} else if (RegExMatch(acceptedChat, "Der Spieler benötigt keinen Streifenwagen\.")) {
					acceptedByPlayer := 2
				}
			}
			
			if (acceptedByPlayer == 0) {
				SendChat("/notruf " . emergency2)
				
				Sleep, 200
				
				chat := readChatLine(0)
				
				if (!RegExMatch(chat, "^Der Spieler benötigt kein Streifenwagen\.$")) {
					Sleep, 100
					SendChat("/d HQ: übernehme Notruf-ID " . emergency2 . " von " . emergency1)
					
					services := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=services&value=1")
					IniWrite, % services, ini/Stats.ini, Übernahmen, Services
					
					Sleep, 100
					SendInfo("Du hast bereits " . csecond . formatNumber(services) . cwhite . " Notrufe übernommen.")
					break
				}
			} else if (acceptedByPlayer == 1) {
				if (takeowerName == getUserName()) {
					SendError("Du hast diesen Notruf bereits übernommen.")
				} else {
					SendError("Dieser Notruf wurde bereits von " . takeowerName . " übernommen.")
				}
				
				break
			} else if (acceptedByPlayer == 2) {
				SendError("Der Notruf ist hinfällig, da kein Streifenwagen mehr benötigt wird.")
				break
			}
		} else if (RegExMatch(chat, "HQ: Verbrechen: Überfall GK (\S+) \((\S+)\), Zeuge: Niemand, Verdächtiger: (\S+)", emergency)) {
			currentStore := emergency1			
		
			if (oldStore != currentStore) {
				oldStore := emergency1
				
				storerobs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=storerobs&value=1")
				IniWrite, %storerobs%, ini/Stats.ini, Übernahmen, Storerobs				
				
				Sleep, 100
				SendChat("/d HQ: Übernehme Ladenüberfall von " . emergency3 . "(" . getPlayerIdByName(emergency3) . ") - GK: " . emergency1 . " (" . emergency2 . ")")
				
				Sleep, 100
				SendInfo("Du hast bereits " . csecond . formatNumber(storerobs) . cwhite . " Raubüberfälle übernommen.")
				
				gk(emergency1, emergency2, true)				
			}
			
			break
		}
		
		i++
	}
}
return

acceptEmergencyLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	serviceName := PlayerInput("Notruf-ID: ")
	
	if (serviceName != "") {
		if (getFullName(serviceName) != "") {
			if (getFullName(serviceName) != getUserName()) {
				SendChat("/notruf " . serviceName)
				
				Sleep, 200
				
				if (!RegExMatch(readChatLine(0) . readChatLine(1), "^Der Spieler benötigt kein Streifenwagen\.$")) {
					Sleep, 100
					SendChat("/d HQ: Übernehme Notruf-ID " . serviceName . " von " . getFullName(serviceName))
					
					services := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=services&value=1")
					IniWrite, %services%, ini/Stats.ini, Übernahmen, Services
	
					Sleep, 100
					SendInfo("Du hast bereits " . cSecond . formatNumber(services) . cwhite . " Notrufe übernommen.")
				}
			} else {
				SendError("Du kannst dich nicht selbst übernehmen.")
			}
		} else {
			SendError("Der angegebene Spieler ist nicht online.")
		}
	}
}
return

stopwatchLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	if (stopwatchTime > 0) {
		SetTimer, StopwatchTimer, Off
		
		minutes := Floor(stopwatchTime / 60)
		seconds := stopwatchTime - (minutes * 60)
		
		SendChat("/l .:: Stoppuhr beendet: " . minutes . " Minuten, " . seconds . " Sekunden ::.")
		SendChat("/l .:: Gesamt: " . stopwatchTime . " Sekunden ::.")
		
		stopwatchTime := 0
	} else {
		stopwatchTime := 0
		
		SetTimer, StopwatchTimer, 1000
		
		SendChat("/l .:: Stoppuhr gestartet! ::.")
		SendInfo("Du kannst die Stopuhr mit '" . cSecond . getUserFriendlyHotkeyName(stopwatchNoMods)  . cwhite . "' beenden.")
	}
}
return

useDrugsLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	useDrugs()
}
return 

eatFishLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	if (getPlayerArmor()) {
		SendError("Du kannst mit Armor keine Fische essen.")
		return
	}
	
	if (94 < getPlayerHealth()) {
		SendError("Du kannst erst unter 94 HP Fische essen.")
		return
	}
		

	SendChat("/eat " . currentFish)
	
	currentFish ++
	 
	if (currentFish >= 6) {
		currentFish := 1
	}
}
return

togCellphoneLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	SendChat("/tog")
	
	Sleep, 200
	
	SendInput, {enter}
}
return

firstAidLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	usePaket()
}
return

CountdownLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	if (countdownRunning) {
		SetTimer, CountdownTimer, Off
		
		countdownRunning := 0
		
		SendChat("/" . cdChat . " Der Countdown wurde abgebrochen!")
	} else {
		cdTime := 5
		cdChat := "l"
		cdGoMessage := "Letzte Warnung!"
		
		SendInfo("Du kannst den Countdown mit '" . csecond . stopAutomaticSystemsNoMods . cwhite . "' abbrechen.")
		
		SendChat("/" . cdChat . " Es folgt ein Countdown, sollten Sie sich weigern, erschießen wird Sie!")
		
		SetTimer, CountdownTimer, 1000
		
		countdownRunning := 1
	}
}
return

thanksLabel:
{
	if (isBlocked() || tv) {
		return 
	}
}
:?:/ty::
SendInput, {Enter}
{
	random, rand, 1, 3
	
	if (rand == 1) {
		SendChat("Vielen Dank!")
	} else if (rand == 2) {
		SendChat("Dankeschön!")
	} else if (rand == 3) {
		SendChat("Merci!")
	}
}
return

sorryLabel:
{
	if (isBlocked() || tv) {
		return 
	}
}
:?:/sry::
SendInput, {Enter}
{
	random, rand, 1, 3
	
	if (rand == 1) {
		SendChat("Entschuldigung!")
	} else if (rand == 2) {
		SendChat("Sorry!")
	} else if (rand == 3) {
		SendChat("Tut mir leid!")
	}
}
return

membersLabel:
{
	if (isBlocked()) {
		return 
	}
	
	SendChat("/members")
}
return

crewmembersLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	SendChat("/crewmembers")
}
return

pauseLabel:
	Suspend, permit
	Suspend
	
	IniRead, overlay, ini/settings.ini, settings, overlay, 1
	IniRead, autoUse, ini/Settings.ini, settings, autoUse, 1

	if (A_IsSuspended) {
		SendInfo("Du hast den Keybinder " . cred . "deaktiviert" . cwhite . ".")
		
		SetTimer, TempoTimer, off
		SetTimer, ChatTimer, off
		SetTimer, MainTimer, off
		SetTimer, KillTimer, off
		SetTimer, SecondTimer, off
		
		if (taskInfo) {
			SetTimer, TaskCheckTimer, off
		}

		if (autoLotto) {
			SetTimer, LottoTimer, off
		}

		if (wantedInfo) {
			SetTimer, WantedTimer, off
		}
		
		if (autoUncuff) {
			SetTimer, UncuffTimer, off
		}

		if (admin) {
			SetTimer, TicketTimer, Off
		}

		if (autoUse) {
			SetTimer, SyncTimer, off
		}
	} else {
		SendInfo("Du hast den Keybinder " . cgreen . "aktiviert" . cwhite . ".")
	
		SetTimer, TempoTimer, 100
		SetTimer, ChatTimer, 200
		SetTimer, MainTimer, 200
		SetTimer, KillTimer, 500
		SetTimer, SecondTimer, 1000
		
		if (taskInfo) {
			SetTimer, TaskCheckTimer, 5000
		}

		if (autoLotto) {
			SetTimer, LottoTimer, 2000
		}
		
		if (autoUncuff) {
			SetTimer, UncuffTimer, 500
		}

		if (wantedInfo) {
			SetTimer, WantedTimer, 1000
		}

		if (admin) {
			SetTimer, TicketTimer, 1000
		}

		if (autoUse) {
			SetTimer, SyncTimer, 6000
		}
	}
return

:?:/trash::
:?:/trashs::
SendInput, {Enter}
{

	dialog := ""
	coords := getCoordinates()
	
	i := trashcan.MaxIndex()
	j := 0
	
	while (i > 1) {
		i := i - 1
		j := 0
		
		while (j < i) {
			j := j + 1
		
			if (Floor(GetDist(coords, trashcan[j])) > Floor(GetDist(coords, trashcan[j + 1]))) {
				temp := trashcan[j]
				trashcan[j] := trashcan[j + 1]
				trashcan[j + 1] := temp
			}
		}
	}
	
	Loop % trashcan.MaxIndex() {
		if (trashcan[A_Index][5] == -1) {
			temp := "{C3C3C3}Unbekannt"
		} else {
			min := Floor(trashcan[A_Index][5] / 60)
			sec := mod(trashcan[A_Index][5], 60)
			
			if(min > 9) {
				temp := "{FF0000}" min "min, " sec "s"
			} else if(min > 0) {
				temp := "{FFEE00}" min "min, " sec "s"
			} else if(min==0) {
				temp := "{00FF00}Frei"
			}
		}
		
		dialog .=  trashcan[A_Index][6] "`t" trashcan[A_Index][4] "`t" temp "`t" Floor(getDist(coords, trashcan[A_Index])) "m`n"
	}
	
	ShowDialog(5, "Übersicht der Mülltonnen", "ID`tOrt`tStatus`tEntfernung`n" dialog, "Markieren", "Abbrechen")
}
return

:?:/stats::
{
	SendChat("/stats")
	
	Sleep, 200
	
	if (RegExMatch(getDialogText(), "(.*)Drogen: (\d+)g(.*)", drugs_)) {
		IniWrite, % drugs_2, ini/settings.ini, Items, drugs
		
		if (drugs_2 == 0) {
			if (infoOvEnabled) {
				imageDestroy(ov_Drugs)
				textDestroy(ov_DrugsText)
			}	
		}
	} else {
		SendError("Beim Auslesen der Drogen ist ein Fehler aufgetreten.")
	}
	
	if (InStr(getDialogText(), "Erste-Hilfe-Paket")) {
		IniWrite, 1, ini/settings.ini, Items, firstaid
	} else {
		IniWrite, 0, ini/settings.ini, Items, firstaid
	
		if (infoOvEnabled) {
			imageDestroy(ov_Firstaid)
		}		
	}
	
	if (InStr(getDialogText(), "Benzin Kanister")) {
		IniWrite, 1, ini/settings.ini, Items, canister
	} else {
		IniWrite, 0, ini/settings.ini, Items, canister
	
		if (infoOvEnabled) {
			imageDestroy(ov_Canister)
		}		
	}
	
	if (InStr(getDialogText(), "Lagerfeuer")) {	
		if (RegExMatch(getDialogText(), "(.*)Lagerfeuer \((\d+)\)(.*)", campfire_)) {
			iniWrite, % campfire_2, ini/settings.ini, Items, campfire
		}
	} else {
		iniWrite, 0, ini/settings.ini, Items, campfire
	
		if (infoOvEnabled) {
			imageDestroy(ov_Campfire)
			textDestroy(ov_CampfireText)
		}		
	}
	
	if (infoOvEnabled) {
		ov_Info(0)
		ov_Info()
	}
}
return

:?:/ov::
:?:/overlay::
{
	if (ovMoveMode) {
		SendError("Diese Funktion ist während des Overlaysverschiebens deaktiviert.")
		return
	}
	
	SendInfo(cSecond . "1" . cWhite . ": Spotify Overlay " . cOrange . "|" . cSecond . " 2" . cWhite . ": Cooldown Overlay")
	SendInfo(cSecond . "3" . cWhite . ": Ping/FPS Overlay " . cOrange . "|" . cSecond . " 4" . cWhite . ": Info Overlay")
	SendInfo(cSecond . "5" . cWhite . ": Alarm Overlay " . cOrange . "|" . cSecond . " 6" . cWhite . ": Partner Overlay")
	
	overlayInput := PlayerInput("Overlay de-/aktivieren: ")
	if (overlayInput == 1) {
		if (spotifyOvEnabled) {
			ov_Spotify(0)
			
			spotifyOvEnabled := false
			
			SetTimer, SpotifyOverlayTimer, off
			SendInfo("Spotify Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Spotify()
			
			spotifyOvEnabled := true
			
			SendInfo("Spotify Overlay " . cGreen . "aktiviert" . cWhite . ".")
		}
	} else if (overlayInput == 2) {
		if (cooldownOvEnabled) {			
			ov_Cooldown(0)
			
			cooldownOvEnabled := false

			SetTimer, CooldownOverlayTimer, Off
			SendInfo("Cooldown Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Cooldown()
			
			cooldownOvEnabled := true
			
			SendInfo("Cooldown Overlay " . cGreen . "aktiviert" . cWhite . ".")
		}
	} else if (overlayInput == 3) {
		if (pingOvEnabled) {			
			ov_Ping(0)
			
			pingOvEnabled := false

			SetTimer, PingOverlayTimer, Off
			SendInfo("FPS/Ping Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Ping()
			
			pingOvEnabled := true
			
			SendInfo("FPS/Ping Overlay " . cGreen . "aktiviert" . cWhite . ".")
		}
	} else if (overlayInput == 4) {
		if (infoOvEnabled) {			
			ov_Info(0)
			
			infoOvEnabled := false

			SendInfo("Informations Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Info()
			
			infoOvEnabled := true
			
			SendInfo("Informations Overlay " . cGreen . "aktiviert" . cWhite . ".")
		}
	} else if (overlayInput == 5) {
		if (alertOvEnabled) {			
			ov_Alert(0)
			
			alertOvEnabled := false

			SetTimer, AlertOverlayTimer, Off
			SendInfo("Alarm Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Alert()
			
			alertOvEnabled := true
			
			SendInfo("Alarm Overlay " . cGreen . "aktiviert" . cWhite . ".")
		}
	} else if (overlayInput == 6) {
		if (partnerOvEnabled) {
			ov_Partner(0) 
			
			partnerOvEnabled := false
			
			SetTimer, PartnerOverlayTimer, off
			SendInfo("Partner Overlay " . cRed . "deaktiviert" . cWhite . ".")
		} else {
			ov_Partner()
		
			partnerOvEnabled := true
			
			SendInfo("Partner Overlay " . cRed . "aktiviert" . cWhite . ".")
		}
	}
}
return

:?:/ovall::
{	
	if (overlayEnabled) {
		overlayEnabled := false
		
		spotifyOvEnabled := false
		cooldownOvEnabled := false
		pingOvEnabled := false
		infoOvEnabled := false
		alertOvEnabled := false
		partnerOvEnabled := false 
		
		destroyOverlay()
		
		SendInfo("Das Overlay wurde " . cRed . "deaktiviert" . cWhite . ".")
	} else {
		overlayEnabled := true
	
		spotifyOvEnabled := true
		cooldownOvEnabled := true
		pingOvEnabled := true
		infoOvEnabled := true
		alertOvEnabled := true
		partnerOvEnabled := true
		
		ov_Spotify()
		ov_Cooldown()
		ov_Ping()
		ov_Info()
		ov_Alert()
		ov_Partner()
		
		SendInfo("Das Overlay wurde " . cGreen . "aktiviert" . cWhite . ".")
	}
}
return

:?:/moveov::
:?:/ovmove::
{
	if (ovMoveMode) {
		ovMoveMode := 0
		
		SendInfo("Das Verschieben des Overlays wurde " . cRed . "beendet" . cWhite . ".")
		SendInfo("Nutze " . cOrange . "/osave" . cWhite . " zum speichern.")
	} else {
		SendInfo(cSecond . "1" . cWhite . ": Spotify Overlay " . cOrange . "|" . cSecond . " 2" . cWhite . ": Cooldown Overlay")
		SendInfo(cSecond . "3" . cWhite . ": Alarm Overlay " . cOrange . "|" . cSecond . " 4" . cWhite . ": Ping / FPS Overlay")
		SendInfo(cSecond . "5" . cWhite . ": Info Overlay")
	
		overlayInput := PlayerInput("Overlay-ID: ")
		if (overlayInput == 1) {
			if (spotifyOvEnabled) {
				ovMoveMode := 1
				
				SendInfo("Das Verschieben des Spotify Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
				SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")
			} else {
				SendError("Das Spotify Overlay muss aktiviert sein.")
			}
		} else if (overlayInput == 2) {
			if (cooldownOvEnabled) {
				ovMoveMode := 2
				
				SendInfo("Das Verschieben des Cooldown Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
				SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")			
			} else {
				SendError("Das Cooldown Overlay muss aktiviert sein.")
			}
		} else if (overlayInput == 3) {
			if (alertOvEnabled) {
				ovMoveMode := 3
				
				SendInfo("Das Verschieben des Alarm Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
				SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
			} else {
				SendError("Das Gegner Overlay muss aktiviert sein.")
			}
		} else if (overlayInput == 4) {
			if (pingOvEnabled) {
				ovMoveMode := 4
				
				SendInfo("Das Verschieben des FPS/Ping Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
				SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
			} else {
				SendError("Das FPS/Ping Overlay muss aktiviert sein.")
			}
		} else if (overlayInput == 5) {
			if (infoOvEnabled) {
				SendInfo("Folgende Sub-Overlays sind verfügbar zum bewegen:")
				SendInfo(cSecond . "1:" . cWhite . "Telefon-Status")
				SendInfo(cSecond . "2:" . cWhite . "Erste-Hilfe-Paket")
				SendInfo(cSecond . "3:" . cWhite . "Kanister (nur im Fahrzeug)")
				SendInfo(cSecond . "4:" . cWhite . "Gekochte Fische")
				SendInfo(cSecond . "5:" . cWhite . "Ungekochte Fische")
				SendInfo(cSecond . "6:" . cWhite . "Lagerfeuer")
				SendInfo(cSecond . "7:" . cWhite . "Drogen")

				typ := PlayerInput("Typ: ")
				if (typ == 1) {
					ovMoveMode := 5
					
					SendInfo("Das Verschieben des Handy Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
				} else if (typ == 2) {
					ovMoveMode := 6
					
					SendInfo("Das Verschieben des Erste-Hilfe Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
				} else if (typ == 3) {
					ovMoveMode := 7
					
					SendInfo("Das Verschieben des Kanister Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")				
				} else if (typ == 4) {
					ovMoveMode := 8
					
					SendInfo("Das Verschieben des Gekochten Fische Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
				} else if (typ == 5) {
					ovMoveMode := 9
					
					SendInfo("Das Verschieben des Ungekochten Fische Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")		
				} else if (typ == 6) {
					ovMoveMode := 10
					
					SendInfo("Das Verschieben des Lagerfeuer Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
				} else if (typ == 7) {
					ovMoveMode := 11
					
					SendInfo("Das Verschieben des Drogen Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
					SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")						
				} else {
					SendInfo("Folgende Sub-Overlays sind verfügbar zum bewegen:")
					SendInfo(cSecond . "1:" . cWhite . "Telefon-Status")
					SendInfo(cSecond . "2:" . cWhite . "Erste-Hilfe-Paket")
					SendInfo(cSecond . "3:" . cWhite . "Kanister (nur im Fahrzeug)")
					SendInfo(cSecond . "4:" . cWhite . "Gekochte Fische")
					SendInfo(cSecond . "5:" . cWhite . "Ungekochte Fische")
					SendInfo(cSecond . "6:" . cWhite . "Lagerfeuer")
					SendInfo(cSecond . "7:" . cWhite . "Drogen")
					return
				}			
			} else {
				SendError("Das Info Overlay muss aktiviert sein.")
			}
		} else if (overlayInput == 6) {
			if (pingOvEnabled) {
				ovMoveMode := 12
				
				SendInfo("Das Verschieben des Partner Overlays wurde " . cGreen . "aktiviert" . cWhite . ".")
				SendInfo("Verschieben: " . cOrange . "Pfeiltasten" . cWhite . ", Speichern: " . cOrange . "/osave")	
			} else {
				SendError("Das Partner Overlay muss aktiviert sein.")
			}
		}
	}
}
return

:?:/ovsave::
:?:/saveov::
{
	saved := true
	
	if (ovMoveMode == 1) {
		IniWrite, % spotifyXPos, ini/settings.ini, Overlay, spotifyXPos
		IniWrite, % spotifyYPos, ini/settings.ini, Overlay, spotifyYPos
	} else if (ovMoveMode == 2) {
		IniWrite, % cooldownXPos, ini/settings.ini, Overlay, cooldownXPos
		IniWrite, % cooldownYPos, ini/settings.ini, Overlay, cooldownYPos
	} else if (ovMoveMode == 3) {
		IniWrite, % pingXPos, ini/settings.ini, Overlay, pingXPos
		IniWrite, % pingYPos, ini/settings.ini, Overlay, pingYPos
	} else if (ovMoveMode == 4) {
		IniWrite, % infoPhoneX, ini/settings.ini, overlay, infoPhoneX
		IniWrite, % infoPhoneY, ini/settings.ini, overlay, infoPhoneY	
	} else if (ovMoveMode == 5) {
		IniWrite, % infoFirstaidX, ini/settings.ini, overlay, infoFirstaidX
		IniWrite, % infoFirstaidY, ini/settings.ini, overlay, infoFirstaidY
	} else if (ovMoveMode == 6) {
		IniWrite, % infoCanisterX, ini/settings.ini, overlay, infoCanisterX
		IniWrite, % infoCanisterY, ini/settings.ini, overlay, infoCanisterY
	} else if (ovMoveMode == 7) {
		IniWrite, % infoFishCookedX, ini/settings.ini, overlay, infoFishCookedX
		IniWrite, % infoFishCookedY, ini/settings.ini, overlay, infoFishCookedY
	} else if (ovMoveMode == 8) {
		IniWrite, % infoFishUncookedX, ini/settings.ini, overlay, infoFishUncookedX
		IniWrite, % infoFishUncookedY, ini/settings.ini, overlay, infoFishUncookedY
	} else if (ovMoveMode == 9) {
		IniWrite, % infoCampfireX, ini/settings.ini, overlay, infoCampfireX
		IniWrite, % infoCampfireY, ini/settings.ini, overlay, infoCampfireY
	} else if (ovMoveMode == 10) {
		IniWrite, % infoDrugsX, ini/settings.ini, overlay, infoDrugsX
		IniWrite, % infoDrugsY, ini/settings.ini, overlay, infoDrugsY
	} else if (ovMoveMode == 11) {
		IniWrite, % alertXPos, ini/settings.ini, overlay, alertXPos
		IniWrite, % alertYPos, ini/settings.ini, overlay, alertYPos
	} else if (ovMoveMode == 12) {
		IniWrite, % partnerX, ini/settings.ini, overlay, partnerX
		IniWrite, % partnerY, ini/settings.ini, overlay, partnerY
	} else {
		saved := false
		SendError("Der Overlay-Move Modus ist nicht aktiviert.")
	}
	
	if (saved) {
		ovMoveMode := 0
		SendInfo("Die Position des Overlays wurde gespeichert. Verschieben " . cRed . "beendet" . cWhite . ".")
	}
}
return

:?:/messer::
{
	SendChat("/sellgun " . getUserName() . " messer 1")
}
return

:?:/relog::
SendInput, {Enter}
{
	reconnectRPG()
}
return

:?:/auf::
SendInput, {Enter}
{	
	openGate()
}
return

:?:/to::
SendInput, {Enter}
{
	SendChat("/trunk open")
}
return

:?:/tc::
SendInput, {Enter}
{
	checkTrunk()
}
return

:?:/heal::
SendInput, {Enter}
{
	healPlayer()
}
return

:?:/usedrugs::
SendInput, {Enter}
{
	useDrugs()
}
return

:?:/erstehilfe::
SendInput, {Enter}
{
	usePaket()
}
return

:?:/pbenter::
SendInput, {Enter}
{	
	if (!isPlayerInAnyVehicle()) {
		if (isPlayerInRangeOfPoint(901.2969, -1203.0950, 16.9832, 3)) {
			if (getPlayerMoney() >= 2500) {
				if (getPlayerArmor()) {
					SendChat("/zivil")
					Sleep, 200
				}
				
				SendChat("/pbenter")
			} else {
				SendError("Du benötigst mindestens 2.500$.")
			}
		} else {
			SendError("Du bist nicht an der Paintball-Arena.")
		}
	} else {
		SendError("Du darfst dich in keinem Fahrzeug befinden.")
	}
}
return

:?:/pbexit::
SendInput, {Enter}
{
	cantExit := 0
	
	SendChat("/pbexit")
	Sleep, 200
	
	Loop, 5 {
		if (InStr(readChatLine(A_Index - 1), "Fehler: Nachdem du getroffen wurdest, musst du 5 Sekunde warten, um die Arena zu verlassen.")) {
			cantExit := 1
		}
	}
		
	if (!cantExit) {
		if (isZivil) {
			Sleep, 1000
			SendChat("/zivil")
		}
		
		isPaintball := false
	}
}
return

:?:/time::
SendInput, {Enter}
{
	SendChat("/time")
	Sleep, 200
	
	adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
	cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
	
	if (RegExMatch(cText, "(.+)In Behandlung: (\d+)", cText_)) {
		writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . formatTime(cText_2) . " im KH")
		SendInfo("Du bist noch " . csecond . formatTime(cText_2) . cwhite . " im Krankenhaus.")
	} else if (RegExMatch(cText, "(.+)Knastzeit: (\d+)", cText_)) {
		if (getPlayerInteriorId() == 1) {
			writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . formatTime(cText_2) . " im Prison")
			SendInfo("Du bist noch " . csecond . formatTime(cText_2) . cwhite . " im Prison.")
		} else {
			writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . formatTime(cText_2) . " im Knast")
			SendInfo("Du bist noch " . csecond . formatTime(cText_2) . cwhite . " im Knast.")
		}
	}
}
return

:?:/fc::
:?:/findcar::
SendInput, {Enter}
{
	SendChat("/findcar")
	
	Sleep, 250
	
	Loop, 5 {
		if (RegExMatch(readChatLine(A_Index - 1), "^GPS: Dein (.*) wurde in der Map rot markiert\.$", o_)) {
			if (isMarkerCreated()) {
				coords := coordsFromRedmarker()
				
				SendInfo("Dein " . o_1 . " befindet sich in " . calculateZone(coords[1], coords[2], coords[3]))
				return
			}
		}
	}
}
return

:?:/fill::
:?:/tanken::
SendInput, {Enter}
{
	if (!isPlayerInAnyVehicle() || !isPlayerDriver()) {
		SendError("Du bist nicht der Fahrer eines Fahrzeuges.")
	} else if (!isPlayerAtGasStation()) {
		SendError("Du bist nicht in der Nähe einer Tankstelle.")
	} else if (getVehicleType() == 6) {
		SendError("Du sitzt auf einem Fahrrad.")
	} else {
		refillCar()
	}
}
return

:?:/q::
{
	stopFinding()
	
	global tempo 				:= 80
	
	global giveMaxTicket		:= 3
	
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
	global admission			:= 0
	global deathArrested 		:= 0
	global lastSpeed 			:= 0	
	global hasEquip				:= 0
	global isZivil				:= 0
	global getOldKomplex		:= 0
	global oldFriskTime			:= 0
	global oldLocalTime			:= 0
	global pbKillStreak 		:= 0
	global currentSpeed 		:= 0
	global countdownRunning 	:= 0
	global autoFindMode		 	:= 0
	global IsPayday				:= 0
	global drugcooldown			:= 0
	global healcooldown			:= 0
	global admincooldown		:= 0
	global ooccooldown			:= 0
	global findcooldown			:= 0
	
	global oldWanted            := -1
	global agentID 				:= -1
	global oldVehicle			:= -1
	global targetid				:= -1
	global wantedIA				:= -1
	global wantedContracter		:= -1
	
	global wantedIAReason		:= ""
	global oldInviteAsk			:= ""
	global target				:= ""
	global lastSpeedUser 		:= ""
	global lastTicketReason 	:= ""
	global lastTicketPlayer 	:= ""
	global requestName			:= ""
	global oldFrisk				:= ""
	global oldLocal				:= ""
	global cooldownString		:= ""
	
	global fillTimeout_ 		:= true
	global canisterTimeout_ 	:= true
	global mautTimeout_ 		:= true
	global healTimeout_ 		:= true
	global cookTimeout_ 		:= true
	global equipTimeout_ 		:= true
	global jailgateTimeout_ 	:= true 
	global GateTimeout_ 		:= true
	global fishTimeout_ 		:= true
	global localTimeout_ 		:= true
	global garbageTimeout_		:= true 
	global fishSellTimeout_		:= true

	global agentTog				:= false
	global startOverlay			:= false
	global isArrested			:= false
	global isCuffed				:= false
	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
	global gotPoisened			:= false
	
	global ovMoveMode			:= false
	global alertActive  		:= false
	
	global alertString 			:= ""
	global oldSpotifyTrack		:= ""
	global oldVehicleName		:= "none"

	Loop, 5 {
		fishName_%A_Index% := "nichts"
		fishLBS_%A_Index% := 0
		fishHP_%A_Index% := 0
	}

	Loop, 5 {
		fishName%A_Index% := "nichts"
		fishHP%A_Index% := 0
		fishPrice%A_Index% := 0
	}
	
	SendInput, /q{enter} 
	
	destroyOverlay()
}
return

:?:/entf::
{
	name := PlayerInput("Entführer: ")
	name := getFullName(name)
	
	if (name == "") {
		SendError("Der angegebene Spieler ist offline.")
		return
	} else if (name == getUserName()) {
		SendError("Du kannst dir selber keine Wanteds eintragen.")
		return
	}
	
	SendInfo(csecond . "1" . cWhite . ": Bürger, " . csecond . "2" . cWhite . ": Staatsbeamter")
		
	wantedType := PlayerInput("Typ: ")
		
	if (wantedType == "1") {
		giveWanteds(name, "Entführung", 2)
	} else if (wantedType == "2") {
		giveWanteds(name, "Entführung von Beamten", 4)
	} else {
		SendError("Es gibt nur Typ 1 (normal) und Typ 2 (Beamter).")
	}
}
return

:?:/sb::
{
	name := PlayerInput("Sachbeschädigung: ")
	name := getFullName(name)
	
	if (name == "") {
		SendError("Der angegebene Spieler ist offline.")
		return
	} else if (name == getUserName()) {
		SendError("Du kannst dir selber keine Wanteds eintragen.")
		return
	}
	
	giveWanteds(name, "Sachbeschädigung", 2)
}
return

:?:/rew::
:?:/rewtd::
:?:/rewanted::
{
	reInput := PlayerInput("Spieler / ID: ")
	if (reInput == "" || reInput == " ") {
		return
	} else if (getFullName(reInput) == "") {
		SendError("Der Spieler ist nicht online.")
		return
	} else if (getFullName(reInput) == getUserName()) {
		SendError("Du kannst dir selbst keine Wanteds eintragen.")
		return
	}
	
	reCount := PlayerInput("Anzahl: ")
	if (reCount == "" || reCount == " ") {
		return
	} else if (reCount is not number) {
		SendError("Es wurde ein ungültiger Wert angegeben.")
		return
	} else if (rewantedting) {
		SendInfo("Die Vergabe läuft bereits. Du kannst es mit '" . cSecond . stopAutomaticSystemsNoMods . cwhite . "' beenden.")
		return
	}
	
	givedRewanted := 0
	rewantedting := true
	
	Loop, %reCount% {
		if (rewantedting) {
			SendChat("/suspect " . getFullName(reInput) . " Re-Wanted")
			Sleep, 100
			
			if (InStr(readChatLine(0), "HQ: Verbrechen: Re-Wanted, Zeuge: " . getUserName() . ", Verdächtiger: " . getFullName(reInput))) {
				givedRewanted ++
			}
		} else {
			break
		}
	}
		
	if (givedRewanted > 0) {
		wanteds := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=wanteds&value=" . wanteds)
		IniWrite, %wanteds%, ini/Stats.ini, Vergaben, Wanteds
		
		SendInfo("Du hast bereits " . csecond . formatNumber(wanteds) . cwhtie . " Wanteds vergeben.")	
	}
}
return

:?:/clearpoints::
:?:/tst::
{
	name := PlayerInput("Spieler: ")
	if (name == "" || name == " ") {
		return
	} else if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	amount := PlayerInput("Anzahl: ")
	if (amount == "" || amount == " ") {
		return
	} else if (amount is not number) {
		SendError("Du musst eine Zahl angeben.")
		return
	}
	
	SendChat("/licunban " . name . " points " . amount)
	Sleep, 200
	
	Loop, 5 {
		if (InStr(readChatLine(A_Index - 1), "Dieser Befehl ist ab Rang 9.")) {
			SendChat("/d HQ: " . getFullName(name) . " bitte " . amount . " Strafpunkte löschen!")
			break
		}
	}
}
return


:?:/frag::
{
	SendInfo("Frag-Uhrzeit wurde erfolgreich gespeichert.")
	
	currentTime := A_Now
	Frags ++
	
	IniWrite, %Frags%, ini/Frags.ini, %currentTime%, Frags
}
return

:?:/setjob::
{
	jobInput := PlayerInput("Job: ")
	
	if (InStr(jobInput, "Dro")) {
		job := 2
		
		SendInfo("Du hast deinen Job auf " . csecond . "Drogendealer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Waf")) {
		job := 3
		
		SendInfo("Du hast deinen Job auf " . csecond . "Waffendealer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Bus")) {
		job := 4
		
		SendInfo("Du hast deinen Job auf " . csecond . "Busfahrer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Pil")) {
		job := 5
		
		SendInfo("Du hast deinen Job auf " . csecond . "Pilot " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Fis") || InStr(jobInput, "Hoch")) {
		job := 6
		
		SendInfo("Du hast deinen Job auf " . csecond . "Hochseefischer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Anw")) {
		job := 7
		
		SendInfo("Du hast deinen Job auf " . csecond . "Anwalt " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Det")) {
		job := 8
		
		SendInfo("Du hast deinen Job auf " . csecond . "Detektiv " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Tru")) {
		job := 9
		
		SendInfo("Du hast deinen Job auf " . csecond . "Trucker " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Far")) {
		job := 10
		
		SendInfo("Du hast deinen Job auf " . csecond . "Farmer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Zug")) {
		job := 11
		
		SendInfo("Du hast deinen Job auf " . csecond . "Zugfahrer " . cwhite . "gesetzt.")
	} else if (InStr(jobInput, "Gär") || InStr(jobInput, "Gar")) {
		job := 12
		
		SendInfo("Du hast deinen Job auf " . csecond . "Gärtner " . cwhite . "gesetzt.")
	} else {
		SendInfo("Unbekannter Job.")
		return
	}
	
	IniWrite, %job%, ini/Settings.ini, Job, Job
}
return

:?:/setline::
:?:/setlinie::
{
	lineInput := PlayerInput("Linie: ")
	if (lineInput == "" || lineInput == " ") {
		return
	}
	
	if (lineInput is not number) {
		SendError("Du musst eine gültige Nummer (1 - 21) eintragen.")
		return
	}
	
	if (lineInput > 21 || lineInput < 1) {
		SendError("Du musst eine gültige Nummer (1 - 21) eintragen.")
		return
	}

	jobLine := lineInput + 1
	IniWrite, %jobLine%, ini/Settings.ini, job, jobLine
	
	SendInfo("Du hast deine Linie auf '" . csecond . lineInput . cwhite . "' gesetzt.")
}
return

:?:/l1::
selectLine(1)
return

:?:/l2::
selectLine(2)
return

:?:/l3::
selectLine(3)
return

:?:/l4::
selectLine(4)
return

:?:/l5::
selectLine(5)
return

:?:/l6::
selectLine(6)
return

:?:/l7::
selectLine(7)
return

:?:/l8::
selectLine(8)
return

:?:/l9::
selectLine(9)
return

:?:/l10::
selectLine(10)
return

:?:/l11::
selectLine(11)
return

:?:/l12::
selectLine(12)
return

:?:/l13::
selectLine(13)
return

:?:/l14::
selectLine(14)
return

:?:/l15::
selectLine(15)
return

:?:/l16::
selectLine(16)
return

:?:/l17::
selectLine(17)
return

:?:/l18::
selectLine(18)
return

:?:/l19::
selectLine(19)
return

:?:/l20::
selectLine(20)
return

:?:/l21::
selectLine(21)
return

:?:/wafk::
{
	playerID := PlayerInput("Spieler: ")
	if (playerID == "" || playerID == " ") {
		return
	} else if (getFullName(playerID) == "") {
		SendError("Der Spieler ist nicht online.")
		return
	} else if (getFullName(playerID) == getUserName()) {
		SendError("Du kannst dich nicht selbst melden.")
		return
	}
	
	playerName := getFullName(playerID)
	
	SendChat("/a " . playerName . " (ID: " . getPlayerIdByName(playerName) . ") AFK mit Wanteds vor Beamten im Interior! Bitte kicken!")
}
return

:?:/tasks::
{
	taskCount := tasks.Length()
	
	if (taskCount == 0) {
		SendInfo("Es sind keine offenen Tasks vorhanden.")
		return
	}
	
	Sleep, 200
	
	pageCount := Ceil(taskCount / 15)
	taskPageID := 0
	page := 0
	openTasks := "{FFBB00}ID {FFFFFF}- {FFBB00}Zeit {FFFFFF}- {FF4040}Spieler {FFFFFF}- {00F0CC}Aufgabe {FFFFFF}- {99CC00}Auftraggeber`n"
	
	for index, task in tasks {
		if (taskPageID >= 15) {
			ShowDialog(0, "Ausstehende Tasks", openTasks, "Weiter >>")
			
			openTasks := "{FFBB00}ID {FFFFFF}- {FFBB00}Zeit {FFFFFF}- {FF4040}Spieler {FFFFFF}- {00F0CC}Aufgabe {FFFFFF}- {99CC00}Auftraggeber`n"
			taskPageID := 0
			page++
			
			Sleep, 500
			
			Loop {
				if (IsInChat()) {
					continue
				} else {
					break
				}
			}
		}
		
		taskSubjectID := getPlayerIdByName(task["subject"])
		
		if (taskSubjectID == -1) {
			openTasks .= "`n{FFBB00}" . task["id"] . " {FFFFFF}- {FFBB00}" . task["time"] . " {FFFFFF}- {FF4040}" . task["subject"] . "{FFFFFF} - {00F0CC}" . task["task"] . " {FFFFFF}- {99CC00}" . task["creator"]
		} else {
			openTasks .= "`n{FFBB00}" . task["id"] . " {FFFFFF}- {FFBB00}" . task["time"] . " {FFFFFF}- {33CC00}" . task["subject"] . " (" . taskSubjectID . ") {FFFFFF}- {00F0CC}" . task["task"] . "{FFFFFF} - {99CC00}" . task["creator"]
		}
		
		taskPageID++
	}
	ShowDialog(0, "Ausstehende Tasks", openTasks, "OK")
}
return

:?:/ontasks::
{
	if (tasks.Length() == 0) {
		SendInfo("Es sind keine offenen Tasks vorhanden.")
		return
	}
	
	taskSubjectsOnline := 0
	
	for index, task in tasks {
		taskSubjectID := getPlayerIdByName(task["subject"])
		
		if (taskSubjectID != -1) {
			AddChatMessage(PREFIX . csecond . task["id"] . cwhite . ": " . csecond . task["subject"] . cwhite . " (ID: " . csecond . taskSubjectID . cwhite . ") - " . csecond . task["task"])
			taskSubjectsOnline++
		}
	}
	
	if (!taskSubjectsOnline) {
		SendInfo("Es ist kein Spieler online, für den ein Task existiert.")
	}
}
return

:?:/addtask::
{
	subject := PlayerInput("Spieler: ")
	fullSubject := getFullName(subject)
	
	if (fullSubject != "") {
		subject := fullSubject
	}
	
	newTask := PlayerInput("Aufgabe: ")
	if (newTask == "" || newTask == " ") {
		return
	}
	
	url := baseURL . "api/tasks?username=" . username . "&password=" . password . "&action=add&subject=" . subject . "&task=" . newTask
	
	addtaskResult := UrlDownloadToVar(url)
	
	if (addtaskResult == "ERROR_BAD_LINK") {
		SendInfo("Fehlerhafte Parameterübergabe.")
	} else if (addtaskResult == "ERROR_USER_NOT_FOUND") {
		SendInfo("Der Account mit dem Namen " . username . " wurde nicht gefunden.")
	} else if (addtaskResult == "ERROR_WRONG_PASSWORD") {
		SendInfo("Zugriff verweigert, das Passwort ist falsch.")
	} else if (addtaskResult == "ERROR_ACCESS_DENIED") {
		SendInfo("Zugriff verweigert.")
	} else if (addtaskResult == "ERROR_NO_SUCH_ACTION") {
		SendInfo("Diese Aktion wird nicht unterstützt.")
	} else if (addtaskResult == "ERROR_MYSQL_QUERY") {
		SendInfo("Es ist ein Fehler bei der MySQL-Abfrage aufgetreten.")
	} else if (addtaskResult == "ERROR_CONNECTION") {
		SendInfo("Aktuell liegt ein Fehler in der Verbindung zum Server vor.")
	} else if (addtaskResult == "SUCCESS") {
		SendChat("/d HQ: Neuer Task - Betreffender Spieler: " . subject . ", Aufgabe: " . newTask)
	} else {
		SendInfo("Es ist ein unbekannter Fehler aufgetreten: " . csecond . addtaskResult)
	}
}
return

:?:/dtask::
:?:/deltask::
{
	deltaskID := PlayerInput("Task-ID: ")
	if (deltaskID == "" || deltaskID == " ") {
		return
	}
	
	url := baseURL . "api/tasks?username=" . username . "&password=" . password . "&action=delete&id=" . deltaskID
	
	deltaskResult := UrlDownloadToVar(url)
	
	if (deltaskResult == "ERROR_BAD_LINK") {
		SendInfo("Fehlerhafte Parameterübergabe.")
	} else if (deltaskResult == "ERROR_USER_NOT_FOUND") {
		SendInfo("Der Account mit dem Namen " . username . " wurde nicht gefunden.")
	} else if (deltaskResult == "ERROR_WRONG_PASSWORD") {
		SendInfo("Zugriff verweigert, das Passwort ist falsch.")
	} else if (deltaskResult == "ERROR_ACCESS_DENIED") {
		SendInfo("Zugriff verweigert.")
	} else if (deltaskResult == "ERROR_NO_SUCH_ACTION") {
		SendInfo("Diese Aktion wird nicht unterstützt.")
	} else if (deltaskResult == "ERROR_MYSQL_QUERY") {
		SendInfo("Es ist ein Fehler bei der MySQL-Abfrage aufgetreten.")
	} else if (deltaskResult == "ERROR_CONNECTION") {
		SendInfo("Aktuell liegt ein Fehler in der Verbindung zum Server vor.")
	} else if (deltaskResult == "SUCCESS") {
		SendChat("/d HQ: Task " . deltaskID . " wurde bearbeitet und gelöscht!")
	} else {
		SendInfo("Es ist ein unbekannter Fehler aufgetreten: " . csecond . deltaskResult)
	}
}
return

:?:/afk::
{
	afk := UrlDownloadToVar(baseURL . "api/isafk?username=" . username . "&password=" . password)
	StringSplit, afk_, afk, ~
	
	if (afk_1 == "error") {
		SendInfo("Es ist ein Fehler aufgetreten: " . csecond . afk_2)
		return
	} else if (afk_1) {
		SendChat("/f HQ: Ich bin nun nicht mehr afk und melde mich zurück!")
		return
	} else {
		afkTime := PlayerInput("Zeit: ")
		if (afkTime != "") {
			if (afkTime is number) {
				SendChat("/f HQ: Ich melde für " . afkTime . " Minuten afk!")
			} else {
				SendError("Du musst eine Zeit in Minuten angeben")
				return
			}
		}
	}
	
	Sleep, 250
	afk := UrlDownloadToVar(baseURL . "api/afk?username=" . username . "&password=" . password . "&time=" . afkTime) 
	
	StringSplit, afk_, afk, ~
	
	if (afk_1 == "error") {
		SendInfo("Es ist ein Fehler aufgetreten: " . csecond . afk_2)
	} else {
		SendClientMessage(prefix . csecond . afk_2)
	}
}
return

:?:/afklist::
SendInput, {Enter}
{
	result := UrlDownloadToVar(baseURL . "api/afklist?username=" . username . "&password=" . password) 
	
	if (result == "ERROR_BAD_LINK") {
		SendInfo("Fehlerhafte Parameterübergabe.")
	} else if (result == "ERROR_USER_NOT_FOUND") {
		SendInfo("Der Account mit dem Namen " . username . " wurde nicht gefunden.")
	} else if (result == "ERROR_WRONG_PASSWORD") {
		SendInfo("Zugriff verweigert, das Passwort ist falsch.")
	} else if (result == "ERROR_ACCESS_DENIED") {
		SendInfo("Zugriff verweigert.")
	} else if (result == "ERROR_MYSQL_QUERY") {
		SendInfo("Es ist ein Fehler bei der MySQL-Abfrage aufgetreten.")
	} else if (result == "ERROR_CONNECTION") {
		SendInfo("Aktuell liegt ein Fehler in der Verbindung zum Server vor.")
	} else if (result == "ERROR_NOBODY_AFK") {
		SendInfo("Es hat sich niemand AFK gemeldet.")
	} else {
		Loop, Parse, result, `n
		{
			StringSplit, result_, A_LoopField, ~
			SendClientMessage(prefix . csecond . result_1 . cwhite . " - AFK gemeldet um: " . csecond . result_2 . cwhite . " Uhr, " . "Bis: " . csecond . result_3 . cwhite . " Uhr")
		}
	}
}
return

:?:/sgk::
SendInput, {Enter}
{
	i := 75
	Loop {
		if (i < 0) {
			SendError("Es wurde kein Raubüberfall gefunden.")
			break
		}
		
		if (RegExMatch(readChatLine(i), "HQ: Verbrechen: Überfall GK (\S+) \((\S+)\), Zeuge: Niemand, Verdächtiger: (\S+)", emergency)) {
			AddChatMessage(PREFIX . "Ladenüberfall von " . csecond . emergency3 . cwhite . " (ID: " . getPlayerIdByName(emergency3) . ") im GK " . csecond . emergency1 . cwhite . " (" . emergency2 . ")")
			gk(emergency3, emergency4, true)
			break
		}
		
		i --
	}
}
return

:?:/ts::
SendInput, {Enter}
{
	SendChat("/d LSPD und FBI Teamspeak³ Server: lspd.lennartf.com")
}
return

:?:/fts::
SendInput, {Enter}
{
	SendChat("/f LSPD und FBI Teamspeak³ Server: lspd.lennartf.com")
}
return

:?:/bwgov::
{
	SendInfo("1: LSPD, 2: FBI, 3: Army")
	
	fracNumber := PlayerInput("Fraktion: ")
	if (fracNumber == "" || fracNumber == " " || fracNumber is not number) {
		return
	}
	
	if (fracNumber == "1") {
		fraction := "Los Santos Police Department"
		preposition := "Das"
		copTitle := "Beamten"
	} else if (fracNumber == "2") {
		fraction := "Federal Bureau of Investigation"
		preposition := "Das"
		copTitle := "Agenten"
	} else if (fracNumber == "3") {
		fraction := "Las Venturas Army"
		preposition := "Die"
		copTitle := "Soldaten"
	} else {
		SendError("Verwende eine Zahl für eine der folgenden Fraktionen:")
		SendError("1: LSPD, 2: FBI, 3: Army")
		return
	}
	
	SendInfo("1: Aktuell (bestimmte Anzahl gesucht)")
	SendInfo("2: Dauerhaft (Bewerbung dauerhaft offen")
	
	typeOf := PlayerInput("Art der Bewerbung: ")
	if (typeOf == "" || typeOf == " ") {
		return
	}
	
	if (typeOf == "1") {
		searchCount := PlayerInput("Gesuchte Mitglieder: ")
		if (searchCount == "" || searchCount == " " || searchCount is not number) {
			return
		}
		
		if (typeOf > 0) {
			SendChat("/gov .:: " . fraction . " - Bewerbungsrunde ::.")

			if (!admin) {
				Sleep, 750
			}

			SendChat("/gov " . preposition . " " . fraction . " ist aktuell auf der Suche nach '" . searchCount . "' neuen " . copTitle . ".")

			if (!admin) {
				Sleep, 750
			} 

			SendChat("/gov Versuchen Sie Ihr Glück und werden Teil unseres Teams. Mehr Informationen im Forum!")
		} else {
			SendInfo("Du musst mindestens ein Member suchen.")
		}
	} else if (typeOf == "2") {
		SendChat("/gov .:: " . fraction . " - Bewerbungsrunde ::.")

		if (!admin) {
			Sleep, 750
		}

		SendChat("/gov " . preposition . " " . fraction . " hat aktuell Ihre Bewerbungsphase geöffnet.")

		if (!admin) {
			Sleep, 750
		} 

		SendChat("/gov Werden Sie Teil unseres Teams und versuchen Sie Ihr Glück!")
	} else {
		SendError("Verwende eine Zahl für einer der folgenden Bewerbungsrunden:")
		SendError("1: Aktuell (bestimmte Anzahl gesucht)")
		SendError("2: Dauerhaft (Bewerbung dauerhaft offen")	
	}
}
return

:?:/fpsunlock::
SendInput, {Enter}
{
    if (fpsUnlock()) {
        SendClientMessage(prefix . cgreen . "Die Beschränkung deiner FPS wurde aufgehoben.")
    } else {
        SendClientMessage(prefix . cred . "Beim Aufheben der Beschränkung deiner FPS ist ein Fehler aufgetreten.")
    }
}
return

:?:/bossmode::
SendInput, {Enter}
{
	IniRead, autoUse, ini/Settings.ini, settings, autoUse, 1
	
	if (autoUse == 0) {
		autoUse := 1

		SendInfo("Heal-Modus wurde " . cgreen . "aktiviert" . cwhite . ".")
	} else {
		autoUse := 0

		SendInfo("Heal-Modus wurde " . cred . "deaktiviert" . cwhite . ".")
	}
	
	IniWrite, %autoUse%, ini/Settings.ini, settings, autoUse
}
return

:?:/zollhelp::
SendInput, {Enter}
{
	SendInfo(".:: Zoll-Informationen ::.")
	SendInfo(csecond . "/zollinfo [Zoll-ID]{FFFFFF} - Zollinformationen nach ID")
	
	closeHotkey := closeCustomsControlNoMods
	closeHotkey := StrReplace(closeHotkey, "!", "ALT+")
	closeHotkey := StrReplace(closeHotkey, "^", "STRG+")
	
	openHotkey := openCustomsControlNoMods
	openHotkey := StrReplace(openHotkey, "!", "ALT+")
	openHotkey := StrReplace(openHotkey, "^", "STRG+")
	
	SendClientMessage(prefix . csecond . closeHotkey . cwhite . " - Zoll schließen (lassen)")
	SendClientMessage(prefix . csecond . openHotkey . cwhite . " - Zoll öffnen (lassen)")
}
return

:?:/zollinfo::
SendInput, {Enter}
{
	customsID := PlayerInput("Zoll-ID: ")
	
	if (customsID == "" || customsID == " ") {
		SendError("Du hast die Eingabe abgebrochen.")
		return
	}

	if (customsID is not number) {
		SendError("Du musst eine Nummer eintragen.")
		return
	}

	if (customsID == "1") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Los Santos - Las Venturas")
		SendInfo("Beschreibung: Zollstation von Red County nach Las Venturas (Nähe Hitman Base)")
	} else if (customsID == "2") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Red County - Bone County")
		SendInfo("Beschreibung: Zollstation von Red County nach Bone County (Nähe Hunter Quarry)")
	} else if (customsID == "3") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Blueberry - Bone County")
		SendInfo("Beschreibung: Zollstation auf der Martin Bridge von Blueberry nach Fort Carson")
	} else if (customsID == "4") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: San Fierro - Tierra Robada")
		SendInfo("Beschreibung: Zollstation auf der Garver Bridge (Nähe FBI Base)")
	} else if (customsID == "5") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: San Fierro - Bayside")
		SendInfo("Beschreibung: Zollstation bei der Gant Bride (von San Fierro nach Bayside)")
	} else if (customsID == "6") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Flint County - Red County")
		SendInfo("Beschreibung: Zollstation von der ehem. GmbH-Base nach The Panopticon")
	} else if (customsID == "7") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Flint County - Red County")
		SendInfo("Beschreibung: Zollstation von Flint County nach Red County (Richtung Blueberry)")
	} else if (customsID == "8") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Los Santos - Flint County")
		SendInfo("Beschreibung: Zollstation von Flint County nach Los Santos (Waffendealer Tunnel)")
	} else if (customsID == "9") {
		SendInfo("Zollinformation (" . csecond . "Zollstation " . customsID . cwhite . "):")
		SendInfo("Stadt: Los Santos - Flint County")
		SendInfo("Beschreibung: Zollstation von Flint County nach Los Santos (Flint Intersection)")
	} else {
		SendInfo("Diese Zollstation existiert nicht (1-9).")
	}
}
return

:?:/kd::
SendInput, {Enter}
{
	IniRead, kills, ini/stats.ini, Stats, kills, 0
	IniRead, dkills, ini/stats.ini, Stats, dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mkills, ini/stats.ini, Stats, mkills[%A_MM%:%A_YYYY%], 0
	
	IniRead, deaths, ini/stats.ini, Stats, deaths, 0
	IniRead, ddeaths, ini/stats.ini, Stats, ddeaths[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mdeaths, ini/stats.ini, Stats, mdeaths[%A_MM%:%A_YYYY%], 0	
	
	kd := round(kills/deaths, 2)
	if (deaths == 0) {
		kd := kills . ".00"
	}				
	
	dkd := round(dkills/ddeaths, 2)
	if (ddeaths == 0) {
		dkd := dkills . ".00"
	}
	
	mkd := round(mkills/mdeaths, 2)
	if (mdeaths == 0) {
		mkd := mkills . ".00"
	}

	SendInfo("Aktuelle Kills: " . cSecond . formatNumber(kills) cWhite . " - Aktuelle Tode: " . cSecond . formatNumber(deaths))
	SendInfo("Tages-Kills: " . cSecond . dkills . cWhite . " - Tages-Tode: " . cSecond . ddeaths)
	SendInfo("Monats-Kills: " . cSecond . formatNumber(mkills) . cWhite . " - Monats-Tode: " . cSecond . formatNumber(mdeaths))
	SendInfo("DKD: " . cSecond . kd . cWhite . " - MKD: " . cSecond . mkd . cWhite . " - KD: " . cSecond . kd)	
}
return

:?:/fkd::
SendInput, {Enter}
{
	shareKD("f")
}
return

:?:/dkd::
SendInput, {Enter}
{
	shareKD("d")
}
return

:?:/jkd::
SendInput, {Enter}
{
	shareKD("j")
}
return

:?:/ckd::
SendInput, {Enter}
{
	shareKD("crew")
}
return

:?:/resetdkd::
SendInput, {Enter}
{
	IniWrite, 0, ini/Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%]
	IniWrite, 0, ini/Stats.ini, Stats, DKills[%A_DD%:%A_MM%:%A_YYYY%]

	SendInfo("Deine Tages-Kills und Tode wurden auf 0 gesetzt.")
}
return

:?:/setkd::
SendInput, {Enter}
{
	updateKD()
}
return

:?:/items::
SendInput, {Enter}
{
	IniRead, drugs, ini/Settings.ini, Items, drugs, 0
	IniRead, firstaid, ini/Settings.ini, Items, firstaid, 0
	IniRead, campfire, ini/Settings.ini, Items, campfire, 0

	if (drugs) {
		dColor := cgreen
	} else {
		dColor := cred 
	}

	if (firstaid) {
		fAvailable := cgreen . "vorhanden"
	} else {
		fAvailable := cred . "nicht vorhanden"
	}

	if (campfire) {
		cAvailable := cgreen . campfire . " vorhanden"
	} else {
		cAvailable := cred . "nicht vorhanden"
	}
	
	SendInfo("|============| Inventar |============|")
	SendInfo("Drogen dabei: " . dColor . drugs . "g")
	SendInfo("Erste-Hilfe-Paket: " . fAvailable)
	SendInfo("Lagerfeuer: " . cAvailable)
	SendInfo("|============| Inventar |============|")
}
return

:?:/gk::
SendInput, {Enter}
{
	gkid := PlayerInput("Gebäudekomplex: ")
	if (gkid == "") {
		return
	}
	
	if (RegExMatch(gkid, "^(\d+)\.(\d+)$")) {
		gk(gkid)
	}
}
return

:?:/showgk::
SendInput, {Enter}
{
	gkid := PlayerInput("GK-ID: ")
	showGK(gkid)
}
return

:?:/fisch::
{
	Loop, 5 {
		if (fishName_%A_Index% != "nichts" && fishHP_%A_Index% > 0) {
			SendClientMessage(fishName_%A_Index% . ", HP: " . fishHP_%A_Index% . ", LBS: " . fishLBS_%A_Index%)
		}
	}
}
return

:?:/test::
SendInput, {Enter}
{
	; SendClientMessage("* " . getUserName() . " hat Drogen konsumiert.")
	
	; SendClientMessage("Der Leader hat das Upgrade Arrest-Limit aktiviert (noch 11 Stunden und 19 Minuten).")
	
	; SendClientMessage("Du hast ein Erstehilfe-Paket erworben (-500$).")
	
	SendChat(getServerName() . ", " . getServerIP() . ", " . getServerPort())
}
return

:?:/label::
SendInput, {Enter}
{
	if (getuserName() != "jacob.tremblay") {
		SendInfo("Du kannst diesen Befehl nicht verwenden.")
		return
	}	
	
	if (!updateTextLabelData()) {
		return
	}	

	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {	
			SendClientMessage(o.TEXT)
		}
	}
}
return

:?:/gkadd::
:?:/addgk::
SendInput, {Enter}
{
	if (getuserName() != "jacob.tremblay") {
		SendInfo("Du kannst diesen Befehl nicht verwenden.")
		return
	}
	
	SendChat("/members")
	
	Sleep, 250
	
	Loop, 15 {
		if (RegExMatch(readChatLine(A_Index), "" . getUserName() . "(.*), GK (\d+)\.(\d+)", gk_)) {
			gk := gk_2 . "." . gk_3
			break
		}
	}
	
	Sleep, 500
	
	if (getPlayerInteriorId()) {
		SendChat("/exit")
	}
	
	Sleep, 2000
	
	if (RegExMatch(getLabelText(), "^Dieses Haus vermietet Zimmer\.\n\nBesitzer: (\S+)\nMiet-Preis: (\d+)\$\nBeschreibung: (.+)\nTippe \/renthouse\.$", label_)) { ; Mietbares Haus
		owner := label_1
		type := "house"
		description := label_3
		SendInfo("Besitzer: " . csecond . label_1)
	} else if (RegExMatch(getLabelText(), "^(.+)\nDrücke Enter\.$", label_)) { ; Fraktionsbase
		owner := label_1
		type := "faction"
		description := ""
		SendInfo("Besitzer: " . csecond . label_1)
	} else if (RegExMatch(getLabelText(), "^Dieses Haus gehört (\S+)\.\n\nPreis: (.*)\nBeschreibung: (.+)\n\n(.+)$", label_)) { ; Crewhaus (unmietbar)
		owner := label_1
		type := "house"
		description := label_3
		SendInfo("Besitzer: " . csecond . label_1)
	} else if (RegExMatch(getLabelText(), "^Dieses Haus vermietet Zimmer\.\n\nBesitzer: (\S+)\nMiet-Preis: (.*)\nBeschreibung: (.+)\nTippe \/renthouse\.\n\n(.+)$", label_)) {
		owner := label_1
		type := "house"
		description := label_3
		SendInfo("Besitzer: " . csecond . label_1)
	} else if (RegExMatch(getLabelText(), "^Dieses Haus gehört (\S+)\.\n\nPreis: (.*)\nBeschreibung: (.+)$", label_)) { ; Unmietbares Haus
		owner := label_1
		type := "house"
		description := label_3
		SendInfo("Besitzer: " . csecond . label_1)
	} else if (RegExMatch(getLabelText(), "^Dieses Haus steht zum Verkauf\.\n\nPreis: (.*)\nBeschreibung: (.+)\nTippe \/buyhouse\.$", label_)) { ; Haus Verkauft
		owner := "niemand"
		type := "house"
		description := label_2
		SendInfo("Besitzer: " . csecond . owner)
	}
	
	Sleep, 200
		
	getPlayerPos(posX, posY, posZ)

	if (!gk) {
		gk := PlayerInput("GK: ")
		if (gk == "") {
			return
		}
	}
		
	if (!owner) {
		owner := PlayerInput("Besitzer: ")
		if (owner == "") {
			return
		}
	}
	
	if (!description) {
		description := PlayerInput("Beschreibung: ")
	}
	
	SendInfo("Trage einen der folgenden Typen ein: public, faction, house")
	
	if (!type) {
		type := PlayerInput("Typ: ")
	}
	
	if (type == "public" || type == "faction" || type == "house") {
		SendInfo("Möchtest du folgendes Gebäudekomplex eintragen? Du kannst mit '" csecond . "X" . cwhite . "' bestätigen!")
		SendInfo("GK: " . gk)
		SendInfo("Besitzer: " . owner)
		SendInfo("Beschreibung: " . description)
		SendInfo("Location: " . getPlayerZone() . ", " . getPlayerCity())
			
		KeyWait, X, D, T10
			
		if (!ErrorLevel && !isBlocked()) {
			string := "GK: " . gk . ", Besitzer: " . owner . ", Beschreibung: " . description . ", X: " . posX . ", Y: " . posY . "`n"
			
			FileAppend, %string%, komplexes.txt
			SendInfo("Gebäudekomplex " . csecond . gk . cwhite . " von " . csecond . owner . cwhite . " (" . getPlayerZone() . ", " . getPlayerCity() . ") wurde gespeichert!")
		}
	} else {
		SendInfo("Trage einen der folgenden Typen ein: public, faction, house")
	}
	
	owner := ""
	gk := ""
	description := ""
}
return

:?:/mr::
SendInput, {Enter}
{
	SendChat("/mauready")
}
return

:?:/mn::
SendInput, {Enter}
{
	SendChat("/maunext")
}
return

:?:/md::
SendInput, {Enter}
{
	SendChat("/maudraw")
}
return

:?:/ml::
SendInput, {Enter}
{
	SendChat("/mauleave")
}
return

:?:/am::
SendInput, {Enter}
{
	SendChat("/accept maumau")
}
return

:?:/mhelp::
SendInput, {Enter}
{
	caption := cwhite . projectName . ": Mau Mau Hilfen"
	
	dialog := primcol . "Befehl/Hotkey`t{FFFFFF}Beschreibung`n"

	dialog .= "/am`tKurzbind für /accept maumau`n"
	dialog .= "/mn`tKurzbind für /maunext`n"
	dialog .= "/mr`tKurzbind für /mauready`n"
	dialog .= "/md`tKurzbind für /maudraw`n"
	dialog .= "/ml`tKurzbind für /mauleave`n"
	dialog .= "-`t-`n"	
	
	dialog .= getUserFriendlyHotkeyName(megaControlNoMods) . "`t/mau 1`n"
	dialog .= getUserFriendlyHotkeyName(megaStopNoMods) . "`t/mau 2`n"
	dialog .= getUserFriendlyHotkeyName(megaByNameNoMods) . "`t/mau 3`n"
	dialog .= getUserFriendlyHotkeyName(megaGetOutOfCarNoMods) . "`t/mau 4`n"
	dialog .= getUserFriendlyHotkeyName(megaClearNoMods) . "`t/mau 5`n"
	dialog .= getUserFriendlyHotkeyName(megaWeaponsNoMods) . "`t/mau 6`n"
	dialog .= getUserFriendlyHotkeyName(arrestNoMods) . "`t/mau 7`n"
	dialog .= getUserFriendlyHotkeyName(imprisonNoMods) . "`t/mau 8`n"
	dialog .= getUserFriendlyHotkeyName(megaLeaveNoMods) . "`t/mau 9`n"
	
	ShowDialog(DIALOG_STYLE_TABLIST_HEADERS, caption, dialog, "Weiter")
}
return

:?:/coop::
{
	wantedInput := PlayerInput("Wanted-Anzahl: ")
	if (wantedInput == "" || wantedInput == " ") {
		return
	}
	
	if (wantedInput is not number) {
		SendError("Die Wantedanzahl muss eine Nummer sein.")
		return
	}
	
	SendInfo("10% von " . wantedInput . " Wanteds sind " . csecond . Round(wantedInput / 10) . cwhite . " (" . csecond . (wantedInput / 10) . cwhite . ") Wanteds.")
	SendInfo("Damit würdest du ihm " . wantedInput * 3 . " Minuten Knastzeit ersparen.")
}
return

:?:/tempo::
{
	tempoInput := PlayerInput("Tempo: ")
	if (tempoInput == "" || tempoInput == " ") {
		return
	}
	
	if (tempoInput is not number) {
		SendError("Die Geschwindigkeit muss eine Zahl sein.")
		return
	}
	
	tempo := tempoInput
	
	SendInfo("Du hast das Tempo auf " . csecond . tempo . " km/h " . cwhite . "gesetzt. Starte den Tempomat mit '" . csecond . tempomatNoMods . cwhite . "'")
}
return

:?:/rz::
:?:/razzia::
SendInput, {Enter}
{	
	useMegaphone(11)
}
return

:?:/weiter::
SendInput, {Enter}
{
	useMegaphone(12)
}
return

:?:/cws::
{
	name := PlayerInput("Name/ID: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/licunban " . name . " weapon")
}
return
	
:?:/cfs::
{
	name := PlayerInput("Name/ID: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/licunban " . name . " flying")
}
return	

:?:/cds::
{	
	name := PlayerInput("Name/ID: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/licunban " . name . " driving")
}
return

:?:/nt::
SendInput, {Enter}
{
	if (currentTicketMoney > 0) {
		giveTicket(lastTicketPlayer, currentTicketMoney, lastTicketReason)
	} else {
		SendError("Es ist kein Ticket mehr ausstellbar.")
	}
}
return

:?:/stvo::
{
	name := PlayerInput("Spieler: ")
	if (StrLen(name) > 2 || name is number) {
		fullName := getFullName(name)
		
		if (fullName != "") {
		
			pointReason := PlayerInput("Grund: ")
			if (StrLen(pointReason) > 4) {

				pointAmount := PlayerInput("Anzahl: ")
				if (pointAmount is number) {
					if (pointAmount < 5) {
						if (pointAmount > 0) {
							
							SendChat("/l Guten " . getDayTime() . " " . fullName . ", Sie haben gegen die Straßenverkehrsordnung verstoßen.")
							SendChat("/l Aus diesem Grund biete ich Ihnen ein Strafticket in Höhe von $" . formatNumber(pointAmount * 2000) . " an.")
							
							Sleep, 1000
						
							SendChat("/l Sollten Sie das Ticket nicht zahlen können, tragen wir Ihnen " . pointAmount . " Strafpunkte ein.")
							SendChat("/l Ihr Vergehen: " . pointReason)
							
							Sleep, 200
							
							SendInfo(csecond . "/apunkte{FFFFFF} - Punkte dafür ausstellen, " . csecond . "/aticket{FFFFFF} - Ticket dafür anbieten")
							
							autoName := fullName
							autoReason := pointReason
							autoTicket := pointAmount * 2000							
						} else {
							SendError("Du musst mindestens 1 Strafpunkt angeben.")
						}
					} else {
						SendError("Du darfst nicht mehr als 4 Strafpunkte eintragen.")
					}
				} else {
					SendError("Du musst eine gültige Punkteanzahl angeben.")
				}
			} else {
				SendError("Der Grund muss mind. 5 Zeichen lang sein.")
			}
		} else {
			SendError("Der angegebene Spieler wurde nicht gefunden.")
		}
	} else {
		SendError("Der Name muss mindestens 3 Zeichen haben.")
	}
}
return

:?:/speed::
{	
	name := PlayerInput("Name/ID des Spielers: ")
	if (name == "" || name == " " || getFullName(name) == "")  {
		return
	}

	if (lastSpeedUser = name && lastSpeed != 0) {
		name := lastSpeedUser
		autoSpeed := lastSpeed
	} else {
		autoSpeed := PlayerInput("Geschwindigkeit: ")
		
		if (autoSpeed == "") {
			return
		}
		
		if (autoSpeed < 80) {
			SendClientMessage("Fehler: Die Geschwindigkeit muss 80 kmh überschreiten.")
			return
		}
	}
	
	reason := "geschwindigkeit"
	
	kmh := max_kmh
	
	if (kmh == 0) {
		kmh := 80
		
		SendInfo("Du musst die maximal erlaubte Höchstgeschwindigkeit noch eintragen, verwende " . csecond . "/setkmh{FFFFFF}.")
	}
	
	SendChat("/l Guten " . getDayTime() . " " . autoName . ", Sie haben gegen die StVO verstoßen.")
	
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/l Sie haben die erlaubte Höchstgeschwindigkeit (" . max_kmh . " km/h) mit " . autoSpeed . " km/h überschritten.")
	
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/l Möchten Sie ein Ticket in Höhe von $" . autoTicket . " oder " . autoPoints . " Strafpunkte?")
	
	Sleep, 100
	
	SendInfo("Verwende " . csecond . "/aticket {FFFFFF}um ein Ticket oder " . csecond . "/apunkte{FFFFFF}, um die Punkte auszustellen.")
	
	lastSpeed := 0
	lastSpeedUser := ""
}
return

:?:/aticket::
SendInput, {Enter}
{
	if (autoName != "") {
		if (autoSpeed == 0) {
			giveTicket(autoName, autoTicket, autoReason)
		} else {
			giveTicket(autoName, autoTicket, autoReason . " (" . autoSpeed . " km/h)")
		}
		
		autoName := ""
		autoSpeed := 0
	} else {
		SendInfo("Du musst erst einen Verstoß mit " . csecond . "/stvo {FFFFFF}eintragen.")
	}
}
return

:?:/apunkte::
SendInput, {Enter}
{
	if (autoName != "") {
		if (autoSpeed == 0) {
			givePoints(autoName, "Missachtung des Tempolimits", 1)
		} else {
			givePoints(autoName, "Missachtung des Tempolimits", 1, " (" . autoSpeed . " km/h)")
		}
		
		autoName := ""
		autoSpeed := 0
	} else {
		SendInfo("Du musst erst einen Verstoß mit " . csecond . "/stvo {FFFFFF}eintragen.")
	}
}
return

:?:/top::
SendInput, {Enter}
{
	SendChat("/l Möchten Sie nun ein Ticket oder Strafpunkte?")
}
return

:?:/tot::
SendInput, {Enter}
{
	SendChat("/l Möchten Sie nun einen Strafzettel oder einen Entzug der Lizenz?")
}
return

:?:/stvof::
{
	name := PlayerInput("Spieler (Flugschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Straßenverkehrsverordnung verstoßen.")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Flugschein i.H.v. $12.000 an.")
	
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Fluglizenzs entziehen.")
	
	Sleep, 100
	
	SendInfo(csecond . "/fst{FFFFFF} - Ticket anbieten, " . csecond . "/tfs{FFFFFF} - Schein taken")
}
return

:?:/stvow::
{
	name := PlayerInput("Spieler (Waffenschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Serverregelwerk verstoßen.")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Waffenschein i.H.v. $36.000 an.")
	
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Waffenlizenz entziehen.")
	
	Sleep, 100
	
	SendInfo(csecond . "/wst{FFFFFF} - Ticket anbieten, " . csecond . "/tws{FFFFFF} - Schein taken")
}
return

:?:/stvob::
{
	name := PlayerInput("Spieler (Bootsschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Straßenverkehrsverordnung verstoßen.")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Bootschein i.H.v. $6.000 an.")
	
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Bootlizenz entziehen.")
	
	Sleep, 100
	
	SendInfo(csecond . "/bst{FFFFFF} - Ticket anbieten, " . csecond . "/tbs{FFFFFF} - Schein taken")
}
return

:?:/fst::
{
	name := PlayerInput("Spieler (Flugschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 12000, "Flugschein-Ticket")
}
return

:?:/wst::
{
	name := PlayerInput("Spieler (Waffenschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 36000, "Waffenschein-Ticket")
}
return

:?:/bst::
{
	name := PlayerInput("Spieler (Bootschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 6000, "Bootsschein-Ticket")
}
return

:?:/tw::
{
	SendInput, /take Waffen{space}
}
return

:?:/tfs::
:?:/tfl::
{
	SendInput, /take Flugschein{space}
}
return

:?:/tws::
:?:/twl::
{
	SendInput, /take Waffenschein{space}
}
return

:?:/tbs::
{
	SendInput, /take Bootsschein{space}
}
return

:?:/td::
{
	SendInput, /take Drogen{space}
}
return

:?:/tm::
{
	SendInput, /take Materialien{space}
}
return

:?:/tall::
{
	SendInput, /take Waffen{Space}
	Input SID, V I M, {Enter}
	SendInput, {Enter}t/take Materialien %SID%{Enter}t/take Drogen %SID%{Enter}
}
return

/*
:?:/dsp::
{
	SendChat("/destroyplant")
}
return
*/

:?:/setkmh::
{	
	maxKMHinput := PlayerInput("Maximal erlaubte km/h: ")
	
	if (maxKMHinput is number) {
		max_kmh := maxKMHinput
		
		IniWrite, %max_kmh%, ini/Settings.ini, settings, max_kmh
		
		SendInfo("Du hast die maximal erlaubte Geschwindigkeit bei Radarkontrollen auf " . csecond . max_kmh . " km/h " . cwhite . "gesetzt.")
	} else {
		SendError("Gib bitte eine Zahl für die maximal erlaubte Geschwindigkeit bei Radarkontrollen ein.")
	}
}
return


:?:/pd::
:?:/payday::
SendInput, {Enter}
{
	IniRead, paydayMoney, ini/Stats.ini, stats, paydayMoney, 0
	IniRead, taxes, ini/Settings.ini, settings, taxes, 1
	
	if (taxes == 1) {
		getTaxes()
		
		Sleep, 500
	}
	
	SendInfo("Geld am nächsten Payday: $" . csecond . formatNumber(paydayMoney))
}
return

:?:/hi::
SendInput, {Enter}
{
	SendChat("/f Hi")

	if (!admin) {
		Sleep, 750
	}

	SendChat("/d Hi")

	if (!admin) {
		Sleep, 750
	}

	SendChat("/crew Hi")
}
return
	
:?:/resetpd::
:?:/resetpayday::
SendInput, {Enter}
{
	IniRead, paydayMoney, ini/Stats.ini, stats, paydayMoney, 0
	IniRead, taxes, ini/Settings.ini, settings, taxes, 1
	
	if (taxes == 1) {
		getTaxes()
		
		Sleep, 500
	}	
	
	SendInfo("Geld am nächsten Payday: $" . csecond . formatNumber(paydayMoney))
	SendInfo("Du hast das Geld für den nächsten Payday auf 0$ zurückgesetzt.")
	
	iniWrite, 0, ini/Stats.ini, stats, paydayMoney
}
return

:?:/settax::
{
	taxClass := PlayerInput("Steuerklasse: ")
	if (taxClass == "" || taxClass == " ") {
		return
	}
	
	if (taxClass is not number) {
		SendInfo("Gib bitte eine gültige Steuerklasse (1-4) ein.")
		return
	}
	
	if (taxClass < 1 || taxClass > 4) {
		SendInfo("Gib bitte eine gültige Steuerklasse (1-4) ein!")
		return
	}
	
	SendChat("/tax")
	
	Sleep, 250
	
	RegExMatch(readChatLine(4 - taxClass), "Steuerklasse " . taxClass . ": (\d*) Prozent", chat_)
	taxes := (100 - chat_1) / 100
	
	IniWrite, %taxes%, ini/Settings.ini, settings, taxes
	SendInfo("Der Steuersatz (Steuerklasse " . cSecond . taxClass . cwhite . ") wurde auf " . cSecond . chat_1 . cwhite . " Prozent gesetzt.")
}
return

:?:/fahrer::
SendInput, {Enter}
{
	if (showDriver) {
		showDriver := false
		
		SendInfo("Es wird nun nicht mehr automatisch dem Fahrer des Wagens gezeigt. (/asp)")
	} else {
		showDriver := true
		
		SendInfo("Es wird nun immer automatisch dem Fahrer des Wagens gezeigt. (/asp)")
	}
}
return

:?:/partner::
{	
	partner := PlayerInput("Partner: ")
	if (partner == "") {
		return
	} else if (getFullName(partner) == "") {
		SendError("Der Spieler ist offline.")
		return
	} else if (getFullName(partner) == getUserName()) {
		SendInfo("Halts Maul.")
		return
	}
	
	partnerName := getFullName(partner)
	partnerID := getPlayerIdByName(partnerName)
	
	for index, entry in partners {
		if (partnerName == entry) {
			SendChat("/f " . partnerName . " wurde als Dienstpartner ausgetragen.")
			partners.RemoveAt(index)
			return 
		}
	}
	
	SendChat("/f " . partnerName . " wurde als Dienstpartner eingetragen.")
	partners.Push(partnerName)
}
return

:?:/partners::
SendInput, {Enter}
{
	partnerCount := 0
	
	SendInfo("Aktuelle Dienstpartner:")
	
	for index, partner in partners {
		partnerPlayerID := getPlayerIdByName(partner)
		
		SendClientMessage(prefix . cSecond . index . cwhite . ": " . partner . " (ID: " . csecond . partnerPlayerID . cwhite . ")")
		partnerCount ++
	}
}
return

:?:/rpartners::
:?:/delpartners::
:?:/rempartners::
:?:/resetpartners::
SendInput, {Enter}
{
	partners := []
	
	SendInfo("Dienstpartner zurückgesetzt.")
}
return

:?:/oa::
SendInput, {Enter}
{
	if (!updateTextLabelData()) {
		SendInput, /offlinearrest  0{left 2}
		return
	}
	
	found := false
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {
			if (RegExMatch(o.TEXT, "(\S+)\n\((\S+)\)\n(\d+):(\d+):(\d+)", label_)) {
				SendChat("/offlinearrest " . label_1 . " 0")
				
				found := true
			}
		}
	}
	
	if (!found) {
		SendInfo("Es konnten keine Offline-Pickups gefunden werden!")
	}
}
return

:?:/op::
SendInput, {Enter}
{
	if (!updateTextLabelData()) {
		SendInput, /offlinearrest  1{left 2}
		return
	}
	
	found := false
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {
			if (RegExMatch(o.TEXT, "(\S+)\n\((\S+)\)\n(\d+):(\d+):(\d+)", label_)) {
				SendChat("/offlinearrest " . label_1 . " 1")
				
				found := true
			}
		}
	}
	
	if (!found) {
		SendInfo("Es konnten keine Offline-Pickups gefunden werden!")
	}
}
return

:?:/da::
SendInput, {Enter}
{
	if (!updateTextLabelData()) {
		SendInput, /deatharrest  0{left 2}
		return
	}
	
	found := false
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {
			if (RegExMatch(o.TEXT, "(\S+)\n\((\S+)\)\n(\d+):(\d+):(\d+)", label_)) {
				SendChat("/deatharrest " . label_1 . " 0")
				
				found := true
			}
		}
	}
	
	if (!found) {
		SendInfo("Es konnten keine Death-Pickups gefunden werden!")
	} else {
		deathArrested := true
		
		SetTimer, DeathArrestTimer, -2000
	}
}
return

:?:/dp::
SendInput, {Enter}
{
	if (!updateTextLabelData()) {
		SendInput, /deatharrest  1{left 2}
		return
	}
	
	found := false
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {
			if (RegExMatch(o.TEXT, "(\S+)\n\((\S+)\)\n(\d+):(\d+):(\d+)", label_)) {
				SendChat("/deatharrest " . label_1 . " 1")
				
				found := true
			}
		}
	}
	
	if (!found) {
		SendInfo("Es konnten keine Death-Pickups gefunden werden!")
	} else {
		deathArrested := true
		
		SetTimer, DeathArrestTimer, -2000
	}
}
return

:?:/arrestlist::
SendInput, {Enter}
{
	arrestCount := 0
	
	SendInfo("Verbrecher in der Arrestliste:")
	
	for index, arrestName in arrestList {
		SendInfo("ID: " . getPlayerIdByName(getFullName(arrestName), 1) . " - " . csecond . getFullName(arrestName))
	
		arrestCount ++
	}
	
	if (!arrestCount) {
		SendInfo("Es sind aktuell keine Spieler in deiner Arrest-Liste.")
	} else {
		SendInfo("Spieler in Arrest-Liste: " . csecond . arrestCount)
	}
}
return

:?:/cufflist::
SendInput, {Enter}
{
	grabCount := 0
	
	SendInfo("Verbrecher in der Cuffliste:")
	
	for index, grabName in grabList {
		SendInfo("ID: " . getPlayerIdByName(getFullName(grabName), 1) . " - " . csecond . getFullName(grabName))
	
		grabCount ++
	}
	
	if (!grabCount) {
		SendInfo("Es sind aktuell keine Spieler in deiner Cuffliste.")
	} else {
		SendInfo("Spieler in Cuffliste: " . csecond . grabCount)
	}
}
return

:?:/fahrt::
SendInput, {Enter}
{
	SendChat("/l Die allgemeine Kontrolle ist nun beendet. Ich danke für Ihre Kooperation!")

	if (!admin) {
		Sleep, 750
	}

	SendChat("/l Ich wünsche Ihnen nun eine schöne und angenehme Weiterfahrt! Auf Wiedersehen!")
}
return

:?:/tput::
{
	SendInput, /trunk put{Space}
}
return

:?:/tcm::
SendInput, {Enter}
{
	SendChat("/trunk clear mats")
}
return

:?:/tcd::
SendInput, {Enter}
{
	SendChat("/trunk clear drugs")
}
return

:?:/wtd::
SendInput, {Enter}
{
	SendChat("Guten Tag,")

	if (!admin) {
		Sleep, 750
	}

	SendChat("Möchten Sie ein Ticket für Ihre(n) Wanted(s) ?")
}
return

:?:/dtd::
SendInput, {Enter}
{
	if (tv) { 
		return
	}

	SendChat("Guten Tag,")
	SendChat("Möchten Sie ein Ticket für Ihre Drogen oder Wanteds?")
}
return

:?:/tdd::
{
	playerForTicket := PlayerInput("Spieler: ")
	playerForTicket := getFullName(playerForTicket)
	
	if (playerForTicket != "") {
		if (playerForTicket == getUsername()) {
			SendError("Du kannst dir selbst kein Ticket anbieten.")
		} else {
			SendChat("/l Guten Tag " . playerForTicket . ",")

			if (!admin) {
				Sleep, 750
			}
		
			SendChat("/l Hiermit biete ich Ihnen einen Freikauf für Ihr Drogen an.")
			
			if (!admin) {
				Sleep, 750
			}
			
			SendChat("/l Sollten Sie dieses Ticket ($4.000) nicht zahlen können, müssen wir Ihnen leider Wanteds eintragen!")
			
			if (!admin) {
				Sleep, 750
			}			
			
			SendChat("/ticket " . playerForTicket . " 4000 Drogen Ticket")
		
		}
	}
}
return

:?:/twd::
{
	playerForTicket := PlayerInput("Spieler: ")
	playerForTicket := getFullName(playerForTicket)
	
	if (playerForTicket != "") {
		if (playerForTicket == getUsername()) {
			SendError("Du kannst dir selbst kein Ticket anbieten.")
		} else {
			wantedCount := PlayerInput("Wanteds: ")
			if (wantedCount is not number) {
				SendError("Du kannst nur Zahlen eingeben.")
				return
			}
			
			if (wantedCount > 4) {
				SendError("Du kannst nur bis 4 Wanteds ein Ticket ausstellen.")
				return
			}
		
			SendChat("/l Guten Tag " . playerForTicket . ",")
		
			if (!admin) {
				Sleep, 750
			}		
			
			SendChat("/l Hiermit biete ich Ihnen einen Freikauf für Ihr" . (wantedCount == 1 ? " Wanted" : "e zwei Wanteds") . " an.")
			
			if (!admin) {
				Sleep, 750
			}
			
			SendChat("/l Sollten Sie dieses Ticket ($" . formatNumber(wantedCount * 750) . ") nicht zahlen können, werden wir Sie leider verhaften müssen.")
			
			if (!admin) {
				Sleep, 750
			}			
			
			if ((wantedCount * 750) > 3000) {
				SendError("Diese Summe konnte unmöglich erreicht werden. Siehe max. Ticket-Wanted Regel.")
			} else {
				SendChat("/ticket " . playerForTicket . " " . (wantedCount * 750) " Wanted-Ticket (" . wantedCount . " Wanted" . (wantedCount == 1 ? "" : "s") . ")")
			}		
		}
	}
}
return

:?:/ci::
{
	if (isBlocked()) {
		SendInput, /dl{enter}
	} else {
		SendInput, t/dl{enter}
	}
	
	carID := PlayerInput("Fahrzeug-ID: ")
	
	if (carID != "") {
		SendInfo("Fahrzeuginformationen werden gespeichert, bitte warte einen Moment...")
		Sleep, 250
		
		SendChat("/carinfo " . carID)
		Sleep, 250
		
		readCarInfos()
	}
	
	SendInput, t/dl{enter}
}
return

:?:/af::
:?:/afind::
{
	playerToFindInput := PlayerInput("Spieler: ")
	if (playerToFindInput == "" || playerToFindInput == " ") {
		SendError("Die Eingabe wurde abgebrochen.")
		return
	}

	playerToFind := playerToFindInput

	if (getFullName(playerToFind) == "") {
		SendError("Der angegebene Spieler ist nicht online.")
		return
	}

	if (getFullName(playerToFind) == getUserName()) {
		SendError("Du kannst dich nicht selber finden.")
		return
	}

	autoFindMode := 1
	
	findPlayer()
	findInfo(playerToFind)
}
return

:?:/as::
:?:/asp::
{
	if (!showDriver) {
		playerToShowToInput := PlayerInput("Partner: ")
		
		if (playerToShowToInput == "" || playerToShowToInput == " ") {
			SendError("Du hast die Eingabe abgebrochen.")
			return
		}

		if (!getFullName(playerToShowToInput)) {
			SendError("Der angegebene Show-Partner ist offline.")
			return
		}

		if (getFullName(playerToShowToInput) == getUserName()) {
			SendError("Du kannst dir selbst niemanden anzeigen, nutze /af[ind]")
			return
		}

		playerToShowTo := playerToShowToInput
		playerToFindInput := PlayerInput("Gesuchter: ")

		if (playerToFindInput == "" || playerToFindInput == " ") {
			SendError("Du hast die Eingabe abgebrochen.")
		} else if (!getFullName(playerToFindInput)) {
			SendError("Der gesuchte Spieler ist offline.")
			return
		} else if (getFullName(playerToFindInput) == getUserName()) {
			SendError("Du kannst dich nicht selbst finden.")
			return
		} else {
			playerToFind := playerToFindInput
			autoFindMode := 2

			findPlayer()
			findInfo(playerToFind)
		}
	}
}
return

:?:/cpos::
:?:/crewpos::
SendInput, {Enter}
{
	if (tv) { 
		return
	}	
	
	sendPosition("crew", 0)
}
return

:?:/wo::
SendInput, {Enter}
{
	SendChat("/d HQ: Wo befindet ihr euch?")
}
return

:?:/ver::
SendInput, {Enter}
{	
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/d HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/d HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		SendChat("/d HQ: " . getFractionTitle() . " " . getUserName() . " hat verstanden und bestätigt!")
	}
}
return

:?:/fver::
SendInput, {Enter}
{
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/f HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/f HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		SendChat("/f HQ: " . getFractionTitle() . " " . getUserName() . " hat verstanden und bestätigt!")
	}
}
return

:?:/rver::
SendInput, {Enter}
{
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/r HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/r HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		SendChat("/r HQ: " . getFractionTitle() . " " . getUserName() . " hat verstanden und bestätigt!")
	}
}
return

:?:/nbk::
:?:/needbk::
SendInput, {Enter}
{
	SendChat("/d HQ: Wird Verstärkung weiterhin gefordert?")
}
return

:?:/hat::
{	
	playerID := PlayerInput("Verbrecher: ")
	if (playerID == "" || playerID == " ") {
		return
	} else if (getFUllName(playerID) == "") {
		SendError("Der Spieler ist nicht online.")
		return
	} else if (getFullName(playerID) == getUserName()) {
		SendError("Du kannst dich nicht selbst melden.")
		return
	}
	
	playerName := getFullName(playerID)
	
	SendChat("/d HQ: Hat bereits jemand " . playerName . " (ID: " . getPlayerIdByName(playerName) . ") gefangen? Ich verfolge ihn!")
}
return

:?:/einsatz::
{	
	SendInfo(csecond . "Info: {FFFFFF}Trage die Zeit in 'Minuten' ein, anschließend wird die Uhrzeit berechnet.")
	
	commitmentMins := PlayerInput("Zeit: ")
	if (commitmentMins == "" || commitmentMins == " ") {
		return
	}
	
	commitmentLocation := PlayerInput("Aufstellort: ")
	if (commitmentLocation == "" || commitmentLocation == " ") {
		return
	}
	
	SendInfo(csecond . "Info: " . cwhite . "Trage Extras ein, Beispiele: " . csecond . "(U)nder(c)over, Swat, normal")
	
	extras := PlayerInput("Zusatz: ")
	if (extras == "" || extras == " ") {
		return
	} else {
		if (InStr(extras, "Undercover") || InStr(extras, "uc")) {
			extras := "Undercover Outfit"
		} else if (InStr(extras, "Normal")) {
			extras := "Dienstuniform"
		} else if (InStr(extras, "SWAT")) {
			extras := "S.W.A.T."
		} else {
			SendError("Verwende folgende Parameter: (U)nder(c)over, Normal, SWAT")
			return
		}
			
		commitmentChat := PlayerInput("Chat: ")
		if (commitmentChat == "" || commitmentChat == " ") {
			if (commitmentChat != "hq") {
				commitmentChat := commitmentChat . " HQ:"
			}
		}
		
		tmpTime := A_Min + commitmentMins
		if (tmpTime > 59) {
			minTime := tmpTime - 60
			hourTime := A_Hour + 1
			
			newTime := hourTime . ":" . minTime . " Uhr"
		} else {
			minTime := tmpTime
			newTime := A_Hour . ":" . minTime . " Uhr"
			
			minInSecs := (commitmentMins * 60)
			
			commitmentUnix := (getUnixTimestamp(A_Now) + minInSecs) 
			commitmentTime := 1
			
			restTime := commitmentUnix - getUnixTimestamp(A_Now)
			
			IniWrite, %commitmentUnix%, ini/Settings.ini, UnixTime, commitmentUnix
			IniWrite, %commitmentTime%, ini/Settings.ini, UnixTime, commitmentTime
		}
		
		SendChat("/" . commitmentChat . " Wir veranstalten einen Einsatz, alle Beamten erscheinen bitte!")
		SendChat("/" . commitmentChat . " Ihr habt bis " . newTime . " (" . commitmentMins . " Minuten) Zeit euch aufzustellen.")
		SendChat("/" . commitmentChat . " Treffpunkt: " . commitmentLocation . ", Ausrüstung: " . extras)
	}
}
return

:?:/mt::
:?:/mats::
{
	if (rank > 0 && rank < 7) {
		extra := "/f HQ:"
	} else if (rank > 7) {
		extra := "/hq"
	} else {
		SendInfo("Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
		extra := "/f HQ:"
	}
	
	SendChat(extra . " Es findet ein Matstransport statt! ALLE EINHEITEN SOFORT ANRÜCKEN!")
	SendChat(extra . " Derzeitige Position: " . getLocation())
}
return

:?:/mrob::
{
	if (rank > 0 && rank < 7) {
		extra := "/f HQ:"
	} else if (rank > 7) {
		extra := "/hq"
	} else {
		SendInfo("Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
		extra := "/f HQ:"
	}
	
	SendChat(extra . " Es findet aktuell ein Überfall auf einen Matstransport statt!")
	SendChat(extra . " ALLE EINHEITEN SOFORT ANRÜCKEN! Aktuelle Position: " . getLocation())
	
	if (!bk) {
		bk := true
		
		SendChat("/bk")
	}
}
return

:?:/go::
SendInput, {Enter}
{	
	if (rank > 0 && rank < 7) {
		extra := "/d HQ:"
	} else if (rank > 7) {
		extra := "/hq"
	} else {
		SendInfo("Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
		extra := "/d HQ:"
	}
	
	SendChat(extra . " Einsatzleitung erlaubt Zugriff, GOGOGO!")
}
return

:?:/fgo::
SendInput, {Enter}
{
	SendChat("/f HQ: Einsaztleitung erlaubt Zugriff, GOGOGO!")
}
return

:?:/rgo::
SendInput, {Enter}
{
	SendChat("/r HQ: Einsaztleitung erlaubt Zugriff, GOGOGO!")
}
return

:?:/abholung::
{
	abholungChat := PlayerInput("Chat: ")
	if (abholungChat == "" || abholungChat == " ") {
		return
	}
	
	SendChat("/" . abholungChat . " HQ: Erbitte Abholung in " . getLocation() . "!")
}
return

:?:/kabholung::
SendInput, {Enter}
{
	if (abholungChat != "") {
		SendChat("/" . abholungChat . " HQ: Eine Abholung wird nicht mehr benötigt.")
		
		abholungChat := ""
	} else {
		SendError("Du hast keine Abholung angefordert.")
	}
}
return

:?:/z::
:?:/ziel::
{
	hunting := PlayerInput("Einsatzziel: ")
	if (hunting == "" || hunting == " ") {
		return
	}
	
	if (getFullName(hunting) == "") {
		SendInfo("Der gesuchte Spieler ist nicht online.")
		return
	}
	
	if (rank > 6) {
		SendChat("/hq An alle Einheiten: Einsatzziel ist " . getFullName(hunting) . " (ID: " . getPlayerIdByName(getFullName(hunting)) . "). Alle SOFORT ausrücken!")
	} else {
		SendChat("/f HQ: An alle Einheiten: Einsatzziel ist " . getFullName(hunting) . " (ID: " . getPlayerIdByName(getFullName(hunting)) . "). Alle SOFORT ausrücken!")
	}
	
	Sleep, 200
	
	SendInfo("Möchtest du den Spieler suchen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
	
	KeyWait, X, D, T10
	
	if (!ErrorLevel) {
		playerToFind := getFullName(hunting)
		autoFindMode := 1
		
		findPlayer()
		findInfo(playerToFind)
	}
}
return

:?:/vf::
:?:/verf::
:?:/verfolgung::
{
	name := PlayerInput("Gesuchter Verbrecher: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Der Verbrecher ist nicht online.")
		return
	}

	SendChat("/d HQ: Erbitte Unterstützung bei der Verfolgung von " . getFullName(name) . "[" . getPlayerIdByName(getFullName(name), true) . "]!")
}
return

:?:/ort::
{
	position := PlayerInput("Letzter bekannter Aufenthaltsort: ")
	if (position == "" || position == " ") {
		return
	}
	
	SendChat("/d HQ: Letzter bekannter Aufenthaltsort: " . position)
}
return

:?:/air::
SendInput, {Enter}
{
	SendChat("/d HQ: Fordere Luftüberwachung im Sektor " . getLocation() . " an!")
}
return

:?:/maumodus::
SendInput, {Enter}
{
	if (maumode) {
		maumode := 0
		
		SendInfo("Du hast den Maumau Modus " . cred . "deaktiviert" . cwhite . ".")
	} else {
		maumode := 1
	
		SendInfo("Du hast den Maumau Modus " . cgreen . "aktiviert" . cwhite . ".")
		SendInfo("/mhelp kannst du alles genau einsehen.")
	}
}
return

:?:/wasser::
:?:/wassermodus::
SendInput, {Enter}
{
	if (watermode) {
		watermode := 0
		
		SendInfo("Du hast den Wassermodus " . cred . "deaktiviert" . cwhite . ".")
	} else {
		watermode := 1
		airmode := 0
		
		SendInfo("Du hast den Wassermodus " . cgreen . "aktiviert" . cwhite . ".")
	}
}
return

:?:/luft::
:?:/luftmodus::
SendInput, {Enter}
{	
	if (airmode) {
		airmode := 0
		
		SendInfo("Luftmodus " . cred . "deaktiviert" . cwhite . ".")
	} else {
		airmode := 1
		watermode := 0
		
		SendInfo("Luftmodus " . cgreen . "aktiviert" . cwhite . ".")
	}
}
return

:?:/einweisung::
SendInput, {Enter}
{
	if (!admission) {
		admission := 1
		
		SendInfo("Du hast den Einweisungs-Modus " . cgreen . "aktiviert" . cwhite . ".")
	} else {
		admission := 0
	
		SendInfo("Du hast den Einweisungs-Modus " . cred . "deaktiviert" . cwhite . ".")
	}
}
return

:?:/sperrzone::
{
	sperrzone := PlayerInput("Sperrzone: ")
	if (sperrzone == "" || sperrzone == " ") {
		return
	}

	SendChat("/gov Das Gebiet ''" . sperrzone . "' wird zur Sperrzone erklärt.")
	SendChat("/gov Wer sich unbefugt in der Sperrzone aufhält muss mit Konsequenzen rechnen.")
}
return

:?:/ksperrzone::
SendInput, {Enter}
{
	if (sperrzone != "") {
		SendChat("/gov Die Sperrzone " . sperrzone . " wird hiermit aufgehoben.")
	} else {
		SendChat("/gov Die Sperrzone wird hiermit aufgehoben.")
	}

	Sleep, 100

	SendChat("/roadblock deleteall")
}
return

:?:/fischtyp::
:?:/fishtype::
:?:/fishtyp::
{
	SendInfo(csecond . "1: {FFFFFF}geringste LBS/HP - " . csecond . "2: {FFFFFF}geringster Geldwert")
	
	fishType := PlayerInput("Typ: ")
	
	if (fishType == "1") {
		fishMode := 0
		
		SendInfo("Du wirfst nun den Fisch mit dem geringsten " . csecond . "LBS/HP-Wert {FFFFFF}weg.")
		
		IniWrite, %fishMode%, ini/Settings.ini, settings, fishMode
	} else if (fishType == "2") {
		fishMode := 1
		
		SendInfo("Du wirfst nun den Fisch mit dem geringsten " . csecond . "Geldwert {FFFFFF}weg.")
		
		IniWrite, %fishMode%, ini/Settings.ini, settings, fishMode
	}
}
return

:?:/afish::
SendInput, {Enter}
{
	startFish()
}
return

:?:/asell::
SendInput, {Enter}
{
	if (IsPlayerInRangeOfPoint(2.3247, -28.8923, 1003.5494, 10)) {
		sellFish()
	} else {
		IniRead, Fishmoney, ini/Stats.ini, Allgemein, Fishmoney, 0
		SendInfo("Du kannst deine Fische hier nicht verkaufen! (Gesamter Verdienst: $" . csecond . formatNumber(Fishmoney) . cwhite . ")")
	}
}
return

:?:/acook::
SendInput, {Enter}
{
	cookFish()
}
return

:?:/fp::
:?:/fische::
SendInput, {Enter}
{
	checkFish()
}
return

:?:/hp::
:?:/cooked::
SendInput, {Enter}
{
	checkCook()
}
return

:?:/sellfish::
{
	hp := checkCook()
	
	if (hp < 1) {
		SendInfo("Du hast keine gekochten Fische bei dir.")
	} else {
		name := PlayerInput("/Name: ")
		if (name == "" || GetFullName(name) == "") {
			return
		}
		
		SendChat("/l Ich gebe Dir, " . getFullName(name) . ", nun meine gekochten Fische mit " . hp . " HP!")
		if (!admin) {
			Sleep, 750
		}
		
		Loop, 5 {
			SendChat("/sell cooked " . A_Index . " " . getFullName(name))
			if (!admin) {
				Sleep, 500
			}
		}
	}
}
return

:?:/dep::
:?:/department::
{
	IniRead, department, ini/Settings.ini, settings, department, %A_Space%
	
	SendInfo("Deine aktuelle Abteilung: " . csecond . department)
	
	dep := PlayerInput("Abteilung: ")
	if (dep == "" || dep = " ") {
		return
	}
	
	if (dep == department) {
		SendError("Diese Abteilung hast du bereits eingetragen.")
		return
	}
	
	IniWrite, %dep%, ini/Settings.ini, settings, department
	
	SendInfo("Deine Abteilung wurde auf " . csecond . dep . cwhite . " geupdated.")
}
return

:?:/setrang::
{
	IniRead, rank, ini/Settings.ini, settings, rank, 0
		
	rank := PlayerInput("Rang: ")
	if (rank == "" || rank = " ") {
		return
	}
	
	if (rank > 11 || rank < 1) {
		SendError("Der Rang muss mindestens 1 und maximal 11 sein.")
		return
	}
	
	IniWrite, %rank%, ini/Settings.ini, settings, rank
	SendInfo("Dein Rang wurde auf " . csecond . rank . cwhite . " geupdated.")
}
return

:?:/bc::
SendInput, {Enter}
{
	SendChat("/roadbarrier create")
}
return

:?:/bd::
SendInput, {Enter}
{
	SendChat("/roadbarrier delete")
}
return

:?:/bda::
SendInput, {Enter}
{
	SendChat("/roadbarrier deleteall")
}
return

:?:/rb::
SendInput, {Enter}
{
	SendChat("/roadblock create")
}
return

:?:/db::
SendInput, {Enter}
{
	SendChat("/roadblock delete")
}
return

:?:/dba::
SendInput, {Enter}
{
	SendChat("/roadblock deleteall")
}
return

:?:/rs::
:?:/rr::
:?:/robres::
SendInput, {Enter}
{
	if (!isPlayerAtLocal()) {
		SendError("Du bist nicht in der Nähe einer Restaurant-Kette.")
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		SendError("Du darfst dich in keinem Fahrzeug befinden.")
		return
	}

	addLocalToStats()
}
return

:?:/sr::
SendInput, {Enter}
{
	SendChat("/showres")
}
return

:?:/cd::
:?:/countdown::
{
	if (countdownRunning) {
		SetTimer, CountdownTimer, Off
		
		countdownRunning := 0
		
		SendChat("/" . cdChat . " Der Countdown wurde abgebrochen!")
	} else {
		cdTime := PlayerInput("Sekunden: ")
		
		if (cdTime == "")
			cdTime := 3
		
		if cdTime is not number
			return
		
		cdChat := PlayerInput("Chat: ")
		
		if (cdChat == "") {
			cdChat := "l"
		}

		SendChat("/" . cdChat . " Countdown:")
		
		cdGoMessage := "Go Go Go!"
		
		SendInfo("Du kannst den Countdown mit '" . csecond . stopAutomaticSystemsNoMods . cwhite . "' abbrechen.")
		
		SetTimer, CountdownTimer, 1000
		
		countdownRunning := 1
	}
}
return

:?:/geld::
:?:/bank::
SendInput, {Enter}
{
	SendChat("Sehe ich aus wie ein Geldautomat?")
}
return

:?:/taxi::
SendInput, {Enter}
{
	SendChat("Ich bin kein Taxifahrer, sondern ein " . getFractionTitle() . "!")
}
return

:?:/gf::
:?:/gfs::
SendInput, {Enter}
{
	SendChat("/gangfights")
}
return

:?:/np::
SendInput, {Enter}
{
	random, rand, 1, 3
	
	if (rand == 1) {
		SendChat("Kein Problem!")
	} else if (rand == 2) {
		SendChat("Gerne!")
	} else if (rand == 3) {
		SendChat("Bitteschön!")
	}
}
return

:?:/beweise::
SendInput, {Enter}
{
	SendChat("Haben Sie dafür Beweise? (Screenshots, Video, o.ä.)")
}
return

:?:/zeuge::
SendInput, {Enter}
{
	SendChat("Zeugen zählen nicht und werden nicht weiter beachtet.")
}
return

:?:/warte::
SendInput, {Enter}
{
	SendChat("Einen Moment bitte, der Fall wird überprüft.")
}
return

:?:/beschwerde::
SendInput, {Enter}
{
	SendChat("Sie haben das Recht, eine Beschwerde im Forum zu erstellen.")

	if (!admin) {
		Sleep, 400
	}

	SendChat("Wir bitten Sie hierbei, die Beschwerdeninformationen zu beachten.")
}
return

:?:/rechte::
SendInput, {Enter}
{
	SendChat("Sie haben das Recht zu schweigen. Alles was Sie sagen, kann und wird vor Gericht gegen Sie verwendet werden.")
	
	if (!admin) {
		Sleep, 1500
	}
	
	SendChat("Sie haben das Recht auf einen Anwalt. Können Sie sich keinen leisten wird Ihnen einer gestellt.")
	
	if (!admin) {
		Sleep, 1500
	}
	
	SendChat("Haben Sie Ihre Rechte verstanden, welche ich Ihnen vorgelesen hab?")
}
return

:?:/warten::
SendInput, {Enter}
{
	SendChat("Bitte warten Sie einen Moment, ich überprüfe die Gültigkeit Ihrer Dokumente.")
}
return

:?:/passieren::
SendInput, {Enter}
{
	SendChat("Sie dürfen passieren.")
	
	if (!admin) {
		Sleep, 750
	}	
	
	SendChat("Ich wünsche Ihnen eine gute Weiterfahrt. Auf Wiedersehen!")
}
return

:?:/runter::
SendInput, {Enter}
{
	SendChat("Steigen Sie bitte umgehend vom Fahrzeug.")

	if (!admin) {
		Sleep, 750
	}
	
	SendChat("Ansonsten sind wir gezwungen Sie wegen Verweigerung zu verhaften.")
}
return

:?:/hdf::
:?:/ruhe::
SendInput, {Enter}
{
	random, tmp, 1, 3
	
	if (tmp == 1) {
		SendChat("Sein Sie bitte still.")
	} else if (tmp == 2) {
		SendChat("Können Sie bitte ruhig sein?")
	} else if (tmp == 3) {
		SendChat("Bitte sein Sie leise..")
	}
}
return

:?:/tuch::
SendInput, {Enter}
{
	SendChat("Warum weinen Sie, möchten Sie ein Taschentuch?")
}
return

:?:/pi::
{	
	name := PlayerInput("Spielerinformationen: ")
	
	SendChat("/id " . name)
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/number " . name)
	if (!admin) {
		Sleep, 750
	}
	
	SendChat("/mdc " . name)
}
return

:?:/alotto::
SendInput, {Enter}
{
	if (!lottoNumber) {
		Random, randomNumber, 1, 100
		
		SendChat("/lotto " . randomNumber)
	} else if (lottoNumber > 100) {
		SendChat("/lotto " . getId())
	} else {
		SendChat("/lotto " . lottoNumber)
	}
}
return

:?:/fan::
{
	name := PlayerInput("Fan: ")
	if (name == "" || name == " ") {
		return
	}
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	if (name != "") {
		SendChat("/me gibt " . getFullName(name) . " ein Autogramm.")
		SendChat("/showbadge " . name)
	}
}
return

:?:/pb::
:?:/paintball::
SendInput, {Enter}
{
	SendChat("/paintball")
	
	Sleep, 200
	
	players := 0
	
	Loop, 100 {
		if (InStr(readChatLine(players), "Punkte")) {
			players ++
		} else {
			SendInfo("Spieler im Paintball: " . csecond . players)
			return
		}
	}
}
return

:?:/savestats::
SendInput, {Enter}
{
	FormatTime, time,, dd.MM.yyyy HH:mm
	
	SendInfo("Statistiken werden gespeichert, Datum: " . csecond . time)
	
	SendChat("/time")
	
	Sleep, 250
	
	SendChat("/stats")
	
	Sleep, 250
	
	SendInput, {F8}
	Sleep, 250
	SendInput, {ESC}
}
return

:?:/uc::
{	
	if (!getPlayerInteriorId()) {
		SendError("Du befindest dich in keinem Gebäude.")
		return
	}		
	
	SendInput, /undercover{space}
}
return

:?:/auc::
SendInput, {Enter}
{
	if (!getPlayerInteriorId()) {
		SendError("Du befindest dich in keinem Gebäude.")
		return
	}	
	
	Random, number, 1, 39
	
	SendChat("/undercover " . number)
}
return

:?:/jas::
SendInput, {Enter}
{
	SendChat("Ja Sir, was kann ich für Sie tun?")
}
return

:?:/jam::
SendInput, {Enter}
{
	SendChat("Ja Madam, was kann ich für Sie tun?")
}
return

:?:/ja::
SendInput, {Enter}
{
	SendChat("Ja, was kann ich für Sie tun?")
}
return

:?:/re::
:?:/resms::
{
	distanceSMS := 0
	
	Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		if (RegExMatch(A_LoopReadLine, "SMS: (.+), Sender: (\S+) \((\d+)\)", preSMS_)) {
			if (preSMS_2 != getUsername()) {
				RegExMatch(A_LoopReadLine, "SMS: (.+), Sender: (\S+) \((\d+)\)", sms_)
			}
		} else if (RegExMatch(A_LoopReadLine, "SMS: (.+)\.\.\.", preSMS_1_)) {
			distanceSMS := 0
			
			RegExMatch(A_LoopReadLine, "SMS: (.+)\.\.\.", sms_)
		} else if (RegExMatch(A_LoopReadLine, "\.\.\.(.*), Sender: (\S+) \((\d+)\)", preSMS_2_)) {
			if (distanceSMS == 2) {
				if (preSMS_2_2 != getUsername()) {
					sms_2 := preSMS_2_2
					sms_3 := preSMS_2_3
				}
			}
		}
		
		distanceSMS ++
	}
	
	if (sms_2 != "") {
		SendInfo("Letzte SMS (von " . csecond . sms_2 . cwhite . "):")
		SendClientMessage(prefix . csecond . sms_1)
		
		SendInput, /sms %sms_3%{space}
	} else {
		SendError("Es wurde keine SMS gefunden.")
	}
}
return

:?:/read::
{
	Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		if (RegExMatch(A_LoopReadLine, "\[Werbung\] (.+), (\S+) \((\d+)\)")) {
			RegExMatch(A_LoopReadLine, "\[Werbung\] (.+), (\S+) \((\d+)\)", ad_)
		}
	}
	
	if (ad_2 != "" || ad_2 != getUserName()) {
		SendInfo("Letzte Werbung (von " . ad_2 . "):")
		SendClientMessage(prefix . csecond . ad_1)
		
		SendInput, /sms %ad_3%{space}
	} else {
		SendError("Es wurde keine Werbung gefunden.")
	}
}
return

:?:/kcall::
{	
	name := PlayerInput("Wen möchtest du anrufen?: ")
	if (name == "" || name == " ") {
		return
	}

	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	if (getFullName(name) == getUserName()) {
		SendError("Du kannst dich selbst nicht anrufen.")
		return
	}

	SendChat("/number " . name)
	
	Sleep, 200

	if (RegExMatch(readChatLine(0), "Name: (\S*), Ph: (\d*)", number_)) {
		SendInfo("Ausgewählter Spieler: " . csecond . number_1)
		SendChat("/call " . number_2)
	} else {
		SendError("Es konnte kein Spieler gefunden werden.")
	}
}
return

:?:/calarm::
{
	name := PlayerInput("Wen möchtest du vorm O-Amt warnen?: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}

	if (getFullName(name) == getUserName()) {
		SendError("Du kannst dir selbst keine SMS senden.")
		return
	}

	SendChat("/number " . name)
	
	Sleep, 200

	if (RegExMatch(readChatLine(0), "Name: (\S*), Ph: (\d*)", number_)) {
		SendInfo("Ausgewählter Spieler: " . csecond . number_1)
		SendChat("/" . number_2 . " Geh lieber offline, dein Car wird vom O-Amt abgeschleppt, gönne dennen nicht.")
	} else {
		SendError("Es konnte kein Spieler gefunden werden.")
	}
}
return

:?:/ksms::
{
	name := PlayerInput("Wen möchtest du deine SMS senden?: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}

	if (getFullName(name) == getUserName()) {
		SendError("Du kannst dir selbst keine SMS senden.")
		return
	}

	SendChat("/number " . name)
	
	Sleep, 200

	if (RegExMatch(readChatLine(0), "Name: (\S*), Ph: (\d*)", number_)) {
		SendInfo("Ausgewählter Spieler: " . csecond . number_1)
		
		SendInput, t/sms %number_2%{space}
	} else {
		SendError("Es konnte kein Spieler gefunden werden.")
	}
}
return

:?:/p::
:?:/pickup::
SendInput, {Enter}
{
	called := false
	
	Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		if (RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)")) {
			RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)", caller_)
			called := true
		} else if (RegExMatch(A_LoopReadLine, "Der Gesprächspartner hat aufgelegt\.") || RegExMatch(A_LoopReadLine, "Du hast aufgelegt\.") || RegExMatch(A_LoopReadLine, "Die Verbindung zu deinem Gesprächspartner wurde unterbrochen\.")) {
			called := false
		}
	}
	
	if (called && caller_1 != "") {
		name := getUsername()
		
		SendChat("/pickup")
		
		if (!admin) { 
			Sleep, 400
		}
		
		SendChat("Guten " . getDayTime() . " " . caller_1 . ", Sie sprechen mit " . getFractionTitle() . " " . name . ".")
		
		if (!admin) {
			Sleep, 750
		}
		
		SendChat("Wie kann ich Ihnen helfen?")
	} else {
		SendInfo("Niemand hat dich angerufen!")
	}
}
return

:?:/h::
:?:/hangup::
SendInput, {Enter}
{
	if (tv) {
		return
	}		
	
	called := false
	pickedup := false
	
	Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		if (RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)") || RegExMatch(A_LoopReadLine, "Der Spieler hat abgehoben\.")) {
			RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)", caller_)
			called := true
			pickedup := true
		} else if (RegExMatch(A_LoopReadLine, "Bitte Warte bis der Spieler annimmt\.")) {
			called := true
			pickedup := false
		} else if (RegExMatch(A_LoopReadLine, "Der Gesprächspartner hat aufgelegt\.") || RegExMatch(A_LoopReadLine, "Du hast aufgelegt\.") || RegExMatch(A_LoopReadLine, "Die Verbindung zu deinem Gesprächspartner wurde unterbrochen\.")) {
			called := false
			pickedup := false
		}
	}
	
	if (called) {
		if (pickedup) {
			if (caller_1 != "") {
				SendChat("Vielen Dank für Ihren Anruf, " . caller_1 . ".")
			} else {
				SendChat("Vielen Dank für Ihren Anruf.")
			}
			
			if (!admin) {
				Sleep, 750
			}
			
			SendChat("Ich wünsche Ihnen noch einen schönen " . getDayTime() . ".")
		}
		
		if (!admin) {
			Sleep, 750
		}
		
		SendChat("/hangup")
	} else {
		SendInfo("Niemand hat dich angerufen.")
	}
}
return

:?:/ab::
SendInput, {Enter}
{
	called := false
	
	Loop, Read, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt
	{
		if (RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)")) {
			RegExMatch(A_LoopReadLine, "Dein Handy klingelt. Tippe /pickup. Anrufer-ID: (\S+)", caller_)
			called := true
		} else if (RegExMatch(A_LoopReadLine, "Der Gesprächspartner hat aufgelegt\.") || RegExMatch(A_LoopReadLine, "Du hast aufgelegt\.") || RegExMatch(A_LoopReadLine, "Die Verbindung zu deinem Gesprächspartner wurde unterbrochen\.")) {
			called := false
		}
	}
	
	if (called) {
		SendChat("/pickup")
		
		if (!admin) {
			Sleep, 750
		}
		
		SendChat("Guten " . getDayTime() . " " . caller_1 . ",")
	
		if (!admin) {
			Sleep, 750
		}
	
		SendChat("Sie sind verbunden mit dem Anrufbeantworter von " . getUsername() . ".")
		
		if (!admin) {
			Sleep, 750
		}
		
		SendChat("Ich bin leider beschäftigt, bitte rufen Sie später erneut an!")
		
		if (!admin) {
			Sleep, 750
		}
		
		SendChat("/hangup")
	} else {
		SendInfo("Niemand hat dich angerufen!")
	}
}
return

:?:/tag::
SendInput, {Enter}
{
	SendChat("Guten " . getDayTime() . ", wie kann ich Ihnen behilflich sein?")
}
return

:?:/bye::
SendInput, {Enter}
{
	SendChat("Ich wünsche Ihnen noch einen schönen " . getDayTime() . ". Auf Wiedersehen!")
}
return

:?:/ac::
SendInput, {Enter}
{
	SendChat("/activity")
}
return

:?:/ga::
SendInput, {Enter}
{
	SendChat("/gpsaus")
	SendInfo("Du hast den GPS Marker deaktiviert.")
}
return

:?:/fg::
SendInput, {Enter}
{
	if (!getPlayerInteriorId()) {
		SendChat("/festgeld 1")
	} else { 
		SendChat("/festgeld 1250000")
	}
}
return

:?:/ap::
SendInput, {Enter}
{
	SendChat("/accept paket")

	Sleep, 200

	if (InStr(readChatLine(0) . readChatLine(1) . readChatLine(2), "Du hast bereits ein Erste-Hilfe-Paket")) {
		getItems()
		
		if (paketInfo) {
			SendChat("/l Vielen Dank " . medicName . ", doch ich habe bereits ein Paket!")
		}
	} else if (RegExMatch(readChatLine(0) . readChatLine(1) . readChatLine(2), "\* Du hast für \$(\d+) ein Erste-Hilfe-Paket von (\S+) gekauft\.", chat_)) {
		getItems()
	
		if (paketInfo) {
			SendChat("/l Vielen Dank " . chat_2 . " für das Erste-Hilfe-Paket!")
		}
	}
}
return

:?:/sbd::
{
	SendInput, /showbadge{space}
}
return

:?:/minuten::
{
	seconds := PlayerInput("Sekunden: ")
	if (seconds == "" || seconds == " ") {
		return
	}
	
	if (seconds is not number) {
		SendError("Die Sekundenangabe muss eine Zahl sein.")
		return
	}
	
	if (seconds < 60) {
		SendError("Die Sekundenangabe muss mehr als 60 sein.")
		return
	}
	
	if (seconds != "") {
		minutes := Floor(seconds / 60)
		SendClientMessage(prefix . csecond . formatNumber(seconds) . cwhite . " Sekunden sind " . csecond . formatNumber(minutes) . cwhite . " Minuten.")
	}
}
return

:?:/link::
SendInput, {Enter}
{
	linkresult := false
	
	Loop, 300 {
		chat := readChatLine(A_Index - 1)
		
		if (RegExMatch(Chat, "http\:\/\/(\S+)", link_)) {
			clipboard := "http://" . link_1
			
			linkresult := true
		} else if (RegExMatch(Chat, "https\:\/\/(\S+)", link_)) {
			clipboard := "https://" . link_1
		
			linkresult := true
		} else if (RegExMatch(Chat, "www\.(\S+)", link_)) {
			clipboard := "www." . link_1
		
			linkresult := true
		}
			
		if (linkresult) {
			SendClientMessage(prefix . cblue . "|________________________________________|")
			SendInfo("Es wurde ein Link abkopiert und gespeichert:")
			SendClientMessage(prefix . csecond . clipboard)
			SendInfo("Du kannst diesen nun überall einfügen.")
			SendClientMessage(prefix . cblue . "|________________________________________|")
			return
		}
	}
	
	if (!linkresult) {
		SendInfo("Es wurde kein gültiger Link gefunden.")
	}	
}
return

:?:/savechat::
SendInput, {Enter}
{
	FileCreateDir, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups
	FormatTime, zeit, %A_Now%,dd.MM.yy - HH.mm
	FileCopy, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups\chatlog %zeit% Uhr.txt, 0
	
	SendInfo("Es wurde ein Backup des aktuellen Chatlogs erstellt.")
}
return

:?:/cc::
:?:/chatclear::
SendInput, {Enter}
{
	Loop, 25 {
		SendClientMessage("")
	}
}
return

:?:/wagen::
SendInput, {Enter}
{
	SendChat("/d HQ: Ich benötige dringend einen Streifenwagen, aktuelle Position: " . getLocation())
}
return

:?:/sani::
SendInput, {Enter}
{
	SendChat("/d HQ: Ich benötige dringend einen Rettungswagen, aktuelle Position: " . getLocation())
	SendChat("/service")
	
	Sleep, 250
	
	SendInput, {down 4}{enter}
}
return

:?:/oamt::
:?:/abschlepp::
SendInput, {Enter}
{
	SendChat("/d HQ: Ich benötige dringend einen Ordnungsbeamten, aktuelle Position: " . getLocation())
	SendChat("/service")
	
	Sleep, 250
	
	SendInput, {down 5}{enter}
}
return

:?:/checkpoint::
{
	x := PlayerInput("X: ")
	if (x == "" || x == " " || x is not number) {
		SendError("Du hast keine 'X' Koordinate angegeben.")
		return
	}
	
	y := PlayerInput("Y: ")
	if (y == "" || y == " " || y is not number) {
		SendError("Du hast keine 'Y' Koordinate angegeben.")
		return
	}
	
	z := PlayerInput("Z: ")
	if (z == "" || z == " " || z is not number) {
		SendError("Du hast keine 'Z' Koordinate angegeben.")
		return
	}	

	if (isMarkerCreated()) {
		SendInfo("Möchtest du den Checkpoint überschreiben? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")
		
		KeyWait, X, D, T10
		
		if (ErrorLevel) {
			return
		}
	}
	
	if (setCheckpoint(x, y, z, 0.5)) {
		return
	} else {
		SendInfo("Der Checkpoint konnte nicht erstellt werden.")
	}
}
return

:?:/coords::
SendInput, {Enter}
{
	getPlayerPos(posX, posY, posZ)
	SendInfo("X: " . csecond . posX . cwhite . ", Y: " . csecond . posY . cwhite . " Z: " . csecond . posZ)
}
return

:?:/reload::
:?:/restart::
SendInput, {Enter}
{
	Reload
}
return

;; ------------------------------------ Admin Systeme --------------------------------------------------
;; -----------------------------------------------------------------------------------------------------
;; -----------------------------------------------------------------------------------------------------

acceptMainLabel:
{
	if (isBlocked()) {
		return
	}	
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	acceptTicket(ticketID)
}
return

accept1Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(1)
}
return

accept2Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(2)	
}
return

accept3Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(3)	
}
return

accept4Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(4)	
}
return

accept5Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(5)	
}
return

accept6Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(6)	
}
return

accept7Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(7)	
}
return

accept8Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(8)	
}
return

accept9Label:
{
	if (isBlocked()) {
		return
	}
	
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(9)
}
return

:?:/tt::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	acceptTicket(ticketID)
}
return

:?:/gt::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	reason := PlayerInput("Grund: ")
	if (reason == "" || reason == " ") {
		SendError("Du hast keinen Grund angegeben.")
		return
	}
	
	SendInfo("Mögliche Empfänger: (Sup)porter, (Mod)erator, Admin, (Head) Admin, (Proj)ektleiter, (Community) Helfer")
	
	toWhomInput := PlayerInput("An: ")
	if (toWhomInput == "" || toWhomInput == " ") {
		SendError("Du hast keinen Empfänger angegeben.")
		return
	}
	
	if (InStr(toWhomInput, "Sup") || InStr(toWhomInput, "Mod") || InStr(toWhomInput, "Admin") || InStr(toWhomInput, "Head") || InStr(toWhomInput, "Proj") || InStr(toWhomInput, "Community")) {
		toWhom := ""
		plus := "+"
		
		if (InStr(toWhomInput, "Proj")) {
			toWhom := "Projektleiter"
			plus := ""
		} else if (InStr(toWhomInput, "Head")) {
			toWhom := "Head Admin"
		} else if (InStr(toWhomInput, "Admin")) {
			toWhom := "Admin"
		} else if (InStr(toWhomInput, "Mod")) {
			toWhom := "Moderator"
		} else if (InStr(toWhomInput, "Sup")) {
			toWhom := "Supporter"
		} else if (InStr(toWhomInput, "Community")) {
			toWhom := "Communityhelfer"
		} else {
			SendInfo("Unbekannter Empfänger: " . csecond . toWhomInput)
			return
		}
		
		SendChat("/aw " . ticketID . " Ich werde dich nun an einen " . toWhom . plus . " weiterleiten.")
		Sleep, 500
		SendChat("/aw " . ticketID . " Bitte gedulde dich, bis ein " . toWhom . plus . " dein Ticket annimmt.")
		Sleep, 500
		
		toWhomCommand := toWhom
		command := "a"
		
		if (toWhomCommand == "Head Admin") {
			toWhomCommand := "Head"
		}
		
		if (toWhomCommand == "Communityhelfer") {
			command := "com"
		}
		
		SendChat("/gt " . ticketID . " " . toWhomCommand)
		SendChat("/" . command . " [Ticket " . ticketID . "] Für: " . toWhom . plus . ", Grund: " . reason)
	} else {
		toWhom := getFullName(toWhomInput)
		
		if (toWhom == "") {
			SendInfo("Unbekannter Spieler: " . csecond . toWhomInput)
		} else {
			SendChat("/aw " . ticketID . " Ich werde dich nun an " . toWhom . " weiterleiten.")
			SendChat("/aw " . ticketID . " Bitte gedulde dich, bis " . toWhom . " dein Ticket annimmt.")
			SendChat("/gt " . ticketID . " " . toWhom)
			
			Sleep, 500
			
			SendChat("/a [Ticket " . ticketID . "] Für: " . toWhom . ", Grund: " . reason)
		}
	}
}
return

:?:/dt::
{
	if (!admin) {
		SendChat("/dt")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	closeTicket(ticketID)
}
return

:?:/fragen::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Hast du weitere Fragen, Probleme oder Anliegen?")
}
return

:?:/tafk::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Da du nicht mehr antwortest, werde ich das Ticket nun schließen!")
	
	Sleep, 500
	
	closeTicket(ticketID)
}
return

:?:/wh::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Wie kann ich dir helfen?")
}
return

:?:/grund::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Warum soll ich dich an das gewünschte Mitglied weiterleiten?")
}
return

:?:/ubbw::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " UBB (= Neon) bzw. Unterbodenbeleuchtungs Codes kannst du in speziellen Events gewinnen (äußerst selten).")

	if (!admin) {
		Sleep, 500
	}
	
	SendChat("/aw " . ticketID . " Ebenfalls ist es möglich einen UBB-Code bzw. ein UBB-Car für InGame Geld von anderen Spielern abzukaufen.")
}
return

:?:/autow::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Dein Auto findest du ganz einfach per /carkey -> Auto auswählen -> /findcar wieder.")
}
return

:?:/cop::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendError("Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendError("Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Bitte melde dich beim zuständigen Beamten, die Administration hat damit nichts zu tun!")
}
return

:?:/sdm::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
		
	SendChat("/prison " . ID . " 60 Sinnloses Deathmatch")
}
return

:?:/2sdm::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 120 2x Sinnloses Deathmatch")
}
return

:?:/3sdm::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . name . " 240 3x Sinnloses Deathmatch")
	SendChat("/gban " . name . " 78 3x Sinnloses Deathmatch")
	SendChat("/warn " . name . " 3x Sinnloses Deathmatch")
}
return

:?:/unreal::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . name . " 30 Unrealistisches Verhalten")
}
return

:?:/buguse::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Buguse-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . name . " 120 Buguse")
	SendChat("/warn " . name . " Buguse")
}
return

:?:/intflucht::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Interior-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Interior-Flucht")
}
return

:?:/offline::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Offline-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Offline-Flucht")
}
return

:?:/carsurf::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Carsurf-DM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Carsurf-DM")
}
return

:?:/jobst::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Jobstörung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Jobstörung")
}
return

:?:/eventst::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Eventstörung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Eventstörung")
}
return

:?:/anfahren::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Anfahren-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Absichtliches Anfahren")
}
return

:?:/baserape::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Baserape-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Baserape während Gangfight")
}
return

:?:/gfst::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("GF-Störung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Gangfight-Störung")
}
return

:?:/anti::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Schießen-AUF-Antispawnkill-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Schießen auf Antispawnkill")
}
return

:?:/escflucht::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 ESC-Flucht")
}
return

:?:/rotor::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Rotorkill-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Rotorkill")
}
return

:?:/geklaert::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Geklärt-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 0 Geklärt mit Geschädigtem")
}
return

:?:/keinrw::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Kein-Verstoß-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 0 Kein Regelwerkverstoß")
}
return

:?:/unbeteiligt::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Unbeteiligter-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " Unbeteiligter im Gangfight")
}
return

:?:/escgf::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Gangfight")
}
return

:?:/escpb::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Paintball")
}
return

:?:/esccp::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Checkpoint")
}
return

:?:/escbeamte::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC vor Beamten")
}
return

:?:/escarrest::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC bei Arrest")
}
return

:?:/timebug::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Timebug-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " Timebug")
}
return

:?:/abwerbe::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Abwerbe-ID: ")	
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	ID := getPlayerIdByName(name, true)
	
	SendChat("/clearchat")
	SendChat("/clearchat")
	
	SendChat("/ban " . ID . " Abwerbe")
}
return

:?:/lbel::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}

	SendChat("/mute " . ID . " 60 Leichte Beleidigung")
}
return

:?:/mbel::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")	
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 120 Mittlere Beleidigung")
}
return

:?:/sbel::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}

	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/warn " . name . " Schwere Beleidigung")
	SendChat("/tban " . name . " 24 Schwere Beleidigung")
}
return

:?:/umgang::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 30 Umgangston")
}
return

:?:/aabuse::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/supban " . ID . " 30 Ausnutzen des Adminchats")
}
return

:?:/adabuse::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 60 Ausnutzen der Werbefunktion")
}
return

:?:/supabuse::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/supban " . ID . " 60 Ausnutzen des Support-Systems")
}
return

:?:/spam::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 10 Spam")
}
return

:?:/caps::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 10 Caps")
}
return

:?:/prov::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendError("Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 15 Provokation")
}
return

:?:/meldungen::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}		
	
    SendChat("/announce Du hast Fragen oder Probleme, benutze '/sup [Deine Frage]'.")
    SendChat("/announce Regelbrecher wie Hacker, Buguser können mit '/a' oder '/cheater' gemeldet werden!")
}
return

:?:/hacker::
{
	if (hackerFinder) {
		hackerFinder := false
		
		SetTimer, HackerFinder, Off
		
		SendInfo("Du hast den Hackerfinder " . cred . "deaktiviert" . cwhite . ".")
	} else {
		level := PlayerInput("Level: ")
		
		if (level == "" || level == " " || level is not number) {
			return
		}
		
		hackerFinder := true
		hackerLevel := level
		hackerID := 0
		
		SendInfo("Spieler mit Level: " . csecond . level)
				
		SetTimer, HackerFinder, 1
	}
}
return

:?:/hacker2::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}	
	
	players := 0
	title := ""
	
	Loop {
		if (A_Index > 375) {
			SendInfo("Spieler mit Level 1 online: " . csecond . players)
			
			Sleep, 50
			SendInput, {ESC}
			return
		}
		
		name := getFullName(A_Index)
		hackerLevel := getPlayerScoreById(A_Index)
		
		if (name != "" && hackerLevel == 1) {
			SendChat("/check " . name)
			
			Sleep, 50
		
			while (title != name) {
				title := getDialogCaption()
				dialog := getDialogText()
			}
			
			if (RegExMatch(dialog, statsFormat, dialog_)) {
				SendClientMessage(prefix . title . " (ID " . A_Index . ") ist Level 1 mit " . dialog_4 . "/" . dialog_5 . " RP")
				players++
			}
		}
	}
}
return

:?:/arac::
{
	if (!admin) {
		SendError("Du bist kein Team-Mitglied.")
		return
	}
	
	racTime := PlayerInput("Zeit (Standard 30): ")
	
	if (racTime == "")
		racTime := 30
	
	if racTime is number
	{
		SetTimer, RespawnCarTimer, 1000
		
		respawnCarsRunning := true
	}
}
return

:?:/level::
{
	tmp_lvl := PlayerInput("Level: ")
	if (tmp_lvl == "" || tmp_lvl == " ") {
		return
	}
	
	if (tmp_lvl is not number) {
		SendError("Der angegebene Wert ist ungültig.")
		return
	}
	
	SendInfo(csecond . "Enter drücken:" . cwhite . " Globaler Chat | " . csecond . "ACM eintragen:" . cwhite . " Eigene Anzeige")
	
	tmp_chat := PlayerInput("Chat oder Ticket-ID: ")
	if (tmp_chat == "" || tmp_chat == " ") {
		tmp_chat := "l"
	}
	
	if (tmp_chat is number) {
		tmp_chat := "aw " . tmp_chat
	}
	
	tmp := (tmp_lvl - 1) * (tmp_lvl - 2) * 2 + (tmp_lvl - 1) * 8
	
	if (admin && tmp_chat != "acm") {
		if (tmp_chat == "acm") {
			SendInfo("|---------------------------------------------|")
		} else {
			SendChat("/" . tmp_chat . " |---------------------------------------------|")
		}
	}
	
	if (tmp_chat == "acm") {
		SendInfo("Informationen zum Level: " . csecond . formatNumber(tmp_lvl) . cwhite . ".")
	} else {
		SendChat("/" . tmp_chat . " Informationen zum Level " . formatNumber(tmp_lvl) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendInfo("Spielstunden mit Premium: " . csecond . formatNumber(round(tmp / 2, 0)) . cwhite . ".")
	} else {
		SendChat("/" . tmp_chat . " Spielstunden mit Premium: " . formatNumber(Round(tmp / 2, 0)) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendInfo("Spielstunden ohne Premium: " . csecond . formatNumber(tmp) . cwhite . ".")
	} else {
		SendChat("/" . tmp_chat . " Spielstunden ohne Premium: " . formatNumber(tmp) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendInfo("Benötigte Respektpunkte zum nächsten Level: " . csecond . formatNumber(8 + (tmp_level - 1) * 4) . cwhite . ".")
	} else {
		SendChat("/" . tmp_chat . " Benötigte Respektpunkte zum nächsten Level: " . formatNumber(8 + (tmp_lvl - 1) * 4) . ".")
	}
	
	if (admin && tmp_chat != "acm") {
		if (tmp_chat == "acm") {
			SendInfo("|---------------------------------------------|")
		} else {
			SendChat("/" . tmp_chat . " |---------------------------------------------|")
		}
	}
}
return

:?:/fraks::
:?:/fraktionen::
{
	sleep, 200
	
	fraktionen =
		(LTrim
			{FFBF00}Staatsfraktionen
			{CC0000}_______________________________________{FFFFFF}
			
			{ffff00}1 - Los Santos Police Department
			{ffff00}2 - Federal Bureau of Investigation ({CC0000}Entfernt{FFFFFF})
			{ffff00}3 - Las Venturas Police Department ({CC0000}Enfernt{FFFFFF})
			{ffff00}4 - Los Santos Medical Department
			{ffff00}19 - San Andreas Fire Department ({CC0000}Entfernt{FFFFFF})
			{ffff00}7 - Regierung
			{ffff00}9 - San News
			{ffff00}13 - Ordnungsamt
			{ffff00}14 - Transport GmbH
			
			{FFBF00}Gangs & Mafien
			{402EB4}_______________________________________{FFFFFF}
			
			5 - Russen Mafia ({CC0000}Entfernt{FFFFFF})
			6  - Yakuza
			8 - Hitman
			18 - Wheelman
			10 - Grove Street
			11 - Ballas
			12 - Los Chickos Malos
			15 - San Fierro Rifa
			16 - Los Santos Vagos
			17 - Triaden
		)
	
	ShowDialog(0, "Admin: Fraktion ID", fraktionen, "OK")
}
return

:?:/jobs::
{
	sleep, 200
	
	jobs =
		(LTrim
			{FFBF00}RPG-City - Job ID
				
			{CC0000}_____________________________________________________________{FFFFFF}
			
			1  - Detektiv - Help 29
			2  - Pizzaboy ({CC0000}Entfernt{FFFFFF})
			3  - Hochseefischer - Help 30
			4  - Drogendealer ({CC0000}kein Job mehr{FFFFFF}) - Help 31
			9  - Waffendealer ({CC0000}kein Job mehr{FFFFFF}) - Help 32
			14 - Müllmann - Help 34
			15 - Taxi ({CC0000}Entfernt{FFFFFF})
			16 - Trucker - Help 35
			18 - Zugfahrer - Help 33
			19 - Pilot - Help 36
			22 - KFZ-Mechaniker ({CC0000}Entfernt{FFFFFF}) - Help 37
			25 - Anwalt - Help 38
			30 - Busfahrer - Help 39
		)
	
	ShowDialog(0, "Admin: Job ID", jobs, "OK")
}
return

HackerFinder:
{
	score := getPlayerScoreById(hackerID)
	
	if (hackerID > 375) {
		if (hackerFinder == true) {
			hackerFinder := false
			
			SetTimer, HackerFinder, Off
			
			SendInfo("Der Hackerfinder wurde " . cred . "deaktiviert" . cwhite . ".")
			return
		}
	}
	
	if (score == hackerLevel) {
		if (admin) {
			SendChat("/tv " . hackerID)
			SendChat("/id " . hackerID)
			SendChat("/check " . hackerID)
			
			Sleep, 150
			
			title := getDialogCaption()
			dialog := getDialogText()
			
			SendInput, {ESC}
			
			if (RegExMatch(dialog, "", dialog_)) {
				SendClientMessage(prefix . title . " (ID " . hackerID . ") ist Level " . dialog_3 . " mit " . dialog_4 . "/" . dialog_5 . " RP")
			}
			
			Sleep, 5000
		} else {
			SendClientMessage(prefix . csecond . getFullname(hackerID) . cwhite . " (ID: " . csecond . hackerID . cwhite . ") - Level: " . csecond getPlayerScoreById(hackerID))
		}
	}
	
	hackerID++
}
return
/*
UpdateStatus:
{
	Loop % trashcan.MaxIndex() {
		if (trashcan[A_Index][5] > 0) {
			trashcan[A_Index][5]--
		}
	}
}
return

UpdateRestTimer:
{
	UpdateRest()
}
return

DoubleClickTimer:
{
	doubleClick := false
	SetTimer, DoubleClickTimer, Off
}
return

SpamProtection:
{
	spamProtection := false
	SetTimer, SpamProtection, Off
}
return
*/
SyncTimer:
{	
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}	
	
	if (autoUse) {
		SendInfo("Das Synchroniseren von Fischen, Paket, Drogen und Lagerfeuer hat begonnen!")
		SendInfo("Drücke bitte nach den nächsten 2 Sekunden keine Keys und schreibe nichts im Chat!")
		
		Sleep, 2000
		
		checkCook()
		checkFish()
		
		Sleep, 1000
		
		getItems()
		
		SendClientMessage(prefix . "Das Synchronisieren ist " . cgreen . "abgeschlossen" . cwhite . ".")
		SetTimer, SyncTimer, 600000
	} else {
		SetTimer, SyncTimer, off
	}
}
return

TempoTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (!tempomat || tempo <= 0) {
		SetTimer, TempoTimer, off 
		return
	} else {
		if (isBlocked()) {
			return
		}
	
		if (IsPlayerInAnyVehicle() && IsPlayerDriver()) {
			currentSpeed := getVehicleSpeed()
			
			if (currentSpeed < tempo) {
				SendInput, {W down}
			} else {
				SendInput, {W up}
			}
		}
	}
}
return

ArrestTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if ((IsPlayerInRangeOfPoint(2341.6477, -2028.5807, 13.5331, 4) || IsPlayerInRangeOfPoint(2322.9871, -1995.6251, 21.1276, 4)) && (getUserName() == "jacob.tremblay" || getUserName() == "Jaden." || getUserName() == "Jannek_Zockt" || getUserName() == "Ness.")) {
		
		indexRemove := -1
		
		for index, arrestName in arrestList {
			suspectID := getPlayerIdByName(getFullName(arrestName), true)
			
			if (suspectID != -1) {
				SendChat("/arrest " . arrestName)
				Sleep, 200

				if (InStr(readChatLine(0) . readChatLine(1) . readChatLine(2), "Du bist nicht in der Nähe eines Gefängnisses.")) {
					SendChat("/arrest " . arrestName)
				}
				
				arrestList.RemoveAt(index)
			}
		}
	}
}
return

ResetChatBlock:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (BlockChat == 1) {
		BlockChat := 0
	}
	
	SetTimer, ResetChatBlock, off
}
return

SecondTimer:
{
	if (!WinExist("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	IniRead, fishcooldown, ini/Settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, ini/Settings.ini, Cooldown, pakcooldown, 0
	IniRead, commitmentUnix, ini/Settings.ini, UnixTime, commitmentUnix, 0
	IniRead, commitmentTime, ini/Settings.ini, UnixTime, commitmentTime, 0
		
	if (fishcooldown > 0) {
		fishcooldown --
		
		if (fishcooldown == 600 || fishcooldown == 300 || fishcooldown == 120 || fishcooldown == 60) {
			SendInfo("Du kannst in " . cSecond . formatTime(fishcooldown) . cwhite . " wieder angeln.")
		} else if (fishcooldown == 0) {
			if (!WinActive("GTA:SA:MP")) {
				MsgBox, 64, Fischen, Du kannst nun wieder fischen
			}
		
			SoundBeep
			SendInfo("Du kannst nun wieder angeln.")
		}		
		
		iniWrite, %fishcooldown%, ini/Settings.ini, Cooldown, fishcooldown
	}
	
	if (pakcooldown > 0) {
		pakcooldown --
		
		if (pakcooldown == 300 || pakcooldown == 120 || pakcooldown == 60) {
			SendInfo("Du kannst in " . cSecond . formatTime(pakcooldown) . cwhite . " wieder ein Erste-Hilfe-Paket nutzen.")
		} else if (pakcooldown == 0) {
			SoundBeep 
			SendInfo("Du kannst nun wieder ein Erste-Hilfe-Paket nutzen.")
		}
		
		iniWrite, %pakcooldown%, ini/Settings.ini, Cooldown, pakcooldown
	}
	
	if (healcooldown > 0) {
		healcooldown --
		
		if (healcooldown == 30 || healcooldown == 10) {
			SendInfo("Du kannst dich in " . cSecond . formatTime(healcooldown) . cwhite . " wieder heilen.")
		} else if (healcooldown == 0) {
			SoundBeep
			SendInfo("Du kannst dich nun wieder heilen.")
		}
	}
	
	if (drugcooldown > 0) {
		drugcooldown --
		
		if (drugcooldown == 15 || drugcooldown == 5) {
			SendInfo("Du kannst in " . cSecond . formatTime(drugcooldown) . cwhite . " wieder Drogen konsumieren.")
		} else if (drugcooldown == 0) {
			SoundBeep 
			SendInfo("Du kannst nun wieder Drogen konsumieren.")
		}
	}

	if (admincooldown > 0) {
		admincooldown -- 
		
		if (admincooldown == 15 || admincooldown == 5) {
			SendInfo("Du kannst in " . cSecond . formatTime(admincooldown) . cWhite . " wieder im Admin-Chat schreiben.")
		} else if (admincooldown == 0) {
			SendInfo("Du kannst nun wieder im Admin-Chat schreiben.")
		}
	}
	
	if (ooccooldown > 0) {
		ooccooldown -- 
		
		if (ooccooldown == 0) {
			SendInfo("Du kannst nun wieder im OOC-Chat schreiben.")
		}
	}	
	
	if (findcooldown > 0) {
		findcooldown -- 
	}		
	
	if (commitmentTime == 1) {
		restTime := commitmentUnix - getUnixTimestamp(A_Now)
		
		if (restTime == 300 || restTime == 240 || restTime == 180 || restTime == 120 || restTime == 60) {
			SendChat("/" . commitmentChat . " Einsatz, Ihr habt noch " . formatTime(restTime) . " Zeit zum Aufstellen (Treffpunkt: " . commitmentLocation . ")!")
		} else if (restTime <= 0) {
			commitmentUnix := 0
			commitmentTime := 0
			
			SendChat("/" . commitmentChat . " Einsatz, Ihr solltet JETZT alle beim Einsatz sein!")
		}
		
		IniWrite, %commitmentTime%, ini/Settings.ini, UnixTime, commitmentTime
		IniWrite, %commitmentUnix%, ini/Settings.ini, UnixTime, commitmentUnix	
	}
		
	for index, oubtbreak in outbreaks {
		if (oubtbreak["countdown"] > 0) {
			oubtbreak["countdown"] --
			
			if (oubtbreak["countdown"] == 0) {
				outbreaks.RemoveAt(index)
			}			
		}
	}

	for index, bankrob in bankrobs {
		if (bankrob["countdown"] > 0) {
			bankrob["countdown"] --
			
			if (bankrob["countdown"] == 0) {
				bankrobs.RemoveAt(index)
			}			
		}
	}
	
	for index, store in storerobs {
		if (store["countdown"] > 0) {
			store["countdown"] --
			
			if (store["countdown"] == 0 || getPlayerIdByName(store["name"]) == -1) {
				storerobs.RemoveAt(index)
			}			
		}
	}

	for index, backup in backups {
		if (backup["countdown"] > 0) {
			backup["countdown"] --
			
			if (backup["countdown"] == 0 || getPlayerIdByName(backup["name"]) == -1) {
				backups.RemoveAt(index)
			}			
		}
	}
	
	
	for index, partner_ in partners {
		if (!getFullName(partner_)) {
			SendChat("/f " . partner_ . " wurde als Dienstpartner ausgetragen (offline).")
			partners.RemoveAt(index)
		}
	}	
	
	if (oldLocalTime > 0) {
		oldLocalTime --
		
		if (oldLocalTime == 0) {
			oldLocal := ""
		}
	}
	
	if (oldFriskTime > 0) {
		oldFriskTime --
		
		if (oldFriskTime == 0) {
			oldFrisk := ""
		}
	}	
	
	if (!fillTimeout_) {
		fillTimeout ++
	
		if (fillTimeout >= 15) {
			fillTimeout_ := true
		}
	}
	
	if (!canisterTimeout_) {
		canisterTimeout ++
		
		if (canisterTimeout >= 15) {
			canisterTimeout_ := true
		}
	}
	
	if (!mautTimeout_) {
		mautTimeout ++
		
		if (mautTimeout >= 15) {
			mautTimeout_ := true
		}
	}
	
	if (!healTimeout_) {
		healTimeout ++
		
		if (healTimeout >= 15) {
			healTimeout_ := true
		}
	}
	
	if (!cookTimeout_) {
		cookTimeout ++
		
		if (cookTimeout >= 15) {
			cookTimeout_ := true
		}
	}
	
	if (!equipTimeout_) {
		equipTimeout ++
		
		if (equipTimeout >= 15) {
			equipTimeout_ := true
		}
	}
	
	if (!jailgateTimeout_) {
		jailgateTimeout ++
		
		if (jailgateTimeout >= 5) {
			jailgateTimeout_ := true 
		}
	}
	
	if (!gateTimeout_) {
		gateTimeout ++
		
		if (gateTimeout >= 5) {
			gateTimeout_ := true
		}
	}
	
	if (!fishTimeout_) {
		fishTimeout ++
		
		if (fishTimeout >= 15) {
			fishTimeout_ := true
		}
	}
	
	if (!localTimeout_) {
		localTimeout ++
		
		if (localTimeout >= 15) {
			localTimeout_ := true
		}
	}
	
	if (!garbageTimeout_) {
		garbageTimeout ++
		
		if (garbageTimeout >= 6) {
			garbageTimeout_ := true
		}
	}
	
	if (!fishSellTimeout_) {
		fishSellTimeout ++
		
		if (fishSellTimeout >= 15) {
			fishSellTimeout_ := true
		}
	}
}
return

TaskCheckTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (taskInfo) {
		tasksResult := UrlDownloadToVar(baseURL . "api/tasks?username=" . username . "&password=" . password . "&action=get")
		
		if (tasksResult == "ERROR_BAD_LINK") {
		} else if (tasksResult == "ERROR_USER_NOT_FOUND") {
		} else if (tasksResult == "ERROR_WRONG_PASSWORD") {
		} else if (tasksResult == "ERROR_ACCESS_DENIED") {
		} else if (tasksResult == "ERROR_NO_SUCH_ACTION") {
		} else if (tasksResult == "ERROR_MYSQL_QUERY") {
		} else if (tasksResult == "ERROR_NO_TASKS") {
		} else if (tasksResult == "ERROR_CONNECTION") {
		} else {
			tasksLoaded := JSON.Load(tasksResult)
			tasksToRemove := []
			
			for newIndex, newEntry in tasksLoaded {
				contains := false
			
				for index, entry in tasks {
					if (entry["id"] == newEntry["id"]) {
						contains := true
					}
				}
				
				if (!contains) {
					tasks.Push(newEntry)
				}
			}
			
			for index, entry in tasks {
				contains := false
			
				for newIndex, newEntry in tasksLoaded {
					if (entry["id"] == newEntry["id"]) {
						contains := true
					}
				}
				
				if (!contains) {
					tasksToRemove.Push(entry["id"])
				}
			}
			
			tasksRemoved := 0
			
			for i, id in tasksToRemove {
				tasksRemoved += removeTask(id)
			}
		}
		
		for index, task in tasks {
			if (task["online"]) {
				taskSubjectID := getPlayerIdByName(task["subject"])
				if (taskSubjectID == -1) {
					task["online"] := false
				}
			} else {
				taskSubjectID := getPlayerIdByName(task["subject"])
				
				if (taskSubjectID != -1) {
					SendInfo("Spieler mit Task ist online: " . csecond . task["subject"] . cwhite . " (ID: " . csecond . taskSubjectID . cwhite . ")")
					SendInfo("Task (ID " . csecond . "" . task["id"] . cwhite . "): " . csecond . task["task"])
				}
			
				task["online"] := true
			}
		}
	} else {
		SetTimer, TaskCheckTimer, off
	}
}
return

/* #BAUM
UpdateComplexTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !updateTextLabelData()) {
		return
	}
	
	if (!updateTextLabelData()) {
		return
	}	

	coords := getCoordinates()
	
	data := []
	data["name"] := getUsername()
	data["complexes"] := []
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {	
			if (RegExMatch(o.TEXT, "^Dieses Haus vermietet Zimmer\.\n\nBesitzer: (\S+)\nMiet-Preis: (\d+)\$\nBeschreibung: (.+)\nTippe \/renthouse\.$", label_)) { ; Mietbares Haus
				complexe := []
				complexe["type"] := "house"
				complexe["name"] := label_1
				complexe["description"] := label_3
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS
				data["complexes"].Push(complexe)
			} else if (RegExMatch(o.TEXT, "^(.+)\nDrücke Enter\.$", label_)) { ; Fraktionsbase
				complexe["type"] := "faction"
				complexe["name"] := "nobody"
				complexe["description"] := "none"
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS		
				data["complexes"].Push(complexe)
			} else if (RegExMatch(o.TEXT, "^Dieses Haus gehört (\S+)\.\n\nPreis: (.*)\nBeschreibung: (.+)\n\n(.+)$", label_)) { ; Crewhaus (unmietbar)
				complexe["type"] := "house"
				complexe["name"] := label_1
				complexe["description"] := label_3
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS
				data["complexes"].Push(complexe)
			} else if (RegExMatch(o.TEXT, "^Dieses Haus vermietet Zimmer\.\n\nBesitzer: (\S+)\nMiet-Preis: (.*)\nBeschreibung: (.+)\nTippe \/renthouse\.\n\n(.+)$", label_)) {
				complexe["type"] := "house"
				complexe["name"] := label_1
				complexe["description"] := label_3
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS	
				data["complexes"].Push(complexe)
			} else if (RegExMatch(o.TEXT, "^Dieses Haus gehört (\S+)\.\n\nPreis: (.*)\nBeschreibung: (.+)$", label_)) { ; Unmietbares Haus
				complexe["type"] := "house"
				complexe["name"] := label_1
				complexe["description"] := label_3
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS	
				complexe["positive"] := true
				data["complexes"].Push(complexes)
			} else if (RegExMatch(o.TEXT, "^Dieses Haus steht zum Verkauf\.\n\nPreis: (.*)\nBeschreibung: (.+)\nTippe \/buyhouse\.$", label_)) { ; Haus Verkauft
				complexe["type"] := "house"
				complexe["name"] := "nobody"
				complexe["description"] := label_2
				complexe["pos_x"] := o.XPOS
				complexe["pos_y"] := o.YPOS
				complexe["pos_z"] := o.ZPOS			
				data["complexes"].Push(complexe)
			}	

		}
	}
	
	if (data["complexes"].Length() > 0) {
		jsonData := JSON.Dump(data)
		
		result := URLDownloadToVar(baseURL . "updateComplexes.php?data=" . jsonData)
		Sleep, 10000
	}
}
return
*/

CloseZollTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (closeZoll != "") {
		if (closeZoll > 0 && closeZoll < 14) {
			SendInfo("Möchtest du Zoll " . csecond . closeZoll . cwhite . " schließen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
				
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				SendChat("/zollcontrol " . closeZoll . " zu")
			}
		}
	}
	
	SetTimer, CloseZollTimer, off
}
return

OpenZollTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (openZoll != "") {
		if (openZoll > 0 && openZoll < 14) {
			SendInfo("Möchtest du Zoll " . csecond . openZoll . cwhite . " öffnen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
				
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				SendChat("/zollcontrol " . openZoll . " auf")
			}
		}
	}
	
	SetTimer, OpenZollTimer, off
}
return

RefillTimer: 
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	SendInfo("Möchtest du einen Kanister nutzen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")

	KeyWait, X, D, T10
	
	if (!ErrorLevel && !isBlocked()) {
		SendChat("/fillcar")
	}	
	
	SetTimer, RefillTimer, off
}
return

RequestTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (requestName != "") {		
		if (RegExMatch(getLabelText(), "\[(\d+)\] (\S+)\nWantedlevel: (\d+)\nGrund: (.+)", label_)) {
			if (requestName == label_2) {
				if (label_3 > 4) {
					if (oldRequest != requestName) {
						oldRequest := requestName

						SendChat("/l Tut mir leid " . requestName . ", jedoch sind nur Tickets bis zu 4 Wanteds, und nicht bis " . label_3 . " möglich.")
					}
				} else {
					SendInfo("Möchtest du " . csecond . requestName . cwhite . " ein Ticket geben? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
				
					KeyWait, X, D, T10
					
					if (!ErrorLevel && !isBlocked()) {
						wantedCount := label_3
						playerForTicket := label_2
					
						SendChat("/ticket " . playerForTicket . " " . (wantedCount * 750) " Wanted-Ticket (" . wantedCount . " Wanted" . (wantedCount == 1 ? "" : "s") . ")")
					}
				}
			}
		}
	}
	
	SetTimer, RequestTimer, off
}
return

ChatTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (chatLogFile.Length < chatLogLines.Length()) {
		chatLogFile := FileOpen(A_MyDocuments . "\GTA San Andreas User Files\SAMP\chatlog.txt", "r")
		chatLogLines := []
	}
	
	while (!chatLogFile.AtEOF) {
		line := chatLogFile.ReadLine()
		line := RegExReplace(line, "U)^\[\d{2}:\d{2}:\d{2}\] ")
		line := StrReplace(line, "`r`n")
		line := StrReplace(line, "`r")
		line := RegExReplace(line, "{\S{6}}", "")
		
		if (line != "") {
			chatLogLines.Push(line)
			
			if (!firstChatLogRun) {
				handleChatMessage(line, chatLogLines.Length(), chatLogLines)
			}
		}
	}
	
	firstChatLogRun := false
}
return

handleChatMessage(message, index, arr) {
	global
	
	if (RegExMatch(message, "^Hurensohn$") || RegExMatch(message, "^Huso$")) {
		if (getUserName() != "Jens") {
			IniRead, huso, ini/stats.ini, Stats, huso, 0
			huso ++
			IniWrite, % huso, ini/stats.ini, Stats, huso
			
			SendInfo("Huso-Counter: " . cSecond . formatNumber(huso))
		}
	} else if (RegExMatch(message, "^Leerfahrt$")) {
		start := -1
		busLine := -1
		
		SendInfo("Du hast deine Linie abgebrochen.")	
	} else if (RegExMatch(message, "^Nächste Haltestelle: (.+)$", chat_)) {
		if (chat_1 == "Busbahnhof Süd" || chat_1 == "Busbahnhof Ost" || chat_1 == "San Fierro Hauptbahnhof" || chat_1 == "Las Venturas Busbahnhof" || chat_1 == "Foster Valley FZ A" || chat_1 == "Foster Valley FZ B") {
			if (start == -1) {
				Sleep, 1000
				
				start := getUnixTimestamp(A_Now)
				tempLine := findLinie()
				
				if (tempLine != 0) {
					busLine := tempLine
					
					SendInfo("Du startest Linie " . csecond . busLine . cwhite . ".")
				} else {
					busLine := -1
					
					SendInfo("Deine Linie konnte nicht korrekt erkannt werden, sie wird vorerst ignoriert.")
				}
			}
		} else {
			if (start != -1 && busLine == -1) {
				tempLine := findLinie()
				
				if (tempLine != 0) {
					busLine := tempLine
					
					SendInfo("Deine Linie wurde soeben gesetzt: Linie " . csecond . busLine)
				}
			}
		}	
	} else if (RegExMatch(message, "^\* Du erhälst am nächsten Payday (.*)\$ gutgeschrieben\. Erhaltene EXP: (\d+)$", message_)) {
		if (start != -1) {
			IniRead, busRounds, ini/Stats.ini, bus, busRounds, 0
			IniRead, busMoney, ini/Stats.ini, bus, busMoney, 0
			
			busRounds ++
			busMoney += numberFormat(message_1)
			
			roundMoney := numberFormat(message_1)
			roundMoney := floor(roundMoney * taxes)
			paydayMoney += roundMoney
			IniWrite, %paydayMoney%, ini/Stats.ini, stats, paydayMoney
			
			IniWrite, %busRounds%, ini/Stats.ini, bus, busRounds
			IniWrite, %busMoney%, ini/Stats.ini, bus, busMoney
			
			end := getUnixTimestamp(A_Now)
			diff := (end - start)
			
			SendInfo("Du hast Linie " . busLine . " für $" . csecond . formatNumber(message_1) . cwhite . " beendet und " . csecond . message_2 . cwhite . " EXP erhalten. Zeit: " . csecond . formatTime(diff))
			SendInfo("Du bist bereits " . csecond . formatNumber(busRounds) . cwhite . " Runden gefahren und hast $" . csecond . formatNumber(busMoney) . cwhite . " verdient.")

			Sleep, 100
			SendChat("/j Ich habe Linie " . busLine . " für " . formatNumber(message_1) . "$ beendet und " . message_2 . " EXP erhalten. Zeit: " . formatTime(diff))
			
			start := -1
			
			if (busLine == 4) {
				busLine := 5
			} else if (busLine == 5) {
				busLine := 4
			} else if (busLine == 8) {
				busLine := 9
			} else if (busLine == 9) {
				busLine := 8
			} else if (busLine == 13) {
				busLine := 14
			} else if (busLine == 14) {
				busLine := 13
			} else if (busLine == 16) {
				busLine := 17
			} else if (busLine == 17) {
				busLine := 16
			} else if (busLine == 19) {
				busLine := 20
			} else if (busLine == 20) {
				busLine := 19
			}
			
			selectLine(busLine)
		}
	} else if (RegExMatch(message, "^Der Leader hat das Upgrade Arrest-Limit aktiviert \((.*)\)\.", message_)) {
		if (RegExMatch(message_1, "^noch (\d+) Tage, (\d+) Stunden und (\d+) Minuten$", arrest_)) {
			daySeconds := (arrest_1 * 86400)
			hourSeconds := (arrest_2 * 3600)
			minuteSeconds := (arrest_3 * 60)
			allSeconds := (daySeconds + hourSeconds + minuteSeconds)
			
			arrestLimitUnix := getUnixTimestamp(A_Now) + allSeconds
			IniWrite, %arrestLimitUnix%, ini/Settings.ini, UnixTime, arrestLimitUnix
		
			SendChat("/f HQ: Guten Tag Leute! Arrest-Limit: " . allSeconds . " Sekunden!")
			; SendInfo("Arrest-Limit-Daten wurden angepasst.")
		} else if (RegExMatch(message_1, "^noch (\d+) Stunden und (\d+) Minuten$", msg_)) {
			hourSeconds := (msg_1 * 3600)
			minuteSeconds := (msg_2 * 60)
			allSeconds := (hourSeconds + minuteSeconds)
			
			
			arrestLimitUnix := getUnixTimestamp(A_Now) + allSeconds
			IniWrite, %arrestLimitUnix%, ini/Settings.ini, UnixTime, arrestLimitUnix
			
			SendChat("/f HQ: Guten Tag Leute! Arrest-Limit: " . allSeconds . " Sekunden!")
			; SendInfo("Arrest-Limit-Daten wurden angepasst.")
		} else if (RegExMatch(message_1, "^noch (\d+) Minuten$", msg_)) {
			minuteSeconds := (msg_1 * 60)
			allSeconds := (minuteSeconds)
			
			arrestLimitUnix := getUnixTimestamp(A_Now) + allSeconds
			IniWrite, %arrestLimitUnix%, ini/Settings.ini, UnixTime, arrestLimitUnix
			
			SendChat("/f HQ: Guten Tag! Arrest-Limit: " . allSeconds . " Sekunden!")
			; SendInfo("Arrest-Limit-Daten wurden angepasst.")
		}
	} else if (RegExMatch(message, "^\*\*\(\( (.+) (\S+): HQ: Guten Tag! Arrest-Limit: (\d+) Sekunden! \)\)\*\*$", message_)) {
		if (message_2 != getUserName()) {
			arrestLimitUnix := getUnixTimestamp(A_Now) + message_3
			IniWrite, %arrestLimitUnix%, ini/Settings.ini, UnixTime, arrestLimitUnix
			
			; SendInfo("Arrest-Limit-Daten wurden angepasst.")
		}
	} else if (RegExMatch(message, "^\* Spieler \[(\d+)\](\S+): (.*)$", message_)) {
		if (getId() == message_1 && message_2 == getUserName() && !admin) {
			admincooldown := 30
		}
	} else if (RegExMatch(message, "^Der Spieler befindet sich in (.*)$", message_)) {
		findcooldown := 5
	} else if (RegExMatch(message, "^\(\( (\S+): (.+) \)\)$", message_)) {
		if (message_1 == getUserName()) {
			ooccooldown := 5
		}
	} else if (RegExMatch(message, "^Es befindet sich zu wenig Kraftstoff im Fahrzeug, um den Motor zu starten\.$", message_)) {
		SetTimer, RefillTimer, 1
	} else if (RegExMatch(message, "^** Das funktioniert hier nicht.$", message_)) {
		if (!garbageTimeout_) {
			garbageTimeout_ := true
		}
	} else if (RegExMatch(message, "^Paintball: (\S+) hat die Arena betreten\.$", message_)) {
		if (message_1 == getUserName()) {
			isPaintball := true 
			SendInfo("Der Paintball-Modus wurde " . cgreen . "angeschaltet" . cwhite . ".")
		}
	} else if (RegExMatch(message, "^Du hast bereits einen Spritkanister !$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^\* (\S+) nimmt seinen Kanister und füllt das Fahrzeug auf\.$", message_)) {
		if (message_1 == getUserName()) {
			getItems()
		}
	} else if (RegExMatch(message, "^Du hast ein Kanister gekauft und kannst ihn mit \/fillcar verwenden\. Kosten: \$(\d+)$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast eine infizierte Spritze gefunden und dich gestochen\.$", message_)) {
		gotPoisened := true
	} else if (RegExMatch(message, "^Du hast ein Lagerfeuer gesetzt, dieses brennt ca\. 40 Sekunden\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast dir ein Lagerfeuer gekauft\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast ein Erstehilfe-Paket erworben \(-(\d+)\$\)\.$")) {
		getItems()
	} else if (RegExMatch(message, "^Du besitzt kein Erste-Hilfe-Paket\.$", message_)) {
		getItems()
 	} else if (RegExMatch(message, "^Du hast ein Erstehilfe-Paket erworben \(-(.*)$\).$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast ein Erste-Hilfe-Paket im Müll gefunden\.$", message_)) {
		getItems()
 	} else if (RegExMatch(message, "\* Du hast für \$(.*) ein Erste-Hilfe-Paket von (\S+) gekauft\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^\* " . getUserName() . " benutzt ein Erste-Hilfe-Paket und versorgt die Wunden\.$", message_)) {
		IniWrite, 600, ini/Settings.ini, Cooldown, pakcooldown
	
		getItems()
	} else if (RegExMatch(message, "^\* " . getUserName() . " hat Drogen konsumiert.$", message_)) {
		getItems()
		drugcooldown := 30
	} else if (RegExMatch(message, "^(.*)g Drogen aus den Safe geholt\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^(.*)g wurden in den Safe gelegt\.$", message_)) {
		getItems()
	} else if (RegExMatch(messfage, "^\* (\S+) hat deine (.*)g für (.*)\$ gekauft\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^\* Du hast (.*)g für (.*)$ von (\S+) gekauft\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^\[ AIRDROP \] (\S+) hat den Airdrop abgegeben und (.*)\.$", message_)) {
		if (message_1 == getUserName()) {
			getItems()	
		}
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen ausgelagert\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen eingelagert\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen für (.*)\$ erworben\.$", message_)) {
		getItems()
	} else if (RegExMatch(message, "^Du bist nun im SWAT-Dienst als Agent (\d+)\.$", message_)) {
		IniRead, mobilePhone, ini/Settings.ini, items, mobilePhone, 0	
		if (mobilePhone) {
			agentTog := true
		}
		
		IniWrite, 0, ini/Settings.ini, items, mobilePhone
	
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}	
		
		agentID := message_1
		SendChat("/f Agent " . agentID . " meldet sich zum Dienst!")
	} else if (RegExMatch(message, "^Du bist nicht mehr im SWAT-Dienst$", message_)) {
		if (agentTog) {
			agentTog := false
		}
		
		IniWrite, 1, ini/Settings.ini, items, mobilePhone
	
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}	

		SendChat("/f Agent " . agentID . " meldet sich vom Dienst ab!")
		agentID := -1
	} else if (RegExMatch(message, "\*\* Diese Mülltonne wurde bereits durchsucht. Versuche es erneut in (\d+) Minuten.$", message_)) {
		/*
		SetTrashTime(line)
		DisableCheckpoint()
		*/
	} else if (RegExMatch(message, "^Du beginnst in einer Mülltonne rumzuschnüffeln\.$", message_)) {
		trashs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trash&value=1")
		iniWrite, %trashs%, ini/Stats.ini, Mülltonnen, trashs
		
		SendInfo("Du hast bereits " . cSecond . formatNumber(trashs) . cwhite . " Mülltonnen durchwühlt.")
	} else if (RegExMatch(message, "^Du (.*) in der Mülltonne gefunden.$", message_)) {
		if (RegExMatch(message_1, "^hast nichts$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if (IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 15 * 60
					SendToRest(trashcan[A_Index][6], 15)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "15 Minuten" . cWhite . " gesetzt!")
				}
			}		
			*/			
			
			nothing := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashNothing&value=1")
			iniWrite, %nothing%, ini/Stats.ini, Mülltonnen, nothing
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(nothing) . cwhite . " nichts in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast ein Lagerfeuer$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/
			
			campfire:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashCampfire&value=1")
			iniWrite, %campfire%, ini/Stats.ini, Mülltonnen, campfire
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(campfire) . cwhite . " Lagerfeuer in Mülltonnen gefunden.")
			getItems()
		} else if (RegExMatch(message_1, "^hast (.*)\$$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/
			
			money := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashMoney&value=" . numberFormat(msg_1))
			iniWrite, %money%, ini/Stats.ini, Mülltonnen, money
			
			SendInfo("Du hast bereits $" . cSecond . formatNumber(money) . cwhite . " in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast (\d+) Stunden (\S+)$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/			
		
			if (RegExMatch(msg_2, "VIP")) {
				vip := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashVIP&value=" . numberFormat(msg_1))
				iniWrite, %vip%, ini/Stats.ini, Mülltonnen, vip
				SendInfo("Du hast bereits " . cSecond . formatNumber(vip) . cwhite . " Stunden VIP in Mülltonnen gefunden.")
			} else if (RegExMatch(msg_2, "Premium")) {
				prem := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashPremium&value=" . numberFormat(msg_1))
				iniWrite, %prem%, ini/Stats.ini, Mülltonnen, prem
				SendInfo("Du hast bereits " . cSecond . formatNumber(prem) . cwhite . " Stunden Premium in Mülltonnen gefunden.")
			}
		} else if (RegExMatch(message_1, "^hast (\d+) Respektpunkte$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/			
		
			respect:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashRespect&value=" . numberFormat(msg_1))
			iniWrite, %respect%, ini/Stats.ini, Mülltonnen, respect
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(respect) . cwhite . " Respektpunkte in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast (\d+)g Marihuana$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/			
		
			drugs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashDrugs&value=" . numberFormat(msg_1))
			iniWrite, %drugs%, ini/Stats.ini, Mülltonnen, drugs
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(drugs) . cwhite . "g Drogen in Mülltonnen gefunden.")
			
			getItems()
		} else if (RegExMatch(message_1, "hast (\d+) Materialien$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/			
		
			mats := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashMats&value=" . numberFormat(msg_1))
			iniWrite, %mats%, ini/Stats.ini, Mülltonnen, mats
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(mats) . cwhite . " Materialien in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast eine Schlagwaffe \((.*)\)$", msg_)) {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/			
		
			weaps := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trashWeapon&value=1")
			iniWrite, %weaps%, ini/Stats.ini, Mülltonnen, weaps
			
			SendInfo("Du hast bereits " . cSecond . formatNumber(weaps) . cwhite . " Waffen in Mülltonnen gefunden.")
		} else {
			/*
			Loop % trashcan.MaxIndex() {
				if(IsPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
					trashcan[A_Index][5] := 30 * 60
					SendToRest(trashcan[A_Index][6], 30)
					SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "30 Minuten" . cWhite . " gesetzt.")
				}
			}				
			*/				
		}
	} else if (RegExMatch(message, "^Der Spieler befindet sich in Gebäudekomplex (.*)$", message_)) {
		if (getOldKomplex != message_1) {
			getOldKomplex := message_1
			
			gk(message_1)
		}
	} else if (RegExMatch(message, "^\* (\S+) hat (\S+) Handschellen angelegt\.$", message_)) {
		if (RegExMatch(message_1, "^Agent (\d+)$", agent_)) {
			agent_ID := agent_1
		}
		
		if (message_1 == getUserName() || agent_ID == agentID) {
			for index, grabName in grabList {
				if (grabName == message_2) {
					isArrested := true
				}
			}
			
			for index, arrestName in arrestList {
				if (arrestName == message_2) {
					isCuffed := true
				}
			}		
		
			if (isArrested == false) {
				arrestList.Push(message_2)			
			}
			
			if (isCuffed == false) {
				grabList.Push(message_2)
			}
			
			isArrested := false 
			isCuffed := false
		} else {
			for index, entry in partners {
				if (message_1 == entry) {
					for index, grabName in grabList {
						if (grabName == message_2) {
							isArrested := true
						}
					}
					
					for index, arrestName in arrestList {
						if (arrestName == message_2) {
							isCuffed := true
						}
					}		
				
					if (isArrested == false) {
						arrestList.Push(message_2)			
					}
					
					if (isCuffed == false) {
						grabList.Push(message_2)
					}
					
					isArrested := false 
					isCuffed := false	
				}
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+)'s Handschellen entfernt\.$", message_)) {
		for index, grabName in grabList {
			if (grabName == message_1) {
				grabList.RemoveAt(index)
			}
		}
	} else if (RegExMatch(message, "^\* (\S+) hat seine Kevlarweste (.*)$", message_)) {
		if (getUserName() == message_1) {			
			if (InStr(message, "abgelegt")) {
				isZivil := 1
				
				SendInfo("Du bist nun Zivil.")
			} else if (RegExMatch(message, "angelegt")) {
				isZivil := 0
			
				SendInfo("Du bist nun im Dienst.")
			}
		}
	} else if (RegExMatch(message, "^Du bist nun wieder im Dienst!$", message_)) {
		isZivil := 1
	} else if (RegExMatch(message, "^Du bist nun nicht mehr im Dienst!$", message_)) {
		isZivil := 0
	} else if (RegExMatch(message, "^(\S+) sagt: (.+)", message_)) {
		if (!tv) {
			if (message_1 != getUserName()) {	
				if (InStr(message_2, "ticket") || InStr(message_2, "tkt") || InStr(message_2, "tigget")) {
					requestName := message_1
					
					SetTimer, RequestTimer, 1
				}
					
				if (InStr(message_2, "sucht") && InStr(message_2, "member") || InStr(message_2, "invite") && !InStr(message_2, "uninvite")) {
					if (oldInviteAsk != message_1) {
						oldInviteAsk := message_1
						
						SendChat("/l Nein.")
					}
				}
			}
		}
	} else if (RegExMatch(message, "^\*\* (.*) \*\*$", message_)) {	
		if (RegExMatch(message_1, "^(.*) (\S+): Der Spieler (\S+) \(ID: (\d+)\) (.*)\.$", dchat_)) {
			if (dchat_2 != getUserName() && autoExecute) {
				wantedIA := dchat_3
				wantedContracter := dchat_2
				wantedIAReason := dchat_5
		
				SetTimer, WantedIATimer, 1
			}
		} else if (RegExMatch(message_1, "^(.*) (\S+): Ich konnte bei dem Spieler (\S+) \(ID: (\d+)\) (\S+) festgellen\.$", dchat_)) {
			if (dchat_2 != getUserName() && autoExecute) {
				wantedIA := dchat_3
				wantedContracter := dchat_2
				wantedIAReason := dchat_5
		
				SetTimer, WantedIATimer, 1
			}	
		} else if (RegExMatch(message_1, "^(.+) (\S+): HQ: Bitte Zollstation (\S+) schließen!$", dchat_)) {
			if (dchat_2 != getUserName()) {
				if (rank > 4) {
					closeZoll := dchat_3
					
					SetTimer, CloseZollTimer, 1
				}
			}
		} else if (RegExMatch(message_1, "^(.+) (\S+): HQ: Bitte Zollstation (\S+) öffnen!$", dchat_)) {
			if (dchat_2 != getUserName()) {		
				if (rank > 4) {
					openZoll := dchat_3
					
					SetTimer, OpenZollTimer, 1
				}
			}
		} else if (RegExMatch(message_1, "^(.+) (\S+): HQ: Verstärkung wird NICHT mehr benötigt!$", dchat_)) {
			if (dchat_2 != getUserName()) {
				indexRemove := -1
				
				for index, entry in backups {
					if (entry["name"] == dchat_2) {
						indexRemove := index
					}
				}
				
				if (indexRemove != -1) {
					backups.RemoveAt(indexRemove)
				}
				
				if (backupSound) {
					SoundPlay, Nonexistent.avi
				}	
			}
		} else if (RegExMatch(message_3, "^(.+) (\S+): HQ: (\S+) hat mich in (.+) getötet, Backup NICHT mehr nötig!$", dchat_)) {
			if (dchat_2 != getUserName()) {
				indexRemove := -1
				
				for index, entry in backups {
					if (entry["name"] == dchat_2) {
						indexRemove := index
					}
				}
				
				if (indexRemove != -1) {
					backups.RemoveAt(indexRemove)
				}
				
				if (backupSound) {
					SoundPlay, Nonexistent.avi
				}	
			}
		} else if (RegExMatch(message_3, "^(.+) (\S+): HQ: Ich bin in (.+) gestorben, Backup NICHT mehr nötigt!$", dchat_)) {
			if (dchat_2 != getUserName()) {
				indexRemove := -1
				
				for index, entry in backups {
					if (entry["name"] == dchat_2) {
						indexRemove := index
					}
				}
				
				if (indexRemove != -1) {
					backups.RemoveAt(indexRemove)
				}
				
				if (backupSound) {
					SoundPlay, Nonexistent.avi
				}	
			}
		}
	} else if (RegExMatch(message, "^\*\*\(\( (.+) (\S+): An alle Einheiten: Einsatzziel ist (\S+) \(ID: (\d+)\)\. Alle SOFORT ausrücken! \)\)\*\*$", line_)) {
		if (line_2 != getUserName()) {
			target := line_3
			targetid := line_4
			
			SetTimer, TargetTimer, 1
		}
	} else if (RegExMatch(message, "^HQ: (.+) (\S+): An alle Einheiten: Einsatzziel ist (\S+) \(ID: (\d+)\)\. Alle SOFORT ausrücken!$", line_)) {
		if (line_2 != getUserName()) {
			target := line_3
			targetid := line_4
			
			SetTimer, TargetTimer, 1
		}		
	} else if (RegExMatch(message, "^WARNUNG: Hör auf zu Spamen, sonst wirst du gekickt!$")) {
		if (antiSpam) {
			blockChatInput()
			
			SendInfo("Das Antispam System wurde " . cgreen . "aktiviert" . cwhite . ".")
			
			SetTimer, SpamTimer, -1500
		}
	} else if (RegExMatch(message, "^\[Fraktion\]: (\S+) hat sich eingeloggt\.$", message_)) {
		if (memberInfo) {
			loginName := message_1
			
			SetTimer, HelloTimer, 1
		}
	} else if (RegExMatch(message, "^\* Sanitäter (\S+) bietet dir ein Erste-Hilfe-Paket für \$(\d+) an\. Benutze \/accept Paket$", message_)) {
		medicName := message_1
		
		SetTimer, PaketTimer, 1
	} else if (RegExMatch(message, "^Paintball: (\S+) wurde von (\S+) getötet\.$", message_)) {
		if (message_1 == getUsername()) {
			pbdeaths := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=pbdeaths&value=1")
			IniWrite, %pbdeaths%, ini/Stats.ini, stats, pbdeaths
			
			IniRead, pbdeaths, ini/Stats.ini, stats, pbdeaths, 0
			IniRead, pbkills, ini/Stats.ini, stats, pbkills, 0 
			
			pbKillStreak := 0
			
			SendInfo(cOrange . "Paintball:" . cWhite . " Tode: " . csecond . formatNumber(pbdeaths) . cwhite . " | Kills: " . csecond . formatNumber(pbkills) . cwhite . " | K/D: " . csecond . round(pbkills/pbdeaths, 3))
			
			if (pbKillStreak > 0 && paintInfo)  {
				SendChat("/l Meine Killstreak war: " . pbKillStreak)
			}
			
			pbKillStreak := 0
		} else if (message_2 == getUsername()) {			
			pbkills := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=pbkills&value=1")
			IniWrite, %pbkills%, ini/Stats.ini, stats, pbkills
			
			IniRead, pbkills, ini/Stats.ini, stats, pbkills, 0
			IniRead, pbdeaths, ini/Stats.ini, stats, pbdeaths, 0		
			IniRead, pbHighestKillStreak, ini/Stats.ini, Stats.ini, pbHighestKillStreak, 0
			
			SendInfo(cOrange . "Paintball:" . cWhite . " Kills: " . csecond . formatNumber(pbkills) . cwhite . " | Tode: " . csecond . formatNumber(pbDeaths) . cwhite . " | K/D: " . csecond . round(pbkills/pbdeaths, 3))
			
			pbKillStreak ++
			
			if (pbKillStreak > pbHighestKillStreak) {
				pbHighestKillStreak := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=pbKillstreak&value=1")
				IniWrite, %pbHighestKillStreak%, ini/Stats.ini, ini/Stats.ini, pbHighestKillStreak
				
				if (paintInfo) {
					SendChat("/l Meine neue beste Killstreak: " . pbKillStreak)
				} else {
					SendInfo("Neuer Killstreak-Rekord: " . csecond . pbHighestKillStreak)
				}
			} else {
				if (paintInfo) {
					SendChat("/l Meine Killstreak: " . pbKillStreak)
				}
			}
		}
	} else if (RegExMatch(message, "^\|=================\|\|============\|\|=================\|$")) {
		Loop {
			chat := arr[index - A_Index]
			
			if (InStr(chat, "KFZ Steuer:")) {
				RegExMatch(chat, "KFZ Steuer: -(\d*)\$", car)
				IsPayday ++
			}
			
			if (InStr(chat, "Lohn: ")) {
				RegExMatch(chat, "Lohn: (.*)\$ \(davon (.*)\$ durch Upgrade und (.*)\$ durch Segnung\)     Miete: -(.*)\$     Lohnsteuer: -(.*)\$", general)
				IsPayday ++
			}
			
			if (InStr(chat, "Stromrechnung: ")) {
				RegExMatch(chat, "Stromrechnung: -(.*)\$", electricity)
				IsPayday ++
			}
			
			if (InStr(chat, "|================| Gehalts-Check |================|")) {
				IsPayday ++
				
				break
			}
		}
		
		money := numberFormat(general1)
		money -= numberFormat(general4)
		money -= numberFormat(general5)
		money -= numberFormat(car1)
		money -= numberFormat(electricity1)
		
		if (IsPayday > 0) {		
			Sleep, 100
			
			SendInfo("Dein Gehaltscheck beläuft sich auf $" . cGreen . formatNumber(money) . cwhite . ".")
			IniWrite, 0, ini/Stats.ini, stats, paydayMoney
		}
	} else if (RegExMatch(message, "^> (\S+) beobachtet (\S+)\.$", message_)) {
		if (!tv) {
			tv := true
		
			SendInfo("Beobachtungsmodus " . cgreen . "aktiviert" . cwhite . ".")
		}
	} else if (RegExMatch(message, "^> (\S+) hat die Beobachtung beendet\.$")) {
		if (tv) {
			tv := false
			
			SendInfo("Beobachtungsmodus " . cred . "deaktiviert" . cwhite . ".")
		}
	} else if (RegExMatch(message, "^Du hast dich ausgerüstet, es wurden (.*) Materialien benötigt\. \(Verbleibend: (.*) Materialien\)$", line0_)) {
		equipMats:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=equipMats&value=" . numberFormat(line0_1))
		IniWrite, %equipmats%, ini/Stats.ini, Allgemein, Equipmats
		IniRead, DailyMats, ini/Stats.ini, stats, %A_DD%_%A_MM%_%A_YYYY%_Mats, 0 ; (( vielleicht son allgemeinen Log noch extra mit Tages, Wochen und Monats equip im CP ?? ))
		DailyMats += numberFormat(line0_1)
		IniWrite, %DailyMats%, ini/Stats.ini, stats, %A_DD%_%A_MM%_%A_YYYY%_Mats
		
		if (DailyMats < 3000) {
			SendInfo(cgrey . "Du hast heute bereits " . formatNumber(DailyMats) . " Materialien verbraucht.")
		} else if (DailyMats > 3000 && DailyMats < 5000) {
			SendInfo(cyellow . "Info: Du hast heute bereits " . formatNumber(DailyMats) . " Materialien verbraucht.")
		} else if (DailyMats > 5000 && DailyMats < 10000) {
			SendInfo(corange . "Achtung: Du hast heute bereits " . formatNumber(DailyMats) . " Materialien verbraucht.")
		} else if (DailyMats > 10000) {
			SendInfo(cred . "WARNUNG: Du hast heute bereits " . formatNumber(DailyMats) . " Materialien verbraucht.")
		}
		
		hasEquip := 1
	} else if (RegExMatch(message, "^\HQ: (.+) (\S+) hat eine Straßensperre in (.+) aufgebaut\.", line0_)) {
		if (line0_2 == getUserName())  {
			roadblocks := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=roadblock&value=1")
			IniWrite, %roadblocks%, ini/Stats.ini, Allgemein, Roadblocks
			
			SendInfo("Du hast bereits " . csecond . formatNumber(roadblocks) . cwhite . " Straßensperren aufgebaut.")
		}
	} else if (RegExMatch(message, "^HQ: (.+) (\S+) hat (\S+) (\d+) (\S+) aus der Akte entfernt\.$", line0_)) {
		if (line0_2 == getUserName()) {
			if (line0_5 == "Strafpunkte") {
				Pointsclear := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=pclear&value=" . numberFormat(line0_4))
				IniWrite, %Pointsclear%, ini/Stats.ini, Vergaben, Pointsclear
				
				SendInfo("Du hast bereits " . csecond . formatNumber(Pointsclear) . cwhite . " Strafpunkte gelöscht.")
			} else if (line0_5 == "Wanteds") {
				Wantedsclear := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=wclear&value=" . numberFormat(line0_4))
				IniWrite, %Wantedsclear%, ini/Stats.ini, Vergaben, Wantedsclear
				
				SendInfo("Du hast bereits " . csecond . formatNumber(Wantedsclear) . cwhite . " Wanteds gelöscht.")
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) ein Ticket für (.*)\$ gegeben, Grund: (.+)$", line0_)) {
		if (RegExMatch(line0_3, "Wanted-Ticket \((\d+) Wanteds?\)", wanteds_)) {
			wantedTicket := []
			wantedTicket["name"] := line0_1
			wantedTicket["wanteds"] := wanteds_1
			wantedTickets.Push(wantedTicket)
		}
		
		Ticketrequests := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=tickets&value=1")
		IniWrite, %Ticketrequests%, ini/Stats.ini, Tickets, Ticketrequests
		
		SendInfo("Du hast bereits " . csecond . formatNumber(Ticketrequests) . cwhite . " Tickets ausgestellt.")
		
		ticket := []
		ticket["name"] := line0_1
		ticket["price"] := numberFormat(line0_2)
		ticket["reason"] := line0_3
		
		for index, ticket in tickets {
			if (line0_1 == ticket["name"] && ticket["reason"] == line0_3) {
				return
			}
		}
		
		tickets.Push(ticket)		
	} else if (RegExMatch(message, "^\* (\S+) hat dein Ticket in Höhe von (.*)\$ bezahlt\.$", line0_)) {
		ticketID := -1
		wantedTicketId := -1
	
		for index, ticket in tickets {
			if (ticket["name"] == line0_1 && ticket["price"] == numberFormat(line0_2)) {
				ticketID := index
				
				ticketResult := UrlDownloadToVar(baseURL . "api/ticketLog?username=" . username . "&password=" . password . "&ticketName=" . line0_1 . "&reason=" . ticket["reason"] . "&money=" . line0_2)
				break
			}
		}
		
		for index, wantedTicket in wantedTickets {
			if (line0_1 == wantedTicket["name"]) {
				wantedTicketId := index
				
				Sleep, 500
				
				SendChat("/clear " . wantedTicket["name"] . " " . wantedTicket["wanteds"])
				break
			}
		}		
		
		Tickets := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=tickets_accepted&value=1")
		IniWrite, %Tickets%, ini/Stats.ini, Tickets, Tickets
		
		SendInfo("Es wurden bereits " . csecond . formatNumber(Tickets) . cwhite . " Tickets von dir angenommen.")
		
		ticketMoney := numberFormat(line0_2)
		ticketMoney := floor(ticketMoney * taxes)

		payPartnerMoney(numberFormat(ticketMoney), "ticket_money")		
		
		if (ticketID != -1) {
			tickets.RemoveAt(ticketID)
		}
		
		if (wantedTicketId != -1) {
			wantedTickets.RemoveAt(wantedTicketId)
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) seinen (\S+) weggenommen\.$", message_)) {
		if (message_2 == "Flugschein") {
			fstakes := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=fstakes&value=1")
			IniWrite, %fstakes%, ini/Stats.ini, Scheine, Flugschein
			
			SendInfo("Du hast bereits " . csecond . formatNumber(fstakes) . cwhite . " Flugscheine entzogen.")
			SendInfo("Der Schaden durch Flugscheine beläuft sich auf $" . csecond . formatNumber(fstakes * 12000) . cwhite . ".")
		} else if (message_2 == "Bootschein") {
			Bootschein := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=bstakes&value=1")
			IniWrite, %Bootschein%, ini/Stats.ini, Scheine, Bootschein
			
			SendInfo("Du hast bereits " . csecond . formatNumber(Bootschein) . cwhite . " Bootscheine entzogen.")
			SendInfo("Der Schaden durch Bootscheine beläuft sich auf $" . csecond . formatNumber(Bootschein * 6000) . cwhite . ".")
		} else if (message_2 == "Waffenschein") {
			Waffenschein := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=wstakes&value=1")
			IniWrite, %Waffenschein%, ini/Stats.ini, Scheine,  Waffenschein
			
			SendInfo("Du hast bereits " . csecond . formatNumber(Waffenschein) . cwhite . " Waffenscheine entzogen.")
			SendInfo("Der Schaden durch Waffenscheine beläuft sich auf $" . csecond . formatNumber(Waffenschein * 36000) . cwhite . ".")
		}
	} else if (RegExMatch(message, "^\* (\S+) nimmt Geld aus seiner Tasche und gibt es " . getUsername() . "\.$", line0_)) {
		if (RegExMatch(arr[index - 1], "^Du hast (.*)\$ von (\S+)\((\d+)\) erhalten\.$", line1_)) {
			playerCoords := getCoordinates()
			
			if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 1564.5, -1694.5, 6.5) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], -1589.5, 716, -4.5) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 2281.5, 2431, 4) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 2341.6, -2028.5, 13) < 25) {
			} else {
				if (numberFormat(line_1) > 1500) {
					SendChat("/l Ich danke Dir für die $" . line1_1 . ", " . line1_2 . "!")
				}
			
				return
			}
			
			arrested := false
			
			Loop, 10 {
				chat := arr[index - A_Index]
				
				if (RegExMatch(chat, "^HQ: Alle Einheiten, (.+) " . line0_1 . " hat den Auftrag ausgeführt\.$", chat_)) {
					arrested := true
				}
			}
			
			if (arrested) {
				Money := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=arrest_money&value=" . numberFormat(line1_1))
				Arrests := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=arrests&value=1")
				
				IniWrite, %arrests%, ini/Stats.ini, Verhaftungen, Arrests				
				IniWrite, %Money%, ini/Stats.ini, Verhaftungen, Money
				
				SendInfo("Du hast bereits " . csecond . formatNumber(Arrests) . cwhite . " Verbrecher eingesperrt.")
				SendInfo("Du hast bereits $" . csecond . formatNumber(Money) . cwhite . " durch Verhaftungen verdient.")
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+)g Drogen weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		drugs:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=drugs&value=" . numberFormat(line0_2))
		IniWrite, %drugs%, ini/Stats.ini, Kontrollen, Drugs
		
		SendInfo("Du hast bereits " . csecond . formatNumber(drugs) . cwhite . "g Drogen weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Samen weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Seeds, ini/Stats.ini, Kontrollen, Seeds, 0 
		Seeds += numberFormat(line0_2)
		IniWrite, %seeds%, ini/Stats.ini, Kontrollen, Seeds
		
		SendInfo("Du hast bereits " . csecond . formatNumber(seeds) . cwhite . " Samen weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (.*) Materialien weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		Mats:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=mats&value=" . numberFormat(line0_2))
		IniWrite, %Mats%, ini/Stats.ini, Kontrollen, Mats
		
		SendInfo("Du hast bereits " . csecond . formatNumber(Mats) . cwhite . " Materialien weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Materialpakete weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		Matpackets := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=matpackets&value=" . numberFormat(line0_2))
		IniWrite, %Matpackets%, ini/Stats.ini, Kontrollen, Matpackets
		
		SendInfo("Du hast bereits " . csecond . formatNumber(Matpackets) . cwhite . " Materialpakete weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Haftbomben weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		Matbombds := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=matBombds&value=" . numberFormat(line0_2))
		IniWrite, %Matbombs%, ini/Stats.ini, Kontrollen, Matbombs
		
		SendInfo("Du hast bereits " . csecond . formatNumber(Matbombs) . cwhite . " Haftbomben weggenommen.")
	} else if (RegExMatch(message, "^Du hast (\d+) (.+) aus dem Kofferraum konfisziert\.$", message_)) {
		if (message_2 == "Materialien") {
			Mats := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=mats&value=" . numberFormat(line0_1))
			IniWrite, %Mats%, ini/Stats.ini, Kontrollen, Mats
			
			SendInfo("Du hast bereits " . csecond . formatNumber(Mats) . cwhite . " Materialien weggenommen.")
		} else if (message_2 == "Gramm Drogen") {
			drugs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=drugs&value=" . numberFormat(line0_1))
			IniWrite, %drugs%, ini/Stats.ini, Kontrollen, Drugs
		
			SendInfo("Du hast bereits " . csecond . formatNumber(drugs) . cwhite . "g Drogen weggenommen.")
		}
	} else if (RegExMatch(message, "^\* (.*) schießt mit seinen Elektroschocker auf (\S+) und setzt ihn unter Strom\.$", message_)) {
		if (RegExMatch(message, "^Agent (\d+)$", agent_)) {
			agent_ID := agent_1
		}
		
		if (getUserName() == message_1 || agentID == agent_ID) {
			tazer:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=tazer&value=1")
			IniWrite, %tazer%, ini/Stats.ini, Allgemein, Tazer
		
			SendInfo("Du hast bereits " . csecond . formatNumber(tazer) . cwhite . " Spieler getazert.")
			
			for index, grabName in grabList {
				if (grabName == message_2) {
					isArrested := true
				}
			}
			
			for index, arrestName in arrestList {
				if (arrestName == message_2) {
					isCuffed := true
				}
			}		
		
			if (isArrested == false) {
				arrestList.Push(message_2)			
			}
			
			if (isCuffed == false) {
				grabList.Push(message_2)
			}
			
			isArrested := false
			isCuffed := false
		} else {
			for index, entry in partners {
				if (message_1 == entry) {
					for index, grabName in grabList {
						if (grabName == message_2) {
							isArrested := true
						}
					}
					
					for index, arrestName in arrestList {
						if (arrestName == message_2) {
							isCuffed := true
						}
					}		
				
					if (isArrested == false) {
						arrestList.Push(message_2)			
					}
					
					if (isCuffed == false) {
						grabList.Push(message_2)
					}
					
					isArrested := false 
					isCuffed := false	
				}
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) ins Fahrzeug gezogen\.$", message_)) {
		indexRemove := -1
		
		for index, grabName in grabList {
			if (message_1 == grabName) {
				indexRemove := index
			}
		}
	
		if (indexRemove != -1) {
			grabList.RemoveAt(indexRemove)
		}
	} else if (RegExMatch(message, "^\* Der Staat übernimmt die Kosten\.$", message_)) {
		if (RegExMatch(arr[index - 1], "^\* Du hast (.*) Liter getankt für (.*)\$\.$", line0_)) {
			IniRead, govfills, ini/Stats.ini, Allgemein, govfills, 0
			IniRead, govfillprice, ini/Stats.ini, Allgemein, govfillprice, 0

			govfills += numberFormat(line0_1)
			govfillprice += numberFormat(line0_2)
			
			IniWrite, %govfills%, ini/Stats.ini, Allgemein, govfills
			IniWrite, %govfillprice%, ini/Stats.ini, Allgemein, govfillprice
			
			SendInfo("Du hast bereits " . csecond . formatNumber(govfills) . cwhite . " Liter getankt.")
			SendInfo("Die Tankkosten belaufen sich auf $" . csecond . formatNumber(govfillprice) . cwhite . ".")		
		}
	} else if (RegExMatch(message, "^HQ: (\S+) wurde getötet, Haftzeit: (\S+) Minuten, Geldstrafe: (.*)\$$", line0_)) {
		if (RegExMatch(arr[index - 1], "^HQ: Alle Einheiten, (.*) (\S+) hat den Auftrag ausgeführt\.$", line1_)) {
			if (line0_1 == getFullName(playerToFind)) {
				stopFinding()
			}			
			
			if (line1_2 == getUserName()) {
				Crimekills := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=suspect_kills&value=1")
				IniWrite, %Crimekills%, ini/Stats.ini, Verhaftungen, Crimekills
				
				SendInfo("Dies war dein " . csecond . formatNumber(Crimekills) . cwhite . " getöteter Verbrecher.")
			}
			
			indexRemove := -1
			
			for index, grabName in grabList {
				if (line0_1 == grabName) {
					indexRemove := index
				}
			}
		
			if (indexRemove != -1) {
				grabList.RemoveAt(indexRemove)
			}			
		}
	} else if (RegExMatch(message, "^HQ: (.*) wurde eingesperrt, Haftzeit: (\d+) Minuten, Geldstrafe: (.*)\$$", line0_)) {		
		if (RegExMatch(arr[index - 1], "^HQ: Alle Einheiten, (.*) (\S+) hat den Auftrag ausgeführt\.$", line1_)) {
			if (line0_1 == getFullName(playerToFind)) {
				stopFinding()
			}
			
			if (line1_2 == getUsername()) {
				if (line0_3 == 0) {
					if (!deathArrested) {
						arrestWanteds := line0_2 / 3
						arrestMoney := arrestWanteds * 750
						
						IniRead, taxes, ini/Settings.ini, settings, taxes, 1
						IniRead, arrestLimitUnix, ini/Settings.ini, UnixTime, arrestLimitUnix, 0
						
						if (getUnixTimestamp(A_Now) > arrestLimitUnix) {
							if (arrestMoney > 16000) {
								arrestMoney := 16000
							}
						} else {
							if (arrestMoney > 32000) {
								arrestMoney := 32000
							}
						}
						
						IniRead, taxes, ini/Settings.ini, settings, taxes, 1
						if (taxes == 1) {
							getTaxes()
							
							Sleep, 500
						}
						
						totalArrestMoney += arrestMoney
						totalArrestMoney := floor(totalArrestMoney * taxes)
						
						if (!deathArrested) {
							arrests := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=arrests&value=1")
							
							IniWrite, %arrests%, ini/Stats.ini, Verhaftungen, Arrests
							
							SendInfo("Du hast bereits " . csecond . formatNumber(arrests) . cwhite . " Verbrecher eingesperrt.")
							
							SetTimer, PartnerMoneyTimer, 1
						}
					} else {
						deathArrested := false
					
						deathArrests := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=darrests&value=1")
						IniWrite, %deathArrests%, ini/Stats.ini, Verhaftungen, Deatharrests
						
						SendInfo("Du hast bereits " . csecond . formatNumber(deathArrests) . cwhite . " Verbrecher nach dem Tod eingesperrt.")
						
						SetTimer, PartnerMoneyTimer, 1
					}
				} else {
					if (deathArrested) {
						deathArrested := false
		
						deathPrison := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=dprison&value=1")
						IniWrite, %deathPrison%, ini/Stats.ini, Verhaftungen, deathprison
						
						SendInfo("Du hast bereits " . csecond . formatNumber(deathPrison) . cwhite . " Verbrecher nach dem Tod ins Prison gesteckt.")
					}
				}
			}
			
			indexRemove := -1
			
			for index, grabName in grabList {
				if (line0_1 == grabName) {
					indexRemove := index
				}
			}
		
			if (indexRemove != -1) {
				grabList.RemoveAt(indexRemove)
			}				
		}
	} else if (RegExMatch(message, "^HQ: Haftzeit: (\d+) Minuten, Geldstrafe: (.*)\$\.$", line0_)) {
		if (RegExMatch(arr[index - 1], "^HQ: (.*) (\S+) hat den Verdächtigen (\S+) offline eingesperrt\.$", line1_)) {
			if (line1_3 == getFullName(playerToFind)) {
				stopFinding()
			}
				
			if (line1_2 == getUserName()) {
				if (line0_2 > 0) {
					offlinePrison := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=oprison&value=1")
					IniWrite, %offlinePrison%, ini/Stats.ini, Verhaftungen, Offlineprison
					
					Sleep, 100
					SendInfo("Du hast bereits " . csecond . formatNumber(offlinePrison) . cwhite . " Verbrecher offline ins Prison gesteckt.")
				} else {
					arrestWanteds := line0_1 / 3
					arrestMoney := arrestWanteds * 750
					
					IniRead, taxes, ini/Settings.ini, settings, taxes, 1
					IniRead, arrestLimitUnix, ini/Settings.ini, UnixTime, arrestLimitUnix, 0
						
					if (getUnixTimestamp(A_Now) > arrestLimitUnix) {
						if (arrestMoney > 16000) {
							arrestMoney := 16000
						}
					} else {
						if (arrestMoney > 32000) {
							arrestMoney := 32000
						}
					}
					
					if (taxes == 1) {
						getTaxes()
						Sleep, 500
					}
					
					totalArrestMoney += arrestMoney
					totalArrestMoney := floor(totalArrestMoney * taxes)	
					offlineArrests := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=oarrests&value=1")
					
					IniWrite, %offlineArrests%, ini/Stats.ini, Verhaftungen, offlinearrests
					
					SendInfo("Du hast bereits " . csecond . formatNumber(offlineArrests) . cwhite . " Verbrecher offline eingesperrt.")
					
					SetTimer, PartnerMoneyTimer, 1
				}
			}
			
			indexRemove := -1
			
			for index, grabName in grabList {
				if (line1_3 == grabName) {
					indexRemove := index
				}
			}
		
			if (indexRemove != -1) {
				grabList.RemoveAt(indexRemove)
			}				
		}
	} else if (RegExMatch(message, "^HQ: Verbrechen: Überfall GK (\S+) \((\S+)\), Zeuge: Niemand, Verdächtiger: (\S+)$", message_)) {
		location := message_1 . " (" . message_2 . ")"
	
		storerob := []
		storerob["time"] := A_Hour . ":" . A_Min
		storerob["name"] := message_3
		storerob["crime"] := "Storerob"
		storerob["location"] := location
		storerob["countdown"] := 90
		
		for index, key in storerobs {
			if (key["name"] == message_3 && key["location"] == location) {
				return
			}
		}
		
		storeRobs.Push(storerob)
	} else if (RegExMatch(message, "^(\S+) hat den Bankräuber (\S+) von (.+) getötet. Der Banküberfall ist gescheitert!$", message_)) {
		if (getUserName() == message_1) {
			indexRemove := -1
			
			for index, entry in bankrobs {
				if (entry["place"] == message_3) {
					indexRemove := index
				}
			}
		
			if (indexRemove != -1) {
				bankrobs.RemoveAt(indexRemove)
			}
			
			IniRead, bankrobs, ini/stats.ini, Stats, bankrobs, 0
			bankrobs ++
			IniWrite, % bankrobs, ini/stats.ini, Stats, bankrobs
	
			SendInfo("Du hast bereits " . cSecond . formatNumber(bankrobs) . cWhite . " Banküberfälle aufgehalten.") ; #BAUM
		} else {
			SendChat("/d HQ: Gute Arbeit, " . message_1 . "!")
		}
	} else if (RegExMatch(message, "^(\S+) hat die Bank in (\S+) verlassen\. Der Banküberfall ist gescheitert!$", message_)) {
		indexRemove := -1
	
		for index, entry in bankrobs {
			if (entry["place"] == message_2) {
				indexRemove := index
			}
		}
	
		if (indexRemove != -1) {
			bankrobs.RemoveAt(removeID)
		}
	}
	/* else if (RegExMatch(message, "^HQ: (.+) " . getUsername() . " hat das Marihuana in (.+) gefunden und zerstört\.$", chat_)) {
		IniRead, plants, ini/Stats.ini, Marihuana, plants, 0
		plants ++
		IniWrite, %plants%, ini/Stats.ini, Marihuana, Plants
		
		SendInfo("Du hast bereits " . csecond . formatNumber(plants) . cwhite . " Marihuana-Pflanzen zerstört.")
		
		adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
		cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
		
		if (RegExMatch(cText, "Marihuana zerstoert~n~~g~(.*)\$", cText_)) {
			paydayMoney += numberFormat(cText_1)
			payPartnerMoney(numberFormat(cText_1), "plants_money")
		}		
	*/
	else if (RegExMatch(message, "^HQ: \+\+\+ Alle Einheiten \+\+\+$")) {
		if (RegExMatch(arr[index - 2], "^HQ: \+\+\+ Alle Einheiten \+\+\+$")) {
			mdcChat1 := arr[index - 1]
	
			if (RegExMatch(mdcChat1, "^HQ: Jemand versucht das Verwaltungstor aufzubrechen\.$")) {
				ShowGameText("~r~Ausbruch~n~~w~Verwaltungstor", 9000, 1)
			
				iniRead, outbreak, ini/Stats.ini, Stats, outbreak, 0
				outbreak ++
				iniWrite, % outbreak, ini/Stats.ini, Stats, outbreak
				
				SendInfo("Es wurde ein Ausbruch (" . cSecond . "Fall " . outbreak . cwhite . ") gemeldet.")

				outbreakInfo := []
				outbreakInfo["time"] := A_Hour . ":" . A_Min
				outbreakInfo["type"] := "gate"
				outbreakInfo["count"] := outbreak
				outbreakInfo["countdown"] := 29
				outbreaks.Push(outbreakInfo)
			
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Coup im Verwaltungsgebäude in Commerce, Los Santos gemeldet\.$")) {				
				ShowGameText("~r~Heist~n~~w~Verwaltungsgebaude", 9000, 1)
				
				coupInfo := []
				
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Coup im Los Santos Police Department gemeldet\.$")) {				
				ShowGameText("~r~Heist~n~~w~Los Santos Police Department", 9000, 1)

				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
				
				; Anpassen: Coup overlay
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Waffentransporter Überfall in (.+) gemeldet\.$", mdcChat1_)) {				
				ShowGameText("~r~Waffentransport-Ueberfall~n~~w~" . mdcChat1_1, 9000, 1)
				
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
				
				; Anpassen: Matrob overlay
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Bank Überfall in (.+) gemeldet\.$", mdcChat1_)) {				
				ShowGameText("~r~Bankueberfall~n~~w~" . mdcChat1_1, 9000, 1)
				
				bankrobInfo := []
				bankrobInfo["time"] := A_Hour . ":" . A_Min
				bankrobInfo["place"] := mdcChat_1
				bankrobInfo["countdown"] := 360
				bankrobs.Push(bankrobInfo)
				
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			}
		}
	} else if (RegExMatch(message, "^HQ: (.+) (\S+) \((\d+)\) benötigt Verstärkung in (.*)\.$", mdcChat_)) {
		if (mdcChat_2 != getUserName()) {
			if (backupSound) {
				SoundSetWaveVolume, 50
				SoundPlay, %A_ScriptDir%/sounds/bk.mp3
			}
				
			backupInfo := []
			backupInfo["time"] := A_Hour . ":" . A_Min 
			backupInfo["name"] := mdcChat_2
			backupInfo["place"] := mdcChat_4
			backupInfo["countdown"] := 240
			backups.Push(backupinfo)
			
			ShowGameText("~r~Backup~n~~w~" . mdcChat_4 , 8000, 1)			
		}
	} else if (RegExMatch(message, "^Geschwindigkeit: (\d+) km\/h$", message_)) {		
		vehOwner := arr[index - 4]
		vehDriver := arr[index - 3]
		
		if (RegExMatch(vehOwner, "^Fahrzeughalter: (\S+)$", vehOwner_)) {
			if (vehOwner_1 == "LSPD" || vehOwner_1 == "SAPD" || vehOwner_1 == "Sanitäter" || vehOwner_1 == "Ordnungsamt" || vehOwner_1 == "FBI" || vehOwner_1 == "SAFD" || vehOwner_1 == "Kirche" || vehOwner_1 == "Army" || vehOwner_1 == "LVPD") {
				return
			}
		}
		
		if (RegExMatch(vehDriver, "^Fahrzeugführer: (\S+) \(ID: (\d+)\)$", driver_)) {
			kmh := max_kmh
			
			Radarcontrols := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=radarcontrols&value=1")
			IniWrite, %Radarcontrols%, ini/Stats.ini, Kontrollen, Radarcontrols
			
			Sleep, 100
			SendInfo("Du hast bereits " . csecond . formatNumber(Radarcontrols) . cwhite . " Fahrzeuge geblitzt.")
			
			if (kmh == 0) {
				kmh := 80
				SendInfo("Setze die erlaubte Geschwindigkeit mit " . cSecond . "/setkmh")
			}
			
			if (laserInfo) {
				if (message_1 > kmh) {
					IniRead, department, ini/Settings.ini, settings, department, %A_Space%
					
					lastSpeed := message_1
					lastSpeedUser := driver_1
					
					Sleep, 500
					useMegaphone(0)
				}
			}
		}
	} else if (RegExMatch(message, "SMS: (.+), Sender: (\S+) \((\d+)\)", message_)) {
		if (message_2 != getUserName()) {	
			IniWrite, 1, ini/Settings.ini, items, mobilePhone
	
			if (infoOvEnabled) {
				ov_Info(0)
				ov_Info()
			}	
	
			if (smsSound) {
				SoundSetWaveVolume, 50
				SoundPlay, %A_ScriptDir%/sounds/sms.mp3
			}
		}
	} else if (RegExMatch(message, "\.\.\.(.+), Sender: (\S+) \((\d+)\)", message_)) {
		if (message_2 != getUserName()) {
			IniWrite, 1, ini/Settings.ini, items, mobilePhone
			
			if (infoOvEnabled) {
				ov_Info(0)
				ov_Info()
			}
			
			if (smsSound) {
				SoundSetWaveVolume, 50
				SoundPlay, %A_ScriptDir%/sounds/sms.mp3
			}
		}
	} else if (RegExMatch(message, "^Dein Handy klingelt\. Tippe \/pickup\. Anrufer-ID: (\S+)$", message_)) {
		IniWrite, 1, ini/Settings.ini, items, mobilePhone
	
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}	

		if (callSound) {
			SoundSetWaveVolume, 50
			SoundPlay, %A_ScriptDir%/sounds/call.mp3
		}
	} else if (RegExMatch(message, "^Der Gesprächspartner hat aufgelegt\.$") 
		|| RegExMatch(message, "^Du hast aufgelegt\.$") 
		|| RegExMatch(message,"^Die Verbindung zu deinem Gesprächspartner wurde unterbrochen\.$")) {
		IniWrite, 1, ini/Settings.ini, items, mobilePhone
		
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}		
		
		if (callSound) {
			SoundPlay, Nonexistent.avi
		}
	} else if (RegExMatch(message, "\* (\S+) geht an sein Handy\.$", message_)) {
		if (message_1 == getUserName()) {
			IniWrite, 1, ini/Settings.ini, items, mobilePhone
			
			if (infoOvEnabled) {
				ov_Info(0)
				ov_Info()
			}

			if (callSound) {
				SoundPlay, Nonexistent.avi
			}	
		}
	} else if (RegExMatch(message, "^Du hast dein Handy (\S+)\.$", message_)) {
		if (InStr(message_1, "abgeschaltet")) {
			IniWrite, 0, ini/Settings.ini, items, mobilePhone
		} else if (InStr(message_1, "angeschaltet")) {
			IniWrite, 1, ini/Settings.ini, items, mobilePhone
		}
		
		Sleep, 100
		
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}		
	} else if (RegExMatch(message, "^\* Du hast einen (.+) \((\d+) LBS\) gegessen, es wurde deiner Gesundheit hinzugefügt.$", message_)) {
	
		Loop, 5 {
			if (message_1 == fishName_%A_Index%) {
				if (message_2 == fishLBS_%A_Index%) {
					fishName_%A_Index% := "nichts"
					fishLBS_%A_Index% := 0
					fishHP_%A_Index% := 0
				}
			}
		}

		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}	
	} else if (RegExMatch(message, "^\* Du hast ein\/e (.+) mit (\d+) LBS gekocht\.$", message_)) {
		Loop, 5 {
			if (fishName%A_Index% == message_1) {
				if (fishLBS%A_Index% == message_2) {
					fishName%A_Index% := "nichts"
					fishLBS%A_Index% := 0
					fishHP%A_Index% := 0
					fishPrice%A_Index% := 0		
				}
			}
		}
		
		if (infoOvEnabled) {
			ov_Info(0)
			ov_Info()
		}			
	}
}

KillTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}	
	
	IniRead, kills, ini/stats.ini, Stats, kills, 0
	IniRead, dkills, ini/stats.ini, Stats, dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mkills, ini/stats.ini, Stats, mkills[%A_MM%:%A_YYYY%], 0
	
	IniRead, deaths, ini/stats.ini, Stats, deaths, 0
	IniRead, ddeaths, ini/stats.ini, Stats, ddeaths[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mdeaths, ini/stats.ini, Stats, mdeaths[%A_MM%:%A_YYYY%], 0
	
	IniRead, killstreak, ini/Stats.ini, Stats, killstreak, 0	
	
	data := getKills()
	
	if (data && !isPaintball) {
		for index, object in data {
			if (object.victim.local) {
				killWeaponShort := weaponShort(object.weapon)
				killWeapon := getWeaponName(object.weapon)
				killerID := getPlayerIdByName(object.murderer.name)
				ped := getPedById(killerID)
				pedCoord := getPedCoordinates(ped)
					
				if (getDistanceToPoint(getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], pedCoord[1], pedCoord[2], pedCoord[3]) <= 30) {
					killName := object.murderer.name
				} else {
					killName := "Unbekannt"
				}
				
				if (getPlayerInteriorId()) {
					deathPlace := "in einem Interior (" . getPlayerInteriorId() . ")"
				} else {
					deathPlace := "in " . getPlayerZone() . ", " . getPlayerCity()
				}				
				
				IniWrite, % killWeaponShort, ini/Stats.ini, Stats, MurdererWeaponArt
				IniWrite, % killFaction, ini/Stats.ini, Stats, MurdererFaction
				IniWrite, % killWeapon, ini/Stats.ini, Stats, MurdererWeapon
				IniWrite, % killName, ini/Stats.ini, Stats, Murderer
				IniWrite, % deathPlace, ini/Stats.ini, Stats, DeathPlace
			
				deaths ++
				ddeaths ++
				mdeaths ++
				
				IniWrite, % deaths, ini/stats.ini, Stats, deaths
				IniWrite, % ddeaths, ini/stats.ini, Stats, ddeaths[%A_DD%:%A_MM%:%A_YYYY%]
				IniWrite, % mdeaths, ini/stats.ini, Stats, mdeaths[%A_MM%:%A_YYYY%]
				
				kd := round(kills/deaths, 2)
				dkd := round(dkills/ddeaths, 2)
				mkd := round(mkills/mdeaths, 2)
	
				SendInfo("DKD: " . cSecond . kd . cWhite . " - MKD: " . cSecond . mkd . cWhite . " - KD: " . cSecond . kd)
			
				if (bk) {
					if (getFullName(killName)) {
						SendChat("/d HQ: " . killName . " hat mich " . deathPlace . " getötet, Backup NICHT mehr nötig!")
					} else {
						SendChat("/d HQ: Ich bin " . deathPlace . " gestorben, Backup NICHT mehr nötigt!")
					}
					
					bk := 0
				} else {
					if (deathText) {
						SendToHotkey(deathMessage)
					}					
				}
				
				if (agentID > 0) {
					if (agentTog) {
						IniWrite, 1, ini/Settings.ini, items, mobilePhone
					}
					
					if (infoOvEnabled) {
						ov_Info(0)
						ov_Info()
					}	
				}					
				
				agentID := 0
				streak := 0
				hasEquip := 0
			} else if (object.murderer.local) {
				killFaction := getSkinFraction(object.skin)
				killWeapon := getWeaponName(object.weapon)
				killWeaponShort := weaponShort(object.weapon)
				killerID := getPlayerIdByName(object.victim.name)
				ped := getPedById(killerID)
				pedCoord := getPedCoordinates(ped)
					
				if (getDistanceToPoint(getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], pedCoord[1], pedCoord[2], pedCoord[3]) <= 30) {
					killName := object.victim.name
				} else {
					killName := "Unbekannt"
				}
				
				if (getPlayerInteriorId()) {
					killPlace := "in einem Interior (" . getPlayerInteriorId() . ")"
				} else {
					killPlace := "in " . getPlayerZone() . ", " . getPlayerCity()
				}				
				
				IniWrite, % killName, ini/Stats.ini, stats, Victim
				IniWrite, % killFaction, ini/Stats.ini, stats, VictimFaction
				IniWrite, % killWeapon, ini/Stats.ini, stats, VictimWeapon
				IniWrite, % killWeaponShort, ini/Stats.ini, stats, VictimWeaponArt
				IniWrite, % killPlace, ini/Stats.ini, stats, KillPlace
				
				kills ++
				dkills ++
				mkills ++
				
				IniWrite, % kills, ini/stats.ini, Stats, kills
				IniWrite, % dkills, ini/stats.ini, Stats, dkills[%A_DD%:%A_MM%:%A_YYYY%]
				IniWrite, % mkills, ini/stats.ini, Stats, mkills[%A_MM%:%A_YYYY%]
				
				kd := round(kills/deaths, 2)
				if (deaths == 0) {
					kd := kills . ".00"
				}				
				
				dkd := round(dkills/ddeaths, 2)
				if (ddeaths == 0) {
					dkd := dkills . ".00"
				}
				
				mkd := round(mkills/mdeaths, 2)
				if (mdeaths == 0) {
					mkd := mkills . ".00"
				}
	
				SendInfo("DKD: " . cSecond . kd . cWhite . " - MKD: " . cSecond . mkd . cWhite . " - KD: " . cSecond . kd)				
			}
		}
	}
}
return

MainTimer:
{	
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}	
	
	WinGetTitle, spotifytrack, ahk_exe Spotify.exe

	if (!firstStart) {
		firstStart := true 
		
		SendInfo("Keybinder (Version " . csecond . version . cwhite . ") wurde gestartet!")
		SendInfo("Willkommen, " . csecond . username . cwhite . "! Fraktion: " . getFractionName() . ", Rang: " . rank)
	}
	
	if (spotifytrack != oldSpotifyTrack) {
		oldSpotifyTrack := spotifytrack

		if (spotifyPrivacy) {
			SendInfo("Neuer Spotify-Track: " . cgreen . spotifytrack)
		}

		if (spotifyPublic) {
			SendChat("/l Spotify-Track wurde gewechselt: " . spotifytrack)
		}
	}
	
	if (isPlayerInAnyVehicle()) {
		if (oldVehicleName != getVehicleModelName()) {
			oldVehicleName := getVehicleModelName()
		}
		
		if (!isInVehicle) {
			isInVehicle := true
			
			if (infoOvEnabled && getVehicleType() != 6) {
				ov_Info(0)
				ov_Info()
			}	
		}
	} else {
		if (isInVehicle) {
			isInVehicle := false
			
			if (infoOvEnabled && getVehicleType() != 6) {
				ov_Info(0)
				ov_Info()
			}
		}
	}
	
	if (afkInfo) {
		if (!WinExist("GTA:SA:MP")) {
			IsPlayerIngame := false
		} else if (WinExist("GTA:SA:MP")) {
			IsPlayerIngame := true
		}

		if (!WinActive("GTA:SA:MP") || IsPlayerInMenu()) {
			if (IsPlayerIngame) {
				if (IsAFKStart == 0 && IsAFKEnd == 0) {
					IsAFKStart := getUnixTimestamp(A_Now)
				}
			}

			return
		} else {
			if (IsPlayerIngame) {
				if (IsAFKStart > 0 && IsAFKEnd == 0) {
					IsAFKEnd := getUnixTimeStamp(A_Now)

					if ((IsAFKEnd - IsAFKStart) < 300) {
						afkColor := cyellow
					} else if ((IsAFKEnd - IsAFKStart) >= 300 && (IsAFKEnd - IsAFKStart) < 1800) {
						afkColor := corange
					} else if ((IsAFKEnd - IsAFKStart) >= 1800) {
						afkColor := cred
					}

					SendInfo(afkColor . "AFK-Zeit: " . formatTime(IsAFKEnd - IsAFKStart))

					IsAFKStart := 0
					IsAFKEnd := 0
				}
			}
		}
	}
	
	if (refillInfo) {
		if (isPlayerInAnyVehicle() && isPlayerDriver()) {
			if (!updateTextDraws())
				return
			
			oReplace := ["~s~", "~r~", "~w~", "~h~", "~g~", "~y~", "~n~", "~b~", "  ", "   "]
			
			for i, o in oTextDraws {
				Loop % oReplace.MaxIndex() {
					o := StrReplace(o, oReplace[A_Index], " ")
				}
				
				if (RegExMatch(o, "Tank: (\S+)\/(\d+) L", tank_)) {
					if (tank_1 <= 5 && oldTank != Ceil(tank_1)) {
						SoundBeep
						
						SendInfo(csecond . "WARNUNG: Dein Tank ist fast leer, es befinde" . (tank_1 == 1 ? "t" : "n") . " sich nur noch " . tank_1 . " Liter darin.")
						oldTank := Ceil(tank_1)
						break
					}
				} else if (RegExMatch(o, "Tank:  Leer")) {
					SoundBeep
					
					SendInfo("WARNUNG: Dein Tank ist leer, du kannst mit '" . cSecond . "X" . cwhite . "' einen Kanister nutzen.")
					
					KeyWait, X, D, T10
					
					if (!ErrorLevel && !isBlocked()) {
						SendChat("/fillcar")
					}
				}
				
				; SendClientMessage(o)
			}
		}	
	}
	
	if ((getPlayerHealth() + getPlayerArmor()) != healthOld) {
		damage := healthOld - (getPlayerHealth() + getPlayerArmor())
		
		healthOld := (getPlayerHealth() + getPlayerArmor())

		if (damageInfo) {
			if (!tv) {
				if (damage > 5 && !isPaintball ) {
					if (!gotPoisened) {
						SendInfo("Du hast soeben (" . csecond . "-" . damage . cwhite . " HP) verloren (" . cRed getDamageWeapon(damage) . cwhite . "), Aktuelle HP: " . cGreen . (getPlayerHealth() + getPlayerArmor()))
					} else {
						SendInfo("Du hast soeben (" . csecond . "-" . damage . cwhite . " HP) verloren (" . cRed "Giftspritze" . cwhite . "),  Aktuelle HP: " . cGreen . (getPlayerHealth() + getPlayerArmor()))
						gotPoisened := false 
					}
					
					SoundBeep, 500, 250
				}
			}
		}
	}
	
	if (isPlayerAtGasStation() && autoFill) {
		if (fillTimeout_) {
			if (isPlayerInAnyVehicle() && isPlayerDriver() && getVehicleType() != 6) {
				if (isPlayerAtGasStation() == 2) {
					if (getVehicleSpeed() >= 25) {
						if (getVehicleHealth() < 900) {
							SendChat("/fixveh")
						}
					}
				}
					
				if (getVehicleSpeed() <= 25) {
					SendInfo("Möchtest du dein Fahrzeug betanken? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")

					KeyWait, X, D, T10

					if (!ErrorLevel && !isBlocked()) {
						fillTimeout_ := false
						refillCar()
						fillTimeout := 0
					} else {
						fillTimeout_ := true
					}
				}
			}
		}

		if (canisterTimeout_) {
			if (!isPlayerInAnyVehicle()) {
				SendInfo("Möchtest du dir einen Kanister kaufen? Du kanst mit '" . csecond . "X" . cwhite . "' bestätigen!")

				KeyWait, X, D, T10

				if (!ErrorLevel && !isBlocked()) {
					canisterTimeout_ := false
					SendChat("/kanister")
					canisterTimeout := 0
				} else {
					canisterTimeout_ := true
				}
			}
		}
	} else if (isPlayerAtMaut() && autoCustoms) {
		if (mautTimeout_) {
			SendInfo("Möchtest du den Zoll öffnen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")

			KeyWait, X, D, T10

			if (!ErrorLevel && !isBlocked()) {
				mautTimeout_ := false
				openMaut()
				mautTimeout := 0
			} else {
				mautTimeout_ := true
			}
		}
	} else if (isPlayerAtHeal() && autoHeal) {
		if (healTimeout_) {
			if (getPlayerHealth() < 100 || getPlayerArmor() < 100) {
				SendInfo("Möchtest du dich heilen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")

				KeyWait, X, D, T10

				if (!ErrorLevel && !isBlocked()) {
					healTimeout_ := false
					healPlayer()
					healTimeout := 0
				} else {
					healTimeout_ := true
				}
			}
		}
	} else if (isPlayerAtCookPoint() && autoCook) {
		if (cookTimeout_) {
			SendInfo("Möchtest du deine Fische kochen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")

			KeyWait, X, D, T10

			if (!ErrorLevel && !isBlocked()) {
				cookTimeout_ := false
				cookFish()
				cookTimeout := 0
			} else {
				cookTimeout_ := true
			}
		}
	} else if (isPlayerAtLocal() && autoLocal) {
		if (localTimeout_) {
			SendInfo("Möchtest du die Kette einnehmen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")

			KeyWait, X, D, T10

			if (!ErrorLevel && !isBlocked()) {
				localTimeout_ := false
				addLocalToStats()
				localTimeout := 0
			} else {
				localTimeout_ := true
			}
		}
	} else if (isPlayerAtEquip() && autoEquip) {
		if (!hasEquip) {
			if (equipTimeout_) {
				SendInfo("Möchtest du dich ausrüsten? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")
				
				KeyWait, X, D, T10
				
				if (!ErrorLevel && !isBlocked()) {
					equipTimeout_ := false
					
					equipment := ""
					
					Loop, 6 {
						if (profile1_%A_Index% != "") {
							equipment .= " " . profile1_%A_Index%
						}
					}
					
					SendChat("/ausruesten" . equipment)
					Sleep, 250
					
					healPlayer()

					equipTimeout := 0
				} else {
					equipTimeout_ := true
				}
			}
		} else {
			if (healTimeout_) {
				if (getPlayerHealth() < 100 || getPlayerArmor() < 100) {
					SendInfo("Möchtest du dich heilen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen!")
					
					KeyWait, X, D, T10
					
					if (!ErrorLevel && !isBlocked()) {
						healTimeout_ := false
						healPlayer()
						healTimeout := 0
					} else {
						healTimeout_ := true
					}
				}
			}	
		}
	} else if (isPlayerAtJailGate() && autoGate) {
		if (jailgateTimeout_) {
			SendInfo("Möchtest du ins Staatsgefängnis? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
			
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				jailgateTimeout_ := false
				openGate()
				jailgateTimeout := 0
			} else {
				jailgateTimeout_ := true
			}
		}
	} else if (isPlayerAtPDGate() && autoGate) {
		if (gateTimeout_) {
			SendInfo("Möchtest du das Tor öffnen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
			
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				gateTimeout_ := false
				openGate()
				gateTimeout := 0
			} else {
				gateTimeout_ := true
			}
		}
	} else if (isPlayerAtFishPoint() && autoFish) {
		if (fishTimeout_) {
			SendInfo("Möchtest du fischen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
				
			KeyWait, X, D, T10
			
			if (!ErrorLevel && !isBlocked()) {
				fishTimeout_ := false
				startFish()
				fishTimeout := 0
			} else {
				fishTimeout_ := true
			}
		}
	} else if (isPlayerInRangeOfPoint(6.0265, -30.8849, 1003.5494, 5.0) && autoFish) {
		if (fishSellTimeout_) {
			SendInfo("Möchtest du deine Fische verkaufen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
			
			KeyWait, X, D, T10
			
			if (!ErrorLevel && !isBlocked()) {
				fishSellTimeout_ := false 
				sellFish()
				fishSellTimeout := 0
			} else {
				fishSellTimeout_ := true
			}
		}
	}
	
	if (!updateTextLabelData()) {
		return
	}
	
	for i, o in oTextLabelData {
		if (o.PLAYERID == 65535 && o.VEHICLEID == 65535) {
			if (getDistanceBetween(o.XPOS, o.YPOS, o.ZPOS, getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], 2.5)) {
				if (RegExMatch(o.TEXT, "^Mülltonne\nVerwende \/search zum durchsuchen\.$", mull_)) {
					if (getDistanceBetween(o.XPOS, o.YPOS, o.ZPOS, getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], 2.5)) {
						if (garbageTimeout_) {
							SendInfo("Möchtest du die Mülltonne durchsuchen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
							
							KeyWait, X, D, T10
							
							if (!ErrorLevel && !isBlocked()) {
								garbageTimeout_ := false
								SendChat("/search")
								garbageTimeout := 0
							} else {
								garbageTimeout_ := true
							}
						}
					}
				}
			}
		}
	}
}
return

WantedTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (wantedInfo) {
		wantedCopy := wantedPlayers.clone()
		
		for index, entry in wantedCopy {
			wantedID := getPlayerIdByName(entry["name"], true)
			
			if (wantedID == -1) {
				removeFromWanted(entry["name"])
			} else if (entry["countdown"] == 0 || entry["countdown"] < -1) {
				removeFromWanted(entry["name"])
			}
			
			if (entry["countdown"] > 0) {
				entry["countdown"] --
			}
		}	

		if (!updateTextLabelData()) {
			return
		}

		if (RegExMatch(getLabelText(), "\[(\d+)\] (\S+)\nWantedlevel: (\d+)\nGrund: (.+)", label_)) {
			for index, entry in wantedPlayers {
				if (entry["name"] == label_2) {
					if (entry["countdown"] > 0) {
						return
					}
				}
			}
				
			if (label_3 < 5) {
				colorW := cyellow
				colorW2 := 0xFFEE00FF
			} else if (label_3 < 10 && label_3 > 4) {
				colorW := corange
				colorW2 := 0xFF8100FF
			} else if (label_3 >= 10) {
				colorW := cwanted
				colorW2 := 0xFF4000FF
			}
			
			SendInfo(colorW . "Verdächtiger " . label_2 . " (ID: " . getPlayerIdByName(label_2) . ") mit " . label_3 . " Wanteds gesichtet!")

			wantedAlarm := []
			wantedAlarm["name"] := label_2
			wantedAlarm["countdown"] := 120

			wantedPlayers.Push(wantedAlarm)
		}
	} else {
		SetTimer, WantedTimer, off
	}
}
return

SpamTimer:
{		
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	unBlockChatInput()
	SendInfo("Das Antispam System wurde " . cred . "deaktiviert" . cwhite . ".")
	
	SetTimer, SpamTimer, off
}
return

TargetTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (target != "" && targetid != -1) {
		SendInfo("Möchtest du den Spieler suchen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
	
		KeyWait, X, D, T10
	
		if (!ErrorLevel) {
			playerToFind := getFullName(targetid)
			autoFindMode := 2

			findPlayer()
			findInfo(playerToFind)
		}
	}
	
	SetTimer, TargetTimer, off
}
return

WantedIATimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (wantedIA != -1 && wantedIAReason != "" && wantedContracter != -1) {
		SendInfo("Möchtest du dem Spieler Wanteds geben? Du kannst mit '" . cSecond . "X" . cwhite . "' bestätigen.")
		
		KeyWait, X, D, T10
		
		if (!ErrorLevel) {
			if (InStr(wantedIAReason, "entführt mich")) {
				if (giveWanteds(wantedIA, "Entführung eines Staatsbeamten (" . wantedContracter . ")", 4)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Entführng eingetragen!")
				}
			} else if (InStr(wantedIAReason, "begeht eine Verweigerung")) {
				if (giveWanteds(wantedIA, "Verweigerung i.A. " . wantedContracter, 1)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Verweigerung eingetragen!")
				}
			} else if (InStr(wantedIAReason, "versuchte mich zu bestechen")) {
				if (giveWanteds(wantedIA, "Beamtenbestechung i.A. " . wantedContracter, 1)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Beamtenbestechung eingetragen!")
				}
			} else if (InStr(wantedIAReason, "verwendet seine Schlag/Schusswaffen")) {
				if (giveWanteds(wantedIA, "Waffengebrauch i.d.Ö. i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Waffengebrauch i.d.Ö. eingetragen!")
				}
			} else if (InStr(wantedIAReason, "ist nicht im Besitz eines Waffenschein")) {
				if (giveWanteds(wantedIA, "Illegaler Waffenbesitz i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " illegaler Waffenbesitz eingetragen!")
				}
			} else if (InStr(wantedIAReason, "hat ein Unbrechtigtes Fahrzeug/Gelände")) {
				if (giveWanteds(wantedIA, "Unautorisiertes Betreten i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Einbruch eingetragen!")
				}
			} else if (InStr(wantedIAReason, "Behindert die Justiz")) {
				if (giveWanteds(wantedIA, "Behinderung der Justiz i.A. " . wantedContracter, 1)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Behinderung der Justiz eingetragen!")
				}
			} else if (InStr(wantedIAReason, "begeht einen Angriff / Beschuss")) {
				if (giveWanteds(wantedIA, "Angriff/Beschuss i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Angriff/Beschuss eingetragen!")
				}
			} else if (InStr(wantedIAReason, "Materialien")) {
				if (giveWanteds(wantedIA, "Besitz von Materialien i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Besitz von Materialien eingetragen!")
				}
			} else if (InStr(wantedIAReason, "Drogen")) {
				if (giveWanteds(wantedIA, "Besitz von Drogen i.A. " . wantedContracter, 2)) {
					SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Besitz von Drogen eingetragen!")
				}
			}
		}
	}
	
	SetTimer, WantedIATimer, off
}
return

HelloTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (loginName != -1) {
		SendInfo("Möchtest du " . csecond . loginName . cwhite . " begrüßen? Du kannst mit '" . cSecond . "X" . cwhite . "' bestätigen.")
		
		KeyWait, X, D, T10
		
		if (!ErrorLevel && !isInChat()) {
			Random tmp, 1, 3
			
			if (tmp == 1) {
				SendChat("/f Sei gegrüßt, " . loginName . "!")
				loginName := -1
			} else if (tmp == 2) {
				SendChat("/f Hallo, " . loginName . "!")
				loginName := -1
			} else if (tmp == 3) {
				SendChat("/f Guten Tag, " . loginName . "!")
				loginName := -1
			}
			
			; BEARBEITEN -> MEHR SPRACHEN WUNSCH DER MEMBER
		}
	}
	
	SetTimer, HelloTimer, off
}
return

PaketTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	SendInfo(csecond . medicName . cwhite . " bietet dir ein Paket an, drücke '" . csecond . "X" . cwhite . "' zum Annehmen.")
	
	KeyWait, X, D, T10
	
	if (!ErrorLevel) {
		SendChat("/accept paket")
		
		Sleep, 200
		
		if (RegExMatch(readChatLine(0) . readChatLine(1) . readChatLine(2), "Du hast bereits ein Erste-Hilfe-Paket\. Verwende \/erstehilfe")) {
			if (paketInfo) {
				SendChat("/l Vielen Dank " . medicName . ", doch ich habe bereits ein Paket!")
			}
		} else if (RegExMatch(readChatLine(0) . readChatLine(1) . readChatLine(2), "\* Du hast für \$(\d+) ein Erste-Hilfe-Paket von (\S+) gekauft\.", chat_)) {
			if (paketInfo) {
				SendChat("/l Vielen Dank " . chat_2 . " für das Erste-Hilfe-Paket!")
			}
		}
	}
	
	SetTimer, PaketTimer, off
}
return

PartnerOverlayTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	regPartners := 0
	partnerString := ""
	
	for index, partner_ in partners {
		if (getFullName(partner_)) {
			regPartners ++
		}
	}
	
	partnerString .= "=== Diensteinheit (" . regPartners . ") ===`n"
	
	if (partnerOv) {
		for index, partner_ in partners {
			if (getFullName(partner_) != "") {
				partnerString .= "Partner " . index . ": " . partner_ . " [ID: " . getPlayerIdByName(partner_) . "]`n"
			}
		}
		
		textSetString(ov_Partner, partnerString)
	} else {
		SetTimer, PartnerOverlayTimer, off
	}
}
return

AlertOverlayTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (alertOv) {
		alertString := ""
		alertActive := false
		
		for index, entry in outbreaks {
			if (entry["countdown"] > 0) {		
				alertActive := true
			}
		}
		
		for index, entry in bankrobs {
			if (entry["countdown"] > 0) {	
				alertActive := true
			}
		}
		
		for index, entry in storerobs {
			if (entry["countdown"] > 0) {	
				alertActive := true
			}
		}
		
		for index, entry in backups {
			if (entry["countdown"] > 0) {
				alertActive := true
			}
		}
		
		if (alertActive) {
			alertString .= getFractionName() . " - Alarm:`n"
		}			
		
		for index, entry in outbreaks {
			if (entry["countdown"] > 0) {			
				alertString .= "[" . entry["time"] . "] Ausbruch " cOrange . entry["count"] . cWhite . ": noch " . cOrange . formatTime(entry["countdown"]) . cWhite . "`n"
			}
		}
		
		for index, entry in bankrobs {
			if (entry["countdown"] > 0) {
				alertString .= "[" . entry["time"] . "] Bankueberfall: noch " . cOrange . formatTime(entry["countdown"]) . cWhite . " in " . cOrange . entry["place"] . cWhite . "`n"
			}
		}
		
		for index, entry in storerobs {
			if (entry["countdown"] > 0) {
				alertString .= "[" . entry["time"] . "] Raubueberfall: noch " . cOrange . formatTime(entry["countdown"]) . cWhite . " in GK " . cOrange . entry["location"] . cWhite . " (" . entry["name"] . " - ID: " . getPlayerIdByName(entry["name"]) . ")`n"
			}
		}	

		for index, entry in backups {
			if (entry["countdown"] > 0) {
				alertString .= "[" . entry["time"] . "] Backup: noch " . cRed . formatTime(entry["countdown"]) . cWhite . " in " . cRed . entry["place"] . cWhite . " (" . entry["name"] . " - ID: " . getPlayerIdByName(entry["name"]) . ")`n"
			}
		}
		
		textSetString(ov_Alert, alertString)
	}
}
return

PingOverlayTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (pingOv) {	
		playerFPS := getPlayerFPS()
		playerPing := getPlayerPingById(getID())
		
		pingString := ""
		
		if (pingAlertColorOn) {
			if (playerPing < 50) {
				pColor := cGreen
			} else if (playerPing >= 50 && playerPing <= 90) {
				pColor := cOranage
			} else if (playerPing > 90) {
				pColor := cRed
			}
			
			if (playerFPS >= 60) {
				fColor := cGreen
			} else if (playerFPS > 30 && playerFPS < 60) {
				fColor := cOrange
			} else if (playerFPS < 30) {
				fColor := cRed
			}
		}
		
		if (pingAlertColorOn) {
			pingString :=  "FPS: " . fColor . playerFPS . "{" . pingColor . "} | Ping: " . pColor . playerPing
		} else {
			pingString :=  "FPS: " . playerFPS . " | Ping: " . playerPing
		}
		
		textSetString(ov_ping, pingString)
	}
}
return

SpotifyOverlayTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (spotifyOv) {
		spotifyString := ""
		
		if (spotifyColorOn) {
			songColor := "{" . spotifySongColor . "}"
			spotifyString := "Spotify: " . songColor . spotifytrack
			textSetString(ov_spotify, spotifyString)
		} else {
			spotifyString := "Spotify: " . spotifytrack
			textSetString(ov_spotify, spotifyString)
		}
	} else {
		ov_Spotify(0)
		SetTimer, SpotifyOverlayTimer, off
	}
}
return

CooldownOverlayTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}	
	
	if (cooldownOv) {
		cooldownString := ""
		cooldownsRunning := false 
		
		if (fishcooldown) {
			cooldownsRunning := true
			cooldownString .= "Angeln: " . formatTime(fishcooldown) . "`n"
		}
		
		if (pakcooldown) {
			cooldownsRunning := true
			cooldownString .= "Erste-Hilfe-Paket: " . formatTime(pakcooldown) . "`n"		
		}
		
		if (healcooldown) {
			cooldownsRunning := true
			cooldownString .= "Heilen: " . formatTime(healcooldown) . "`n"
		}
		
		if (drugcooldown) {
			cooldownsRunning := true
			cooldownString .= "Drogen: " . formatTime(drugcooldown) . "`n"
		} 
		
		if (admincooldown) {
			cooldownsRunning := true
			cooldownString .= "Admin-Chat: " . formatTime(admincooldown) . "`n"
		}

		if (ooccooldown) {
			cooldownsRunning := true
			cooldownString .= "OOC-Chat: " . formatTime(ooccooldown) . "`n"
		} 
		
		textSetString(ov_Cooldown, cooldownString)
	} else {
		SetTimer, CooldownOverlayTimer, off
	}
}
return


PartnerMoneyTimer:
{	
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	payPartnerMoney(totalArrestMoney, "arrest_money")
	
	totalArrestMoney := 0
	
	SetTimer, PartnerMoneyTimer, off
}
return

ShotAllowedCar:
{
	SendInfo("Du darfst nun das Fahrzeug beschießen, sofern der Verbrecher flüchtet.")
	
	SetTimer, ShotAllowedCar, off
}
return

ShotAllowedBike:
{
	SendInfo("Du darfst nun das Zweirad beschießen, sofern der Verbrecher flüchtet.")

	SetTimer, ShotAllowedBike, off
}
return

TazerAllowed:
{
	SendInfo("Du darfst den Verbrecher nun Tazern oder Handschellen anlegen. " . csecond . "(Ausnahme: Kampfsituation)")
	
	SetTimer, TazerAllowed, off
}
return

UncuffTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (autoUncuff) {
		if (IsPlayerInAnyVehicle()) {
			if (IsPlayerDriver()) {
				if (getVehicleHealth() < 250) {
					SendInfo("Möchtest du alle Personen im Fahrzeug entcuffen? Drücke '" . csecond . "X" . cwhite . "' zum Bestätigen.")
					
					KeyWait, X, D, T5
					
					if (!ErrorLevel || isBlocked()) {
						passenger := GetSeatIDs()
						passenger_length := passenger.MaxIndex()

						Loop, %passenger_length% {
							if (passenger[A_Index] != -1) {
								SendChat("/uncuff " . passenger[A_Index])
							}
						}
					}
				}
			}
		}
	} else {
		SetTimer, UncuffTimer, off
	}
}
return

LottoTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	if (autoLotto) {
		if (A_Min == 0 && A_Hour != oldHour) {
			SendChat("/lotto")
			
			if (getUserName() == "jacob.tremblay" || getUserName() == "Jaden.") {
				oldHour := A_Hour
			
				if (!lottoNumber) {
					Random, randomNumber, 1, 100
					
					SendChat("/lotto " . randomNumber)
				} else if (lottoNumber > 100) {
					SendChat("/lotto " . getId())
				} else {
					SendChat("/lotto " . lottoNumber)
				}					
			} else {
				SendInfo("Möchtest du dir ein Lottoticket kaufen? Du kannst mit '" . csecond . "X" . cwhite . "' bestätigen.")
				
				oldHour := A_Hour
				
				KeyWait, X, D, T10
				
				if (!ErrorLevel && !isInChat() && !IsDialogOpen() && !IsPlayerInMenu()) {
					if (!lottoNumber) {
						Random, randomNumber, 1, 100
						
						SendChat("/lotto " . randomNumber)
					} else if (lottoNumber > 100) {
						SendChat("/lotto " . getId())
					} else {
						SendChat("/lotto " . lottoNumber)
					}
				}			
			}
		}
	} else {
		SetTimer, LottoTimer, off
	}
}
return

AutoFindTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}	
	
	if (autoFindMode == 1) {
		SendChat("/find " . playerToFind)
	} else if (autoFindMode == 2) {
		if (showDriver) {
			passengers := getSeatIDs()
			
			if (passengers) {
				driver := passengers[1]
				
				if (driver == -1) {
					return
				}
				
				showP := driver
			} else {
				return
			}
		} else {
			if (playerToShowTo == "") {
				return
			} else {
				showP := playerToShowTo
			}
		}
		
		SendChat("/showpos " . showP . " " . playerToFind)
	} else {
		return
	}
	
	Sleep, 250
	
	adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
	cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
	
	if (InStr(cText, "Handy aus")) {
		return
	}
	
	if (getDistanceBetween(coordsFromRedmarker()[1], coordsFromRedmarker()[2], coordsFromRedmarker()[3], 1163.2358, -1323.2552, 15.3945, 5)) {
		setChatLine(readChatLine(0), prefix . getFullName(playerToFind) . " befindet sich im " . cred . "Krankenhaus" . cwhite . ".")
	}
}
return

CountdownTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}	
	
	if (cdTime == 0) {
		SendChat("/" . cdChat . " " . cdGoMessage)
		SetTimer, CountdownTimer, Off
		
		countdownRunning := 0
		
		if (cdGoMessage == "Letzte Warnung!") {
			Sleep, 3000
			SendInfo("Freigabe erhalten.")
		}
		
		return
	}
	
	SendChat("/" . cdChat . " << " . cdTime . " >>")
	
	cdTime--
}
return

TicketTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG()) {
		return
	}		
	
	chat := readChatLine(0)
	
	if (chat == oldchat) {
		return
	} else {
		oldchat := chat
	}
	
	if (RegExMatch(chat, "Du hast das Ticket von (\S+) (.+).", var)) {
		if (var2 == "geschlossen") {
			saveTicket(var1)
		} else if (var2 == "zurückgelegt") {
			saveTicket(var1)
		}
	} else if (RegExMatch(chat, "(\S+) hat den Server verlassen. Das Ticket wurde geschlossen!", var)) {
		saveTicket(var1)
	} else if (RegExMatch(chat, "(\S+) wurde gekickt/gebannt. Das Ticket wurde geschlossen!", var)) {
		saveTicket(var1)
	} else if (RegExMatch(chat, "(\S+) hat ein Timeout. Das Ticket wurde geschlossen!", var)) {
		saveTicket(var1)
	}
}
return

RespawnCarTimer:
{
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected() || !isConnectedToRPG() || !admin) {
		return
	}	

	if (racTime == 0) {
		SendChat("/rac")
		SendChat("/rac")
		
		SendChat("/announce | - Es wurden alle (unbenutzten) Fahrzeuge respawnt, das Team wünscht euch weiterhin viel Spaß! - |")
		
		SetTimer, RespawnCarTimer, Off
		
		respawnCarsRunning := false
	} else {
		if (Mod(racTime, 15) == 0 || racTime == 10 || racTime == 5) {
			SendChat("/announce | -  Fahrzeug-Respawnt: " . racTime . " Sekunden! - |")
		}
	}
	
	racTime--
}
return

StopwatchTimer:
{
	stopwatchTime ++
}
return

DeathArrestTimer:
{
	deathArrested := false
}
return

findPlayer() {
	global
	
	if (showDriver) {
		passengers := getSeatIDs()
		
		if (passengers) {
			driver := passengers[1]
			
			if (driver == -1 || driver == getId()) {
				autoFindMode := 1
			} else {
				autoFindMode := 2
			}
		} else {
			if (playerToShowTo == "") {
				autoFindMode := 1
			} else {
				autoFindMode := 2
			}
		}
	} else if (autoFindMode == 0) {
		autoFindMode := 1
	}
	
	GoSub, AutoFindTimer
	SetTimer, AutoFindTimer, 5500
	
	if (showDriver && autoFindMode == 2) {
		passengers := getSeatIDs()
		
		if (passengers) {
			driver := passengers[1]
			
			if (driver == -1) {
				driver := "niemand"
			} else {
				driver := getFullName(driver)
			}
		}
	}
}

findInfo(name) {
	global 
	
	player := getFullName(name)
	playerID := getPlayerIdByName(player)
	playerScore := getPlayerScoreById(playerID)
	
	SendInfo("Die Suche nach " . player . " (ID: " . playerID . ") wurde gestartet.")
	Sleep, 200
	
	SendChat("/mdc " . player)
}

closeTicket(ticketID) {
	farewell := ""
	
	if ((A_WDay == 6 && A_Hour > 12) || A_WDay == 7 || (A_WDay == 1 && A_Hour < 12)) {
		farewell := " und ein schönes Wochenende"
	} else {
		if (A_Hour >= 0 && A_Hour <= 10) {
			farewell := " und einen angenehmen Morgen"
		} else if (A_Hour >= 11 && A_Hour <= 17) {
			farewell := " und einen schönen Tag"
		} else if (A_Hour >= 18 && A_Hour <= 23) {
			farewell := " und einen angenehmen Abend"
		}
	}
	
	SendChat("/aw " . ticketID . " Ich wünsche Dir noch viel Spaß auf GTA-City " . farewell . ".")	
	SendChat("/aw " . ticketID . " Sollte noch etwas sein, kannst Du dich gerne wieder über das Ticket-System melden!")
	
	Sleep, 200

	if (InStr(readChatLine(0), "Dieses Ticket wurde nicht erstellt.") || InStr(readChatLine(0), "Du bearbeitest dieses Ticket nicht.")) {
		return
	}
	
	SendChat("/dt " . ticketID)
}

acceptTicket(ticketID) {
	name := ""
	greeting := "Guten Tag"
	
	if (A_Hour >= 0 && A_Hour <= 10) {
		greeting := "Guten Morgen"
	} else if (A_Hour >= 11 && A_Hour <= 17) {
		greeting := "Guten Tag"
	} else if (A_Hour >= 18 && A_Hour <= 23) {
		greeting := "Guten Abend"
	} else {
		greeting := "Hallo"
	}
	
	SendChat("/tt " . ticketID)
	
	Sleep, 200
		
	if (RegExMatch(readChatLine(0), "Dieses Ticket wird bereits bearbeitet.") || RegExMatch(readChatLine(0), "Dieses Ticket wurde nicht erstellt.")) {
		return
	} else if (RegExMatch(readChatLine(0), "\(\( Ticket (\d+) (\S+): (.*) \)\)", var)) {
		name := var2
	} else if (RegExMatch(readChatLine(0), "\.\.\.(.*) \)\)", var)) {		
		if (RegExMatch(readChatLine(1), "\(\( Ticket (\d+) (\S+): (.*)\.\.\.", var_)) {
			name := var_2
		}
	}
	
	if (name != "") {
		greeting .= ", " . name
	}
	
	Sleep, 200
	
	SendChat("/aw " . ticketID . " " . greeting . "!")
	SendChat("/aw " . ticketID . " Du sprichst mit " . getUsername() . ", ich bin für Deine Fragen und Problemen offen!")
}

saveTicket(name) {
	
	ticketID := 0
	
	if (name is number) {
		ticketID := name
	} else {
		Loop 15
		{
			if (sup_name_%A_Index% == name) {
				ticketID := A_Index
				break
			}
		}
	}
	
	if (ticketID > 0) {
		IniRead, daytickets, Tickets.ini, Ticketzähler, daytickets[%A_DD%:%A_MM%:%A_YYYY%]
		daytickets ++
		IniWrite, %daytickets%, Tickets.ini, Ticketzähler, daytickets[%A_DD%:%A_MM%:%A_YYYY%]
		
		IniRead, gestickets, Tickets.ini, Gesamt, gestickets, 0
		gestickets ++
		IniWrite, %gestickets%, Tickets.ini, Gesamt, gestickets
		
		IniRead, monthtickets, Tickets.ini, Monat, monthtickets[%A_MM%:%A_YYYY%]
		monthtickets ++
		IniWrite, %monthtickets%, Tickets.ini, Monat, monthtickets[%A_MM%:%A_YYYY%]
				
		if (gestickets < 10) {
			str_ticketID := "0000" . gestickets
		} else if (gestickets < 100) {
			str_ticketID := "000" . gestickets
		} else if (gestickets < 1000) {
			str_ticketID := "00" . gestickets
		} else if (gestickets < 10000) {
			str_ticketID := "0" . gestickets
		} else {
			str_ticketID := gestickets
		}
		
		SendInfo("Tickets bearbeitet: " . cSecond . formatNumber(gestickets) . cwhite . " | Heute: " . cSecond . daytickets . cwhite . " | Monat: " . cSecond . formatNumber(monthtickets))
	}
}
return

checkHealMessage() {
	global healcooldown
	
	Loop, 5 {	
		if (InStr(readChatLine(A_Index - 1), "* " . getUserName() . " hat die Gesundheit regeneriert.")) {
			healcooldown := 60
			
			Sleep, 200
			break
		}
	}
}

stopFinding(key = 0) {
	if (autoFindMode > 0) {
		SetTimer, AutoFindTimer, Off
		
		stoppedAnything := true
		
		autoFindMode := 0
		playerToFind := ""
		playerToShowTo := ""
		
		if (key) {
			SendInfo("Das automatische Suchen wurde beendet.")
		}
	}
}

utf8toansi(string) {
	FileAppend, %string%, conv.txt
	FileRead, UTF, *P65001 conv.txt
	FileDelete, conv.txt
	return UTF
}

/*
createText(id) {
	global
	
	if (id == 1) {
		armour := getPlayerArmor()
		
		if (armour <= 1) {
			armour := "_"
		}
		
		hpText := createTextDraw(getTextDrawColor(hpTextColor) . getPlayerHealth(), hpTextPosX, hpTextPosY, 0xFFFFFFFF, hpTextFont, hpTextFontSize, hpTextFontSize * 3)
		armourText := createTextDraw(getTextDrawColor(armourTextColor) . armour, armourTextPosX, armourTextPosY, 0xFFFFFFFF, hpTextFont, hpTextFontSize, hpTextFontSize * 3)
		
		SetTimer, HealthTextDrawTimer, 500
	} else if (id == 3) {
		fpsText := createTextDraw(getTextDrawColor(fpsTextColor) . getFPS(), fpsTextPosX, fpsTextPosY, 0xFFFFFFFF, fpsTextFont, fpsTextFontSize, fpsTextFontSize * 3)
		
		SetTimer, FPSTextDrawTimer, 500
	}
}

updateText(id) {
	global
	
	if (id == 1) {
		if (hpText != -1) {
			moveTextDraw(hpText, hpTextPosX, hpTextPosY)
		}
	} else if (id == 2) {
		if (armourText != -1) {
			moveTextDraw(armourText, armourTextPosX, armourTextPosY)
		}
	} else if (id == 3) {
		if (fpsText != -1) {
			moveTextDraw(fpsText, fpsTextPosX, fpsTextPosY)
		}
	}
}

getTextDrawColor(id) {
	color := ""
	
	if (id == 1) {
		color := "~w~"
	} else if (id == 2) {
		color := "~l~"
	} else if (id == 3) {
		color := "~r~"
	} else if (id == 4) {
		color := "~g~"
	} else if (id == 5) {
		color := "~b~"
	} else if (id == 6) {
		color := "~y~"
	} else if (id == 7) {
		color := "~p~"
	}
	
	return color
}
*/

ownHotkey(id) {
	global
	
	if (isInChat() || isDialogOpen() || !ownHotkey%id%Active || ownHotkey%id%Text == "") {
		return
	}
	
	chatActionsArray := StrSplit(ownHotkey%id%Text, "`n")
	
	Loop % chatActionsArray.MaxIndex() {
		sendLine(chatActionsArray[A_Index])
	}
}

sendLine(line, local := false) {
	IniRead, fishcooldown, ini/Settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, ini/Settings.ini, Cooldown, pakcooldown, 0
	
	line := StrReplace(line, "[name]", getUsername())
	line := StrReplace(line, "[id]", getId())
	line := StrReplace(line, "[ping]", getPlayerPingById(getId()))
	line := StrReplace(line, "[fps]", getPlayerFps())
	line := StrReplace(line, "[zone]", getPlayerZone())
	line := StrReplace(line, "[city]", getPlayerCity())
	line := StrReplace(line, "[location]", getLocation())
	line := StrReplace(line, "[hp]", getPlayerHealth())
	line := StrReplace(line, "[armour]", getPlayerArmor())
	line := StrReplace(line, "[money]", formatNumber(getPlayerMoney()))
	line := StrReplace(line, "[skin]", getPlayerSkinId())
	line := StrReplace(line, "[weaponid]", getPlayerWeaponId())
	line := StrReplace(line, "[weapon]", getPlayerWeaponName())
	line := StrReplace(line, "[freezed]", (IsPlayerFreezed() ? "ja" : "nein"))
	line := StrReplace(line, "[vhealth]", getVehicleHealth())
	line := StrReplace(line, "[vmodelid]", getVehicleModelId())
	line := StrReplace(line, "[vmodel]", getVehicleModelName())
	line := StrReplace(line, "[vspeed]", round(getVehicleSpeed()))
	line := StrReplace(line, "[fishtime]", formatTime(fishcooldown))
	line := StrReplace(line, "[pakettime]", formatTime(pakcooldown))
	
	if (RegExMatch(line, "(.*)\[sleep (\d+)\](.*)", line_)) {
		if (line_1 != "")
			sendLine(line_1, local)
		
		Sleep, %line_2%
		
		if (line_3 != "")
			sendLine(line_3, local)
	} else if (RegExMatch(line, "(.*)\[local\](.*)", line_)) {
		if (line_1 != "")
			sendLine(line_1, local)
		
		if (line_2 != "")
			sendLine(line_2, true)
	} else if (RegExMatch(line, "(.*)\[usepak\](.*)", line_)) {
		if (line_1 != "")
			sendLine(line_1, local)
		
		GoSub, firstAidLabel
		
		if (line_2 != "")
			sendLine(line_2, local)
	} else if (RegExMatch(line, "(.*)\[eatfish\](.*)", line_)) {
		if (line_1 != "")
			sendLine(line_1, local)
		
		GoSub, eatFishLabel
		
		if (line_2 != "")
			sendLine(line_2, local)
	} else if (RegExMatch(line, "(.*)\[motor\](.*)", line_)) {
		if (line_1 != "")
			sendLine(line_1, local)
		
		GoSub, motorSystemLabel
		
		if (line_2 != "")
			sendLine(line_2, local)
	} else {
		if (local) {
			SendInfo(line)
		} else {
			SendChat(line)
		}
	}
}

removeFromWanted(name) {
	global wantedPlayers
	
	indexToRemove := -1
	
	for index, entry in wantedPlayers {
		if (entry["name"] == name) {
			indexToRemove := index
		}
	}
	
	if (indexToRemove != -1) {
		wantedPlayers.RemoveAt(indexToRemove)
		return removeFromWanted(name) + 1
	} else {
		return 0
	}
}

giveWanteds(suspect, reason, amount) {	
	global username
	global password	
	
	suspect := getFullName(suspect)
		
	FormatTime, time, , HH:mm
    result := URLDownloadToVar(baseURL . "api/catalog-new?username=" . username . "&password=" . password . "&type=wanteds&suspect=" . suspect . "&reason=" . reason)
	
    try {
        data := JSON.Load(result)
    } catch {
        SendError("Es ist ein Scriptinterner Fehler aufgetreten.")
        return false
    }
    
    if (data["error"] != "") {
        SendError("" . data["error"])
    } else {
        if (!data["registered"]) {
			SendInfo("" . cSecond . "~~~ ~~~ ~~~ " . cWhite . "Sperre" . cSecond . " ~~~ ~~~ ~~~")
			SendInfo(cSecond . suspect . colorWhite . " hat bereits Wanteds aus diesem Grund erhalten.")
			SendInfo("Ausgestellt von " . data["lastoffical"] . " um " . data["time"] . " Uhr.")
			SendInfo("Möchtest du die Wanteds vergeben? Du kannst mit '" . cSecond . "X" . cWhite . "' bestätigen.")			
            
            KeyWait, X, D, T10
            
            if (ErrorLevel) {
                return false
            }
        }
	
		Loop %amount% {
			SendChat("/suspect " . suspect . " " . reason . " - Uhr: " . time)
		}
		
		Sleep, 200
		
		suspectLine0 := readChatLine(0)
		suspectLine1 := readChatLine(1)
		
		if (inStr(suspectLine0 . suspectLine1, "Du kannst Beamte keine Wanteds eintrragen.") || InStr(suspectLine0 . suspectLine1, "Der Spieler befindet sich im Gefängnis.")) {
			return false
		}
		
		wanteds := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=wanteds&value=" . numberFormat(amount))
		IniWrite, %wanteds%, ini/Stats.ini, Vergaben, Wanteds
		
		SendInfo("Du hast bereits " . csecond . formatNumber(wanteds) . cwhite . " Wanteds vergeben.")
		return true
	}
	
	return false 
}

givePoints(suspect, reason, amount, extra := "") {
	global username
	global password	
	
	suspect := getFullName(suspect)
	
	result := URLDownloadToVar(baseURL . "api/catalog-new?username=" . username . "&password=" . password . "&type=points&suspect=" . suspect . "&reason=" . reason)
	
    try {
        data := JSON.Load(result)
    } catch {
        SendError("Es ist ein Scriptinterner Fehler aufgetreten.")
        return false
    }
    
    if (data["error"] != "") {
        SendError("" . data["error"])
    } else {
		 if (!data["registered"]) {
			SendInfo("" . cSecond . "~~~ ~~~ ~~~ " . cWhite . "Sperre" . cSecond . " ~~~ ~~~ ~~~")
			SendInfo(cSecond . suspect . colorWhite . " hat bereits Punkte aus diesem Grund erhalten.")
			SendInfo("Ausgestellt von " . data["lastoffical"] . " um " . data["time"] . " Uhr.")
			SendInfo("Möchtest du die Punkte vergeben? Du kannst mit '" . cSecond . "X" . cWhite . "' bestätigen.")					
			
            KeyWait, X, D, T10
            
            if (ErrorLevel) {
                return false
            }
        }
		SendChat("/punkte " . suspect . " " . amount . " " . reason . extra)
	
		Sleep, 200
		
		pointsLine0 := readChatLine(0)
		pointsLine1 := readChatLine(1)
		
		if (InStr(pointsLine0 . pointsLine1, "Du kannst dir keine Punkte geben.")) {
			return false
		}
		
		points := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=points&value=" . numberFormat(amount))
		IniWrite, %points%, ini/Stats.ini, Vergaben, Points
		
		SendInfo("Du hast bereits " . csecond . formatNumber(points) . cwhite . " Punkte vergeben.")
		return true
	}
	return false
}

giveTicket(player, money, reason) {
	global
	
	if (lastTicketReason == reason && lastTicketPlayer == player) {
		currentTicket ++
	} else {
		currentTicket := 1
		maxTickets := Ceil(money / 10000)
	}
	
	currentTicketMoney := money
	lastTicketPlayer := player
	lastTicketReason := reason
	
	if (currentTicketMoney > 10000) {
		currentMoney := 10000
		currentTicketMoney -= 10000
		
		SendInfo("Für das nächste Ticket, Verwende: " . cSecond . "/nt")
	} else {
		currentMoney := currentTicketMoney
		currentTicketMoney := 0
	}
	
	if (maxTickets == 1) {
		reason .= " (" . currentTicket . "/" . maxTickets . ")"
	}
	
	SendChat("/ticket " . player . " " . currentMoney . " " . reason)
}

payPartnerMoney(money, stat) {
	global username
	global password
		
	IniRead, paydayMoney, ini/Stats.ini, stats, paydayMoney, 0
		
	paydayMoney += money
	partnerStake := round(money / (partners.Length() + 1), 0)
	
	IniWrite, %paydayMoney%, ini/Stats.ini, stats, paydayMoney
	IniRead, statMoney, ini/Stats.ini, Verhaftungen, Money, 0

	statMoney := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=" . stat . "&value=" . numberFormat(partnerStake))
	
	if (stat == "arrest_money") {
		IniWrite, %statMoney%, ini/Stats.ini, Verhaftungen, Money
		SendInfo("Du hast bereits $" . csecond . formatNumber(statMoney) . cwhite . " durch Verhaftungen verdient.")
	} else if (stat == "ticket_money") {
		IniWrite, %statMoney%, ini/Stats.ini, Tickets, Money
		SendInfo("Du hast bereits $" . csecond . formatNumber(statMoney) . cwhite . " durch Tickets verdient.")
	} 
	/*else if (stat == "plants_money") {
		IniWrite, %statMoney%, ini/Stats.ini, Marihuana, Money
		SendInfo("Du hast bereits $" . csecond . formatNumber(statMoney) . cwhite . " durch Marihuana-Pflanzen verdient.")
	}	
	*/
	
	indexRemove := -1
	
	for index, value in partners {
		if (getFullName(value) != -1) {
			playerID := getPlayerIdByName(value)
			ped := getPedById(playerID)
			pedCoord := getPedCoordinates(ped)
			
			if (getDistanceToPoint(getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], pedCoord[1], pedCoord[2], pedCoord[3]) <= 5.0) {
				SendChat("/pay " . value . " " . partnerStake)
			} else {
				SendInfo(cSecond . getFullName(value) . cWhite . " ist nicht in der Nähe, du musst ihm $" . cSecond . formatNumber(partnerStake) . cWhite . " geben.")
			}
		} else {
			indexRemove := index
		}
	}
	
	if (indexRemove != -1) {
		partners.RemoveAt(indexRemove)
	}		
}

cookFish() {
	global
	
	if (!getPlayerInteriorId()) {
		IniRead, campfire, ini/Settings.ini, Items, campfire, 0
		
		if (campfire) {
			SendChat("/campfire")
			Sleep, 200
		} 
					
		Loop, 5 {
			SendChat("/cook fish " . A_Index)
			Sleep, 650
		}			
	} else {
		if (isPlayerAtCookPoint()) {
			Loop, 5 {
				SendChat("/cook fish " . A_Index)
				Sleep, 650
			}	
		} else {
			SendInfo("Du kannst hier nicht kochen.")
		}
	}
	
	Sleep, 200
	checkCook()
}

sellFish() {
	global 
		
	sellFishMoney := 0
	
	Loop, 5 {
		SendChat("/sell fish " . A_Index)
		
		Sleep, 200
	
		chat := readChatLine(0)
		
		if (RegExMatch(chat, "Du hast deinen (.+) \((\d+) LBS\) für (\d+)\$ verkauft.", chat_)) {
			sellFishMoney += numberFormat(chat_3)
		}
		
		if (!admin) {
			Sleep, 500 
		}
	}
	
	Fishmoney:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=fish_money&value=" . numberFormat(sellFishMoney))
	IniWrite, %Fishmoney%, ini/Stats.ini, Allgemein, Fishmoney
	
	SendInfo("Du hast für deine Fische $" . csecond . formatNumber(sellFishMoney) . cwhite . " erhalten.")
	SendInfo("Gesamt hast du bereits $" . csecond . formatNumber(fishmoney) . cwhite . " durch Fische verdient.")
}

startFish() {
	global
	
	IniRead, fishcooldown, ini/Settings.ini, Cooldown, fishcooldown, 0
	
	if (isPlayerAtFishPoint()) {
		if (!fishcooldown) {
			fishNumber := 0
			aFishMoney := 0
			aFishHP := 0
			
			cheapestFish := -1
			cheapestFishName := ""
			cheapestFishValue := 100000
			cheapestFishMoney := 100000
			cheapestFishHP := 100000
			
			thrownAway := false
			attempt := 1
			
			Loop {
				SendChat("/fish")
				
				Sleep, 200
				
				fishing := readChatLine(0)
				
				if (RegExMatch(fishing, "Du hast ein\/e (.+) mit (\d+) LBS gefangen.", fishing_)) {
					fishNumber ++
					
					currentFishMoney := getFishValue(fishing_1, fishing_2)
					currentFishHealth := Floor(fishing_2 * 0.3)
					
					if (fishMode) {
						fishValue := currentFishMoney
					} else {
						fishValue := fishing_2
					}
					
					SendInfo(csecond . fishNumber . cwhite . ": " . fishing_1 . " LBS: " . csecond . fishing_2 . cwhite . " | Preis: $" . csecond . formatNumber(currentFishMoney) . cwhite . " | HP: " . csecond . currentFishHealth)
					
					aFishMoney += numberFormat(currentFishMoney)
					aFishHP += fishing_2
					
					if (cheapestFishValue > fishValue) {
						cheapestFish := fishNumber
						cheapestFishName := fishing_1
						cheapestFishValue := fishValue
						cheapestFishMoney := currentFishMoney
						cheapestFishHP := fishing_2
					}
				} else if (RegExMatch(fishing, "Du kannst nur 5 Fische bei dir tragen.")) {
					if (cheapestFish == -1) {
						SendInfo("Du musst deine Fische erst verkaufen!")
						break
					}
					
					if (thrownAway)
						break
					
					aFishMoney -= cheapestFishMoney
					aFishHP -= cheapestFishHP
					
					SendChat("/releasefish " . cheapestFish)
					Sleep, 200
					
					if (fishMode)  {
						SendInfo(cscond . cheapestFishName . cWhite . ": " . cheapestFish . cwhite . " im Wert von $" . csecond . formatNumber(cheapestFishValue) . cwhite . " weggeworfen")
					} else {
						SendInfo(cscond . cheapestFishName . cWhite . ": " . cheapestFish . cwhite . " mit " . csecond . formatNumber(cheapestFishValue) . cwhite . " LBS weggeworfen")
					}
					
					thrownAway := true
				} else if (RegExMatch(fishing, "Du bist an keinem Angelplatz \(Big Wheel Rods\) oder an einem Fischerboot!")) {
					if (attempt == 3) {
						SendInfo("Du kannst hier nicht angeln!")
						break
					}
					
					attempt ++
				} else if (RegExMatch(fishing, "Du kannst erst in (\d+) (\S+) wieder angeln\.", ftime_)) {
					if (aFishMoney + aFishHP > 0) {
						Sleep, 500
						
						checkFish()
						
						IniWrite, 900, ini/Settings.ini, Cooldown, fishcooldown
						
						SendChat("/me holt seine Angelrute ein.")
						break
					} else {
						SendInfo("Du kannst noch nicht angeln.")
						break
					}
				}
			}
		} else {
			SendInfo("Du kannst noch nicht fischen! (Gesperrt: " . csecond . formatTime(fishcooldown) . cwhite . ")")
		}
	} else {
		if (fishcooldown) {
			SendInfo("Du kannst noch nicht fischen! (Gesperrt: " . csecond . formatTime(fishcooldown) . cwhite . ")")
		} else {
			SendInfo("Du kannst fischen!")
		}
	}
	
	if (infoOvEnabled) {
		ov_Info(0)
		ov_Info()
	}	
}

check(name) {
	global autoTake
	global admin
	global checkingPlayers
	
	pos := checkingPlayers.Push(getFullName(name))
	
	drugsFound := 0
	matsFound := 0
	seedsFound := 0
	packetsFound := 0
	bombsFound := 0
	
	SendChat("/frisk " . name)
	Sleep, 200
	
	chat1 := readChatLine(0)
	chat2 := readChatLine(1)
	chat3 := readChatLine(2)
	
	if (RegExMatch(chat1 . chat2 . chat3, "Dieser Spieler ist zu weit entfernt!")) {
		return -1
	}
	
	if (autoTake) {
		i := 0
		
		Loop {
			if (i > 10) {
				break
			}

			chat := readChatLine(i)
			
			if (RegExMatch(chat, "Gegenstände von (\S+):")) {
				if (i == 0) {
					break
				}
				
				j := i
				
				Loop {
					j--
					
					if (j < 0) {
						break
					}

					chat := readChatLine(j)
					
					if (RegExMatch(chat, "Du hast (\d+)g Drogen gefunden\.", chat_)) {
						drugsFound := numberFormat(chat_1)
					} else if (RegExMatch(chat, "Du hast (\d+) Samen gefunden\.", chat_)) {
						seedsFound := numberFormat(chat_1)
					} else if (RegExMatch(chat, "Du hast (\d+) Materialien gefunden\.", chat_)) {
						matsFound := numberFormat(chat_1)
					} else if (RegExMatch(chat, "Du hast (\d+) Materialpakete gefunden\.", chat_)) {
						packetsFound := numberFormat(chat_1)
					} else if (RegExMatch(chat, "Du hast (\d+) Haftbomben gefunden\.", chat_)) {
						bombsFound := chat_1
					}
				}
				
				break
			}
			
			i++
		}
		
		if (drugsFound || seedsFound) {
			if (!admin) {
				Sleep, 500
			}
			
			if (chat_1 > 10) {
				SendChat("/take Drogen " . name)
				
				if (drugsFound) {
					drugs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=drugs&value=" . numberFormat(drugsFound))
					IniWrite, %drugs%, ini/Stats.ini, Kontrollen, Drugs
					SendInfo("Du hast bereits " . csecond . formatNumber(drugs) . "g " . cwhite . "Drogen weggenommen.")
				}
			} else {
				SendInfo("Der Spieler hat unter 10g, biete ihn mit " . csecond . "/tdd" . cwhite . " ein Ticket an.")
			}
			
			if (seedsFound) {
				IniRead, seeds, ini/Stats.ini, Kontrollen, seeds, 0
				seeds += seedsFound		
				IniWrite, %seeds%, ini/Stats.ini, Kontrollen, Seeds
				SendInfo("Du hast bereits " . csecond . formatNumber(seeds) . cwhite . " Samen weggenommen.")
			}
		}
		
		if (matsFound || packetsFound || bombsFound) {
			if (!admin) {
				Sleep, 500
			}
			
			SendChat("/take Materialien " . name)
			
			if (matsFound) {
				mats:= UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=mats&value=" . numberFormat(matsFound))
				IniWrite, %mats%, ini/Stats.ini, Kontrollen, Mats
				SendInfo("Du hast bereits " . csecond . formatNumber(mats) . cwhite . " Materialien weggenommen.")
			}	
			
			if (packetsFound) {
				matpackets := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=matpackets&value=" . numberFormat(packetsFound))
				IniWrite, %matpackets%, ini/Stats.ini, Kontrollen, Matpackets
				SendInfo("Du hast bereits " . csecond . formatNumber(matpackets) . cwhite . " Materialpakete weggenommen.")
			} 
			
			if (bombsFound) {
				matbombs := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=matBombs&value=1")
				IniWrite, %matbombs%, ini/Stats.ini, Kontrollen, Matbombs
				SendInfo("Du hast bereits " . csecond . formatNumber(matbombs) . cwhite . " Haftbomben weggenommen.")
			}
		}
	}
	
	checkingPlayers.RemoveAt(pos)
	
	return [drugsFound, seedsFound, matsFound, packetsFound, bombsFound]
}

readCarInfos() { ; Anpassen
	global
	
	dialog := getDialogText()
	
	if (InStr(dialog, "Allgemeines")) {
		RegExMatch(dialog, "Besitzer: (\S+)", owner)
		RegExMatch(dialog, "Letzter Fahrer: (\S+) \(ID: (\d+), Level: (\d+)\)", driver)
		id := getPlayerIdByName(owner1, true)
		
		if (owner1 == "S.F.") {
			owner1 := "S.F. Rifa"
		} else if (owner1 == "L.S.") {
			owner1 := "L.S. Vagos"
		} else if (owner1 == "Los") {
			owner1 := "Los Chickos Malos"
		} else if (owner1 == "Grove") {
			owner1 := "Grove Street"
		} else if (owner1 == "Russen") {
			owner1 := "Russen Mafia"
		}
		
		zone := getPlayerZone()
		city := getPlayerCity()
		
		if (id == -1) {
			SendInfo(csecond . "Besitzer: " . cwhite . owner1)
			SendInfo(csecond . "Letzter Fahrer: " . cwhite . driver1)
			SendInfo(csecond . "Stadt: " . cwhite . city . csecond . " Bezirk: " . cwhite . zone)
		} else {
			lvl := getPlayerScoreById(id)
			
			SendInfo(csecond . "Besitzer: " . cwhite . owner1 . csecond . " ID: " . cwhite . id . csecond . " Level: " . cwhite . lvl)
			SendInfo(csecond . "Letzter Fahrer: " . cwhite . driver1)
			SendInfo(csecond . "Stadt: " . cwhite . city . csecond . " Bezirk: " . cwhite . zone)
		}
		
		SendChat("/time")
	}
}

sendPosition(chat, cMode := true) {
	global
	
	if (isInChat() && cMode) {
		return
	}
	
	if (isPaintball) {
		SendChat("/" . chat . " HQ: Ich befinde mich aktuell in der Paintball-Arena!")
	} else {
		if (isPlayerInRangeOfPoint(1163.2358, -1323.2552, 15.3945, 5.0)) {
			SendChat("/" . chat . " HQ: Ich befinde mich aktuell im Krankenhaus!")
		} else {
			SendChat("/" . chat . " HQ: Ich befinde mich derzeit in " . getLocation() . ", HP: " . getPlayerHealth() . "/" . getPlayerArmor())
		}
	}
}

useMegaphone(type) {
	global
	
	if (admission && IsPlayerInRangeOfPoint(1535.7749, -1677.9380, 5.8906, 500.0)) {
		SendInfo("Du kannst während einer Einweisung das Megafon nicht verwenden.")
		return
	}
	
	if (type == 0) {
		SendChat("/m << " . department . ", Radarkontrolle! " . driver_1 . ", halten Sie SOFORT an und fahren Sie rechts ran! >>")
	} else if (type == 1) {
		if (watermode) {
			SendChat("/m << Küstenwache, bitte folgen Sie dem Boot >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., bitte folgen Sie dem Einsatzfahrzeug >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., bitte folgen Sie dem Helikopter! >>")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << " . department . ", bitte folgen Sie dem Einsatzfahrzeug >>")
		}		
	} else if (type == 2) {
		if (watermode) {
			SendChat("/m << Küstenwache, Wasserverkehrskontrolle. Halten Sie bitte an >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., Allgemeine Kontrolle, bitte halten Sie SOFORT an! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., Luftverkehrskontrolle. Landen Sie umgehend! >>")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << " . department . ", Allgemeine Kontrolle, bitte halten Sie an! >>")
		}
	} else if (type == 3) {
		if (watermode) {
			SendChat("/m << Küstenwache, stoppen Sie SOFORT Ihr Boot! >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., halten Sie SOFORT an! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., landen Sie SOFORT! >>")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << " . department . ", bleiben Sie SOFORT stehen >>")
		}
		
		SendChat("/m << Letzte Mahnung, sollten Sie verweigern, wenden wir härte Maßnahmen an! >>")

		SetTimer, ShotAllowedCar, 30000
		SetTimer, ShotAllowedBike, 5000
		SetTimer, TazerAllowed, 5000
	} else if (type == 4) {
		playerToFindName := getFullName(playerToFind)
	
		if (playerToFindName == "" || playerToFind == "") {
			SendError("Du suchst aktuell niemanden.")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << " . playerToFindName . ", bleiben Sie SOFORT stehen! >>")
			SendChat("/m << Letzte Mahnung, sollten Sie verweigern, wenden wir härte Maßnahmen an! >>")
		
			SetTimer, ShotAllowedCar, 30000
			SetTimer, ShotAllowedBike, 5000
			SetTimer, TazerAllowed, 5000
		}		
	} else if (type == 5) {
		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			dept := department
		}
		
		SendChat("/m << " . dept . ", steigen Sie mit erhobenen Händen aus Ihrem Fahrzeug! >>")
	} else if (type == 6) {
		if (watermode) {
			SendChat("/m << Küstenwache, fahren Sie umgehend zur Seite! >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m >> S.W.A.T., räumen Sie SOFORT die Straße! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., räumen Sie umgehend den Luftraum! >>")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << " . department . ", räumen Sie umgehend die Straße! >>")
		}
	} else if (type == 7) {
		if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., SOFORT die Waffen niederlegen, ansonsten gebrauchen wir Gewalt! >>")
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			SendChat("/m << Hier spricht das " . department . ", SOFORT die Waffen niederlegen, ansonsten gebrauchen wir Gewalt! >>")
		}
	} else if (type == 8) {
		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			dept := department
		}
		
		if (!getPlayerInteriorId()) {
			SendChat("/m << " . dept . ", verlassen Sie SOFORT dieses Gelände! >>")
		} else {
			SendChat("/m << " . dept . ", verlassen Sie SOFORT dieses Gebäude! >>")
		}
	} else if (type == 9) {
		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			dept := department
		}
		
		SendChat("/m << " . dept . ", unterlassen Sie SOFORT diese Verfolgung! >>")		
	} else if (type == 10) {
		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, department, ini/Settings.ini, settings, department, %A_Space%
			dept := department
		}
			
		SendChat("/m << " . dept . ", bitte halten Sie sich an die Straßenverkehrsordnung >>")
	} else if (type == 11) {
		IniRead, department, ini/Settings.ini, settings, department, %A_Space%
		
		if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., dies ist eine Razzia! >>")
		} else {
			SendChat("/m << " . department . ", dies ist eine Razzia! >>")
		}
		
		SendChat("/m << Nehmen Sie SOFORT die Hände hoch oder wir schießen! >>")
	} else if (type == 12) {
		IniRead, department, ini/Settings.ini, settings, department, %A_Space%

		if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., alle Personen bitte SOFORT weiterfahren! >>")
		} else {
			SendChat("/m << " . department . ", alle Personen bitte SOFORT weiterfahren! >>")
		}		
	}
}

getFishValue(fishName, fishWeight) {
	global 
	
	if (fishName == "Bernfisch" || fishName == "Blauer Fächerfisch") {
		value := fishWeight * 1
	} else if (fishName == "Roter Schnapper" || fishName == "Schwertfisch" || fishName == "Zackenbarsch") {
		value := fishWeight * 2
	} else if (fishName == "Katzenfisch" || fishName == "Forelle") {
		value := fishWeight * 3
	} else if (fishName == "Delphin" || fishName == "Hai" || fishName == "Segelfisch") {
		value := fishWeight * 4
	} else if (fishName == "Makrele") {
		value := fishWeight * 5
	} else if (fishName == "Aal" || fishName == "Hecht") {
		value := fishWeight * 6
	} else if (fishName == "Schildkröte" || fishName == "Thunfisch" || fishName == "Wolfbarsch") {
		value := fishWeight * 8
	} else {
		value := 0
	}
	
	return value
}

gk(id, store := "", showGK := false) {
	global
	
    result := URLDownloadToVar(baseURL . "api/newgk.php?gk=" . id)
    
    if (result == "ERROR_CONNECTION") {
        SendInfo("Fehler bei der Verbindung zum Server.")
    } else if (result == "ERROR_BAD_LINK") {
        SendInfo("Fehlerhafte Parameterübergabe.")
    } else if (result == "ERROR_ACCESS_DENIED") {
        SendInfo("Zugriff verweigert, das Passwort ist falsch.")
    } else if (result == "ERROR_WRONG_FORMAT") {
        SendInfo("Fehlerhaftes Format.")
    } else if (result == "ERROR_NOT_FOUND") {
        SendInfo("Der Komplex wurde nicht in der Datenbank gefunden.")
    } else {
        if (store == "") {
            SendInfo("Gebäudekomplex " . cSecond . id . cwhite . ":")
        }
        
        try {
            data := JSON.Load(result)
        } catch {
            SendInfo("Es ist ein unbekannter Fehler aufgetreten.")
            return
        }
        
        for index, storerob in data {
            name := storerob["name"]
            location := ""
            
            if (storerob["type"] == "public") {
                color := "{12C0EB}"
                location := " (" . calculateZone(storerob["x"], storerob["y"], 0.0) . ", " . calculateCity(storerob["x"], storerob["y"], 0.0) . ")"
            } else if (storerob["type"] == "house") {
                
                if (name == "Nobody") {
					color := "{09B814}"
                    name := "Haus (frei)"
                } else if (name == "Auktion im CP") {
					color := "{B83109}"
                    name := "Haus (" . name . ")"
                } else {
					color := "{09B814}"
                    name := "Haus von " . name
                }
                
                location := " (" . calculateZone(storerob["x"], storerob["y"], 0.0) . ", " . calculateCity(storerob["x"], storerob["y"], 0.0) . ")"
            } else if (storerob["type"] == "faction") {
                color := "{117ABB}"
                location := " (" . calculateZone(storerob["x"], storerob["y"], 0.0) . ", " . calculateCity(storerob["x"], storerob["y"], 0.0) . ")"
            } else if (storerob["type"] == "vehicle") {
                color := "{FF00FF}"
            }
            
            if (storerob["x"] == -5000 || storerob["y"] == -5000) {
                location := ""
            }
            
            if (store != "") {
                if (store == "BS" && name == "Burger Shot") {
                } else if (store == "SM" && name == "24/7") {
                } else if (store == "CB" && name == "Clucking Bell") {
                } else if (store == "CS" && name == "Binco") {
                } else if (store == "PS" && name == "Well Stacked Pizza") {
				} else if (store == "DN" && name == "Donut Laden") {
                } else {
                    continue
                }
                
                SendInfo("GK " . id . ": (ID: " . storerob["type"] . "." . storerob["id"] . ") " . color . name . location)
                
                if (showGK) {
                    Sleep, 50
                    
                    showGK(storerob["type"] . "." . storerob["id"], true)
                }
            } else {
                SendInfo("[" . storerob["type"] . "." . storerob["id"] . "] " . color . name . location)
            }
        }
    }
}

showGK(gk, ignoreExisting := false) {
	global
	
    if (RegExMatch(gk, "^(public|house|faction)\.(\d+)$", regex_)) {
        result := UrlDownloadToVar(baseURL . "api/newgk.php?id=" . gk)
        
        if (result == "ERROR_CONNECTION") {
            SendInfo("Fehler bei der Verbindung zum Server.")
        } else if (result == "ERROR_BAD_LINK") {
            SendInfo("Fehlerhafte Parameterübergabe.")
        } else if (result == "ERROR_ACCESS_DENIED") {
            SendInfo("Zugriff verweigert, das Passwort ist falsch.")
        } else if (result == "ERROR_WRONG_FORMAT") {
            SendInfo("Fehlerhaftes Format.")
        } else if (result == "ERROR_NOT_FOUND") {
            SendInfo("Der Komplex wurde nicht in der Datenbank gefunden.")
        } else {
            try {
                data := JSON.Load(result)
            } catch {
                SendInfo("Es ist ein unbekannter Fehler aufgetreten.")
                return
            }
            
            if (IsMarkerCreated() && !ignoreExisting) {
                SendInfo("Du kannst mit '" . cSecond . "X" . cwhite . "' bestätigen, wenn du den CP neu setzen willst.")
                
                KeyWait, X, D, T10
                
                if (ErrorLevel) {
                    return
                }
            }
            
            zPos := data["z"]
            
            if (zPos == -1)
                zPos := 20
            
            if (setCheckpoint(data["x"], data["y"], zPos, 5)) {
                SendInfo("Der Checkpoint zum GK mit der ID " . csecond . gk . cwhite . " wurde erfolgreich gesetzt!")
            } else {
                SendInfo("Beim Setzen des Checkpoints ist ein Fehler aufgetreten!")
            }
        }
    } else {
        SendInfo("Die ID wurde falsch formatiert. Beispiel: " . csecond . "public.12")
    }
}

checkFish() {
	global

	fishHP := 0 
	fishMoney := 0
	allFishHP := 0
	allFishMoney := 0
	
	SendChat("/fishes")
	Sleep, 200
	
	Loop, 15 {
		if (RegExMatch(readChatLine(A_Index), "^\*\* \((\d+)\) Fisch: (.+) \((\d+) LBS\)$", fish_)) {
			fishMoney := getFishValue(fish_2, fish_3)
			fishHP := Floor(fish_3 * 0.3)
			allFishHP += fishHP
			allFishMoney += fishMoney
			
			fishName%fish_1% := fish_2
			fishLBS%fish_1% := fish_3
			fishHP%fish_1% := fishHP
			fishPrice%fish_1% := fishMoney
			
			message%fish_1% := prefix . "(" . fish_1 . ") " . cSecond . fishName%fish_1% . cWhite . ": " . cSecond . fishHP%fish_1% . cWhite . " HP | $" . csecond . fishPrice%fish_1% . cWhite . " | " . cSecond . fishLBS%fish_1% . cWhite . " LBS"
		}
	}
	
	fishes := 5
	
	Loop, 5 {
		setChatLine(fishes, message%A_Index%)
		fishes -= 1
	}	
	
	SendInfo("Gesamt HP: " . cSecond . formatNumber(allFishHP) . cwhite . " HP | Gesamt Wert: $" . cSecond . formatNumber(allFishMoney))
	
	if (infoOvEnabled) {
		ov_Info(0)
		ov_Info()
	}	
	
	return allHP
}

checkCook() {
	global
	
	fishHP := 0
	allHP := 0
	
	SendChat("/cooked")
	Sleep, 200
	
	Loop, 15 {
		if (RegExMatch(readChatLine(A_Index), "^\*\* \((\d+)\) Hergestellt: (.+) \((\d+) LBS\)$", fish_)) {
			fishHP := floor(fish_3 / 3)
			allHP += fishHP
			
			fishName_%fish_1% := fish_2
			fishLBS_%fish_1% := fish_3
			fishHP_%fish_1% := fishHP
			
			message%fish_1% := prefix . "(" . fish_1 . ") " . cSecond . fishName_%fish_1% . cWhite . ": " . cSecond . fishLBS_%fish_1% . cWhite . " LBS | " . csecond . fishHP_%fish_1% . cWhite . " HP"
		}
	}
	
	fishes := 5
	
	Loop, 5 {
		setChatLine(fishes, message%A_Index%)
		fishes -= 1
	}	
	
	SendInfo("Gesamt HP: " . cSecond . formatNumber(allHP) . cwhite . " HP.")
	
	if (infoOvEnabled) {
		ov_Info(0)
		ov_Info()
	}	
	
	return allHP
}

addLocalToStats() {	
	global
	
	SendChat("/robres")
	
	Sleep, 200
	
	Loop, 5 { 
		if (RegExMatch(readChatLine(A_Index - 1), "HQ: Die Restaurant-Kette (.+) wurde von Staat San Andreas eingenommen\.", output1_)) {
			if (output1_1 != oldLocal) {
				SendChat("/d HQ: Ich habe die Kette " . output1_1 . " von ihrem Erpresser befreit!")
				Restaurants := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=restaurants&value=1")
				IniWrite, %Restaurants%, ini/Stats.ini, Übernahmen, Restaurants
			
				SendInfo("Du hast bereits " . csecond . formatNumber(Restaurants) . cwhite . " Restaurants übernommen.")
				
				oldLocalTime := 180
				oldLocal := output1_1
			}
			
			break
		}
	}
}	

addControlsToStats(frisk_name) {
	global
	
	Sleep, 200
	
	Loop, 5 {
		chat := readChatLine(A_Index - 1)
	
		if (InStr(chat, "* " . getUserName() . " hat " . frisk_name . " nach Waffen durchsucht.")) {
			if (frisk_name != oldFrisk) {
				controls := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=controls&value=1")
				IniWrite, %controls%, ini/Stats.ini, Kontrollen, controls
		
				SendInfo("Du hast bereits " . csecond . formatNumber(controls) . cwhite . " Kontrollen durchgeführt.")

				oldFriskTime := 180 
				oldFrisk := frisk_name
				
				break
			}
		}
	}
}

updateKD() {
	global
	
	IniRead, Kills, ini/Stats.ini, Stats, Kills, 0
	IniRead, Deaths, ini/Stats.ini, Stats, Deaths, 0
	
	if (Kills != getKill()) {
		Kills := getKill()
		iniWrite, %Kills%, ini/Stats.ini, Stats, Kills
		SendInfo("Deine Kills wurden auf " . cSecond . formatNumber(Kills) . cwhite . " aktuallisiert.")
	}
	
	if (Deaths != getDeath()) {
		Deaths := getDeath() 
		iniWrite, %Deaths%, ini/Stats.ini, Stats, Deaths
		SendInfo("Deine Toden wurden auf " . cSecond . formatNumber(Deaths) . cwhite . " aktuallisiert.")
	}
}

getKill() {
	global
	
	forceStats()

	if (RegExMatch(getDialogText(), "(.*)Morde: (\d+)(.*)", kills_)) {
		return kills_2
	} else {
		return -1
	}
}

getDeath() {
	global
	
	forceStats()

	if (RegExMatch(getDialogText(), "(.*)Gestorben: (\d+)(.*)", deaths_)) {
		return deaths_2
	} else {
		return -1
	}
}
getItems() {
	global
	
	forceStats()
	
	if (RegExMatch(getDialogText(), "(.*)Drogen: (\d+)g(.*)", drugs_)) {
		IniWrite, % drugs_2, ini/Settings.ini, Items, drugs
		
		if (drugs_2 == 0) {
			if (infoOvEnabled) {
				imageDestroy(ov_Drugs)
				textDestroy(ov_DrugsText)
			}	
		}
	} else {
		SendError("Beim Auslesen der Drogen ist ein Fehler aufgetreten.")
	}
	
	if (InStr(getDialogText(), "Erste-Hilfe-Paket")) {
		IniWrite, 1, ini/Settings.ini, Items, firstaid
	} else {
		IniWrite, 0, ini/Settings.ini, Items, firstaid
	
		if (infoOvEnabled) {
			imageDestroy(ov_Firstaid)
		}		
	}
	
	if (InStr(getDialogText(), "Benzin Kanister")) {
		IniWrite, 1, ini/Settings.ini, Items, canister
	} else {
		IniWrite, 0, ini/Settings.ini, Items, canister
	
		if (infoOvEnabled) {
			imageDestroy(ov_Canister)
		}		
	}
	
	if (InStr(getDialogText(), "Lagerfeuer")) {	
		if (RegExMatch(getDialogText(), "(.*)Lagerfeuer \((\d+)\)(.*)", campfire_)) {
			iniWrite, % campfire_2, ini/Settings.ini, Items, campfire
		}
	} else {
		iniWrite, 0, ini/Settings.ini, Items, campfire
	
		if (infoOvEnabled) {
			imageDestroy(ov_Campfire)
			textDestroy(ov_CampfireText)
		}		
	}
	
	if (infoOvEnabled) {
		ov_Info(0)
		ov_Info()
	}
}


forceStats() {
	global
	
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP")) {
		return
	}
	
	blockDialog()
	SendChat("/stats")
	Sleep, 200
	unblockDialog()
}

healPlayer() {
	global healcooldown
	
	if (getPlayerHealth() >= 100 && getPlayerArmor() >= 100) {
		SendError("Du kannst dich nicht mit voller HP/AM heilen.")
	} else if (healcooldown) {
		SendInfo("Du kannst dich erst in " . cSecond . formatTime(healcooldown) . cWhite . " wieder heilen.")
	} else {
		SendChat("/heal")
		Sleep, 200
	
		checkHealMessage()
	}
}

usePaket() {
	global pakcooldown
	
	if (getPlayerArmor() > 30) {
		SendError("Du kannst mit mehr als 30 AM kein Erste-Hilfe-Paket verwenden.")
	} else if (75 < getPlayerHealth()) {
		SendError("Du kannst erst unter 75 HP ein Erste-Hilfe-Paket nehmen, du hast " . getPlayerHealth() . " HP.")
	} else if (pakcooldown) {
		SendInfo("Du kannst erst in " . cSecond . formatTime(pakcooldown) . cWhite . " wieder ein Erste-Hilfe-Paket nutzen.")
	} else {
		SendChat("/erstehilfe")
	}
}

useDrugs() {
	global drugcooldown
	
	if (getPlayerArmor()) {
		SendError("Du kannst mit Armor keine Drogen nehmen.")
	} else if (94 < getPlayerHealth()) {
		SendError("Du kannst erst unter 94 HP Drogen nehmen, du hast " . getPlayerHealth() . " HP.")
	} else if (drugcooldown) {
		SendInfo("Du kannst erst in " . cSecond . formatTime(drugcooldown) . cwhite . " Sekunden wieder Drogen nutzen.")
	} else {
		SendChat("/usedrugs")	
	}
}

refillCar() {	
	global
	
	if (isPlayerInAnyVehicle() && isPlayerDriver()) {
		if (getVehicleEngineState()) {
			SendChat("/motor")
			
			Sleep, 250
			
			if (InStr(readChatLine(0) . readChatLine(1), "Du fährst zu schnell, um den Motor abzustellen.")) {
				Sleep, 1000
				
				SendChat("/motor")
				Sleep, 250
			
				if (InStr(readChatLine(0) . readChatLine(1), "Du fährst zu schnell, um den Motor abzustellen.")) {
					return
				}
			}
		}
		
		Sleep, 100
		
		SendChat("/fill")
		Sleep, 8800
		
		if (!getVehicleEngineState()) {
			SendChat("/motor")
			Sleep, 2000
			
			if (getVehicleLightState()) {
				SendChat("/licht")
			}
		}
	}
}

openGate() {	
	global
	
	SendChat("/auf")
}

openMaut() {
	global
	
	SendChat("/zoll")
	Sleep, 200
	
	if (inStr(readChatLine(0) . readChatLine(1), "Es ist keine Zollstation in deiner Nähe.")) {
		Sleep, 400
		SendChat("/zoll")
	}
}

getTaxes() {
	global
	
	SendChat("/tax")
	
	Sleep, 250
	
	if (RegExMatch(readChatLine(4 - 4), "Steuerklasse 4: (\d*) Prozent", chat_)) {
		taxes := (100 - chat_1) / 100
		
		IniWrite, %taxes%, ini/Settings.ini, settings, taxes
		SendInfo("Der Steuersatz (Steuerklasse " . cSecond . "4" . cwhite . ") wurde auf " . cSecond . chat_1 . cwhite . " Prozent gesetzt.")
		return 1
	}
	
	return 0
}

getLocation() {
	global
	
	zone := getPlayerZone()
	city := getPlayerCity()
	
	if (!getPlayerInteriorID()) {
		if (city == "" || city == "Unbekannt") {
			return zone
		} else {
			return zone . ", " . city
		}
	} else {
		return "Interior-ID " . getPlayerInteriorID()
	}
}

getSkinFraction(id) {
	global
	
    skins := {"LSPD": [260, 163, 164, 265, 266, 267, 280, 281, 283, 284, 288], "FBI": [165, 166, 240, 286, 294, 11, 172, 194, 211, 59], "Sanitäter": [70, 274, 275, 276, 308], "Feuerwehr": [255, 277, 278, 279, 191], "Russen": [43, 111, 112, 113, 124, 125, 126, 127, 258, 272, 40], "Yakuza": [121, 122, 123, 186, 203, 204, 228, 169, 224], "Hitman": [], "Wheelman": [], "San News": [60, 170, 188, 227, 250, 56, 226], "Grove Street": [105, 106, 107, 269, 271, 65], "Ballas": [102, 103, 104, 293, 13], "LCM": [46, 47, 48, 98, 185, 223, 249, 214], "Ordnungsamt": [8, 42, 50, 71, 233], "Transport GmbH": [34, 44, 132, 133, 202, 206, 261, 31, 131], "San Fierro Rifa": [], "Vagos": [108, 109, 110, 292, 91], "Triaden": [], "Biker": [100, 247, 248, 254, 131]}
    fraction := ""
  
	for key, array in skins
    {
        for index2, value2 in array
        {
            if (value2 == id) {
                fraction := key
                Break, 2
            }
        }
    }
    if(fraction) {
        return fraction
    }
    return "Zivilist"
}

getDamageWeapon(damage) {
	global
	
	weap := {"Deagle": [46, 47], "UZI/Tec9": [6, 7], "MP5": [8], "AK47/M4": [9, 10], "Rifle": [24, 25], "Sniper": [41, 42]}

	for key, array in weap {
		for index2, value2 in array {
			if (value2 == damage) {
				weap := key 
				Break, 2
			} else {
				weap := "Unbekannt" 
			}
		}
	}
	
	if (weap) {
		return weap
	}
}

weaponShort(id) {
	global
	
	short := {0: "meiner", 1: "einem", 2: "einem", 3: "einem", 4: "einem", 5: "einem", 6: "einer", 7: "einem", 8: "einem", 9: "einer", 10: "einem", 11: "einem", 12: "einem", 13: "einem", 14: "einer", 15: "einem", 16: "einer", 17: "", 18: "einem", 22: "einer", 23: "einem", 24: "einer", 25: "einer", 26: "einer", 27: "einer", 28: "einer", 29: "einer", 30: "einer", 31: "einer", 32: "einer", 33: "einer", 34: "einer", 35: "einer", 36: "einer", 37: "einem", 38: "einer", 39: "einem", 40: "einem", 41: "einer", 42: "einem", 43: "einer"}

	if (short[id]) {
		return short[id]
	}
	
	return "einer"
}

isConnected() {
	global
	
    coords := getCoordinates()
   
    if ((coords[1] == 384 && coords[2] == -1557 && coords[3] == 20) || (Round(coords[1]) == 1531 && Round(coords[2]) == -1734 && Round(coords[3]) == 13)) {
        return false
    }
   
    return true
}

isConnectedToRPG() {
	global
	
	if (isSAMPAvailable()) {
		if (inStr(getServerName(), "GTA-City") && InStr(getServerName(), "Reallife")) {
			if (getServerIP() == "51.77.68.94" && getServerPort() == "7777") {
				return true
			}
		}
	}
   
    return true
}

isPlayerAtGasStation() {
	global
	
	if (isPlayerInRangeOfPoint(700, -1930, 0, 30) || isPlayerInRangeOfPoint(1833, -2431, 14, 30)) { ; Verona Beach
		return 2
	} else if (isPlayerInRangeOfPoint(615, 1689, 7, 6)
	|| isPlayerInRangeOfPoint(-1328, 2677, 40, 6) ; Tierra Robada
	|| isPlayerInRangeOfPoint(1596, 2199, 11, 6) ; Redsands West
	|| isPlayerInRangeOfPoint(2202, 2474, 11, 6) ; Emerald Isle
	|| isPlayerInRangeOfPoint(2114, 920, 11, 6) ; The Strip
	|| isPlayerInRangeOfPoint(-2408, 976, 45, 6) ; Juniper Hill
	|| isPlayerInRangeOfPoint(-2029, 156, 29, 6) ; Doherty
	|| isPlayerInRangeOfPoint(-1676, 414, 7, 6) ; Easter Basin
	|| isPlayerInRangeOfPoint(1004, -939, 43, 6) ; Temple
	|| isPlayerInRangeOfPoint(1944, -1773, 14, 6) ; Idlewood
	|| isPlayerInRangeOfPoint(-90, -1169, 3, 6) ; Flint County
	|| isPlayerInRangeOfPoint(-1605, -2714, 49, 6) ; Whetstone
	|| isPlayerInRangeOfPoint(-2243, -2560, 32, 6) ; Angel Pine
	|| isPlayerInRangeOfPoint(1381, 457, 20, 6) ; Montgomery
	|| isPlayerInRangeOfPoint(70, 1218, 19, 6) ; Fort Carson
	|| isPlayerInRangeOfPoint(1555, -1605, 14, 6)) { ; LSPD
		return 1
	} else {
		return 0
	}
}

isPlayerAtMaut() {
	global
	
	if (isPlayerInRangeOfPoint(1733.47, 546.37, 26, 10) ; Zoll 1
	|| isPlayerInRangeOfPoint(1741.11, 543.47, 26, 10) ; Zoll 1
	|| isPlayerInRangeOfPoint(1744.03, 523.63, 27, 10) ; Zoll 1
	|| isPlayerInRangeOfPoint(1752.71, 521.69, 27, 10) ; Zoll 1
	|| isPlayerInRangeOfPoint(512.54, 476.62, 18, 10) ; Zoll 2
	|| isPlayerInRangeOfPoint(529.22, 467.21, 18, 10) ; Zoll 2
	|| isPlayerInRangeOfPoint(-159.79, 414.18, 11, 10) ; Zoll 3
	|| isPlayerInRangeOfPoint(-157.44, 392.24, 11, 10) ; Zoll 3
	|| isPlayerInRangeOfPoint(-1408.23, 824.19, 47, 10) ; Zoll 4
	|| isPlayerInRangeOfPoint(-1414.77, 803.59, 47, 10) ; Zoll 4
	|| isPlayerInRangeOfPoint(-2695.05, 1284.63, 55, 10) ; Zoll 5
	|| isPlayerInRangeOfPoint(-2686.34, 1284.24, 55, 10) ; Zoll 5
	|| isPlayerInRangeOfPoint(-2676.62, 1265.37, 55, 10) ; Zoll 5
	|| isPlayerInRangeOfPoint(-2668.18, 1264.91, 55, 10) ; Zoll 5
	|| isPlayerInRangeOfPoint(-963.08, -343.05, 36, 10) ; Zoll 6
	|| isPlayerInRangeOfPoint(-968.00, -322.33, 36, 10) ; Zoll 6
	|| isPlayerInRangeOfPoint(-71.76, -892.47, 15, 10) ; Zoll 7
	|| isPlayerInRangeOfPoint(-68.74, -867.96, 15, 10) ; Zoll 7
	|| isPlayerInRangeOfPoint(100.20, -1284.37, 14, 10) ; Zoll 8
	|| isPlayerInRangeOfPoint(94.40, -1277.82, 14, 10) ; Zoll 8
	|| isPlayerInRangeOfPoint(97.19, -1254.11, 14, 10) ; Zoll 8
	|| isPlayerInRangeOfPoint(94.69, -1245.59, 14, 10) ; Zoll 8
	|| isPlayerInRangeOfPoint(42.71, -1537.98, 5, 10) ; Zoll 9
	|| isPlayerInRangeOfPoint(58.02, -1524.93, 5, 10)) { ; Zoll 9
		return 1
	} else {
		return 0
	}
}

isPlayerAtEquip() {
	global
	
	if (IsPlayerInRangeOfPoint(225.5152, 121.3243, 999.0702, 4.0)
	|| IsPlayerInRangeOfPoint(240.5149, 1878.7798, 11.4609, 4.0)
	|| IsPlayerInRangeOfPoint(255.3406, 77.3936, 1003.6406, 4.0)
	|| IsPlayerInRangeOfPoint(2317.0151, -2019.1134, 13.5528, 4.0)) {
		return 1
	} else {
		return 0
	}
}

isAtDepartmentSpawn() {
	global
	
	if (IsPlayerInRangeOfPoint(-1617.6255, 676.5569, -4.9063, 3.0)
	|| IsPlayerInRangeOfPoint(1530.8369, -1664.8872, 6.2188, 3.0)
	|| IsPlayerInRangeOfPoint(224.1197, 1862.0314, 13.1470, 3.0)
	|| IsPlayerInRangeOfPoint(2326.1082, -2038.6212, 13.5528, 3.0)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtHeal() {
	global
	
	if (IsPlayerInRangeOfPoint(225, 121, 999, 5) 
	|| IsPlayerInRangeOfPoint(197, 168, 1003, 5)
	|| IsPlayerInRangeOfPoint(2316, -2019, 13, 5)
	|| IsPlayerInRangeOfPoint(2324, -1148, 1050, 5)
	|| IsPlayerInRangeOfPoint(418.7545, -83.8548, 1001, 5)
	|| IsPlayerInRangeOfPoint(-794.9179, 490.1421, 1376, 5)
	|| IsPlayerInRangeOfPoint(774.3298, -49.7077, 1000, 5)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtLocal() {
	global
	
	if (IsPlayerInRangeOfPoint(792.6970, -1626.2189, 13.3906, 3.1)
		|| IsPlayerInRangeOfPoint(2412.0930, -1491.2977, 24.0000, 3.1)
		|| IsPlayerInrangeOfPoint(2113.6445, -1788.6113, 13.5608, 3.1) 
		|| IsPlayerInrangeOfPoint(1026.6838, -1350.2480, 13.7266, 3.1)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtJailGate() {
	global
	
	if (IsPlayerInRangeOfPoint(2325.9573, -2010.4614, 13.5528, 6.0)
	|| IsPlayerInRangeOfPoint(2292.4316, -2028.8600, 13.5469, 6.0)
	|| IsPlayerInRangeOfPoint(2349.7400, -2006.9121, 13.5433, 6.0)
	|| IsPlayerInRangeOfPoint(2350.1248, -1985.2939, 13.3828, 6.0)
	|| IsPlayerInRangeOfPoint(2345.8162, -1979.7006, 13.4098, 6.0)
	|| IsPlayerInRangeOfPoint(2345.8069, -1999.7858, 13.3766, 6.0)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtPDGate() {
	global
	
	if (IsPlayerInRangeOfPoint(239.4568, 117.5778, 1003.2188, 6.0)
	|| IsPlayerInRangeOfPoint(252.6459, 109.0739, 1003.2188, 6.0)
	|| IsPlayerInRangeOfPoint(-1632.6377, 688.2757, 7.1875, 10.0)
	|| IsPlayerInRangeOfPoint(-1572.1520, 662.2211, 7.1875, 10.0)
	|| IsPlayerInRangeOfPoint(-1701.6948, 684.0962, 24.8906, 10.0)
	|| IsPlayerInRangeOfPoint(214.1250, 1875.7494, 13.1470, 10.0)
	|| IsPlayerInRangeOfPoint(135.1927, 1941.3784, 19.3160, 10.0)
	|| IsPlayerInRangeOfPoint(246.3796, 72.4658, 1003.6406, 6.0)
	|| IsPlayerInRangeOfPoint(1588.5104, -1638.0930, 13.4157, 10.0)
	|| IsPlayerInRangeOfPoint(1544.6460, -1626.9393, 13.3835, 10.0)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtCookPoint() {
	global
	
	if (IsPlayerInRangeOfPoint(376.3651, -61.0868, 1001.5078, 3) 
	|| IsPlayerInRangeOfPoint(377.7927, -57.4440, 1001.5078, 3)
	|| IsPlayerInRangeOfPoint(369.5478, -6.0176, 1001.8589, 3)
	|| IsPlayerInRangeOfPoint(374.0126, -113.5144, 1001.4922, 3)) {
		return 1
	} else {
		return 0
	}
}

isPlayerAtFishPoint() {
	global
	
	if (IsPlayerInRangeOfPoint(1610.3545, 599.4703, 7.7813, 2)
		|| IsPlayerInRangeOfPoint(1606.8572, 599.4689, 7.7802, 2)
		|| IsPlayerInRangeOfPoint(1603.3273, 599.4689, 7.7802, 2)
		|| IsPlayerInRangeOfPoint(1599.8569, 599.8057, 7.7802, 2)
		|| IsPlayerInRangeOfPoint(1596.3372, 599.7783, 7.7813, 2)
		|| IsPlayerInRangeOfPoint(1592.8359, 599.4689, 7.7813, 2)
		|| IsPlayerInRangeOfPoint(1589.3557, 599.4712, 7.7813, 2)
		|| IsPlayerInRangeOfPoint(1585.8787, 599.4683, 7.7802, 2)
		|| IsPlayerInRangeOfPoint(403.8053, -2088.7981, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(398.7274, -2088.7927, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(396.1470, -2088.7983, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(391.0635, -2088.7979, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(383.3910, -2088.6040, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(374.9511, -2088.6829, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(369.8314, -2088.7937, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(367.2829, -2088.7981, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(362.2083, -2088.7891, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(354.5507, -2088.7954, 7.8359, 2)
		|| IsPlayerInRangeOfPoint(-2091.2231, 1436.5226, 7.1016, 2)
		|| IsPlayerInRangeOfPoint(-2086.6912, 1436.4066, 7.1016, 2)
		|| IsPlayerInRangeOfPoint(-2082.6958, 1436.1895, 7.1016, 2)
		|| IsPlayerInRangeOfPoint(-2078.2371, 1436.4476, 7.1016, 2)
		|| IsPlayerInRangeOfPoint(-2073.6873, 1436.2191, 7.1016, 2)
		|| IsPlayerInRangeOfPoint(-2069.6814, 1436.1677, 7.1007, 2)
		|| IsPlayerInRangeOfPoint(-2065.1917, 1436.3531, 7.1007, 2)) {
		return 1
	} else {
		return 0
	}
}

getFractionName() {
	global
	
	if (userFraction == 1) {
		return "LSPD"
	} else if (userFraction == 2) {
		return "FBI"
	} else if (userFraction == 3){ 
		return "Army"
	}
	
	return "LSPD"
}

getFractionTitle() {
	global
	
	if (getFractionName() == "LSPD") {
		return "Officer"
	} else if (getFractionName() == "FBI") {
		return "Agent"
	} else if (getFractionName() == "Army") {
		return "Soldat"
	}
	
	return "Beamter"
}

isBlocked() {
	global
	
	if (isInChat() || IsDialogOpen() || IsPlayerInMenu()) {
		return 1 
	} else {
		return 0
	}
}

sendToHotkey(text, check = 0) {
	global

	if (check == 1) {
		text = /f %text%
	}

	String := checkVars(text)
	StringReplace, String, String, &&, |, All

	if (InStr(String, "|")) {
		StringSplit, Splitted, String, |
		Loop, %Splitted0% {
			Value := Splitted%A_Index%

			if (InStr(Value, "[SLEEP")) {
				RegExMatch(Value, "\[SLEEP ([0-9]+)\]", sleepresult)
				StringReplace, Value, Value, [SLEEP %sleepresult1%], , All
				Sleep, %sleepresult1%
			}

			if (check == 1) {
				SendInfo(Value)
			} else {
				if (InStr(Value, "[LOCAL]")) {
					StringReplace, Value, Value, [LOCAL],, All
					SendInfo(Value)
				} else {
					if (InStr(Value,"[ENTER]")) {
						StringReplace, Value, Value, [ENTER], , All
						SendChat(Value)
					} else {
						SendInput, t%Value%
					}
				}
			}
		}
	} else {
		if (InStr(String, "[SLEEP")) {
			RegExMatch(String, "\[SLEEP ([0-9]+)\]", sleepresult)
			StringReplace, String, String, [SLEEP %sleepresult1%], , All
			sleep %sleepresult1%
		}

		if (check == 1) {
			SendInfo(Value)
		} else {
			if (InStr(String,"[LOCAL]")) {
				StringReplace, String, String, [LOCAL],, All
				SendInfo(String)
			} else {
				if (InStr(String,"[ENTER]")) {
					StringReplace, String, String, [ENTER], , All
					SendChat(String)
				} else {
					SendInput, t%String%
				}
			}
		}
	}

	return
}

checkVars(String) {
	global

	if (InStr(String, "[NAME]")) {
		MyName := getUserName()
		StringReplace, String, String, [NAME], %MyName%,
	}

	if (InStr(String, "[ID]")) {
		MyId := GetId()
		StringReplace, String, String, [ID], %MyId%, All
	}

	if (InStr(String, "[FPS]"))	{
		Frames := GetFPS()
		StringReplace, String, String, [FPS], %Frames%, All
	}

	if (InStr(String, "[PING]")) {
		Ping := GetPlayerPingById(GetId())
		StrinGreplace, String, String, [PING], %Ping%, All
	}

	if (InStr(String, "[SCORE]")) {
		Score := getPlayerScoreById(GetId())
		StringReplace, String, String, [SCORE], %Score%, All
	}

	if (InStr(String, "[CITY]")) {
		City := getPlayerCity()
		StringReplace, String, String, [CITY], %City%, All
	}

	if (InStr(String, "[ZONE]")) {
		Zone := getPlayerZone()
		StringReplace, String, String, [ZONE], %Zone%, All
	}

	if (InStr(String, "[POS]")) {
		MyPos := getPlayerZone() ", " getPlayerCity()
		StringReplace, String, String, [POS], %MyPos%, All
	}

	if (InStr(String, "[HP]")) {
		Life := getPlayerHealth()
		StringReplace, String, String, [HP], %Life%, All
	}

	if (Instr(String, "[VICTIM]")) {
		IniRead, Victim, ini/Stats.ini, Stats, Victim, %A_Space%
		StringReplace, String, String, [VICTIM], %Victim%, All
	}

	if (Instr(String, "[VICTIMFRAK]")) {
		IniRead, VictimFaction, ini/Stats.ini, Stats, VictimFaction, %A_Space%
		StringReplace, String, String, [VICTIMFRAK], %VictimFaction%, All
	}

	if (Instr(String, "[VICTIMWEAP]")) {
		IniRead, VictimWeapon, ini/Stats.ini, Stats, VictimWeapon, %A_Space%
		StringReplace, String, String, [VICTIMWEAP], %VictimWeapon%, All
	}

	if (Instr(String, "[VICTIMWEAPART]")) {
		IniRead, VictimWeaponArt, ini/Stats.ini, Stats, VictimWeaponArt, %A_Space%
		StringReplace, String, String, [VICTIMWEAPART], %VictimWeaponArt%, All
	}

	if (Instr(String, "[KILLPLACE]")) {
		IniRead, KillPlace, ini/Stats.ini, Stats, KillPlace, %A_Space%
		StringReplace, String, String, [KILLPLACE], %KillPlace%, All
	}

	if (Instr(String, "[KILLPLACEFULL]")) {
		IniRead, KillPlaceFull, ini/Stats.ini, Stats, KillPlaceFull, %A_Space%
		StringReplace, String, String, [KILLPLACEFULL], %KillPlaceFull%, All
	}

	if (Instr(String, "[MURDERER]")) {
		IniRead, Murderer, ini/Stats.ini, Stats, Murderer, %A_Space%
		StringReplace, String, String, [MURDERER], %Murderer%, All
	}

	if (Instr(String, "[MURDERERFRAK]")) {
		IniRead, MurdererFaction, ini/Stats.ini, Stats, MurdererFaction, %A_Space%
		StringReplace, String, String, [MURDERERFRAK], %MurdererFaction%, All
	}

	if (Instr(String, "[MURDERERWEAP]")) {
		IniRead, MurdererWeapon, ini/Stats.ini, Stats, MurdererWeapon, %A_Space%
		StringReplace, String, String, [MURDERERWEAP], %MurdererWeapon%, All
	}

	if (Instr(String, "[MURDERERWEAPART]")) {
		IniRead, MurdererWeaponArt, ini/Stats.ini, Stats, MurdererWeaponArt, %A_Space%
		StringReplace, String, String, [MURDERERWEAPART], %MurdererWeaponArt%, All
	}

	if (Instr(String, "[DEATHPLACE]")) {
		IniRead, DeathPlace, ini/Stats.ini, Stats, DeathPlace, %A_Space%
		StringReplace, String, String, [DEATHPLACE], %DeathPlace%, All
	}

	if (Instr(String, "[DEATHPLACEFULL]")) {
		IniRead, DeathPlaceFull, ini/Stats.ini, Stats, DeathPlaceFull, %A_Space%
		StringReplace, String, String, [DEATHPLACEFULL], %DeathPlaceFull%, All
	}

	if (InStr(String, "[DAYTIME]")) {
		DayTime := getDayTime()
		StringReplace, String, String, [DAYTIME], %DayTime%, All
	}

	if (InStr(String, "[KILLS]") || InStr(String, "[DEATHS]") || InStr(String, "[KD]")) {
		IniRead, Kills, ini/Stats.ini, Stats, Kills, 0
		IniRead, Deaths, ini/Stats.ini, Stats, Deaths, 0

		KD := Round(Kills / Deaths, 3)

		StringReplace, String, String, [KILLS], %Kills%, All
		StringReplace, String, String, [DEATHS], %Deaths%, All
		StringReplace, String, String, [KD], %KD%, All
	}

	if (InStr(String, "[DKILLS]") || InStr(String, "[DDEATHS]") || InStr(String, "[DKD]")) {
		IniRead, DKills, ini/Stats.ini, Stats, Dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
		IniRead, DDeaths, ini/Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%], 0
		DKD := Round(Dkills / DDeaths, 3)

		StringReplace, String, String, [DKILLS], %Dkills%, All
		StringReplace, String, String, [DDEATHS], %DDeaths%, All
		StringReplace, String, String, [DKD], %DKD%, All
	}

	return string
}

removeTask(id) {
	global tasks
	
	indexToRemove := -1
	
	for index, entry in tasks {
		if (entry["id"] == id) {
			indexToRemove := index
		}
	}
	
	if (indexToRemove != -1) {
		tasks.RemoveAt(indexToRemove)
		return removeTask(id) + 1
	} else {
		return 0
	}
}

selectLine(busLine) {
	line := busLine - 1
	
	BlockInput, On
	SendChat("/linie")
	
	Sleep, 200
	SendInput, {down %line%}{enter}
	BlockInput, Off
}

findLinie() {
	busLine := 0
	distance := 10000000
	coords := getCoordinates()
	
	global oTextLabelData
	
	if (!updateTextLabelData()) {
		return
	}
	
	vehicleID := getVehicleID()
	
	for i, o in oTextLabelData {
		if (o.VEHICLEID == vehicleID) {
			if (RegExMatch(o.TEXT, "Linie (\d+)\n(.+)", label_)) {
				busLine := label_1
			}
			
			break
		}
	}
	
	return busLine
}

reconnectRPG() {	
	stopFinding()
		
	global giveMaxTicket		:= 3
	
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
	global admission			:= 0
	global deathArrested 		:= 0
	global lastSpeed 			:= 0	
	global hasEquip				:= 0
	global isZivil				:= 0
	global getOldKomplex		:= 0
	global oldFriskTime			:= 0
	global oldLocalTime			:= 0
	global pbKillStreak 		:= 0
	global currentSpeed 		:= 0
	global countdownRunning 	:= 0
	global autoFindMode		 	:= 0
	global IsPayday				:= 0
	global drugcooldown			:= 0
	global healcooldown			:= 0
	global admincooldown		:= 0
	global ooccooldown			:= 0
	global findcooldown			:= 0
	
	global oldWanted            := -1
	global agentID 				:= -1
	global oldVehicle			:= -1
	global targetid				:= -1
	global wantedIA				:= -1
	global wantedContracter		:= -1
	
	global wantedIAReason		:= ""
	global oldInviteAsk			:= ""
	global target				:= ""
	global lastSpeedUser 		:= ""
	global lastTicketReason 	:= ""
	global lastTicketPlayer 	:= ""
	global requestName			:= ""
	global oldFrisk				:= ""
	global oldLocal				:= ""
	global cooldownString		:= ""
	
	global fillTimeout_ 		:= true
	global canisterTimeout_ 	:= true
	global mautTimeout_ 		:= true
	global healTimeout_ 		:= true
	global cookTimeout_ 		:= true
	global equipTimeout_ 		:= true
	global jailgateTimeout_ 	:= true 
	global GateTimeout_ 		:= true
	global fishTimeout_ 		:= true
	global localTimeout_ 		:= true
	global garbageTimeout_		:= true 
	global fishSellTimeout_		:= true

	global agentTog				:= false
	global startOverlay			:= false
	global isArrested			:= false
	global isCuffed				:= false
	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
	global gotPoisened			:= false
	
	global ovMoveMode			:= false
	global alertActive  		:= false
	
	global alertString 			:= ""
	global oldSpotifyTrack		:= ""
	global oldVehicleName		:= "none"
		
	SendChat("/me verbindet sich neu zum Server.")

	restart()	
}

checkTrunk() {
	global 
	
	blockDialog()
	SendChat("/trunk check")
	Sleep, 200
	unblockDialog()
	Sleep, 200

	if (InStr(readChatLine(0) . readChatLine(1), "Fehler:")) {
		if (InStr(readChatLine(0) . readChatLine(1), "Der Kofferraum ist nicht offen")) {
			SendChat("/trunk open")
			
			blockDialog()
			SendChat("/trunk check")
			Sleep, 200
			unblockDialog()
			Sleep, 200
			
			if (InStr(readChatLine(0) . readChatLine(1), "Fehler:")) {
				SendError("Versuche es erneut.")
				return
			}
		} else {
			SendError("Versuche es erneut.")
			return
		}
	}
	
	if (RegExMatch(getDialogCaption(), "Kofferraum von Fahrzeug (\S+) \((.*)\)", result_)) {
		if (RegExMatch(getDialogText(), "Drogen: (\d+)\nMaterialien: (\d+)\nDeagle: (\d+)\nShotgun: (\d+)\nMP5: (\d+)\nAK47: (\d+)\nM4: (\d+)\nRifle: (\d+)\nSniper: (\d+)", dialog_)) {
			foundSomething := 0
			
			SendInfo("Gegenstände aus dem Fahrzeug " . csecond . result_1 . cWhite . "(" . csecond . result_2 . cwhite . "):")
			
			if (dialog_1 > 0) {
				SendInfo("Du hast {CC0000}" . dialog_1 . "g Drogen " . cWhite . "gefunden.")
				drugsfound := 1
				foundSomething := 1
			}
			
			if (dialog_2 > 0) {
				SendInfo("Du hast {CC0000}" . dialog_2 . " Materialien " . cWhite . "gefunden.")
				matsfound := 1
				foundSomething := 1
			}
			
			if (dialog_3 > 0) {
				SendInfo("Du hast " . dialog_3 . " Schuss Deagle " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_4 > 0) {
				SendInfo("Du hast " . dialog_4 . " Schuss Shotgun " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_5 > 0) {
				SendInfo("Du hast " . dialog_5 . " Schuss MP5 " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_6 > 0) {
				SendInfo("Du hast " . dialog_6 . " Schuss AK-47 " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_7 > 0) {
				SendInfo("Du hast " . dialog_7 . " Schuss M4 " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_8 > 0) {
				SendInfo("Du hast " . dialog_8 . " Schuss Rifle " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (dialog_9 > 0) {
				SendInfo("Du hast " . dialog_9 . " Schuss Sniper " . cWhite . "gefunden.")
				foundSomething := 1
			}
			
			if (!foundSomething) {
				SendInfo("Du hast nichts gefunden.")
			} else if (dialog_1 > 0 || dialog_2 > 0) {
				SendChat("/trunk check")
			}
			
			trunkControls := UrlDownloadToVar(baseURL . "api/stats?username=" . username . "&password=" . password . "&action=add&stat=trunkControls&value=1")
			IniWrite, %trunkcontrols%, ini/Stats.ini, Kontrollen, Trunkcontrols
			
			SendInfo("Du hast bereits " . csecond . formatNumber(trunkcontrols) . cWhite . " Kofferäume durchsucht.")
			
			Sleep, 200
			
			if (matsfound && drugsfound) {
				SendInfo("Es wurden Drogen & Materialien gefunden. Du kansnt Sie mit '" . cSecond . "X" . cwhite . "' konfiszieren.")
				
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear mats")
					
					Sleep, 400
					
					SendChat("/trunk clear drugs")
				}
			} else if (matsfound && !drugsfound) {
				SendInfo("Es wurden Materialien gefunden. Du kansnt Sie mit '" . cSecond . "X" . cwhite . "' konfiszieren.")
			
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear mats")
				}
			} else if (!matsfound && drugsfound) {
				SendInfo("Es wurden Drogen gefunden. Du kansnt Sie mit '" . cSecond . "X" . cwhite . "' konfiszieren.")
			
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear drugs")
				}
			}
			
			return 1
		}				
	}
		
	SendInfo("Der Kofferraum konnte nicht durchsucht werden.")
	return 0
}

costumStation(id) {
	global 
	
	if (id == 1) {
		return "Los Santos - Las Venturas"
	} else if (id == 2) {
		return "Red County - Bone County"
	} else if (id == 3) {
		return "Blueberry - Bone County"
	} else if (id == 4) {
		return "San Fierro - Tierra Robada"
	} else if (id == 5) {
		return "San Fierro - Bayside"
	} else if (id == 6) {
		return "Flint County - Red County"
	} else if (id == 7) {
		return "Flint County - Red County"
	} else if (id == 8) {
		return "Los Santos - Flint County"
	} else if (id == 9) {
		return "Los Santos - Flint County"
	} else if (id == 10) {
		return "Los Santos"
	} else if (id == 11) {
		return "San Fierro"
	} else if (id == 12) {
		return "Las Venturas"
	} else if (id == 13) {
		return "San Andreas"
	}
}
/*
onDialogResponse() {
	global
	
	if (GetDialogCaption() == "Übersicht der Mülltonnen") {
		if (!IsDialogButton1Selected() && !doubleClick) {
			doubleClick := true
			SetTimer, DoubleClickTimer, 250
			return
		}
		
		SetCheckPoint(trashcan[GetDialogIndex()][1], trashcan[GetDialogIndex()][2], trashcan[GetDialogIndex()][3], 5)
		SendInfo("Mülltonne " . cSecond . trashcan[GetDialogIndex()][6] . cWhite . " in " . cSecond . trashcan[GetDialogIndex()][4] . cWhite . " wurde markiert.")
	}
}

updateRest() {
	global
	
	/*
	rest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	rest.Open("GET", "http://leonprefix.net/trash/?mode=list", false)
	rest.Send()
	
	split := StrSplit(rest.ResponseText, "#")
	
	Loop % split.maxIndex() {
		split2 := StrSplit(split[A_Index], ";")
		trash := split2[1]
		sec := split2[2]
		x := 0
		
		while (++x <= trashcan.MaxIndex()) {
			if (trashcan[x][6] == trash) {
				trashcan[x][5] := sec
			}
		}
	}
	
}

sendToRest(trash, min) {
	global 
	
	if (!spamProtection) {
		spamProtection := true
		SetTimer, SpamProtection, 5000
	} else {
		return
	}
	
	rest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	rest.Open("GET", "http://leonprefix.net/trash/?mode=set&id=" . trash . "&min=" . min, false)
	rest.Send()
}

setTrashTime(line) {
	global
	
	Loop % trashcan.MaxIndex() {
		if (isPlayerInRangeOfPoint(trashcan[A_Index][1], trashcan[A_Index][2], trashcan[A_Index][3], 5)) {
			split := StrSplit(line, A_Space)
			min := split[12]
			
			if (InStr(line, "Sekunden.")) {
				min := 1
			}
			
			trashcan[A_Index][5] := 60 * min
			SendToRest(trashcan[A_Index][6], min)
			
			if (min == 1) {
				SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . "eine Minute" . cWhite . " gesetzt.")
			} else {
				SendInfo("Die Zeit von Mülltonne " . cSecond . trashcan[A_Index][6] . cWhite . " wurde auf " . cSecond . min . " Minuten" . cWhite . " gesetzt.")
			}
		}
	}
}
*/
shareKD(chat := "f") {
	global 
	
	IniRead, kills, ini/stats.ini, Stats, kills, 0
	IniRead, dkills, ini/stats.ini, Stats, dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mkills, ini/stats.ini, Stats, mkills[%A_MM%:%A_YYYY%], 0
	
	IniRead, deaths, ini/stats.ini, Stats, deaths, 0
	IniRead, ddeaths, ini/stats.ini, Stats, ddeaths[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, mdeaths, ini/stats.ini, Stats, mdeaths[%A_MM%:%A_YYYY%], 0	
	
	kd := round(kills/deaths, 2)
	if (deaths == 0) {
		kd := kills . ".00"
	}				
	
	dkd := round(dkills/ddeaths, 2)
	if (ddeaths == 0) {
		dkd := dkills . ".00"
	}
	
	mkd := round(mkills/mdeaths, 2)
	if (mdeaths == 0) {
		mkd := mkills . ".00"
	}

	SendChat("/" . chat . " Aktuelle Kills: " . formatNumber(kills) . " - Aktuelle Tode: " . formatNumber(deaths))
	SendChat("/" . chat . " Tages-Kills: " . dkills . " - Tages-Tode: " . ddeaths)
	SendChat("/" . chat . " Monats-Kills: " . formatNumber(mkills) . " - Monats-Tode: " . formatNumber(mdeaths))
	SendChat("/" . chat . " DKD: " . kd . " - MKD: " . mkd . " - KD: " . kd)	
}

ov_Spotify(create := 1) {
	global
		
	if (create) {		
		ovColor := "0xFF" . spotifyColor
		
		ov_spotify := textCreate(spotifyFont, spotifySize, spotifyBold, spotifyItal, spotifyXPos, spotifyYPos, ovColor, "", true, true)
		
		SetTimer, SpotifyOverlayTimer, 2000
	} else {
		textDestroy(ov_spotify)
	}
}

ov_Ping(create := 1) { 
	global
			
	if (create) {
		ovColor := "0xFF" . pingColor
		ov_Ping := textCreate(pingFont, pingSize, pingBold, pingItal, pingXPos, pingYPos, ovColor, "", true, true)
		
		SetTimer, PingOverlayTimer, 1000
	} else {
		textDestroy(ov_Ping) 
	}
}

ov_Cooldown(create := 1) {
	global
			
	if (create) {
		ovColor := "0xFF" . cooldownColor
		ov_Cooldown := textCreate(cooldownFont, cooldownSize, cooldownBold, cooldownItal, cooldownXPos, cooldownYPos, ovColor, "", true, true)
		
		SetTimer, CooldownOverlayTimer, 990
	} else {
		textDestroy(ov_Cooldown)
	}
}

ov_Alert(create := 1) {
	global

	if (create) {
		ovColor := "0xFF" . alertColor
		ov_Alert := textCreate(alertFont, alertSize, alertBold, alertItal, alertXPos, alertYPos, ovColor, "", true, true)
		
		SetTimer, AlertOverlayTimer, 1000
	} else {
		textDestroy(ov_Alert) 
	}
}

ov_Partner(create := 1) {
	global
	
	if (create) {
		ovColor := "0xFF" . partnerColor
		ov_Partner := textCreate(partnerFont, partnerSize, partnerBold, partnerItal, partnerX, partnerY, ovColor, "", true, true)
		
		SetTimer, PartnerOverlayTimer, 5000
	} else {
		textDestroy(ov_Partner)
	}
}

ov_Info(create := 1) {
	global	

	if (create) {
		if (infoOv) {
			IniRead, drugs, ini/Settings.ini, Items, drugs, 0
			IniRead, firstaid, ini/Settings.ini, Items, firstaid, 0
			IniRead, canister, ini/Settings.ini, Items, canister, 0
			IniRead, campfire, ini/Settings.ini, Items, campfire, 0
			IniRead, mobilePhone, ini/Settings.ini, Items, mobilePhone, 0
					
			if (mobilePhone) {
				ov_Phone := imageCreate("images\Overlay\phoneOn.png", infoPhoneX, infoPhoneY, 0, true, true)
			} else {
				ov_Phone := imageCreate("images\Overlay\phoneOff.png", infoPhoneX, infoPhoneY, 0, true, true)
			}
			
			if (firstaid) {
				ov_Firstaid := imageCreate("images\Overlay\firstaid.png", infoFirstaidX, infoFirstaidY, 0, true, true)
			}
			
			if (canister) {
				if (isPlayerInAnyVehicle()) {
					ov_Canister := imageCreate("images\Overlay\canister.png", infoCanisterX, infoCanisterY, 0, true, true)
				} else {
					imageDestroy(ov_Canister)
				}
			}
			
			if (campfire) {
				ov_Campfire := imageCreate("images\Overlay\campfire.png", infoCampfireX, infoCampfireY, 0, true, true) 
				ov_CampfireText := textCreate("Arial", 9, true, false, infoCampfireX + 10, infoCampfireY + 14, 0xFFFFFFFF, campfire, true, true)
			}		

			if (drugs) {
				ov_Drugs := imageCreate("images\Overlay\drugs.png", infoDrugsX, infoDrugsY, 0, true, true)
				ov_DrugsText := textCreate("Arial", 9, true, false, infoDrugsX + 11, infoDrugsY + 14, 0xFFFFFFFF, drugs, true, true)
			}
			
			hasCookedFish := 0
			
			Loop, 5 {
				if (fishName_%A_Index% != "nichts" && fishHP_%A_Index% > 0) {
					hasCookedFish ++
				}
			}
			
			if (hasCookedFish) {
				ov_Fish := imageCreate("images\Overlay\fishCooked.png", infoFishCookedX, infoFishCookedY, 0, true, true)
				ov_FishText := textCreate("Arial", 9, true, false, infoFishCookedX + 8, infoFishCookedY + 8, 0xFFFFFFFF, hasCookedFish, true, true)
			}

			hasFish := 0

			Loop, 5 {
				if (fishName%A_Index% != "nichts" && fishHP%A_Index% > 0) {
					hasFish ++
				}
			}
			
			if (hasFish) {
				ov_UncookedFish := imageCreate("images\Overlay\fishUncooked.png", infoFishUncookedX, infoFishUncookedY, 0, true, true)
				ov_UncookedFishText := textCreate("Arial", 9, true, false, infoFishUncookedX + 8, infoFishUncookedY + 8, 0xFFFFFFFF, hasFish, true, true)
			}
		}
	} else {
		imageDestroy(ov_Phone)
		imageDestroy(ov_Firstaid)
		imageDestroy(ov_Canister)
		imageDestroy(ov_Campfire)
		imageDestroy(ov_Drugs)
		imageDestroy(ov_Fish)
		imageDestroy(ov_UncookedFish)
		
		textDestroy(ov_DrugsText)
		textDestroy(ov_CampfireText)
		textDestroy(ov_FishText)
		textDestroy(ov_UncookedFishText)		
	}
}

ov_UpdatePosition(id) {
	global
	
	if (id == 1) {
		if (spotifyOv) {
			textSetPos(ov_spotify, spotifyXPos, spotifyYPos)
		}
	} else if (id == 2) {
		if (cooldownOv) {
			textSetPos(ov_Cooldown, cooldownXPos, cooldownYPos)
		}
	} else if (id == 3) {
		if (alertOv) {
			textSetPos(ov_Alert, alertXPos, alertYPos)
		}
	} else if (id == 4) {
		if (pingOv) {
			textSetPos(ov_Ping, pingXPos, pingYPos)
		}
	} else if (id == 5) {
		if (infoOv) {
			imageSetPos(ov_Phone, infoPhoneX, infoPhoneY)
		}
	} else if (id == 6) {
		if (infoOv) {
			imageSetPos(ov_Firstaid, infoFirstaidX, InfoFirstaidY)
		}
	} else if (id == 7) {
		if (infoOv) {
			if (isPlayerInAnyVehicle()) {
				imageSetPos(ov_Canister, infoCanisterX, infoCanisterY)
			}
		}
	} else if (ovMoveMode == 8) {
		if (infoOv) {
			textSetPos(ov_FishText, infoFishCookedX + 8, infoFishCookedY + 8)
			imageSetPos(ov_Fish, infoFishCookedX, infoFishCookedY)
		}
	} else if (ovMoveMode == 9) {
		if (infoOv) {
			textSetPos(ov_UncookedFishText, infoFishUncookedX + 8, infoFishUncookedY + 8)
			imageSetPos(ov_UncookedFish, infoFishUncookedX, infoFishUncookedY)
		}
	} else if (ovMoveMode == 10) {
		if (infoOv) {
			textSetPos(ov_CampfireText, infoCampfireX + 10, infoCampfireY + 14)
			imageSetPos(ov_Campfire, infoCampfireX, infoCampfireY)
		}
	} else if (ovMoveMode == 11) {
		if (infoOv) {
			textSetPos(ov_DrugsText, infoDrugsX + 11, infoDrugsY + 14)
			imageSetPos(ov_Drugs, infoDrugsX, infoDrugsY)
		}
	} else if (ovMoveMode == 12) {
		if (infoOv) {
			textSetPos(ov_Partner, partnerX, partnerY)
		}
	}
}

destroyOverlay() {
	global
	
	overlayEnabled := false
	spotifyOvEnabled := false
	cooldownOvEnabled := false
	pingOvEnabled := false
	infoOvEnabled := false
	alertOvEnabled := false	

	SetTimer, SpotifyOverlayTimer, off
	SetTimer, CooldownOverlayTimer, off
	SetTimer, PingOverlayTimer, off
	SetTimer, AlertOverlayTimer, off
	SetTimer, PartnerOverlayTimer, off

	imageDestroy(ov_Phone)
	imageDestroy(ov_Firstaid)
	imageDestroy(ov_Canister)
	imageDestroy(ov_Campfire)
	imageDestroy(ov_Drugs)
	imageDestroy(ov_Fish)
	imageDestroy(ov_UncookedFish)
		
	textDestroy(ov_DrugsText)
	textDestroy(ov_CampfireText)
	textDestroy(ov_FishText)
	textDestroy(ov_UncookedFishText)
	textDestroy(ov_Cooldown)
	textDestroy(ov_Ping)
	textDestroy(ov_spotify)
	textDestroy(ov_Alert)
	textDestroy(ov_Partners)
	
	destroyAllVisual()
}

SendInfo(message) {
	global
	
	SendClientMessage(prefix . message)
}

SendError(message) {
	global
	
	SendClientMessage(prefix . cRed . "Fehler: " . message)
}