#include <GUIConstantsEx.au3>
#include <misc.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>

Opt("GUIOnEventMode", 1)
HotKeySet("{F10}", Closebutton)
HotKeySet("{F5}", Play)
HotKeySet("{F6}", NewSpeed)
Local $hMainGUI = GUICreate("pianer", 200, 130,"","",0x00800000,$WS_EX_TOPMOST)
GUICtrlCreateLabel("F5 - play", 3, 0, 50)
GUICtrlCreateLabel("F6 - speed", 3, 15, 50)
GUICtrlCreateLabel("F10 - close", 3, 30, 60)
Global $status = GUICtrlCreateLabel("Not Playing", 90, 10, 100, 20)
Global $button = GUICtrlCreateButton("Browse", 	3, 45, 80, 20)
Global $input = GUICtrlCreateInput("music file", 3, 65, 190, 20)
Global $input2 = GUICtrlCreateInput("75", 85, 45, 108, 20)
Global $speeds = GUICtrlRead($input2)
GUICtrlCreateLabel("made for playable piano - gmtower.org", 3, 90, 300, 100)
GUICtrlSetState($input, 128)
GUICtrlSetState($input2, 128)
GUICtrlSetOnEvent($button, "browse")
GUISetState(@SW_SHOW, $hMainGUI)
AutoItSetOption("SendKeyDelay", 1)
AutoItSetOption("SendKeyDownDelay", 50)
AutoItSetOption("WinWaitDelay", 0)
AutoItSetOption("TrayIconHide",1)

Func _Continue()
    $binFlag = Not $binFlag
 EndFunc

While 1
    Sleep(100)
 WEnd

Func play()
   GUICtrlSetData($status, "Playing")
   $file = GUICtrlRead($input)
   $notes = FileRead($file)
   If StringCompare($notes,"") = 0 Then
	  MsgBox(0, "Error", "Invalid File / No notes detected")
   Else
   $response = MsgBox(4, "Notes", "These are the opening notes:" & @CRLF & @CRLF & StringLeft($notes, 20) & @CRLF & @CRLF & "These are the ending notes:" & @CRLF & @CRLF & StringRight($notes,10) & @CRLF & @CRLF & "Is this correct?")
   If $response = 6 Then
	  MsgBox(0, "OK!", "Ok, starting!")
   ;ProcessExists("hl2.exe")
   If (true) Then
   $notes = "[]" & StringRegExpReplace($notes, @crlf, " ") & "[]"
   $notes = StringRegExpReplace($notes, ":", "")
   $notes = StringRegExpReplace($notes, "<", "")
   $notes = StringRegExpReplace($notes, ">", "")
   $notes = StringRegExpReplace($notes, "{", "")
   $notes = StringRegExpReplace($notes, "}", "")
   $notes = StringRegExpReplace($notes, "\?", "")
   $chordArray = StringRegExp($notes, "\[(.*?)\]", 3)
   $chordAmount = UBound($chordArray) - 1;
   $notChordArray = StringRegExp($notes, "\](.*?)\[", 3)
   $notChordAmount = UBound($notChordArray) - 1
   For $i = 0 To $chordAmount Step +1
	  $speeds = GUICtrlRead($input2)
	  If $i <=$chordAmount Then
		 ToolTip($chordArray[$i],0,0)
		 Global $chordArrayUpper = StringRegExp($chordArray[$i],"([A-Z!-*\[\^@])", 3)
		 Global $chordArrayLower = StringRegExp($chordArray[$i],"([a-z0-9])", 3)
		 $chordAmountUpper = UBound($chordArrayUpper) - 1
		 $chordAmountLower = UBound($chordArrayLower) - 1
		 If $chordAmountUpper > -1 Then
			;WinActivate("Garry's Mod")
			For $j = 0 to $chordAmountUpper Step +1
			   ;WinActivate("Garry's Mod")
				  Send($chordArrayUpper[$j],1)
			Next
			;ControlSend("Garry's Mod","","","{SHIFTUP}")
		 EndIf
		 If $chordAmountLower > -1 Then
			For $j = 0 to $chordAmountLower Step +1
			   ;WinActivate("Garry's Mod")
			   ;ControlSend("Garry's Mod","","",$chordArrayLower[$j])
			   Send($chordArrayLower[$j],1)
			Next
		 EndIf
	  EndIf
	  Sleep($speeds-50)
	  If $i <=$notChordAmount Then
		 $notChordArray2 = StringRegExp($notChordArray[$i],".", 3)
		 $notChordAmount2 = UBound($notChordArray2) - 1
			For $j = 0 To $notChordAmount2 Step +1
			   $speeds = GUICtrlRead($input2)
			   ToolTip($notChordArray2[$j],0,0)
			   ;WinActivate("Garry's Mod")
				  ;ControlSend("Garry's Mod","","",$notChordArray2[$j])
				  Send($notChordArray2[$j],1)
			   Sleep($speeds-50)
			   ;ControlSend("Garry's Mod","","","{SHIFTUP}")
			Next
		 EndIf
	  Next
   Else
	  MsgBox(0,"Error","Garry's Mod is not running!")
   EndIf
   Else
   EndIf
   EndIf
   GUICtrlSetData($status, "Not Playing")
EndFunc

Func Browse()
   Global $fileLocation = FileOpenDialog ( "Select Music File", @WorkingDir & "\", "Text (*.txt)")
   if @error = 1 Then
   else
   GUICtrlSetData($input, $fileLocation)
   endif
EndFunc

Func Closebutton()
   Exit
EndFunc

Func Quersumme($zahl)
local $split=StringSplit($zahl,"")
$zahl=0
For $i=1 To UBound($split)-1
$zahl=$zahl+$split[$i]
Next
return $zahl
EndFunc

Func NewSpeed()
   $newspeed = InputBox("New Speed", "Enter a new speed:", $speeds,"",100,130,Default,Default,100)
   If @error = 1 or @error = 2 or IsNumber($newspeed) = 1 then
   Else
   GUICtrlSetData($input2, $newspeed)
   EndIf
EndFunc

