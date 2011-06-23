; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2887&highlight=
; Author: DarkDragon (based on code by Rings, extended by Andre)
; Date: 09. April 2005
; OS: Windows
; Demo: No


; Get the color under the mouse cursor
; Farbe des Punktes unter dem Mauscursor ermitteln

Procedure GetColorUnderMouse() 
  GetCursorPos_(@CursorPos.POINT ) 
  hDC = GetDC_(0) 
  If hDC <> 0 
    Color = GetPixel_(hDC,CursorPos\x,CursorPos\y) 
    ReleaseDC_(0, hDC) 
    ProcedureReturn Color 
  EndIf 
EndProcedure 

color.l = GetColorUnderMouse()

Debug "Color:"
Debug color

Debug "Color in Hex format:"
Debug Hex(color)

Debug "Color in RGB values:"
Debug Red(color)
Debug Green(color)
Debug Blue(color)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -