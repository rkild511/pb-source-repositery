; German forum: http://www.purebasic.fr/german/viewtopic.php?t=325&highlight=
; Author: Kiffi (updated for PB 4.00 by Andre)
; Date: 03. October 2004
; OS: Windows
; Demo: No


; VB's RaiseEvent as PureBasic code...
Enumeration 
  #frmMain 
EndEnumeration 

Enumeration 
  #cmdLos 
  #lstOutput 
EndEnumeration 

#WM_APP = $8000 

Procedure myEvent() 
  PostMessage_(WindowID(#frmMain), #WM_APP,0,0) 
  PostMessage_(WindowID(#frmMain), #WM_APP + 1,0,0) 
EndProcedure 

If OpenWindow(#frmMain, 0, 0, 300, 150, "RaiseEvent-Test", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(#frmMain)) 
    ListViewGadget(#lstOutput,10,10,280,100) 
    ButtonGadget(#cmdLos,10,120,90,20,"Los!") 
    Repeat 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow 
          Break 
        Case #PB_Event_Gadget 
          Select EventGadget() 
            Case #cmdLos 
              myEvent() 
          EndSelect 
        Case #WM_APP 
          AddGadgetItem(#lstOutput,-1,"#WM_App erhalten") 
        Case #WM_APP + 1 
          AddGadgetItem(#lstOutput,-1,"#WM_App+1 erhalten") 
      EndSelect 
      Delay(1) 
    ForEver 
  EndIf 
  CloseWindow(#frmMain) 
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -