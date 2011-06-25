;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Author : Psychophanta
;* Date : Mon Dec 15, 2008
;* Link : http://www.purebasic.fr/english/viewtopic.php?p=270752#270752
;*
;*****************************************************************************
Global *TI.IDirectDrawSurface,SS.RECT,TS.RECT,DDrawBase,dwSize=100
TS\right=1024:TS\bottom=768:InitSprite():InitKeyboard():OpenScreen(TS\right,TS\bottom,32,"")
SS\right=TS\right:SS\bottom=TS\bottom
!extrn _PB_DDrawBase
!extrn _PB_DirectX_PrimaryBuffer
!extrn _PB_DirectX_BackBuffer
!DDBLT_WAIT equ $1000000
!mov eax,dword[_PB_DirectX_PrimaryBuffer]
!test eax,eax
!jz @f
!mov dword[p_TI],eax
!jmp _start
!@@:
!push v_DDrawBase
!mov eax,dword[_PB_DirectX_BackBuffer]
!push eax
!mov eax,dword[eax]
!call dword[eax+144]
!push p_TI
!mov eax,dword[v_DDrawBase]
!push eax
!mov eax,dword[eax]
!call dword[eax+56]
!mov eax,dword[p_TI]
!_start:
Procedure b2()
  Protected r.l=0.,g.l=0.,b.l=0.
  Protected rs.l=1,gs.l=1,bs.l=1
  Protected i.l,j.l
  StartDrawing(ScreenOutput())
  For j=0 To SS\bottom-1
    For i=0 To SS\right-1
      Plot(i,j,RGB(255*Cos(r*#PI/512),255*Cos(g*#PI/512),255*Cos(b*#PI/512)))
      r+rs:If r<0 Or r>255:rs=-rs:r+rs:EndIf
;       g+gs:If g<0 Or g>255:gs=-gs:g+gs:EndIf
      b+bs:If b<0 Or b>255:bs=-bs:b+bs:EndIf
    Next
    r+rs:If r<0 Or r>255:rs=-rs:r+rs:EndIf
    g+gs:If g<0 Or g>255:gs=-gs:g+gs:EndIf
;     b+bs:If b<0 Or b>255:bs=-bs:b+bs:EndIf
  Next
  StopDrawing()
EndProcedure
b2()
Repeat
  ExamineKeyboard()
  SS\left=TS\right/2+240*Cos(alfa.f):SS\top=TS\bottom/2+192*Sin(alfa.f)
  SS\right=SS\left+256:SS\bottom=SS\top+192
  !mov eax,dword[_PB_DirectX_PrimaryBuffer]
  !push dword v_dwSize dword DDBLT_WAIT dword v_SS dword[_PB_DirectX_BackBuffer] dword v_TS eax
  !mov eax,dword[eax]
  !call dword[eax+20]
  alfa+0.01:If alfa>=2*#PI:alfa=0:EndIf
  Delay(16)
Until KeyboardPushed(#PB_Key_Escape)


