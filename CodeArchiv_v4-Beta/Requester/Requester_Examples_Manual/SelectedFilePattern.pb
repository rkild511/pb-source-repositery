; www.PureArea.net
; Author: Andre Beer / PureBasic Team
; Date: 24. May 2003
; OS: Windows
; Demo: Yes

StandardFile$ = "C:\autoexec.bat"        ; initial path + file
Pattern$ = "Text (*.txt)|*.txt;*.bat|"   ; set first pattern  (index = 0)
Pattern$ + "PureBasic (*.pb)|*.pb|"      ; set second pattern (index = 1)
Pattern$ + "Bmp (*.bmp)|*.bmp|"          ; set third pattern  (index = 2)
Pattern$ + "Jpeg (*.jpg)|*.jpg|"         ; set fourth pattern (index = 3)
Pattern$ + "All files (*.*)|*.*"         ; set fifth pattern  (index = 4)
Pattern = 2    ; use the second of the five possible patterns as standard

; Now we open a filerequester, you can change the pattern and will get the index after closing
File$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)
Index = SelectedFilePattern()
If Index > 0
  MessageRequester("Information", "Following pattern index was selected:"+Chr(10)+Str(Index), 0)
Else
  MessageRequester("Information", "The requester was canceled.", 0)
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -