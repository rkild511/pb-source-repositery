; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2855&highlight=
; Author: Lebostein
; Date: 08. April 2005
; OS: Windows
; Demo: No


; Hab mal das Hin- und Hergeschiebe der Farbbits vereinfacht und sogar 
; ein wenig beschleunigt. Hier mal der Vergleich der bisherigen Methode 
; und meinem Einfall gestern Nacht im Bett. Die Werte für R, G und B in 
; RGBColorFormat2() entsprechen nicht den Farbwerten, sondern den 
; Farbwerten an der entsprechenden Position. (Debugger ausschalten, 
; sonst keine realen Geschwindigkeiten!): 


;----------------------------------------------------------------- 

Procedure DX_PixelFormat() 

  ProcedureReturn #PB_PixelFormat_24Bits_BGR 

EndProcedure 

;----------------------------------------------------------------- 

Procedure RGBColorFormat1(RGB) ;bisheriges Vorgehen 

  R = Red(RGB) 
  G = Green(RGB) 
  B = Blue(RGB) 

  Select DX_PixelFormat() 

  Case #PB_PixelFormat_15Bits     : ProcedureReturn B >> 3 + (G >> 3) << 5 + (R >> 3) << 10 
  Case #PB_PixelFormat_16Bits     : ProcedureReturn B >> 3 + (G >> 2) << 5 + (R >> 3) << 11 
  Case #PB_PixelFormat_24Bits_RGB : ProcedureReturn R + G << 8 + B << 16 
  Case #PB_PixelFormat_24Bits_BGR : ProcedureReturn B + G << 8 + R << 16 
  Case #PB_PixelFormat_32Bits_RGB : ProcedureReturn R + G << 8 + B << 16 
  Case #PB_PixelFormat_32Bits_BGR : ProcedureReturn B + G << 8 + R << 16 

  EndSelect 

EndProcedure 

;----------------------------------------------------------------- 

Procedure RGBColorFormat2(RGB) ;Andere Möglichkeit 

  Select DX_PixelFormat() 

  Case #PB_PixelFormat_15Bits 
  R = (RGB & $0000F8) << 07 
  G = (RGB & $00F800) >> 06 
  B = (RGB & $F80000) >> 19 

  Case #PB_PixelFormat_16Bits 
  R = (RGB & $0000F8) << 08 
  G = (RGB & $00FC00) >> 05 
  B = (RGB & $F80000) >> 19 

  Case #PB_PixelFormat_24Bits_RGB 
  R = (RGB & $0000FF) 
  G = (RGB & $00FF00) 
  B = (RGB & $FF0000) 

  Case #PB_PixelFormat_24Bits_BGR 
  R = (RGB & $0000FF) << 16 
  G = (RGB & $00FF00) 
  B = (RGB & $FF0000) >> 16 

  Case #PB_PixelFormat_32Bits_RGB 
  R = (RGB & $0000FF) 
  G = (RGB & $00FF00) 
  B = (RGB & $FF0000) 

  Case #PB_PixelFormat_32Bits_BGR 
  R = (RGB & $0000FF) << 16 
  G = (RGB & $00FF00) 
  B = (RGB & $FF0000) >> 16 

  EndSelect 

  ProcedureReturn R + G + B 

EndProcedure 

;----------------------------------------------------------------- 

#count = 10000000 
RGB = $FAFAFA 

timeGetDevCaps_(TimerCaps.TIMECAPS, SizeOf(TIMECAPS)) 
timeBeginPeriod_(TimerCaps.TIMECAPS\wPeriodMin) 

start = timeGetTime_() 
For i = 1 To #count: RGBColorFormat1(RGB): Next i 
ende1 = timeGetTime_() - start 

start = timeGetTime_() 
For i = 1 To #count: RGBColorFormat2(RGB): Next i 
ende2 = timeGetTime_() - start 

timeEndPeriod_(TimerCaps.TIMECAPS\wPeriodMin) 

MessageRequester("Ergebnis:", "Variante1: " + Str(ende1) + "ms" + #CR$ + "Variante2: " + Str(ende2) + "ms")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger