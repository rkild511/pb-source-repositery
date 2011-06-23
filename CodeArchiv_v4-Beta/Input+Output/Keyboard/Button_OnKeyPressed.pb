; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm + Andre)
; Date: 01. April 2003
; OS: Windows
; Demo: No


; Button (or other gadget) OnKeyPressed event is missing in Purebasic
; or I don't know about it ...
; 
; ------------------------------------------------------
; Uses EventwParam() undocumented function [gets wParam]
;
#Win_1 = 1
#Text_1 = 1
#Btn_Cancel = 2
#Btn_OK = 3
;
If OpenWindow(#Win_1, 389, 263, 248, 93, "#VK_RETURN test", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Win_1))
    StringGadget(#Text_1, 10, 10, 230, 20,"")
    ButtonGadget(#Btn_Cancel, 10, 55, 90, 30, "Cancel")
    ButtonGadget(#Btn_OK, 150, 55, 90, 30, "OK", #PB_Button_Default)
    SetActiveGadget(#Btn_OK)
  EndIf
EndIf 
;
Repeat
  EventID.l = WaitWindowEvent() ; Get msg
  Select EventID
    
    Case #WM_KEYDOWN ; Key pressed (KEYBOARD)
    
      EventID2.l = EventwParam() ; Get wParam
      
      Select EventID2
        
        Case #VK_RETURN ; Key is RETURN
        
          EventID3.l = GetFocus_()
          Select EventID3
            Case GadgetID(#Btn_OK) ; active gadget is #Btn_OK
              MessageRequester("KEY!","You hit Ok",0)
            Case GadgetID(#Btn_Cancel) ; active gadget is #Btn_Cancel
              MessageRequester("KEY!","You hit Cancel",0)
            Case GadgetID(#Text_1) ; active gadget is #Text_1
              MessageRequester("KEY!","You hit Return in the StringGadget",0)
            Default
          EndSelect
        
        Default
      EndSelect
      
    Case #PB_Event_Gadget ; Gadget event (MOUSE)
      
      Select EventGadget()
        Case #Btn_OK
          MessageRequester("MOUSE!","You clicked Ok",0)
        Case #Btn_Cancel
          MessageRequester("MOUSE!","You clicked Cancel",0)
      EndSelect
  
  EndSelect 
  
Until EventID = #PB_Event_CloseWindow
End

;-----------------------------------------------------------------------
;Symbolic constant name Value (hexadecimal) Mouse Or keyboard equivalent
;VK_LBUTTON 01 Left mouse button 
;VK_RBUTTON 02 Right mouse button 
;VK_CANCEL 03 Control-break processing 
;VK_MBUTTON 04 Middle mouse button (three-button mouse) 
;VK_BACK 08 BACKSPACE key 
;VK_TAB 09 TAB key 
;VK_CLEAR 0C CLEAR key 
;VK_RETURN 0D ENTER key 
;VK_SHIFT 10 SHIFT key 
;VK_CONTROL 11 CTRL key 
;VK_MENU 12 ALT key 
;VK_PAUSE 13 PAUSE key 
;VK_CAPITAL 14 CAPS LOCK key 
;VK_ESCAPE 1B ESC key 
;VK_SPACE 20 SPACEBAR 
;VK_PRIOR 21 PAGE UP key 
;VK_NEXT 22 PAGE DOWN key 
;VK_END 23 End key 
;VK_HOME 24 HOME key 
;VK_LEFT 25 LEFT ARROW key 
;VK_UP 26 UP ARROW key 
;VK_RIGHT 27 RIGHT ARROW key 
;VK_DOWN 28 DOWN ARROW key 
;VK_SELECT 29 Select key 
;VK_EXECUTE 2B EXECUTE key 
;VK_SNAPSHOT 2C PRINT SCREEN key For Windows 3.0 And later 
;VK_INSERT 2D INS key 
;VK_DELETE 2E DEL key 
;VK_HELP 2F HELP key 
;VK_0 30 0 key 
;VK_1 31 1 key 
;VK_2 32 2 key 
;VK_3 33 3 key 
;VK_4 34 4 key 
;VK_5 35 5 key 
;VK_6 36 6 key 
;VK_7 37 7 key 
;VK_8 38 8 key 
;VK_9 39 9 key 
;VK_A 41 A key 
;VK_B 42 B key 
;VK_C 43 C key 
;VK_D 44 D key 
;VK_E 45 E key 
;VK_F 46 F key 
;VK_G 47 G key 
;VK_H 48 H key 
;VK_I 49 I key 
;VK_J 4A J key 
;VK_K 4B K key 
;VK_L 4C L key 
;VK_M 4D M key 
;VK_N 4E N key 
;VK_O 4F O key 
;VK_P 50 P key 
;VK_Q 51 Q key 
;VK_R 52 R key 
;VK_S 53 S key 
;VK_T 54 T key 
;VK_U 55 U key 
;VK_V 56 V key 
;VK_W 57 W key 
;VK_X 58 X key 
;VK_Y 59 Y key 
;VK_Z 5A Z key 
;VK_LWIN 5B Left Windows key (Microsoft Natural Keyboard) 
;VK_RWIN 5C Right Windows key (Microsoft Natural Keyboard) 
;VK_APPS 5D Applications key (Microsoft Natural Keyboard) 
;VK_NUMPAD0 60 Numeric keypad 0 key 
;VK_NUMPAD1 61 Numeric keypad 1 key 
;VK_NUMPAD2 62 Numeric keypad 2 key 
;VK_NUMPAD3 63 Numeric keypad 3 key 
;VK_NUMPAD4 64 Numeric keypad 4 key 
;VK_NUMPAD5 65 Numeric keypad 5 key 
;VK_NUMPAD6 66 Numeric keypad 6 key 
;VK_NUMPAD7 67 Numeric keypad 7 key 
;VK_NUMPAD8 68 Numeric keypad 8 key 
;VK_NUMPAD9 69 Numeric keypad 9 key 
;VK_MULTIPLY 6A Multiply key 
;VK_ADD 6B Add key 
;VK_SEPARATOR 6C Separator key 
;VK_SUBTRACT 6D Subtract key 
;VK_DECIMAL 6E Decimal key 
;VK_DIVIDE 6F Divide key 
;VK_F1 70 F1 key 
;VK_F2 71 F2 key 
;VK_F3 72 F3 key 
;VK_F4 73 F4 key 
;VK_F5 74 F5 key 
;VK_F6 75 F6 key 
;VK_F7 76 F7 key 
;VK_F8 77 F8 key 
;VK_F9 78 F9 key 
;VK_F10 79 F10 key 
;VK_F11 7A F11 key 
;VK_F12 7B F12 key 
;VK_F13 7C F13 key 
;VK_F14 7D F14 key 
;VK_F15 7E F15 key 
;VK_F16 7F F16 key 
;VK_F17 80H F17 key 
;VK_F18 81H F18 key 
;VK_F19 82H F19 key 
;VK_F20 83H F20 key 
;VK_F21 84H F21 key 
;VK_F22 85H F22 key 
;VK_F23 86H F23 key 
;VK_F24 87H F24 key 
;VK_NUMLOCK 90 NUM LOCK key 
;VK_SCROLL 91 SCROLL LOCK key 
;VK_ATTN F6 Attn key
;VK_CRSEL F7 CrSel key
;VK_EXSEL F8 ExSel key
;VK_EREOF F9 Erase EOF key
;VK_PLAY FA Play key
;VK_ZOOM FB Zoom key
;----------------------------------------------------------------------- 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP