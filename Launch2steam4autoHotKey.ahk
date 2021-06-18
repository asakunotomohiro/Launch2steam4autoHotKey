#UseHook
#SingleInstance, Force
#NoEnv

;	オキシゲン ノット インクルード
F1 & o::
	GameArray := [ 
			 , A_Desktop . "\Oxygen Not Included.url"
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

;	game
F1 & g::
	GameArray := [ 
			 , A_Desktop . "\RPG Maker MV.url"
			 , A_Desktop . "\Dungeon Siege 2.url"
			 , A_Desktop . "\Life Goes On.url"
			 , A_Desktop . "\Hearts of Iron IV.url"
			 , A_Desktop . "\METAL GEAR SOLID V GROUND ZEROES.url"
			 , A_Desktop . "\METAL GEAR SOLID V THE PHANTOM PAIN.url"
			 , A_Desktop . "\Metro 2033.url"
			 , A_Desktop . "\reconquest.url"
			 , A_Desktop . "\Rise of Nations Extended Edition.url"
			 , A_Desktop . "\Super Bomberman R Online.url"
			 , A_Desktop . "\大秦帝国.url"
			 , A_Desktop . "\Three Kingdoms The Last Warlord.url"
			 , A_Desktop . "\Batman Arkham Asylum GOTY Edition.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

;	ファクトリオ
F1 & f::
	GameArray := [ 
			 , A_Desktop . "\Factorio.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

;	シムシティ
F1 & c::
	GameArray := [ 
			 , A_Desktop . "\" . "SimCity™.lnk"
			 , A_Desktop . "\" . "Cities Skylines.url"
			 , A_Desktop . "\" . "Banished.url"
			 , A_Desktop . "\" . "Block'hood.url"
			 , A_Desktop . "\" . "SimCity 4 Deluxe.url"
			 , A_Desktop . "\" . "OpenTTD.url"
			 , A_Desktop . "\" . "TheoTown.url"
			 , A_Desktop . "\" . "Tropico 4.url"
			 , A_Desktop . "\" . "Surviving Mars.url"
			 , A_Desktop . "\" . "Restaurant Empire II.url"
			 , A_Desktop . "\" . "Prison Architect.url"
			 , A_Desktop . "\" . "Railway Empire.url"
			 , ""]

	Launch2steam4autoHotKey(GameArray)
return

;	サウンドトラック(Playの頭文字)
;		 まだいくつかあるのに、デスクトップにショートカットファイルを作成できない。
F1 & p::
	GameArray := [ 
			 , A_Desktop . "\" . "Oxygen Not Included Soundtrack.url"
			 , A_Desktop . "\" . "DEATH STRANDING Soundtrack Expanded Edition.url"
			 , A_Desktop . "\" . "This War of Mine Soundtrack.url"
			 , A_Desktop . "\" . "Hacknet - Labyrinths Official Soundtrack.url"
			 , A_Desktop . "\" . "Hacknet Official Soundtrack.url"
			 , A_Desktop . "\" . "Shadow Tactics Blades of the Shogun - Official Soundtrack.url"
			 , A_Desktop . "\" . "Space Haven Soundtrack.url"
			 , A_Desktop . "\" . "This War of Mine Soundtrack.url"
			 , ""]

	Launch2steam4autoHotKey( GameArray )
return

F1::F1
; ーーー 以下、 変更不可。 ーーー
global steamListBox :=
Launch2steam4autoHotKey( GameArray )
{
	; グローバル宣言。
	global gameLocalArray := Object()
	global steamExeArray := Object()
	global gameExeArray := Object()
	Array := [ 
			 , A_StartMenuCommon . "\Programs\Steam\Steam.lnk"
			 , "C:\Program Files\Steam\Steam.exe"
			 , "C:\Program Files (x86)\Steam\Steam.exe"
			 , A_StartMenu . "\Programs\Steam\Steam.lnk"
			 , ""]
	gameRunNotPathGet :=

	if % GameArray.MaxIndex() <= 3 && GameArray != ""
	{
		For index, element in GameArray
		{
			IfExist, %element%
			{
				Run, open %element%
				break
			}
			varFoundReg := gameurlGrep(element, varControlWURL, varControlWCOMMENT1, varControlWCOMMENT2, varControlW)
			If ( varFoundReg > 0 )
			{
				Run, open %varControlWURL%
				break
			}
		}
		if GameArray.MaxIndex() = "" && GameArray != ""
		{
			; ユーザ設定の変数設定に1行格納済み。
			varFoundReg := gameurlGrep(GameArray, varControlWURL, varControlWCOMMENT1, varControlWCOMMENT2, varControlW)
			IfExist, %GameArray%
			{
				Run, open %GameArray%
			}
			Else If ( varFoundReg > 0 )
			{
				Run, open %varControlWURL%
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
			if ( element = "" )
			{
				; 空の場合、for文をやり直す。
				continue
			}
			gameRunNotPathGet = %element%
			; 以下、Steamゲーム本体のPathを探す。
			For exeIndex, exeElement in Array
			{
				IfNotExist, %exeElement%
				{
					; SteamPath存在しない。
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
						; OutDirにPathが含まれている。
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
				; 以下、ファイルを探す。
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
				; ゲームexe
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
			; ここは、lnkとURLではない追加場所。
			sleep 200
			DetectHiddenWindows, On
			UniqueID := WinExist("ahk_exe Steam.exe")
			DetectHiddenWindows, Off
			varFoundReg := gameurlGrep(element, varControlWURL, varControlWCOMMENT1, varControlWCOMMENT2, varControlW)
			if % StrLen(UniqueID) == 3 && varControlW == ""
			{
				exefilename = %element%
			}
			Else If ( varFoundReg > 0 )
			{
				exefilename = %varControlW%
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
;	indexII := % gameLocalArray.MaxIndex()
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
xwide := wordCount-100
rowHight := GameArray.MaxIndex()
Gui, Add, ListBox, W%wordCount% R%rowHight% VsteamListBox, %gameElementArray%
GUI, Add, Button, GhelloWorld, &OK
GUI, Add, Button, x+%xwide% Hidden GVhelloWorld, &URL
Gui, Show, , ゲーム選択。
Return

GuiClose:
GuiEscape:
Gui, Destroy
return
}

helloWorld:
	GUI, Submit
	VhelloWorld(gameLocalArray, gameExeArray)
return
gameurlGrep(urlname, ByRef grepURL, ByRef grepFrontComment, ByRef grepBackComment, ByRef grepExefilename )
{
	varControlW :=
	grepURL :=
	grepFrontComment :=
	grepBackComment :=
	grepExefilename :=
	urlname := Trim(urlname)
	varFoundReg := RegExMatch(urlname, "i)(?P<COMMENT1>.*)(?P<URL>\bsteam://rungameid/\d+\b)(?P<COMMENT2>.*)", varControlW)
	grepURL := Trim(varControlWURL,  " `t|`n")
	grepFrontComment := Trim(varControlWCOMMENT1, " `t|`n")
	grepBackComment := Trim(varControlWCOMMENT2,  " `t|`n")
	grepExefilename = %grepBackComment%%grepFrontComment%	%grepURL%

	return varFoundReg
}

VhelloWorld(gameLocalArray, gameExeArray)
{
iiElement :=
StringGetPos, steamListBoxPos, steamListBox, ., L1
StringLeft, iilistBox, steamListBox, steamListBoxPos
steamListBoxPos += 1
StringTrimLeft, guiListboxSteam, steamListBox, steamListBoxPos
iilistBox := iilistBox+1	; GUI側で選んだゲームの1文字目を添え字として抜き出す。

steamGameRun := 
For index, element in gameLocalArray	; GameArray配列(呼び出し元)
{
	if ( index == iilistBox && iilistBox != "" )
	{
		IfExist, %element%
		{
			; リンクファイルなどが存在している状態で人間側が配列を渡してきた。
			steamGameRun = %element%
			break
		}
		else
		{
			For exeIndex, exeElement in gameExeArray
			{
				steamGameRun := 
				StringGetPos, exeGameElementPos, exeElement, ., L1
				StringLeft, iiExeIndex, exeElement, exeGameElementPos	; exeファイル名から添え字を切り出す。
				exeGameElementPos += 1
				StringTrimLeft, exeGameName, exeElement, exeGameElementPos
				if ( index == iiExeIndex )
				{
					steamGameRun = %exeGameName%
					break
				}
			}
			varFoundReg := gameurlGrep(element, varControlWURL, varControlWCOMMENT1, varControlWCOMMENT2, varControlW)
			If ( varFoundReg > 0 )
			{
					steamGameRun = %varControlWURL%
				break
			}
		}
	}
	else if ( iilistBox = "" )
	{
		varFoundReg := gameurlGrep(guiListboxSteam, varControlWURL, varControlWCOMMENT1, varControlWCOMMENT2, varControlW)
		If ( varFoundReg > 0 )
		{
			steamGameRun = %varControlWURL%
		}
break
	}
}

if steamGameRun = 
{
	StringGetPos, steamListBoxPos, steamListBox, ., L1
	StringLeft, iilistBox, steamListBox, steamListBoxPos
	if ( gameLocalArray.MaxIndex() == iilistBox )
	{
		run https://github.com/asakunotomohiro/Launch2steam4autoHotKey
		Gui, Show
		return
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
;	msgbox, OKボタン押下：%steamGameRun%
}
ExitApp
return
}

;# Pathの書き換え方法。
;GameArray配列に、ショートカットファイル名を記載すること(フルPathであること)。
;AutoHotKeyが用意している変数名との組み合わせでフルPathになっていれてもよい。
;見栄えの問題として、空行を設けている前提があるため、それを崩した場合、正常動作をしない可能性がある。
;
;```ahk:抜粋.ahk
;GameArray := [	; ここが1行目の空行
;		 , A_Desktop . "\[ゲーム用ショートカットファイル名].url"	; ここが2行目
;		 , A_Desktop . "\Flockers.url"	; 3行目。
;		 , ""]	; 4行目も空行。
;```
;
;この空行を基準にプログラムが動くため、記述場所には気をつけること。
;
;また、コメントアウト化で、配列数も短くなる。
;```ahk:抜粋.ahk
;GameArray := [	; ここが1行目の空行
;		 , "C:\Users\Public\Desktop\[ゲーム用ショートカットファイル名].url"	; ここが2行目
;;		 , A_Desktop . "\Flockers.url"	; コメントアウトしているため、配列として数えない。
;		 , ""]	; 3行目も空行。
;```
;
;当然、空行追加は、配列として数えられる(これも止めること。見栄えが悪くなる)。
;```ahk:抜粋.ahk
;GameArray := [	; ここが1行目の空行
;		 , "C:\Users\Public\Desktop\Flockers.url"	; ここが2行目
;		 , ""	; 3行目空行。
;		 , ""]	; 4行目空行(3行目の空行を配列として含めるため)。
;```
;
;以下のように、URL表記でも問題ない。
;```ahk:抜粋.ahk
;GameArray := [
;		 , "steam://～～～	オキシゲンノットインクルード"
;		 , "steam://～～～	ヒットマン"
;		 , "steam://～～～	シムシティ"
;		 , ""]
;```
;ゲームexe名だけでもかまわないが、他のゲーム名と同じ場合、ディレクトリ名を含める必要がある。
;"Launcher.exe"ではなく、
;"HITMAN2\Launcher.exe"とすること。
;本音は、GUIの起動に時間がかかるため、止めた方がいい。
;推奨値は、ショートカットファイル名を記述すること。
;また、1行のみにした場合、GUI画面を出さずにゲームが起動する(ショートカットファイルかURL指定のみ)。
;そして、その場合は、本スクリプトが終了せず、常駐する。
;
;当たり前だが、上記の配列にショートカットファイル名を記述するだけではなく、
;`Launch2steam4autoHotKey(GameArray)`
;の関数に渡して呼び出す必要がある(要はゼロからゲーム起動を作る場合の話)。
;本プログラムでは、F1キーとの組み合わせで動くようにしているが、変更も可能ということ。
;この辺は、AutoHotkeyそのものを調べておけば解決する。
