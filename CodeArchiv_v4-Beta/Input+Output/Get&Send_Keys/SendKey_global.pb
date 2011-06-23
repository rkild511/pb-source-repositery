; http://www.purebasic-lounge.de
; Author: remi_meier (updated for PB 4.00 by Andre)
; Date: 01. March 2005
; OS: Windows
; Demo: No

Procedure SendKeyStroke(VK_Key.l, time.l)
  #INPUT_MOUSE     = 0
  #INPUT_KEYBOARD  = 1
  #INPUT_HARDWARE  = 2

  ; Following structures are already included in PB4.02
  ;   Structure MOUSEINPUT
  ;     dx.l
  ;     dy.l
  ;     mouseData.l
  ;     dwFlags.l
  ;     time.l
  ;     dwExtraInfo.l ;ULONG_PTR dwExtraInfo
  ;   EndStructure
  ;   Structure KEYBDINPUT
  ;     wVk.w
  ;     wScan.w
  ;     dwFlags.l
  ;     time.l
  ;     dwExtraInfo.l;ULONG_PTR dwExtraInfo
  ;   EndStructure
  ;   Structure HARDWAREINPUT
  ;     uMsg.l
  ;     wParamL.w
  ;     wParamH.w
  ;   EndStructure

  ;   Structure INPUT
  ;     type.l
  ;     StructureUnion
  ;       mi.MOUSEINPUT
  ;       ki.KEYBDINPUT
  ;       hi.HARDWAREINPUT
  ;     EndStructureUnion
  ;   EndStructure


  Protected KeyStroke.INPUT
  KeyStroke\type = #INPUT_KEYBOARD
  KeyStroke\ki\wVk = VK_Key ;#VK_Irgendwas
  KeyStroke\ki\wScan = 0
  KeyStroke\ki\dwFlags = 0
  KeyStroke\ki\time = time
  KeyStroke\ki\dwExtraInfo = 0

  SendInput_(1, @KeyStroke, SizeOf(INPUT))

EndProcedure

Delay(1000)
SendKeyStroke(#VK_F1, 100)    ; started in the PB IDE it will open the help (F1)
SendKeyStroke(#VK_F12, 100)
Delay(1000)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -