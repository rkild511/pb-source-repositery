; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB3.93 by ts-soft)
; Date: 22. November 2003
; OS: Windows
; Demo: No

Global Mem.l 
; hier werden 1024 byte speicher reserviert 
Mem = AllocateMemory(1024) 

Procedure.l DesktopOutput() 
  PokeL(Mem, 1) 
  ProcedureReturn Mem 
EndProcedure 

Maus.Point 

Repeat 
  ; hier werden die maus koordinaten ausgelesen 
  GetCursorPos_(Maus) 
  ; 
  ; hier beginnt die verwirrung 
  StartDrawing(DesktopOutput()) 
    Plot(Maus\x, Maus\y, $0000FF) 
  StopDrawing() 
  ; 
  ; delay für cpu entlastung 
  Delay(5) 
  ; hier wird die escape taste geprüft 
  If GetAsyncKeyState_(#VK_ESCAPE) 
    Quit = 1 
  EndIf 
  
Until Quit 
InvalidateRect_(0, 0, 0) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -