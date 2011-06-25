;*****************************************************************************
;*
;* PurePunch Contest #3
;*
;* Name     : "Help MSDOS " Aide Msdos a la demande
;* Author   :Dobro
;* Category : UTIL
;* Date     : 16 / 07 / 09
;*
;*****************************************************************************
OpenWindow(1,10,10,500,500,"aide Dos"):EditorGadget(1,10,10,490,430,2048)
StringGadget(2,10,450,50,20,"dir"):ButtonGadget(3,80,450,30,20,"Doc")
c$="dir":Repeat:Event= WaitWindowEvent():Select Event:Case  13100:h$=""
Select EventGadget():Case 2:c$=GetGadgetText(2):Case 3:ClearGadgetItems(1)
AddGadgetItem(1, -1,c$):p=RunProgram("cmd.exe","/c "+c$+"/?", "",30):If p:
While ProgramRunning(p):h$+ReadProgramString(p)+#LF$:OemToChar_(@h$,@h$):Wend:
EndIf:SetGadgetText(1,h$):CloseProgram(p):EndSelect:EndSelect:Until Event=16

; IDE Options = PureBasic 4.31 (Windows - x86)
; CursorPosition = 12
; DisableDebugger