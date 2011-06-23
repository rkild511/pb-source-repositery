; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12892&postdays=0&postorder=asc&start=15
; Author: gnozal (updated for PB 4.00 by Andre)
; Date: 15. December 2004
; OS: Windows
; Demo: No

; 
; Code example : how to colorize standard buttons   (part of the PureCOLOR userlib)
; 

; -------------------------------------------------------- 
; Get Text Height (only a TextLength() function in PB) 
; 
Procedure GetTextHeight(hdc.l) 
  Protected tm.textmetric, PrevMapMode.l 
  PrevMapMode = SetMapMode_(hdc, #MM_TEXT) 
  GetTextMetrics_(hdc, @tm) 
  If PrevMapMode 
    SetMapMode_(hdc, PrevMapMode) 
  EndIf 
  ProcedureReturn tm\tmHeight 
EndProcedure 

; -------------------------------------------------------- 
; Create color button (fake with image) 
; 
Procedure CreateColoredButton(GadgetNumber.l, ImageNumber.l, ButtonTextColor.l, ButtonBackColor.l) 
  Protected ButtonW.l, ButtonH.l, hFont.l, ButtonText.s, Button_hdc.l, GadgetHandle.l 
  ButtonW = GadgetWidth(GadgetNumber) 
  ButtonH = GadgetHeight(GadgetNumber) 
  GadgetHandle = GadgetID(GadgetNumber) 
  If CreateImage(ImageNumber, ButtonW, ButtonH) 
    ; Create image 
    Button_hdc = StartDrawing(ImageOutput(ImageNumber)) 
    ; Button color 
    Box(0, 0, ButtonW, ButtonH, ButtonBackColor) 
    ; Button font 
    hFont = SendMessage_(GadgetHandle, #WM_GETFONT, 0, 0) 
    DrawingFont(hFont) 
    ; Button text 
    ButtonText = GetGadgetText(GadgetNumber) 
    FrontColor(ButtonTextColor) 
    DrawingMode(1) 
    DrawText((ButtonW - TextWidth(ButtonText)) / 2, (ButtonH - GetTextHeight(Button_hdc)) / 2, ButtonText) 
    StopDrawing() 
    ; Add bitmap style 
    SetWindowLong_(GadgetHandle, #GWL_STYLE, GetWindowLong_(GadgetHandle, #GWL_STYLE) | #BS_BITMAP) 
    ; Use image 
    SendMessage_(GadgetHandle, #BM_SETIMAGE, #IMAGE_BITMAP, ImageID(ImageNumber)) 
  EndIf 
EndProcedure 

; -------------------------------------------------------- 
; Clear button color 
; 
Procedure ClearColoredButton(GadgetNumber.l, ImageNumber.l) 
  Protected GadgetHandle.l 
  GadgetHandle = GadgetID(GadgetNumber) 
  ; Substract bitmap style 
  SetWindowLong_(GadgetHandle, #GWL_STYLE, GetWindowLong_(GadgetHandle, #GWL_STYLE) & ~#BS_BITMAP) 
  ; Free image 
  FreeImage(ImageNumber) 
EndProcedure 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -