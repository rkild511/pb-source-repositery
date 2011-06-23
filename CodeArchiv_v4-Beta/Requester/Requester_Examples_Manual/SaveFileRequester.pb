; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 13. May 2003
; OS: Windows
; Demo: Yes

StandardFile$ = "C:\autoexec.bat"   ; set initial file+path to display
; With next string we will set the search patterns ("|" as separator) for file displaying:
;  1st: "Text (*.txt)" as name, ".txt" and ".bat" as allowed extension
;  2nd: "PureBasic (*.pb)" as name, ".pb" as allowed extension
;  3rd: "All files (*.*) as name, "*.*" as allowed extension, valid for all files
Pattern$ = "Text (*.txt)|*.txt;*.bat|PureBasic (*.pb)|*.pb|All files (*.*)|*.*"
Pattern = 0    ; use the first of the three possible patterns as standard
File$ = SaveFileRequester("Please choose file to save", StandardFile$, Pattern$, Pattern)
If File$
  MessageRequester("Information", "You have selected following file:"+Chr(10)+File$, 0)
Else
  MessageRequester("Information", "The requester was canceled.", 0) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -