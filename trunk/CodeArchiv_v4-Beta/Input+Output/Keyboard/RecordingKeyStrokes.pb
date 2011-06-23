; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13287&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 06. December 2004
; OS: Windows
; Demo: No


Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #String_0 
  #Text_0 
  #Text_1 
  #Text_2 
  #Text_3 
  #Text_4 
EndEnumeration 

Global OldCallback, key$, vk$ 
key$ = Space(255) 

Procedure String0_CallBack(hwnd, msg, wparam, lparam) 
  Select hwnd 
    Case GadgetID(#String_0) 
      gadID$ = "#String_0" 
      If wparam = #VK_TAB ; catch the tab key 
        GetKeyNameText_(lparam,key$,255) 
        SetGadgetText(#Text_2,  key$) 
        SetGadgetText(#Text_3, "") 
      EndIf 
  EndSelect 
  Select msg 
    Case #WM_KEYDOWN ; get the key pressed 
      GetKeyNameText_(lparam,key$,255) 
      SetGadgetText(#Text_2, key$) 
      SetGadgetText(#Text_3, "") 
    Case #WM_CHAR ; display valid charater 
      lShift = GetAsyncKeyState_(#VK_LSHIFT) 
      rShift = GetAsyncKeyState_(#VK_RSHIFT) 
      lCtrl = GetAsyncKeyState_(#VK_LCONTROL) 
      rCtrl = GetAsyncKeyState_(#VK_RCONTROL) 
      ;Debug rCtrl 
      If lShift < 0 
        vk$ = "Left Shift + " 
      ElseIf rShift < 0 
        vk$ = "Right Shift + " 
      ElseIf lCtrl < 0 
        vk$ = "Left Control + " 
      ElseIf rCtrl < 0 
        vk$ = "Right Control + " 
      Else 
        vk$ = "" 
      EndIf 
      SetGadgetText(#Text_2, vk$ + key$) 
      If wparam <> 38 And wparam > 26 
        SetGadgetText(#Text_3, Chr(wparam)) 
      ElseIf wparam = 38 
        SetGadgetText(#Text_3, "&" + Chr(wparam)) 
      EndIf 
    Case #WM_SYSCHAR 
      lAlt = GetAsyncKeyState_(#VK_LMENU) 
      rAlt = GetAsyncKeyState_(#VK_RMENU) 
      If lAlt <> 0 
        vk$ = "Left Alt + " 
      ElseIf rAlt <> 0 
        vk$ = "Right Alt + " 
      Else 
        vk$ = "" 
      EndIf 
      SetGadgetText(#Text_2, vk$ + key$) 
    Case #WM_SYSKEYDOWN ; catch the Alt keys 
      GetKeyNameText_(lparam,key$,255) 
      SetGadgetText(#Text_2, key$) 
      lrAlt$ = key$ 
  EndSelect 
  ProcedureReturn CallWindowProc_(OldCallback, hwnd, msg, wparam, lparam) 
EndProcedure 

If OpenWindow(#Window_0, 0, 0, 300, 150, "Key Pressed", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_TitleBar) 
  If CreateGadgetList(WindowID(#Window_0)) 
    TextGadget(#Text_0, 20, 60, 100, 20, "Key Pressed", #PB_Text_Right) 
    TextGadget(#Text_1, 20, 90, 100, 20, "Character displayed", #PB_Text_Right) 
    TextGadget(#Text_2, 130, 60, 100, 25, "") 
    TextGadget(#Text_3, 130, 90, 50, 25, "") 
    TextGadget(#Text_4, 130, 120, 50, 25, "") 
    StringGadget(#String_0, 20, 5, 260, 20, "") 
    SetActiveGadget(#String_0) 
    OldCallback = SetWindowLong_(GadgetID(#String_0), #GWL_WNDPROC, @String0_CallBack()) 
    SetWindowLong_(GadgetID(#String_0), #GWL_WNDPROC, @String0_CallBack()) 
  EndIf 
EndIf 
Quit = #False 
Repeat 
  event = WaitWindowEvent() 
  Select event 
    Case #PB_Event_CloseWindow 
      Quit = #True 
  EndSelect 
Until Quit 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP