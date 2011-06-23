; English forum: 
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 22. September 2003
; OS: Windows
; Demo: Yes


;#realx=1024:#realy=768 
;#realx=800:#realy=600 
#realx=640:#realy=480 
;#realx=512:#realy=384 
;#realx=400:#realy=300 
;#realx=320:#realy=240 
;#realx=320:#realy=200 

;#aufx=320:#aufy=200 
;#aufx=640:#aufy=480 
;#aufx=512:#aufy=384 
;#aufx=400:#aufy=300 
#aufx=#realx:#aufy=#realy 

#updown=1 ; 0 or 1 Calculate from up to down (1) or down to up (0) 

#mouselen=100 ; waittime, before the old mousepoints are deleted 

#hotspotadd=0 ; Change the brightness of the hotspots 

#dodownmax=0  ; high of the flames (0=small 2=very big) 
#downsub=0    ; dito+flicker (0=high flames, no flicker ,10=small high flicker) 

text$="Set on Fire by GPI" ; the text ;""=nowtext 
#line=0 

; Structure Byte      ; structure already declared in PB 3.70+
;   b.b 
; EndStructure 
  
If #realx<#aufx Or #realy<#aufy 
  End 
EndIf 

Global Dim col(#aufx,#aufy) 
Global Dim hotspot(#aufx,#aufy) 

If InitSprite()=0 
  Debug "sprite" 
  End 
EndIf 
If InitKeyboard()=0 
  Debug "keyboard" 
  End 
EndIf 
If OpenScreen(#realx,#realy,8,"PureFire")=0 
  Debug "open" 
  End 
EndIf 
If InitPalette()=0 
  Debug "palette" 
  End 
EndIf 
If InitMouse()=0 
  Debug "mouse" 
  End 
EndIf 

omx=#aufx/2:omy=#aufy/2 
MouseLocate(omx,omy-1) 

Structure xy 
  x.l 
  y.l 
  c.l 
EndStructure 

Global NewList M.xy() 


;create palette      
CreatePalette(0) 
For i=0 To 84 
  SetPaletteColor(0,i,RGB(Int(250/84*i),0,0)) 
Next 
For i=0 To 84 
  SetPaletteColor(0,i+85,RGB(250,Int(250/84*i),0)) 
Next 
For i=0 To 84 
  SetPaletteColor(0,i+85+85,RGB(250,250,Int(250/84*i))) 
Next 
SetPaletteColor(0,255,RGB(255,255,255)) 

DisplayPalette(0) 


;draw the flame-points 
LoadFont(0,"Arial",30) 
StartDrawing(ScreenOutput()) 

If text$<>"" 
  DrawingFont(FontID(0)) 
  DrawingMode(1) 
  FrontColor(RGB(255,255,255)) 
  DrawText((#aufx-TextWidth(text$))>>1,#aufy-1-Int(60/200*#aufy) ,text$) 
EndIf 

CompilerIf #line 
  LineXY(0,#aufy-1,#aufx-1,#aufy-1) 
CompilerEndIf 

For y=0 To #aufy-1 
  For x=0 To #aufx-1 
    If Point(x,y)>0 
      hotspot(x,y)=1 
    EndIf 
  Next 
Next 
StopDrawing() 
FreeFont(0) 
      

dodown=0:count=0 
Repeat 
  CompilerIf #dodownmax>0 
    dodown+1:If dodown>#dodownmax:dodown=0:EndIf 
  CompilerEndIf 
  count+1:If count>#mouselen:count=0:EndIf 
  
  
  
  ;mouse 
  quit=0 
  While FirstElement(m())>0 And quit=0 
    If m()\c=count 
      hotspot(m()\x,m()\y)=0 
      DeleteElement(m()) 
    Else 
      quit=1 
    EndIf 
  Wend    
  mx=MouseX():my=MouseY() 
  If mx>#aufx-1:mx=#aufx-1:EndIf 
  If my>#aufy-1:my=#aufy-1:EndIf 
  If omx<>mx Or omy<>my 
    ax=omx-mx:If ax<0 :ax=-ax:EndIf 
    ay=omy-my:If ay<0 :ay=-ay:EndIf 
    If ax>ay:ab=ax:Else:ab=ay:EndIf 
    ax=omx-mx:ay=omy-my 
    For i=1 To ab 
      xx=mx+Int(ax*i/ab) 
      yy=my+Int(ay*i/ab) 
      If hotspot(xX,yY)=0 
        LastElement(m()) 
        AddElement(m()) 
        m()\x=xx 
        m()\y=yy 
        m()\c=count 
        hotspot(xX,yY)=col(xX,yY)+1 
      EndIf 
    Next 
    omx=mx:omy=my 
  EndIf 
    
  
  StartDrawing(ScreenOutput()) 
  CompilerIf #updown 
    adr=DrawingBuffer() 
    add=DrawingBufferPitch() 
    
    For NY=0 To #aufy-1 
    
  CompilerElse 
    sub=DrawingBufferPitch() 
    adr=DrawingBuffer()+sub*(#aufy-1) 
    
    For NY=#aufy-1 To 0 Step -1 
    
  CompilerEndIf 
  
    ny1 =ny+1:If ny1 >#aufy-1:ny1=#aufy-1:EndIf 
    ny2 =ny+2:If ny2 >#aufy-1:ny2=#aufy-1:EndIf 
    
    *adr2.byte=adr 
    
    For NX=0 To #aufx-1 
      nx1=nx-1:If nx1<0:nx1=0:EndIf 
      nx3=nx+1:If nx3>#aufx-1:nx3=#aufx-1:EndIf 
        
      i=Int( (col(nx1,ny1)+col(nx,ny1)+col(nx3,ny1)+col(nx1,ny2)+col(nx,ny2)+col(nx3,ny2))/6 ) 
      If dodown=0 
        CompilerIf #downsub=<0 
          i-1 
        CompilerElse 
          i-Random(#downsub) 
        CompilerEndIf 
      EndIf 
      If i<0:i=0:EndIf 
      ;If i>254:i=254:EndIf 
        
      If hotspot(nx,ny) 
        a=col(nx,ny) 
        b=hotspot(nx,ny) 
        If a=b : b=Random(330)+20:hotspot(nx,ny)=b:EndIf 
        If a+10<b:b=a+10:EndIf 
        If a-10>b:b=a-10:EndIf 
        col(nx,ny)=b 
        
        i+#hotspotadd 
        If i<0:i=0:EndIf 
        If i>255:i=255:EndIf 
        
      Else  
        col(nx,ny)=i 
        
        If i>254:i=254:EndIf 
      EndIf 
      
      *adr2\b=i:*adr2+1 
      
    Next 
    CompilerIf #updown 
      adr+add 
    CompilerElse 
      adr-sub 
    CompilerEndIf 
    
  Next 
  StopDrawing() 
  
  ExamineMouse()  
  ExamineKeyboard() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_All) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = C:\Programming\Set_on_Fire.exe
; DisableDebugger