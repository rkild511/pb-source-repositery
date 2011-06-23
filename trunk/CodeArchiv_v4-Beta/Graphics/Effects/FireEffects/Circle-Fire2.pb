; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5156#5156
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 29. April 2003
; OS: Windows
; Demo: Yes


;#realx=1024:#realy=768 
;#realx=800:#realy=600 
;#realx=640:#realy=480 
;#realx=512:#realy=384 
#realx=400:#realy=300 
;#realx=320:#realy=240 
;#realx=320:#realy=200 

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


; Structure long    ; already declared in PB 3.70+
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
Procedure addpoint(x,y) 
  ;If x>0 And x<#aufx-1 And y>0 And y<#aufy-1 
    in(x,y)=1 
    ;in(x-1,y)=1 
    ;in(x+1,y)=1 
    in(x,y-1)=1 
    in(x-1,y-1)=1 
    in(x+1,y-1)=1 
    ;in(x,y+1)=1 
    ;in(x-1,y+1)=1 
    ;in(x+1,y+1)=1 
  ;EndIf 
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

NewMinX=1:NewMaxX=#aufx-2 
NewMinY=1:NewMaxY=#aufy-2 

Repeat 
  OldMinX=NewMinX-1:OldMaxX=NewMaxX+1 
  OldMinY=NewMinY-1:OldMaxY=NewMaxY+1 
  
  If OldMinX<1:       OldMinX=1       :EndIf 
  If OldMaxX>#aufx-2: OldMaxX=#aufx-2 :EndIf 
  If OldMinY<1:       OldMinY=1       :EndIf 
  If OldMaxY>#aufy-2: OldMaxY=#aufy-2 :EndIf 
  
  NewMinX=#aufx-2:NewMaxX=1 
  NewMinY=#aufy-2:NewMaxY=1 
  
  
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
      If x<NewMinX 
        NewMinX=x 
      ElseIf x>NewMaxX 
        NewMaxX=x 
      EndIf 
      
      If y<NewMinY 
        NewMinY=y 
      ElseIf y>NewMaxY 
        NewMaxY=y 
      EndIf 
      
      col(x,y)+Random(100) 
      addpoint(x,y) 
    EndIf 
    *cx+4 
    *cy+4 
  Wend 
    
  StartDrawing(ScreenOutput()) 
  
  CompilerIf #updown 
    For NY=OldMinY To OldMaxY 
  CompilerElse 
    For NY=OldMaxY To OldMinY Step -1 
  CompilerEndIf 

    For NX=OldMinX To OldMaxX 
      If in(NX,NY) 
        c1=col(NX,NY) 
        c2=col(NX,NY+1) 
        c3=col(NX-1,NY+1) 
        c4=col(NX+1,NY+1) 
        i= (c1+c2+c3+c4)>>2-1 
        
        If i<0:i=0:EndIf 
        If i>255:i=255:EndIf 
        
        
        col(NX,NY)=i 
        
        If i 
          If NX<NewMinX 
            NewMinX=NX 
          ElseIf NX>NewMaxX 
            NewMaxX=NX 
          EndIf 
          
          If NY<NewMinY 
            NewMinY=NY 
          ElseIf NY>NewMaxY 
            NewMaxY=NY 
          EndIf 
          addpoint(NX,NY) 
        Else 
          in(NX,NY)=0 
        EndIf 
        Plot(NX,NY,color(i)) 
      EndIf 
    Next 
  Next 
    
  StopDrawing() 
  
  ExamineKeyboard() 
  FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 
Debug "normal end" 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
