; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3280&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 31. December 2003
; OS: Windows
; Demo: No


; Create a start panel, move the mouse to the top of the desktop and the
; panel (with a button) appears...
; Erstellt eine Startleiste, bewegen Sie die Maus an den oberen Rand des
; Bildschirms und die Startleiste mit Schalter erscheint......

Global actmode,resux 
resux = GetSystemMetrics_(#SM_CXSCREEN) 

Procedure IsMouseOver(wnd) 
    GetWindowRect_(wnd,re.RECT) 
    GetCursorPos_(pt.POINT) 
    If actmode=0 
      If WindowFromPoint_(pt\x,pt\y)=wnd 
        result=1 
      EndIf 
      ;In der letzten Pixelzeile des Fensters sollte kein Gadget sein 
      ;Also von den 30 Pixeln nur die ersten 29 nutzen. 
    Else 
      result=PtInRect_(re,pt\x,pt\y) 
    EndIf 
    ProcedureReturn result 
EndProcedure 

Procedure CheckWindow(id) 
  wnd=WindowID(id) 
  inside=IsMouseOver(wnd) 
  actwindow=GetForegroundWindow_() 
  If inside 
    If actmode=0 
      actmode=1 : ResizeWindow(id,0,0,#PB_Ignore,#PB_Ignore) 
    EndIf 
  Else 
    If actmode=1 And actwindow<>wnd 
      actmode=0 
      For i=-1 To -29 Step -4 
        ResizeWindow(id,0,i,#PB_Ignore,#PB_Ignore):WindowEvent():Delay(20) 
      Next i 
    EndIf 
  EndIf 
  ProcedureReturn actmode  
EndProcedure 

OpenWindow(0, 0, -29, resux,30,"MouseOver",#PB_Window_BorderLess ) 
CreateGadgetList(WindowID(0)) 
ButtonGadget(0, resux-85, 5, 80, 20, "Beenden") 
SetForegroundWindow_(GetDesktopWindow_()) 
Repeat 
  event=WindowEvent() 
  If CheckWindow(0) And event 
    If event=#PB_Event_Gadget 
      Select EventGadget() 
        Case 0 
          End 
      EndSelect 
    EndIf 
  EndIf 
  Delay(4)    
ForEver 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
