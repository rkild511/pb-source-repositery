; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9063&highlight=
; Author: Bong-Mong
; Date: 07. January 2004
; OS: Windows
; Demo: No


; Need the SkinWin userlib by Danilo, can be found on PureArea.net !
; Note: SkinWin is now included in the PBOSL userlib package

;-----Colour Trackbar Example-----
;-----User BongMong----
;-----07/01/04----

Global  purple
purple=CreateSolidBrush_(RGB($67,$32,$98))

Enumeration
#Window_0 = 1
EndEnumeration

Enumeration
#Gadget_0
EndEnumeration

Procedure myCallback(WindowID, Message, wParam, lParam)
  Result = #PB_ProcessPureBasicEvents
  Select Message
  Case #WM_CTLCOLORSTATIC
    Select lParam
    Case GadgetID(#Gadget_0)
      SetBkMode_(wParam,#TRANSPARENT)
      SetTextColor_(wParam, $FFFFFF)
      Result = purple
    EndSelect
  EndSelect
  ProcedureReturn Result
EndProcedure

hWnd = OpenWindow(1, 278, 107, 351, 261, "BongMong",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar )
If hWnd
  SetWinBackgroundColor(hWnd, RGB($67,$32,$98))
  SetForegroundWindow_(hWnd)
  SetWindowCallback(@myCallback())
  
  If CreateGadgetList(WindowID(1))
    TrackBarGadget(#Gadget_0, 20, 230, 130, 20, 0, 100)
    ResizeGadget(#Gadget_0,#PB_Ignore,#PB_Ignore, 130, 19)
    
    Repeat
      
      Event = WaitWindowEvent()
      
      If Event = #PB_Event_Gadget
        
        GadgetID = EventGadget()
        
      EndIf
      
    Until Event = #PB_Event_CloseWindow
  EndIf
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
