; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14367&highlight=
; Author: Henrik (updated for PB 4.00 by Andre)
; Date: 13. March 2005
; OS: Windows
; Demo: No

Enumeration
#Window_0
EndEnumeration

Enumeration
#Panel_0
EndEnumeration

Global PHwnd.l,Number.l
Number.l=0

Procedure WNDENUMPROC (Hwnd, LPARAM)
  Debug Hwnd
  Debug "-----"
  
  SetGadgetItemText(#Panel_0,Number.l, "Tab_Hnd: = "+Str(Hwnd),0)
  Number.l+1
  
  EnumChildWindows_(Hwnd, @WNDENUMPROC(), LPARAM+1)
  
  ProcedureReturn #True
EndProcedure


Procedure Open_Window_0()
  If OpenWindow(#Window_0, 275, 258, 600, 300, "Tab", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
    If CreateGadgetList(WindowID(#Window_0))
      
      ;- Panel0
      PHwnd=PanelGadget(#Panel_0, 60, 40, 435, 200)
      AddGadgetItem(#Panel_0, -1, "Tab 1")
      AddGadgetItem(#Panel_0, -1, "Tab 2")
      AddGadgetItem(#Panel_0, -1, "Tab 3")
      CloseGadgetList()
      
    EndIf
  EndIf
EndProcedure


Open_Window_0()
EnumChildWindows_( PHwnd, @WNDENUMPROC(), 0)


Repeat
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget
    ;Debug "WindowID: " + Str(EventWindowID())
    
    GadgetID = EventGadget()
    If GadgetID = #Panel_0
      ; Debug "GadgetID: #Panel_0"
    EndIf
    
  EndIf
Until Event = #PB_Event_CloseWindow

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP