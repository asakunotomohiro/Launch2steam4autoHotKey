#UseHook

global steamListBox =

Launch2steam4autoHotKey(GameArray)
{
	; グローバル宣言
	global gameLocalArray := Object()
	global steamExeArray := Object()
	global gameExeArray := Object()
	Array := [ 
			 , "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"
			 , "C:\Program Files\Steam\Steam.exe"
			 , "C:\Program Files (x86)\Steam\Steam.exe"
			 , UserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"
			 , ""]
	gameRunNotPathGet :=

	if % GameArray.MaxIndex() <= 3 && GameArray != ""
	{
		For index, element in GameArray
		{
			IfExist, %element%
			{
				Run, open %element%
			}
		}
		if GameArray.MaxIndex() = "" && GameArray != ""
		{
			IfExist, %GameArray%
			{
				Run, open %GameArray%
			}
		}
		return
	}

gameElementArray := 
gameLocalArray := GameArray
steamExeArray := Array
	For index, element in GameArray
	{
		IfNotExist, %element%
		{
		StringLeft, OutputVar, element, 8
		if ( element = "" || OutputVar = "steam://")
		{
			continue
		}
		gameRunNotPathGet = %element%
		For exeIndex, exeElement in Array
		{
			IfNotExist, %exeElement%
			{
				continue
			}
			SplitPath, exeElement, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			toppathDir :=
			if (OutExtension == "lnk")
			{
				FileGetShortcut, %exeElement%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
				SplitPath, OutTarget, OutFileActualName, OutActualDir, OutActualExtension, OutActualNameNoExt, OutActualDrive
				exeElement = %OutTarget%
				if OutDir =
				{
					msgbox, 起動したいゲームを見つけられない1。
				}
				else
				{
					toppathDir = %OutDir%
					break
				}
			}
		}
		if toppathDir =
		{
			continue
		}
		DetectHiddenWindows, On
		UniqueID := WinExist("ahk_exe Steam.exe")
		Loop, %toppathDir%\steamapps\common\%gameRunNotPathGet%, 0, 1
		{
			WinGet, steamclose, PID, ahk_id %UniqueID%
			sleep 200
			if steamclose !=
			{
				Process, Close, %steamclose%
				steamerr := ErrorLevel
			}
			sleep 200
			steamGamefullpath := A_LoopFileFullPath
		}
		DetectHiddenWindows, Off
		if steamerr > 0 
		{
			sleep 200
			WinActivate, ahk_pid %steamclose%
		}
		IfExist, %steamGamefullpath%
		{
			gameExeArray.Insert( index "." steamGamefullpath )
		}
		steamGamefullpath := 
		}

		SplitPath, element, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		if (OutExtension == "lnk")
		{
			IfNotExist, %element%
			{
				continue
			}
			FileGetShortcut, %element%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
			if OutTarget =
			{
				exefilename = %OutNameNoExt%.exe
			}
			else
			{
				StringTrimRight, OutputVar, OutTarget, 4
				exefilename = %OutputVar%.exe
			}
		}
		else if (OutExtension == "url")
		{
			IfNotExist, %element%
			{
				continue
			}
			StringTrimRight, OutputVar, OutFileName, 4
			exefilename = %OutputVar%.exe
		}
		else
		{
			; ここは、lnkとURLではない追加場所(exeファイル名が記載されている場合に処理される)。
			sleep 200
			DetectHiddenWindows, On
			UniqueID := WinExist("ahk_exe Steam.exe")
			DetectHiddenWindows, Off
			if % StrLen(UniqueID) == 3
			{
				exefilename = %element%
			}
			else
			{
				continue
			}
		}

		indexII := % index - 1
		if gameElementArray =
		{
			gameElementArray = %indexII%.%exefilename%|
		}
		else
		{
			gameElementArray = %gameElementArray%|%indexII%.%exefilename%
		}
	}
;	indexII := % indexII + 1
;	gameElementArray = %gameElementArray%|%indexII%.本URL
wordCount := 0
For index, element in GameArray
{
	if % StrLen(element) > wordCount
	{
		wordCount = % StrLen(element)
	}
}
wordCount := wordCount*4+wordCount
rowHight := GameArray.MaxIndex()
Gui, Add, ListBox, W%wordCount% R%rowHight% VsteamListBox, %gameElementArray%
GUI, Add, Button, GhelloWorld, &OK
Gui, Show, , ゲーム選択。
Return

GuiClose:
GuiEscape:
Gui, Destroy
return

helloWorld:
GUI, Submit
iiElement :=
StringGetPos, steamListBoxPos, steamListBox, ., L1
StringLeft, iilistBox, steamListBox, steamListBoxPos
steamListBoxPos += 1
StringTrimLeft, guiListboxSteam, steamListBox, steamListBoxPos
iilistBox := iilistBox+1

steamGameRun := 
For index, element in gameLocalArray	; GameArray配列(呼び出し元)
{
	if ( index == iilistBox )
	{
		IfExist, %element%
		{
			steamGameRun = %element%
			break
		}
		else
		{
			For exeIndex, exeElement in gameExeArray	; exeファイル名専用配列
			{
				steamGameRun := 
				StringGetPos, exeGameElementPos, exeElement, ., L1
				StringLeft, iiExeIndex, exeElement, exeGameElementPos	; exeファイル名から添え字を切り出す。
				exeGameElementPos += 1
				StringTrimLeft, exeGameName, exeElement, exeGameElementPos	; exeファイル名のみに加工する。
				if ( index == iiExeIndex )
				{
					steamGameRun = %exeGameName%
					break
				}
			}
		}
	}
}

if steamGameRun = 
{
	StringLeft, iilistBox, steamListBox, steamListBoxPos
	if ( gameLocalArray.MaxIndex()-2 == iilistBox )
	{
		run https://github.com/asakunotomohiro/Launch2steam4autoHotKey
	}
	else {
		msgbox, インストールなし(%guiListboxSteam%)。
		Gui, Show
		return
	}
}
else
{
	sleep 200
	Run, open %steamGameRun%
}
Gui, Destroy
return
}

gameExeRunGoGo(Array, ByRef varSoftwarePID, originally)
{
	varSoftwarePID :=

	For index, element in Array
	{
		SplitPath, element, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
		reElement := element
		if (OutExtension == "lnk")
		{
			FileGetShortcut, %element%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
			element = %OutTarget%
			reElement = %OutTarget%
			if OutDir =
			{
				StringTrimRight, OutputVar, OutFileName, 4
				exename = %OutputVar%.exe
			}
			else
			{
				; OutDirにPathが含まれている。
				exename = %OutNameNoExt%.exe
			}
		}
		else
		{
			exename = %OutFileName%
		}

		IF FileExist( element )
		{
			WinGet, OutputList, List, ahk_exe %element%
			if OutputList > 1 
			{
				WinGet, activeID, ID, A
				WinGetClass, winClassName, ahk_exe %element%
				WinGet, serch_ID, ID, ahk_exe %element%
				WinGet, activeWinID, IDLast, ahk_exe %element%

				sleep 200
				if ( activeID == serch_ID )
				{
					WinActivate, ahk_id %activeWinID%
					WinGet, varSoftwarePID, PID, ahk_id %activeWinID%
				}
				else
				{
					WinActivate, ahk_id %serch_ID%
					WinGet, varSoftwarePID, PID, ahk_id %serch_ID%
				}

			}
			else if OutputList > 0 
			{
;				msgbox, 起動済み。
				WinGet, activeWinID, ID, ahk_exe %element%
				WinActivate, ahk_id %activeWinID%
				WinGet, varSoftwarePID, PID, ahk_id %activeWinID%
			}
			else
			{
				Run, open %element%, , , varSoftwarePID
				oneSoftware = %element%
			}
			break
		}
	}

	return %reElement%
}

steamExeRunGoGo(Array, ByRef varSoftwarePID, originally)
{
	varSoftwarePID :=
	reElement := 

	For index, element in Array
	{
		IF FileExist( element )
		{
			SplitPath, element, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			if (OutExtension == "lnk")
			{
				FileGetShortcut, %element%, element, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
				reElement = %element%
				if OutDir !=
				{
					; OutDirにPathが含まれている。
					exeelement = %OutNameNoExt%.exe
					element = %OutDir%%exeelement%
				}
				else
				{
					exeelement = %element%
				}
			}
			else
			{
				reElement := element
				exeelement = %OutFileName%
			}
			WinGet, OutputList, List, ahk_exe %exeelement%
			if OutputList > 0 
			{
				sleep 200
				WinGet, activeID, ID, A
				WinGetClass, winClassName, ahk_exe %exeelement%
				WinGet, serch_ID, ID, ahk_class %winClassName%
				WinGet, activeWinID, IDLast, ahk_class %winClassName%

				sleep 200
				if ( activeID == serch_ID )
				{
					WinActivate, ahk_id %activeWinID%
					WinGet, varSoftwarePID, PID, ahk_id %activeWinID%
				}
				else
				{
					WinActivate, ahk_id %serch_ID%
					WinGet, varSoftwarePID, PID, ahk_id %serch_ID%
				}
			}
			else
			{
				; 起動
				Run, open %element%, , , varSoftwarePID
			}
			break
		}
		Else If % index == Array.MaxIndex()-1
		{
			if (OutExtension == "lnk")
			{
				StringTrimRight, OutputVar, OutNameNoExt, 4
				exeelement = %OutNameNoExt%.exe
			}
			else
			{
				exeelement = %OutFileName%
			}
		}
	}

	return %reElement%
}

^h::Send {Backspace}
F1::F1

softRunGoGo(Array, ByRef varSoftwarePID, originally)
{
	varSoftwarePID :=

	For index, element in Array
	{
		IF FileExist( element )
		{
			Run, open %element%, , , varSoftwarePID
			sleep 450
			WinActivate, ahk_pid %varSoftwarePID%
			break
		}
		Else If % index == Array.MaxIndex()-1
		{
			SplitPath, element, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
			if (OutExtension == "lnk")
			{
				FileGetShortcut, %element%, OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
				if OutTarget =
				{
					exefilename = %OutNameNoExt%.exe
				}
				else
				{
					StringTrimRight, OutputVar, OutTarget, 4
					exefilename = %OutputVar%.exe
				}
			}
			else
			{
				exefilename = %OutFileName%
			}
		}
	}

	return %element%
}

#s::
	Array := [
			 , "C:\Program Files\Steam\Steam.exe"
			 , "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"
			 , UserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Steam.lnk"
			 , "C:\Program Files (x86)\Steam\Steam.exe"
			 , ""]
	oneSoftware :=

	oneSoftware := steamExeRunGoGo(Array, varSoftwarePID, "#s")
	If oneSoftware !=
	{
		sleep 250
		WinActivate, ahk_pid %varSoftwarePID%
	}
return

#f::
	Array := [ 
			 , "C:\Program Files\Mozilla Firefox\firefox.exe"
			 , "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"
			 , UserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"
			 , "C:\Program Files (x86)\Mozilla Firefox\firefox.exe"
			 , ""]
	oneSoftware :=

	oneSoftware := softRunGoGo(Array, varSoftwarePID, "#f")
	IfExist, %oneSoftware%
	{
		sleep 150
		WinActivate, ahk_pid %varSoftwarePID%
	}
return

#o::
	Array := [ 
			 , "C:\Program Files\Origin\Origin.exe"
			 , "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Origin\Origin.lnk"
			 , UserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Origin\Origin.lnk"
			 , "C:\Program Files (x86)\Origin\Origin.exe"
			 , ""]
	oneSoftware :=

	oneSoftware := gameExeRunGoGo(Array, varSoftwarePID, "#o")
	IfExist, %oneSoftware%
	{
		sleep 200
		WinActivate, ahk_pid %varSoftwarePID%
	}
return

#m::
	Array := [
			 , "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Minecraft\Minecraft.lnk"
			 , "C:\Program Files\Minecraft\MinecraftLauncher.exe"
			 , "C:\Program Files (x86)\Minecraft\MinecraftLauncher.exe"
			 , UserProfile . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Minecraft\Minecraft.lnk"
			 , ""]
	oneSoftware :=
	varSoftwarePID :=

	oneSoftware := gameExeRunGoGo(Array, varSoftwarePID, "#m")
	IfExist, %oneSoftware%
	{
		sleep 200
		WinActivate, ahk_pid %varSoftwarePID%
	}
return

F1 & u::
	cal := systemroot . "\system32\calc.exe"
	Run, %systemroot%\system32\calc.exe, , , varCalcPID
return

F1 & t::
	Send, ^+{Esc}
;	Run, %systemroot% . \system32\osk.exe, , , varOskPID
return

;	オキシゲン ノット インクルード
F1 & o::
	GameArray := [ 
			 , A_Desktop . "\Oxygen Not Included.url"
			 , A_Desktop . "\OpenTTD.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

;	ヒットマン
F1 & h::
	GameArray := [ 
			 , A_Desktop . "\HITMAN 2.url"
			 , A_Desktop . "\HITMAN.url"
			 , A_Desktop . "\Hitman GO Definitive Edition.url"
			 , A_Desktop . "\Hitman Absolution.url"
			 , A_Desktop . "\Hitman Blood Money.url"
			 , A_Desktop . "\Hitman Contracts.url"
			 , A_Desktop . "\Hitman 2 Silent Assassin.url"
			 , A_Desktop . "\Hitman Codename 47.url"
			 , A_Desktop . "\Sniper Ghost Warrior Contracts.url"
			 , A_Desktop . "\Zombie Army Trilogy.url"
			 , A_Desktop . "\Sniper Elite 3.url"
			 , A_Desktop . "\Sniper Elite V2.url"
			 , A_Desktop . "\Sniper Elite.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

;	ファクトリオ
F1 & f::
	GameArray := [ 
			 , A_Desktop . "\Factorio.url"
			 , A_Desktop . "\Flockers.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

F1 & c::
	GameArray := [ 
			 , A_Desktop . "\" . "SimCity™.lnk"
			 , A_Desktop . "\" . "Cities Skylines.url"
			 , A_Desktop . "\" . "Banished.url"
			 , A_Desktop . "\" . "Block'hood.url"
			 , A_Desktop . "\" . "SimCity 4 Deluxe.url"
			 , A_Desktop . "\" . "TheoTown.url"
			 , A_Desktop . "\" . "OpenTTD.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return
