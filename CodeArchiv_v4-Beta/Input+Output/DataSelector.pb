; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2938&postdays=0&postorder=asc&start=0
; Author: bobobo (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: Yes

#Window_0       = 0 
#Button_weniger = 2 
#Button_mehr    = 3 
#Combo=4 

OpenWindow(#Window_0, 279, 160, 180, 70, "Test", #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#Window_0)) 
ButtonGadget(#Button_weniger, 10, 10, 60, 20, "weniger") 
ButtonGadget(#Button_mehr, 75, 10, 60, 20, "mehr") 
ComboBoxGadget(#Combo,5,35, 170,200) 
AddGadgetItem(#Combo, -1, "Elfriede - 030-123456789") 
AddGadgetItem(#Combo, -1, "Erna - 030-123456789") 
AddGadgetItem(#Combo, -1, "Arbeit - 030-123456789") 
AddGadgetItem(#Combo, -1, "Kneipe - 030-123456789") 
AddGadgetItem(#Combo, -1, "unterm_Tisch - 030-1236789") 


SetGadgetState(#Combo,0) 

Repeat 
  EventID = WindowEvent() 
  If EventID = #PB_Event_Gadget 
    GEID = EventGadget() 
    altWert = wert 
    If GEID = #Button_weniger : wert-100 : EndIf 
    If GEID = #Button_weniger :SetGadgetState(#Combo,GetGadgetState(#Combo)-1 ):EndIf 
    If GEID = #Button_mehr : wert+100 : EndIf 
    If GEID = #Button_mehr :SetGadgetState(#Combo,GetGadgetState(#Combo)+1 ):EndIf 
    If GetGadgetState(#Combo)<0 : SetGadgetState(#Combo,0):EndIf 
  EndIf 
Until EventID = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
