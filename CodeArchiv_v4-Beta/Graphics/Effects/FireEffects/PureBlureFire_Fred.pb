; English forum: 
; Author: Fred  (based on GPI's code, updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 22. September 2003
; OS: Windows
; Demo: Yes

#ScreenWidth  = 640
#ScreenHeight = 480


Global Dim col(#ScreenWidth,#ScreenHeight)
Global Dim hotspot(#ScreenWidth,#ScreenHeight)

If InitSprite()
  If InitKeyboard()
    If OpenScreen(#ScreenWidth,#ScreenHeight,8,"PureFire")
      If InitPalette()
        If InitMouse()
          MouseLocate(160,100)
      
CreatePalette(0)
For i=0 To 63
  SetPaletteColor(0,i,RGB(i*4,0,0))
Next 
For i=0 To 63
  SetPaletteColor(0,i+64,RGB(255,i*4,0))
Next
For i=0 To 63
  SetPaletteColor(0,i+64+64,RGB(255,255,i*4))
Next
SetPaletteColor(0,255,RGB(255,255,255))


DisplayPalette(0) 

LoadFont(0,"Arial",30)
StartDrawing(ScreenOutput())

text$="Set on Fire by GPI"
DrawingFont(FontID(0))
DrawingMode(1)
FrontColor(RGB(255,255,255))
DrawText((320-TextWidth(text$))>>1,#ScreenHeight-1-60,text$)

LineXY(0,#ScreenHeight-1,#ScreenWidth-1,#ScreenHeight-1)


For y=0 To #ScreenHeight-1
  For x=0 To #ScreenWidth-1
    If Point(x,y)>0
      hotspot(x,y)=1
    EndIf
  Next
Next
StopDrawing()
FreeFont(0)

;For y=195 To #ScreenHeight-1
;  For x=0 To #ScreenWidth-1
;    hotspot(x,y)=random(2)
;  Next
;Next
      

dodown=0:dodownmax=1
Repeat
  dodown+1:If dodown=dodownmax:dodown=0:EndIf
  For y=0 To #ScreenHeight-1
    For x=0 To #ScreenWidth-1
      If hotspot(x,y)
        col(x,y)=Random(255)
      EndIf
    Next
  Next
  
  ;mouse
  hotspot(MouseX(),MouseY())=1
  
  For NY=1 To #ScreenHeight-1 
    nym1=ny-1:If nym1<0:nym1=0:EndIf
    nyp1=ny+1:If nyp1>#ScreenHeight-1:nyp1=#ScreenHeight-1:EndIf
    For NX=0 To #ScreenWidth-1
      nxm1=nx-1:If nxm1<0:nxm1=0:EndIf
      nxp1=nx+1:If nxp1>#ScreenWidth-1:nxp1=#ScreenWidth-1:EndIf 
      
      A=col(NXp1,NY) 
      B=col(NXm1,NY)
      C=col(NX,NYp1)
      D=col(NX,NYm1)
      
      E=col(NXm1,NYm1) 
      F=col(NXp1,NYm1)
      G=col(NXm1,NYp1) 
      H=col(NXp1,NYp1)
    
      i=(A+B+C+D+E+F+G+H)>>3
      If dodown=0
        i-Random(1)
      EndIf
      If i<0:i=0:EndIf
      If i>191:i=191:EndIf
      
      col(nx,ny-1)=i
      
    Next 
  Next 
  
;   Structure Byte     ; structure already declared in PB3.70+
;     b.b
;   EndStructure
  
  StartDrawing(ScreenOutput())
  adr=DrawingBuffer()
  add=DrawingBufferPitch()
  For y=0 To #ScreenHeight-1
    *adr2.Byte=adr
    For x=0 To #ScreenWidth-1
      If hotspot(x,y)
        *adr2\b = 100 : *adr2+1
      Else
        *adr2\b = col(x,y) : *adr2+1
      EndIf
    Next
    adr+add
  Next
  StopDrawing()
  ExamineMouse()  
  ExamineKeyboard() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All)

        EndIf
      EndIf
    EndIf
  EndIf
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger