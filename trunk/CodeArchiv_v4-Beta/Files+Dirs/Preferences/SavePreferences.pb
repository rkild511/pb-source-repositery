; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2316
; Author: nco2k  (fixed by Danilo, updated for PB4.00 by blbltheworm)
; Date: 17. September 2003
; OS: Windows
; Demo: Yes


;- Window Constants 
; 
#Window_Main = 0 

;- Gadget Constants 
; 
#Gadget_Trackbar0 = 0 
#Gadget_Option0 = 1 
#Gadget_Option1 = 2 
#Gadget_Option2 = 3 
#Gadget_Text0 = 4 
#Gadget_Button0 = 5 

;- Open Window 
; 
If OpenWindow(#Window_Main, 0, 0, 200, 200, "BLABLA", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(#Window_Main)) 
    TrackBarGadget(#Gadget_Trackbar0, 50, 40, 100, 20, 0, 4, #PB_TrackBar_Ticks) 
    OptionGadget(#Gadget_Option0, 50, 100, 60, 20, "Option0") 
    OptionGadget(#Gadget_Option1, 50, 125, 60, 20, "Option1") 
    OptionGadget(#Gadget_Option2, 50, 150, 60, 20, "Option2") 
    TextGadget(#Gadget_Text0, 160, 40, 30, 20, "") 
    ButtonGadget(#Gadget_Button0, 150, 175, 45, 20, "Save") 
  EndIf 
  
  ;- Preferences 
  ; 
  If OpenPreferences("Test.pref") 
    PreferenceGroup("Group0") 
      SetGadgetState(#Gadget_Trackbar0, Val(ReadPreferenceString("Track", "0"))) 
      SetGadgetText(#Gadget_Text0, Str(GetGadgetState(#Gadget_Trackbar0)*25)+" %") 
    PreferenceGroup("Group1") 
      SetGadgetState(#Gadget_Option0 +Val(ReadPreferenceString("Option", "0")), 1) 
    ClosePreferences() 
  Else 
    MessageRequester("BLABLA", "Test.pref is missing!", #PB_MessageRequester_Ok) 
  EndIf 
  
  ;- Event Loop 
  ; 
  Repeat 
    event = WaitWindowEvent() 
    If event = #PB_Event_Gadget 
      If EventGadget() = #Gadget_Button0 
        If CreatePreferences("Test.pref") 
          PreferenceGroup("Group0") 
            WritePreferenceString("Track", Str(GetGadgetState(#Gadget_Trackbar0))) 
          PreferenceGroup("Group1") 
            For a = #Gadget_Option0 To #Gadget_Option2 
              If GetGadgetState(a) 
                WritePreferenceString("Option", Str(a-#Gadget_Option0)) 
                ;WritePreferenceLong("Option", a-#Gadget_Option0) 
              EndIf 
            Next a 
          ClosePreferences() 
        EndIf 
        End 
      EndIf 
      If EventGadget() = #Gadget_Trackbar0 
        SetGadgetText(#Gadget_Text0, Str(GetGadgetState(#Gadget_Trackbar0)*25)+" %") 
      EndIf 
    EndIf 
  Until event = #PB_Event_CloseWindow 
EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
