; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1317&highlight=
; Author; Franco
; Date: 12. June 2003
; OS: Windows
; Demo: No

; (c) 2003 Franco's template - absolutely freeware 
; What is the status of the Windows-AppBar? 

Structure AppBar 
  NotUsed1.l 
  NotUsed2.l 
  NotUsed3.l 
  Position.l 
  LeftX.l 
  LeftY.l 
  RightX.l 
  RightY.l 
EndStructure 

Info.AppBar 

; Is AutoHide of AppBar active ? 
; Result: 0 = no , 1 = yes 
AppBarHide=SHAppBarMessage_(4,Info)-2 ; don't know axactly why I have to substract 2 
If AppBarHide = 0 : AppBarHide$ = "no" : EndIf 
If AppBarHide = 1 : AppBarHide$ = "yes" : EndIf 

; Position of the Windows-AppBar 
; Value of position information:  0 = left, 1 = top, 2 = right, 3 = bottom 
SHAppBarMessage_(5,Info) 
If Info\Position = 0 : Position$ = "left" : EndIf 
If Info\Position = 1 : Position$ = "top" : EndIf 
If Info\Position = 2 : Position$ = "right" : EndIf 
If Info\Position = 3 : Position$ = "bottom" : EndIf 

; Visible Height and Width of the Windows-AppBar 
; Real AppBar is always 2 pixel outside the Desktop 
; Only Micro$oft know's why! 
; Value of Height and Width: pixel 
LeftX$=Str(Info\LeftX) 
LeftY$=Str(Info\LeftY) 
RightX$=Str(Info\RightX) 
RightY$=Str(Info\RightY) 

; Now it's time to view the information 
Text$="AutoHide of AppBar active: "+AppBarHide$ 
Text$=Text$+Chr(13)+"Position of AppBar: "+Position$+Chr(13) 
Text$=Text$+Chr(13)+"Remember:" 
Text$=Text$+Chr(13)+"AppBar is always 2 pixel outside the Desktop!" 
Text$=Text$+Chr(13)+"Only Micro$oft know's why!"+Chr(13) 

RealHeight$=Str(Info\RightY-Info\LeftY) 
Text$=Text$+Chr(13)+"Real Height of AppBar: "+RealHeight$ 

RealWidth$=Str(Info\RightX-Info\LeftX) 
Text$=Text$+Chr(13)+"Real Width of AppBar: "+RealWidth$+Chr(13) 

Text$=Text$+Chr(13)+"Real left X position of AppBar: "+LeftX$ 
Text$=Text$+Chr(13)+"Real left Y position of AppBar: "+LeftY$ 
Text$=Text$+Chr(13)+"Real right X position of AppBar: "+RightX$ 
Text$=Text$+Chr(13)+"Real right Y position of AppBar: "+RightY$+Chr(13) 

PosVertical = Info\Position 
PosHorizontal = Info\Position 

If PosVertical = 0 Or PosHorizontal = 2 : VisibleHeight$=Str(Info\RightY-Info\LeftY-4) : Else : VisibleHeight$=Str(Info\RightY-Info\LeftY-2) : EndIf 
Text$=Text$+Chr(13)+"Visible Height of AppBar: "+VisibleHeight$ 

If PosVertical = 1 Or PosHorizontal = 3 : VisibleWidth$=Str(Info\RightX-Info\LeftX-4) : Else : VisibleWidth$=Str(Info\RightX-Info\LeftX-2) : EndIf 
Text$=Text$+Chr(13)+"Visible Width of AppBar: "+VisibleWidth$+Chr(13) 

If Info\Position = 0 : RightX$=Str(Info\RightX) : Else : RightX$=Str(Info\RightX-2) : EndIf 
If Info\Position = 1 : RightY$=Str(Info\RightY) : Else : RightY$=Str(Info\RightY-2) : EndIf 
If Info\Position = 2 : LeftX$=Str(Info\LeftX) : Else : LeftX$=Str(Info\LeftX+2) : EndIf 
If Info\Position = 3 : LeftY$=Str(Info\LeftY) : Else : LeftY$=Str(Info\LeftY+2) : EndIf 

Text$=Text$+Chr(13)+"Visible left X position of AppBar: "+LeftX$ 
Text$=Text$+Chr(13)+"Visible left Y position of AppBar: "+LeftY$ 
Text$=Text$+Chr(13)+"Visible right X position of AppBar: "+RightX$ 
Text$=Text$+Chr(13)+"Visible right Y position of AppBar: "+RightY$ 

MessageRequester("(c) Franco's AppBarInfo",Text$,0) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
