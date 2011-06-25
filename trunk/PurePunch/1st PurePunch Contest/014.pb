;*****************************************************************************
;* PurePunch Contest 
;* http://www.purebasic.fr/english/viewtopic.php?p=256341#256341
;*
;* Name   : TVnoise
;* Author : Psychophanta
;* Date   : Thu Dec 18, 2008
;* Link   : http://www.purebasic.fr/english/viewtopic.php?p=271156#271156
;*
;*****************************************************************************
;TVnoise (July 2005), by Psychophanta, adapted for Pure Punch
Global *TargetInterface.IDirectDrawSurface,SourceSurface.RECT,TargetSurface.RECT
With TargetSurface
\right=1024:\bottom=768:w.l=256:h.l=360:maxw.l=\right-w:maxh.l=\bottom-h
InitSprite():InitKeyboard()
OpenScreen(\right,\bottom,32,"TVnoise")
!extrn _PB_DDrawBase
!extrn _PB_DirectX_PrimaryBuffer
!extrn _PB_DirectX_BackBuffer
!DDBLT_WAIT equ $1000000
SourceSurface\right=\right:SourceSurface\bottom=\bottom
Procedure TargetInterfaceInit()
  !mov eax,dword[_PB_DirectX_PrimaryBuffer]
  !test eax,eax
  !jz @f
  !mov dword[p_TargetInterface],eax
  ProcedureReturn
  !@@:
  !;TargetInterfaceInit:
  !push DDrawBase
  !mov eax,dword[_PB_DirectX_BackBuffer]
  !push eax
  !mov eax,dword[eax]
  !call dword[eax+144]
  !push p_TargetInterface
  !mov eax,dword[DDrawBase]
  !push eax
  !mov eax,dword[eax]
  !call dword[eax+56]
  !mov eax,dword[p_TargetInterface]
  !;EndTargetInterfaceInit
EndProcedure
DataSection
!DDrawBase:dd 0
!dwSize:dd 100
EndDataSection
TargetInterfaceInit()
bn.l=$010101
StartDrawing(ScreenOutput())
For j.l=0 To SourceSurface\bottom-1
  For i.l=0 To SourceSurface\right-1
    Plot(i.l,j.l,Random($FF)*bn.l)
  Next
Next
StopDrawing()
Repeat
  ExamineKeyboard()
  SourceSurface\left=Random(maxw):SourceSurface\top=Random(maxh)
  SourceSurface\right=SourceSurface\left+w:SourceSurface\bottom=SourceSurface\top+h
  !mov eax,dword[_PB_DirectX_PrimaryBuffer]
  !push dword dwSize dword DDBLT_WAIT dword v_SourceSurface dword[_PB_DirectX_BackBuffer] dword v_TargetSurface eax
  !mov eax,dword[eax]
  !call dword[eax+20]
  Delay(16)
Until KeyboardPushed(#PB_Key_Escape)
ClearScreen(0):FlipBuffers(0):ClearScreen(0):CloseScreen()

