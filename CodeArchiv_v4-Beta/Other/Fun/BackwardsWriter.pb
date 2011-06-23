; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2705&highlight=
; Author: wichtel (updated for PB 4.00 by Andre)
; Date: 31. October 2003
; OS: Windows
; Demo: No

;- Window Constants 
; 
Enumeration 
  #window 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #forward 
  #reverse 
EndEnumeration 

;- Fonts 
; 
Global FontID1 
FontID1 = LoadFont(1, "Comic Sans MS", 26) 

;- Colors 
Global background, textground 
    background = CreateSolidBrush_($00AAFF) 
    textground = CreateSolidBrush_($880000) 
    

;- Functions 

Procedure myCallback(WindowID, Message, wParam, lParam) ; for coloring as well 
  GUIResult = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_CTLCOLOREDIT 
;       Select lParam 
;         Case GadgetID(#forward) 
          SetTextColor_(wParam, $00FF00) 
          SetBkMode_(wParam,#TRANSPARENT) 
          GUIResult = textground 
;      EndSelect 
    Case #WM_CTLCOLORSTATIC 
;       Select lParam 
;         Case GadgetID(#reverse) 
          SetTextColor_(wParam, $0000FF) 
          SetBkMode_(wParam,#TRANSPARENT) 
          GUIResult = textground 
      EndSelect 
      
;  EndSelect 
  ProcedureReturn GUIResult 
EndProcedure 

Procedure Window() 
  If OpenWindow(#window, 399, 297, 640, 180, "Rückwärtsschreiber", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(#window)) 
      StringGadget(#forward, 20, 20, 600, 60, "", #PB_String_BorderLess) 
      GadgetToolTip(#forward, "Hier kannst du was schreiben.") 
      SetGadgetFont(#forward, FontID1) 
      StringGadget(#reverse, 20, 100, 600, 60, "", #PB_String_BorderLess|#PB_String_ReadOnly) 
      GadgetToolTip(#reverse, "Und hier steht es rückwärts.") 
      SetGadgetFont(#reverse, FontID1) 
    EndIf 
    SetClassLong_(WindowID(#window), #GCL_HBRBACKGROUND, background) 
    InvalidateRect_(WindowID(#window), #Null, #True) 
    SetWindowCallback(@myCallback()) 
  EndIf 
EndProcedure 



;- Main 
Window() 
SetActiveGadget(#forward) 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
    ;Debug "WindowID: " + Str(EventWindowID()) 
    GadgetID = EventGadget() 
    If GadgetID = #forward 
      forward$=GetGadgetText(#forward) 
      reverse$="" 
      flen=Len(forward$) 
      For c=flen To 1 Step -1 
        reverse$+Mid(forward$,c,1) 
      Next c  
      SetGadgetText(#reverse,reverse$) 
    EndIf 
  EndIf 
  
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
