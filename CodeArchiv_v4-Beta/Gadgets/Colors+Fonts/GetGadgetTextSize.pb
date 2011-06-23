; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1631&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 07. July 2003
; OS: Windows
; Demo: No


; Erklärung:
; Manchmal wird es benötigt die exakte Größe eines Textes in Pixeln 
; für Gadgets herauszubekommen, z.B. wenn man ein Gadget an 
; die Größe des Textes anpassen möchte. 
;
; Die folgende Procedure dient dazu immer die korrekte Größe, 
; unabhängig vom benutzen Gadget-Font, herauszubekommen: 

; 
; by Danilo, 07.07.2003 - german forum 
; 
Procedure GetGadgetTextSize(GadgetNr.l,Type.l,String.s) 
  ; 
  ; Returns the size in pixels 
  ; the string needs in the gadget 
  ; 
  ;   Length = GetGadgetTextSize(GadgetNr,#TEXTLENGTH,String$) 
  ;   Height = GetGadgetTextSize(GadgetNr,#TEXTHEIGHT,String$) 
  ; 
  #TEXTLENGTH = 0 
  #TEXTHEIGHT = 1 
  hGadget = GadgetID(GadgetNr) 
  If hGadget 
    hFont   = SendMessage_(hGadget,#WM_GETFONT,0,0) 
    hDC     = GetDC_(hGadget) 
    If hFont 
      SelectObject_(hDC,hFont) 
    EndIf 
    If GetTextExtentPoint32_(hDC,String,Len(String),@TextSize.SIZE) 
      If     Type = #TEXTLENGTH ; Text-Length 
        RetVal = TextSize\cx 
      ElseIf Type = #TEXTHEIGHT ; Text-Height 
        RetVal = TextSize\cy 
      EndIf 
    EndIf 
    ReleaseDC_(hGadget,hDC) 
  EndIf 
  ProcedureReturn RetVal 
EndProcedure 


;- Example 
; 
; This example creates 3 TextGadgets, size 10x10 
; and resizes the gadgets after setting different fonts. 
; By using the procedure GetGadgetTextSize(), the 
; resizing works always correct. 
; 
A$     = "Example by Danilo, 7/7/2003" 
B$     = "Hello World !!" 
C$     = "YO!" 
hFont1 = LoadFont(1,"Arial",32,#PB_Font_Bold) 
hFont2 = LoadFont(2,"Lucida Console",72,#PB_Font_Bold|#PB_Font_Italic) 

OpenWindow(0,200,200,300,300,"GetGadgetTextLength",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 

  TextGadget   (0,10,010,10,10,A$) 
  ResizeGadget (0,10,010,GetGadgetTextSize(0,#TEXTLENGTH,A$),GetGadgetTextSize(0,#TEXTHEIGHT,A$)) 

  TextGadget   (1,10,040,10,10,B$) 
  SetGadgetFont(1,hFont1) 
  ResizeGadget (1,10,040,GetGadgetTextSize(1,#TEXTLENGTH,B$),GetGadgetTextSize(1,#TEXTHEIGHT,B$)) 

  TextGadget   (2,10,110,10,10,C$) 
  SetGadgetFont(2,hFont2) 
  ResizeGadget (2,10,110,GetGadgetTextSize(2,#TEXTLENGTH,C$),GetGadgetTextSize(2,#TEXTHEIGHT,C$)) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
