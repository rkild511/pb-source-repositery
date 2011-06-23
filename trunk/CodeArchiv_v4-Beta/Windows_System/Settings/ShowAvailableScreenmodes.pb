; German forum: http://www.purebasic.fr/german/viewtopic.php?t=498&highlight=
; Author: ChaOsKid (updated for PB 4.00 by Andre)
; Date: 18. October 2004
; OS: Windows
; Demo: Yes

Enumeration 
  #Combo_0 
  #Radio_0 
  #Radio_1 
  #Button_0 
EndEnumeration 

Structure ScreenModes 
  width.l 
  height.l 
  depth.l 
  refreshrate.l 
EndStructure 

Global NewList ScreenModes.ScreenModes() 

Procedure AddScreenModes(depth.l) 
  ClearGadgetItemList(#Combo_0) 
  ForEach ScreenModes() 
    If ScreenModes()\depth = depth And ScreenModes()\width >= 640 
      AddGadgetItem(#Combo_0, -1, Str(ScreenModes()\width)+" x "+Str(ScreenModes()\height)+" x "+Str(ScreenModes()\depth)+" ("+Str(ScreenModes()\refreshrate)+" Hz)") 
    EndIf 
  Next 
  SetGadgetState(#Combo_0,0) 
EndProcedure 

#Title = "Test" 
If InitSprite() = #False Or OpenWindow(0, 0, 0, 210, 90, #Title, #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
  If CreateGadgetList(WindowID(0)) 
    ComboBoxGadget(#Combo_0, 5, 5, 200, 143) 
    OptionGadget(#Radio_0, 10, 35, 60, 20, "16 Bit") 
    SetGadgetState(#Radio_0, 1) 
    OptionGadget(#Radio_1, 140, 35, 60, 20, "32 Bit") 
    ButtonGadget(#Button_0, 5, 60, 200, 25, "Exit") 
  EndIf 
Else 
  MessageRequester(#Title, "Error", #MB_OK | #MB_ICONERROR) 
EndIf 

If ExamineScreenModes() 
  While NextScreenMode() 
    AddElement(ScreenModes()) 
    ScreenModes()\width = ScreenModeWidth() 
    ScreenModes()\height = ScreenModeHeight() 
    ScreenModes()\depth = ScreenModeDepth() 
    ScreenModes()\refreshrate = ScreenModeRefreshRate() 
  Wend 
  AddScreenModes(16) 
EndIf 


Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Radio_0 
          ;zeige nur 16 Bit auflösungen <--- 
          AddScreenModes(16) 
        Case #Radio_1 
          ClearGadgetItemList(#Combo_0) 
          ;zeige nur 32 Bit auflösungen <--- 
          AddScreenModes(32) 
        Case #Button_0 
          End 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP