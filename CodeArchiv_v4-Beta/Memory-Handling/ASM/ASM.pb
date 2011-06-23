; www.purearea.net
; Author: Unknown
; Date: 31. December 2002
; OS: Windows
; Demo: Yes


; Inline-ASM
wert.l = 12 
MOV wert, 85 
MessageRequester("Info", StrU(wert,2), 0) 

; Direkt-FASM
wert.l = 12
!MOV dword [v_wert], 85        ; Beachten Sie das "!" am Anfang der Zeile
MessageRequester("Info", StrU(wert,2), 0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm