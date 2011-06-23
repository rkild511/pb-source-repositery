; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6183&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm + Andre)
; Date: 18. May 2003
; OS: Windows
; Demo: Yes


; Added code for working example by Andre 14th June 2003

path$="C:\"           ; change to your own path + file
file$="test.avi"
#Screenwidth = 800
#Screenheight = 600

If InitSprite() And InitKeyboard() And OpenScreen(#Screenwidth,#Screenheight,32,"Movie Screen")
Else
  End
EndIf

;-PlayAvi 
playavi : 
FlipBuffers() 
ClearScreen(RGB(0,0,0)) 
FlipBuffers() 

If InitMovie() 
  If LoadMovie(0, path$ + file$) 
    ResizeMovie(0,0,0,#Screenwidth,#Screenheight)
    ClearScreen(RGB(0,0,0)) 
    Delay(1000) 
    PlayMovie(0, ScreenID()) 
    Repeat 
      ExamineKeyboard()
      Delay(1) 
    Until (MovieStatus(0)=MovieLength(0) - 2) Or KeyboardPushed(#PB_Key_Escape) 
    FreeMovie(0) 
    ClearScreen(RGB(0,0,0)) 
  EndIf
EndIf 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
