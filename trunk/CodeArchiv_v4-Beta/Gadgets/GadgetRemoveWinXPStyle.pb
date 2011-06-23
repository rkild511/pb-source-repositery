; English forum: 
; Author: Denis (updated for PB 4.00 by Andre)
; Date: 27. October 2004
; OS: Windows
; Demo: No


; Remove Windows XP style from gadget

Enumeration 
  #Window 
  #ProgressBar1 
  #OptionGadget1 
  #OptionGadget2 
  #UxTheme_dll 
EndEnumeration 

If OpenWindow(Window, 300, 500, 360, 150, "  XP Styles or Not", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  
  If CreateGadgetList(WindowID(Window)) 
    ProgressBarGadget(#ProgressBar1, 50, 60, 99, 11, 0, 700) 
    OptionGadget(#OptionGadget1, 30, 15, 200, 18, "Try with XP style") 
    OptionGadget(#OptionGadget2, 30, 95, 200, 18, "Try without XP style") 

     Result = OpenLibrary(#UxTheme_dll,"UxTheme.dll") 
     If Result 
       ; here is the code to remove XP style 
        CallFunction(#UxTheme_dll, "SetWindowTheme",GadgetID(#ProgressBar1) , "", "") 
        CallFunction(#UxTheme_dll, "SetWindowTheme",GadgetID(#OptionGadget2) , "", "") 
        CloseLibrary(#UxTheme_dll) 
     EndIf 
      
    UpdateWindow_(WindowID(Window)) 
     For i.w = 1 To 700 
       SetGadgetState(#ProgressBar1, i) 
         Delay(1) 
     Next i 
    
    Repeat 
    Until WaitWindowEvent() = #PB_Event_CloseWindow 
    
  EndIf 
EndIf 
End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP