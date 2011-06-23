; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8607&highlight=
; Author: PB (updated for PB4.00 by blbltheworm)
; Date: 04. December 2003
; OS: Windows
; Demo: Yes

; PureBasic doesn't (yet) support the SHEmptyRecycleBin() API (probably 
; due to Windows 95/NT not supporting it). However, using the OpenLibrary 
; functions you can pretty much use any API you want (even if PureBasic 
; doesn't support it), so here's an example of emptying the Recycle Bin: 

Procedure EmptyTrash(confirm) 
  If OpenLibrary(0,"shell32.dll") And GetFunction(0,"SHEmptyRecycleBinA") 
    CallFunction(0,"SHEmptyRecycleBinA",0,"",1-confirm) 
    CloseLibrary(0) 
  EndIf 
EndProcedure 

EmptyTrash(1) ; 1 = confirm with user first, 0 = don't confirm. 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
