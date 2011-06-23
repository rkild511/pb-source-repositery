; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3111&highlight=
; Author: bossi  (based on Fred's ComboBox_OwnerDrwan.pb example, adapted image paths + sizes by Andre)
; Date: 12. December 2003
; OS: Windows
; Demo: No

Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #Gadget_1 
EndEnumeration 

#DI_NORMAL = $0003 

; Load Icons / Icons laden
LoadImage(0, "..\..\Graphics\Gfx\cube16.ico") 
LoadImage(1, "..\..\Graphics\Gfx\tool16.ico") 
LoadImage(2, "..\..\Graphics\Gfx\help16.ico") 

Procedure WindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
  Select Message 
    Case #WM_DRAWITEM 
      *DrawItem.DRAWITEMSTRUCT = lParam 
      If *DrawItem\CtlType = #ODT_COMBOBOX 
        If *DrawItem\itemID <> -1 
          Text$ = Space(512)
          DrawIconEx_(*DrawItem\hDC, *DrawItem\rcItem\left   , *DrawItem\rcItem\top+1, ImageID(*DrawItem\itemID) , 16, 16, 0, 0, #DI_NORMAL) 
        EndIf 
      EndIf 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 

If OpenWindow(#Window_0, 0, 0, 400, 100, "Combobox - own icons", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
  If CreateGadgetList(WindowID(#Window_0)) 
    ComboBoxGadget(#Gadget_1, 60, 40, 50, 200, #CBS_OWNERDRAWFIXED) 
      AddGadgetItem(#Gadget_1, -1, "") 
      AddGadgetItem(#Gadget_1, -1, "") 
      AddGadgetItem(#Gadget_1, -1, "") 
  EndIf 
EndIf 

SetWindowCallback(@WindowCallback()) 
  
Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
