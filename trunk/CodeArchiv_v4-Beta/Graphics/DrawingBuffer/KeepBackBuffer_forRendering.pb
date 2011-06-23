; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2731&highlight=
; Author: Stefan Moebius
; Date: 05. November 2003
; OS: Windows
; Demo: Yes


; Problem:
; Gibt es nicht eine Möglichkeit, den Backbuffer in den SpecialFX-Buffer zu kopieren,
; das vorher gezeichnetes nicht verloren geht und das Rendern darauf möglich ist?

!extrn _PB_DirectX_BackBuffer
!extrn _PB_Sprite_FXBuffer

Procedure GetBackDDS()
  !MOV Eax,[_PB_DirectX_BackBuffer]
  ProcedureReturn
EndProcedure

Procedure GetFxDDS()
  !MOV Eax,[_PB_Sprite_FXBuffer]
  ProcedureReturn
EndProcedure

Procedure DisplayBackBuffer()
  CallFunctionFast(PeekL(PeekL(GetFxDDS())+$1C),GetFxDDS(),0,0,GetBackDDS(),0,16)
EndProcedure



InitSprite()

OpenScreen(1024,768,16,"DisplayBackBuffer")

StartDrawing(ScreenOutput())
LineXY(0,0,1024,768,$FFFFFF)
StopDrawing()

StartSpecialFX()
DisplayBackBuffer()
DisplayRGBFilter(100,100,100,100,128,255,128)
StopSpecialFX()

FlipBuffers()

Delay(5000)
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
