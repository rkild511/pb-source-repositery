; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8674&highlight=
; Author: Fred
; Date: 09. December 2003
; OS: Windows
; Demo: No


; ComboBox OwnerDraw in PureBasic 
; 

Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #Gadget_0 
EndEnumeration 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 0, 0, 400, 100, "ComboBox OwnerDraw", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ComboBoxGadget(#Gadget_0, 60, 40, 330, 200,  #CBS_OWNERDRAWFIXED) 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

#DI_NORMAL = $0003 

Procedure WindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 

  Select Message 

    Case #WM_DRAWITEM 
      *DrawItem.DRAWITEMSTRUCT = lParam 
      
      If *DrawItem\CtlType = #ODT_COMBOBOX 
        SetBkMode_(*DrawItem\hDC, #TRANSPARENT) ; Text is rendered transparent 
        
        If *DrawItem\ItemState & #ODS_FOCUS 
          Brush = CreateSolidBrush_($FFEEFF) 
          FillRect_(*DrawItem\hDC, *DrawItem\rcItem, Brush) 
          DeleteObject_(Brush) 
          
          SetTextColor_(*DrawItem\hDC, $FF) 
        Else 
          FillRect_(*DrawItem\hDC, *DrawItem\rcItem, GetStockObject_(#WHITE_BRUSH)) 
        EndIf 

        If *DrawItem\itemID <> -1 
          Text$ = Space(512) 
          SendMessage_(*DrawItem\hwndItem, #CB_GETLBTEXT, *DrawItem\itemID, @Text$) 
          
          DrawIconEx_(*DrawItem\hDC, *DrawItem\rcItem\left+2   , *DrawItem\rcItem\top+1, LoadIcon_(0, #IDI_ASTERISK), 16, 16, 0, 0, #DI_NORMAL) 
          TextOut_   (*DrawItem\hDC, *DrawItem\rcItem\left+2+20, *DrawItem\rcItem\top+1, Text$, Len(Text$)) 
        EndIf 
      EndIf 
  
  EndSelect 
  
  ProcedureReturn Result 
EndProcedure 


SetWindowCallback(@WindowCallback()) 

  AddGadgetItem(#Gadget_0, -1, "Test1") 
  AddGadgetItem(#Gadget_0, -1, "Test2") 
  AddGadgetItem(#Gadget_0, -1, "Test3") 
  
Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
