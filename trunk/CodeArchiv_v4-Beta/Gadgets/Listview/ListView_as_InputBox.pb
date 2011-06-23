; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7186&highlight=
; Author: Kale (updated for PB4.00 by blbltheworm)
; Date: 11. September 2003
; OS: Windows
; Demo: No

#Window_0 = 0 

#Gadget_0 = 0 
#Gadget_1 = 1 
#Gadget_2 = 2 


Procedure AddText() 
    exsistingText.s = GetGadgetText(#Gadget_0) 
    If exsistingText = "" 
        SetGadgetText(#Gadget_0, GetGadgetText(#Gadget_1)) 
    Else 
        SetGadgetText(#Gadget_0, exsistingText + Chr(13) + Chr(10) + GetGadgetText(#Gadget_1)) 
    EndIf 
    lines = SendMessage_(GadgetID(0),#EM_GETLINECOUNT,0,0) 
    SendMessage_(GadgetID(#Gadget_0), #EM_LINESCROLL, 0, lines) 
EndProcedure 

  If OpenWindow(#Window_0, 338, 281, 439, 254, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      StringGadget(#Gadget_0, 5, 5, 430, 210, "", #ES_MULTILINE | #ES_AUTOVSCROLL | #ES_AUTOHSCROLL | #WS_VSCROLL | #WS_HSCROLL | #PB_String_ReadOnly) 
      StringGadget(#Gadget_1, 5, 225, 345, 21, "") 
      ButtonGadget(#Gadget_2, 358, 222, 77, 25, "Enter >>>") 
      
    EndIf 
  EndIf 

Repeat 
  Event = WaitWindowEvent() 
  
  Select Event 
    Case #PB_Event_Gadget 
        Select EventGadget() 
            Case #Gadget_2 
                AddText() 
        EndSelect 
  EndSelect 

Until Event = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
