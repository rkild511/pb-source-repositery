; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1314&highlight=
; Author: NicTheQuick
; Date: 12. June 2003
; OS: Windows
; Demo: Yes

Procedure.l RGB32(R.l, G.l, B.l, A.l) 
  RGBA.l = A << 24 + B << 16 + G << 8 + R 
  ProcedureReturn RGBA 
EndProcedure 
Procedure.l R32(RGBA.l) 
  R.l = RGBA & $FF 
  ProcedureReturn R 
EndProcedure 
Procedure.l G32(RGBA.l) 
  G.l = RGBA >> 8 & $FF 
  ProcedureReturn G 
EndProcedure 
Procedure.l B32(RGBA.l) 
  B.l = RGBA >> 16 & $FF 
  ProcedureReturn B 
EndProcedure 
Procedure.l A32(RGBA.l) 
  A.l = RGBA >> 24 
  ProcedureReturn A 
EndProcedure 


Procedure.l RGB24(R.l, G.l, B.l) 
  RGB.l = B << 16 + G << 8 + R 
  ProcedureReturn RGB 
EndProcedure 
Procedure.l R24(RGB.l) 
  R.l = RGB & $FF 
  ProcedureReturn R 
EndProcedure 
Procedure.l G24(RGB.l) 
  G.l = RGB >> 8 & $FF 
  ProcedureReturn G 
EndProcedure 
Procedure.l B24(RGB.l) 
  B.l = RGB >> 16 
  ProcedureReturn B 
EndProcedure 


Procedure.l RGB16(R.l, G.l, B.l) 
  R >> 3 
  G >> 2 
  B >> 3 
  RGB.l = B << 11 + G << 5 + R 
  ProcedureReturn RGB 
EndProcedure 
Procedure.l R16(RGB.l) 
  R.l = (RGB & $1F) << 3 
  ProcedureReturn R 
EndProcedure 
Procedure.l G16(RGB.l) 
  G.l = (RGB >> 5 & $3F) << 2 
  ProcedureReturn G 
EndProcedure 
Procedure.l B16(RGB.l) 
  B.l = (RGB >> 11 & $1F) << 3 
  ProcedureReturn B 
EndProcedure 


Procedure.l RGB15(R.l, G.l, B.l) 
  R >> 3 
  G >> 3 
  B >> 3 
  RGB.l = B << 10 + G << 5 + R 
  ProcedureReturn RGB 
EndProcedure 
Procedure.l R15(RGB.l) 
  R.l = (RGB & $1F) << 3 
  ProcedureReturn R 
EndProcedure 
Procedure.l G15(RGB.l) 
  G.l = (RGB >> 5 & $1F) << 3 
  ProcedureReturn G 
EndProcedure 
Procedure.l B15(RGB.l) 
  B.l = (RGB >> 10 & $1F) << 3 
  ProcedureReturn B 
EndProcedure 

Debug A32(RGB32(1, 2, 3, 4)) 

Debug R24(RGB24(5, 6, 7)) 

Debug G16(RGB16(88, 99, 110)) 

Debug B15(RGB15(63, 127, 255))

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
