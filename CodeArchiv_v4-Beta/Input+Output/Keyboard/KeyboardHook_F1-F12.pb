; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=495
; Author: Danilo (updated for PB 4.00 by Andre)
; Date: 07. April 2003
; OS: Windows
; Demo: No

; The following keyboard hook locks the keys 'F1' - 'F12'.
; The key 'F12' will show a pop-up menu too.
; An icon will be placed in the systray to quit the hook.

; Die folgende Version sperrt die F-Tasten 'F1' - 'F12' und
; lässt bei F12 noch ein PopupMenu erscheinen.
; Ausserdem findet man im Systray ein Icon um den Hook zu beenden.
;
; Dieser LowLevel Keyboard Hook ist, falls mich jetzt nicht alles
; täuscht, undokumentiert - aber auch sonst ohne Gewähr.
;
; by Danilo, 07.04.2003 - german forum
;
Global hWindow,msg,hook

Structure KBDLLHOOKSTRUCT
  vkCode.l
  scanCode.l
  flags.l
  time.l
  dwExtraInfo.l
EndStructure

Procedure.l myKeyboardHook(nCode, wParam, *p.KBDLLHOOKSTRUCT)
  If nCode = #HC_ACTION
    If wParam = #WM_KEYDOWN Or wParam = #WM_SYSKEYDOWN Or wParam = #WM_KEYUP Or wParam = #WM_SYSKEYUP
      #LLKHF_ALTDOWN = $20
      If *p\vkCode => #VK_F1 And *p\vkCode <= #VK_F12 ; F1 - F12 sperren!!
        If *p\vkCode = #VK_F12
          PostMessage_(hWindow,msg,0,0)
        EndIf
        ProcedureReturn 1
      EndIf
    EndIf
  EndIf
  ProcedureReturn CallNextHookEx_(0, nCode, wParam, *p)
EndProcedure

Procedure AskForExit()
  If MessageRequester("EXIT", "End the KeyboardHook ??",#MB_YESNO) = #IDYES
    UnhookWindowsHookEx_(hook) : End
  EndIf
EndProcedure

; Win NT
#WH_KEYBOARD_LL = 13
hook = SetWindowsHookEx_(#WH_KEYBOARD_LL,@myKeyboardHook(),GetModuleHandle_(0),0)
If hook = 0: End: EndIf

hWindow     = OpenWindow(1,0,0,10,10,"k8D h00K",#PB_Window_Invisible)


; by daniel, 21. Nov 2002 (german Tips&Tricks)
SystemPath$ = Space(1024) : GetSystemDirectory_(SystemPath$,1024)
hIcon       = ExtractIcon_(0,SystemPath$+"\user32.dll",1)
;-----


AddSysTrayIcon(1,WindowID(1),hIcon)
SysTrayIconToolTip(1,"k8D h00K")
msg = RegisterWindowMessage_("DKs_k8D_h00K")

If CreatePopupMenu(0)
  For a = 1 To 19
    MenuItem(a, "Oink! - "+RSet(Str(a),2,"0"))
  Next a
  MenuBar()
  MenuItem(20,"QUIT IT!")
EndIf


Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow : End
    Case msg
      DisplayPopupMenu(0, hWindow,GetSystemMetrics_(#SM_CXSCREEN)/2,GetSystemMetrics_(#SM_CYSCREEN)/2)
    Case #PB_Event_Menu
      If EventMenu() = 20
        AskForExit()
      Else
        MessageRequester("MENU","Menu entry: "+Str(EventMenu()),0)
      EndIf
    Case #PB_Event_SysTray
      If EventType() = #PB_EventType_LeftDoubleClick
        AskForExit()
      EndIf
  EndSelect
ForEver


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -