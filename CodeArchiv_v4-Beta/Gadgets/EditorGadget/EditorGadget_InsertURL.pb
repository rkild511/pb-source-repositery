; German forum: http://www.purebasic.fr/german/viewtopic.php?t=5&start=70
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 15. October 2004
; OS: Windows
; Demo: No


; an URL will be correctly inserted in the EditorGadget, but there
; isn't any event handling for it yet

#ENM_LINK = 4000000 
If OpenWindow(0,0,0,322,150,"EditorGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    handle=EditorGadget (0,8,8,306,133,#PB_Container_Raised) 
    mask=SendMessage_(handle,#EM_GETEVENTMASK,0,0) 
    SendMessage_(handle,#EM_SETEVENTMASK, 0, mask | #ENM_LINK) 
    SendMessage_(handle,#EM_AUTOURLDETECT,1,0) 
    
    AddGadgetItem(0,a,"http://www.falko-pure.de"+Chr(13)+Chr(10)) 
      
    Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
  EndIf 
  
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -