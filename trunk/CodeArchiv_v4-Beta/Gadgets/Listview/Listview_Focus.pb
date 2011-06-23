; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 11. March 2003
; OS: Windows
; Demo: Yes

#ListView = 1

Procedure WindowCallback(Window.l, Message.l, wParam.l, lParam.l)
  result = #PB_ProcessPureBasicEvents
  
  If Message = #WM_COMMAND
  
    If wParam>>16 = #LBN_SETFOCUS And lParam = GadgetID(#ListView)
    
      AddGadgetItem(#ListView, -1, "got focus!")
      
    ElseIf wParam>>16 = #LBN_KILLFOCUS And lParam = GadgetID(#ListView)
    
      AddGadgetItem(#ListView, -1, "lost focus!")
    
    EndIf

  
  EndIf
  
  ProcedureReturn result
EndProcedure




OpenWindow(0,0,0,500,500, "ListView Focus",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
CreateGadgetList(WindowID(0))

ListViewGadget(#ListView, 100, 100, 200, 200)
AddGadgetItem(#ListView,-1,"Listview, click to get Focus")

StringGadget(0,100,350,250,25,"Click here to get focus from ListView")

SetWindowCallback(@WindowCallback())

While WaitWindowEvent() <> #PB_Event_CloseWindow: Wend
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -