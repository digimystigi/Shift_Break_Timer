#SingleInstance force
#NoEnv	; Recommended for performance and compatibility with future AutoHotkey releases.
 #Warn	; Enable warnings to assist with detecting common errors.
SendMode Input	; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%	; Ensures a consistent starting directory.
#NoTrayIcon

;;;;;;;;;;
;; Main ;;
;;;;;;;;;;

	SetTimer, gUpdate, 1000

	global vFBTime ; First Break time
	global vLBTime ; Lunch Break time
	global vSBTime ; Second Break time
	global vESTime ; End of Shift time

	INIRead, vFBTime, timeconf.ini, Time, FBTime,	645
	INIRead, vLBTime, timeconf.ini, Time, LBTime,	765
	INIRead, vSBTime, timeconf.ini, Time, SBTime,	915
	INIRead, vESTime, timeconf.ini, Time, ESTime,	1020 

	GUI, Main:New,, Break Timer!
	GUI, +HwndMain AlwaysOnTop +OwnDialogs
	critical
 
	GUI, FONT, S10 cBlack ;w700
	GUI, Add, Text, x10 y24	gFBreak vF, 1st Break:
	GUI, Add, Text, x10 y64	gLunchB vL, Lunch:
	GUI, Add, Text, x10 y104 gSBreak vS, 2nd Break:
	GUI, Add, Text, X10 y144 gEShift vE, Shift End: 
 
 
	GUI, FONT, S24 w400, Courier New
	GUI, Add, Text, Right x90 y10	vTfb, 0:00
	GUI, Add, Text, Right x90 y50	vTlb, 0:00
	GUI, Add, Text, Right x90 y90	vTsb, 0:00
	GUI, Add, Text, Right x90 y130 vTes, 0:00
	 
	GUI, Show

	GoSub gUpdate
	#Include E:\AutoReload.ahk


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; gUpdate ; Screen Update ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


gUpdate:

	IfGreater, A_TimeIdle, 10000
	{
		WinLast := WinExist("A")
		Gui, %Main%:Restore
		WinActivate, ahk_id %WinLast%
	}

	vTime := A_Hour * 60 + A_Min
	vTTFB := vFBTime - vTime
	vTTLB := vLBTime - vTime
	vTTSB := vSBTime - vTime
	vTTES := vESTime - vTime

	IfLess, vTTES, 1
	{
		vTTES = 0:00
		Gui, %Main%:Font, cRed
		GuiControl, %Main%:Font, Tes
	}
	Else
	{
		IfLess, vTTES, 6
			Gui, %Main%:Font, cYellow
		Else
			Gui, %Main%:Font, cBlack
		vTTES := FTime(vTTES)
		GuiControl, %Main%:Font, Tes
	}


	IfLess, vTTSB, 1
	{
		vTTSB = 0:00
		Gui, %Main%:Font, cRed
		GuiControl, %Main%:Font, Tsb
	}
	Else
	{
		IfLess, vTTSB, 6
			Gui, %Main%:Font, cYellow
		Else
			Gui, %Main%:Font, cBlack
		vTTSB := FTime(vTTSB)
		GuiControl, %Main%:Font, Tsb
	}


	IfLess, vTTLB, 1
	{
		vTTLB = 0:00
		Gui, %Main%:Font, cRed
		GuiControl, %Main%:Font, Tlb
	}
	Else
	{
		IfLess, vTTLB, 6
			Gui, %Main%:Font, cYellow
		Else
			Gui, %Main%:Font, cBlack
		vTTLB := FTime(vTTLB)
		GuiControl, %Main%:Font, Tlb
	}


	IfLess, vTTFB, 1
	{
		vTTFB = 0:00
		Gui, %Main%:Font, cRed
		GuiControl, %Main%:Font, Tfb
	}
	Else
	{
		IfLess, vTTFB, 6
			Gui, %Main%:Font, cYellow
		Else
			Gui, %Main%:Font, cBlack
		vTTFB := FTime(vTTFB)
		GuiControl, %Main%:Font, Tfb
	}


	GuiControl, %Main%:Text, TFB, %vTTFB%
	GuiControl, %Main%:Text, TLB, %vTTLB%
	GuiControl, %Main%:Text, TSB, %vTTSB%
	GuiControl, %Main%:Text, TES, %vTTES%
return


MainGuiEscape:
MainGuiClose:
	GUI +OwnDialogs
	MsgBox, 8225, Quit?, Are you sure you want`nto close your timer?
	IfMsgBox Ok
		ExitApp
return


;;;;;;;;;;;;;;;;;
;; Preferences ;;
;;;;;;;;;;;;;;;;;


EShift:
LunchB:
SBreak:
FBreak:

	global Tm
	global vFBTime
	global vLBTime
	global vSBTime
	global vESTime

	If A_GuiControl = F
	{
		Bk = First Break
		Tm = vFBTime
		ini = FBTime
	}
	Else If A_GuiControl = L
	{
		Bk = Lunch
		Tm = vLBTime
		ini = LBTime
	}
	Else If A_GuiControl = S
	{
		Bk = Second Break
		Tm = vSBTime
		ini = SBTime
	}
	Else If A_GuiControl = E
	{
		Bk = End of Shift
		Tm = vESTime
		ini = ESTime
	}

	Mins := Mod(%Tm%, 60)
	Hours:= Floor(%Tm%/60)
	vBox = %A_Year%%A_MM%%A_DD%%Hours%%Mins%

	GUI, Time:New
	GUI, Time:+AlwaysOnTop
	GUI, Time:Add, Text, v, Set %Bk% time:
	Gui, Time:Add, DateTime, w70 h25 1 vTimeVal, hh:mm tt
	GuiControl, , TimeVal, %vBox%
	GUI, Time:Add, Button, w70 Default, Ok
	Gui, %Main%:+Disabled
	GUI, Time:Show

return

TimeButtonOk:

	Gui, +OwnDialogs
	Gui, Time:Submit
	StringRight, Time, TimeVal, 6
	StringLeft, Time, Time, 4
	StringLeft, Hours, Time, 2
	StringRight, Mins, Time, 2

	Temp := Hours * 60 + Mins
	%Tm% := Temp	

	INIWrite, %vFBTime%, timeconf.ini, Time, FBTime
	INIWrite, %vLBTime%, timeconf.ini, Time, LBTime
	INIWrite, %vSBTime%, timeconf.ini, Time, SBTime
	INIWrite, %vESTime%, timeconf.ini, Time, ESTime


TimeGuiEscape:
TimeGuiClose:
	Gui, %Main%:-Disabled
	Gui, Time:Destroy

return



FTime(x)
{
	min	:= mod(x, 60)
	x	:= floor(x/60)
	hour	:= x
	if min < 10
		min = 0%min%
	x = %hour%:%min%
	return x
}


^Pause::Pause, Toggle