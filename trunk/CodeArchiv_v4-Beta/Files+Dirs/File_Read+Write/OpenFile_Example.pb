; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5996&highlight=
; Author: wayne1 (updated for PB4.00 by blbltheworm)
; Date: 29. April 2003
; OS: Windows
; Demo: Yes

Procedure OFile(file.s) 
   d=ReadFile(1, file) 
    If d 
      While Eof(1)=0 
        Text$ = Text$+ReadString(1)+Chr(13)+ Chr(10) 
      Wend 
      CloseFile(1) 
      SetGadgetText(2, Text$) 
      Else 
      MessageRequester("Error","No valid file was selected.",#MB_ICONERROR) 
    EndIf 
EndProcedure 


If OpenWindow(0, 100, 200, 495, 260, "Open Small Files Example", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget) 

CreateGadgetList(WindowID(0)) 

ButtonGadget(1,210,20,80,25,"Open File") 
StringGadget(2,10,60,480,185,"",#ES_MULTILINE | #ES_AUTOVSCROLL|#WS_VSCROLL|#WS_HSCROLL) 

;TextGadget(2,10,60,480,185,"",#PB_Text_Border ) 

  Repeat 
    EventID.l = WaitWindowEvent() 
    If EventID = #PB_Event_CloseWindow  
      Quit = 1 
    EndIf 
    If EventID = #PB_Event_Gadget 
      Select EventGadget() 
        Case 1 
          file$ = OpenFileRequester("Open File","","All Files|*.*",1) 
          OFile(file$) 
      EndSelect 
    EndIf 
  Until Quit = 1 
  
EndIf 

End    

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
