; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7330&highlight=
; Author: Nonproductive (updated for PB4.00 by blbltheworm)
; Date: 24. August 2003
; OS: Windows
; Demo: No


; PureBasic Visual Designer v3.72 


;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#AddURL = 0 
#ConnectURL = 1 
#DeleteURL = 2 
#SelectedURL = 3 
#ListURL = 4 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 0, 363, 434, "URL Manager",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ButtonGadget(#AddURL, 10, 400, 90, 30, "Add") 
      ButtonGadget(#ConnectURL, 260, 400, 90, 30, "Connect") 
      ButtonGadget(#DeleteURL, 260, 320, 90, 30, "Delete") 
      StringGadget(#SelectedURL, 10, 360, 340, 30, "") 
      ListViewGadget(#ListURL, 10, 10, 340, 300) 
      
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  
Event = WaitWindowEvent() 

If Event = #PB_Event_Gadget 
  GadgetID = EventGadget() 
  EvntT = EventType() 
  
If EvntT = #PB_EventType_Change And GadgetID = #SelectedURL 
  SelURL.s = GetGadgetText(#SelectedURL) 
  If SelURL.s <> "" 
    DisableGadget(#ConnectURL,0) 
    DisableGadget(#AddURL,0) 
    ;ConnectURL.Default=True    
  Else 
    DisableGadget(#ConnectURL,1) 
    DisableGadget(#AddURL,1) 
    ;ConnectURL.Default=False 
  EndIf 

ElseIf GadgetID = #ListURL 
    Result = GetGadgetState(#ListURL) 
    If Result <> -1 
    LstURL.s = GetGadgetText(#ListURL) 
    SetGadgetText(#SelectedURL,LstURL.s) 
    DisableGadget(#ConnectURL,0) 
    DisableGadget(#DeleteURL,0) 
    Else 
    DisableGadget(#DeleteURL,1) 
  EndIf 
  
ElseIf GadgetID = #AddURL 
      SelURL.s = GetGadgetText(#SelectedURL) 
      LstURL.s = GetGadgetText(#ListURL) 
      If SelURL.s <> LstURL.s 
        AddGadgetItem(#ListURL,-1,SelURL.s) 
      Else 
        MBResult = MessageRequester("Oops!","Please Enter a different URL Or email address.",#PB_MessageRequester_Ok) 
      EndIf 
      
ElseIf GadgetID = #ConnectURL 
      SelURL.s = GetGadgetText(#SelectedURL) 
      If SelURL.s <> "" 
      ShellExecute_(#Null,"open",SelURL,"","",#SW_SHOWNORMAL) 
      Else 
        MBResult = MessageRequester("Oops!","Please Enter a URL or email address.",#PB_MessageRequester_Ok) 
      EndIf 
      
ElseIf GadgetID = #DeleteURL 
      Result = GetGadgetState(#ListURL) 
      If Result <> -1 
        RemoveGadgetItem(#ListURL,Result) 
      Else 
        MBResult = MessageRequester("Oops!","Please select an item in the list.",#PB_MessageRequester_Ok) 
      EndIf 

EndIf 
EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
