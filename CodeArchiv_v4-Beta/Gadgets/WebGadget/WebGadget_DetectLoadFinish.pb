; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2772&highlight=
; Author: freak (updated for PB4.00 by blbltheworm)
; Date: 10. November 2003
; OS: Windows
; Demo: No

; Loading of the WebGadget content is finished, when Isbusy = 0
If OpenWindow(0, 0, 0, 600, 600, "WebBrowser", #PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 

    WebGadget(0, 10, 10, 580, 555, "http://www.purebasic.com") 
    WebObject.IWebBrowser2 = GetWindowLong_(GadgetID(0), #GWL_USERDATA) 
    
    TextGadget(1, 10, 570, 100, 20, "", #PB_Text_Border) 
    
    Repeat 
      Event = WindowEvent() 
      
      
      WebObject\get_Busy(@IsBusy.l) 
      If IsBusy 
        SetGadgetText(1, "busy!") 
      Else 
        SetGadgetText(1, "not busy") 
      EndIf 
      
      
      If Event = 0 
        Delay(1) 
      EndIf 
    Until Event = #PB_Event_CloseWindow 

  EndIf 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
