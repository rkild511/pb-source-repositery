; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8572&highlight=
; Author: waffle
; Date: 01. December 2003
; OS: Windows
; Demo: No


;I did this to use a joystick with starfleet command
;works with windows too
;AOE has problems with it

;norms global mouser using joystick
quit.l=0
If InitJoystick()=0
  MessageRequester("Mouser Error","No controller detected",#MB_ICONSTOP)
  End
EndIf
holdingX.l=0
holdingY.l=0
holddelayX.l=0
holddelayY.l=0
lbhold.l=0
rbhold.l=0
Repeat
  
  If ExamineJoystick()
    dx=JoystickAxisX()
    dy=JoystickAxisY()
    lb=JoystickButton(1) Or JoystickButton(5)
    rb=JoystickButton(4) Or JoystickButton(6)
    If JoystickButton(3)
      quit=1
    EndIf
    ;now, read the mouse position
    GetCursorPos_(mouse.POINT) : x=mouse\x : y=mouse\y
    ;now to move the mouse
    If dx
      If holddelayX
        If GetTickCount_()-holddelayX>300
          holdingX=4*dx
        EndIf
      Else
        holddelayX=GetTickCount_()
      EndIf
      x=x+dx+holdingX
      
      
    Else
      holdingx=0
      holddelayX=0
    EndIf
    If dy
      If HoldDelayY
        If GetTickCount_()-HoldDelayY>300
          holdingY=4*dy
        EndIf
      Else
        HoldDelayY=GetTickCount_()
      EndIf
      y=y+dy+holdingY
      
    Else
      holdingY=0
      HoldDelayY=0
    EndIf
    
    SetCursorPos_(x,y)
    If lb
      If lbhold=0
        mouse_event_(#MOUSEEVENTF_LEFTDOWN,0,0,0,0)
        lbhold=1
      EndIf
      
      
    Else
      If lbhold
        mouse_event_(#MOUSEEVENTF_LEFTUP,0,0,0,0)
        lbhold=0
      EndIf
    EndIf
    If rb
      If rbhold=0
        mouse_event_(#MOUSEEVENTF_RIGHTDOWN,0,0,0,0)
        rbhold=0
      EndIf
    Else
      If rbhold
        mouse_event_(#MOUSEEVENTF_RIGHTUP,0,0,0,0)
        rbhold=0
      EndIf
    EndIf
  EndIf
  Delay(1)
  
  
Until quit

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
