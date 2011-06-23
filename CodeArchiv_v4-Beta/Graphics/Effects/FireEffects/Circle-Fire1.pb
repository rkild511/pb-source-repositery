; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5156#5156
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 29. April 2003
; OS: Windows
; Demo: Yes


;#realx=1024:#realy=768 
;#realx=800:#realy=600 
;#realx=640:#realy=480 
;#realx=512:#realy=384 
;#realx=400:#realy=300 
;#realx=320:#realy=240 
#realx=320:#realy=200 

;#aufx=1024:#aufy=768 
;#aufx=800:#aufy=600 
;#aufx=640:#aufy=480 
;#aufx=512:#aufy=384 
;#aufx=400:#aufy=300 
;#aufx=320:#aufy=240 
;#aufx=320:#aufy=200 

#aufx=#realx : #aufy=#realy 

#bigmax=50 
#bigmin=0 

#speed=3 

#updown=1 ; 0 or 1 Calculate from up to down (1) or down to up (0) 

Global NewList punkte.Point() 
; Structure long    ; Structure already declared in PB 3.70+
;   l.l 
; EndStructure 
Global Dim color(255) 
Global Dim col(#aufx,#aufy) 
Global Dim in(#aufx,#aufy) 
Global Dim KreisPointx(50,50,800) 
Global Dim KreisPointy(50,50,800) 
Procedure.f deg(rad) 
  ProcedureReturn 3.1415926*rad/180 
EndProcedure 
Procedure addpoint(xx,yy) 
  If xx>0 And xx<#aufx-1 And yy>0 And yy<#aufy-1 
    x=xx:y=yy-1 
    If in(x,y)=0 
      AddElement(punkte()) 
      punkte()\x=x 
      punkte()\y=y 
      in(x,y)=1 
    EndIf 
    x=xx-1:y=yy-1 
    If in(x,y)=0 
      AddElement(punkte()) 
      punkte()\x=x 
      punkte()\y=y 
      in(x,y)=1 
    EndIf 
    x=xx+1:y=yy-1 
    If in(x,y)=0 
      AddElement(punkte()) 
      punkte()\x=x 
      punkte()\y=y 
      in(x,y)=1 
    EndIf 
    x=xx:y=yy 
    If in(x,y)=0 
      AddElement(punkte()) 
      punkte()\x=x 
      punkte()\y=y 
      in(x,y)=1 
    EndIf 
  EndIf 
EndProcedure 
  
If #realx<#aufx Or #realy<#aufy 
  MessageRequester("Fire","auflösung",0) 
  End 
EndIf 
If InitSprite()=0 
  MessageRequester("Fire","sprite",0) 
  End 
EndIf 
If InitKeyboard()=0 
  MessageRequester("Fire","keyboard",0) 
  End 
EndIf 
OpenWindow(0,0,0,#realx,#realy,"hallo",0) 
If OpenScreen(#realx,#realy,32,"PureFire")=0 
  MessageRequester("Fire","open",0) 
  End 
EndIf 

For x=0 To #aufx-1 
  in(x,0)=1 
  in(x,#aufy-1)=1 
Next 
For y=0 To #aufy-1 
  in(0,y)=1 
  in(#aufx-1,y)=1 
Next 

For x=0 To 50 
  For y=0 To 50 
    cxx=0:cyy=0:a=-1 
    For i=0 To 360 
      cx=Int(Cos(deg(i))*x) 
      cy=Int(Sin(deg(i))*y) 
      If cx<>cxx Or cy<>cyy 
        a+1 
        KreisPointx(x,y,a)=cx 
        KreisPointy(x,y,a)=cy 
      EndIf 
    Next 
  Next 
Next 


For i=0 To 84 
  color(i)      =RGB(Int(250/84*i),0,0) 
  color(i+85)   =RGB(250,Int(250/84*i),0) 
  color(i+85+85)=RGB(250,250,Int(250/84*i)) 
Next 
color(255)=RGB(255,255,255) 


bigx=#bigmin:dbigx=1 
bigy=#bigmax:dbigy=-1 

kx=Random(#aufx):ky=Random(#aufy) 
dx=#speed:dy=#speed 

ClearScreen(RGB(0,0,0)) 
FlipBuffers() 
ClearScreen(RGB(0,0,0)) 


Repeat 
  ClearScreen(RGB(0,0,0)) 
  
  bigx+dbigx 
  If bigx>=#bigmax 
    bigx=#bigmax 
    dbigx=-Random(#speed) 
  ElseIf bigx<=#bigmin 
    bigx=#bigmin 
    dbigx=Random(#speed) 
  EndIf 

  bigy+dbigy 
  If bigy>=#bigmax 
    bigy=#bigmax 
    dbigy=-Random(#speed) 
  ElseIf bigy<=#bigmin 
    bigy=#bigmin 
    dbigy=Random(#speed) 
  EndIf    
  
  kx+dx:ky+dy 
  
  If kx<=bigx 
    kx=bigx 
    dx=Random(#speed) 
  ElseIf kx>=#aufx-bigx 
    kx=#aufx-bigx 
    dx=-Random(#speed) 
  EndIf 
  
  If ky<=bigy 
    ky=bigy 
    dy=Random(#speed) 
  ElseIf ky>=#aufy-bigy 
    ky=#aufy-bigy 
    dy=-Random(#speed) 
  EndIf 

  *cx.long=@KreisPointx(bigx,bigy,0) 
  *cy.long=@KreisPointy(bigx,bigy,0) 
  While *cx\l<>0 Or *cy\l<>0 
    x=kx+*cx\l:y=ky+*cy\l 
    If x>0 And x<#aufx-1 And y>0 And y<#aufy-1 
      addpoint(x,y)      
      col(x,y)+Random(100) 
    EndIf 
    *cx+4 
    *cy+4 
  Wend 
    
  StartDrawing(ScreenOutput()) 
  
  ResetList(punkte()) 
  While NextElement(punkte()) 
    NX=punkte()\x 
    NY=punkte()\y 
    
    c1=col(NX,NY) 
    c2=col(NX,NY+1) 
    c3=col(NX-1,NY+1) 
    c4=col(NX+1,NY+1) 
    i= (c1+c2+c3+c4-3)>>2 
    If i<0:i=0:EndIf 
    If i>255:i=255:EndIf 
        
    If i 
      addpoint(NX,NY) 
      Plot(NX,NY,color(i)) 
    Else 
      DeleteElement(punkte()) 
      in(NX,NY)=0 
    EndIf 
    col(NX,NY)=i 
    
    
  Wend 
    
  StopDrawing() 
  
  ExamineKeyboard() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 
Debug "normal end" 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
