; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8324&highlight=
; Author: griz & Psychophanta
; Date: 13. November 2003
; OS: Windows
; Demo: No


; /// return approx distance between 2 points /// 
; /// usage : approx_distance(x1-x2,y1-y2)    /// 

; The distance between 2 points is 2 sets of xy coordinates.
; So say point 1 is (x=5, y=10) and point 2 is (x=15, y=20).
; To find the distance between them i call the function like this: 
; distance(15 - 5, 20 - 10) 

Procedure approx_distance(xx,yy) 
  xx=Abs(xx) 
  yy=Abs(yy) 
  If xx<yy 
    ProcedureReturn (yy<<8+yy<<3-yy<<4-yy<<1+xx<<7-xx<<5+xx<<3-xx<<1)>>8 
  Else 
    ProcedureReturn (xx<<8+xx<<3-xx<<4-xx<<1+yy<<7-yy<<5+yy<<3-yy<<1)>>8 
  EndIf 
EndProcedure 

Procedure.f distance(xx.f,yy.f) 
  !;finit 
  !fld dword[esp] ;push xx to FPU stack (to st0) 
  !fmul st0,st0 
  !fld dword[esp+4] ;push yy value to FPU stack (to st0) (xx is now in st1) 
  !fmul st0,st0 
  !faddp 
  !fsqrt 
EndProcedure 

Procedure.l approx_distanceASM(xx.l,yy.l) 
  !mov eax,dword[esp] 
  !mov ebx,dword[esp+4] 
  !cmp eax,0 
  !jnl @f 
  !neg eax 
  !@@: 
  !cmp ebx,0 
  !jnl @f 
  !neg ebx 
  !@@: 
  !cmp eax,ebx 
  !jnl @f 
  !xchg eax,ebx  
  !@@: 
  !mov edx,eax 
  !shl edx,1 
  !shl eax,3 
  !sub eax,edx 
  !shl edx,3 
  !sub eax,edx 
  !shl edx,4 
  !add eax,edx 
  !; 
  !mov edx,ebx 
  !shl edx,1 
  !shl ebx,3 
  !sub ebx,edx 
  !shl edx,4 
  !sub ebx,edx 
  !shl edx,2 
  !add ebx,edx 
  !; 
  !add eax,ebx 
  !shr eax,8 
  ProcedureReturn 
EndProcedure 

;-PROVE IT: 
DisableDebugger 
cx1=13:cx2=782:cy1=345:cy2=286 

tt=GetTickCount_() 
For t=1 To 1000000 
  approx_distance(cx2-cx1,cy2-cy1) 
Next 
EnableDebugger 
Debug GetTickCount_()-tt 

DisableDebugger 
tt=GetTickCount_() 
!finit 
For t=1 To 1000000 
  distance(cx2-cx1,cy2-cy1) 
Next 
EnableDebugger 
Debug GetTickCount_()-tt 

DisableDebugger 
tt=GetTickCount_() 
For t=1 To 1000000 
  approx_distanceASM(cx2-cx1,cy2-cy1) 
Next 
EnableDebugger 
Debug GetTickCount_()-tt 


Debug "" 
Debug approx_distance(cx2-cx1,cy2-cy1) 
Debug distance(cx2-cx1,cy2-cy1) 
Debug approx_distanceASM(cx2-cx1,cy2-cy1) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
