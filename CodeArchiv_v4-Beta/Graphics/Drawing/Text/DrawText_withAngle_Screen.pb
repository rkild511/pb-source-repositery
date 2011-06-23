; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No

InitSprite() 
Procedure DrawRText(DC.l,x,y,Text.s,fFont.s,fangle.l,fHeight) 
  Font = CreateFont_(fHeight,0,fangle*10,0,0,0,0,0,0,0,0,0,0,fFont) 
  GetWindowRect_(ScreenID(),r.RECT) 
  OldFont = SelectObject_(DC,Font) 
  SetTextAlign_(DC,#TA_BASELINE) 
  SetBkMode_(DC,#TRANSPARENT) 
  ExtTextOut_(DC, x,y,0 ,r,Text,Len(Text),0 ) 
  SelectObject_(DC,OldFont) 
  DeleteObject_(Font) 
EndProcedure 

OpenScreen(1024,768,16,"") 
For i = 0 To 255 
    ClearScreen(RGB(0,0,0)) 
    DC = StartDrawing(ScreenOutput()) 
    FrontColor(RGB(255-i,i,0)) 
    DrawRText(DC,Int(10+3*i),Int(100+2*i),"Testtext "+Str(i),"Arial",Int(i/6),20+Int(i/10)) 
    StopDrawing()
    ;Parameter 
    ;1 = DeviceContext 
    ;2 = StartX 
    ;3 = StartY 
    ;4 = Text$ 
    ;5 = Font$ 
    ;6 = Angle 
    ;7 = FontHeight 
    FlipBuffers() 
Next 
Delay(2000) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -