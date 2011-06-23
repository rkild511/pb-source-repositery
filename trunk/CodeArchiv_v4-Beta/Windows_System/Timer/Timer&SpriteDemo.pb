; English forum: 
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 07. September 2003
; OS: Windows
; Demo: No


; Original code need the PureTools userlib - now integrated in PBOSL package, get it on www.purearea.net!
; Here the WinAPI commands are used now...

#ScreenWidth  = 800
#ScreenHeight = 600
#ScreenBits   = 32
X = #ScreenWidth >> 1



Procedure Timer_()
  Shared y, size, flag, color
  y+#ScreenHeight/200 : If y > #ScreenHeight : y=0 : EndIf
  color = (size<<3)-1
  If size < 32 And flag = 0
    size+1
  Else
    flag = 1 : size-1 : If size = 0 : flag = 0 : EndIf
  EndIf
EndProcedure


;DirectX init
If InitSprite() = 0 Or InitKeyboard() = 0
   MessageRequester("ERROR","Can't initialize DirectX 7 or later", 0):End
EndIf


If OpenScreen(#ScreenWidth,#ScreenHeight,#ScreenBits,"Timer Test") = 0
   MessageRequester("ERROR","Can´t open DirectX screen",0):End
EndIf


; Start the Timer-Procedure
;StartTimer(0,15,@Timer_())
SetTimer_(ScreenID(),0,15,@Timer_())


  ; Wait for Escape-Key
  Repeat
     ExamineKeyboard()
     FlipBuffers()
     If IsScreenActive()
        ClearScreen(RGB(0,0,0))
        StartDrawing(ScreenOutput())
           FrontColor(RGB(color,color,0))
           Box(X-size/2,y,size,size) 
        StopDrawing()
     Else
        Delay(200)
     EndIf
  Until KeyboardPushed(#PB_Key_Escape)


; End Program
;EndTimer(0)
KillTimer_(ScreenID(), 0)
Delay(20)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger