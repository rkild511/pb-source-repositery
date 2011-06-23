; German Forum:
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 13. October 2002
; OS: Windows
; Demo: No


Global hwnd.l,Listbox.l,TopIndex.l 
hwnd = OpenWindow(0,0,0,640,480, "Testfenster", #PB_Window_SizeGadget|#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 
If hwnd 
If CreateGadgetList(hwnd) 
Listbox = ListIconGadget(0,10,10, 300, 300, "Test" ,280,0) 
For I = 1 To 1000 
  AddGadgetItem(0,-1,"") 
  SetGadgetItemText(0, I-1, "Test"+Str(I), 0) 
Next I 
    TopIndex = 300 
    SendMessage_(Listbox,#LVM_GETITEMRECT,0,r.Rect) 
    SendMessage_(Listbox,#LVM_SCROLL,0,((r\bottom - r\top)*(TopIndex-1))) 
EndIf    

  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow 
      Quit = 1 
    EndIf 
  Until Quit =1 
  
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -