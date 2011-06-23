; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2337&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 19. September 2003
; OS: Windows
; Demo: Yes

;- Window Constants 
#Window_Main = 0 

;- Gadget Constants 
#Gadget_Text = 0 
#Gadget_Ok   = 1 
#Gadget_Quit = 2 

;- Open Window 
If OpenWindow(#Window_Main, 429, 288, 160, 160, "TEST",  #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
  If CreateGadgetList(WindowID(#Window_Main)) 
    TextGadget(#Gadget_Text, 10, 10, 140, 80, Chr(13)+Chr(10)+"press Shortcut_Return"+Chr(13)+Chr(10)+"for Gadget_Ok"+Chr(13)+Chr(10)+""+Chr(13)+Chr(10)+"press Shortcut_Escape"+Chr(13)+Chr(10)+"for Gadget_Quit", #PB_Text_Center) 
    ButtonGadget(#Gadget_Ok, 10, 100, 140, 20, "Ok") 
    ButtonGadget(#Gadget_Quit, 10, 130, 140, 20, "Quit") 
  EndIf 
  
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Return,#Gadget_Ok) 
  AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Escape,#Gadget_Quit) 
  
  ;- Event Loop 
  Repeat 
    Event = WaitWindowEvent() 
    If Event = #PB_Event_Gadget Or Event = #PB_Event_Menu 
      Select EventGadget() 
        Case #Gadget_Ok 
          MessageRequester("TEST", "Shortcut_Return or Gadget_Ok has been pressed!", #PB_MessageRequester_Ok) 
        Case #Gadget_Quit 
          MessageRequester("TEST", "Shortcut_Escape or Gadget_Quit has been pressed!", #PB_MessageRequester_Ok) 
      EndSelect 
    ElseIf Event = #PB_Event_CloseWindow 
      End 
    EndIf 
  ForEver 
EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
