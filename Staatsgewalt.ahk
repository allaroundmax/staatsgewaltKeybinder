﻿#IfWinActive, GTA:SA:MP
#SingleInstance, force

#Persistent
#NoEnv

#Include, include/UDF.ahk
#Include, include/API.ahk
#Include, include/JSON.ahk

SetWorkingDir, %A_ScriptDir%

/*
 * TODOs
	* Loginsystem?
	* Statistiken auf Server übertragen?
	* Updatelog von Server holen
*/

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

global projectName 			:= "Staatsgewalt"
global fullProjectName 		:= "Staatsgewalt"

global keybinderVersion 	:= "overlay"
global version 				:= "4.0.8"
global keybinderStart 		:= 0

global baseURL 				:= "https://staatsgewalt.jameschans.de/keybinder/"

global COLOR_WHITE			:= "{FFFFFF}"
global COLOR_GREY			:= "{BDBDBD}"
global COLOR_RED			:= "{CC0000}"
global COLOR_WANTED			:= "{FF4000}"
global COLOR_GREEN			:= "{00962B}"
global COLOR_YELLOW			:= "{FFEE00}"
global COLOR_ORANGE			:= "{FF8100}"

Start:
{
	keybinderStart := A_Hour . ":" . A_Min . ":" . A_Sec
	
	newversion :=  URLDownloadToVar(baseURL . "api/getsetting?key=version")
	
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
	
	IfNotExist, images/LogoSmallFBI.png
		URLDownloadToFile, %baseURL%keybinder/download/images/LogoSmallFBI.png, images\LogoSmallFBI.png
	
	IfNotExist, images/LogoSmallLSPD.png
		URLDownloadToFile, %baseURL%keybinder/download/images/LogoSmallLSPD.png, images\LogoSmallLSPD.png	
	
	IfNotExist, images/LogoSmallArmy.png
		URLDownloadToFile, %baseURL%keybinder/download/images/LogoSmallArmy.png, images\LogoSmallArmy.png	
	
	IfNotExist, sounds
		FileCreateDir, sounds
	
	IfNotExist, sounds/bk.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/bk.mp3, sounds\bk.mp3
		
	IfNotExist, sounds/call.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/call.mp3, sounds\call.mp3
	
	IfNotExist, sounds/sms.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/sms.mp3, sounds\sms.mp3
	
	IfNotExist, sounds/double.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/double.mp3, sounds\double.mp3
		
	IfNotExist, sounds/triple.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/triple.mp3, sounds\triple.mp3
		
	IfNotExist, sounds/quadra.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/quadra.mp3, sounds\quadra.mp3
	
	IfNotExist, sounds/penta.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/penta.mp3, sounds\penta.mp3
		
	IfNotExist, sounds/hexa.mp3
		URLDownloadToFile, %baseURL%keybinder/download/sounds/hexa.mp3, sounds\hexa.mp3
	
	IfNotExist, inis
		FileCreateDir, inis

	UnBlockChatInput()
	
	chatLogFile := FileOpen(A_MyDocuments . "\GTA San Andreas User Files\SAMP\chatlog.txt", "r")
	firstChatLogRun := true
	chatLogLines := []
	
	FormatTime, time, , dd.MM.yyyy HH:mm:ss
	
	IfNotExist, images
		FileCreateDir, images
	
	if (keybinderVersion == "overlay") {
		IfNotExist, bin 
			FileCreateDir, bin
		
		IfNotExist, bin\overlay.dll
			URLDownloadToFile, %baseURL%keybinder/download/bin/overlay.dll, bin\overlay.dll
		
		#Include, include/overlay.ahk
		
		SetParam("use_window", "1")
		SetParam("window", "GTA:SA:MP")
	}
	
	IniRead, autoLock, settings.ini, settings, autoLock, 0
	IniRead, autoEngine, settings.ini, settings, autoautoEngine, 0
	IniRead, autoFill, settings.ini, settings, autoFill, 0
	IniRead, autoLotto, settings.ini, settings, autoLotto, 0
	IniRead, antiSpam, settings.ini, settings, antiSpam, 0
	IniRead, autoUncuff, settings.ini, settings, autoUncuff, 0
	IniRead, autoFrisk, settings.ini, settings, autoFrisk, 0
	IniRead, autoTake, settings.ini, settings, autoTake, 0
	IniRead, autoWanted, settings.ini, settings, autoWanted, 0
	IniRead, autoCustoms, settings.ini, settings, autoCustoms, 0
	IniRead, autoLocal, settings.ini, settings, autoLocal, 0
	IniRead, autoUse, settings.ini, settings, autoUse, 1
	IniRead, fishMode, settings.ini, settings, fishMode, 0
	IniRead, autoHeal, settings.ini, settings, autoHeal, 0
	IniRead, chatlogSaver, settings.ini, settings, chatlogSaver, 0
	IniRead, admin, settings.ini, settings, admin, 0
	
	
	IniRead, lottoNumber, settings.ini, Einstellungen, Lottozahl, 0
	IniRead, cookSystem, settings.ini, Einstellungen, cookSystem, 1
	IniRead, primaryColor, settings.ini, Einstellungen, Primärfarbe, %A_Space%
	IniRead, secondaryColor, settings.ini, Einstellungen, Sekundärfarbe, %A_Space%
	IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
	IniRead, ownprefix, settings.ini, Einstellungen, Ownprefix, %A_Space%	
	IniRead, ownRank, settings.ini, Einstellungen, ownRank, 0
	IniRead, showDamageInfo, settings.ini, Einstellungen, showDamageInfo, 1
	IniRead, packetMessages, settings.ini, Einstellungen, PaketNachrichten, 1
	IniRead, spotifymessage, settings.ini, Einstellungen, spotifymessage, 1
	IniRead, paintballMessages, settings.ini, Einstellungen, PaintballNachrichten, 1
	IniRead, partnerMessages, settings.ini, Einstellungen, PartnerNachrichten, 1
	IniRead, friendMessages, settings.ini, Einstellungen, FreundeNachrichten, 1
	IniRead, warningMessages, settings.ini, Einstellungen, Vorwarnungsnachrichten, 1
	IniRead, AutoLaserMessage, Settings.ini, Settings, AutoLaserMessage, 0
	IniRead, wantedAlarm, Settings.ini, Einstellungen, WantedAlarm, 1
	IniRead, frakGreeting, Settings.ini, Einstellungen, Begrüßungen, 1
	IniRead, refillWarning, Settings.ini, Einstellungen, Tankwarnung, 1
	IniRead, smsSound, settings.ini, Sounds, smsSound, 1
	IniRead, callSound, settings.ini, Sounds, callSound, 1
	IniRead, killSound, settings.ini, Sounds, killSound, 1
	IniRead, deathSound, settings.ini, Sounds, deathSound, 1
	IniRead, backupSound, settings.ini, Sounds, backupSound, 1
	IniRead, emergencySound, settings.ini, Sounds, emergencySound, 1
	IniRead, leagueSound, settings.ini, Sounds, leagueSound, 1	
	IniRead, maxKMH, settings.ini, Einstellungen, MaxKMH, 0
	IniRead, taxes, settings.ini, Steuern, Steuersatz, 1			
	IniRead, commitmentUnix, settings.ini, UnixTime, commitmentUnix, 0
	IniRead, commitmentTime, settings.ini, UnixTime, commitmentTime, 0
	IniRead, drugs, settings.ini, Items, drugs, 0
	IniRead, firstaid, settings.ini, Items, firstaid, 0
	IniRead, campfire, settings.ini, Items, campfire, 0
	
	IniRead, fishcooldown, settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, settings.ini, Cooldown, pakcooldown, 0

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
	defaultHotkeysArray["ungrab"] 						:= "~^9"
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
		
	IfNotExist, Hotkeys.ini
	{
		for key, value in defaultHotkeysArray {
			IniWrite, %value%, Hotkeys.ini, Hotkeys, %key%
		}
	}
	
	for key, value in defaultHotkeysArray {
		IniRead, hk, Hotkeys.ini, Hotkeys, %key%, %A_Space%
		
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
			} else {
				FileAppend, [%time%] Der Hotkey für ownHotkey%outerIndex% (%hk%) ist bereits registriert (%alreadyRegisteredKey% - %alreadyRegisteredValue%)!`n, log.txt
			}
		}
	}

	Loop, 3 {
		profileID := A_Index
		
		Loop, 6 {
			IniRead, profile%profileID%_%A_Index%, settings.ini, Ausrüstungsprofile, Profil%profileID%_%A_Index%, %A_Space%
		}
	}
	
	IniRead, ucSkin, settings.ini, Ausrüstungsprofile, UCSkin, 0
	IniRead, equipArmour, settings.ini, Ausrüstungsprofile, Schutzweste, 0
	
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
	global prefix := "|" . primcol . projectName . COLOR_WHITE . "| " 
	
	if (ownprefix != "") {
		prefix := ownprefix . " "
	}
	
	if (keybinderVersion == "overlay") {
		IniRead, statsOverlayContent, settings.ini, StatsOverlay, Content, %A_Space%
		IniRead, statsOverlayAutostart, settings.ini, StatsOverlay, Autostart, 0
		IniRead, statsOverlayPosX, settings.ini, StatsOverlay, PosX, 20
		IniRead, statsOverlayPosY, settings.ini, StatsOverlay, PosY, 215
		IniRead, statsOverlayColors, settings.ini, StatsOverlay, Colors, 1
		IniRead, statsOverlayItalic, settings.ini, StatsOverlay, Italic, 0
		IniRead, statsOverlayFont, settings.ini, StatsOverlay, Font, Arial
		IniRead, statsOverlayFontSize, settings.ini, StatsOverlay, FontSize, 7
		IniRead, statsOverlayBold, settings.ini, StatsOverlay, Bold, 1
		IniRead, statsOverlayColor, settings.ini, StatsOverlay, Color, FF9900
		
		if (statsOverlayContent == "") {
			statsOverlayConect := "[primcol]Spieler Informationen [white]([primcol][name][white])~| Spieler ID: [csecond][id][white]~| FPS: [csecond][fps][white]~| Standort: [csecond][zone], [city][white]~| Leben: [csecond][hp] / [armour]~~[primcol]Statistiken~[white]| Arrests: [csecond][arrests][white] (Geld: [csecond][arrestmoney][white]$)~| Tickets: [csecond][tickets][white] (Geld: [csecond][ticketmoney][white]$)~| Wanteds: [csecond][wanteds][white]~| Kills: [csecond][crimekills][white]~| Kontrollen: [csecond][controls]~[backup]~~~[lock]~[light]"
			
			IniWrite, %statsOverlayContent%, settings.ini, StatsOverlay, Content
		}
		
		statsOverlayContent := StrReplace(statsOverlayContent, "~", "`n")
		
		statsOverlayprimcolor := "{0040FF}"
		statsOverlaycsecondor := "{" . statsOverlayColor . "}"
		statsOverlayPositiveColor := "{00962B}"
		statsOverlayNegativeColor := "{CC0000}"
		
		allOverlaysEnabled := false
		statsOverlayEnabled := false
		
		if (statsOverlayAutostart) {
			createOverlay(1)
			
			statsOverlayEnabled := true
		}
	}
	
	if (keybinderFrac == "") {
		keybinderFrac := "FBI"
	}
	
	global chat 				:= []
	global partners 			:= []
	global grabList 			:= []
	global arrestList 			:= []
	global wantedTickets 		:= []
	global wantedPlayers 		:= []
	global ticketPlayers 		:= []
	global checkingPlayers 		:= []	
	
	global pedStates 			:= {}
	
	global tempo 				:= 80
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
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
	
	global oldscreen			:= -1
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
	global tvName 				:= ""
	
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

	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
		
	global oldVehicleName		:= "none"
	global oldSpotifyTrack		:= "notFound"

	if (keybinderVersion == "overlay") {
		if (admin) {
			overlayOn := false
			
			Loop 15 {
				sup_text_%A_Index% := ""
				sup_name_%A_Index% := ""
			}
			
			numID := 1
			page := 1	
		}
	}
	
	if (admin) {
		IfNotExist Tickets
			FileCreateDir, Tickets
		
		global respawnCarsRunning := false
	}
	
	SetTimer, ChatTimer, 200	
	SetTimer, MainTimer, 200
	SetTimer, ArrestTimer, 100
	SetTimer, TimeoutTimer, 1000
	SetTimer, SecondTimer, 1000
	SetTimer, WantedTimer, 1000
	
	if (autoUncuff) {
		SetTimer, UncuffTimer, 500
	}
	
	if (chatlogSaver) {
		SetTimer, ChatlogSaveTimer, 1000
	}
	
	if (admin) {
		SetTimer, TicketTimer, 1000
	}
	
	SetTimer, LottoTimer, 2000
	
	if (refillWarning) {
		SetTimer, TankTimer, 5000
	}	
	
	if (bossmode) {
		SetTimer, SyncTimer, 600000
	}
	
	Gui, Color, white
	Gui, Font, s32 CDefault, Verdana
		
	Gui, Add, Text, x245 y12 w460 h55 , %fullProjectName%
		
	if (keybinderFrac == "FBI") {	
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallFBI.png
	} else if (keybinderFrac == "LSPD") {	
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallLSPD.png
	} else if (keybinderFrac == "Army") {
		Gui, Add, Picture, x12 y0 w80 h80, images\LogoSmallArmy.png
	}
	
	Gui, Font, s10 CDefault, Verdana

	Gui, Add, GroupBox, x-8 y75 w210 h460, 
	Gui, Add, Button, x12 y89 w170 h30 gSettingsGUI, Settings
	Gui, Add, Button, x12 y129 w170 h30 gHotkeysGUI, Hotkeys
	Gui, Add, Button, x12 y169 w170 h30 gNewsGUI, News
	Gui, Add, Button, x12 y209 w170 h30 gHelpGUI, Hilfen
	Gui, Add, Button, x12 y249 w170 h30 gSupport, Fehler Melden
	Gui, Add, Button, x12 y419 w170 h30 gRPGConnect, RPG - Connect
	Gui, Add, Button, x12 y459 w170 h30 gTeamSpeak, FBI/LSPD - TS Connect

	Gui, Add, GroupBox, x232 y89 w560 h190, Neuigkeiten (Version %version%)
	; TODO: Updatelogs vom Server ziehen	
	StringReplace, update, msg, ', `r`n, All
	Gui, Add, Edit, x242 y109 w540 h160 ReadOnly, 
(
Version 4.0.8
- Hat man eine Paketsperre, wird nicht mehr versucht ein Paket zu nutzen. 
- Die öffentliche Spotify-Meldung kann nun unter 'Einstellunge' -> 'Verschiedene Meldungen' ab oder angeschaltet werden. 
- Hinzugefügt: /ts -> Sendet den LSPD / FBI TS in den /d Chat.
- Hinzugefügt: /fts -> Sendet den LSPD / FBI TS in den /f Chat.

Version 4.0.7
- Paintballmodus eingefügt. 
- Im Paintball sendet man mit sämtlichen Positionsdurchgeben eine Meldung, dass man im Paintball ist. 
- Im Paintball ist das Usen von Paket / Fischen / Drugs nicht mehr möglich.
- Im Paintball erhält man keine Damage-Meldungen mehr.
- Die Donut-Restaurant-Kette ist nun ebenfalls vorhanden (X, /rs)
- Wenn man nach Invite gefragt wird, sagt man nun automatisch nein. Das Gleich wenn gefragt wird 'Sucht ihr Member'
- Hinzugefügt: /fpsunlock
- Hinzugefügt: /bwgov
- Hinzugefügt: /dkd
- Wenn man nach Invite gefragt wird, sagt man nun automatisch nein. Das Gleich wenn gefragt wird 'Sucht ihr Member'
- Weitere Häuser (aus Idlewood) für das Healen mit 'X' eingefügt.
- Wenn die Fische, Paket und Drogen synchronisieren erhält man nun eine Meldung.
- Verbesserte Variablen: beim /relog und /q werden alle nötigen Variablen nun richtig zurückgesetzt.
- Auto-Lotto System angepasst, ab Zahl 100 verwendet man nun seine eigene ID.
- Fehler behoben, dass man /erstehilfe nicht anwenden konnte.
- Wenn man getötet wird erhält man nur noch den Mörder, wenn dieser in NameTag Range ist.
- Fehler behoben, dass man einen Storeüberfall (^) nicht annehmen konnte.
- Fehler mit dem Drogencooldown behoben.
- Fehler beim Zivil / Duty gehen wurde behoben, dies wird nun korrekt erkannt.
- Fehler beim Zivil / Duty gehen wurde behoben, wenn die Weste weggeworfen wird.
- Fehler behoben, dass der Tempomat nicht mehr funktioniert hat. 
- Fehler behoben, dass man einen Storeüberfall (^) nicht annehmen konnte.
- Fehler mit dem Drogencooldown behoben.
- Wenn beim durchsuchen Drogen/Mats gefunden werden, werden die Wanteds dafür nun korrekt ausgestellt.
- Die Meldung bei 6 & 7 (Sie sind vorläufig festgenommen wurde angepasst. 
- Die Meldung bei 7 (Sie sind vorläufig festgenommen (( ZELLE ))) wurde abgeändert und warnt nun den vor, den man auf /afind hat.
- Die Meldung, dass man im Dienst oder Zivil ist kommt nur noch, sofern man eine Rüstung trägt. 
- Wenn man nun den Motor startet, sofern der Tank leer ist, wird man gefragt ob man einen Kanister nutzen möchte.
- Verbesserungen an automatische Systeme vorgenommen.

Version 4.0.6
- Synchronisations-Timer wurde auf 10 Minuten gesetzt
- Hinzugefügt: /bc => Roadbarrier aufbauen
- Hinzugefügt: /bd => Roadbarrier delete
- Hinzugefügt: /bda => Roadbarrier deleteall


Version 4.0.5
- Schnelles Fischen nun mit X am Angelsteg möglich.
- FBI Tore funktionieren nun ebenfalls auf X.
- Hinzugefügt: /items -> Zeigt Items an
- /enter und /exit entfernt
- Bei /acook wurde wieder eine kleine Verzögerung reingehauen
- Bei /af wird nun /mdc gemacht, um zusehen wie viele Wanteds der gesuchte hat

Version 4.0.4
- Wenn man mit /acook nicht in einem Restaurant ist, wird automatisch ein Lagerfeuer gesetzt und gekocht.
- Verzögerung bei /acook entfernt
- Ausrüsten auf 'X' funktioniert nur noch einmal während man lebt. Wenn man getötet wird, wird dies wieder zurückgesetzt. Sonst healt man absofort.
- Bossmode angepasst -> Dies funktioniert nur noch wenn man W A S oder D drückt -> erlaubt. Alle 120 Sekunden werden nun Paket, Fische & Drogen gesynct. 
- Wenn man in ein leeres Fahrzeug steigt wird man nun gefragt ob man mit 'X' einen Kanister nutzen möchte. 

Version 4.0.3
- Schnelles Grab-System optimiert; sofern ein eingetragener Partner einen Spieler tazert/cufft, wird dieser ebenfalls aufgenommen und kann mit '9' gezogen werden
- Im Agentenmodus wird nun ebenfalls erkannt, ob man einen Spieler tazert oder cufft
- Drogen werden nun exakt in den Stats erfasst
- Hinzugefügt: /setdrugs -> Drogen aktuallisieren
- Hinzugefügt: /setfirstaid -> Erste-Hilfe-Paket aktuallisieren
- Hinzugefügt: /bossmode
- Mülltonnenstatistiken hinzugefügt
- Wenn man Spotify laufen hat wird nun der nächste Track immer im Chat angezeigt.
- Kleinere Anpassungen + Bugfixxes

Version 4.0.2
- Ausbruchs Overlay an die Seite gelegt und kleiner gemacht.
- Fehler bei einer Tazermeldung wurde gefixxt.
- /gk funktioniert nun
- Bei /find wird nun das Gebäudekomplex angezeigt.

Version 4.0.1
- Tore können nun davor mit 'X' geöffnet werden
- Ausrüsten nun am Punkt mit 'X' möglich
- /zivil als Hotkey auf ALT + X gelegt
- Soundsysteme überarbeitet
- Anpassung der Vorwarnungsmeldungen (30 Sekunden Regel)
- Partner-System und Arrest-System auf die aktuellen Chatmeldungen angepasst.

Version 4.0.0
- Wiederaufnahme des Keybinders (offline Version)
)

	; TODO: Userinfos von Server ziehen
	Gui, Add, GroupBox, x232 y289 w560 h190, User-Informationen 
		
	IniRead, rank, settings.ini, Einstellungen, rank, 0	
	
	if (rank is number) {
		if (ownRank == 0) {
			rankinfo := "Du bist kein Beamter"
		} else {
			rankinfo := "Rang: " . rank . "!"
		}
	} else {
		rankinfo := "Du bist kein Beamter"
	}
	
	info =
	(
Name: %username%
%rankinfo%
	
	
	
	
Aktuelle Keybinderversion: %version%
Keybinder-Typ: %keybinderVersion%

Eingeloggt seit: %keybinderStart% Uhr
	)
	Gui, Add, Text, x242 y309 w540 h160, %info%

	Gui, Show, w818 h505, %fullProjectName% - Version %version%
}
return

GuiClose:
{
	if (keybinderVersion == "overlay") {
		if (statsOverlayEnabled) {
			TextDestroy(statsOverlay)
		}	

		if (admin) {
			TextDestroy(sup_heading)
			TextDestroy(sup_page)
			TextDestroy(sup_text)
			BoxDestroy(sup_box)
		}
	}

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
	Run, ts3server://176.96.138.103
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
	
	if (keybinderVersion == "nooverlay") {
		Gui, Settings: Add, Button, x10 y760 w130 h40 voverlayButton, Overlay
		
		GuiControl, Settings: Disable, overlayButton
	} else {
		Gui, Settings: Add, Button, x10 y760 w130 h40 gOverlaySettingsGUI, Overlays
	}
			
	Gui, Settings: Add, Button, x480 y760 w130 h40 gSettingsGuiClose, Schließen
	
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

	Gui, Settings: Add, CheckBox, x420 y30 w190 h20 vchatlogSaver checked%chatlogSaver%, Chatlogs abspeichern
	Gui, Settings: Add, CheckBox, x420 y60 w190 h20 vadmin checked%admin%, Admin-Modus
	
	
	/*
	Gui, Settings: Add, Text, x400 y60 w150 h20, Lottozahl (0 Rand, 101 = ID)
	Gui, Settings: Add, Edit, x560 y60 w40 h20 vlottoNumber, %lottoNumber%	
	Gui, Settings: Add, Text, x400 y90 w110 h20, Primärfarbe
	Gui, Settings: Add, Edit, x530 y90 w70 h20 vprimaryColor, %primaryColor%
	Gui, Settings: Add, Text, x400 y120 w110 h20, Sekundärfarbe
	Gui, Settings: Add, Edit, x530 y120 w70 h20 vsecondaryColor, %secondaryColor%
	Gui, Settings: Add, Text, x400 y150 w110 h20, Abteilung
	Gui, Settings: Add, Edit, x530 y150 w70 h20 vkeybinderFrac, %keybinderFrac%
	Gui, Settings: Add, Text, x400 y180 w110 h20, Eigener prefix
	Gui, Settings: Add, Edit, x530 y180 w70 h20 vownprefix, %ownprefix%
	Gui, Settings: Add, CheckBox, x400 y210 w120 h20 vcookSystem Checked%cookSystem%, Auto. Kochen
	*/
		
	Gui, Settings: Add, GroupBox, x10 y250 w600 h80, Sounds
	Gui, Settings: Add, CheckBox, x20 y270 w170 h20 vsmsSound Checked%smsSound%, SMS Sound
	Gui, Settings: Add, CheckBox, x190 y270 w170 h20 vcallSound Checked%callSound%, Call Sound
	Gui, Settings: Add, CheckBox, x360 y270 w170 h20 vbackupSound Checked%backupSound%, Backup Sound
	Gui, Settings: Add, CheckBox, x20 y300 w170 h20 vemergencySound Checked%emergencySound%, Bankrob Sound	
	Gui, Settings: Add, CheckBox, x190 y300 w170 h20 vleagueSound Checked%leagueSound%, LoL Kill Sounds
	
	Gui, Settings: Add, GroupBox, x10 y340 w600 h110, Verschiedene Meldungen
	Gui, Settings: Add, CheckBox, x20 y360 w170 h20 vshowDamageInfo checked%showDamageInfo%, Damage-Infos
	Gui, Settings: Add, CheckBox, x190 y360 w200 h20 vpacketMessages checked%packetMessages%, Paket-Nachrichten
	Gui, Settings: Add, CheckBox, x400 y360 w200 h20 vspotifymessage checked%spotifymessage%, Spotify-Nachrichten
	Gui, Settings: Add, CheckBox, x20 y390 w170 h20 vpaintballMessages checked%paintballMessages%, Paintball-Nachrichten
	Gui, Settings: Add, CheckBox, x190 y390 w200 h20 vpartnerMessages checked%partnerMessages%, Partner-Nachrichten (/d)
	Gui, Settings: Add, CheckBox, x400 y390 w160 h20 vwarningMessages checked%warningMessages%, Vorwarnungsmeldung
	
	Gui, Settings: Add, CheckBox, x20 y420 w160 h20 vwantedAlarm checked%wantedAlarm%, Wanted-Nachrichten
	Gui, Settings: Add, CheckBox, x190 y420 w200 h20 vfrakGreeting checked%frakGreeting%, Member begrüßen?
	Gui, Settings: Add, CheckBox, x400 y420 w200 h20 vrefillWarning checked%refillWarning%, Tank-Warnungen
	
	Gui, Settings: Add, GroupBox, x10 y460 w600 h280, Ausrüstungsprofile
	Gui, Settings: Add, Text, x20 y480 w580 h115, Hier kannst du dir drei Ausrüsten-Profile zusammenstellen und direkt Ingame abrufen.`nDie ersten beiden Profile sind für den normalen Streifendienst gedacht und können standardmäßig mit F4 bzw. F5 ausgewählt werden.`nIm dritten Profil kann zusätzlich ein UC-Skin gewählt werden und du kannst entscheiden`, ob du mit einer Schutzweste auf Streife gehen möchtest oder nicht.`nDie UC-Ausrüstung kannst du standardmäßig mit F6 auswählen.`nGehealt wirst du aber in jedem Fall.
	
	Gui, Settings: Add, Text, x30 y620 w70 h20, Profil 1:
	Gui, Settings: Add, DropDownList, x100 y620 w75 h120 vprofile1_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x183 y620 w75 h120 vprofile1_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x266 y620 w75 h120 vprofile1_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x349 y620 w75 h120 vprofile1_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x432 y620 w75 h120 vprofile1_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x515 y620 w75 h120 vprofile1_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Settings: Choose, profile1_1, %profile1_1%
	GuiControl, Settings: Choose, profile1_2, %profile1_2%
	GuiControl, Settings: Choose, profile1_3, %profile1_3%
	GuiControl, Settings: Choose, profile1_4, %profile1_4%
	GuiControl, Settings: Choose, profile1_5, %profile1_5%
	GuiControl, Settings: Choose, profile1_6, %profile1_6%
	Gui, Settings: Add, Text, x30 y650 w70 h20 , Profil 2:
	Gui, Settings: Add, DropDownList, x100 y650 w75 h120 vprofile2_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x183 y650 w75 h120 vprofile2_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x266 y650 w75 h120 vprofile2_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x349 y650 w75 h120 vprofile2_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x432 y650 w75 h120 vprofile2_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x515 y650 w75 h120 vprofile2_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Settings: Choose, profile2_1, %profile2_1%
	GuiControl, Settings: Choose, profile2_2, %profile2_2%
	GuiControl, Settings: Choose, profile2_3, %profile2_3%
	GuiControl, Settings: Choose, profile2_4, %profile2_4%
	GuiControl, Settings: Choose, profile2_5, %profile2_5%
	GuiControl, Settings: Choose, profile2_6, %profile2_6%
	
	Gui, Settings: Add, Text, x30 y680 w70 h20 , UC-Profil:
	Gui, Settings: Add, DropDownList, x100 y680 w75 h120 vprofile3_1, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x183 y680 w75 h120 vprofile3_2, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x266 y680 w75 h120 vprofile3_3, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x349 y680 w75 h120 vprofile3_4, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x432 y680 w75 h120 vprofile3_5, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	Gui, Settings: Add, DropDownList, x515 y680 w75 h120 vprofile3_6, ||Deagle|Shotgun|MP5|M4|Rifle|Sniper|Schlagstock|Spray
	GuiControl, Settings: Choose, profile3_1, %profile3_1%
	GuiControl, Settings: Choose, profile3_2, %profile3_2%
	GuiControl, Settings: Choose, profile3_3, %profile3_3%
	GuiControl, Settings: Choose, profile3_4, %profile3_4%
	GuiControl, Settings: Choose, profile3_5, %profile3_5%
	GuiControl, Settings: Choose, profile3_6, %profile3_6%
	Gui, Settings: Add, Text, x30 y710 w110 h20, UC-Skin (1-39):
	Gui, Settings: Add, Edit, x150 y710 w75 h20 vucSkin, %ucSkin%
	Gui, Settings: Add, CheckBox, x266 y710 w110 h20 vequipArmour Checked%equipArmour%, Schutzweste
	
	Gui, Settings: Show, h810 w660, %projectName% - Einstellungen - Version %version%
}
return

SettingsGuiClose:
{
	Gui, Settings: Submit, NoHide

	IniWrite, % autoLock, settings.ini, settings, autoLock
	IniWrite, % autoEngine, settings.ini, settings, autoEngine
	IniWrite, % autoFill, settings.ini, settings, autoFill
	IniWrite, % autoLotto, settings.ini, settings, autoLotto
	IniWrite, % antiSpam, settings.ini, settings, antiSpam
	IniWrite, % autoUncuff, settings.ini, settings, autoUncuff
	IniWrite, % autoFrisk, settings.ini, settings, autoFrisk
	IniWrite, % autoTake, settings.ini, settings, autoTake
	IniWrite, % autoWanted, settings.ini, settings, autoWanted
	IniWrite, % autoCustoms, settings.ini, settings, autoCustoms
	IniWrite, % autoLocal, settings.ini, settings, autoLocal
	IniWrite, % autoUse, settings.ini, settings, autoUse
	IniWrite, % fishMode, settings.ini, settings, fishMode
	Iniwrite, % autoHeal, settings.ini, settings, autoHeal
	Iniwrite, % chatlogSaver, settings.ini, settings, chatlogSaver
	IniWrite, % admin, settings.ini, settings, admin

	IniWrite, %lottoNumber%, settings.ini, Einstellungen, Lottozahl
	IniWrite, %cookSystem%, settings.ini, Einstellungen, cookSystem
	

	IniWrite, %keybinderFrac%, settings.ini, Einstellungen, keybinderFrac
	IniWrite, %ownprefix%, settings.ini, Einstellungen, Ownprefix
	IniWrite, %primaryColor%, settings.ini, Einstellungen, Primärfarbe
	IniWrite, %secondaryColor%, settings.ini, Einstellungen, Sekundärfarbe
	
	if (ownprefix != "") {
		prefix := ownprefix . " "
	}
	
	IniWrite, %showDamageInfo%, settings.ini, Einstellungen, showDamageInfo
	IniWrite, %packetMessages%, settings.ini, Einstellungen, PaketNachrichten
	IniWrite, %spotifymessage%, settings.ini, Einstellungen, spotifymessage
	IniWrite, %paintballMessages%, settings.ini, Einstellungen, PaintballNachrichten
	IniWrite, %partnerMessages%, settings.ini, Einstellungen, PartnerNachrichten
	IniWrite, %warningMessages%, settings.ini, Einstellungen, Vorwarnungsnachrichten
	IniWrite, %wantedAlarm%, settings.ini, Einstellungen, WantedAlarm
	IniWrite, %frakGreeting%, settings.ini, Einstellungen, Begrüßungen
	IniWrite, %refillWarning%, settings.ini, Einstellungen, Tankwarnung
	
	IniWrite, %smsSound%, settings.ini, Sounds, smsSound
	IniWrite, %callSound%, settings.ini, Sounds, callSound
	IniWrite, %killSound%, settings.ini, Sounds, killSound
	IniWrite, %deathSound%, settings.ini, Sounds, deathSound
	IniWrite, %backupSound%, settings.ini, Sounds, backupSound
	IniWrite, %emergencySound%, settings.ini, Sounds, emergencySound	
	IniWrite, %leagueSound%, settings.ini, Sounds, leagueSound

	IniWrite, %profile1_1%, settings.ini, Ausrüstungsprofile, Profil1_1
	IniWrite, %profile1_2%, settings.ini, Ausrüstungsprofile, Profil1_2
	IniWrite, %profile1_3%, settings.ini, Ausrüstungsprofile, Profil1_3
	IniWrite, %profile1_4%, settings.ini, Ausrüstungsprofile, Profil1_4
	IniWrite, %profile1_5%, settings.ini, Ausrüstungsprofile, Profil1_5
	IniWrite, %profile1_6%, settings.ini, Ausrüstungsprofile, Profil1_6
	
	IniWrite, %profile2_1%, settings.ini, Ausrüstungsprofile, Profil2_1
	IniWrite, %profile2_2%, settings.ini, Ausrüstungsprofile, Profil2_2
	IniWrite, %profile2_3%, settings.ini, Ausrüstungsprofile, Profil2_3
	IniWrite, %profile2_4%, settings.ini, Ausrüstungsprofile, Profil2_4
	IniWrite, %profile2_5%, settings.ini, Ausrüstungsprofile, Profil2_5
	IniWrite, %profile2_6%, settings.ini, Ausrüstungsprofile, Profil2_6
	
	IniWrite, %profile3_1%, settings.ini, Ausrüstungsprofile, Profil3_1
	IniWrite, %profile3_2%, settings.ini, Ausrüstungsprofile, Profil3_2
	IniWrite, %profile3_3%, settings.ini, Ausrüstungsprofile, Profil3_3
	IniWrite, %profile3_4%, settings.ini, Ausrüstungsprofile, Profil3_4
	IniWrite, %profile3_5%, settings.ini, Ausrüstungsprofile, Profil3_5
	IniWrite, %profile3_6%, settings.ini, Ausrüstungsprofile, Profil3_6
	
	IniWrite, %ucSkin%, settings.ini, Ausrüstungsprofile, UCSkin
	IniWrite, %equipArmour%, settings.ini, Ausrüstungsprofile, Schutzweste
	
	global primcol := "{" . primaryColor . "}"
	global csecond := "{" . secondaryColor . "}"
	global prefix := "|" . primcol . projectName . COLOR_WHITE . "| "

	Gui, Settings: Destroy
	
	reload
}
return

if (keybinderVersion == "overlay") {
	OverlaySettingsGUI:
	{
		Gui, OverlaySettings: Destroy
		
		Gui, OverlaySettings: Color, white
		Gui, OverlaySettings: Font, S10 CDefault, Verdana
		
		Gui, OverlaySettings: Add, Button, x10 y670 w160 h40 gOverlaySettingsSave, Speichern
		Gui, OverlaySettings: Add, Button, x370 y670 w160 h40 gOverlaySettingsGuiClose, Schließen
		
		
		Gui, OverlaySettings: Add, GroupBox, x10 y10 w520 h260, Overlay-Inhalt
		Gui, OverlaySettings: Add, Edit, x20 y30 w500 h230 vstatsOverlayContent, %statsOverlayContent%
		
		Gui, OverlaySettings: Add, GroupBox, x10 y280 w520 h170, Statistik-Overlay Einstellungen
		
		Gui, OverlaySettings: Add, Text, x20 y300 w200 h20, Beim Keybinderstart starten:
		Gui, OverlaySettings: Add, CheckBox, x230 y300 w80 h20 vstatsOverlayAutostart checked%statsOverlayAutostart%, on / off
		
		Gui, OverlaySettings: Add, Text, x20 y330 w90 h20, Koordinaten:
		Gui, OverlaySettings: Add, Text, x130 y330 w10 h20, x
		Gui, OverlaySettings: Add, Text, x130 y360 w10 h20, y
		Gui, OverlaySettings: Add, Text, x20 y390 w120 h20, Farben anzeigen:
		Gui, OverlaySettings: Add, Text, x20 y420 w120 h20, Kursiv anzeigen:
		
		Gui, OverlaySettings: Add, Edit, x150 y330 w70 h20 vstatsOverlayPosX, %statsOverlayPosX%
		Gui, OverlaySettings: Add, Edit, x150 y360 w70 h20 vstatsOverlayPosY, %statsOverlayPosY%
		Gui, OverlaySettings: Add, CheckBox, x150 y390 w80 h20 vstatsOverlayColors checked%statsOverlayColors%, on / off
		Gui, OverlaySettings: Add, CheckBox, x150 y420 w80 h20 vstatsOverlayItalic checked%statsOverlayItalic%, on / off
		
		Gui, OverlaySettings: Add, Text, x230 y330 w145 h20, Schriftart (z.B. Arial):
		Gui, OverlaySettings: Add, Text, x230 y360 w140 h20, Schriftgröße:
		Gui, OverlaySettings: Add, Text, x230 y390 w140 h20, Fett anzeigen:
		Gui, OverlaySettings: Add, Text, x230 y420 w140 h20, Sekundärfarbe:
		
		Gui, OverlaySettings: Add, Edit, x380 y330 w140 h20 vstatsOverlayFont, %statsOverlayFont%
		Gui, OverlaySettings: Add, Edit, x380 y360 w140 h20 vstatsOverlayFontSize, %statsOverlayFontSize%
		Gui, OverlaySettings: Add, CheckBox, x380 y390 w140 h20 vstatsOverlayBold checked%statsOverlayBold%, on / off
		Gui, OverlaySettings: Add, Edit, x380 y420 w140 h20 vstatsOverlayColor, %statsOverlayColor%
		
		Menu, OverlaySettingsInformations, Add, &Informationen, OverlaySettingsInformations
		
		Gui, OverlaySettings: Menu, OverlaySettingsInformations
		
		Gui, OverlaySettings: Show, h720 w540, %projectName% - Overlay - Version: %version%
	}
	return

	OverlaySettingsGuiClose:
	{
		Gui, OverlaySettings: Destroy
	}
	return

	OverlaySettingsSave:
	{
		Gui, OverlaySettings: Submit, NoHide
		
		savedStatsOverlayContent := StrReplace(statsOverlayContent, "`n", "~")
		
		IniWrite, %savedStatsOverlayContent%, settings.ini, StatsOverlay, Content
		IniWrite, %statsOverlayAutostart%, settings.ini, StatsOverlay, Autostart
		IniWrite, %statsOverlayPosX%, settings.ini, StatsOverlay, PosX
		IniWrite, %statsOverlayPosY%, settings.ini, StatsOverlay, PosY
		IniWrite, %statsOverlayColors%, settings.ini, StatsOverlay, Colors
		IniWrite, %statsOverlayItalic%, settings.ini, StatsOverlay, Italic
		IniWrite, %statsOverlayFont%, settings.ini, StatsOverlay, Font
		IniWrite, %statsOverlayFontSize%, settings.ini, StatsOverlay, FontSize
		IniWrite, %statsOverlayBold%, settings.ini, StatsOverlay, Bold
		IniWrite, %statsOverlayColor%, settings.ini, StatsOverlay, Color
		
		statsOverlayprimcolor := csecond
		statsOverlaycsecondor := "{" . statsOverlayColor . "}"
		statsOverlayPositiveColor := "{00962B}"
		statsOverlayNegativeColor := "{CC0000}"
		
		if (statsOverlayEnabled) {
			SetTimer, StatsOverlayTimer, Off
			
			TextDestroy(statsOverlay)
			
			createOverlay(1)
		}
		
		MsgBox, 64, Speicherung, Alle Eingaben und Daten wurden erfolgreich gespeichert!
		
		Gui, OverlaySettings: Destroy
	}
	return

	OverlaySettingsInformations:
	{
		Gui, OverlayVariables: Destroy
		
		Gui, OverlayVariables: Default
		
		Gui, OverlayVariables: Color, white
		Gui, OverlayVariables: Font, S10 CDefault, Verdana
		
		Gui, OverlayVariables: Add, ListView, x10 y10 r20 w460 gOverlayVariablesLV, Platzhalter|Beschreibung
		Gui, OverlayVariables: Add, Button, x310 y450 w160 h40 gOverlayVariablesGuiClose, Schließen
		
		LV_Add("", "-----------------", "Allgemeine Variablen")
		LV_Add("", "[primcol]", "Primärfarbe")
		LV_Add("", "[csecond]", "Sekundärfarbe")
		LV_Add("", "[white]", "Weiß")
		LV_Add("", "[name]", "Dein Name")
		LV_Add("", "[id]", "Deine ID")
		LV_Add("", "[ping]", "Dein Ping")
		LV_Add("", "[fps]", "Deine FPS")
		LV_Add("", "[zone]", "Deine Zone")
		LV_Add("", "[city]", "Deine Stadt")
		LV_Add("", "[hp]", "Deine HP")
		LV_Add("", "[armour]", "Deine Armour")
		LV_Add("", "[money]", "Geld auf der Hand")
		LV_Add("", "[bankmoney]", "Geld auf dem Konto")
		LV_Add("", "[allmoney]", "Gesamtgeld")
		LV_Add("", "[skin]", "Deine Skin-ID")
		LV_Add("", "[weaponid]", "Weapon-ID der aktuellen Waffe")
		LV_Add("", "[weapon]", "Name der aktuellen Waffe")
		LV_Add("", "[freezed]", "ja/nein, ob man gefreezed ist")
		LV_Add("", "[vhealth]", "Fahrzeugzustand in Prozent")
		LV_Add("", "[vmodelid]", "Fahrzeug-Modell-ID")
		LV_Add("", "[vmodel]", "Fahrzeug-Modell-Name")
		LV_Add("", "[vspeed]", "Fahrzeug-Geschwindigkeit")
		LV_Add("", "[fishtime]", "Fisch-Zeit")
		LV_Add("", "[date]", "Aktuelles Datum im Format TT.MM.JJJJ")
		LV_Add("", "[motor]", "Motor-Status")
		LV_Add("", "[lock]", "Lock-Status")
		LV_Add("", "[light]", "Licht-Status")
		LV_Add("", "[checkpoint]", "Distanz zum Checkpoint")
		LV_Add("", "[pdmoney]", "Geld am nächsten Payday (brutto)")
		LV_Add("", "[pdmoneynetto]", "Geld am nächsten Payday (netto)")
		LV_Add("", "[find]", "Spieler auf /af oder /asp")
		LV_Add("", "[partners]", "Eingetragene Partner")
		LV_Add("", "[backup]", "Backup Informationen zeigen")
		
		LV_Add("", "-----------------", "Statistik Variablen")
		LV_Add("", "[wanteds]", "Anzahl der vergebenen Wanteds")
		LV_Add("", "[points]", "Anzahl der vergebenen Punkte")
		LV_Add("", "[pointclear]", "Anzahl der gelöschten Punkte")
		LV_Add("", "[wantedclear]", "Anzahl der gelöschten Wanteds")
		LV_Add("", "[ticketrequests]", "Anzahl der von dir angebotenen Tickets")
		LV_Add("", "[tickets]", "Anzahl der von dir angenommenen Tickets")
		LV_Add("", "[ticketmoney]", "Durch Tickets verdientes Geld")
		LV_Add("", "[arrests]", "Anzahl der eingesperrten Verbrecher")
		LV_Add("", "[deatharrests]", "Anzahl der Death-Arrests")
		LV_Add("", "[offlinearrests]", "Anzahl der Offline-Arrests")
		LV_Add("", "[deathprison]", "Anzahl der Death-Prison")
		LV_Add("", "[offlineprison]", "Anzahl der Offline-Prison")
		LV_Add("", "[crimekills]", "Anzahl der getöteten Verbrecher")
		LV_Add("", "[arrestmoney]", "Durch Verhaftungen verdientes Geld")
		LV_Add("", "[controls]", "Anzahl der Kontrollen")
		LV_Add("", "[trunkcontrols]", "Anzahl der Kofferraumkontrollen")
		LV_Add("", "[radar]", "Anzahl der Radarkontrollen")
		LV_Add("", "[takedmats]", "Anzahl der entzogenen Mats")
		LV_Add("", "[takedpaks]", "Anzahl der entzogenen Mats-Pakete")
		LV_Add("", "[takedbomb]", "Anzahl der entzogenen Haftbomben")
		LV_Add("", "[takeddrugs]", "Anzahl der entzogenen Drogen")
		LV_Add("", "[takedseeds]", "Anzahl der entzogenen Samen")
		LV_Add("", "[plants]", "Anzahl zerstörter Marihuana-Pflanzen")
		LV_Add("", "[plantsmoney]", "Durch Marihuana verdientest Geld")
		LV_Add("", "[locals]", "Anzahl der eingenommenen Ketten")
		LV_Add("", "[stores]", "Anzahl der übernommenen Storers")
		LV_Add("", "[services]", "Anzahl der angenommenen Notrufe")
		LV_Add("", "[tazer]", "Anzahl der Tazer-Benutzungen")		
		LV_Add("", "[fishmoney]", "Durch Fischen verdientes Geld")
		LV_Add("", "[roadblocks]", "Anzahl aufgestellter Straßensperren")
		LV_Add("", "[equipmats]", "Anzahl der verbrauchten Materialien beim Ausrüsten")
		LV_Add("", "[totalmoney]", "Gesamt verdientes Geld")
		
		LV_ModifyCol()
		
		Gui, OverlayVariables: Show, h500 w480, %projectName% - Overlay-Variablen - Version: %version%
	}
	return

	OverlayVariablesLV:
	{
		if A_GuiEvent = DoubleClick
		{
			LV_GetText(RowText, A_EventInfo)
			clipboard := RowText
			ToolTip, Die Variable "%RowText%" wurde in die Zwischenablage kopiert!
			SetTimer, RemoveToolTip, 1000
		}
	}
	return

	RemoveToolTip:
	{
		SetTimer, RemoveToolTip, Off
		ToolTip
	}
	return

	OverlayVariablesGuiClose:
	{
		Gui, OverlayVariables: Destroy
	}
	return
}

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
	Gui, Hotkeys: Add, Text, x320 y480 w170 h20 , /grab
	Gui, Hotkeys: Add, Text, x320 y510 w170 h20 , /ungrab
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
	Gui, Hotkeys: Add, Hotkey, x490 y510 w120 h20 vungrabHotkey gSaveHotkeyLabel, %ungrabNoMods%
	
	Gui, Hotkeys: Tab, Seite 4

	Gui, Hotkeys: Add, Text, x10 y30 w170 h20 , /wanted
	Gui, Hotkeys: Add, Text, x10 y60 w170 h20 , /wanted LS
	Gui, Hotkeys: Add, Text, x10 y90 w170 h20 , /wanted SF
	Gui, Hotkeys: Add, Text, x10 y120 w170 h20 , /wanted LV
	Gui, Hotkeys: Add, Text, x10 y150 w170 h20 , /wanted INT
	
	Gui, Hotkeys: Add, Edit, x190 y30 w120 h20 ReadOnly, LWin
	Gui, Hotkeys: Add, Edit, x190 y60 w120 h20 ReadOnly, LWin + 1
	Gui, Hotkeys: Add, Edit, x190 y90 w120 h20 ReadOnly, LWin + 2
	Gui, Hotkeys: Add, Edit, x190 y120 w120 h20 ReadOnly, LWin + 3
	Gui, Hotkeys: Add, Edit, x190 y150 w120 h20 ReadOnly, LWin + 4
	
	
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
		Stattdessen können diese alternativ in der Hotkeys.ini eingetragen werden.
		Beispielsweise können so auch die Maustasten "xButton1" und "xButton2" belegt werden, was hier im GUI nicht möglich ist.
		
		Ein Speichern ist nicht notwendig, da dies automatisch geschieht.
		Solltest du aber manuelle Änderungen in der Hotkeys.ini durchgeführt haben, musst du den Keybinder neustarten!
	)
}
return

ResetHotkeys:
{
	FileDelete, Hotkeys.ini
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
		IniWrite, ---, Hotkeys.ini, Hotkeys, %name%
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
			IniWrite, %hk%, Hotkeys.ini, Hotkeys, %name%
			
			registeredHotkeys[name] := hk
		} else {
			IniWrite, ---, Hotkeys.ini, Hotkeys, %name%
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
.:: Overlay ::. 
/ov -> Overlay de/aktivieren (einzeln)
/ovall -> Alle Overlays de/aktivieren
/ovmove -> Overlay bewegen
/ovsave -> Overlay speichern

.:: Zollsystem ::.
/zollhelp -> Keys / Befehle für Zollsachen anzeigen
/zollinfo -> Alle Zollstationen auflisten

.:: Deathmatch ::. 
/kd -> K/D für sich anzeigen
/fkd -> K/D im /f anzeigen
/dkd -> K/D im /d anzeigen
/setkd -> K/D setzen (über Stats)
/resetdkd -> Tages K/D zurückgesetzen
/bossmode -> Bossmodus aktivieren
/items -> Zeigt alle Items an

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
/off -> Meldet sich vom Dienst ab! (/d)
/on -> Meldet sich zum Dienst! (/d)
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
/dsp -> Marihuana zerstören
/ci -> Fahrzeuginformationen anzeigen
/pi -> Spielerinformationen anzeigen
/uc -> Undercover gehen
/auc -> Random Undercover Skin
/sbd -> Dienstmarke zeigen

.:: MauMau System ::. 
/mr -> /mauready
/mn -> /maunext
/md -> /maudraw
/am -> /accept maumau
/ml -> /mauleave
/maumodus -> MauModus anschalten
/mhelp -> MauMau Hilfen

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
/afish -> Schnelles fischen
/asell -> Schnelles Fische verkaufen
/acook -> Schnelles Fische kochen
/fischtyp -> Fisch-Typ setzen (Gewicht, Wert)
/fische -> Ungekochte Fische checken
/hp -> Gekochte Fische checken
/sellfish -> Jemanden deine gekochten Fische schenken
/fpsunlock

.:: Überarbeite Serverbefehle ::. 
/q -> Setzt Variablen zurück 
/pbexit -> Gibt Armour nach PB wieder
/heal -> Healcooldown
/erstehilfe -> First-Aid Cooldown
/tim -> Knast / KH Zeit anzeigen
/paintball -> Spielerzahl anzeigen
/fill -> An /tanken angepasst
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

RPGConnect:
{
	RegRead GTA_SA_EXE, HKEY_CURRENT_USER, Software\SAMP, gta_sa_exe
	SplitPath, GTA_SA_EXE,, PFAD
	
	run, %PFAD%\samp.exe samp.rpg-city.de, %PFAD%
}
return

handleChatMessage(message, index, arr) {
	global
	
	if (RegExMatch(message, "^Es befindet sich zu wenig Kraftstoff im Fahrzeug, um den Motor zu starten\.$", message_)) {
		SetTimer, RefillTimer, 1
	} else if (RegExMatch(message, "^Paintball: (\S+) hat die Arena betreten\.$", message_)) {
		if (message_1 == getUserName()) {
			isPaintball := true 
			SendClientMessage(prefix . "Der Paintball-Modus wurde " . COLOR_GREEN . "angeschaltet" . COLOR_WHITE . ".")
		}
	} else if (RegExMatch(message, "^Du hast dir ein Lagerfeuer gekauft\.$", message_)) {
		getCampfire(1)
	} else if (RegExMatch(message, "^Du hast ein Lagerfeuer in der Mülltonne gefunden\.$", message_)) {
		getCampfire(1)
	} else if (RegExMatch(message, "^Du besitzt kein Erste-Hilfe-Paket\.$", message_)) {
		getFirstAid(1)
 	} else if (RegExMatch(message, "^Du hast ein Erstehilfe-Paket erworben \(-(.*)$\).$", message_)) {
		getFirstAid(1)
	} else if (RegExMatch(message, "^Du hast ein Erste-Hilfe-Paket im Müll gefunden\.$", message_)) {
		getFirstAid(1)
 	} else if (RegExMatch(message, "\* Du hast für \$(.*) ein Erste-Hilfe-Paket von (\S+) gekauft\.$", message_)) {
		getFirstAid(1)
	} else if (RegExMatch(message, "^\* " . getUserName() . " benutzt ein Erste-Hilfe-Paket und versorgt die Wunden\.$", message_)) {
		IniWrite, 600, settings.ini, Cooldown, pakcooldown
	
		getFirstAid(1)
	} else if (RegExMatch(message, "^\* " . getUserName() . " hat Drogen konsumiert.$", message_)) {
		getDrugs(1)
		drugcooldown := 30
	} else if (RegExMatch(message, "^(.*)g Drogen aus den Safe geholt\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^(.*)g wurden in den Safe gelegt\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^\* (\S+) hat deine (.*)g für (.*)\$ gekauft\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^\* Du hast (.*)g für (.*)$ von (\S+) gekauft\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^\[ AIRDROP \] (\S+) hat den Airdrop abgegeben und (\d+)g Drogen erhalten\.$", message_)) {
		if (message_1 == getUserName()) {
			getDrugs(1)	
		}
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen ausgelagert\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen eingelagert\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^Du hast (.*)g Drogen für (.*)\$ erworben\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^Du hast (\d+)g Marihuana in der Mülltonne gefunden\.$", message_)) {
		getDrugs(1)
	} else if (RegExMatch(message, "^Du bist nun im SWAT-Dienst als Agent (\d+)\.$", message_)) {
		agentID := message_1
		SendChat("/f Agent " . agentID . " meldet sich zum Dienst!")
	} else if (RegExMatch(message, "^Du bist nicht mehr im SWAT-Dienst$", message_)) {
		SendChat("/f Agent " . agentID . " meldet sich vom Dienst ab!")
		agentID := -1
	} else if (RegExMatch(message, "^Du beginnst in einer Mülltonne rumzuschnüffeln\.$", message_)) {
		iniRead, trashs, Stats.ini, Mülltonnen, trashs, 0
		trashs ++
		iniWrite, % trashs, Stats.ini, Mülltonnen, trashs
		
		SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(trashs) . COLOR_WHITE . " Mülltonnen durchwühlt.")
	} else if (RegExMatch(message, "^Du (.*) in der Mülltonne gefunden.$", message_)) {
		if (RegExMatch(message_1, "^hast nichts$", msg_)) {
			iniRead, nothing, Stats.ini, Mülltonnen, nothing, 0
			nothing ++
			iniWrite, % nothing, Stats.ini, Mülltonnen, nothing
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(nothing) . COLOR_WHITE . " nichts in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast ein Lagerfeuer$", msg_)) {
			iniRead, campfire, Stats.ini, Mülltonnen, campfire, 0
			campfire ++
			iniWrite, % campfire, Stats.ini, Mülltonnen, campfire
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(campfire) . COLOR_WHITE . " Lagerfeuer in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast (.*)\$$", msg_)) {
			iniRead, money, Stats.ini, Mülltonnen, money, 0
			money += numberFormat(msg_1)
			iniWrite, % money, Stats.ini, Mülltonnen, money
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(money) . COLOR_WHITE . "$ in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast (\d+) Stunden (\S+)$", msg_)) {
			if (RegExMatch(msg_2, "VIP")) {
				iniRead, vip, Stats.ini, Mülltonnen, vip, 0
				vip += msg_1
				iniWrite, % vip, Stats.ini, Mülltonnen, vip
				SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(vip) . COLOR_WHITE . " Stunden VIP in Mülltonnen gefunden.")
			} else if (RegExMatch(msg_2, "Premium")) {
				iniRead, prem, Stats.ini, Mülltonnen, prem, 0
				prem += msg_1
				iniWrite, % prem, Stats.ini, Mülltonnen, prem
				SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(prem) . COLOR_WHITE . " Stunden Premium in Mülltonnen gefunden.")
			}
		} else if (RegExMatch(message_1, "^hast (\d+) Respektpunkte$", msg_)) {
			iniRead, respect, Stats.ini, Mülltonnen, respect, 0
			respect += msg_1
			iniWrite, % respect, Stats.ini, Mülltonnen, respect
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(respect) . COLOR_WHITE . " Respektpunkte in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast (\d+)g Marihuana$", msg_)) {
			iniRead, drugs, Stats.ini, Mülltonnen, drugs, 0
			drugs += msg_1
			iniWrite, % drugs, Stats.ini, Mülltonnen, drugs
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(drugs) . COLOR_WHITE . "g Drogen in Mülltonnen gefunden.")
		} else if (RegExMatch(message_1, "^hast eine Schlagwaffe \((.*)\)$", msg_)) {
			iniRead, weaps, Stats.ini, Mülltonnen, weaps, 0
			weaps ++
			iniWrite, % weaps, Stats.ini, Mülltonnen, weaps
			
			SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(weaps) . COLOR_WHITE . " Waffen in Mülltonnen gefunden.")
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
				if (name == message_2) {
					SendClientMessage("[DEBUG]: " . grabName . " befindet sich schon in der Cuffliste!")
					return
				}
			}
			
			SendClientMessage("[DEBUG]: " . message_2 . " wurde in die Cuffliste aufgenommen!")
			grabList.Push(message_2)
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+)'s Handschellen entfernt\.$", message_)) {
		toRemove := []
	
		for index, grabName in grabList {
			if (grabName == message_1) {
				SendClientMessage(prefix . "[DEBUG] " . COLOR_RED . "Index: " . index . ", Name: " . grabName)
				toRemove.Push(index)
			}
		}
	
		for i, id in toRemove {
			SendClientMessage(prefix . "[DEBUG] " . COLOR_RED . "I: " . i . ", ID: " . id)
			grabList.RemoveAt(id)
		}
	} else if (RegExMatch(message, "^\* (\S+) hat seine Kevlarweste (.*)$", message_)) {
		if (getUserName() == message_1) {			
			if (InStr(message, "abgelegt")) {
				isZivil := 1
				
				SendClientMessage(prefix . "Du bist nun Zivil.")
			} else if (RegExMatch(message, "angelegt")) {
				isZivil := 0
			
				SendClientMessage(prefix . "Du bist nun im Dienst.")
			}
		}
	} else if (RegExMatch(message, "^Du bist nun wieder im Dienst!$", message_)) {
		isZivil := 1
	} else if (RegExMatch(message, "^Du bist nun nicht mehr im Dienst!$", message_)) {
		isZivil := 0
	} else if (RegExMatch(message, "^(\S+) sagt: (.+)", message_)) {
		if (message_1 != getUserName()) {			
			if (InStr(message_2, "ticket") || InStr(message_2, "tkt") || InStr(message_2, "tigget")) {
				requestName := message_1
				
				SetTimer, RequestTimer, 1
			}
			
			if (InStr(message_2, "sucht") && InStr(message_2, "member") || InStr(message_2, "invite")) {
				if (oldInviteAsk != message_1) {
					oldInviteAsk := message_1
					
					SendChat("/l Nein.")
				}
			}
		}
		
	} else if (RegExMatch(message, "^\*\* (.+) (\S+): HQ: Bitte Zollstation (\S+) schließen! \*\*", message_)) {
		if (message_2 != getUserName()) {
			if (checkRank()) {
				if (getRank() > 4) {
					closeZoll := message_3
					
					SetTimer, CloseZollTimer, 1
				}
			}
		}
	} else if (RegExMatch(message, "^\*\* (.*) (\S+): Der Spieler (\S+) \(ID: (\d+)\) (.*)\. \*\*", line_)) {
		if (line_2 != getUserName()) {
			wantedIA := line_3
			wantedContracter := line_2
			wantedIAReason := line_5
	
			SetTimer, WantedIATimer, 1
		}
	} else if (RegExMatch(message, "^\*\* (.*) (\S+): Ich konnte bei dem Spieler (\S+) \(ID: (\d+)\) (\d+) feststellen\. \*\*", line_)) {
		if (line_2 != getUserName()) {
			wantedIA := line_3
			wantedContracter := line_2
			wantedIAReason := line_5
	
			SetTimer, WantedIATimer, 1
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
	} else if (RegExMatch(message, "^\*\* (.+) (\S+): HQ: Bitte Zollstation (\S+) öffnen! \*\*", message_)) {
		if (message_2 != getUserName()) {		
			if (checkRank()) {
				if (getRank() > 4) {
					openZoll := message_3
					
					SetTimer, OpenZollTimer, 1
				}
			}
		}
	} else if (RegExMatch(message, "^WARNUNG: Hör auf zu Spamen, sonst wirst du gekickt!$")) {
		if (antiSpam) {
			blockChatInput()
			
			SendClientMessage(prefix . "Das Antispam System wurde " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
			
			SetTimer, SpamTimer, -1500
		}
	} else if (RegExMatch(message, "^\[Fraktion\]: (\S+) hat sich eingeloggt\.$", message_)) {
		if (frakGreeting) {
			loginName := message_1
			
			SetTimer, HelloTimer, 1
		}
	} else if (RegExMatch(message, "^\* Sanitäter (\S+) bietet dir ein Erste-Hilfe-Paket für \$(\d+) an\. Benutze \/accept Paket$", message_)) {
		medicName := message_1
		
		SetTimer, PaketTimer, 1
	} else if (RegExMatch(message, "^Paintball: (\S+) wurde von (\S+) getötet\.$", message_)) {
		if (message_1 == getUsername()) {
			IniRead, pbdeaths, stats.ini, stats, pbdeaths, 0
			pbdeaths ++
			IniWrite, %pbdeaths%, stats.ini, stats, pbdeaths
			
			IniRead, pbdeaths, stats.ini, stats, pbdeaths, 0
			IniRead, pbkills, stats.ini, stats, pbkills, 0
			
			pbKillStreak := 0
			
			SendClientMessage(prefix . "Tode: " . csecond . FormatNumber(pbdeaths) . COLOR_WHITE . " | Kills: " . csecond . FormatNumber(pbkills) . COLOR_WHITE . " | K/D: " . csecond . round(pbkills/pbdeaths, 3))
			
			if (pbKillStreak > 0 && paintballMessages)  {
				SendChat("/l Meine Killstreak war: " . pbKillStreak)
			}
			
			pbKillStreak := 0
		} else if (message_2 == getUsername()) {			
			IniRead, pbkills, stats.ini, stats, pbkills, 0
			pbkills ++
			IniWrite, %pbkills%, stats.ini, stats, pbkills
			
			IniRead, pbkills, stats.ini, stats, pbkills, 0
			IniRead, pbdeaths, stats.ini, stats, pbdeaths, 0			
			
			SendClientMessage(prefix . "Kills: " . csecond . FormatNumber(pbkills) . COLOR_WHITE . " | Tode: " . csecond . FormatNumber(pbDeaths) . COLOR_WHITE . " | K/D: " . csecond . round(pbkills/pbdeaths, 3))
			
			pbKillStreak ++
			
			IniRead, pbHighestKillStreak, stats.ini, stats, Killstreak, 0
			
			if (pbKillStreak > pbHighestKillStreak) {
				IniWrite, %pbKillStreak%, stats.ini, stats, Killstreak
				
				if (paintballMessages) {
					SendChat("/l Meine neue beste Killstreak: " . pbKillStreak)
				}
			} else {
				if (paintballMessages) {
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
			
			SendClientMessage(prefix . "Gehaltsscheck: " . csecond . FormatNumber(money) . "$")
		
			paydayMoney := 0
		}
	} else if (RegExMatch(message, "^ > " . getUsername() . " beobachtet (\S+)\.$", message_)) {
		if (!tv) {
			tv := true
			tvName := message_1
		
			SendClientMessage(prefix . "Beobachtungsmodus " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
		}
	} else if (RegExMatch(message, "^ > " . getUsername() . " hat die Beobachtung beendet\.$")) {
		if (tv) {
			tv := false
			
			SendClientMessage(prefix . "Beobachtungsmodus " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
		}
	} else if (RegExMatch(message, "^Du hast dich ausgerüstet, es wurden (.*) Materialien benötigt\. \(Verbleibend: (.*) Materialien\)$", line0_)) {
		IniRead, Equipmats, stats.ini, Allgemein, Equipmats, 0
		Equipmats += numberFormat(line0_1)
		IniWrite, %equipmats%, stats.ini, Allgemein, Equipmats
		IniRead, DailyMats, stats.ini, stats, %A_DD%_%A_MM%_%A_YYYY%_Mats, 0
		DailyMats += numberFormat(line0_1)
		IniWrite, %DailyMats%, stats.ini, stats, %A_DD%_%A_MM%_%A_YYYY%_Mats
		
		if (DailyMats < 3000) {
			SendClientMessage(prefix . COLOR_GREY . "Materialverbrauch heute: " . FormatNumber(DailyMats))
		} else if (DailyMats > 3000 && DailyMats < 5000) {
			SendClientMessage(prefix . COLOR_YELLOW . "Materialverbrauch heute: " . FormatNumber(DailyMats))
		} else if (DailyMats > 5000 && DailyMats < 10000) {
			SendClientMessage(prefix . COLOR_ORANGE . "Materialverbrauch heute: " . FormatNumber(DailyMats))
		} else if (DailyMats > 10000) {
			SendClientMessage(prefix . COLOR_RED . "Materialverbrauch heute: " . FormatNumber(DailyMats))
		}
		
		hasEquip := 1
	} else if (RegExMatch(message, "^\HQ: (.+) (\S+) hat eine Straßensperre in (.+) aufgebaut\.", line0_)) {
		if (line0_2 == getUserName())  {
			IniRead, roadblocks, stats.ini, Allgemein, roadblocks, 0
			roadblocks ++
			IniWrite, %roadblocks%, stats.ini, Allgemein, Roadblocks
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(roadblocks) . COLOR_WHITE . " Straßensperren aufgebaut.")
		}
	} else if (RegExMatch(message, "^HQ: (.+) (\S+) hat (\S+) (\d+) (\S+) aus der Akte entfernt\.$", line0_)) {
		if (line0_2 == getUserName()) {
			if (line0_5 == "Strafpunkte") {
				IniRead, Pointsclear, stats.ini, Vergaben, Pointsclear, 0
				Pointsclear += line0_4
				IniWrite, %Pointsclear%, stats.ini, Vergaben, Pointsclear
				
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Pointsclear) . COLOR_WHITE . " Strafpunkte gelöscht.")
			} else if (line0_5 == "Wanteds") {
				IniRead, Wantedsclear, stats.ini, Vergaben, Wantedsclear
				Wantedsclear += line0_4
				IniWrite, %Wantedsclear%, stats.ini, Vergaben, Wantedsclear
				
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Wantedsclear) . COLOR_WHITE . " Wanteds gelöscht.")
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) ein Ticket für (.*)\$ gegeben, Grund: (.+)$", line0_)) {
		if (RegExMatch(line0_3, "Wanted-Ticket \((\d+) Wanteds?\)", wanteds_)) {
			wantedTicket := []
			wantedTicket["name"] := line0_1
			wantedTicket["wanteds"] := wanteds_1
			
			wantedTickets.Push(wantedTicket)
		}
		 
		IniRead, Ticketrequests, stats.ini, Tickets, Ticketrequests, 0
		Ticketrequests ++
		IniWrite, %Ticketrequests%, stats.ini, Tickets, Ticketrequests
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Ticketrequests) . COLOR_WHITE . " Tickets ausgestellt.")
	} else if (RegExMatch(message, "^\* (\S+) hat dein Ticket in Höhe von (.*)\$ bezahlt\.$", line0_)) {
		ticketMoney := line0_2
		paydayMoney += numberFormat(ticketMoney)
		
		payPartnerMoney(numberFormat(ticketMoney), "ticket_money")

		IniRead, Tickets, stats.ini, Tickets, Tickets, 0
		Tickets ++
		IniWrite, %Tickets%, stats.ini, Tickets, Tickets
		
		SendClientMessage(prefix . "Es wurden bereits " . csecond . FormatNumber(Tickets) . COLOR_WHITE . " Tickets von dir angenommen.")
		
		for index, wantedTicket in wantedTickets {
			if (line0_1 == wantedTicket["name"]) {
				wantedTicketId := index
				
				SendChat("/clear " . wantedTicket["name"] . " " . wantedTicket["wanteds"])
				break
			}
		}
		
		wantedTicketId := -1
		
		if (wantedTicketId != -1) {
			wantedTickets.RemoveAt(wantedTicketId)
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) seinen (\S+) weggenommen\.$", message_)) {
		if (message_2 == "Flugschein") {
			IniRead, Flugschein, stats.ini, Scheine, Flugschein, 0
			Flugschein ++
			IniWrite, %fstakes%, stats.ini, Scheine, Flugschein
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . formatNumber(Flugschein) . COLOR_WHITE . " Flugscheine entzogen.")
			SendClientMessage(prefix . "Der Schaden durch Flugscheine beläuft sich auf " . csecond . formatNumber(Flugschein * 12000) . "$")
		} else if (message_2 == "Bootschein") {
			IniRead, Bootschein, stats.ini, Scheine, Bootschein, 0
			Bootschein ++
			IniWrite, %Bootschein%, stats.ini, Scheine, Bootschein
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . formatNumber(Bootschein) . COLOR_WHITE . " Bootscheine entzogen.")
			SendClientMessage(prefix . "Der Schaden durch Bootscheine beläuft sich auf " . csecond . formatNumber(Bootschein * 6000) . "$")
		} else if (message_2 == "Waffenschein") {
			IniRead, Waffenschein, stats.ini, Scheine, Waffenschein, 0
			Waffenschein ++
			IniWrite, %Waffenschein%, stats.ini, Scheine,  Waffenschein
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . formatNumber(Waffenschein) . COLOR_WHITE . " Waffenscheine entzogen.")
			SendClientMessage(prefix . "Der Schaden durch Waffenscheine beläuft sich auf " . csecond . formatNumber(Waffenschein * 36000) . "$")
		}
	} else if (RegExMatch(message, "^\* (\S+) nimmt Geld aus seiner Tasche und gibt es " . getUsername() . "\.$", line0_)) {
		if (RegExMatch(arr[index - 1], "^Du hast (.*)\$ von (\S+)\((\d+)\) erhalten\.$", line1_)) {
			playerCoords := getCoordinates()
			
			if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 1564.5, -1694.5, 6.5) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], -1589.5, 716, -4.5) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 2281.5, 2431, 4) < 20) {
			} else if (getDistanceToPoint(playerCoords[1], playerCoords[2], playerCoords[3], 2341.6, -2028.5, 13) < 20) {
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
				IniRead, Money, stats.ini, Verhaftungen, Money, 0
				Money += numberFormat(line1_1)
				IniWrite, %Money%, stats.ini, Verhaftungen, Money
				
				IniRead, Arrests, stats.ini, Verhaftungen, Arrests, 0
				Arrests ++
				IniWrite, %arrests%, stats.ini, Verhaftungen, Arrests				
				
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Arrests) . COLOR_WHITE . " Verbrecher eingesperrt.")
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Money) . "$" . COLOR_WHITE . " durch Verhaftungen verdient.")
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+)g Drogen weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Drugs, stats.ini, Kontrollen, Drugs, 0
		Drugs += numberFormat(line0_2)
		IniWrite, %drugs%, stats.ini, Kontrollen, Drugs
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(drugs) . "g" . COLOR_WHITE . " Drogen weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Samen weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Seeds, stats.ini, Kontrollen, Seeds, 0
		Seeds += numberFormat(line0_2)
		IniWrite, %seeds%, stats.ini, Kontrollen, Seeds
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(seeds) . COLOR_WHITE . " Samen weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (.*) Materialien weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Mats, stats.ini, Kontrollen, Mats, 0
		Mats += numberFormat(line0_2)
		IniWrite, %Mats%, stats.ini, Kontrollen, Mats
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Mats) . COLOR_WHITE . " Materialien weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Materialpakete weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Matpackets, stats.ini, Kontrollen, Matpackets, 0
		Matpackets += numberFormat(line0_2)
		IniWrite, %Matpackets%, stats.ini, Kontrollen, Matpackets
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Matpackets) . COLOR_WHITE . " Materialpakete weggenommen.")
	} else if (RegExMatch(message, "^\* Du hast (\S+) seine (\d+) Haftbomben weggenommen\.$", line0_)) {
		for index, value in checkingPlayers {
			if (line0_1 == value) {
				return
			}
		}
		
		IniRead, Matbombs, stats.ini, Kontrollen, Matbombs, 0
		Matbombs += line0_2
		IniWrite, %Matbombs%, stats.ini, Kontrollen, Matbombs
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Matbombs) . COLOR_WHITE . " Haftbomben weggenommen.")
	} else if (RegExMatch(message, "^Du hast (.*) (.+) aus dem Kofferraum konfisziert\.$", message_)) {
		if (message_2 == "Materialien") {
			IniRead, Mats, stats.ini, Kontrollen, Mats, 0
			Mats += numberFormat(message_1)
			IniWrite, %Mats%, stats.ini, Kontrollen, Mats
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(mats) . COLOR_WHITE . " Materialien weggenommen.")
		} else if (message_2 == "Gramm Drogen") {
			IniRead, drugs, stats.ini, Kontrollen, drugs, 0
			drugs += numberFormat(message_1)
			IniWrite, %drugs%, stats.ini, Kontrollen, Drugs
		
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(drugs) . "g " . COLOR_WHITE . "Drogen weggenommen.")
		}
	} else if (RegExMatch(message, "^\* (.*) schießt mit seinen Elektroschocker auf (\S+) und setzt ihn unter Strom\.$", message_)) {
		if (RegExMatch(message, "^Agent (\d+)$", agent_)) {
			agent_ID := agent_1
		}
		
		if (getUserName() == message_1 || agentID == agent_ID) {
			IniRead, tazer, stats.ini, Allgemein, tazer, 0
			tazer ++
			IniWrite, %tazer%, stats.ini, Allgemein, Tazer
		
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(tazer) . COLOR_WHITE . " Spieler getazert.")
			
			for index, grabName in grabList {
				if (name == message_2) {
					SendClientMessage("[DEBUG]: " . grabName . " befindet sich schon in der Cuffliste!")
					return
				}
			}
			
			SendClientMessage("[DEBUG]: " . message_2 . " wurde in die Cuffliste aufgenommen!")
			grabList.Push(message_2)
		} else {
			for index, partner in partners {
				if (getFullName(partner) == message_1) {
					for index2, grabname in grabList {
						if (message_2 == grabName) {
							SendClientMessage("[DEBUG]: " . grabName . " befindet sich bereits in der Cuffliste!")
							return
						}
					}
					
					grabList.Push(message_2)
					SendClientMessage("[DEBUG]: " . message_2 . " wurde in die Cuffliste aufgenommen!")
				}
			}
		}
	} else if (RegExMatch(message, "^\* Du hast (\S+) ins Fahrzeug gezogen\.$", message_)) {
		toRemove := []
	
		for index, grabName in grabList {
			if (message_1 == grabName) {
				toRemove.Push(index)
				SendClientMessage("[DEBUG]: " . grabName . " wurde aus der Cuffliste entfernt (Schritt 1)!")
			}
		}
	
		for index, grabID in toRemove {
			grabList.RemoveAt(grabID)
			SendClientMessage("[DEBUG]: Slot-" . grabID . " wurde aus der Cuffliste entfernt (Schritt 1)!")
		}
	} else if (RegExMatch(message, "^\* Der Staat übernimmt die Kosten\.$", message_)) {
		if (REgExMatch(arr[index - 1], "^\* Du hast (.*) Liter getankt für (.*)\$\.$", line0_)) {
			IniRead, govfills, stats.ini, Allgemein, govfills, 0
			govfills += numberFormat(line0_1)
			IniWrite, %govfills%, stats.ini, Allgemein, govfills
			
			IniRead, govfillprice, stats.ini, Allgemein, govfillprice, 0
			govfillprice += numberFormat(line0_2)
			IniWrite, %govfillprice%, stats.ini, Allgemein, govfillprice
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(govfills) . COLOR_WHITE . " Liter getankt.")
			SendClientMessage(prefix . "Die Tankkosten belaufen sich auf " . csecond . formatNumber(govfillprice) . "$")		
		}
	} else if (RegExMatch(message, "^HQ: (\S+) wurde getötet, Haftzeit: (\S+) Minuten, Geldstrafe: (.*)\$$", line0_)) {
		if (RegExMatch(message, "^HQ: Alle Einheiten, (.*) (\S+) hat den Auftrag ausgeführt\.$", line1_)) {
			if (line0_1 == getFullName(playerToFind)) {
				stopFinding()
			}			
			
			if (line1_2 == getUserName()) {
				IniRead, Crimekills, stats.ini, Verhaftungen, Crimekills, 0
				Crimekills ++
				IniWrite, %Crimekills%, stats.ini, Verhaftungen, Crimekills
				
				SendClientMessage(prefix . "Dies war dein " . csecond . FormatNumber(Crimekills) . COLOR_WHITE . " getöteter Verbrecher.")
			}
			
			for index, grabName in grabList {
				if (line0_1 == grabName) {
					toRemove.Push(index)
					SendClientMessage("[DEBUG]: " . grabName . " wurde aus der Cuffliste entfernt (Schritt 1)!")
				}
			}
		
			for index, grabID in toRemove {
				grabList.RemoveAt(grabID)
				SendClientMessage("[DEBUG]: Slot-" . grabID . " wurde aus der Cuffliste entfernt (Schritt 1)!")
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
						wanteds := line0_2 / 3
						amoney := wanteds * 750
								
						if (amoney > 16000) {
							amoney := 16000
						}
								
						amoney := Floor(amoney * taxes)
						paydayMoney += numberFormat(amoney)
						totalArrestMoney += numberFormat(amoney)
						
						if (!deathArrested) {
							IniRead, Arrests, stats.ini, Verhaftungen, Arrests, 0
							Arrests ++
							IniWrite, %arrests%, stats.ini, Verhaftungen, Arrests
							
							SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(arrests) . COLOR_WHITE . " Verbrecher eingesperrt.")
							
							SetTimer, PartnerMoneyTimer, 1
						}
					} else {
						deathArrested := false
					
						IniRead, Deatharrests, stats.ini, Verhaftungen, Deatharrests, 0
						Deatharrests ++
						IniWrite, %deathArrests%, stats.ini, Verhaftungen, Deatharrests
						
						SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(deathArrests) . COLOR_WHITE . " Verbrecher nach dem Tod eingesperrt.")
						
						SetTimer, PartnerMoneyTimer, 1
					}
				} else {
					if (deathArrested) {
						deathArrested := false
		
						IniRead, deathprison, stats.ini, Verhaftungen, deathprison, 0
						deathprison ++
						IniWrite, %deathPrison%, stats.ini, Verhaftungen, deathprison
						
						SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(deathPrison) . COLOR_WHITE . " Verbrecher nach dem Tod ins Prison gesteckt.")
					}
				}
			}
			
			for index, grabName in grabList {
				if (line0_1 == grabName) {
					toRemove.Push(index)
					SendClientMessage("[DEBUG]: " . grabName . " wurde aus der Cuffliste entfernt (Schritt 1)!")
				}
			}
		
			for index, grabID in toRemove {
				grabList.RemoveAt(grabID)
				SendClientMessage("[DEBUG]: Slot-" . grabID . " wurde aus der Cuffliste entfernt (Schritt 1)!")
			}				
		}
	} else if (RegExMatch(message, "^HQ: Haftzeit: (\d+) Minuten, Geldstrafe: (.*)\$\.$", line0_)) {
		if (RegExMatch(arr[index - 1], "^HQ: (.*) (\S+) hat den Verdächtigen (\S+) offline eingesperrt\.$", line1_)) {
			if (line1_3 == getFullName(playerToFind)) {
				stopFinding()
			}
				
			if (line1_2 == getUserName()) {
				if (line0_2 > 0) {
					IniRead, Offlineprison, stats.ini, Verhaftungen, Offlineprison, 0
					Offlineprison ++
					IniWrite, %offlinePrison%, stats.ini, Verhaftungen, Offlineprison
					
					SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(offlinePrison) . COLOR_WHITE . " Verbrecher offline ins Prison gesteckt.")
				} else {
					wanteds := line0_1 / 3
					amoney := wanteds * 750
					
					if (amoney > 16000) {
						amoney := 16000
					}
					
					amoney := Floor(amoney * taxes)
					paydayMoney += numberFormat(amoney)
					totalArrestMoney += numberFormat(amoney)
				
					IniRead, offlinearrests, stats.ini, Verhaftungen, offlinearrests, 0
					offlinearrests ++
					IniWrite, %offlineArrests%, stats.ini, Verhaftungen, offlinearrests
					
					SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(offlineArrests) . COLOR_WHITE . " Verbrecher offline eingesperrt.")
					
					SetTimer, PartnerMoneyTimer, 1
				}
			}
			
			for index, grabName in grabList {
				if (line1_3 == grabName) {
					toRemove.Push(index)
					SendClientMessage("[DEBUG]: " . grabName . " wurde aus der Cuffliste entfernt (Schritt 1)!")
				}
			}
		
			for index, grabID in toRemove {
				grabList.RemoveAt(grabID)
				SendClientMessage("[DEBUG]: Slot-" . grabID . " wurde aus der Cuffliste entfernt (Schritt 1)!")
			}				
		}
	} else if (RegExMatch(message, "^HQ: (.+) " . getUsername() . " hat das Marihuana in (.+) gefunden und zerstört\.$", chat_)) {
		IniRead, plants, stats.ini, Marihuana, plants, 0
		plants ++
		IniWrite, %plants%, stats.ini, Marihuana, Plants
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(plants) . COLOR_WHITE . " Marihuana-Pflanzen zerstört.")
		
		adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
		cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
		
		if (RegExMatch(cText, "Marihuana zerstoert~n~~g~(.*)\$", cText_)) {
			paydayMoney += numberFormat(cText_1)
			payPartnerMoney(numberFormat(cText_1), "plants_money")
		}		
	} else if (RegExMatch(message, "^HQ: \+\+\+ Alle Einheiten \+\+\+$")) {
		if (RegExMatch(arr[index - 2], "^HQ: \+\+\+ Alle Einheiten \+\+\+$")) {
			mdcChat1 := arr[index - 1]
	
			if (RegExMatch(mdcChat1, "^HQ: Jemand versucht das Zellentor aufzubrechen\.$")) {
				ShowGameText("~r~Ausbruch~n~~w~Zellentor", 8000, 1)
				
				iniRead, outbreak, Stats.ini, Stats, outbreak, 0
				outbreak ++
				iniWrite, % outbreak, Stats.ini, Stats, outbreak
				
				SendClientMessage(prefix . "Es wurde ein Ausbruch (" . cSecond . "#Fall " . outbreak . COLOR_WHITE . ") gemeldet!")

				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			} else if (RegExMatch(mdcChat1, "^HQ: Jemand versucht das Verwaltungstor aufzubrechen\.$")) {
				ShowGameText("~r~Ausbruch~n~~w~Verwaltungstor", 9000, 1)
			
				iniRead, outbreak, Stats.ini, Stats, outbreak, 0
				outbreak ++
				iniWrite, % outbreak, Stats.ini, Stats, outbreak
				
				SendClientMessage(prefix . "Es wurde ein Ausbruch (" . cSecond . "#Fall " . outbreak . COLOR_WHITE . ") gemeldet!")

				outbreakInfo := []
				outbreakInfo["type"] := "gate"
				outbreakInfo["count"] := outbreak
				outbreakInfo["countdown"] := 30			
			
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Coup im Verwaltungsgebäude in Commerce, Los Santos gemeldet\.$")) {				
				ShowGameText("~r~Heist~n~~w~Verwaltungsgebaude", 9000, 1)
				
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
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Waffentransporter Überfall in (.+) gemeldet\.$", mdcChat1_)) {				
				ShowGameText("~r~Waffentransport-Ueberfall~n~~w~" . mdcChat1_1, 9000, 1)
				
				if (emergencySound) {
					SoundSetWaveVolume, 50
					SoundPlay, %A_ScriptDir%/sounds/bk.mp3
				}
			} else if (RegExMatch(mdcChat1, "^HQ: Es wurde ein Bank Überfall in (.+) gemeldet\.$", mdcChat1_)) {				
				ShowGameText("~r~Bankueberfall~n~~w~" . mdcChat1_1, 9000, 1)
				
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
		}
		
		ShowGameText("~r~Backup~n~~w~" . mdcChat_4 , 8000, 1)
	} else if (RegExMatch(message, "^Geschwindigkeit: (\d+) km\/h$", message_)) {		
		vehOwner := arr[index - 4]
		vehDriver := arr[index - 3]
		
		if (RegExMatch(vehOwner, "^Fahrzeughalter: (\S+)$", vehOwner_)) {
			if (vehOwner_1 == "LSPD" || vehOwner_1 == "SAPD" || vehOwner_1 == "Sanitäter" || vehOwner_1 == "Ordnungsamt" || vehOwner_1 == "FBI" || vehOwner_1 == "SAFD" || vehOwner_1 == "Kirche" || vehOwner_1 == "Army" || vehOwner_1 == "LVPD") {
				return
			}
		}
		
		if (RegExMatch(vehDriver, "^Fahrzeugführer: (\S+) \(ID: (\d+)\)$", driver_)) {
			kmh := maxKMH
			
			IniRead, Radarcontrols, stats.ini, Kontrollen, Radarcontrols, 0
			Radarcontrols ++
			IniWrite, %Radarcontrols%, stats.ini, Kontrollen, Radarcontrols
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Radarcontrols) . COLOR_WHITE . " Fahrzeuge geblitzt.")			
			
			if (kmh == 0) {
				kmh := 80
				
				SendClientMessage(prefix . "Trage zuerst eine erlaubte Höchstgeschwindigkeit ein:  " . csecond . "/setkmh")
			}
			
			if (AutoLaserMessage)
			{
				if (message_1 > kmh) {
					IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
					
					lastSpeed := message_1
					lastSpeedUser := driver_1
					
					Sleep, 500
					
					SendChat("/m << " . keybinderFrac . ", Radarkontrolle! " . driver_1 . ", halten Sie SOFORT an und fahren Sie rechts ran! >>")				
				}
			}
		}
	}
	/*
	} else if (RegExMatch(message, "^ Zeuge: (\S+)$")) {
		message3 := arr[index - 3]
		
		if (RegExMatch(message3, "^ Name: (\S+)$", message3_)) {
			if (!noAfind) {
				playerToFind := message3_1
				autoFindMode := 2
			
				findPlayer()
				findInfo(playerToFind)
				
				SendClientMessage("DBUG")
			}
		}
	} 
	*/
	else if (RegExMatch(message, "SMS: (.+), Sender: (\S+) \((\d+)\)", message_)) {
		if (message_2 != getUserName()) {		
	
			if (smsSound) {
				SoundSetWaveVolume, 50
				SoundPlay, %A_ScriptDir%/sounds/sms.mp3
			}
		}
	} else if (RegExMatch(message, "\.\.\.(.+), Sender: (\S+) \((\d+)\)", message_)) {
		if (message_2 != getUserName()) {	
			
			if (smsSound) {
				SoundSetWaveVolume, 50
				SoundPlay, %A_ScriptDir%/sounds/sms.mp3
			}
		}
	} else if (RegExMatch(message, "^Dein Handy klingelt\. Tippe \/pickup\. Anrufer-ID: (\S+)$", message_)) {
		
		if (callSound) {
			SoundSetWaveVolume, 50
			SoundPlay, %A_ScriptDir%/sounds/call.mp3
		}
	} else if (RegExMatch(message, "^Der Gesprächspartner hat aufgelegt\.$") 
		|| RegExMatch(message, "^Du hast aufgelegt\.$") 
		|| RegExMatch(message,"^Die Verbindung zu deinem Gesprächspartner wurde unterbrochen\.$")) {
		
		if (callSound) {
			SoundPlay, Nonexistent.avi
		}
	} else if (RegExMatch(message, "\* (\S+) geht an sein Handy\.$", message_)) {
		if (message_1 == getUserName()) {
			
			if (callSound) {
				SoundPlay, Nonexistent.avi
			}	
		}
	}
}

if (keybinderVersion == "overlay") 
{
	StatsOverlayTimer:
	{
		if (keybinderVersion == "nooverlay") {
			return
		}
		
		IniRead, accountmoney, stats.ini, Vermögen, Bank, 0
		IniRead, depositmoney, stats.ini, Vermögen, Festgeld, 0
		
		allMoney := accountMoney + depositMoney + getPlayerMoney()
		
		IniRead, wanteds, stats.ini, Vergaben, Wanteds, 0
		IniRead, points, stats.ini, Vergaben, Points, 0
		IniRead, pointclear, stats.ini, Vergaben, Pointsclear, 0
		IniRead, wantedclear, stats.ini, Vergaben, Wantedsclear, 0
		IniRead, ticketrequests, Stats.ini, Tickets, Ticketrequests, 0
		IniRead, tickets, Stats.ini, Tickets, Tickets, 0
		IniRead, ticketmoney, stats.ini, Tickets, Money, 0
		IniRead, arrests, stats.ini, Verhaftungen, Arrests, 0
		IniRead, deatharrests, stats.ini, Verhaftungen, Deatharrests, 0
		IniRead, offlinearrests, stats.ini, Verhaftungen, Offlinearrests, 0
		IniRead, deathprison, stats.ini, Verhaftungen, Deathprison, 0
		IniRead, offlineprison, stats.ini, Verhaftungen, Offlineprison, 0
		IniRead, crimekills, stats.ini, Verhaftungen, Crimekills, 0
		IniRead, arrestmoney, stats.ini, Verhaftungen, Money, 0
		IniRead, controls, stats.ini, Kontrollen, Controls, 0
		IniRead, trunkcontrols, stats.ini, Kontrollen, Trunkcontrols, 0
		IniRead, radar, stats.ini, Kontrollen, Radarcontrols, 0
		IniRead, takedmats, stats.ini, Kontrollen, Mats, 0
		IniRead, takedpaks, stats.ini, Kontrollen, Matpackets, 0
		IniRead, takedbomb, stats.ini, Kontrollen, Matbombs, 0
		IniRead, takeddrugs, stats.ini, Kontrollen, Drugs, 0
		IniRead, takedseeds, stats.ini, Kontrollen, Seeds, 0
		IniRead, plants, stats.ini, Marihuana, Plants, 0
		IniRead, plants_money, stats.ini, Marihuana, Money, 0
		IniRead, locals, stats.ini, Übernahmen, Restaurants, 0
		IniRead, stores, stats.ini, Übernahmen, Storerobs, 0
		IniRead, services, stats.ini, Übernahmen, Services, 0
		IniRead, tazer, stats.ini, Allgemein, Tazer, 0
		IniRead, fishmoney, stats.ini, Allgemein, Fishmoney, 0
		IniRead, roadblocks, stats.ini, Allgemein, Roadblocks, 0
		IniRead, equipmats, stats.ini, Allgemein, Equipmats, 0

		totalMoney := arrestMoney + ticketMoney + fishMoney
		
		IniRead, fishTime, settings.ini, UnixTime, fishTime, 0
		IniRead, fishUnix, settings.ini, UnixTime, fishUnix, 0
		
		motorStatus := ""
		lockStatus := ""
		lightStatus := ""
		checkpointDistance := "-"
		
		if (isPlayerInAnyVehicle()) {
			if (getVehicleEngineState()) {
				motorStatus := statsOverlayPositiveColor . "Motor an{FFFFFF}"
			} else {
				motorStatus := statsOverlayNegativeColor . "Motor aus{FFFFFF}"
			}
		}
		
		if (isPlayerInAnyVehicle()) {
			if (getVehicleLockState()) {
				lockStatus := statsOverlayNegativeColor . "Fahrzeug abgeschlossen{FFFFFF}"
			} else {
				lockStatus := statsOverlayPositiveColor . "Fahrzeug aufgeschlossen{FFFFFF}"
			}
		}
		
		if (isPlayerInAnyVehicle()) {
			if (getVehicleLightState()) {
				lightStatus := statsOverlayPositiveColor . "Licht angeschalten{FFFFFF}"
			} else {
				lightStatus := statsOverlayNegativeColor . "Licht abgeschalten{FFFFFF}"
			}
		}
		
		if (bk == true) {
			backupStatus := statsOverlayNegativeColor . "Bk ist angeschaltet{FFFFFF}"
		} else {
			backupStatus := statsOverlayPositiveColor . "Bk ist ausgeschaltet{FFFFFF}"
		}
		
		if (IsMarkerCreated()) {
			coordsFromRedmarker := CoordsFromRedmarker()
			playerCoords := getCoordinates()
			distance := getDistanceToPoint(coordsFromRedmarker[1], coordsFromRedmarker[2], coordsFromRedmarker[3], playerCoords[1], playerCoords[2], playerCoords[3])
			
			checkpointDistance := FormatNumber(Floor(distance)) . "m"
		}
		
		ovFind := getFullName(playerToFind)
		
		ovPartners := ""
		
		for index, entry in partners {
			ovPartners .= "`n" . statsOverlayprimcolor . index . COLOR_WHITE . ": " . entry
		}
		
		statsOverlayText := statsOverlayContent
		
		statsOverlayText := StrReplace(statsOverlayText, "[name]", getUsername())
		statsOverlayText := StrReplace(statsOverlayText, "[id]", getId())
		statsOverlayText := StrReplace(statsOverlayText, "[ping]", getPlayerPingById(getId()))
		statsOverlayText := StrReplace(statsOverlayText, "[fps]", getPlayerFPS())
		statsOverlayText := StrReplace(statsOverlayText, "[zone]", getPlayerZone())
		statsOverlayText := StrReplace(statsOverlayText, "[city]", getPlayerCity())
		statsOverlayText := StrReplace(statsOverlayText, "[hp]", getPlayerHealth())
		statsOverlayText := StrReplace(statsOverlayText, "[armour]", getPlayerArmor())
		statsOverlayText := StrReplace(statsOverlayText, "[money]", FormatNumber(getPlayerMoney()))
		statsOverlayText := StrReplace(statsOverlayText, "[bankmoney]", FormatNumber(accountMoney))
		statsOverlayText := StrReplace(statsOverlayText, "[allmoney]", FormatNumber(allMoney))
		statsOverlayText := StrReplace(statsOverlayText, "[skin]", getPlayerSkinId())
		statsOverlayText := StrReplace(statsOverlayText, "[weaponid]", getPlayerWeaponId())
		statsOverlayText := StrReplace(statsOverlayText, "[weapon]", getPlayerWeaponName())
		statsOverlayText := StrReplace(statsOverlayText, "[freezed]", (IsPlayerFreezed() ? "ja" : "nein"))
		statsOverlayText := StrReplace(statsOverlayText, "[vhealth]", getVehicleHealth())
		statsOverlayText := StrReplace(statsOverlayText, "[vmodelid]", getVehicleModelId())
		statsOverlayText := StrReplace(statsOverlayText, "[vmodel]", getVehicleModelName())
		statsOverlayText := StrReplace(statsOverlayText, "[vspeed]", round(getVehicleSpeed()))
		statsOverlayText := StrReplace(statsOverlayText, "[fishtime]", formatTime(fishcooldown))
		statsOverlayText := StrReplace(statsOverlayText, "[healTime]", healcooldown)
		statsOverlayText := StrReplace(statsOverlayText, "[date]", A_DD . "." . A_MM . "." . A_Year)
		statsOverlayText := StrReplace(statsOverlayText, "[motor]", motorStatus)
		statsOverlayText := StrReplace(statsOverlayText, "[lock]", lockStatus)
		statsOverlayText := StrReplace(statsOverlayText, "[light]", lightStatus)
		statsOverlayText := StrReplace(statsOverlayText, "[checkpoint]", checkpointDistance)
		statsOverlayText := StrReplace(statsOverlayText, "[pdmoney]", FormatNumber(paydayMoney))
		statsOverlayText := StrReplace(statsOverlayText, "[pdmoneynetto]", FormatNumber(Round(paydayMoney * taxes)))
		statsOverlayText := StrReplace(statsOverlayText, "[find]", (autoFindMode > 0 ? (ovFind == "" ? "-" : ovFind) : "-"))
		statsOverlayText := StrReplace(statsOverlayText, "[partners]", (ovPartners == "" ? "-" : ovPartners))
		statsOverlayText := StrReplace(statsOverlayText, "[backup]", backupStatus)
		
		statsOverlayText := StrReplace(statsOverlayText, "[wanteds]", FormatNumber(wanteds))
		statsOverlayText := StrReplace(statsOverlayText, "[points]", FormatNumber(points))
		statsOverlayText := StrReplace(statsOverlayText, "[pointclear]", FormatNumber(pointclear))
		statsOverlayText := StrReplace(statsOverlayText, "[wantedclear]", FormatNumber(wantedclear))
		
		statsOverlayText := StrReplace(statsOverlayText, "[ticketrequests]", FormatNumber(ticketrequests))
		statsOverlayText := StrReplace(statsOverlayText, "[tickets]", FormatNumber(tickets))
		statsOverlayText := StrReplace(statsOverlayText, "[ticketmoney]", FormatNumber(ticketmoney))
		
		statsOverlayText := StrReplace(statsOverlayText, "[arrests]", FormatNumber(arrests))
		statsOverlayText := StrReplace(statsOverlayText, "[deatharrests]", FormatNumber(deatharrests))
		statsOverlayText := StrReplace(statsOverlayText, "[offlinearrests]", FormatNumber(offlinearrests))
		statsOverlayText := StrReplace(statsOverlayText, "[deathprison]", FormatNumber(deathprison))
		statsOverlayText := StrReplace(statsOverlayText, "[offlineprison]", FormatNumber(offlineprison))
		statsOverlayText := StrReplace(statsOverlayText, "[crimekills]", FormatNumber(crimekills))
		statsOverlayText := StrReplace(statsOverlayText, "[arrestmoney]", FormatNumber(arrestmoney))
		
		statsOverlayText := StrReplace(statsOverlayText, "[controls]", FormatNumber(controls))
		statsOverlayText := StrReplace(statsOverlayText, "[trunkcontrols]", FormatNumber(trunkcontrols))
		statsOverlayText := StrReplace(statsOverlayText, "[radar]", FormatNumber(radar))
		statsOverlayText := StrReplace(statsOverlayText, "[takedmats]", FormatNumber(takedmats))
		statsOverlayText := StrReplace(statsOverlayText, "[takedpaks]", FormatNumber(takedpaks))
		statsOverlayText := StrReplace(statsOverlayText, "[takedbomb]", FormatNumber(takedbomb))
		statsOverlayText := StrReplace(statsOverlayText, "[takeddrugs]", FormatNumber(takeddrugs))
		statsOverlayText := StrReplace(statsOverlayText, "[takedseeds]", FormatNumber(takedseeds))
		
		statsOverlayText := StrReplace(statsOverlayText, "[plants]", FormatNumber(plants))
		statsOverlayText := StrReplace(statsOverlayText, "[plantsmoney]", FormatNumber(plants_money))

		statsOverlayText := StrReplace(statsOverlayText, "[locals]", FormatNumber(locals))
		statsOverlayText := StrReplace(statsOverlayText, "[stores]", FormatNumber(stores))
		statsOverlayText := StrReplace(statsOverlayText, "[services]", FormatNumber(services))
		
		statsOverlayText := StrReplace(statsOverlayText, "[tazer]", FormatNumber(tazer))
		statsOverlayText := StrReplace(statsOverlayText, "[fishmoney]", FormatNumber(fishMoney))
		statsOverlayText := StrReplace(statsOverlayText, "[roadblocks]", FormatNumber(roadblocks))
		statsOverlayText := StrReplace(statsOverlayText, "[equipmats]", FormatNumbeR(equipmats))
		statsOverlayText := StrReplace(statsOverlayText, "[totalmoney]", FormatNumber(totalMoney))
		
		statsOverlayText := StrReplace(statsOverlayText, "[primcol]", statsOverlayprimcolor)
		statsOverlayText := StrReplace(statsOverlayText, "[csecond]", statsOverlaycsecondor)
		statsOverlayText := StrReplace(statsOverlayText, "[white]", . COLOR_WHITE)
		
		if (!statsOverlayColors) {
			statsOverlayText := RegExReplace(statsOverlayText, "{\S{6}}", "")
		}
		
		TextSetString(statsOverlay, statsOverlayText)
	}
	return

	:?:/ov::
	:?:/overlay::
	{
		if (keybinderVersion == "nooverlay") {
			SendClientMessage(prefix . "Du benutzt die Overlay lose Version")
			return
		}	

		if (allOverlayEnabled) {
			SendClientMessage(prefix . "Du hast das gesamte Overlay aktiviert (/ovall), verwende dies erst einmal.")
			return
		}
		
		SendClientMessage(prefix . csecond . "1{FFFFFF}: Statistik-Overlay")
		
		overlayInput := PlayerInput("Overlay de-/aktivieren: ")
		
		if (overlayInput == "1") {
			if (statsOverlayEnabled) {
				TextDestroy(statsOverlay)
				
				statsOverlayEnabled := false
				
				if (ovMoveMode == 1) {
					ovMoveMode := 0
				}
				
				SetTimer, StatsOverlayTimer, Off
				
				SendClientMessage(prefix . "Statistik-Overlay {CC0000}deaktiviert{FFFFFF}.")
			} else {
				createOverlay(1)
				
				statsOverlayEnabled := true
				
				SendClientMessage(prefix . "Statistik-Overlay {00962B}aktiviert{FFFFFF}.")
			}
		}
	}
	return
	
	:?:/ovall::
	{
		if (keybinderVersion == "nooverlay") {
			SendClientMessage(prefix . "Du benutzt die Overlay lose Version")
			return
		}	
		
		if (!allOverlaysEnabled) {
			allOverlaysEnabled := true
			
			if (!statsOverlayEnabled) {
				createOverlay(1)
				
				statsOverlayEnabled := true
			}
			
			SendClientMessage(prefix . "Du hast das Overlay {00962B}aktiviert{FFFFFF}.")
		} else {
			allOverlaysEnabled := false
		
			if (statsOverlayEnabled) {
				TextDestroy(statsOverlay)
				
				statsOverlayEnabled := false
				
				if (ovMoveMode == 1) {
					ovMoveMode := 0
				}
				
				SetTimer, StatsOverlayTimer, Off
			} 
			
			SendClientMessage(prefix . "Du hast das Overlay {CC0000}deaktiviert{FFFFFF}.")
		}
	}
	return

	createOverlay(id) {
		global
		
		if (id == 1) {
			statsOverlay := TextCreate(statsOverlayFont, statsOverlayFontSize, statsOverlayBold, statsOverlayItalic, statsOverlayPosX, statsOverlayPosY, 0xFFFFFFFF, "", true, true)
			
			SetTimer, StatsOverlayTimer, 1000
		}
	}

	updateOverlay(id) {
		global
		
		if (id == 1) {
			if (statsOverlayEnabled) {
				TextSetPos(statsOverlay, statsOverlayPosX, statsOverlayPosY)
			}
		}
	}

	:?:/ovmove::
	{
		if (keybinderVersion == "nooverlay") {
			SendClientMessage(prefix . "Du benutzt die Overlay lose Version")
			return
		}		
		
		if (ovMoveMode) {
			ovMoveMode := 0
			
			SendClientMessage(prefix . "Der Overlay-Bearbeitungsmodus wurde {CC0000}deaktiviert{FFFFFF}.")
		} else {
			SendClientMessage(prefix . csecond . "1{FFFFFF}: Statistik-Overlay")
			
			overlayInput := PlayerInput("Overlay verschieben: ")
			
			if (overlayInput == "1") {
				if (statsOverlayEnabled) {
					ovMoveMode := 1
					
					SendClientMessage(prefix . "Der Overlay-Bearbeitungsmodus wurde {00962B}aktiviert{FFFFFF}.")
					SendClientMessage(prefix . "Das Overlay kann nun mit den Pfeiltasten verschoben werden.")
					SendClientMessage(prefix . "Wenn du fertig bist, tippe " . csecond . "/ovsave {FFFFFF}ein, um die Einstellung zu speichern.")
				} else {
					SendClientMessage(prefix . "Das Statistik-Overlay muss aktiviert sein, um es zu verschieben.")
				}
			}
		}
	}
	return

	:?:/ovsave::
	{
		if (keybinderVersion == "nooverlay") {
			SendClientMessage(prefix . "Du benutzt die Overlay lose Version")
			return
		}		
		
		if (ovMoveMode == 1) {
			IniWrite, %statsOverlayPosX%, settings.ini, StatsOverlay, PosX
			IniWrite, %statsOverlayPosY%, settings.ini, StatsOverlay, PosY
			
			ovMoveMode := 0
			
			SendClientMessage(prefix . "Die Overlay-Position wurde {00962B}gespeichert {FFFFFF}und der Bearbeitungsmodus {CC0000}deaktiviert{FFFFFF}.")
		} else {
			SendClientMessage(prefix . "Der Overlay-Bearbeitungsmodus ist nicht aktiviert!")
		}
	}
	return
}

~Up::
{
	if (keybinderVersion == "overlay") {
		if (ovMoveMode) {
			if (ovMoveMode == 1) {
				statsOverlayPosY -= 3
			}
			
			updateOverlay(ovMoveMode)
		}
	}
}
return

~Down::
{
	if (keybinderVersion == "overlay") {
		if (ovMoveMode) {
			if (ovMoveMode == 1) {
				statsOverlayPosY += 3
			}
			
			updateOverlay(ovMoveMode)
		}
	}
}
return

~Left::
{
	if (keybinderVersion == "overlay") {
		if (ovMoveMode) {
			if (ovMoveMode == 1) {
				statsOverlayPosX -= 3
			}
			
			updateOverlay(ovMoveMode)
		}
	}
}
return

~Right::
{
	if (keybinderVersion == "overlay") {
		if (ovMoveMode) {
			if (ovMoveMode == 1) {
				statsOverlayPosX += 3
			}
			
			updateOverlay(ovMoveMode)
		}
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
				SendClientMessage(prefix . "Du benötigst mindestens 2.500$.")
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
	IniRead, autoUse, settings.ini, settings, autoUse, 1
	
	if (isBlocked() || isPlayerInAnyVehicle() || !autoUse || isPaintball) {
		return
	}
	
	IniRead, firstaid, settings.ini, Items, firstaid, 0
	IniRead, drugs, settings.ini, Items, drugs, 0
	IniRead, pakcooldown, settings.ini, Cooldown, pakcooldown, 0
		
	if (getPlayerHealth() <= 75) {		
		if (firstaid && !pakcooldown) {
			SendChat("/erstehilfe")
		}
		/*
		if (drugs > 0) {
			if (!drugsCooldown) {
				SendChat("/usedrugs")
			}
		}
		*/
	}		
		
	Loop, 5 {
		LBS := fishLBS_%A_Index%
		check := getPlayerHealth()
		check += Round(LBS / 3)
    
		if (check <= 90 && LBS != 0) {
			SendChat("/eat " . A_Index)
			
			fishLBS_%A_Index% := 0
			return
		}
	}
}
return

~LButton::
{
	Sleep, 200
	
	if (isDialogOpen()) {
		dialogCaption := getDialogCaption()
		
		if (RegExMatch(dialogCaption, "Kofferraum von Fahrzeug (\d+) \((.+)\)")) {
			line := getDialogLine(getDialogIndex())
			
			if (RegExMatch(line, "(\S+): (\d+)", line_)) {
				if (line_2 > 0) {
					type := line_1
					unit := "Munition"
					
					if (type == "Drogen") {
						type := "drugs"
						unit := "g"
					} else if (type == "Materialien") {
						type := "mats"
						unit := ""
					}
					
					SendClientMessage(prefix . "Möchtest du " . csecond line_2 . unit . " " . line_1 . " {FFFFFF}konfiszieren? Drücke '" . csecond . "X" . COLOR_WHITE . "' zum Bestätigen.")
					
					KeyWait, X, D, T10
					
					if (!Errorlevel) {
						SendChat("/trunk clear " . type)
					}
				}
			}
		}
	}
}
return

~^R::
{
	if (isInChat() || IsDialogOpen() || IsPlayerInMenu()) {
		return
	}
}
:?:/relog::
{
	stopFinding()
	
	global tempo 				:= 80
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
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
	
	global oldscreen			:= -1
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
	global tvName 				:= ""

	global fillTimeout_ 		:= true
	global canisterTimeout_ 	:= true
	global mautTimeout_ 		:= true
	global healTimeout_ 		:= true
	global cookTimeout_ 		:= true
	global equipTimeout_ 		:= true
	global jailgateTimeout_ 	:= true 
	global GateTimeout_ 		:= true
	global fishTimeout_ 		:= true
	global localTimeout_		:= true

	global timeout				:= true
	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
	
	global oldVehicleName		:= "none"
	
	SendChat("/me verbindet sich neu zum Server.")

	restart()
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
				
				SendClientMessage(prefix . "Du hast den Tempomat " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
			} else {
				if (!tempomat) {
					tempomat := true
					
					SetTimer, TempoTimer, 100
					
					SendClientMessage(prefix . "Du hast den Tempomat " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . " (Tempo: " . csecond . tempo . " km/h" . COLOR_WHITE . ").")
				}
			}
		} else {
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du befindest dich in keinem Fahrzeug.")
	}
}
return

closeCustomsControlLabel:
{
	if (isBlocked()) {
		return
	}
		
	if (checkRank()) {
		if (getRank() > 4) {
			SendInput, t/zollcontrol  zu{left 3}
		} else if (getRank() < 5) {
			zoll := PlayerInput("Zoll Nummer: ")
			if (zoll == "" || zoll == " ") {
				return
			}
				
			SendChat("/d HQ: Bitte Zollstation " . zoll . " schließen!")
		}
	}	
}
return

openCustomsControlLabel:
{
	if (isBlocked()) {
		return
	}
		
	if (checkRank()) {
		if (getRank() > 3) {
			SendInput, t/zollcontrol  auf{left 4}
		} else if (getRank() < 4) {
			zoll := PlayerInput("Zoll Nummer: ")
			if (zoll == "" || zoll == " ") {
				return
			}
			
			SendChat("/d HQ: Bitte Zollstation " . zoll . " öffnen!")
		}
	}
}
return

govClosedCustomsLabel:
{
	if (isBlocked()) {
		return
	}
	
	if (checkRank()) {
		if (getRank() > 6) {
			SendInput, t/gov Die Zollstationen  sind zurzeit geschlossen.{left 26}
		}
	}
}
return

govOpenedCustomsLabel:
{
	if (isBlocked()) {
		return
	}
	
	if (checkRank()) {
		if (getRank() > 6) {
			SendInput, t/gov Die Zollstationen  sind nicht mehr geschlossen.{left 29}
		}
	}
}
return

openCustomsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (isPlayerOnMaut()) {
		openMaut()
	} else {
		SendClientMessage(prefix . "Du bist an keiner Zollstation.")
	}
}
return

openDoorLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	SendChat("/auf")
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
	
	if (!isFraction()) {
		return
	}

	if (watermode) {
		SendChat("/m << Küstenwache, bitte folgen Sie dem Boot >>")
	} else if (getPlayerSkinID() == 285) {
		SendChat("/m << S.W.A.T., bitte folgen Sie dem Einsatzfahrzeug >>")
	} else if (airmode) {
		SendChat("/m << C.A.S., bitte folgen Sie dem Helikopter! >>")
	} else {
		IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
		SendChat("/m << " . keybinderFrac . ", bitte folgen Sie dem Einsatzfahrzeug >>")
	}
}
return

megaControlLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!maumode) {
		if (!isFraction()) {
			return
		}
		
		if (watermode) {
			SendChat("/m << Küstenwache, Wasserverkehrskontrolle. Halten Sie bitte an >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., Allgemeine Kontrolle, bitte halten Sie SOFORT an! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., Luftverkehrskontrolle. Landen Sie umgehend! >>")
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			SendChat("/m << " . keybinderFrac . ", Allgemeine Kontrolle, bitte halten Sie an! >>")
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 1 wird gelegt:")
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
		if (!isFraction()) {
			return
		}

		if (watermode) {
			SendChat("/m << Küstenwache, stoppen Sie SOFORT Ihr Boot! >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., halten Sie SOFORT an! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., landen Sie SOFORT! >>")
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			SendChat("/m << " . keybinderFrac . ", bleiben Sie SOFORT stehen >>")
		}
		
		SendChat("/m << Letzte Mahnung, sollten Sie verweigern, wenden wir härte Maßnahmen an! >>")

		if (warningMessages) {
			if (isPlayerInAnyVehicle()) {
				SetTimer, ShotAllowedCar, 30000
			}
			
			if (!isPlayerInAnyVehicle()) {
				SetTimer, TazerAllowed, 5000
			}
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 2 wird gelegt:")
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
		if (!isFraction()) {
			return
		}

		playerToFindName := getFullName(playerToFind)
	
		if (playerToFindName == "" || playerToFind == "") {
			SendClientMessage(prefix . "Fehler: Du suchst aktuell niemanden.")
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			SendChat("/m << " . playerToFindName . ", bleiben Sie SOFORT stehen! >>")
			SendChat("/m << Letzte Mahnung, sollten Sie verweigern, wenden wir härte Maßnahmen an! >>")
		
			if (warningMessages) {
				if (isPlayerInAnyVehicle()) {
					SetTimer, ShotAllowedCar, 30000
				}
				
				if (!isPlayerInAnyVehicle()) {
					SetTimer, TazerAllowed, 5000
				}
			}
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 3 wird gelegt:")
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
		if (!isFraction()) {
			return
		}
		
		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			dept := keybinderFrac
		}
		
		SendChat("/m << " . dept . ", steigen Sie mit erhobenen Händen aus Ihrem Fahrzeug! >>")
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 4 wird gelegt:")
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
		if (!isFraction()) {
			return
		}
		
		if (watermode) {
			SendChat("/m << Küstenwache, fahren Sie umgehend zur Seite! >>")
		} else if (getPlayerSkinID() == 285) {
			SendChat("/m >> S.W.A.T., räumen Sie SOFORT die Straße! >>")
		} else if (airmode) {
			SendChat("/m << C.A.S., räumen Sie umgehend den Luftraum! >>")
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			SendChat("/m << " . keybinderFrac . ", räumen Sie umgehend die Straße! >>")
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 5 wird gelegt:")
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
		if (!isFraction()) {
			return
		}

		if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., SOFORT die Waffen niederlegen, ansonsten gebrauchen wir Gewalt! >>")
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			SendChat("/m << Hier spricht das " . keybinderFrac . ", SOFORT die Waffen niederlegen, ansonsten gebrauchen wir Gewalt! >>")
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 6 wird gelegt:")
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
		if (!isFraction()) {
			return
		}

		if (watermode) {
			dept := "Küstenwache"
		} else if (getPlayerSkinID() == 285) {
			dept := "S.W.A.T."
		} else if (airmode) {
			dept := "C.A.S."
		} else {
			IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
			dept := keybinderFrac
		}
		
		if (!getPlayerInteriorId()) {
			SendChat("/m << " . dept . ", verlassen Sie SOFORT dieses Gelände! >>")
		} else {
			SendChat("/m << " . dept . ", verlassen Sie SOFORT dieses Gebäude! >>")
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 9 wird gelegt:")
		SendChat("/mau 9")
	}
}
return

megaStopFollowLabel:
{
	if (isBlocked() || tv) {
		return
	}
		
	if (!isFraction()) {
		return
	}

	if (watermode) {
		dept := "Küstenwache"
	} else if (getPlayerSkinID() == 285) {
		dept := "S.W.A.T."
	} else if (airmode) {
		dept := "C.A.S."
	} else {
		IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
		dept := keybinderFrac
	}
	
	SendChat("/m << " . dept . ", unterlassen Sie SOFORT diese Verfolgung! >>")
}
return

megaRoadTrafficActLabel:
{
	if (isBlocked() || tv) {
		return
	}
		
	if (!isFraction()) {
		return
	}

	if (watermode) {
		dept := "Küstenwache"
	} else if (getPlayerSkinID() == 285) {
		dept := "S.W.A.T."
	} else if (airmode) {
		dept := "C.A.S."
	} else {
		IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
		dept := keybinderFrac
	}
		
	SendChat("/m << " . dept . ", bitte halten Sie sich an die Straßenverkehrsordnung >>")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . csecond . "1: {FFFFFF}Drogen/Samen | " . csecond . "2: {FFFFFF}Materialien/Pakete")
		
		wantedType := PlayerInput("Typ: ")
		
		if (wantedType == "1") {
			giveWanteds(name, "Besitz von Marihuana(samen)", 2)
		} else if (wantedType == "2") {
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . csecond . "1: {FFFFFF}Privatfahrzeug | " . csecond . "2: {FFFFFF}Dienstfahrzeug | " . csecond . "3: {FFFFFF}gep./bew. Dienstfahrzeug")
		
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		SendChat("/a " . name . " (ID: " getPlayerIdByName(name) . ") ESC Flucht / Buguse vor Cops!!!")
		
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
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
		return
	}
	
	SendChat("/a " . getFullName(playerToFind) . " (ID: " getPlayerIdByName(getFullName(playerToFind)) . ") ESC Flucht / Buguse vor Cops!!!")

	giveWanteds(playerToFind, "ESC-Flucht", 4)
}
return

:?:/sb::
{
	name := PlayerInput("Sachbeschädigung: ")
	name := getFullName(name)
	
	if (name != "") {
		giveWanteds(name, "Sachbeschädigung", 2)
	}
}
return

kidnapWantedsLabel:
{
	if (isBlocked()) {
		return
	}
}
:?:/entf::
{
	name := PlayerInput("Entführer: ")
	name := getFullName(name)
	
	if (name != "") {
		SendClientMessage(prefix . csecond . "1: {FFFFFF}Bürger | " . csecond . "2: {FFFFFF}Staatsbeamter")
		
		wantedType := PlayerInput("Typ: ")
		
		if (wantedType == "1") {
			giveWanteds(name, "Entführung", 2)
		} else if (wantedType == "2") {
			giveWanteds(name, "Entführung von Beamten", 4)
		}
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

:?:/rew::
:?:/rewtd::
:?:/rewanted::
{
	reInput := PlayerInput("Spieler / ID: ")
	if (reInput == "" || reInput == " ") {
		return
	}
	
	if (getFullName(reInput) == "") {
		SendClientMessage(prefix . "Fehler: Der Spieler ist nicht online.")
		return
	}
	
	if (getFullName(reInput) == getUserName()) {
		SendClientMessage(prefix . "Fehler: Du kannst dir selbst keine Wanteds eintragen.")
		return
	}
	
	reCount := PlayerInput("Anzahl: ")
	if (reCount == "" || reCount == " ") {
		return
	}
	
	if (reCount is not number) {
		SendClientMessage(prefix . "Fehler: Es wurde ein ungültiger Wert angegeben.")
		return
	}
	
	if (rewantedting) {
		SendClientMessage(prefix . "Die Vergabe läuft bereits. Du kannst es mit '" . cSecond . stopAutomaticSystemsNoMods . COLOR_WHITE . "' beenden.")
		return
	}
	
	givedRewanted := 0
	rewantedting := true
	
	Loop, %reCount% {
		if (rewantedting) {
			SendChat("/suspect " . getFullName(reInput) . " Re-Wanted")
		
			Sleep, 200
			
			if (InStr(readChatLine(0), "[WANTED] Verdächtiger: " . getFullName(reInput) . ", Zeuge: " . getUserName() . ", Verbrechen: Re-Wanted")) {
				givedRewanted ++
			}
		} else {
			break
		}
	}
		
	if (givedRewanted > 0) {
		IniRead, Wanteds, stats.ini, Vergaben, Wanteds, 0
		Wanteds += givedRewanted
		IniWrite, %wanteds%, stats.ini, Vergaben, Wanteds
		
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(wanteds) . " {FFFFFF}Wanteds vergeben.")	
	}
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
}
:?:/clearpoints::
:?:/tst::
{
	name := PlayerInput("Name/ID: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	amount := PlayerInput("Punkte: ")
	if (amount == "" || amount == " ") {
		return
	}
	
	if (amount is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine Zahl angeben.")
		return
	}
	
	SendChat("/licunban " . name . " points " . amount)
	
	Sleep, 200
	
	Loop, 5 {
		chat := readChatLine(A_Index - 1)
	
		if (InStr(chat, "Dieser Befehl ist ab Rang 9.")) {
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
}
:?:/heal::
{
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
		
		if (!admin || comhelper) {
			Sleep, 250
		}
		
		healPlayer()
	} else {
		SendChat("/heal")
		
		if (!admin || comhelper) {
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
		SendChat("/bk")
		
		bk := 1
	}
	
	SendChat("/d HQ: Ich benötige DRINGEND Verstärkung in " . getLocation() . "! (HP: " . getPlayerHealth() . ", AM: " . getPlayerArmor() . ")")
}
return

backupWhLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (!bk) {
		SendChat("/bk")
		bk := 1
	}
	
	SendChat("/d HQ: Ich benötige DRIGEND Verstärkung in " . getLocation() . ", verfolge Wheelman!")
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
		
		SendChat("/d HQ: Verstärkung wird NICHT mehr benötigt!")
	} else {
		SendClientMessage(prefix . "Du hast keine Verstärkung angefordert.")
	}
}
return

autoImprisonLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	toRemove := []
	
	for index, arrestName in arrestList {
		toRemove.Push(index)
		
		suspectID := getPlayerIdByName(getFullName(arrestName), true)
				
		if (suspectID != -1) {
			SendChat("/arrest " . arrestName)
		}
	}
	
	for i, id in toRemove {
		arrestList.RemoveAt(id)
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
		}
		
		if (getFullName(name) == "") {
			SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
			return
		}		
		
		SendChat("/arrest " . name)
			
		toRemove := []
		
		for index, arrestName in arrestList {
			if (arrestName == name) {
				toRemove.Push(index)
			}
		}
		
		for i, id in toRemove {
			arrestList.RemoveAt(id)
		}
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 8 wird gelegt:")
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
			SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
			return
		}

		SendChat("/waffen " . name)
		
		if (!admin || comhelper) {
			Sleep, 100
		}
		
		SendChat("/cuff " . name)
		
		if (autoFrisk) {
			if (!admin || comhelper) {
				Sleep, 400
			}
			
			checkResult := check(name)
			
			if (checkResult != -1 && autoWanted) {
				if (checkResult[1] || checkResult[2]) {
					if (!admin || comhelper) {
						Sleep, 700
					}
					
					giveWanteds(name, "Besitz von Marihuana(samen)", 2)
				}
				
				if (checkResult[3] || checkResult[4] || checkResult[5]) {
					if (!admin || comhelper) {
						Sleep, 700
					}
					
					giveWanteds(name, "Besitz von Materialien/Materialpaketen", 2)
				}
			}
		}
		
		arrestList.Push(name)
	} else {
		SendClientMessage(prefix . "Mau-Modus: Mau 7 wird gelegt:")
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
	if (name == "" || name == " ")
		return
	
	name := getFullName(name)
	if (name == "") {
		SendClientMessage(prefix . "Fehler: Der Spieler ist nicht online.")
		return
	}
	
	SendChat("/uncuff " . name)
	
	toRemove := []
	
	for index, arrestName in arrestList {
		if (arrestName == name) {
			toRemove.Push(index)
		}
	}
	
	for i, id in toRemove {
		arrestList.RemoveAt(id)
	}
}
return

arrestSlotsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	arrestCount := 0
	
	SendClientMessage(prefix . "Verbrecher in der Arrestliste:")
	
	for index, arrestName in arrestList {
		SendClientMessage(prefix . "ID: " . getPlayerIdByName(getFullName(arrestName), 1) . " - " . csecond . getFullName(arrestName))
		arrestCount ++
	}
	
	if (!arrestCount) {
		SendClientMessage(prefix . "Es sind aktuell keine Spieler in deiner Arrest-Liste.")
	} else {
		SendClientMessage(prefix . "Spieler in Arrest-Liste: " . csecond . arrestCount)
	}
}
return

resetArrestSlotsLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	arrestList := []
	
	SendClientMessage(prefix . "Arrestslots zurückgesetzt.")
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
		SendClientMessage(prefix . "Fehler: Der angegebene Spieler ist nicht online.")
		return
	}
	
	if (getFullName(frisk_name) == getUserName()) {
		SendClientMessage(prefix . "Fehler: Du kannst dich nicht selber durchsuchen.")
		return
	}

	checkResult := check(frisk_name)
	
	if (checkResult == -1) {
		return
	}
		
	if (!admin || comhelper) {
		Sleep, 1000
	}
		
	SendChat("/waffen " . frisk_name)
	
	addControlsToStats(getFullName(frisk_name))
	
	Sleep, 300

	if (autoWanted) {
		if (checkResult[1] || checkResult[2]) {
			if (!admin || comhelper) {
				Sleep, 1000
			}
			
			giveWanteds(frisk_name, "Besitz von Marihauan(samen)", 2)
		}
		
		if (checkResult[3] || checkResult[4] || checkResult[5]) {
			if (!admin || comhelper) {
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
	
	if (!admin || comhelper) {
		Sleep, 750
	}	
	
	SendChat("/l Dürfen wir Sie auf Gegenstände, Waffen und Alkohol kontrollieren?")

	if (!admin || comhelper) {
		Sleep, 750
	}


	SendChat("/l Falls Sie verweigern, erhalten Sie einen Wanted und werden festgenommen.")
	
	if (!admin || comhelper) {
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
		SendClientMessage(prefix . "Fehler: Du kannst im SWAT Modus nicht deine Scheine anfordern.")
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
}
:?:/to::
{
	if (!isPlayerInAnyVehicle()) {
		SendChat("/trunk open")
	} else {
		SendClientMessage(prefix . "Fehler: Du darfst dich in keinem Fahrzeug befinden.")
	}
}
return

checkTrunkLabel:
{
	if (isBlocked() || tv) {
		return
	}
}
:?:/tc::
{
	blockDialog()
	SendChat("/trunk check")
	Sleep, 200
	unblockDialog()
	
	chat0 := readChatLine(0)
	chat1 := readChatLine(1)
	
	if (InStr(chat0 . chat1, "Fehler:")) {
		if (InStr(chat0 . chat1, "Der Kofferraum ist nicht offen")) {
			SendChat("/trunk open")
			blockDialog()
			SendChat("/trunk check")
			Sleep, 200
			unblockDialog()
			
			chat0 := readChatLine(0)
			chat1 := readChatLine(1)
			
			if (InStr(chat0 . chat1, "Fehler:")) {
				return
			}
		} else {
			return
		}
	}
	
	if (RegExMatch(getDialogCaption(), "Kofferraum von Fahrzeug (\S+) \((.*)\)", result_)) {
		if (RegExMatch(getDialogText(), "Drogen: (\d+)\nMaterialien: (\d+)\nDeagle: (\d+)\nShotgun: (\d+)\nMP5: (\d+)\nAK47: (\d+)\nM4: (\d+)\nRifle: (\d+)\nSniper: (\d+)", dialog_)) {
			foundSomething := 0
			
			SendClientMessage(prefix . "Gegenstände aus dem Fahrzeug " . csecond . result_1 . " {FFFFFF}(" . csecond . result_2 . COLOR_WHITE . "):")
			
			if (dialog_1 > 0) {
				SendClientMessage(prefix . "Du hast {CC0000}" . dialog_1 . "g Drogen {FFFFFF}gefunden.")
				drugsfound := 1
				foundSomething := 1
			}
			
			if (dialog_2 > 0) {
				SendClientMessage(prefix . "Du hast {CC0000}" . dialog_2 . " Materialien {FFFFFF}gefunden.")
				matsfound := 1
				foundSomething := 1
			}
			
			if (dialog_3 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_3 . " Schuss Deagle {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_4 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_4 . " Schuss Shotgun {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_5 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_5 . " Schuss MP5 {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_6 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_6 . " Schuss AK-47 {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_7 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_7 . " Schuss M4 {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_8 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_8 . " Schuss Rifle {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (dialog_9 > 0) {
				SendClientMessage(prefix . "Du hast " . dialog_9 . " Schuss Sniper {FFFFFF}gefunden.")
				foundSomething := 1
			}
			
			if (!foundSomething) {
				SendClientMessage(prefix . "Du hast nichts gefunden.")
			} else if (dialog_1 > 0 || dialog_2 > 0) {
				SendChat("/trunk check")
			}
			
			IniRead, Trunkcontrols, stats.ini, Kontrollen, Trunkcontrols, 0
			Trunkcontrols ++
			IniWrite, %trunkcontrols%, stats.ini, Kontrollen, Trunkcontrols
			
			SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Trunkcontrols) . " {FFFFFF}Kofferäume durchsucht.")
			
			Sleep, 200
			
			if (matsfound && drugsfound) {
				SendClientMessage(prefix . "Es wurden Drogen & Materialien gefunden. Du kansnt Sie mit '" . cSecond . "X" . COLOR_WHITE . "' konfiszieren.")
				
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear mats")
					
					Sleep, 400
					
					SendChat("/trunk clear drugs")
				}
			} else if (matsfound && !drugsfound) {
				SendClientMessage(prefix . "Es wurden Materialien gefunden. Du kansnt Sie mit '" . cSecond . "X" . COLOR_WHITE . "' konfiszieren.")
			
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear mats")
				}
			} else if (!matsfound && drugsfound) {
				SendClientMessage(prefix . "Es wurden Drogen gefunden. Du kansnt Sie mit '" . cSecond . "X" . COLOR_WHITE . "' konfiszieren.")
			
				KeyWait, X, D, T10
				if (!ErrorLevel && !isInChat()) {
					SendChat("/trunk clear drugs")
				}
			}
			
			return
		}				
	}
		
	SendClientMessage(prefix . "Der Kofferraum konnte nicht durchsucht werden!")
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
		
		if (warningMessages) {
			if (isPlayerInAnyVehicle()) {
				SetTimer, ShotAllowedCar, 30000
			}
			
			if (!isPlayerInAnyVehicle()) {
				SetTimer, TazerAllowed, 5000
			}
		}
	}
}
return

arrestedByNameLabel:
{
	if (isBlocked() || tv) {
		return
	}

	if (!getFullName(playerToFind)) {
		SendClientMessage(prefix . "Fehler: Du hast keinen Spieler auf Find.")
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
		
		if (warningMessages) {
			if (isPlayerInAnyVehicle()) {
				SetTimer, ShotAllowedCar, 30000
			}
			
			if (!isPlayerInAnyVehicle()) {
				SetTimer, TazerAllowed, 5000
			}
		}
	}
}
return

ramLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (isPlayerInAnyVehicle()) {
		SendClientMessage(prefix . "Fehler: Du darfst dich in keinem Fahrzeug befinden.")
		return
	}
	
	if (getPlayerInteriorId()) {
		SendClientMessage(prefix . "Fehler: Du befindest dich in einem Gebäude.")
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
								SendClientMessage("DEBUG: Versuche " . grabName . " auf Sitz 1 zu ziehen.")
								return
							}
							
							if (seatID[3] == -1) {
								SendChat("/grab " . grabName . " 2")
								SendClientMessage("DEBUG: Versuche " . grabName . " auf Sitz 2 zu ziehen.")
								return
							}
							
							if (seatID[3] == -1) {
								SendChat("/grab " . grabName . " 3")
								SendClientMessage("DEBUG: Versuche " . grabName . " auf Sitz 3 zu ziehen.")
								return
							}
							
							SendClientMessage(prefix . "Es ist kein Platz im Fahrzeug frei.")
						} else if (getVehicleType() == 4) {
							if (seatID[2] == -1) {
								SendChat("/grab " . grabName . " 1")
								SendClientMessage("DEBUG: Versuche " . grabName . " auf Sitz 1 zu ziehen.")
								return
							}
							
							SendClientMessage(prefix . "Es ist kein Platz auf dem Motorrad frei.")
						}
					}
					
					SendClientMessage(prefix . "Es sind keine gecufften Spieler in deiner Nähe.")
					return
				}
			}
		} else {
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")	
	}
}
return

ungrabLabel:
{
	if (isBlocked() || tv) {
		return
	}
	
	if (IsPlayerInAnyVehicle()) {
		if (IsPlayerDriver()) {
			SendInput, t/ungrab{space}
		} else {
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist nicht in einem Fahrzeug.")
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
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")
	}
}
return

~F::
{
	if (isBlocked() || tv) {
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
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")
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
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer eines Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")
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
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")
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
			SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer des Fahrzeuges.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Du bist in keinem Fahrzeug.")
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
		SendClientMessage(prefix . "Es laufen keine Systeme.")
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
		if (keybinderFrac == "FBI") {	
			SendChat("/d HQ: Agent " . getUserName() . " übernimmt den Auftrag!")
		} else if (keybinderFrac == "LSPD") {
			SendChat("/d HQ: Officer " . getUserName() . " übernimmt den Auftrag!")
		} else if (keybinderFrac == "Army") {
			SendChat("/d HQ: Soldat " . getUserName() . " übernimmt den Auftrag!")
		}
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
		if (keybinderFrac == "FBI") {	
			SendChat("/d HQ: Agent " . getUserName() . " hat den Auftrag ausgeführt!")
		} else if (keybinderFrac == "LSPD") {
			SendChat("/d HQ: Officer " . getUserName() . " hat den Auftrag ausgeführt!")
		} else if (keybinderFrac == "Army") {
			SendChat("/d HQ: Soldat " . getUserName() . " hat den Auftrag ausgeführt!")
		}
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
		SendChat("/s Bitte stecken Sie umgehend Ihre Waffen ein.")
	} else if (tmp == 2) {
		SendChat("/s Stecken Sie SOFORT Ihre Waffen ein.")
	} else if (tmp == 3) {
		SendChat("/s Legen Sie SOFORT Ihre Waffe weg.")
	} else if (tmp == 4) {
		SendChat("/s Nehmen Sie sofort die Waffe runter.")
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

	if (RegExMatch(getLabelText(), "\[(\S+)\] (\S+)\nWantedlevel: (\S+)\nGrund: (.+)", label_)) {
		if (label_3 > 0) {
			if (label_3 > 4) {
				SendClientMessage(prefix . cSecond . label_2 . COLOR_WHITE . " hat mehr als 4 Wanteds.")
			} else {
				SendChat("/ticket " . label_1 . " " . (label_3 * 750) " Wanted-Ticket (" . label_3 . " Wanted" . (label_3 == 1 ? "" : "s") . ")")
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
		SendClientMessage(prefix . "Fehler: Der angegebene Spieler ist nicht online.")
		return
	}
	
	if (getFullName(playerForTicket) == getUserName()) {
		SendClientMessage(prefix . "Fehler: Der angegebene Spieler ist nicht online.")
		return
	}
		
	playerForTicket := getFullName(playerForTicket)
	
	wantedCount := PlayerInput("Wanteds: ")
	if (wantedCount == "" || wantedCount == " ") {
		return
	}
	
	if (wantedCount is not number) {
		SendClientMessage(prefix . "Fehler: Ungültiger Wert.")
		return
	}
	
	if (wantedCount > 4 || wantedCount < 1) {
		SendClientmessage(prefix . "Fehler: Die Wantedanzahl darf nicht höher als 4 und muss mind. 1 sein.")
		return
	}

	; SendChat("/l Guten " . getDayTime() . " " . playerForTicket . ",")
	; SendChat("/l Hiermit biete ich Ihnen einen Freikauf für " . (wantedCount == 1 ? wantedCount . " Wanted" :  wantedCount . " Wanteds") . " an.")
			
	; if (!admin || comhelper) {
		; Sleep, 1500
	; }
			
	; SendChat("/l Sollten Sie das Ticket (" . FormatNumber(wantedCount * 750) . "$) nicht zahlen können, werden wir Sie leider verhaften müssen.")
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
			SendClientMessage(prefix . "Fehler: Es wurde kein freier Notruf gefunden.")
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
					SendChat("/d HQ: übernehme Notruf-ID " . emergency2 . " von " . emergency1)
					
					IniRead, Services, stats.ini, Übernahmen, Services, 0
					Services ++
					IniWrite, %services%, stats.ini, Übernahmen, Services
					
					SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(services) . COLOR_WHITE . " Notrufe übernommen.")
					break
				}
			} else if (acceptedByPlayer == 1) {
				if (takeowerName == getUserName()) {
					SendClientMessage(prefix . "Fehler: Du hast diesen Notruf bereits übernommen.")
				} else {
					SendClientMEssage(prefix . "Fehler: Dieser Notruf wurde bereits von " . takeowerName . " übernommen.")
				}
				
				break
			} else if (acceptedByPlayer == 2) {
				SendClientMessage(prefix . "Fehler: Der Notruf ist hinfällig, da kein Streifenwagen mehr benötigt wird.")
				break
			}
		} else if (RegExMatch(chat, "HQ: Verbrechen: Überfall GK (\S+) \((\S+)\), Zeuge: Niemand, Verdächtiger: (\S+)", emergency)) {
			currentStore := emergency1
		
			gk(emergency1, emergency2, true)
		
			if (oldStore != currentStore) {
				SendChat("/d HQ: Übernehme Ladenüberfall- von " . emergency4 . "(" . getPlayerIdByName(emergency4) . ") - GK: " . emergency1 . " (" . emergency3 . ")")
				
				IniRead, storerobs, stats.ini, Übernahmen, storerobs, 0
				storerobs ++
				IniWrite, %storerobs%, stats.ini, Übernahmen, Storerobs
				
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(storerobs) . COLOR_WHITE . " Raubüberfälle übernommen.")
				
				oldStore := emergency1
			}
			
			SendClientMessage(prefix . "Möchtest du den Verbrecher suchen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' zum Bestätigen!")
			
			KeyWait, X, D, T10
			
			if (!ErrorLevel) {
				playerToFind := emergency1
				autoFindMode := 2
				
				findPlayer()
				findInfo(playerToFind)
			}
			
			break
		}
		
		i++
	}
}
return

acceptEmergencyLabel:
{
	if (isBlocked()) {
		return 
	}
	
	serviceName := PlayerInput("Notruf-ID: ")
	
	if (serviceName != "") {
		if (getFullName(serviceName) != "") {
			if (getFullName(serviceName) != getUserName()) {
				SendChat("/notruf " . serviceName)
				
				Sleep, 200
				
				if (!RegExMatch(readChatLine(0) . readChatLine(1), "^Der Spieler benötigt kein Streifenwagen\.$")) {
					SendChat("/d HQ: Übernehme Notruf-ID " . serviceName . " von " . getFullName(serviceName))
					
					IniRead, Services, Stats.ini, Übernahmen, Services, 0
					Services ++
					IniWrite, %services%, stats.ini, Übernahmen, Services
	
					SendClientMessage(prefix . "Du hast bereits " . cSecond . formatNumber(services) . COLOR_WHITE . " Notrufe übernommen.")
				}
			} else {
				SendClientMessage(prefix . "Fehler: Du kannst dich nicht selbst übernehmen.")
			}
		} else {
			SendClientMessage(prefix . "Fehler: Der angegebene Spieler ist nicht online.")
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
		SendClientMessage(prefix . "Du kannst die Stopuhr mit '" . cSecond . getUserFriendlyHotkeyName(stopwatchNoMods)  . COLOR_WHITE . "' beenden.")
	}
}
return

:?:

useDrugsLabel:
{
	if (isBlocked() || tv) {
		return 
	}
}
:?:/usedrugs::
{
	if (getPlayerArmor()) {
		SendClientMessage(prefix . "Fehler: Du kannst mit Armor keine Drogen nehmen.")
		return
	}
	
	if (94 < getPlayerHealth()) {
		SendClientMessage(prefix . "Fehler: Du kannst erst unter 94 HP Drogen nehmen, du hast " . getPlayerHealth() . " HP.")
		return
	}
	
	if (drugcooldown) {
		SendClientMessage(prefix . "Du kannst erst in " . cSecond . drugTime . COLOR_WHITE . " Sekunden wieder Drogen nutzen.")
		return
	}
	
	SendChat("/usedrugs")
}
return

eatFishLabel:
{
	if (isBlocked() || tv) {
		return 
	}
	
	if (getPlayerArmor()) {
		SendClientMessage(prefix . "Fehler: Du kannst mit Armor keine Fische essen.")
		return
	}
	
	if (94 < getPlayerHealth()) {
		SendClientMessage(prefix . "Fehler: Du kannst erst unter 94 HP Fische essen.")
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
	if (isBlocked()) {
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
}
:?:/erstehilfe::
{
	if (getPlayerArmor()) {
		SendClientMessage(prefix . "Fehler: Du kannst mit Armor kein Erste-Hilfe-Paket benutzen.")
		return
	}
	
	if (94 < getPlayerHealth()) {
		SendClientMessage(prefix . "Fehler: Du kannst erst unter 94 HP ein Erste-Hilfe-Paket benutzen.")
		return
	}
	
	SendChat("/erstehilfe")
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
		
		SendClientMessage(prefix . "Du kannst den Countdown mit '" . csecond . stopAutomaticSystemsNoMods . COLOR_WHITE . "' abbrechen.")
		
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
:?:/thx::
{
	if (tv)
		return
	
	Random, rand, 1, 3
	
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
{
	if (tv)
		return
	
	Random, rand, 1, 3
	
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
	
	IniRead, autoUse, settings.ini, settings, autoUse, 1
	
	if (A_IsSuspended) {
		SendClientMessage(prefix . "Du hast den Keybinder {CC0000}deaktiviert{FFFFFF}.")
		
		SetTimer, ChatTimer, off 
		SetTimer, MainTimer, off	
		SetTimer, TimeoutTimer, off
		SetTimer, SecondTimer, off
		SetTimer, WantedTimer, off
		SetTimer, LottoTimer, Off
		
		if (autoUncuff) {
			SetTimer, UncuffTimer, off
		}		
		
		if (chatlogSaver) {
			SetTimer, ChatlogSaveTimer, off
		}
		
		if (refillWarning) {
			SetTimer, TankTimer, Off
		}
		
		if (admin) {
			SetTimer, TicketTimer, Off
		}
		
		if (autoUse) {
			SetTimer, SyncTimer, off
		}
	} else {
		SendClientMessage(prefix . "Du hast den Keybinder {00AA31}aktiviert{FFFFFF}.")
	
		SetTimer, TempoTimer, 100
		SetTimer, ChatTimer, 200
		SetTimer, MainTimer, 200
		SetTimer, TimeoutTimer, 1000
		SetTimer, SecondTimer, 1000
		SetTimer, WantedTimer, 1000
		SetTimer, LottoTimer, 2000
		
		IniRead, bossmode, settings.ini, settings, bossmode, 1
		
		if (autoUncuff) {
			SetTimer, UncuffTimer, 500
		}
		
		if (chatlogSaver) {
			SetTimer, ChatlogSaveTimer, 1000
		}
		
		iF (refillWarning) {
			SetTimer, TankTimer, 1000
		}
		
		if (admin) {
			SetTimer, TicketTimer, 1000
		}
		
		if (autoUse) {
			SetTimer, SyncTimer, 600000
		}
	}
return

:?:/ts::
{
	SendChat("/d LSPD und FBI Teamspeak³ Server: lspd.lennartf.com")
}
return

:?:/fts::
{
	SendChat("/f LSPD und FBI Teamspeak³ Server: lspd.lennartf.com")
}
return

:?:/bwgov::
{
	SendClientMessage(prefix . "1: LSPD, 2: FBI, 3: Army")
	
	fracNumber := PlayerInput("Fraktion: ")
	if (fracNumber == "" || fracNumber == " " || fracNumber is not number) {
		return
	}
	
	if (fracNumber == "1") {
		fraction := "Los Santos Plice Department"
		preposition := "Das"
		title := "Beamten"
	} else if (fracNumber == "2") {
		fraction := "Federal Bureau of Investigation"
		preposition := "Das"
		title := "Agenten"
	} else if (fracNumber == "3") {
		fraction := "Las Venturas Army"
		preposition := "Die"
		title := "Soldaten"
	} else {
		SendClientMessage(prefix . "Fehler: Verwende eine Zahl für eine der folgenden Fraktionen:")
		SendClientMessage(prefix . "Fehler: 1: LSPD, 2: FBI, 3: Army")
		return
	}
	
	SendClientMessage(prefix . "1: Aktuell (bestimmte Anzahl gesucht)")
	SendClientMessage(prefix . "2: Dauerhaft (Bewerbung dauerhaft offen")
	
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
			if (!admin || comhelper) {
				Sleep, 750
			}
			SendChat("/gov " . preposition . " " . fraction . " ist aktuell auf der Suche nach '" . title . "' neuen " . title . ".")
			if (!admin || comhelper) {
				Sleep, 750
			} 
			SendChat("/gov Versuchen Sie Ihr Glück und werden Teil unseres Teams. Mehr Informationen im Forum!")
		} else {
			SendClientMessage(prefix . "Du musst mindestens ein Member suchen.")
		}
	} else if (typeOf == "2") {
		SendChat("/gov .:: " . fraction . " - Bewerbungsrunde ::.")
		if (!admin || comhelper) {
			Sleep, 750
		}
		SendChat("/gov " . preposition . " " . fraction . " hat aktuell Ihre Bewerbungsphase geöffnet.")
		if (!admin || comhelper) {
			Sleep, 750
		} 
		SendChat("/gov Werden Sie Teil unseres Teams und versuchen Sie Ihr Glück!")
	} else {
		SendClientMessage(prefix . "Fehler: Verwende eine Zahl für einer der folgenden Bewerbungsrunden:")
		SendClientMessage(prefix . "Fehler: 1: Aktuell (bestimmte Anzahl gesucht)")
		SendClientMessage(prefix . "Fehler: 2: Dauerhaft (Bewerbung dauerhaft offen")	
	}
}
return

:?:/fpsunlock::
{
    if (fpsUnlock()) {
        SendClientMessage(prefix . COLOR_GREEN . "Die Beschränkung deiner FPS wurde aufgehoben.")
    } else {
        SendClientMessage(prefix . COLOR_RED . "Beim Aufheben der Beschränkung deiner FPS ist ein Fehler aufgetreten.")
    }
}
return

:?:/bossmode::
{
	IniRead, autoUse, settings.ini, settings, autoUse, 1
	
	if (autoUse == 0) {
		autoUse := 1
		
		SendClientMessage(prefix . "Heal-Modus wurde " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
	} else {
		autoUse := 0
	
		SendClientMessage(prefix . "Heal-Modus wurde " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	}
	
	IniWrite, %autoUse%, settings.ini, settings, autoUse
}
return

:?:/zollhelp::
{
	SendClientMessage(prefix . ".:: Zoll-Informationen ::.")
	SendClientMessage(prefix . csecond . "/zollinfo [Zoll-ID]{FFFFFF} - Zollinformationen nach ID")
	
	closeHotkey := closeCustomsControlNoMods
	closeHotkey := StrReplace(closeHotkey, "!", "ALT+")
	closeHotkey := StrReplace(closeHotkey, "^", "STRG+")
	
	openHotkey := openCustomsControlNoMods
	openHotkey := StrReplace(openHotkey, "!", "ALT+")
	openHotkey := StrReplace(openHotkey, "^", "STRG+")
	
	SendClientMessage(prefix . csecond . closeHotkey . COLOR_WHITE . " - Zoll schließen (lassen)")
	SendClientMessage(prefix . csecond . openHotkey . COLOR_WHITE . " - Zoll öffnen (lassen)")
}
return

:?:/zollinfo::
{
	customsID := PlayerInput("Zoll-ID: ")
	
	if (customsID == "" || customsID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast die Eingabe abgebrochen.")
		return
	} else if (customsID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine Nummer eintragen.")
		return
	}

	if (customsID == "1") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Los Santos - Las Venturas")
		SendClientMessage(prefix . "Beschreibung: Zollstation von Red County nach Las Venturas (Nähe Hitman Base)")
	} else if (customsID == "2") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Red County - Bone County")
		SendClientMessage(prefix . "Beschreibung: Zollstation von Red County nach Bone County (Nähe Hunter Quarry)")
	} else if (customsID == "3") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Blueberry - Bone County")
		SendClientMessage(prefix . "Beschreibung: Zollstation auf der Martin Bridge von Blueberry nach Fort Carson")
	} else if (customsID == "4") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: San Fierro - Tierra Robada")
		SendClientMessage(prefix . "Beschreibung: Zollstation auf der Garver Bridge (Nähe FBI Base)")
	} else if (customsID == "5") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: San Fierro - Bayside")
		SendClientMessage(prefix . "Beschreibung: Zollstation bei der Gant Bride (von San Fierro nach Bayside)")
	} else if (customsID == "6") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Flint County - Red County")
		SendClientMessage(prefix . "Beschreibung: Zollstation von der ehem. GmbH-Base nach The Panopticon")
	} else if (customsID == "7") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Flint County - Red County")
		SendClientMessage(prefix . "Beschreibung: Zollstation von Flint County nach Red County (Richtung Blueberry)")
	} else if (customsID == "8") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Los Santos - Flint County")
		SendClientMessage(prefix . "Beschreibung: Zollstation von Flint County nach Los Santos (Waffendealer Tunnel)")
	} else if (customsID == "9") {
		SendClientMessage(prefix . "Zollinformation (" . csecond . "Zollstation " . customsID . COLOR_WHITE . "):")
		SendClientMessage(prefix . "Stadt: Los Santos - Flint County")
		SendClientMessage(prefix . "Beschreibung: Zollstation von Flint County nach Los Santos (Flint Intersection)")
	} else {
		SendCLientMessage(prefix . "Diese Zollstation existiert nicht (1-9).")
	}
}
return

:?:/kd::
{
	IniRead, Kills, Stats.ini, Stats, Kills, 0
	IniRead, Deaths, Stats.ini, Stats, Deaths, 0
	IniRead, DKills, Stats.ini, Stats, Dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, DDeaths, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%], 0

	SendClientMessage(Prefix . "Kills: " . cSecond . FormatNumber(Kills) . COLOR_WHITE . " Tode: " . cSecond . FormatNumber(Deaths) . COLOR_WHITE . " K/D-Rate: " . cSecond . Round(Kills / Deaths, 3))
	SendClientMessage(Prefix . "{FF8200}Tagesstatistik:" . COLOR_WHITE . " Kills: " . cSecond . FormatNumber(DKills) . COLOR_WHITE . " Tode: " . cSecond . FormatNumber(DDeaths) . COLOR_WHITE . " K/D-Rate: " . cSecond . Round(DKills / DDeaths, 3))
}
return

:?:/fkd::
{
	IniRead, Kills, Stats.ini, Stats, Kills, 0
	IniRead, Deaths, Stats.ini, Stats, Deaths, 0
	IniRead, DKills, Stats.ini, Stats, Dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, DDeaths, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%], 0

	SendChat("/f Kills: " . FormatNumber(Kills) . " Tode: " . FormatNumber(Deaths) . " K/D-Rate: " . Round(Kills / Deaths, 3))
	SendChat("/f Tagesstatistik: Kills: " . cSecond . FormatNumber(DKills)  . " Tode: " . FormatNumber(DDeaths) . " K/D-Rate: " . Round(DKills / DDeaths, 3))
}
return

:?:/dkd::
{
	IniRead, Kills, Stats.ini, Stats, Kills, 0
	IniRead, Deaths, Stats.ini, Stats, Deaths, 0
	IniRead, DKills, Stats.ini, Stats, Dkills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, DDeaths, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%], 0

	SendChat("/d HQ: Kills: " . FormatNumber(Kills) . " Tode: " . FormatNumber(Deaths) . " K/D-Rate: " . Round(Kills / Deaths, 3))
	SendChat("/d HQ: Tagesstatistik: Kills: " . cSecond . FormatNumber(DKills)  . " Tode: " . FormatNumber(DDeaths) . " K/D-Rate: " . Round(DKills / DDeaths, 3))
}
return

:?:/resetdkd::
{
	IniWrite, 0, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%]
	IniWrite, 0, Stats.ini, Stats, DKills[%A_DD%:%A_MM%:%A_YYYY%]
	SendClientMessage(Prefix . "Deine Tages-Kills und Tode wurden auf 0 gesetzt.")
}
return

:?:/setkd::
{
	updateKD()
}
return

:?:/items::
{
	IniRead, drugs, settings.ini, Items, drugs, 0
	if (drugs) {
		dColor := COLOR_GREEN
	} else {
		dColor := COLOR_RED 
	}
	IniRead, firstaid, settings.ini, Items, firstaid, 0
	if (firstaid) {
		fAvailable := COLOR_GREEN . "vorhanden"
	} else {
		fAvailable := COLOR_RED . "nicht vorhanden"
	}
	IniRead, campfire, settings.ini, Items, campfire, 0
	if (campfire) {
		cAvailable := COLOR_GREEN . campfire . " vorhanden"
	} else {
		cAvailable := COLOR_RED . "nicht vorhanden"
	}
	
	SendClientMessage(prefix . "|============| Inventar |============|")
	SendClientMessage(prefix . "Drogen dabei: " . dColor . drugs . "g")
	SendClientMessage(prefix . "Erste-Hilfe-Paket: " . fAvailable)
	SendClientMessage(prefix . "Lagerfeuer: " . cAvailable)
	SendClientMessage(prefix . "|============| Inventar |============|")
}
return

:?:/gk::
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

:?:/q::
{
	stopFinding()
	global tempo 				:= 80
	global currentTicket 		:= 1
	global maxTickets 			:= 1
	global currentFish 			:= 1
	
	global totalArrestMoney 	:= 0
	global currentTicketMoney 	:= 0
	global maumode				:= 0
	global watermode 			:= 0
	global airmode 				:= 0
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
	
	global oldscreen			:= -1
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
	global tvName 				:= ""

	global fillTimeout_ 		:= true
	global canisterTimeout_ 	:= true
	global mautTimeout_ 		:= true
	global healTimeout_ 		:= true
	global cookTimeout_ 		:= true
	global equipTimeout_ 		:= true
	global jailgateTimeout_ 	:= true 
	global GateTimeout_ 		:= true
	global fishTimeout_ 		:= true
	global localTimeout_		:= true
		
	global isPaintball			:= false
	global hackerFinder 		:= false
	global rewantedting			:= false
	global tempomat 			:= false
	global tv 					:= false
	
	global oldVehicleName		:= "none"
	
	SendInput, /q{enter} 
}
return

:?:/mr::
{
	SendChat("/mauready")
}
return

:?:/mn::
{
	SendChat("/maunext")
}
return

:?:/md::
{
	SendChat("/maudraw")
}
return

:?:/ml::
{
	SendChat("/mauleave")
}
return

:?:/am::
{
	SendChat("/accept maumau")
}
return

:?:/mhelp::
{
	caption := COLOR_WHITE . projectName . ": Mau Mau Hilfen"
	
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
		SendClientMessage(prefix . "Fehler: Die Wantedanzahl muss eine Nummer sein.")
		return
	}
	
	SendClientMessage(prefix . "10% von " . wantedInput . " Wanteds sind " . csecond . Round(wantedInput / 10) . COLOR_WHITE . " (" . csecond . (wantedInput / 10) . COLOR_WHITE . ") Wanteds.")
	SendClientMessage(prefix . "Damit würdest du ihm " . wantedInput * 3 . " Minuten Knastzeit ersparen.")
}
return

:?:/tempo::
{
	tempoInput := PlayerInput("Tempo: ")
	if (tempoInput == "" || tempoInput == " ") {
		return
	}
	
	if (tempoInput is not number) {
		SendClientMessage(prefix . "Fehler: Die Geschwindigkeit muss eine Zahl sein.")
		return
	}
	
	tempo := tempoInput
	
	SendClientMessage(prefix . "Du hast das Tempo auf " . csecond . tempo . " km/h " . COLOR_WHITE . "gesetzt. Starte den Tempomat mit '" . csecond . tempomatNoMods . COLOR_WHITE . "'")
}
return

:?:/pbexit::
{
	if (tv) {
		return
	}	
	
	cantExit := 0
	
	SendChat("/pbexit")
	
	Sleep, 200
	
	Loop, 5 {
		chat := readChatLine(A_Index - 1)
		
		if (InStr(chat, "Fehler: Nachdem du getroffen wurdest, musst du 5 Sekunde warten, um die Arena zu verlassen.")) {
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

:?:/rz::
:?:/razzia::
{	
	if (tv) {
		return
	}
	
	IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
	
	if (getPlayerSkinID() == 285) {
		SendChat("/m << S.W.A.T., dies ist eine Razzia! >>")
	} else {
		SendChat("/m << " . keybinderFrac . ", dies ist eine Razzia! >>")
	}
	
	SendChat("/m << Nehmen Sie SOFORT die Hände hoch oder wir schießen! >>")
}
return

:?:/weiter::
{
	if (!tv) {
		IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
		
		if (getPlayerSkinID() == 285) {
			SendChat("/m << S.W.A.T., alle Personen bitte SOFORT weiterfahren! >>")
		} else {
			SendChat("/m << " . keybinderFrac . ", alle Personen bitte SOFORT weiterfahren! >>")
		}
	}
}
return

:?:/cws::
{
	name := PlayerInput("Name/ID: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendclientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
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
		SendclientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
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
		SendclientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/licunban " . name . " driving")
}
return

:?:/nt::
{	
	if (tv) {
		return
	}	
	
	if (currentTicketMoney > 0) {
		giveTicket(lastTicketPlayer, currentTicketMoney, lastTicketReason)
	} else {
		SendClientMessage(prefix . "Fehler: Es ist kein Ticket mehr ausstellbar.")
	}
}
return

:?:/stvo::
{
	if (tv) {
		return
	}		
	
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
							
							SendClientMessage(prefix . csecond . "/apunkte{FFFFFF} - Punkte dafür ausstellen, " . csecond . "/aticket{FFFFFF} - Ticket dafür anbieten")
							
							autoName := fullName
							autoReason := pointReason
							autoTicket := pointAmount * 2000							
						} else {
							SendClientMessage(prefix . "Fehler: Du musst mindestens 1 Strafpunkt angeben.")
						}
					} else {
						SendClientMessage(prefix . "Fehler: Du darfst nicht mehr als 4 Strafpunkte eintragen.")
					}
				} else {
					SendClientMessage(prefix . "Fehler: Du musst eine gültige Punkteanzahl angeben.")
				}
			} else {
				SendClientMessage(prefix . "Fehler: Der Grund muss mind. 5 Zeichen lang sein.")
			}
		} else {
			SendClientMessage(prefix . "Fehler: Der angegebene Spieler wurde nicht gefunden.")
		}
	} else {
		SendClientMessage(prefix . "Fehler: Der Name muss mindestens 3 Zeichen haben.")
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
	
	kmh := maxKMH
	
	if (kmh == 0) {
		kmh := 80
		
		SendClientMessage(prefix . "Du musst die maximal erlaubte Höchstgeschwindigkeit noch eintragen, verwende " . csecond . "/setkmh{FFFFFF}.")
	}
	
	SendChat("/l Guten " . getDayTime() . " " . autoName . ", Sie haben gegen die StVO verstoßen.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Sie haben die erlaubte Höchstgeschwindigkeit (" . maxKMH . " km/h) mit " . autoSpeed . " km/h überschritten.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Möchten Sie ein Ticket in Höhe von $" . autoTicket . " oder " . autoPoints . " Strafpunkte?")
	
	Sleep, 100
	
	SendClientMessage(prefix . "Verwende " . csecond . "/aticket {FFFFFF}um ein Ticket oder " . csecond . "/apunkte{FFFFFF}, um die Punkte auszustellen.")
	
	lastSpeed := 0
	lastSpeedUser := ""
}
return

:?:/aticket::
{
	if (tv) {
		return
	}	
	
	if (autoName != "") {
		if (autoSpeed == 0) {
			giveTicket(autoName, autoTicket, autoReason)
		} else {
			giveTicket(autoName, autoTicket, autoReason . " (" . autoSpeed . " km/h)")
		}
		
		autoName := ""
		autoSpeed := 0
	} else {
		SendClientMessage(prefix . "Du musst erst einen Verstoß mit " . csecond . "/stvo {FFFFFF}eintragen.")
	}
}
return

:?:/apunkte::
{
	if (tv) {
		return
	}	
	
	if (autoName != "") {
		if (autoSpeed == 0) {
			givePoints(autoName, "Missachtung des Tempolimits", 1)
		} else {
			givePoints(autoName, "Missachtung des Tempolimits", 1, " (" . autoSpeed . " km/h)")
		}
		
		autoName := ""
		autoSpeed := 0
	} else {
		SendClientMessage(prefix . "Du musst erst einen Verstoß mit " . csecond . "/stvo {FFFFFF}eintragen.")
	}
}
return

:?:/top::
{	
	if (tv) {
		return
	}	
	
	SendChat("/l Möchten Sie nun ein Ticket oder Strafpunkte?")
}
return

:?:/tot::
{
	if (tv) {
		return
	}	
	
	SendChat("/l Möchten Sie nun einen Strafzettel oder einen Entzug der Lizenz?")
}
return

:?:/stvof::
{
	if (tv) {
		return
	}	
	
	name := PlayerInput("Spieler (Flugschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Straßenverkehrsverordnung verstoßen.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Flugschein i.H.v. $12.000 an.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Fluglizenzs entziehen.")
	
	Sleep, 100
	
	SendClientMessage(prefix . csecond . "/fst{FFFFFF} - Ticket anbieten, " . csecond . "/tfs{FFFFFF} - Schein taken")
}
return

:?:/stvow::
{
	if (tv) {
		return
	}

	name := PlayerInput("Spieler (Waffenschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Serverregelwerk verstoßen.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Waffenschein i.H.v. $36.000 an.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Waffenlizenz entziehen.")
	
	Sleep, 100
	
	SendClientMessage(prefix . csecond . "/wst{FFFFFF} - Ticket anbieten, " . csecond . "/tws{FFFFFF} - Schein taken")
}
return

:?:/stvob::
{
	if (tv) {
		return
	}
	
	name := PlayerInput("Spieler (Bootsschein): ")
	if (name == "" || name == " " || getFullName(name) == "") 
		return

	SendChat("/l Guten " . getDayTime() . " " . getFullName(name) . ", Sie haben gegen die Straßenverkehrsverordnung verstoßen.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}	
	
	SendChat("/l Aus diesem Grund biete ich Ihnen einen Strafzettel für Ihren Bootschein i.H.v. $6.000 an.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Sollten Sie diesen nicht begleichen können, müssen wir Ihre Bootlizenz entziehen.")
	
	Sleep, 100
	
	SendClientMessage(prefix . csecond . "/bst{FFFFFF} - Ticket anbieten, " . csecond . "/tbs{FFFFFF} - Schein taken")
}
return

:?:/fst::
{
	if (tv) {
		return
	}

	name := PlayerInput("Spieler (Flugschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 12000, "Flugschein-Ticket")
}
return

:?:/wst::
{	
	if (tv) {
		return
	}
	
	name := PlayerInput("Spieler (Waffenschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 36000, "Waffenschein-Ticket")
}
return

:?:/bst::
{	
	if (tv) {
		return
	}
	
	name := PlayerInput("Spieler (Bootschein): ")
	if (name == "" || name == " " || getFullName(name) == "") {
		return
	}
	
	giveTicket(name, 6000, "Bootsschein-Ticket")
}
return

:?:/tw::
{
	if (tv) {
		return
	}
	
	SendInput, /take Waffen{space}
}
return

:?:/tfs::
:?:/tfl::
{
	if (tv) {
		return
	}
	
	SendInput, /take Flugschein{space}
}
return

:?:/tws::
:?:/twl::
{
	if (tv) {
		return
	}
	
	SendInput, /take Waffenschein{space}
}
return

:?:/tbs::
{
	if (tv) {
		return
	}
	
	SendInput, /take Bootsschein{space}
}
return

:?:/td::
{
	if (tv) {
		return
	}	

	SendInput, /take Drogen{space}
}
return

:?:/tm::
{
	if (tv) {
		return
	}	
	
	SendInput, /take Materialien{space}
}
return

:?:/tall::
{
	if (tv) {
		return
	}	
	
	SendInput, /take Waffen{Space}
	Input SID, V I M, {Enter}
	SendInput, {Enter}t/take Materialien %SID%{Enter}t/take Drogen %SID%{Enter}
}
return

:?:/dsp::
{
	if (tv) {
		return
	}	
	
	SendChat("/destroyplant")
}
return

:?:/setkmh::
{	
	maxKMHinput := PlayerInput("Maximal erlaubte km/h: ")
	
	if (maxKMHinput is number) {
		maxKMH := maxKMHinput
		
		IniWrite, %maxKMH%, settings.ini, Einstellungen, MaxKMH
		
		SendClientMessage(prefix . "Du hast die maximal erlaubte Geschwindigkeit bei Radarkontrollen auf " . csecond . maxKMH . " km/h {FFFFFF}gesetzt.")
	} else {
		SendClientMessage(prefix . "Fehler: Gib bitte eine Zahl für die maximal erlaubte Geschwindigkeit bei Radarkontrollen ein.")
	}
}
return


:?:/pd::
:?:/payday::
{
	if (taxes == 1) {
		SendClientMessage(prefix . "Es wurde noch kein Steuersatz eingetragen, gib bitte " . csecond . "/settax" . COLOR_WHITE . "ein.")
	}
	
	SendClientMessage(prefix . "Geld am nächsten Payday: $" . csecond . formatNumber(paydayMoney) . COLOR_WHITE . " (Brutto) $" . csecond . formatNumber(Round(paydayMoney * taxes)) . COLOR_WHITE . " (Netto)")
}
return

:?:/hi::
{
	SendChat("/f Hi")
	SendChat("/d Hi")
	SendChat("/crew Hi")
}
return
	
:?:/resetpd::
:?:/resetpayday::
{
	SendClientMessage(prefix . "Geld am nächsten Payday: " . csecond . FormatNumber(paydayMoney) . COLOR_WHITE . "$ (Brutto) " . csecond . FormatNumber(Round(paydayMoney * taxes)) . COLOR_WHITE . "$ (Netto)")
	
	paydayMoney := 0
	
	SendClientMessage(prefix . "Du hast das Geld für den nächsten Payday auf 0$ zurückgesetzt!")
}
return

:?:/settax::
{
	taxClass := PlayerInput("Steuerklasse: ")
	if (taxClass == "" || taxClass == " ") {
		return
	}
	
	if (taxClass is not number) {
		SendClientMessage(prefix . "Gib bitte eine gültige Steuerklasse (1-4) ein.")
		return
	}
	
	if (taxClass < 1 || taxClass > 4) {
		SendClientMessage(prefix . "Gib bitte eine gültige Steuerklasse (1-4) ein!")
		return
	}
	
	SendChat("/tax")
	
	Sleep, 250
	
	chat := readChatLine(4 - taxClass)
	RegExMatch(chat, "Steuerklasse " . taxClass . ": (\d*) Prozent", chat_)
	taxes := (100 - chat_1) / 100
	
	IniWrite, %taxes%, settings.ini, Steuern, Steuersatz
	SendClientMessage(prefix . "Der Steuersatz (Steuerklasse " . cSecond . taxClass . COLOR_WHITE . ") wurde auf " . cSecond . chat_1 . COLOR_WHITE . " Prozent gesetzt.")	
}
return

:?:/fahrer::
{
	if (showDriver) {
		showDriver := false
		
		SendClientMessage(prefix . "Es wird nun nicht mehr automatisch dem Fahrer des Wagens gezeigt. (/asp)")
	} else {
		showDriver := true
		
		SendClientMessage(prefix . "Es wird nun immer automatisch dem Fahrer des Wagens gezeigt. (/asp)")
	}
}
return

:?:/partner::
{	
	partnerID := PlayerInput("Partner-Nr.: ")
	
	if (partnerID is number) {
		if (partnerID >= 1) {
			if (partners.HasKey(partnerID)) {
				partnerName := partners.Delete(partnerID)
				
				if (partnerMessages) {
					SendChat("/d HQ: Der Streifendienst mit (" . partnerID . ") " . partnerName . " wurde beendet!")
				} else {
					SendClientMessage(prefix . "Du hast " . csecond . partnerName . COLOR_WHITE . " (" . csecond . partnerID . COLOR_WHITE . ") ausgetragen.")
				}
			} else {
				partnerName := PlayerInput("Partner-ID/Name: ")
				partnerName := getFullName(partnerName)
				
				if (partnerName == "") {
					SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
					return
				}
				
				partners[partnerID] := partnerName
				
				if (partnerMessages) {
					SendChat("/d HQ: " . partnerName . " wurde als Streifenpartner " . partnerID . " eingetragen!")
				} else {
					SendClientMessage(prefix . "Du hast " . csecond . partnerName . COLOR_WHITE . " (" . csecond . partnerID . COLOR_WHITE . ") eingetragen.")
				}
				
				if (taxes == 1) {
					SendClientMessage(prefix . "Du musst noch deine Steuerklasse eintragen, verwende " . csecond . "/settax")
				}
			}
		}
	}
}
return

:?:/partners::
{
	partnerCount := 0
	
	SendClientMessage(prefix . "Aktuelle Dienstpartner:")
	
	for index, partner in partners {
		partnerPlayerID := getPlayerIdByName(partner, true)
		
		SendClientMessage(prefix . index . COLOR_WHITE . ": " . partner . " (ID: " . csecond . partnerPlayerID . COLOR_WHITE . ")")
		partnerCount++
	}
}
return

:?:/rpartners::
:?:/delpartners::
:?:/rempartners::
:?:/resetpartners::
{
	partners := []
	
	SendClientMessage(prefix . "Dienstpartner zurückgesetzt.")
}
return

:?:/oa::
{
	if (tv) {
		return
	}
	
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
		SendClientMessage(prefix . "Es konnten keine Offline-Pickups gefunden werden!")
	}
}
return

:?:/op::
{
	if (tv) {
		return
	}	
	
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
		SendClientMessage(prefix . "Es konnten keine Offline-Pickups gefunden werden!")
	}
}
return

:?:/da::
{
	if (tv) {
		return
	}	
	
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
		SendClientMessage(prefix . "Es konnten keine Death-Pickups gefunden werden!")
	} else {
		deathArrested := true
		
		SetTimer, DeathArrestTimer, -2000
	}
}
return

:?:/dp::
{
	if (tv) {
		return
	}	
	
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
		SendClientMessage(prefix . "Es konnten keine Death-Pickups gefunden werden!")
	} else {
		deathArrested := true
		
		SetTimer, DeathArrestTimer, -2000
	}
}
return

:?:/arrestlist::
{
	arrestCount := 0
	
	SendClientMessage(prefix . "Verbrecher in der Arrestliste:")
	
	for index, arrestName in arrestList {
		SendClientMessage(prefix . "ID: " . getPlayerIdByName(getFullName(arrestName), 1) . " - " . csecond . getFullName(arrestName))
	
		arrestCount ++
	}
	
	if (!arrestCount) {
		SendClientMessage(prefix . "Es sind aktuell keine Spieler in deiner Arrest-Liste.")
	} else {
		SendClientMessage(prefix . "Spieler in Arrest-Liste: " . csecond . arrestCount)
	}
}
return

:?:/cufflist::
{
	grabCount := 0
	
	SendClientMessage(prefix . "Verbrecher in der Cuffliste:")
	
	for index, grabName in grabList {
		SendClientMessage(prefix . "ID: " . getPlayerIdByName(getFullName(grabName), 1) . " - " . csecond . getFullName(grabName))
	
		grabCount ++
	}
	
	if (!grabCount) {
		SendClientMessage(prefix . "Es sind aktuell keine Spieler in deiner Cuffliste.")
	} else {
		SendClientMessage(prefix . "Spieler in Cuffliste: " . csecond . grabCount)
	}
}
return

:?:/fahrt::
{
	if (tv) {
		return
	}

	SendChat("/l Die allgemeine Kontrolle ist nun beendet. Ich danke für Ihre Kooperation!")
	SendChat("/l Ich wünsche Ihnen nun eine schöne und angenehme Weiterfahrt! Auf Wiedersehen!")
}
return

:?:/tput::
{
	if (tv) {
		return
	}	
	
	SendInput, /trunk put{Space}
}
return

:?:/tcm::
{	
	if (tv) {
		return
	}	
	
	SendChat("/trunk clear mats")
}
return

:?:/tcd::
{
	if (tv) {
		return
	}	
	
	SendChat("/trunk clear drugs")
}
return

:?:/wtd::
{
	if (tv) { 
		return
	}
	
	SendChat("Guten Tag,")
	SendChat("Möchten Sie ein Ticket für Ihre(n) Wanted(s) ?")
}
return

:?:/dtd::
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
	if (tv) { 
		return
	}
	
	playerForTicket := PlayerInput("Spieler: ")
	playerForTicket := getFullName(playerForTicket)
	
	if (playerForTicket != "") {
		if (playerForTicket == getUsername()) {
			SendClientMessage(prefix . "Fehler: Du kannst dir selbst kein Ticket anbieten.")
		} else {
			SendChat("/l Guten Tag " . playerForTicket . ",")

			if (!admin || comhelper) {
				Sleep, 750
			}
		
			SendChat("/l Hiermit biete ich Ihnen einen Freikauf für Ihr Drogen an.")
			
			if (!admin || comhelper) {
				Sleep, 750
			}
			
			SendChat("/l Sollten Sie dieses Ticket ($4.000) nicht zahlen können, müssen wir Ihnen leider Wanteds eintragen!")
			
			if (!admin || comhelper) {
				Sleep, 750
			}			
			
			SendChat("/ticket " . playerForTicket . " 4000 Drogen Ticket")
		
		}
	}
}
return

:?:/twd::
{
	if (tv) { 
		return
	}
	
	playerForTicket := PlayerInput("Spieler: ")
	playerForTicket := getFullName(playerForTicket)
	
	if (playerForTicket != "") {
		if (playerForTicket == getUsername()) {
			SendClientMessage(prefix . "Fehler: Du kannst dir selbst kein Ticket anbieten.")
		} else {
			wantedCount := PlayerInput("Wanteds: ")
			if (wantedCount is not number) {
				SendClientMessage(prefix . "Fehler: Du kannst nur Zahlen eingeben.")
				return
			}
			
			if (wantedCount > 4) {
				SendClientMessage(prefix . "Fehler: Du kannst nur bis 4 Wanteds ein Ticket ausstellen.")
				return
			}
		
			SendChat("/l Guten Tag " . playerForTicket . ",")
		
			if (!admin || comhelper) {
				Sleep, 750
			}		
			
			SendChat("/l Hiermit biete ich Ihnen einen Freikauf für Ihr" . (wantedCount == 1 ? " Wanted" : "e zwei Wanteds") . " an.")
			
			if (!admin || comhelper) {
				Sleep, 750
			}
			
			SendChat("/l Sollten Sie dieses Ticket ($" . FormatNumber(wantedCount * 750) . ") nicht zahlen können, werden wir Sie leider verhaften müssen.")
			
			if (!admin || comhelper) {
				Sleep, 750
			}			
			
			if ((wantedCount * 750) > 3000) {
				SendClientMessage(prefix . "Fehler: Diese Summe konnte unmöglich erreicht werden. Siehe max. Ticket-Wanted Regel.")
			} else {
				SendChat("/ticket " . playerForTicket . " " . (wantedCount * 750) " Wanted-Ticket (" . wantedCount . " Wanted" . (wantedCount == 1 ? "" : "s") . ")")
			}		
		}
	}
}
return

:?:/ci::
{	
	if (tv) { 
		return
	}	
	
	if (isBlocked()) {
		SendInput, /dl{enter}
	} else {
		SendInput, t/dl{enter}
	}
	
	carID := PlayerInput("Fahrzeug-ID: ")
	
	if (carID != "") {
		SendClientMessage(prefix . "Fahrzeuginformationen werden gespeichert, bitte warte einen Moment...")
		
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
		SendClientMessage(prefix . "Fehler: Die Eingabe wurde abgebrochen.")
	} else {
		playerToFind := playerToFindInput
		
		if (getFullName(playerToFind) == "") {
			SendClientMessage(prefix . "Fehler: Der angegebene Spieler ist nicht online.")
		} else if (getFullName(playerToFind) == getUserName()) {
			SendClientMessage(prefix . "Fehler: Du kannst dich nicht selber finden.")
		} else {
			autoFindMode := 1
		
			findPlayer()
			findInfo(playerToFind)
		}
	}
}
return

:?:/as::
:?:/asp::
{
	if (!showDriver) {
		playerToShowToInput := PlayerInput("Partner: ")
		
		if (playerToShowToInput == "" || playerToShowToInput == " ") {
			SendClientMessage(prefix . "Fehler: Du hast die Eingabe abgebrochen.")
		} else if (!getFullName(playerToShowToInput)) {
			SendClientMessage(prefix . "Fehler: Der angegebene Show-Partner ist offline.")
		} else if (getFullName(playerToShowToInput) == getUserName()) {
			SendClientMessage(prefix . "Fehler: Du kannst dir selbst niemanden anzeigen, nutze /af[ind]")
		} else {
			playerToShowTo := playerToShowToInput		
			playerToFindInput := PlayerInput("Gesuchter: ")
			
			if (playerToFindInput == "" || playerToFindInput == " ") {
				SendClientMessage(prefix . "Fehler: Du hast die Eingabe abgebrochen.")
			} else if (!getFullName(playerToFindInput)) {
				SendClientMessage(prefix . "Fehler: Der gesuchte Spieler ist offline.")
				return
			} else if (getFullName(playerToFindInput) == getUserName()) {
				SendClientMessage(prefix . "Fehler: Du kannst dich nicht selbst finden.")
				return
			} else {
				playerToFind := playerToFindInput
				autoFindMode := 2
				
				findPlayer()
				findInfo(playerToFind)
			}
		}
	}
}
return

:?:/cpos::
:?:/crewpos::
{
	if (tv) { 
		return
	}	
	
	sendPosition("crew", 0)
}
return

:?:/wo::
{
	SendChat("/d HQ: Wo befindet ihr euch und was ist das Problem?")
}
return

:?:/ver::
{	
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/d HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/d HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		if (keybinderFrac == "FBI") {	
			SendChat("/d HQ: Agent " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "LSPD") {
			SendChat("/d HQ: Officer " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "Army") {
			SendChat("/d HQ: Soldat " . getUserName() . " hat verstanden und bestätigt!")
		}
	}
}
return

:?:/fver::
{
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/f HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/f HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		if (keybinderFrac == "FBI") {	
			SendChat("/f HQ: Agent " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "LSPD") {
			SendChat("/f HQ: Officer " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "Army") {
			SendChat("/f HQ: Soldat " . getUserName() . " hat verstanden und bestätigt!")
		}
	}
}
return

:?:/rver::
{
	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/r HQ: Wagen " . getVehicleID() . " hat verstanden und bestätigt!")
		} else {
			SendChat("/r HQ: Wagen " . getVehicleModelId() . " hat verstanden und bestätigt!")
		}
	} else {
		if (keybinderFrac == "FBI") {	
			SendChat("/r HQ: Agent " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "LSPD") {
			SendChat("/r HQ: Officer " . getUserName() . " hat verstanden und bestätigt!")
		} else if (keybinderFrac == "Army") {
			SendChat("/r HQ: Soldat " . getUserName() . " hat verstanden und bestätigt!")
		}
	}
}
return

:?:/nbk::
:?:/needbk::
{
	SendChat("/d HQ: Wird Verstärkung weiterhin gefordert?")
}
return

:?:/einsatz::
{	
	SendClientMessage(prefix . csecond . "Info: {FFFFFF}Trage die Zeit in 'Minuten' ein, anschließend wird die Uhrzeit berechnet.")
	
	commitmentMins := PlayerInput("Zeit: ")
	if (commitmentMins == "" || commitmentMins == " ") {
		return
	}
	
	commitmentLocation := PlayerInput("Aufstellort: ")
	if (commitmentLocation == "" || commitmentLocation == " ") {
		return
	}
	
	SendClientMessage(prefix . csecond . "Info: " . COLOR_WHITE . "Trage Extras ein, Beispiele: " . csecond . "(U)nder(c)over, Swat, normal")
	
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
			SendClientMessage(prefix . "Fehler: Verwende folgende Parameter: (U)nder(c)over, Normal, SWAT")
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
			
			IniWrite, %commitmentUnix%, settings.ini, UnixTime, commitmentUnix
			IniWrite, %commitmentTime%, settings.ini, UnixTime, commitmentTime
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
	if (tv) { 
		return
	}		
	
	if (checkRank()) {
		if (getRank() > 0 && getRank() < 7) {
			extra := "/f HQ:"
		} else if (getRank() > 7) {
			extra := "/hq"
		} else {
			SendClientMessage(prefix . "Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
			extra := "/f HQ:"
		}
		
		SendChat(extra . " Es findet ein Matstransport statt! ALLE EINHEITEN SOFORT ANRÜCKEN!")
		SendChat(extra . " Derzeitige Position: " . getLocation())
	}
}
return

:?:/mrob::
{	
	if (tv) { 
		return
	}		
	
	if (checkRank()) {
		if (getRank() > 0 && getRank() < 7) {
			extra := "/f HQ:"
		} else if (getRank() > 7) {
			extra := "/hq"
		} else {
			SendClientMessage(prefix . "Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
			extra := "/f HQ:"
		}
		
		SendChat(extra . " Es findet aktuell ein Überfall auf einen Matstransport statt!")
		SendChat(extra . " ALLE EINHEITEN SOFORT ANRÜCKEN! Aktuelle Position: " . getLocation())
		
		if (!bk) {
			bk := true
			
			SendChat("/bk")
		}
	}
}
return

:?:/go::
{	
	if (checkRank()) {
		if (getRank() > 0 && getRank() < 7) {
			extra := "/d HQ:"
		} else if (getRank() > 7) {
			extra := "/hq"
		} else {
			SendClientMessage(prefix . "Bei der Rang-Abfrage ist ein Fehler aufgetreten.")
			extra := "/d HQ:"
		}
		
		SendChat(extra . " Einsatzleitung erlaubt Zugriff, GOGOGO!")
	}
}
return

:?:/fgo::
{
	SendChat("/f HQ: Einsaztleitung erlaubt Zugriff, GOGOGO!")
}
return

:?:/rgo::
{
	SendChat("/r HQ: Einsaztleitung erlaubt Zugriff, GOGOGO!")
}
return

:?:/abholung::
{
	if (tv) { 
		return
	}		
	
	abholungChat := PlayerInput("Chat: ")
	if (abholungChat == "" || abholungChat == " ") {
		return
	}
	
	SendChat("/" . abholungChat . " HQ: Erbitte Abholung in " . getLocation() . "!")
}
return

:?:/kabholung::
{
	if (tv) { 
		return
	}		
	
	if (abholungChat != "") {
		SendChat("/" . abholungChat . " HQ: Eine Abholung wird nicht mehr benötigt.")
		
		abholungChat := ""
	} else {
		SendClientMessage(prefix . "Fehler: Du hast keine Abholung angefordert.")
	}
}
return

:?:/z::
:?:/ziel::
{
	hunting := PlayerInput("Ziel (Name/ID): ")
	if (hunting == "" || hunting == " ") {
		return
	}
	
	if (getFullName(hunting) == "") {
		SendClientMessage(prefix . "Der gesuchte Spieler ist nicht online.")
		return
	}
	
	if (checkRank()) {
		if (getRank() > 6) {
			SendChat("/hq An alle Einheiten: Einsatzziel ist " . getFullName(hunting) . " (ID: " . getPlayerIdByName(getFullName(hunting)) . "). Alle SOFORT ausrücken!")
		} else {
			SendChat("/f HQ: An alle Einheiten: Einsatzziel ist " . getFullName(hunting) . " (ID: " . getPlayerIdByName(getFullName(hunting)) . "). Alle SOFORT ausrücken!")
		}
		
		Sleep, 200
		
		SendClientMessage(prefix . "Möchtest du den Spieler suchen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
		
		KeyWait, X, D, T10
		
		if (!ErrorLevel) {
			playerToFind := getFullName(hunting)
			autoFindMode := 1
			
			findPlayer()
			findInfo(playerToFind)
		}
	}
}
return

:?:/vf::
:?:/verf::
:?:/verfolgung::
{
	if (tv) { 
		return
	}		
	
	name := PlayerInput("Verbrecher: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Der Verbrecher ist nicht online.")
		return
	}

	if (isPlayerInAnyVehicle()) {
		if (isPlayerDriver()) {
			SendChat("/d HQ: Wagen " . getVehicleID() . " erbittet Unterstützung bei der Verfolgung von " . getFullName(name) . "[" . getPlayerIdByName(getFullName(name), true) . "]!")
		} else {
			SendChat("/d HQ: Wagen " . getVehicleModelId() . " erbittet Unterstützung bei der Verfolgung von " . getFullName(name) . "[" . getPlayerIdByName(getFullName(name), true) . "]!")
		}
	} else {
		SendChat("/d HQ: Erbitte Unterstützung bei der Verfolgung von " . getFullName(name) . "[" . getPlayerIdByName(getFullName(name), true) . "]!")
	}
}
return

:?:/ort::
{
	if (tv) { 
		return
	}		
	
	position := PlayerInput("Letzter bekannter Aufenthaltsort: ")
	if (position == "" || position == " ") {
		return
	}
	
	SendChat("/d HQ: Letzter bekannter Aufenthaltsort: " . position)
}
return

:?:/air::
{
	if (tv) { 
		return
	}		
	
	SendChat("/d HQ: Fordere Luftüberwachung im Sektor " . getLocation() . " an!")
}
return

:?:/off::
{
	SendChat("/d HQ: Officer " . getUsername() . " meldet sich vom Dienst ab!")
}
return

:?:/on::
{
	SendChat("/d HQ: Officer " . getUsername() . " meldet sich einsatzbereit zum Dienst!")
}
return

:?:/maumodus::
{
	if (maumode) {
		maumode := 0
		
		SendClientMessage(prefix . "Du hast den Maumau Modus " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	} else {
		maumode := 1
	
		SendClientMessage(prefix . "Du hast den Maumau Modus " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
		SendClientMessage(prefix . "/mhelp kannst du alles genau einsehen.")
	}
}
return

:?:/wasser::
:?:/wassermodus::
{
	if (watermode) {
		watermode := 0
		
		SendClientMessage(prefix . "Du hast den Wassermodus " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	} else {
		watermode := 1
		airmode := 0
		
		SendClientMessage(prefix . "Du hast den Wassermodus " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
	}
}
return

:?:/luft::
:?:/luftmodus::
{	
	if (airmode) {
		airmode := 0
		
		SendClientMessage(prefix . "Luftmodus " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	} else {
		airmode := 1
		watermode := 0
		
		SendClientMessage(prefix . "Luftmodus " . COLOR_GREEN . "aktiviert" . COLOR_WHITE . ".")
	}
}
return

:?:/sperrzone::
{
	sperrzone := PlayerInput("Sperrzone: ")
	if (sperrzone == "" || sperrzone == " ") {
		return
	}

	SendChat("/gov Das Gebiet " . sperrzone . " wird zur Sperrzone erklärt.")
	SendChat("/gov Wer sich unbefugt in der Sperrzone aufhält muss mit Konsequenzen rechnen.")
}
return

:?:/ksperrzone::
{
	if (sperrzone != "") {
		SendChat("/gov Die Sperrzone " . sperrzone . " wird hiermit aufgehoben.")
	} else {
		SendChat("/gov Alle Sperrzonen werden hiermit aufgehoben.")
	}
	
	SendChat("/roadblock deleteall")
}
return

:?:/fischtyp::
:?:/fishtype::
:?:/fishtyp::
{
	SendClientMessage(prefix . csecond . "1: {FFFFFF}geringste LBS/HP - " . csecond . "2: {FFFFFF}geringster Geldwert")
	
	fishType := PlayerInput("Typ: ")
	
	if (fishType == "1") {
		fishMode := 0
		
		SendClientMessage(prefix . "Du wirfst nun den Fisch mit dem geringsten " . csecond . "LBS/HP-Wert {FFFFFF}weg.")
		
		IniWrite, %fishMode%, settings.ini, settings, fishMode
	} else if (fishType == "2") {
		fishMode := 1
		
		SendClientMessage(prefix . "Du wirfst nun den Fisch mit dem geringsten " . csecond . "Geldwert {FFFFFF}weg.")
		
		IniWrite, %fishMode%, settings.ini, settings, fishMode
	}
}
return

:?:/afish::
{
	if (tv) { 
		return
	}		
	
	startFish()
}
return

:?:/asell::
{
	if (tv) { 
		return
	}		
	
	if (IsPlayerInRangeOfPoint(2.3247, -28.8923, 1003.5494, 10)) {
		SendClientMessage(prefix . "Deine Fische werden nun verkauft!")
		
		sellFishMoney := 0
		
		Loop, 5 {
			SendChat("/sell fish " . A_Index)
			
			Sleep, 200
		
			chat := readChatLine(0)
			
			if (RegExMatch(chat, "Du hast deinen (.+) \((\d+) LBS\) für (\d+)\$ verkauft.", chat_)) {
				sellFishMoney += numberFormat(chat_3)
			}
			
			if (!admin || comhelper) {
				Sleep, 500 
			}
		}
		
		IniRead, Fishmoney, stats.ini, Allgemein, Fishmoney, 0
		Fishmoney += numberFormat(sellFishMoney)
		IniWrite, %Fishmoney%, stats.ini, Allgemein, Fishmoney
		
		SendClientMessage(prefix . "Du hast für deine Fische $" . csecond . FormatNumber(sellFishMoney) . COLOR_WHITE . " erhalten.")
		SendClientMessage(prefix . "Gesamt hast du bereits $" . csecond . FormatNumber(Fishmoney) . COLOR_WHITE . " durch Fische verdient.")
	} else {
		IniRead, Fishmoney, stats.ini, Allgemein, Fishmoney, 0
		
		SendClientMessage(prefix . "Du kannst deine Fische hier nicht verkaufen! (Gesamter Verdienst: " . csecond . FormatNumber(Fishmoney) . COLOR_WHITE . "$)")
	}
}
return

:?:/acook::
{
	if (tv) { 
		return
	}		
	
	if (!getPlayerInteriorId()) {
		IniRead, campfire, settings.ini, Items, campfire, 0
		
		if (campfire) {
			SendChat("/campfire")
			
			Sleep, 200
			
			Loop, 5 {
				SendChat("/cook fish " . A_Index)
			
				Sleep, 700
			}		
		} else {
			SendClientMessage(prefix . "Du hast kein Lagerfeuer, geh in ein Restaurant.")
		}
	} else {
		if (isOnCookPoint()) {
			Loop, 5 {
				SendChat("/cook fish " . A_Index)
			
				Sleep, 700
			}	
		} else {
			SendClientMessage(prefix . "Du kannst hier nicht kochen.")
		}
	}
	
	Sleep, 200
	
	checkCooked()
}
return

:?:/fp::
:?:/fische::
{
	SendClientMessage(prefix . "Überprüfung der ungekochten Fische:")
	
	checkFishes()
}
return

:?:/hp::
:?:/cooked::
{
	SendClientMessage(prefix . "Überprüfung der gekochten Fische:")
	
	checkCooked()
}
return

:?:/sellfish::
{
	if (tv) { 
		return
	}		
	
	hp := checkCooked()
	
	if (hp < 1) {
		SendCLientMessage(prefix . "Du hast keine gekochten Fische bei dir.")
	} else {
		name := PlayerInput("/Name: ")
		if (name == "" || GetFullName(name) == "") {
			return
		}
		
		SendChat("/l Ich gebe Dir, " . getFullName(name) . ", nun meine gekochten Fische mit " . hp . " HP!")
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		Loop, 5 {
			SendChat("/sell cooked " . A_Index . " " . getFullName(name))
			if (!admin || comhelper) {
				Sleep, 500
			}
		}
	}
}
return

:?:/dep::
:?:/department::
{
	IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
	
	SendClientMessage(prefix . "Deine aktuelle Abteilung: " . csecond . keybinderFrac)
	
	dep := PlayerInput("Abteilung (LSPD, FBI, Army): ")
	if (dep == "" || dep = " ") {
		return
	}
	
	if (dep == keybinderFrac) {
		SendClientMessage(prefix . "Fehler: Diese Abteilung hast du bereits eingetragen.")
		return
	}
	
	if (dep == "LSPD" || dep == "FBI" || dep == "Army") {
		IniWrite, %dep%, settings.ini, Einstellungen, keybinderFrac
	
		SendClientMessage(prefix . "Deine Abteilung wurde auf " . csecond . dep . COLOR_WHITE . " geupdated.")
	} else {
		SendClientMessage(prefix . "Fehler: Verwende bitte folgende Abteilungen: LSPD, FBI, Army")
	}
}
return

:?:/setrang::
{
	IniRead, rank, settings.ini, settings, rank, 0
		
	rank := PlayerInput("Rang: ")
	if (rank == "" || rank = " ") {
		return
	}
	
	if (rank > 11 || rank < 1) {
		SendClientMessage(prefix . "Fehler: Der Rang muss mindestens 1 und maximal 11 sein.")
		return
	}
	
	IniWrite, %rank%, settings.ini, settings, rank
	
	SendClientMessage(prefix . "Dein Rang wurde auf " . csecond . rank . COLOR_WHITE . " geupdated.")
}
return

:?:/bc::
{
	if (tv) { 
		return
	}		
	
	SendChat("/roadbarrier create")
}
return

:?:/bd::
{
	if (tv) { 
		return
	}		
	
	SendChat("/roadbarrier delete")
}
return

:?:/bda::
{
	if (tv) { 
		return
	}		
	
	SendChat("/roadbarrier deleteall")
}
return

:?:/rb::
{
	if (tv) { 
		return
	}		
	
	SendChat("/roadblock create")
}
return

:?:/db::
{
	if (tv) { 
		return
	}	
	
	SendChat("/roadblock delete")
}
return

:?:/dba::
{
	if (tv) { 
		return
	}	
	
	SendChat("/roadblock deleteall")
}
return

:?:/rs::
:?:/rr::
:?:/robres::
{
	if (tv) { 
		return
	}		
	
	if (!isPlayerOnLocal()) {
		SendClientMessage(prefix . "Fehler: Du bist nicht in der Nähe einer Restaurant-Kette.")
	} else if (IsPlayerInAnyVehicle()) {
		SendClientMessage(prefix . "Fehler: Du darfst dich in keinem Fahrzeug befinden.")
	} else {
		addLocalToStats()
	}
}
return

:?:/sr::
{
	SendChat("/showres")
}
return


:?:/cd::
:?:/countdown::
{
	if (tv) { 
		return
	}	
	
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
		
		if (cdChat == "")
			cdChat := "l"
		
		SendChat("/" . cdChat . " Countdown:")
		
		cdGoMessage := "Go Go Go!"
		
		SendClientMessage(prefix . "Du kannst den Countdown mit '" . csecond . stopAutomaticSystemsNoMods . COLOR_WHITE . "' abbrechen.")
		
		SetTimer, CountdownTimer, 1000
		
		countdownRunning := 1
	}
}
return

:?:/geld::
:?:/bank::
{
	if (tv) { 
		return
	}	
	
	SendChat("Sehe ich aus wie ein Geldautomat?")
}
return

:?:/taxi::
{
	if (tv) { 
		return
	}	
	
	if (keybinderFrac == "FBI") {
		SendChat("/l Wir sind kein Taxiunternehmen, wir sind Agenten.")
	} else {
		SendChat("/l Wir sind kein Taxiunternehmen, wir sind Beamte.")
	}
}
return

:?:/gf::
:?:/gfs::
{
	SendChat("/gangfights")
}
return

:?:/np::
{
	if (tv) { 
		return
	}	
	
	Random, rand, 1, 3
	
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
{
	if (tv) { 
		return
	}	
	
	SendChat("Haben Sie dafür Beweise? (Screenshots, Video, o.ä.)")
}
return

:?:/zeuge::
{
	if (tv) { 
		return
	}	
	
	SendChat("Zeugen zählen nicht und werden nicht weiter beachtet.")
}
return

:?:/warte::
{
	if (tv) { 
		return
	}	
	
	SendChat("Einen Moment bitte, der Fall wird überprüft.")
}
return

:?:/beschwerde::
{
	if (tv) { 
		return
	}	
	
	SendChat("/l Sie haben das Recht, eine Beschwerde im Forum zu erstellen.")

	if (!admin || comhelper) {
		Sleep, 400
	}

	SendChat("/l Wir bitten Sie hierbei, die Beschwerdeninformationen zu beachten.")
}
return

:?:/rechte::
{
	if (tv) {
		return
	}
	
	SendChat("/l Sie haben das Recht zu schweigen. Alles was Sie sagen, kann und wird vor Gericht gegen Sie verwendet werden.")
	
	if (!admin || comhelper) { 
		Sleep, 750
	}
	
	SendChat("/l Sie haben das Recht auf einen Anwalt. Können Sie sich keinen leisten wird Ihnen einer gestellt.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Haben Sie Ihre Rechte verstanden, welche ich Ihnen vorgelesen hab?")
}
return

:?:/warten::
{
	if (tv) { 
		return
	}	

	SendChat("/l Bitte warten Sie einen Moment, ich überprüfe die Gültigkeit Ihrer Dokumente.")
}
return

:?:/passieren::
{
	if (tv) { 
		return
	}	

	SendChat("/l Sie dürfen passieren.")
	
	if (!admin || comhelper) {
		Sleep, 750
	}	
	
	SendChat("/l Ich wünsche Ihnen eine gute Weiterfahrt. Auf Wiedersehen!")
}
return

:?:/runter::
{
	if (tv) { 
		return
	}	
	
	SendChat("/l Steigen Sie bitte umgehend vom Fahrzeug.")

	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/l Ansonsten sind wir gezwungen Sie wegen Verweigerung zu verhaften.")
}
return

:?:/hdf::
:?:/ruhe::
{
	if (tv) { 
		return
	}	
	
	Random, tmp, 1, 3
	
	if (tmp == 1) {
		SendChat("/l Sein Sie bitte still.")
	} else if (tmp == 2) {
		SendChat("/l Können Sie bitte ruhig sein?")
	} else if (tmp == 3) {
		SendChat("/l Bitte sein Sie leise..")
	}
}
return

:?:/tuch::
{
	if (tv) {
		return
	}
	
	SendChat("Warum weinen Sie, möchten Sie ein Taschentuch?")
}
return

:?:/time::
{
	SendChat("/time")
	
	Sleep, 100
	
	adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
	cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
	
	if (RegExMatch(cText, "(.+)In Behandlung: (\d+)", cText_)) {
		time := formatTime(cText_2)
		
		writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . time . " im KH")
		SendClientMessage(prefix . "Du bist noch " . csecond . time . " {FFFFFF}im Krankenhaus.")
	} else if (RegExMatch(cText, "(.+)Knastzeit: (\d+)", cText_)) {
		time := formatTime(cText_2)
		
		if (getPlayerInteriorId() == 1) {
			writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . time . " im Prison")
			SendClientMessage(prefix . "Du bist noch " . csecond . time . " {FFFFFF}im Prison.")
		} else {
			writeString(hGTA, adrGTA2 + 0x7AAD43, cText_1 . "Noch " . time . " im Knast")
			SendClientMessage(prefix . "Du bist noch " . csecond . time . " {FFFFFF}im Knast, die Kaution beträgt " . csecond . FormatNumber(Floor(cText_2 / 60) * 500) . COLOR_WHITE . "$.")
		}
	}
}
return

:?:/pi::
{	
	name := PlayerInput("Spielerinformationen: ")
	
	SendChat("/id " . name)
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/number " . name)
	if (!admin || comhelper) {
		Sleep, 750
	}
	
	SendChat("/mdc " . name)
}
return

:?:/alotto::
{
	if (lottoNumber == 0) {
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
	if (tv) {
		return
	}	
	
	name := PlayerInput("Fan: ")
	if (name == "" || name == " ") {
		return
	}
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
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
{
	SendChat("/paintball")
	
	Sleep, 200
	
	players := 0
	
	Loop, 100 {
		chat := readChatLine(players)
		
		if (InStr(chat, "Punkte")) {
			players++
		} else {
			SendClientMessage(prefix . "Spieler im Paintball: " . csecond . players)
			return
		}
	}
}
return

:?:/savestats::
{
	FormatTime, time,, dd.MM.yyyy HH:mm
	
	SendClientMessage(prefix . "Statistiken werden gespeichert, Datum: " . csecond . time)
	
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
	if (tv) {
		return
	}	
	
	if (getPlayerInteriorId() == 0) {
		SendClientMessage(prefix . "Fehler: Du befindest dich in keinem Gebäude.")
		return
	}		
	
	SendInput, /undercover{space}
}
return

:?:/auc::
{
	if (tv) {
		return
	}	
	
	if (getPlayerInteriorId() == 0) {
		SendClientMessage(prefix . "Fehler: Du befindest dich in keinem Gebäude.")
		return
	}	
	
	Random, number, 1, 39
	
	SendChat("/undercover " . number)
}
return

:?:/jas::
{
	if (tv) {
		return
	}		
	
	SendChat("Ja Sir, was kann ich für Sie tun?")
}
return

:?:/jam::
{
	if (tv) {
		return
	}		
	
	SendChat("Ja Madam, was kann ich für Sie tun?")
}
return

:?:/ja::
{
	if (tv) {
		return
	}		
	
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
		
		distanceSMS++
	}
	
	if (sms_2 != "") {
		SendClientMessage(prefix . "Letzte SMS (von " . csecond . sms_2 . COLOR_WHITE . "):")
		SendClientMessage(prefix . csecond . sms_1)
		
		SendInput, /sms %sms_3%{space}
	} else {
		SendClientMessage(prefix . "Keiner hat dich angeschrieben!")
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
		SendClientMessage(prefix . "Letzte Werbung (von " . ad_2 . "):")
		SendClientMessage(prefix . csecond . ad_1)
		
		SendInput, /sms %ad_3%{space}
	} else {
		SendClientMessage(prefix . "Keine letzte Werbung gefunden!")
	}
}
return

:?:/kcall::
{	
	
	name := PlayerInput("Name: ")
	if (name == "" || name == " ")
		return
	
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/number " . name)
	
	Sleep, 200
	
	chat := readChatLine(0)
	
	if (RegExMatch(chat, "Name: (\S*), Ph: (\d*)", number_)) {
		SendClientMessage(prefix . "Ausgewählter Spieler: " . csecond . number_1)
		
		SendChat("/call " . number_2)
	} else {
		SendClientMessage(prefix . "Anruf fehlgeschlagen!")
	}
}
return

:?:/calarm::
{
	name := PlayerInput("Name: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/number " . name)
	
	Sleep, 200
	
	chat := readChatLine(0)
	
	if (RegExMatch(chat, "Name: (\S*), Ph: (\d*)", number_)) {
		SendClientMessage(prefix . "Ausgewählter Spieler: " . csecond . number_1)
		
		SendChat("/" . number_2 . " Geh lieber offline, dein Car wird vom O-Amt abgeschleppt, gönne dennen nicht.")
	} else {
		SendClientMessage(prefix . "Senden der SMS fehlgeschlagen!")
	}
}
return

:?:/ksms::
{
	name := PlayerInput("Name: ")
	if (name == "" || name == " ") {
		return
	}
	
	if (getFullName(name) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/number " . name)
	
	Sleep, 200
	
	chat := readChatLine(0)
	
	if (RegExMatch(chat, "Name: (\S*), Ph: (\d*)", number_)) {
		SendClientMessage(prefix . "Ausgewählter Spieler: " . csecond . number_1)
		
		SendInput, t/sms %number_2%{space}
	} else {
		SendClientMessage(prefix . "Senden der SMS fehlgeschlagen!")
	}
}
return

:?:/p::
:?:/pickup::
{
	if (tv) {
		return
	}		
	
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
		
		if (!admin || comhelper)
			Sleep, 400
		
		if (keybinderFrac == "FBI") {
			copTitle := "Agent"
		} else if (keybinderFrac == "LSPD") {
			copTitle := "Officer"
		} else if (keybinderFrac == "Army") {
			copTitle := "Soldat"
		}
		
		SendChat("Guten " . getDayTime() . " " . caller_1 . ", Sie sprechen mit " . copTitle . " " . name . ".")
		
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		SendChat("Wie kann ich Ihnen helfen?")
	} else {
		SendClientMessage(prefix . "Niemand hat dich angerufen!")
	}
}
return

:?:/h::
:?:/hangup::
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
			
			if (!admin || comhelper) {
				Sleep, 750
			}
			
			SendChat("Ich wünsche Ihnen noch einen schönen " . getDayTime() . ".")
		}
		
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		SendChat("/hangup")
	} else {
		SendClientMessage(prefix . "Niemand hat dich angerufen!")
	}
}
return

:?:/ab::
{
	if (tv) {
		return
	}		
	
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
		
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		SendChat("Guten " . getDayTime() . " " . caller_1 . ",")
	
		if (!admin || comhelper) {
			Sleep, 750
		}
	
		SendChat("Sie sind verbunden mit dem Anrufbeantworter von " . getUsername() . ".")
		
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		SendChat("Ich bin leider beschäftigt, bitte rufen Sie später erneut an!")
		
		if (!admin || comhelper) {
			Sleep, 750
		}
		
		SendChat("/hangup")
	} else {
		SendClientMessage(prefix . "Niemand hat dich angerufen!")
	}
}
return

:?:/tag::
{
	if (tv) {
		return
	}		
	
	SendChat("Guten " . getDayTime() . ", wie kann ich Ihnen behilflich sein?")
}
return

:?:/bye::
{
	if (tv) {
		return
	}		
	
	SendChat("Ich wünsche Ihnen noch einen schönen " . getDayTime() . ". Auf Wiedersehen!")
}
return

:?:/ac::
{
	SendChat("/activity")
}
return

:?:/ga::
{
	SendChat("/gpsaus")
	SendClientMessage(prefix . "Du hast den GPS Marker deaktiviert.")
}
return

:?:/fg::
{
	if (!getPlayerInteriorId()) {
		SendChat("/festgeld 1")
	} else { 
		SendChat("/festgeld 1250000")
	}
}
return

:?:/ap::
{
	if (tv) {
		return
	}		
	
	SendChat("/accept paket")
}
return

:?:/fill::
:?:/tanken::
{
	if (!isPlayerInAnyVehicle() || !isPlayerDriver()) {
		SendClientMessage(prefix . "Fehler: Du bist nicht der Fahrer eines Fahrzeuges.")
		return
	} else if (!isPlayerOnGasStation()) {
		SendClientMessage(prefix . "Fehler: Du bist nicht in der Nähe einer Tankstelle.")
		return
	} else {
		refillCar()
	}
}
return

:?:/sbd::
{
	if (tv) {
		return
	}			
	
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
		SendClientMessage(prefix . "Fehler: Die Sekundenangabe muss eine Zahl sein.")
		return
	}
	
	if (seconds < 60) {
		SendClientMessage(prefix . "Fehler: Die Sekundenangabe muss mehr als 60 sein.")
		return
	}
	
	if (seconds != "") {
		minutes := Floor(seconds / 60)
		SendClientMessage(prefix . csecond . FormatNumber(seconds) . " {FFFFFF}Sekunden sind " . csecond . FormatNumber(minutes) " {FFFFFF}Minuten.")
	}
}
return

:?:/link::
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
			SendClientMessage(prefix . "{2090B3}|________________________________________|")
			SendClientMessage(prefix . "Es wurde ein Link abkopiert und gespeichert:")
			SendClientMessage(prefix . csecond . clipboard)
			SendClientMessage(prefix . "Du kannst diesen nun überall einfügen.")
			SendClientMessage(prefix . "{2090B3}|________________________________________|")
			return
		}
	}
	
	if (!linkresult) {
		SendClientMessage(prefix . "Es wurde kein gültiger Link gefunden.")
	}	
}
return

:?:/savechat::
{
	FileCreateDir, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups
	FormatTime, zeit, %A_Now%,dd.MM.yy - HH.mm
	FileCopy, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups\chatlog %zeit% Uhr.txt, 0
	
	SendClientMessage(prefix . "Es wurde ein Backup des aktuellen Chatlogs erstellt.")
}
return

:?:/cc::
:?:/chatclear::
{
	Loop, 25 {
		SendClientMessage("")
	}
}
return

:?:/wagen::
{
	if (tv) { 
		return
	}
	
	SendChat("/d HQ: Ich benötige dringend einen Streifenwagen, aktuelle Position: " . getLocation())
}
return

:?:/sani::
{
	if (tv) { 
		return
	}
	
	SendChat("/d HQ: Ich benötige dringend einen Rettungswagen, aktuelle Position: " . getLocation())
	SendChat("/service")
	
	Sleep, 250
	
	SendInput, {down 4}{enter}
}
return

:?:/oamt::
:?:/abschlepp::
{
	SendChat("/d HQ: Ich benötige dringend einen Ordnungsbeamten, aktuelle Position: " . getLocation())
	SendChat("/service")
	
	Sleep, 250
	
	SendInput, {down 5}{enter}
}
return

:?:/checkpoint::
{
	x := PlayerInput("x: ")
	if (x == "" || x == " " || x is not number) {
		SendClientMessage(prefix . "Fehler: Du hast keine 'X' Koordinate angegeben.")
		return
	}
	
	y := PlayerInput("y: ")
	if (y == "" || y == " " || y is not number) {
		SendClientMessage(prefix . "Fehler: Du hast keine 'Y' Koordinate angegeben.")
		return
	}
	
	z := PlayerInput("z: ")
	if (z == "" || z == " " || z is not number) {
		SendClientMessage(prefix . "Fehler: Du hast keine 'Z' Koordinate angegeben.")
		return
	}	

	if (IsMarkerCreated()) {
		SendClientMessage(prefix . "Möchtest du den Checkpoint überschreiben? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
		
		KeyWait, X, D, T10
		
		if (ErrorLevel) {
			return
		}
	}
	
	if (setCheckpoint(x, y, z, 0.5)) {
	} else {
		SendClientMessage(prefix . "Der Checkpoint konnte nicht erstellt werden.")
	}
}
return

:?:/coords::
{
	getPlayerPos(posX, posY, posZ)
	SendClientMessage("{FFFF00}* X: " . posX . " Y: " . posY . " Z: " . posZ)
}
return

:?:/restart::
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	acceptTicket(9)
}
return

:?:/supov::
{
	if (keybinderVersion == "nooverlay") {
		SendClientMessage(prefix . "Fehler: Du benutzt die Overlay lose Version")
		return
	}
	
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	if (overlayOn) {
		SetTimer, updateOverlay, Off
		
		TextDestroy(sup_heading)
		TextDestroy(sup_page)
		TextDestroy(sup_text)
		BoxDestroy(sup_box)
		
		overlayOn := false
	} else {
		sup_box := BoxCreate(500, 400, 275, 175, 0xDD000000, true)
		
		BoxSetBorder(sup_box, 2, true)
		BoxSetBorderColor(sup_box, 0xFF5AE342)
		
		sup_heading := TextCreate("Arial", 7, true, false, 503, 403, 0xFF5AE342, "--- --- --- --- --- --- --- --- --- --- --- --- --- ---     Ticket #01     --- --- --- --- --- --- --- --- --- --- --- --- --- ---", false, false)
		sup_page := TextCreate("Arial", 7, true, false, 503, 560, 0xFF5AE342, "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --    Seite 01   -- --- --- --- --- --- --- --- --- --- --- --- --- --- ---", false, false)
		sup_text := TextCreate("Arial", 7, true, false, 503, 413, 0xFFFFFFFF, "", false, false)
		
		TextSetShown(sup_heading, true)
		TextSetShown(sup_page, true)
		TextSetShown(sup_text, true)
		
		SetTimer, updateOverlay, 50
		
		overlayOn := true
	}
}
return

~^Up::
{
	if (overlayOn == true) {
		if (page == 1) {
			return
		}
		
		page--
	}
}
return

~^Down::
{
	if (overlayOn == true) {
		page++
	}
}
return

~^Right::
{
	if (overlayOn == true) {
		if (numID == 15) {
			numID := 1
		} else {
			numID++
		}
		
		Loop, parse, sup_text_%numID%, `n, `r
		{
			index := A_Index
		}
		
		page := Floor((index - 1) / 14) + 1
		
		if (page == 0) {
			page := 1
		}
	}
}
return

~^Left::
{
	if (overlayOn == true) {
		if (numID == 1) {
			numID := 15
		} else {
			numID--
		}
		
		Loop, parse, sup_text_%numID%, `n, `r
		{
			index := A_Index
		}
		
		page := Floor((index - 1) / 14) + 1
		
		if (page == 0) {
			page := 1
		}
	}
}
return

:?:/setadmin::
{
	comhelper_ := PlayerInput("Communityhelfer? Ja/Nein: ")
	
	if (InStr(comhelper_, "ja")) {
		comhelper := 1
	} else if (InStr(comhelper_, "nein")) {
		comhelper := 0
	} else {
		SendClientMessage(prefix . "Trage Ja oder Nein ein.")
		return
	}
	
	IniWrite, %comhelper%, Settings.ini, Einstellungen, comhelper
	SendClientMessage(prefix . "Du hast dein Communityhelfer Status auf " . csecond . comhelper . COLOR_WHITE . " gesetzt.")
}
return

:?:/tt::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	acceptTicket(ticketID)
}
return

:?:/gt::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	reason := PlayerInput("Grund: ")
	if (reason == "" || reason == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keinen Grund angegeben.")
		return
	}
	
	SendClientMessage(prefix . "Mögliche Empfänger: (Sup)porter, (Mod)erator, Admin, (Head) Admin, (Proj)ektleiter, (Community) Helfer")
	
	toWhomInput := PlayerInput("An: ")
	if (toWhomInput == "" || toWhomInput == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keinen Empfänger angegeben.")
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
			SendClientMessage(prefix . "Unbekannter Empfänger: " . csecond . toWhomInput)
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
			SendClientMessage(prefix . "Unbekannter Spieler: " . csecond . toWhomInput)
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
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	closeTicket(ticketID)
}
return

:?:/fragen::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Hast du weitere Fragen, Probleme oder Anliegen?")
}
return

:?:/tafk::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Wie kann ich dir helfen?")
}
return

:?:/grund::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Warum soll ich dich an das gewünschte Mitglied weiterleiten?")
}
return

:?:/ubbw::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " UBB (= Neon) bzw. Unterbodenbeleuchtungs Codes kannst du in speziellen Events gewinnen (äußerst selten).")

	if (!admin || comhelper) {
		Sleep, 500
	}
	
	SendChat("/aw " . ticketID . " Ebenfalls ist es möglich einen UBB-Code bzw. ein UBB-Car für InGame Geld von anderen Spielern abzukaufen.")
}
return

:?:/autow::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Dein Auto findest du ganz einfach per /carkey -> Auto auswählen -> /findcar wieder.")
}
return

:?:/cop::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ticketID := PlayerInput("Ticket-ID: ")
	if (ticketID == "" || ticketID == " ") {
		SendClientMessage(prefix . "Fehler: Du hast keine ID angegeben.")
		return
	}
	
	if (ticketID is not number) {
		SendClientMessage(prefix . "Fehler: Du musst eine gültige ID angeben.")
		return
	}
	
	SendChat("/aw " . ticketID . " Bitte melde dich beim zuständigen Beamten, die Administration hat damit nichts zu tun!")
}
return

:?:/sdm::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
		
	SendChat("/prison " . ID . " 60 Sinnloses Deathmatch")
}
return

:?:/2sdm::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 120 2x Sinnloses Deathmatch")
}
return

:?:/3sdm::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("SDM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . name . " 30 Unrealistisches Verhalten")
}
return

:?:/buguse::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Buguse-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . name . " 120 Buguse")
	SendChat("/warn " . name . " Buguse")
}
return

:?:/intflucht::
{
	if (!admin || comhelper) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Interior-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Interior-Flucht")
}
return

:?:/offline::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Offline-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Offline-Flucht")
}
return

:?:/carsurf::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Carsurf-DM-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Carsurf-DM")
}
return

:?:/jobst::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Jobstörung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Jobstörung")
}
return

:?:/eventst::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Eventstörung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Eventstörung")
}
return

:?:/anfahren::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Anfahren-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Absichtliches Anfahren")
}
return

:?:/baserape::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Baserape-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Baserape während Gangfight")
}
return

:?:/gfst::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("GF-Störung-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Gangfight-Störung")
}
return

:?:/anti::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Schießen-AUF-Antispawnkill-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 Schießen auf Antispawnkill")
}
return

:?:/escflucht::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-Flucht-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 30 ESC-Flucht")
}
return

:?:/rotor::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Rotorkill-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 60 Rotorkill")
}
return

:?:/geklaert::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Geklärt-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 0 Geklärt mit Geschädigtem")
}
return

:?:/keinrw::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Kein-Verstoß-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/prison " . ID . " 0 Kein Regelwerkverstoß")
}
return

:?:/unbeteiligt::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Unbeteiligter-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " Unbeteiligter im Gangfight")
}
return

:?:/escgf::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Gangfight")
}
return

:?:/escpb::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Paintball")
}
return

:?:/esccp::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC im Checkpoint")
}
return

:?:/escbeamte::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC vor Beamten")
}
return

:?:/escarrest::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("ESC-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " ESC bei Arrest")
}
return

:?:/timebug::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Timebug-ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/kick " . ID . " Timebug")
}
return

:?:/abwerbe::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	ID := PlayerInput("Abwerbe-ID: ")	
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}

	SendChat("/mute " . ID . " 60 Leichte Beleidigung")
}
return

:?:/mbel::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")	
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 120 Mittlere Beleidigung")
}
return

:?:/sbel::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}

	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/warn " . name . " Schwere Beleidigung")
	SendChat("/tban " . name . " 24 Schwere Beleidigung")
}
return

:?:/umgang::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 30 Umgangston")
}
return

:?:/aabuse::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/supban " . ID . " 30 Ausnutzen des Adminchats")
}
return

:?:/adabuse::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 60 Ausnutzen der Werbefunktion")
}
return

:?:/supabuse::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/supban " . ID . " 60 Ausnutzen des Support-Systems")
}
return

:?:/spam::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 10 Spam")
}
return

:?:/caps::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 10 Caps")
}
return

:?:/prov::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
	ID := PlayerInput("ID: ")
	if (ID == "" || ID == " ") {
		return
	}
	
	if (getFullName(ID) == "") {
		SendClientMessage(prefix . "Fehler: Dieser Spieler ist nicht online.")
		return
	}
	
	SendChat("/mute " . ID . " 15 Provokation")
}
return

:?:/meldungen::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}		
	
    SendChat("/announce Du hast Fragen oder Probleme, benutze '/sup [Deine Frage]'.")
    SendChat("/announce Regelbrecher wie Hacker, Buguser können mit '/a' oder '/report' gemeldet werden!")
}
return

:?:/hacker::
{
	if (hackerFinder) {
		hackerFinder := false
		
		SetTimer, HackerFinder, Off
		
		SendClientMessage(prefix . "Du hast den Hackerfinder " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	} else {
		level := PlayerInput("Level: ")
		
		if (level == "" || level == " " || level is not number) {
			return
		}
		
		hackerFinder := true
		hackerLevel := level
		hackerID := 0
		
		SendClientMessage(prefix . "Spieler mit Level: " . csecond . level)
				
		SetTimer, HackerFinder, 1
	}
}
return

:?:/hacker2::
{
	if (!admin) {
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
		return
	}	
	
	players := 0
	title := ""
	
	Loop {
		if (A_Index > 375) {
			SendClientMessage(prefix . "Spieler mit Level 1 online: " . csecond . players)
			
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
		SendClientMessage(prefix . "Fehler: Du bist kein Team-Mitglied.")
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
		SendClientMessage(prefix . "Fehler: Der angegebene Wert ist ungültig.")
		return
	}
	
	SendClientMessage(prefix . csecond . "Enter drücken:" . COLOR_WHITE . " Globaler Chat | " . csecond . "ACM eintragen:" . COLOR_WHITE . " Eigene Anzeige")
	
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
			SendClientMessage(prefix . "|---------------------------------------------|")
		} else {
			SendChat("/" . tmp_chat . " |---------------------------------------------|")
		}
	}
	
	if (tmp_chat == "acm") {
		SendClientMessage(prefix . "Informationen zum Level: " . csecond . FormatNumber(tmp_lvl) . COLOR_WHITE . ".")
	} else {
		SendChat("/" . tmp_chat . " Informationen zum Level " . FormatNumber(tmp_lvl) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendClientMessage(prefix . "Spielstunden mit Premium: " . csecond . FormatNumber(round(tmp / 2, 0)) . COLOR_WHITE . ".")
	} else {
		SendChat("/" . tmp_chat . " Spielstunden mit Premium: " . FormatNumber(Round(tmp / 2, 0)) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendClientMessage(prefix . "Spielstunden ohne Premium: " . csecond . FormatNumber(tmp) . COLOR_WHITE . ".")
	} else {
		SendChat("/" . tmp_chat . " Spielstunden ohne Premium: " . FormatNumber(tmp) . ".")
	}
	
	if (!admin && tmp_chat != "acm")
		sleep, 400
	
	if (tmp_chat == "acm") {	
		SendClientMessage(prefix . "Benötigte Respektpunkte zum nächsten Level: " . csecond . FormatNumber(8 + (tmp_level - 1) * 4) . COLOR_WHITE . ".")
	} else {
		SendChat("/" . tmp_chat . " Benötigte Respektpunkte zum nächsten Level: " . FormatNumber(8 + (tmp_lvl - 1) * 4) . ".")
	}
	
	if (admin && tmp_chat != "acm") {
		if (tmp_chat == "acm") {
			SendClientMessage(prefix . "|---------------------------------------------|")
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
			
			SendClientMessage(prefix . "Der Hackerfinder wurde " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
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
			SendClientMessage(prefix . csecond . getFullname(hackerID) . COLOR_WHITE . " (ID: " . csecond . hackerID . COLOR_WHITE . ") - Level: " . csecond getPlayerScoreById(hackerID))
		}
	}
	
	hackerID++
}
return

SyncTimer:
{	
	SendClientMessage(prefix . "Das Synchroniseren von Fischen, Paket, Drogen und Lagerfeuer hat begonnen!")
	SendClientMessage(prefix . "Drücke bitte in den nächsten 4 Sekunden keine Keys und schreibe nichts im Chat!")
	
	checkCooked()
	getFirstAid(0)
	
	Sleep, 1500
	
	getDrugs(0)
	getCampfire(0)
	
	SendClientMessage(prefix . "Das Synchronisieren ist " . COLOR_GREEN . "abgeschlossen" . COLOR_WHITE . ".")
}
return

TempoTimer:
{
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
	if ((IsPlayerInRangeOfPoint(2341.6477, -2028.5807, 13.5331, 4) || IsPlayerInRangeOfPoint(2322.9871, -1995.6251, 21.1276, 4)) && (getUserName() == "jacob.tremblay" || getUserName() == "Jaden." || getUserName() == "Manu")) {
		
		toRemove := []
		
		for index, arrestName in arrestList {
			toRemove.Push(index)
			
			suspectID := getPlayerIdByName(getFullName(arrestName), true)
			
			if (suspectID != -1) {
				SendChat("/arrest " . arrestName)
			}
		}
		
		for i, id in toRemove {
			arrestList.RemoveAt(id)
		}	
	}
}
return

ResetChatBlock:
{
	if (BlockChat == 1) {
		BlockChat := 0
	}
	
	SetTimer, ResetChatBlock, off
}
return

SecondTimer:
{
	IniRead, fishcooldown, settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, settings.ini, Cooldown, pakcooldown, 0
	IniRead, commitmentUnix, settings.ini, UnixTime, commitmentUnix, 0
	IniRead, commitmentTime, settings.ini, UnixTime, commitmentTime, 0
		
	if (fishcooldown > 0) {
		fishcooldown --
		
		if (fishcooldown == 600 || fishcooldown == 300 || fishcooldown == 120 || fishcooldown == 60) {
			SendClientMessage(prefix . "Du kannst in " . cSecond . formatTime(fishcooldown) . COLOR_WHITE . " wieder angeln.")
		} else if (fishcooldown == 0) {
			if (!WinActive("GTA:SA:MP")) {
				MsgBox, 64, Fischen, Du kannst nun wieder fischen
			}
		
			SoundBeep
			SendClientMessage(prefix . "Du kannst nun wieder angeln.")
		}
		
		iniWrite, %fishcooldown%, settings.ini, Cooldown, fishcooldown
	}
	
	if (pakcooldown > 0) {
		pakcooldown --
		
		if (pakcooldown == 300 || pakcooldown == 120 || pakcooldown == 60) {
			SendClientMessage(prefix . "Du kannst in " . cSecond . formatTime(pakcooldown) . COLOR_WHITE . " wieder ein Erste-Hilfe-Paket nutzen.")
		} else if (pakcooldown == 0) {
			SoundBeep 
			SendClientMessage(prefix . "Du kannst nun wieder ein Erste-Hilfe-Paket nutzen.")
		}
		
		iniWrite, %pakcooldown%, settings.ini, Coodlwon, pakcooldown
	}
	
	if (healcooldown > 0) {
		healcooldown --
		
		if (healcooldown == 30 || healcooldown == 10) {
			SendClientMessage(prefix . "Du kannst dich in " . cSecond . healcooldown . COLOR_WHITE . " wieder heilen.")
		} else if (healcooldown == 0) {
			SoundBeep
			SendClientMessage(prefix . "Du kannst dich nun wieder heilen.")
		}
	}
	
	if (drugcooldown > 0) {
		drugcooldown --
		
		if (drugcooldown == 15 || drugcooldown == 5) {
			SendClientMessage(prefix . "Du kannst in " . cSecond . drugcooldown . COLOR_WHITE . " wieder Drogen konsumieren.")
		} else if (drugcooldown == 0) {
			SoundBeep 
			SendClientMessage(prefix . "Du kannst nun wieder Drogen konsumieren.")
		}
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
		
		IniWrite, %commitmentTime%, settings.ini, UnixTime, commitmentTime
		IniWrite, %commitmentUnix%, settings.ini, UnixTime, commitmentUnix	
	}
	
	
	if (drugTime > 0) {
		drugTime --
		
		if (drugTime == 0) {
			SendClientMessage(prefix . "Du kannst nun wieder Drogen nehmen.")
		}
	}
	
	if (oldLocalTime > 0) {
		oldLocalTime --
		
		oldLocal := ""
	}
	
	if (oldFriskTime > 0) {
		oldFriskTime --
		
		oldFrisk := ""
	}	
}
return

CloseZollTimer:
{
	if (closeZoll != "") {
		if (closeZoll > 0 && closeZoll < 14) {
			SendClientMessage(prefix . "Möchtest du Zoll " . csecond . closeZoll . COLOR_WHITE . " schließen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
				
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
	if (openZoll != "") {
		if (openZoll > 0 && openZoll < 14) {
			SendClientMessage(prefix . "Möchtest du Zoll " . csecond . openZoll . COLOR_WHITE . " öffnen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
				
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
	SendClientMessage(prefix . "Möchtest du einen Kanister nutzen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")

	KeyWait, X, D, T10
	
	if (!ErrorLevel && !isBlocked()) {
		SendChat("/fillcar")
	}	
	
	SetTimer, RefillTimer, off
}
return

RequestTimer:
{
	if (requestName != "") {
		if (RegExMatch(GetLabelText(), "\[(\S+)\] (\S+)\nWantedlevel: (\S+)\nGrund: (.+)", label_)) {
			if (requestName == label_2) {
				if (label_3 > 4) {
					if (oldRequest != requestName) {
						oldRequest := requestName

						SendChat("/l Tut mir leid " . requestName . ", jedoch sind nur Tickets bis zu 4 Wanteds, und nicht bis " . label_3 . " möglich.")
					}
				} else {
					SendClientMessage(prefix . "Möchtest du " . csecond . requestName . COLOR_WHITE . " ein Ticket geben? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
				
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

TimeoutTimer:
{
	if (!fillTimeout) {
		fillTimeout ++
	
		if (fillTimeout >= 9) {
			fillTimeout_ := true
		}
	}
	
	if (!canisterTimeout) {
		canisterTimeout ++
		
		if (canisterTimeout >= 9) {
			canisterTimeout_ := true
		}
	}
	
	if (!mautTimeout) {
		mautTimeout ++
		
		if (mautTimeout >= 9) {
			mautTimeout_ := true
		}
	}
	
	if (!healTimeout_) {
		healTimeout ++
		
		if (healTimeout >= 9) {
			healTimeout_ := true
		}
	}
	
	if (!cookTimeout_) {
		cookTimeout ++
		
		if (cookTimeout >= 9) {
			cookTimeout_ := true
		}
	}
	
	if (!equipTimeout_) {
		equipTimeout ++
		
		if (equipTimeout >= 9) {
			equipTimeout_ := true
		}
	}
	
	if (!jailgateTimeout_) {
		jailgateTimeout ++
		
		if (jailgateTimeout >= 2) {
			jailgateTimeout_ := true 
		}
	}
	
	if (!gateTimeout_) {
		gateTimeout ++
		
		if (gateTimeout >= 3) {
			gateTimeout_ := true
		}
	}
	
	if (!fishTimeout_) {
		fishTimeout ++
		
		if (fishTimeout >= 9) {
			fishTimeout_ := true
		}
	}
	
	if (!localTimeout_) {
		localTimeout ++
		
		if (localTimeout >= 9) {
			localTimeout_ := true
		}
	}
}
return

TankTimer:
{
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
					
					SendClientMessage(prefix . cSecond . "WARNUNG: Dein Tank ist fast leer, es befinde" . (tank_1 == 1 ? "t" : "n") . " sich nur noch " . tank_1 . " Liter darin.")
					oldTank := Ceil(tank_1)
					break
				} else if (!tank_1) {
					SoundBeep
				
					SendClientMessage(prefix . "WARNUNG: Dein Tank ist leer, du kannst mit '" . cSecond . "X" . COLOR_WHITE . "' einen Kanister nutzen.")
					
					KeyWait, X, D, T10
					
					if (!ErrorLevel && !isBlocked()) {
						SendChat("/fillcar")
					}
				}
			}
		}
	}
}
return

ChatTimer:
{
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

WantedTimer:
{
	IniRead, wantedAlarm, settings.ini, Einstellungen, WantedAlarm, 1

	if (wantedAlarm) {
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

		if (RegExMatch(getLabelText(), "\[(\S+)\] (\S+)\nWantedlevel: (\S+)\nGrund: (.+)", label_)) {
		
			for index, entry in wantedPlayers {
				if (entry["name"] == label_2) {
					if (entry["countdown"] > 0) {
						return
					}
				}
			}
				
			if (label_3 < 5) {
				colorW := COLOR_YELLOW
			} else if (label_3 < 10 && label_3 > 4) {
				colorW := COLOR_ORANGE
			} else if (label_3 >= 10) {
				colorW := COLOR_WANTED
			}
			
			SendClientMessage(prefix . colorW . "Verdächtiger " . label_2 . " (ID: " . getPlayerIdByName(label_2) . ") mit " . label_3 . " Wanteds gesichtet!")

			wantedInfo := []
			wantedInfo["name"] := label_2
			wantedInfo["countdown"] := 300

			wantedPlayers.Push(wantedInfo)
		}
	} else {
		SetTimer, WantedTimer, off
	}
}
return

SpamTimer:
{		
	unBlockChatInput()
	SendClientMessage(prefix . "Das Antispam System wurde " . COLOR_RED . "deaktiviert" . COLOR_WHITE . ".")
	
	SetTimer, SpamTimer, off
}
return

TargetTimer:
{
	if (target != "" && targetid != -1) {
		SendClientMessage(prefix . "Möchtest du den Spieler suchen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
	
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
	if (wantedIA != -1 && wantedIAReason != "" && wantedContracter != -1) {
		SendClientMessage(prefix . "Möchtest du dem Spieler Wanteds geben? Du kannst mit '" . cSecond . "X" . COLOR_WHITE . "' bestätigen.")
		
		KeyWait, X, D, T10
		
		if (!ErrorLevel) {
			if (InStr(wantedIAReason, "entführt mich")) {
				giveWanteds(wantedIA, "Entführung eines Staatsbeamten (" . wantedContracter . ")", 4)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Entführng eingetragen!")
			} else if (InStr(wantedIAReason, "begeht eine Verweigerung")) {
				giveWanteds(wantedIA, "Verweigerung i.A. " . wantedContracter, 1)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Verweigerung eingetragen!")
			} else if (InStr(wantedIAReason, "versuchte mich zu bestechen")) {
				giveWanteds(wantedIA, "Beamtenbestechung i.A. " . wantedContracter, 1)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Beamtenbestechung eingetragen!")
			} else if (InStr(wantedIAReason, "verwendet seine Schlag/Schusswaffen")) {
				giveWanteds(wantedIA, "Waffengebrauch i.d.Ö. i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Waffengebrauch i.d.Ö. eingetragen!")
			} else if (InStr(wantedIAReason, "ist nicht im Besitz eines Waffenschein")) {
				giveWanteds(wantedIA, "Illegaler Waffenbesitz i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " illegaler Waffenbesitz eingetragen!")
			} else if (InStr(wantedIAReason, "hat ein Unbrechtigtes Fahrzeug/Gelände")) {
				giveWanteds(wantedIA, "Unautorisiertes Betreten i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Einbruch eingetragen!")
			} else if (InStr(wantedIAReason, "Behindert die Justiz")) {
				giveWanteds(wantedIA, "Behinderung der Justiz i.A. " . wantedContracter, 1)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Behinderung der Justiz eingetragen!")
			} else if (InStr(wantedIAReason, "begeht einen Angriff / Beschuss")) {
				giveWanteds(wantedIA, "Angriff/Beschuss i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Angriff/Beschuss eingetragen!")
			} else if (InStr(wantedIAReason, "Materialien")) {
				giveWanteds(wantedIA, "Besitz von Materialien i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Besitz von Materialien eingetragen!")
			} else if (InStr(wantedIAReason, "Drogen")) {
				giveWanteds(wantedIA, "Besitz von Drogen i.A. " . wantedContracter, 2)
				SendChat("/d HQ: Habe den Auftrag ausgeführt und " . getFullName(wantedIA) . " Besitz von Drogen eingetragen!")
			}
		}
	}
	
	SetTimer, WantedIATimer, off
}
return

HelloTimer:
{
	if (loginName != -1) {
		SendClientMessage(prefix . "Möchtest du " . csecond . loginName . COLOR_WHITE . " begrüßen? Du kannst mit '" . cSecond . "X" . COLOR_WHITE . "' bestätigen.")
		
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
	SendClientMessage(prefix . csecond . medicName . COLOR_WHITE . " bietet dir ein Paket an, drücke '" . csecond . "X" . COLOR_WHITE . "' zum Annehmen.")
	
	KeyWait, X, D, T10
	
	if (!ErrorLevel) {
		SendChat("/accept paket")
		
		Sleep, 200
		
		if (RegExMatch(readChatLine(0) . readChatLine(1) . readChatLine(2), "Du hast bereits ein Erste-Hilfe-Paket\. Verwende \/erstehilfe")) {
			if (packetMessages) {
				SendChat("/l Vielen Dank " . medicName . ", doch ich habe bereits ein Paket!")
			}
		} else if (RegExMatch(readChatLine(0) . readChatLine(1) . readChatLine(2), "\* Du hast für \$(\d+) ein Erste-Hilfe-Paket von (\S+) gekauft\.", chat_)) {
			if (packetMessages) {
				SendChat("/l Vielen Dank " . chat_2 . " für das Erste-Hilfe-Paket!")
			}
		}
	}
	
	SetTimer, PaketTimer, off
}
return

PartnerMoneyTimer:
{
	payPartnerMoney(numberFormat(totalArrestMoney), "arrest_money")
	
	totalArrestMoney := 0
	
	SetTimer, PartnerMoneyTimer, off
}
return

ShotAllowedCar:
{
	if (warningMessages) {
		SendClientMessage(prefix . "Du darfst nun das Fahrzeug beschießen, sofern der Spieler flüchtet.")
	}
	
	SetTimer, ShotAllowedCar, off
}
return

TazerAllowed: 
{
	if (warningMessages) {
		SendClientMessage(prefix . "Du darfst den Verbrecher nun Tazern " . csecond . "(Ausnahme: Kampfsituation)")
	}
	
	SetTimer, TazerAllowed, off
}
return

MainTimer:
{	
	if (!isConnected() || !WinExist("GTA:SA:MP")) {
		return
	}
	
	WinGetTitle, spotifytrack, ahk_exe Spotify.exe
		
	if (oldSpotifyTrack != spotifytrack && spotifytrack != "") {
		oldSpotifyTrack := spotifytrack
		
		SendClientMessage(prefix . "Neuer Spotify-Track: " . COLOR_GREEN . spotifytrack)
		
		if (spotifymessage) {
			SendChat("/l Spotify-Track wurde gewechselt: " . spotifytrack)
		}
	}	
	
	if (isPlayerInAnyVehicle()) {
		if (oldVehicleName != getVehicleModelName()) {
			oldVehicleName := getVehicleModelName()
		}
	} 
	
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
					afkColor := COLOR_YELLOW
				} else if ((IsAFKEnd - IsAFKStart) >= 300 && (IsAFKEnd - IsAFKStart) < 1800) {
					afkColor := COLOR_ORANGE
				} else if ((IsAFKEnd - IsAFKStart) >= 1800) {
					afkColor := COLOR_RED
				}
				
				SendClientMessage(prefix . afkColor . "AFK-Zeit: " . formatTime(IsAFKEnd - IsAFKStart))
				
				IsAFKStart := 0
				IsAFKEnd := 0
			}
		}
	}	
	
	IniRead, Killstreak, Stats.ini, Stats, Killstreak, 0	
	IniRead, Kills, Stats.ini, Stats, Kills, 0
	IniRead, Deaths, Stats.ini, Stats, Deaths, 0
	IniRead, DKills, Stats.ini, Stats, DKills[%A_DD%:%A_MM%:%A_YYYY%], 0
	IniRead, DDeaths, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%], 0	
	
	data := getKills()
	
	if (data && !isPaintball) {
		for index, object in data {
			if (object.victim.local) {
				chat0 := readChatLine(0)
				chat1 := readChatLine(1)
				chat2 := readChatLine(2)
				chat3 := readChatLine(3)
				chat4 := readChatLine(4)
				chat := chat0 . chat1 . chat2 . chat3 . chat4
				
				if (InStr(chat, "Paintball:")) {
					return
				}
				
				if (InStr(chat, "[KillHouse]")) {
					return
				}
				
				hasEquip := 0
				
				killName := object.murderer.name
                killFaction := getSkinFraction(object.skin)
                killWeapon := getWeaponName(object.weapon)
				killWeaponShort := weaponShort(object.weapon)
				
				if (bk) {
					
					if (getFullName(killName)) {
						SendChat("/d HQ: Ich wurde von " . killName . " in " . getLocation() . " mit " . killWeaponShort . " " . killWeapon . " getötet.")
					} else {
						SendChat("/d HQ: Ich wurde in " . getLocation() . " mit " . killWeaponShort)
					}
					SendChat("/d HQ: Verstärkung wird NICHT mehr benötigt!")
					
					bk := 0
				} else {
					if (getFullName(killName)) {
						killerID := getPlayerIdByName(killName)
						ped := getPedById(killerID)
						pedCoord := getPedCoordinates(ped)
						
						if (getDistanceToPoint(getCoordinates()[1], getCoordinates()[2], getCoordinates()[3], pedCoord[1], pedCoord[2], pedCoord[3]) <= 30) {
							SendChat("/f Ich wurde von " . killName . " in " . getLocation() . " mit " . killWeaponShort . " " . killWeapon . " getötet.")
						} else {
							SendChat("/f Ich wurde in " . getLocation() . " mit " . killWeaponShort . " " . killWeapon . " getötet.")
						}
					}
				}
				
				SLeep, 200
				
				Deaths ++
				DDeaths ++
				IniWrite, %Deaths%, Stats.ini, Stats, Deaths
				IniWrite, %DDeaths%, Stats.ini, Stats, DDeaths[%A_DD%:%A_MM%:%A_YYYY%]
				
				SendClientMessage(Prefix . "Das war dein Tot Nr. " . cSecond . FormatNumber(Deaths) . COLOR_WHITE . ".")
				SendClientMessage(Prefix . "{FF8200}Tagesstatistik" . COLOR_WHITE . " Tode: " . cSecond . DDeaths . COLOR_WHITE . " Kills: " . cSecond . DKills . COLOR_WHITE . " Tages-KD: " . cSecond . Round(DKills / DDeaths, 3))
				
				if (Streak > 0) {
					Streak := 0
					SendClientMessage(Prefix . "Aufgrund deines Todes, wurde deine Killstreak zurückgesetzt.")
				}
				
				Sleep, 5500
			} else if (object.murderer.local) {
				chat0 := readChatLine(0)
				chat1 := readChatLine(1)
				chat2 := readChatLine(2)
				chat3 := readChatLine(3)
				chat4 := readChatLine(4)
				chat := chat0 . chat1 . chat2 . chat3 . chat4
				
				if (InStr(chat, "Paintball:")) {
					return
				}
				
				if (InStr(chat, "[KillHouse]")) {
					return
				}				
			
				killName := object.victim.name
                killFaction := getSkinFraction(object.skin)
                killWeapon := getWeaponName(object.weapon)
				killWeaponShort := weaponShort(object.weapon)
			
				Kills ++
				DKills ++
				
				IniWrite, %Kills%, Stats.ini, Stats, Kills
				IniWrite, %DKills%, Stats.ini, Stats,  DKills[%A_DD%:%A_MM%:%A_YYYY%]
				
				Streak ++

				SendChat("/f Ich habe " . killName . " (" . killFaction . ") in " . getLocation() . " mit " . killWeaponShort . " " . killWeapon . " getötet!")

				if (leagueSound) {
					if (Streak == 2) {
						SendChat("/f DOUBLE KILL!")
						SoundPlay, %A_ScriptDir%/sounds/double.mp3
					} else if (Streak == 3) {
						SendChat("/f TRIPLE KILL!")
						SoundPlay, %A_ScriptDir%/sounds/triple.mp3
					} else if (Streak == 4) {
						SendChat("/f QUADRA KILL!")
						SoundPlay, %A_ScriptDir%/sounds/quadra.mp3
					} else if (Streak == 5) {
						SendChat("/f PENTA KILL!")
						SoundPlay, %A_ScriptDir%/sounds/penta.mp3
					} else if (Streak == 6) {
						SendChat("/f HEXA KILL!")
						SoundPlay, %A_ScriptDir%/sounds/hexa.mp3
					}
				}
				
				SLeep, 200

				SendClientMessage(Prefix . "Das war dein Kill Nr. " . cSecond . FormatNumber(Kills) . COLOR_WHITE . ".")
				SendClientMessage(Prefix . "{FF8200}Tagesstatistik" . COLOR_WHITE . " Kills: " . cSecond . DKills . COLOR_WHITE . " Tode: " . cSecond . DDeaths . COLOR_WHITE . " Tages-KD: " . cSecond . Round(DKills / DDeaths, 3))
				
				IniRead, Killstreak, Stats.ini, Stats, Killstreak, 0
				
				if (Streak > Killstreak) {
					IniWrite, %Streak%, Stats.ini, Stats, Killstreak
					SendClientMessage(Prefix . "Du hast einen neuen Killstreak-Rekord von " . cSecond . Streak . COLOR_WHITE . ".")
				}
				
				Sleep, 5500
			}
		}
	}
	
	if (showDamageInfo) {
		if (getPlayerHealth() != healthOld) {
			damage := healthOld - getPlayerHealth()
			
			healthOld := getPlayerHealth() 
			
			if (damage > 5 && !isPaintball) {
				SendClientMessage(prefix . "Du hast " . cSecond . damage . COLOR_WHITE . " HP verloren (Waffe: " . cRed getDamageWeapon(damage) . COLOR_WHITE . "), HP über: " . cGreen . getPlayerHealth())
			}
		}	
	}
	
	if (isPlayerOnGasStation() && autoFill) {
		if (fillTimeout_) {
			if (isPlayerInAnyVehicle() && isPlayerDriver()) {
				SendClientMessage(prefix . "Möchtest du dein Fahrzeug betanken? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
				
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
		
		if (canisterTimeout_) {
			if (!isPlayerInAnyVehicle()) {
				SendClientMessage(prefix . "Möchtest du dir einen Kanister kaufen? Du kanst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
			
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
	} else if (isPlayerOnMaut() && autoCustoms) {
		if (mautTimeout_) {
			SendClientMessage(prefix . "Möchtest du den Zoll öffnen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
				
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				mautTimeout_ := false
				openMaut()
				mautTimeout := 0
			} else {
				mautTimeout_ := true
			}
		}
	} else if (isPlayerOnHeal() && autoHeal) {
		if (healTimeout_) {
			if (getPlayerHealth() < 100 || getPlayerArmor() < 100) {
				SendClientMessage(prefix . "Möchtest du dich heilen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
				
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
	} else if (isOnCookPoint()) {
		if (cookSystem) {
			if (cookTimeout_) {
				SendClientMessage(prefix . "Möchtest du deine Fische kochen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
				
				KeyWait, X, D, T10
				
				if (!ErrorLevel && !isBlocked()) {
					cookTimeout_ := false
				
					Loop, 5 {
						SendChat("/cook fish " . A_Index)
						
						if (!admin || comhelper) {
							Sleep, 500
						}
					}	
					
					checkCooked()
					
					cookTimeout := 0
				} else {
					cookTimeout_ := true
				}
			}
		}
	} else if (isPlayerOnLocal() && autoLocal) {
		if (localTimeout_) {
			SendClientMessage(prefix . "Möchtest du die Kette einnehmen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
			
			KeyWait, X, D, T10
			
			if (!ErrorLevel && !isBlocked()) {
				localTimeout_ := false
				addLocalToStats()
				localTimeout := 0
			} else {
				localTimeout_ := true
			}
		}
	} else if (isPlayerOnEquip()) {
		if (!hasEquip) {
			if (equipTimeout_) {
				SendClientMessage(prefix . "Möchtest du dich ausrüsten? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
				
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
					SendClientMessage(prefix . "Möchtest du dich heilen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen!")
					
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
	} else if (isPlayerOnJailGate()) {
		if (jailgateTimeout_) {
			SendClientMessage(prefix . "Möchtest du ins Staatsgefängnis? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
			
			KeyWait, X, D, T10
				
			if (!ErrorLevel && !isBlocked()) {
				jailgateTimeout_ := false
				SendChat("/auf")
				jailgateTimeout := 0
			} else {
				jailgateTimeout_ := true
			}
		}
	} else if (isPlayerOnPDGate()) {
		if (gateTimeout_) {
			if (!getPlayerInteriorId()) {
				SendClientMessage(prefix . "Möchtest du das Tor öffnen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
				
				KeyWait, X, D, T10
					
				if (!ErrorLevel && !isBlocked()) {
					gateTimeout_ := false
					SendChat("/auf")
					gateTimeout := 0
				} else {
					gateTimeout_ := true
				}
			}
		}
	} else if (isPlayerOnFishPoint()) {
		if (fishTimeout_) {
			SendClientMessage(prefix . "Möchtest du fischen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
				
			KeyWait, X, D, T10
			
			if (!ErrorLevel && !isBlocked()) {
				timeout := false
				startFish()
				fishTimeout := 0
			} else {
				fishTimeout_ := true
			}
		}
	}
}
return

UncuffTimer:
{
	if (autoUncuff) {
		if (IsPlayerInAnyVehicle()) {
			if (IsPlayerDriver()) {
				if (getVehicleHealth() < 250) {
					SendClientMessage(prefix . "Möchtest du alle Personen im Fahrzeug entcuffen? Drücke '" . csecond . "X" . COLOR_WHITE . "' zum Bestätigen.")
					
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

ChatlogSaveTimer:
{	
	if (chatlogSaver) {
		WinWait, GTA:SA:MP, , 1
		
		if (ErrorLevel) {
			return
		}
		
		WinWaitClose, GTA:SA:MP, , 1
		
		if (ErrorLevel) {
			return
		}
		
		FileCreateDir, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups
		FormatTime, time, %A_Now%, dd.MM.yy - HH.mm
		FileCopy, %A_MyDocuments%\GTA San Andreas User Files\SAMP\chatlog.txt, %A_MyDocuments%\GTA San Andreas User Files\SAMP\ChatlogBackups\chatlog %time% Uhr.txt, 0
		
		TrayTip, %projectName%, Chatlog wurde abgespeichert!
	} else {
		SetTimer, ChatlogSaveTimer, off
	}
}
return

LottoTimer:
{
	if (autoLotto) {
		if (A_Min == 0 && A_Hour != oldHour) {
			SendChat("/lotto")
			
			SendClientMessage(prefix . "Möchtest du dir ein Lottoticket kaufen? Du kannst mit '" . csecond . "X" . COLOR_WHITE . "' bestätigen.")
			
			oldHour := A_Hour
			
			KeyWait, X, D, T10
			
			if (!ErrorLevel && !isInChat() && !IsDialogOpen() && !IsPlayerInMenu()) {
				if (lottoNumber == 0) {
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
}
return

AutoFindTimer:
{
	if (!WinActive("GTA:SA:MP")) {
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
	
	Sleep, 200
	
	adrGTA2 := getModuleBaseAddress("gta_sa.exe", hGTA)
	cText := readString(hGTA, adrGTA2 + 0x7AAD43, 512)
	
	if (InStr(cText, "Handy aus")) {
		return
	}
	
	if (getDistanceBetween(CoordsFromRedmarker()[1], CoordsFromRedmarker()[2], CoordsFromRedmarker()[3], 1163.2358, -1323.2552, 15.3945, 5)) {
		SendClientMessage(prefix . getFullName(playerToFind) . " befindet sich im " . COLOR_RED . "Krankenhaus" . COLOR_WHITE . ".")
	}
}
return

CountdownTimer:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (cdTime == 0) {
		SendChat("/" . cdChat . " " . cdGoMessage)
		SetTimer, CountdownTimer, Off
		
		countdownRunning := 0
		
		if (cdGoMessage == "Letzte Warnung!") {
			Sleep, 3000
			SendClientMessage(prefix . "Freigabe erhalten.")
		}
		
		return
	}
	
	SendChat("/" . cdChat . " << " . cdTime . " >>")
	
	cdTime--
}
return

TicketTimer:
{
	chat := readChatLine(0)
	
	if (chat == oldchat) {
		return
	} else {
		oldchat := chat
	}
	
	if (RegExMatch(chat, "\(\( Ticket (\d+) (\S+): (.*) \)\)", var)) {
		addStr(var1, var2, var3)
	} else if (RegExMatch(chat, "\.\.\.(.*) \)\)", var)) {
		chat_ := readChatLine(1)
		
		if (RegExMatch(chat_, "\(\( Ticket (\d+) (\S+): (.*)\.\.\.", var_)) {
			addStr(var_1, var_2, var_3)
			addStr(var_1, var_2, var1)
		}
	} else if (RegExMatch(chat, "Du hast das Ticket von (\S+) (.+).", var)) {
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
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (!admin || comhelper) {
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

UpdateOverlay:
{
	if (!WinActive("GTA:SA:MP")) {
		return
	}
	
	if (keybinderVersion == "nooverlay" || overlayOn == false) {
		SetTimer, UpdateOverlay, off
		return
	}
	
	index := 0
	reading := false
	str := ""
	
	Loop, parse, sup_text_%numID%, `n, `r
	{
		if (page == 1) {
			reading := true
		} else if (A_Index == (page - 1) * 14 + 1) {
			reading := true
		}
		
		if (reading) {
			index ++
			str := str . A_LoopField . "`n"
			
			if (index == 14) {
				break
			}
		}
	}
	
	TextSetString(sup_text, str)
	
	if (numID < 10) {
		numStr := "0" . numID
	} else {
		numStr := numID
	}
	
	TextSetString(sup_heading, "--- --- --- --- --- --- --- --- --- --- --- --- --- ---     Ticket #" . numStr . "     --- --- --- --- --- --- --- --- --- --- --- --- --- ---")
	
	if (page < 10) {
		zeileStr := "0" . page
	} else {
		zeileStr := page
	}
	
	TextSetString(sup_page, "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --    Seite " . zeileStr . "  -- --- --- --- --- --- --- --- --- --- --- --- --- --- ---")
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
	
	SendClientMessage(prefix . "Die Suche nach " . player . " (ID: " . playerID . ") wurde gestartet.")
	if (playerScore <= 5) {
		SendClientMessage(prefix . "Level: " . COLOR_RED . playerScore)
	} else {
		SendClientMessage(prefix . "Level: " . COLOR_GREEN . playerScore)
	}
		
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

addStr(id, name, inhalt) {
	overlayfs := "FF8000"
	overlayfa := "0099FF"
	
	StringReplace, inhalt, inhalt, ä, ae, All
	StringReplace, inhalt, inhalt, ö, oe, All
	StringReplace, inhalt, inhalt, ü, ue, All
	StringReplace, inhalt, inhalt, ß, ss, All
	
	if (name == getUsername()) {
		name := "{" . overlayfs . "}" . getUsername()
	} else {
		sup_name_%id% := name
		name := "{" . overlayfa . "}" . name
	}
	
	sup_text_%id% := sup_text_%id% . name . COLOR_WHITE . ": " . inhalt . "`n"
	
	global numID := id
	
	Loop, parse, sup_text_%numID%, `n, `r
	{
		index := A_Index
	}
	
	global page := Floor((index - 1) / 14) + 1
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
		
		str_speichern := RegExReplace(sup_text_%ticketID%, "{(\S{6})}")
		
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
		
		str_path := "Ticket Nr. " . str_ticketID . " - " . sup_name_%ticketID% . " - " . A_DD . "." . A_MM . "." . A_YYYY . " " . A_Hour . "." . A_Min . "." . A_Sec . " Uhr.txt"
		
		FileAppend, %str_speichern%, Tickets\%str_path%
		
		SendClientMessage(prefix . "Tickets bearbeitet: " . cSecond . formatNumber(gestickets) . COLOR_WHITE . " | Heute: " . cSecond . daytickets . COLOR_WHITE . " | Monat: " . cSecond . formatNumber(monthtickets))
				
		sup_text_%ticketID% := ""
		sup_zeilen_%ticketID% := 0
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
			SendClientMessage(prefix . "Das automatische Suchen wurde beendet.")
		}
	}
}

/*
useHeals() {
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP") || !isConnected()) {
		return
	}
	
	IniRead, bossmode, settings.ini, settings, bossmode, 1
	IniRead, drugs, settings.ini, Items, drugs, 0
	IniRead, firstaid, settings.ini, Items, firstaid, 0
	
	if (GetPlayerHealth() < 55 && bossmode) {
		Settimer, autoUseTimer, off
		
		if (firstaid) {
			SendChat("/erstehilfe")
		}
	
		if (currentFish <= 0){
			currentFish := getFishHP()
			
			if (currentFish <= 0) {
				return
			}
		}
		
		i := currentFish
		loopCount := 6 - currentFish
		
		Loop, %loopCount% {
			if (getPlayerHealth() < 100) {
				SendChat("/eat " . i)
				i ++
				
				sleep, 750
			} else {
				if (i < 6) {
					Settimer, autoUseTimer, 2500
					return
				}
			}
		}
	}

	Settimer, reactivateAutoUse, -60000
}
*/
checkRank() {
	global
	
	iniRead, rank, settings.ini, settings, rank, 0
	
	if (!rank || rank == "" || rank == "ERROR") {
		SendClientMessage(prefix . "Du musst deinen genauen Rang eintragen, um alle Funktionen nutzen zukönnen.")
		SendClientMessage(prefix . "Verwende hierfür '" . cSecond . "/setrang" . COLOR_WHITE . "' als Befehl.")
		return 0
	} else {
		return 1
	}
}

getRank() {
	global
	
	iniRead, rank, settings.ini, settings, rank, 0
	return rank
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
	IniRead, fishcooldown, settings.ini, Cooldown, fishcooldown, 0
	IniRead, pakcooldown, settings.ini, Cooldown, pakcooldown, 0
	
	line := StrReplace(line, "[name]", getUsername())
	line := StrReplace(line, "[id]", getId())
	line := StrReplace(line, "[ping]", getPlayerPingById(getId()))
	line := StrReplace(line, "[fps]", getPlayerFps())
	line := StrReplace(line, "[zone]", getPlayerZone())
	line := StrReplace(line, "[city]", getPlayerCity())
	line := StrReplace(line, "[location]", getLocation())
	line := StrReplace(line, "[hp]", getPlayerHealth())
	line := StrReplace(line, "[armour]", getPlayerArmor())
	line := StrReplace(line, "[money]", FormatNumber(getPlayerMoney()))
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
			SendClientMessage(prefix . line)
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
	suspect := getFullName(suspect)
		
	FormatTime, time, , HH:mm
	
	Loop %amount% {
		SendChat("/suspect " . suspect . " " . reason . " - Uhr: " . time)
	}
	
	Sleep, 200
	
	suspectLine0 := readChatLine(0)
	suspectLine1 := readChatLine(1)
	
	if (InStr(suspectLine0 . suspectLine1, "Du kannst Beamte keine Wanteds eintrragen.") || InStr(suspectLine0 . suspectLine1, "Der Spieler befindet sich im Gefängnis.")) {
		return false
	}
	

	IniRead, wanteds, stats.ini, Vergaben, wanteds, 0
	wanteds += amount
	IniWrite, %wanteds%, stats.ini, Vergaben, Wanteds
	
	SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(wanteds) . COLOR_WHITE . " Wanteds vergeben.")	
	return true
}

givePoints(suspect, reason, amount, extra := "") {
	global
	
	suspect := getFullName(suspect)

	SendChat("/punkte " . suspect . " " . amount . " " . reason . extra)
	
	Sleep, 200
	
	pointsLine0 := readChatLine(0)
	pointsLine1 := readChatLine(1)
	
	if (InStr(pointsLine0 . pointsLine1, "Du kannst dir keine Punkte geben.")) {
		return false
	}
	
	IniRead, points, stats.ini, Vergaben, points, 0	
	points += amount
	IniWrite, %points%, stats.ini, Vergaben, Points
	
	SendClientMessage(prefix . "Du hast bereits " . csecond . formatNumber(points) . COLOR_WHITE . " Punkte vergeben.")	
	return true
}

giveTicket(player, money, reason) {
	global
	
	if (lastTicketReason == reason && lastTicketPlayer == player) {
		currentTicket++
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
		
		SendClientMessage(prefix . "Für das nächste Ticket, Verwende: " . cSecond . "/nt")
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
	global
	
	partnerStake := Round(money / (partners.Length() + 1), 0)
	
	IniRead, statMoney, stats.ini, Verhaftungen, Money, 0
	statMoney += partnerStake
	
	if (stat == "arrest_money") {
		IniWrite, %statMoney%, stats.ini, Verhaftungen, Money
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(statMoney) . "$" . COLOR_WHITE . " durch Verhaftungen verdient.")
	} else if (stat == "ticket_money") {
		IniWrite, %statMoney%, stats.ini, Tickets, Money
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(statMoney) . "$" . COLOR_WHITE . " durch Tickets verdient.")
	} else if (stat == "plants_money") {
		IniWrite, %statMoney%, stats.ini, Marihuana, Money
		SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(statMoney) . "$" . COLOR_WHITE . " durch Marihuana-Pflanzen verdient.")
	}	
	
	for index, value in partners {
		SendChat("/pay " . value . " " . partnerStake)
	}
}

startFish() {
	global
	
	IniRead, fishUnix, settings.ini, Einstellungen, fishUnix, 0
	
	if (fishUnix < getUnixTimestamp(A_Now)) {
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
				fishNumber++
				
				currentFishMoney := getFishValue(fishing_1, fishing_2)
				currentFishHealth := Floor(fishing_2 * 0.3)
				
				if (fishMode) {
					fishValue := currentFishMoney
				} else {
					fishValue := fishing_2
				}
				
				SendClientMessage(prefix . csecond . fishNumber . ": {FFFFFF}" . fishing_1 . " LBS: " . csecond . fishing_2 . COLOR_WHITE . " | Preis: " . csecond . FormatNumber(currentFishMoney) . COLOR_WHITE . "$ | HP: " . csecond . currentFishHealth)
				
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
					SendClientMessage(prefix . "Du musst deine Fische erst verkaufen!")
					break
				}
				
				if (thrownAway)
					break
				
				aFishMoney -= cheapestFishMoney
				aFishHP -= cheapestFishHP
				
				SendChat("/releasefish " . cheapestFish)
				Sleep, 200
				
				if (fishMode)  {
					SendClientMessage(prefix . cscond . cheapestFishName . ": {FFFFFF}" . cheapestFish . COLOR_WHITE . " im Wert von " . csecond . FormatNumber(cheapestFishValue) . COLOR_WHITE . "$ weggeworfen")
				} else {
					SendClientMessage(prefix . cscond . cheapestFishName . ": {FFFFFF}" . cheapestFish . COLOR_WHITE . " mit " . csecond . FormatNumber(cheapestFishValue) . COLOR_WHITE . " LBS weggeworfen")
				}
				
				thrownAway := true
			} else if (RegExMatch(fishing, "Du bist an keinem Angelplatz \(Big Wheel Rods\) oder an einem Fischerboot!")) {
				if (attempt == 3) {
					SendClientMessage(prefix . "Du kannst hier nicht angeln!")
					break
				}
				
				attempt++
			} else if (RegExMatch(fishing, "Du kannst erst in (\d+) (\S+) wieder angeln\.", ftime_)) {
				if (aFishMoney + aFishHP > 0) {
					Sleep, 500
					
					checkFishes()
					
					IniWrite, 900, settings.ini, Cooldown, fishcooldown
					break
				} else {
					SendClientMessage(prefix . "Du kannst noch nicht angeln.")
					break
				}
			}
		}
	} else {
		restTime := fishUnix - getUnixTimestamp(A_Now)
		SendClientMessage(prefix . "Du kannst noch nicht fischen! (Gesperrt: " . csecond . formatTime(restTime) . COLOR_WHITE . ")")
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
			if (!admin || comhelper) {
				Sleep, 500
			}
			
			if (chat_1 > 10) {
				SendChat("/take Drogen " . name)
				
				if (drugsFound) {
					IniRead, drugs, stats.ini, Kontrollen, Drugs, 0
					drugs += drugsFound		
					IniWrite, %drugs%, stats.ini, Kontrollen, Drugs
					SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(drugs) . "g " . COLOR_WHITE . "Drogen weggenommen.")
				}
			} else {
				SendClientMessage(prefix . "Der Spieler hat unter 10g, biete ihn mit " . csecond . "/tdd" . COLOR_WHITE . " ein Ticket an.")
			}
			
			if (seedsFound) {
				IniRead, seeds, stats.ini, Kontrollen, seeds, 0
				seeds += seedsFound		
				IniWrite, %seeds%, stats.ini, Kontrollen, Seeds
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(seeds) . COLOR_WHITE . " Samen weggenommen.")
			}
		}
		
		if (matsFound || packetsFound || bombsFound) {
			if (!admin || comhelper) {
				Sleep, 500
			}
			
			SendChat("/take Materialien " . name)
			
			if (matsFound) {
				IniRead, mats, stats.ini, Kontrollen, mats, 0
				mats += matsFound			
				IniWrite, %mats%, stats.ini, Kontrollen, Mats
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(mats) . COLOR_WHITE . " Materialien weggenommen.")
			}	
			
			if (packetsFound) {
				IniRead, matpackets, stats.ini, Kontrollen, matpackets, 0
				matpackets += packetsFound
				IniWrite, %matpackets%, stats.ini, Kontrollen, Matpackets
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(matpackets) . COLOR_WHITE . " Materialpakete weggenommen.")
			} 
			
			if (bombsFound) {
				IniRead, matbombs, stats.ini, Kontrollen, matbombs, 0
				matbombs ++
				IniWrite, %matbombs%, stats.ini, Kontrollen, Matbombs
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(matbombs) . COLOR_WHITE . " Haftbomben weggenommen.")
			}
		}
	}
	
	checkingPlayers.RemoveAt(pos)
	
	return [drugsFound, seedsFound, matsFound, packetsFound, bombsFound]
}

readCarInfos() {
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
			SendClientMessage(csecond . "Besitzer: " . COLOR_WHITE . owner1)
			SendClientMessage(csecond . "Letzter Fahrer: " . COLOR_WHITE . driver1)
			SendClientMessage(csecond . "Stadt: " . COLOR_WHITE . city . csecond . " Bezirk: " . COLOR_WHITE . zone)
		} else {
			lvl := getPlayerScoreById(id)
			
			SendClientMessage(csecond . "Besitzer: " . COLOR_WHITE . owner1 . csecond . " ID: " . COLOR_WHITE . id . csecond . " Level: " . COLOR_WHITE . lvl)
			SendClientMessage(csecond . "Letzter Fahrer: " . COLOR_WHITE . driver1)
			SendClientMessage(csecond . "Stadt: " . COLOR_WHITE . city . csecond . " Bezirk: " . COLOR_WHITE . zone)
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
		SendChat("/" . chat . " HQ: Ich befinde mich derzeit in der Paintball-Arena!")
	} else {
		SendChat("/" . chat . " HQ: Ich befinde mich derzeit in " . getLocation() . ", HP: " . getPlayerHealth() . "/" . getPlayerArmor())
	}
}

getFishValue(fishName, fishWeight) {
	global
	
	if (fishName == "Bernfisch") {
		value := fishWeight * 1
	} else if (fishName == "Blauer Fächerfisch") {
		value := fishWeight * 1
	} else if (fishName == "Roter Schnapper") {
		value := fishWeight * 2
	} else if (fishName == "Schwertfisch") {
		value := fishWeight * 2
	} else if (fishName == "Zackenbarsch") {
		value := fishWeight * 2
	} else if (fishName == "Katzenfisch") {
		value := fishWeight * 3
	} else if (fishName == "Forelle") {
		value := fishWeight * 3
	} else if (fishName == "Delphin") {
		value := fishWeight * 4
	} else if (fishName == "Hai") {
		value := fishWeight * 4
	} else if (fishName == "Segelfisch") {
		value := fishWeight * 4
	} else if (fishName == "Makrele") {
		value := fishWeight * 5
	} else if (fishName == "Aal") {
		value := fishWeight * 6
	} else if (fishName == "Hecht") {
		value := fishWeight * 6
	} else if (fishName == "Schildkröte") {
		value := fishWeight * 8
	} else if (fishName == "Thunfisch") {
		value := fishWeight * 8
	} else if (fishName == "Wolfbarsch") {
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
        SendClientMessage(prefix . "Fehler bei der Verbindung zum Server.")
    } else if (result == "ERROR_BAD_LINK") {
        SendClientMessage(prefix . "Fehlerhafte Parameterübergabe.")
    } else if (result == "ERROR_ACCESS_DENIED") {
        SendClientMessage(prefix . "Zugriff verweigert, das Passwort ist falsch.")
    } else if (result == "ERROR_WRONG_FORMAT") {
        SendClientMessage(prefix . "Fehlerhaftes Format.")
    } else if (result == "ERROR_NOT_FOUND") {
        SendClientMessage(prefix . "Der Komplex wurde nicht in der Datenbank gefunden.")
    } else {
        if (store == "") {
            SendClientMessage(prefix . "Gebäudekomplex " . cSecond . id . COLOR_WHITE . ":")
        }
        
        try {
            data := JSON.Load(result)
        } catch {
            SendClientMessage(prefix . "Es ist ein unbekannter Fehler aufgetreten.")
            return
        }
        
        for index, entry in data {
            name := entry["name"]
            location := ""
            
            if (entry["type"] == "public") {
                color := "{00FF00}"
                location := " (" . calculateZone(entry["x"], entry["y"], 0.0) . ", " . calculateCity(entry["x"], entry["y"], 0.0) . ")"
            } else if (entry["type"] == "house") {
                color := "{00FFFF}"
                
                if (name == "Nobody") {
                    name := "Haus (frei)"
                } else if (name == "Auktion im CP") {
                    name := "Haus (" . name . ")"
                } else {
                    name := "Haus von " . name
                }
                
                location := " (" . calculateZone(entry["x"], entry["y"], 0.0) . ", " . calculateCity(entry["x"], entry["y"], 0.0) . ")"
            } else if (entry["type"] == "faction") {
                color := "{7F00FF}"
                location := " (" . calculateZone(entry["x"], entry["y"], 0.0) . ", " . calculateCity(entry["x"], entry["y"], 0.0) . ")"
            } else if (entry["type"] == "vehicle") {
                color := "{FF00FF}"
            }
            
            if (entry["x"] == -5000 || entry["y"] == -5000) {
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
                
                SendClientMessage(prefix . cSecond . "GK " . id . " " . color . "(ID: " . entry["type"] . "." . entry["id"] . ") " . name . location)
                
                if (showGK) {
                    Sleep, 50
                    
                    showGK(entry["type"] . "." . entry["id"], true)
                }
            } else {
                SendClientMessage(prefix . cSecond . "GK " . color . "(ID: " . entry["type"] . "." . entry["id"] . ") " . name . location)
            }
        }
    }
}

showGK(gk, ignoreExisting := false) {
	global
	
    if (RegExMatch(gk, "^(public|house|faction)\.(\d+)$", regex_)) {
        result := UrlDownloadToVar(baseURL . "api/newgk.php?id=" . gk)
        
        if (result == "ERROR_CONNECTION") {
            SendClientMessage(prefix . "Fehler bei der Verbindung zum Server.")
        } else if (result == "ERROR_BAD_LINK") {
            SendClientMessage(prefix . "Fehlerhafte Parameterübergabe.")
        } else if (result == "ERROR_ACCESS_DENIED") {
            SendClientMessage(prefix . "Zugriff verweigert, das Passwort ist falsch.")
        } else if (result == "ERROR_WRONG_FORMAT") {
            SendClientMessage(prefix . "Fehlerhaftes Format.")
        } else if (result == "ERROR_NOT_FOUND") {
            SendClientMessage(prefix . "Der Komplex wurde nicht in der Datenbank gefunden.")
        } else {
            try {
                data := JSON.Load(result)
            } catch {
                SendClientMessage(prefix . "Es ist ein unbekannter Fehler aufgetreten.")
                return
            }
            
            if (IsMarkerCreated() && !ignoreExisting) {
                SendClientMessage(prefix . "Du kannst mit '" . cSecond . "X" . COLOR_WHITE . "' bestätigen, wenn du den CP neu setzen willst.")
                
                KeyWait, X, D, T10
                
                if (ErrorLevel) {
                    return
                }
            }
            
            zPos := data["z"]
            
            if (zPos == -1)
                zPos := 20
            
            if (setCheckpoint(data["x"], data["y"], zPos, 5)) {
                SendClientMessage(prefix . "Der Checkpoint zum GK mit der ID " . SECCOL . gk . " {FFFFFF}wurde erfolgreich gesetzt!")
            } else {
                SendClientMessage(prefix . "Beim Setzen des Checkpoints ist ein Fehler aufgetreten!")
            }
        }
    } else {
        SendClientMessage(prefix . "GK Fehler: Die ID wurde falsch formatiert. " . cSecond . "Beispiel: public.12")
    }
}

checkFishes() {	
	global
	
	SendChat("/fishes")

	Sleep, 250

	fishNumber := 5
	fishMoney := 0
	totalHP := 0
	
	Loop, 5 {
		fish := readChatLine(fishNumber)
		
		RegExMatch(fish, "\*\* \((\d)\) Fisch: (.+) \((\d+) LBS\)", fish_)
		
		fishValue := getFishValue(fish_2, fish_3)
		fishMoney += fishValue
		
		hp := Floor(fish_3 / 3)
		totalHP += hp
		
		message%A_Index% := prefix . "(" . fish_1 . ") " . fish_2 . " (" . fish_3 . " LBS) - " . csecond . fishValue . "$ {FFFFFF}- " . csecond . hp . " HP"
		
		fishNumber -= 1
	}
	
	fishNumber := 5
	
	Loop, 5 {
		setChatLine(fishNumber, message%A_Index%)
		
		fishNumber -= 1
	}
	
	SendClientMessage(prefix . "Du bekommst für die Fische " . csecond . FormatNumber(fishMoney) . "$")
	SendClientMessage(prefix . "Du kannst mit den Fischen " . csecond . FormatNumber(totalHP) . COLOR_WHITE . " HP generieren.")
}

checkCooked() {	
	global
	
	SendChat("/cooked")
	
	Sleep, 200
	
	fishNumber := 5
	totalHP := 0
	
	Loop, 5 {
		fish := readChatLine(fishNumber)
		
		if (RegExMatch(fish, "\*\* \((\d)\) Hergestellt: gekochten (.+) \((\d+) LBS\)", fish_)) {
			HP := Floor(fish_3 / 3)
			totalHP += HP
			
			message%A_Index% := prefix . "(" . fish_1 . ") " . fish_2 . " (" . fish_3 . " LBS) - " . csecond . HP . " HP"
			
			
			fishLBS_%index% := fish_3
			fishName_%index% := fish_2
			
		} else if (RegExMatch(fish, "\*\* \((\d)\) Hergestellt: Nichts \(0 LBS\)", fish_)) {
			message%A_Index% := prefix . "(" . fish_1 . ") Nichts"
			
			fishLBS_%index% := 0
			fishName_%index% := "nichts"
		}
		
		fishNumber -= 1
	}
	
	fishNumber := 5
	
	Loop, 5 {
		setChatLine(fishNumber, message%A_Index%)
		
		fishNumber -= 1
	}
	
	SendClientMessage(prefix . "Du kannst mit den Fischen " . csecond . FormatNumber(totalHP) . COLOR_WHITE . " HP generieren.")
	
	return totalHP
}

addLocalToStats() {	
	global
	
	SendChat("/robres")
	
	Sleep, 200
	
	Loop, 5 { 
		chat := readChatLine(A_Index - 1)
	
		if (RegExMatch(chat, "HQ: Die Restaurant-Kette (.+) wurde von Staat San Andreas eingenommen\.", output1_)) {
			if (output1_1 != oldLocal) {
				SendChat("/d HQ: Ich habe die Kette " . output1_1 . " von ihrem Erpresser befreit!")

			
				; STAT
				IniRead, Restaurants, stats.ini, Übernahmen, Restaurants, 0
				Restaurants ++
				IniWrite, %Restaurants%, stats.ini, Übernahmen, Restaurants
			
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(Restaurants) . COLOR_WHITE . " Restaurants übernommen.")
				
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
				; STAT
				IniRead, controls, stats.ini, Kontrollen, controls, 0
				controls ++
				IniWrite, %controls%, stats.ini, Kontrollen, controls
		
				SendClientMessage(prefix . "Du hast bereits " . csecond . FormatNumber(controls) . COLOR_WHITE . " Kontrollen durchgeführt.")

				oldFriskTime := 180 
				oldFrisk := frisk_name
				
				break
			}
		}
	}
}

updateKD() {
	global
	
	IniRead, Kills, Stats.ini, Stats, Kills, 0
	IniRead, Deaths, Stats.ini, Stats, Deaths, 0
	
	if (Kills != getKill()) {
		Kills := getKill()
		iniWrite, %Kills%, Stats.ini, Stats, Kills
		SendClientMessage(Prefix . "Deine Kills wurden auf " . cSecond . formatNumber(Kills) . COLOR_WHITE . " aktuallisiert.")
	}
	
	if (Deaths != getDeath()) {
		Deaths := getDeath() 
		iniWrite, %Deaths%, Stats.ini, Stats, Deaths
		SendCLientMessage(prefix . "Deine Toden wurden auf " . cSecond . formatNumber(Deaths) . COLOR_WHITE . " aktuallisiert.")
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

getDrugs(setted = 0) {
	global
	
	forceStats()

	if (RegExMatch(getDialogText(), "(.*)Drogen: (\d+)g(.*)", drugs_)) {
		IniWrite, % drugs_2, settings.ini, Items, drugs
		
		if (setted) {
			SendClientMessage(prefix . "Du hast nun " . cSecond . drugs_2 . COLOR_WHITE . "g Drogen bei dir.")
		}
		
		return deaths_2
	} else {
		return -1
	}
}

getFirstAid(setted = 0) {
	global
	
	forceStats() 
	
	if (InStr(getDialogText(), "Erste-Hilfe-Paket")) {
		IniWrite, 1, settings.ini, Items, firstaid
		
		if (setted) {
			SendClientMessage(prefix . "Du hast nun ein Erste-Hilfe-Paket bei dir.")
		}
		
		return 1
	} else {
		IniWrite, 0, settings.ini, Items, firstaid
	
		if (setted) {
			SendClientMessage(prefix . "Du hast nun kein Erste-Hilfe-Paket mehr bei dir.")
		}	
		
		return 0
	}
}

getCampfire(setted = 0) {
	global
	
	forceStats() 
	
	if (InStr(getDialogText(), "Lagerfeuer")) {
		if (RegExMatch(getDialogText(), "(.*)Lagerfeuer \((\d+)\)(.*)", out_)) {
			iniWrite, % out_2, settings.ini, Items, campfire
		
			if (setted) {
				SendClientMessage(prefix . "Du hast nun " . out_2 . " Lagefeuer bei dir.")
			}
			
			return 1
		} else {
			iniWrite, 0, settings.ini, Items, campfire
		
			if (setted) {
				SendClientMessage(prefix . "Du hast nun keine Lagefeuer bei dir.")
			}
			
			return 0
		}
	} else {
		iniWrite, 0, settings.ini, Items, campfire
	
		if (setted) {
			SendClientMessage(prefix . "Du hast nun keine Lagefeuer bei dir.")
		}
		
		return 0
	}
}

forceStats() {
	global
	
	if (!WinExist("GTA:SA:MP") || !WinActive("GTA:SA:MP")) {
		return
	}
	
	BlockDialog()
	
	SendChat("/stats")
	
	Sleep, 200
	
	UnblockDialog()
}

getFishHP() {
	global
	
	SendChat("/cooked")
	Sleep, 250
	
	fishNumber := 5
	
	Loop, 5 {
		fish := readChatLine(fishNumber)
	
		if (RegExMatch(fish, "\*\* \((\d)\) Hergestellt: gekochten (.+) \((\d+) LBS\)", fish_)) {
			return %A_Index%
		}
		
		fishNumber -= 1
	}
	
	return 0
}

healPlayer() {
	global healcooldown
	
	if (healcooldown > 0) {
		SendClientMessage(prefix . "Du kannst dich erst in " . csecond . healcooldown . COLOR_WHITE . " Sekunden heilen.")
	} else {
		SendChat("/heal")
	
		Sleep, 200
	
		checkHealMessage()
	}
}

refillCar() {
	global
	
	if (isPlayerInAnyVehicle() && isPlayerDriver()) {
		if (getVehicleEngineState()) {
			SendChat("/motor")
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

openMaut() {
	global
	
	SendChat("/zoll")
	Sleep, 200
	
	if (inStr(readChatLine(0) . readChatLine(1), "Es ist keine Zollstation in deiner Nähe.")) {
		Sleep, 800
		SendChat("/zoll")
	}
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
  
	for key, array in skins {
        for index2, value2 in array {
            if (value2 == id) {
                fraction := key
                Break, 2
            }
        }
    }
	
    if (fraction) {
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
			}
		}
	}
	
	if (weap) {
		return weap
	}
	
	return "Unbekannt"
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

isPlayerOnGasStation() {
	global
	
	if (isPlayerInRangeOfPoint(700, -1930, 0, 30) ; Verona Beach
	|| isPlayerInRangeOfPoint(1833, -2431, 14, 30) ; LS Airport
	|| isPlayerInRangeOfPoint(615, 1689, 7, 6) ; Bone County
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

isPlayerOnMaut() {
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

isPlayerOnEquip() {
	global
	
	if (IsPlayerInRangeOfPoint(255, 77, 1003, 5)) {
		return 1
	} else {
		return 0
	}
}

isPlayerOnHeal() {
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

isOnCookPoint() {
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

isPlayerOnLocal() {
	global
	
	if (IsPlayerInRangeOfPoint(792.6970, -1626.2189, 13.3906, 3.1) ; Kette BS (Marina)
		|| IsPlayerInRangeOfPoint(2412.0930, -1491.2977, 24.0000, 3.1)  ; Kette CB (East Los Santos)
		|| IsPlayerInrangeOfPoint(2113.6445, -1788.6113, 13.5608, 3.1) ; Kette PS (Idlewood)
		|| IsPlayerInrangeOfPoint(1026.6838, -1350.2480, 13.7266, 3.1)) { ; Kette Donut
		return 1
	} else {
		return 0
	}
}

isPlayerOnJailGate() {
	global
	
	if (IsPlayerInRangeOfPoint(2349.8623, -2007.0856, 13.5433, 5)
	|| IsPlayerInRangeOfPoint(2350.1714, -1985.9761, 13.3828, 5)
	|| IsPlayerInRangeOfPoint(2345.9443, -1978.7985, 13.4297, 5)
	|| IsPlayerInRangeOfPoint(2345.6887, -1999.4963, 13.3770, 5)) {
		return 1
	} else {
		return 0
	}
}

isPlayerOnPDGate() {
	global
	
	if (IsPlayerInRangeOfPoint(246.3596, 72.3406, 1003.6406, 7)
	|| IsPlayerInRangeOfPoint(1544.5332, -1626.9120, 13.3835, 10)
	|| IsPlayerInRangeOfPoint(1588.4823, -1638.0181, 13.4223, 10)
	|| IsPlayerInRangeOfPoint(-1632.2172, 688.3776, 7.1875, 10)
	|| IsPlayerInRangeOfPoint(-1572.2305, 662.0664, 7.1875, 10)
	|| IsPlayerInRangeOfPoint(-1701.6676, 684.1833, 24.8947, 10)) {
		return 1
	} else {
		return 0
	}
}

isPlayerOnFishPoint() {
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

isBlocked() {
	global
	
	if (isInChat() || IsDialogOpen() || IsPlayerInMenu()) {
		return 1 
	} else {
		return 0
	}
}

isFraction() {
	IniRead, keybinderFrac, settings.ini, Einstellungen, keybinderFrac, %A_Space%
	
	if (keybinderFrac == "" || keybinderFrac == "ERROR") {
		SendClientMessage(prefix . "Fehler: Du musst noch deine Fraktion setzen. Nutze " . csecond . "/dep")	
		return 0
	} else {
		return 1
	}
}