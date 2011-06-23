; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1389&highlight=
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 17. June 2003
; OS: Windows
; Demo: No

; Windows only
; This code uses the cards.dll from the windows-systemdrawer. 
; feel free to create you own blackjack now 

Procedure CardDraw(hdc,NR,X,Y,X2,Y2) 
Result=OpenLibrary(1,"cards.dll") 
If Result 
  cdtInit=GetFunction(1,"cdtInit") 
  cdtDrawExt=GetFunction(1,"cdtDrawExt") 
  cdtTerm=GetFunction(1,"cdtTerm") 
EndIf 
Result=CallFunctionFast(cdtInit,@w,@h) 
Result=CallFunctionFast(cdtDrawExt,hdc,X,Y,X2,Y2,NR,0,0) 
Result= CallFunctionFast(cdtTerm) 
CloseLibrary(1) 
EndProcedure 

If OpenWindow(0, 0, 0, 400, 300, "click this window to draw a card ", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget|#PB_Window_TitleBar) 
    Repeat 
        ev.l = WaitWindowEvent() 
        If ev=513 
             Beep_(100,100)      
             hdc.l = StartDrawing(WindowOutput(0)) 
             CardDraw(hdc,Random(60),WindowMouseX(0),WindowMouseY(0),80,100) 
             StopDrawing() 
        EndIf 
    Until ev=#PB_Event_CloseWindow 
EndIf 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
