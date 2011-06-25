;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : Matrix Blanker Light
;* Author : Prod
;* Date   : Sun May 24, 2009
;* Link   : http://www.purebasic.fr/english/viewtopic.php?p=286895#286895
;*
;*****************************************************************************

InitKeyboard() : InitSprite() : InitSprite3D() : Sprite3DQuality(1)
ExamineDesktops() : sw=DesktopWidth(0) : sh=DesktopHeight(0)

OpenScreen(sw,sh,DesktopDepth(0),"")

If sh=>1200
  a=256
EndIf
f=FontID(LoadFont(-1,"Courier",sh/75,a))
StartDrawing(ScreenOutput())
  DrawingFont(f) : cw=TextWidth(".")+2 : ch=TextHeight(".")+2
StopDrawing()

mw=sw/cw : mh=sh/ch : ox=(sw-(cw*mw))/2 : oy=(sh-(ch*mh))/2 : ct=mh*2

Global Dim cm.i(2,2,2)
Global Dim cmm.i(2,2,2)
Global Dim rc.i(2)
Global Dim lny.i(mw*4)
Global Dim yl.i(mw)

For a=0 To mw*4
  lny(a)=(a&3)*mh/4
Next
For y=0 To 2
  For x=0 To 2
    For a=0 To 2
      cm(x,y,a)=Random(223)+32 : b=Random(9)-5 : cmm(x,y,a)=b-(~b>>3)
    Next
  Next
Next

b=cw-1 : c=ch-1
For a=0 To 1
  CreateSprite(a,16,16,4) : CreateSprite3D(a,a) : TransformSprite3D(a,0,0,b,0,b,c,0,c) : b=sw-1 : c=sh-1
Next
CreateSprite(2,sw,sh) : TransparentSpriteColor(2,1)
StartDrawing(SpriteOutput(0))
  Box(0,0,16,16,#White)
StopDrawing()

Repeat
  t=ElapsedMilliseconds() : ExamineKeyboard()
  StartDrawing(SpriteOutput(2))
    DrawingFont(f)
    For x=0 To mw-1
      yl(x)=yl(x)+1
      For a=x*4 To (x*4)+3
        y=lny(a)+1
        If y=>0
          If y<mh
            b=48+Random(35) : DrawText((x*cw)+ox+1,(y*ch)+oy+1,Chr(b+(b/58*7)),a&1,0)
          Else
            y=yl(x)-(Random(mh))-(mh/8)
            If y>0
              y=0
            EndIf
            yl(x)=y
          EndIf
        EndIf
        lny(a)=y
      Next
    Next
  StopDrawing()
  If ct=0
    For y=0 To 2
      For x=0 To 2
        b=cmm(x,y,cc) : a=cm(x,y,cc)+b
        If a<32 Or a>255
          c=(a>>8) : a=(c*223)+32 : b=(Random(4)+1)*(1-(c*2))
        EndIf
        cm(x,y,cc)=a : cmm(x,y,cc)=b
      Next
    Next
    StartDrawing(SpriteOutput(1))
      For b=0 To 1
        For a=0 To 1
          For y=0 To 7
            For x=0 To 7
              For c=0 To 2
                rc(c)=((cm(a,b,c)*(8-x)*(8-y))+(cm(a+1,b,c)*x*(8-y))+(cm(a,b+1,c)*(8-x)*y)+(cm(a+1,b+1,c)*x*y))/64
              Next
              Plot((a*8)+x,(b*8)+y,RGB(rc(0),rc(1),rc(2)))
            Next
          Next
        Next
      Next
    StopDrawing()
    Start3D()
      DisplaySprite3D(1,0,0)
      For x=0 To mw-1
        For a=0 To 1
          y=lny((x*4)+(a*2)+1)
          If y=>0 And y<=mh
            For b=0 To 1
              DisplaySprite3D(0,(x*cw)+ox,((y-b)*ch)+oy,(2-b)*96)
            Next
          EndIf
        Next
      Next
    Stop3D()
    DisplayTransparentSprite(2,0,0) : FlipBuffers() : cc=(((cc*3)+2)/2)&3 : a=65-(ElapsedMilliseconds()-t)
    If a<0
      a=0
    EndIf
    Delay(a)
  Else
    ct=ct-1
  EndIf
Until KeyboardPushed(-1) Or IsScreenActive()=0
End
