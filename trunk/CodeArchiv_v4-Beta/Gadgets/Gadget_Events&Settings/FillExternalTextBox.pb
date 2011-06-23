; German forum: http://www.purebasic.fr/german/viewtopic.php?t=875&start=10
; Author: bobobo (updated for PB 4.00 by Andre)
; Date: 15. November 2004
; OS: Windows
; Demo: No



;- Window Constants
;
Enumeration
  #Window_0
  #Window_1
  #Button_0
  #Button_1
  #String_0
  #Button_2
EndEnumeration

Global win1,win2

If OpenWindow(#Window_0, 216, 0, 600, 300, "Application", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  win1=WindowID(#WIndow_0)
  If CreateGadgetList(WindowID(#WIndow_0))
    ButtonGadget(#Button_0, 0, 0, 170, 110, "FillTextBox")
    ButtonGadget(#Button_1, 170, 0, 170, 110, "Schluss nun")
  EndIf
EndIf
If OpenWindow(#Window_1, 410, 159, 295, 216, "TextBoxWindow", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar, win1)
  win2=WindowID(#WIndow_1)
  If CreateGadgetList(WindowID(#Window_1))
    StringGadget(#String_0, 0, 0, WindowWidth(#Window_1), WindowHeight(#Window_1)-20, "")
    ButtonGadget(#Button_2, 0, WindowHeight(#Window_1)-20, WindowWidth(#Window_1), 20, "Anderes An-Aus",#PB_Button_Toggle)
  EndIf
EndIf

HideWindow(#Window_0,0)
Repeat
  Event = WaitWindowEvent()
  If Event = #PB_Event_Gadget
    ;Debug "WindowID: " + Str(EventWindowID())
    GadgetID = EventGadget()
    If GetGadgetState(#button_2)=1
      HideWindow(#window_0,1)
    Else
      HideWindow(#window_0,0)
    EndIf
    If GadgetID = #Button_1
      End
    EndIf
    If GadgetID = #Button_0
      Debug "GadgetID: #Button_0"
      SetActiveWindow(#Window_1)
      text.s=""
      For i=1 To 20
        text+Chr(Random(24)+97)
        SetGadgetText(#String_0,text)
      Next i
    ElseIf GadgetID = #String_0
      Debug "GadgetID: #String_0"
    EndIf
  EndIf
Until Event = #PB_Event_CloseWindow
End
;

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP