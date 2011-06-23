;**
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _

;** GetTextHeight
Procedure GetTextHeight(hDC);* Return the Height of a text; hDC=StartDrawing()
  Protected tm.TEXTMETRIC, PrevMapMode.l
  PrevMapMode=SetMapMode_(hDC,#MM_TEXT)
  GetTextMetrics_(hDC,tm)
  SetMapMode_(hDC,PrevMapMode)
  ProcedureReturn tm\tmHeight
EndProcedure

;** CatchBMP
Procedure CatchBMP(BMPaddress);* Create a ImageID from a Bitmap in Memory _
  Protected hDC.l, *pbfileh.BITMAPFILEHEADER, pbinfoh.l, pbits.l, init.l
  Protected ImageID.l
  hDC=GetDC_(GetDesktopWindow_())
  *pbfileh=BMPaddress
  pbinfoh=BMPaddress + SizeOf(BITMAPFILEHEADER)
  pbits=*pbfileh\bfOffBits ; offset
  init=BMPaddress + pbits ; bitmap data
  ImageId=CreateDIBitmap_(hDC,pbinfoh,#CBM_INIT,init,pbinfoh,#DIB_RGB_COLORS)
  ReleaseDC_(GetDesktopWindow_(),hDC)
  ProcedureReturn ImageId
EndProcedure

;** FreeCatchBMP
Procedure FreeCatchBMP(ImageId);* Give the ImageID from a CatchBMP() free
  DeleteObject_(ImageId)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 28
; Folding = -
; EnableXP
; HideErrorLog