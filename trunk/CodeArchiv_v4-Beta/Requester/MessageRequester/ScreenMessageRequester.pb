; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2826&start=10
; Author: Stefan Moebius (updated for PB4.00 by blbltheworm)
; Date: 05. December 2003
; OS: Windows
; Demo: No


; Doesn't work with all gfx cards!
; Funktioniert nicht mit allen Grafikkarten!

InitSprite()

Procedure GetDDrawBase()
  !EXTRN _PB_DDrawBase
  !MOV Eax,[_PB_DDrawBase]
  ProcedureReturn
EndProcedure



Procedure ScreenMessageRequester(Title$,Text$,Flag)
  CallFunctionFast(PeekL(PeekL(GetDDrawBase())+40),GetDDrawBase());FlipToGDISurface
  ShowCursor_(-1)
  Result=MessageBox_(ScreenID(),Text$,Title$,Flag)
  ShowCursor_(0)
  ProcedureReturn Result
EndProcedure



OpenScreen(1024,768,16,"ScreenMessageRequester")

Start=GetTickCount_()
Repeat
  ClearScreen(RGB(128,128,128))
  FlipBuffers()
  If GetTickCount_()-Start>3000
    Start=GetTickCount_()
    If ScreenMessageRequester("???","Beenden ?",#MB_YESNO)=#IDYES:End:EndIf
  EndIf
ForEver

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
