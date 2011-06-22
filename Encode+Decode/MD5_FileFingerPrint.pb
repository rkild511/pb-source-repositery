; www.purearea.net (Sourcecode collection by cnesm)
; Author:
; Date: 22. November 2003


;- Window Constants 
; 
#Window0  = 0 

;- Gadget Constants 
; 
#W0_Button_Open = 0 
#W0_Text_Input = 1 
#W0_Text_Output1 = 2 
#W0_Button_Generate = 3 
#W0_Button_Cancel = 4 
#W0_Text_Output2 = 5 


Procedure Open_Window0() 
  If OpenWindow(#Window0 , 373, 329, 291, 171,  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar , "Mein lustiger MD5 - File Fingerprint") 
    If CreateGadgetList(WindowID()) 
      ButtonGadget(#W0_Button_Open, 240, 10, 40, 25, "..") 
      StringGadget(#W0_Text_Input, 10, 10, 210, 25, "") 
      StringGadget(#W0_Text_Output1, 10, 50, 270, 25, "", #PB_String_ReadOnly) 
      ButtonGadget(#W0_Button_Generate, 10, 130, 110, 30, "Generate") 
      ButtonGadget(#W0_Button_Cancel, 170, 130, 110, 30, "Cancel") 
      StringGadget(#W0_Text_Output2, 10, 90, 270, 25, "", #PB_String_ReadOnly)      
    EndIf 
  EndIf 
EndProcedure 

Open_Window0() 

Quit = 0 
Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_EventCloseWindow 
    Quit = 1 
  EndIf    
  If Event = #PB_EventGadget 
    Select EventGadgetID() 
      Case #W0_Button_Open: 
        SetGadgetText(#W0_Text_Input, OpenFileRequester("", "", "Alle Dateien | *.*", 0)) 
      Case #W0_Button_Generate: 
        SetGadgetText(#W0_Text_Output1,MD5FileFingerprint(GetGadgetText(#W0_Text_Input))) 
        SetGadgetText(#W0_Text_Output2,UCase(MD5FileFingerprint(GetGadgetText(#W0_Text_Input)))) 
      Case #W0_Button_Cancel: 
        Quit=1 
    EndSelect 
  EndIf 
Until Quit = 1 

; ExecutableFormat=Windows
; EnableXP
; DisableDebugger
; EOF