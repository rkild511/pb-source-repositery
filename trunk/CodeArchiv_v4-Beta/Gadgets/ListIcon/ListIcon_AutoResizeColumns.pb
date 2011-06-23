; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1821&start=10
; Author: ChaOsKid (updated for PB 4.00 by Andre)
; Date: 29. January 2005
; OS: Windows
; Demo: No


Global Quit.l, Spaltenanzahl.l 
#LV_GADGET = 1 
;/ 
Procedure OpenMyWindow() 
  If OpenWindow(0, 0, 0, 600, 300, "ListView Column Resize", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(0)) 
      ListIconGadget(#LV_GADGET, 2, 2, 596, 296, "", 250, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines|#PB_ListIcon_AlwaysShowSelection) 
      Spaltenanzahl = 4 ; 
      For s = 1 To Spaltenanzahl 
        AddGadgetColumn(#LV_GADGET, s, "", 80) 
      Next 
    EndIf 
    ProcedureReturn 1 
  EndIf 
  ProcedureReturn 0 
EndProcedure 
;/ 
Procedure.l isVerticalScrollBarVisible(hwnd.l) 
  style.l = GetWindowLong_(hwnd, #GWL_STYLE) 
  If style & #WS_VSCROLL <> 0 
    ProcedureReturn 1 
  EndIf 
  ProcedureReturn 0 
EndProcedure 
;/ 
Procedure.l LVM_SetColumnWidth(GadgetID.l, Spalte.l, Breite.l) 
  ProcedureReturn SendMessage_(GadgetID(GadgetID), #LVM_SETCOLUMNWIDTH, Spalte, Breite) 
EndProcedure 
;/ 
Procedure.l LVM_GetColumnWidth(GadgetID.l, Spalte.l) 
  ProcedureReturn SendMessage_(GadgetID(GadgetID), #LVM_GETCOLUMNWIDTH, Spalte, 0) 
EndProcedure 
;/ 
Procedure ResizeListViewColums() 
  For s = 1 To Spaltenanzahl 
    Breite + LVM_GetColumnWidth(#LV_GADGET, s) 
  Next 
  Breite = GadgetWidth(#LV_GADGET) - Breite - 5 
  If isVerticalScrollBarVisible(GadgetID(#LV_GADGET)) 
    Breite - GetSystemMetrics_(#SM_CXVSCROLL) 
  EndIf 
  LVM_SetColumnWidth(#LV_GADGET, 0, Breite) 
EndProcedure 
;/ 
Procedure.l Events(event.l) 
  Select event 
    Case #PB_Event_SizeWindow 
      ResizeGadget(#LV_GADGET, #PB_Ignore, #PB_Ignore, WindowWidth(0)-5, WindowHeight(0)-5) 
      ResizeListViewColums() 
    Case #PB_Event_CloseWindow 
      Quit = 1 
  EndSelect 
  ProcedureReturn event 
EndProcedure 
;/ 
If OpenMyWindow() 
  For i = 0 To 20 
    AddGadgetItem(#LV_GADGET, -1, Str(i) + Chr(10) + "---" + Chr(10) + "---" + Chr(10) + "---" + Chr(10) + "---") 
  Next 
  Repeat 
    Events(WaitWindowEvent()) 
  Until Quit 
EndIf 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --