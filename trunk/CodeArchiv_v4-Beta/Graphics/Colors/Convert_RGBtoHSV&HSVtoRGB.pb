; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8251&highlight=
; Author: tinman (updated for PB 4.00 by Deeem2031)
; Date: 08. November 2003
; OS: Windows
; Demo: Yes


; RGB to HSV colour converter and back again 
; From: http://astronomy.swin.edu.au/~pbourke/colour/hsv/ 

#USE_ASM_PROCEDURES=1

CompilerIf #USE_ASM_PROCEDURES=1 
; Uses the MinF and MaxF functions posted to the tricks & tips forum by Psychophanta 
Procedure.f MinF(n1.f,n2.f) 
  !finit 
  !fld dword[p.v_n2] 
  !fld dword[p.v_n1] 
  !fcomi st1 
  !fcmovnb st1 
  ProcedureReturn
EndProcedure 

Procedure.f MaxF(n1.f,n2.f) 
  !finit 
  !fld dword[p.v_n2] 
  !fld dword[p.v_n1] 
  !fcomi st1 
  !fcmovb st1
  ProcedureReturn
EndProcedure 
CompilerElse 

Procedure.f MinF(n1.f, n2.f) 
  If n1<n2 
    ProcedureReturn n1 
  EndIf 
  ProcedureReturn n2 
EndProcedure 

Procedure.f MaxF(n1.f, n2.f) 
  If n1>n2 
    ProcedureReturn n1 
  EndIf 
  ProcedureReturn n2 
EndProcedure 

CompilerEndIf 


Structure COLOUR 
    r.f 
    g.f 
    b.f 
EndStructure 


Structure HSV 
    h.f 
    s.f 
    v.f 
EndStructure 


; 
;    Calculate RGB from HSV, reverse of RGB2HSV() 
;    R,G,B are all values between 0 and 1 for intensity of colour 
;    Hue is in degrees 
;    Lightness is between 0 And 1 
;    Saturation is between 0 And 1 
Procedure HSV2RGB(*c1.HSV, *rgb.COLOUR) 
    Define.COLOUR  sat 

    While *c1\h < 0 
        *c1\h = *c1\h + 360 
    Wend 
    
    While *c1\h > 360 
        *c1\h = *c1\h - 360 
    Wend 

    If *c1\h < 120 
        sat\r = (120 - *c1\h) / 60.0 
        sat\g = *c1\h / 60.0 
        sat\b = 0 
    ElseIf *c1\h < 240 
        sat\r = 0 
        sat\g = (240 - *c1\h) / 60.0 
        sat\b = (*c1\h - 120) / 60.0 
    Else 
        sat\r = (*c1\h - 240) / 60.0 
        sat\g = 0 
        sat\b = (360 - *c1\h) / 60.0 
    EndIf 
    
    sat\r = MinF(sat\r, 1) 
    sat\g = MinF(sat\g, 1) 
    sat\b = MinF(sat\b, 1) 

    *rgb\r = (1 - *c1\s + *c1\s * sat\r) * *c1\v 
    *rgb\g = (1 - *c1\s + *c1\s * sat\g) * *c1\v 
    *rgb\b = (1 - *c1\s + *c1\s * sat\b) * *c1\v 
EndProcedure 


; 
;    Calculate HSV from RGB 
;    R,G,B are all values between 0 and 1 for intensity of colour 
;    Hue is in degrees 
;    Lightness is betweeen 0 And 1 
;    Saturation is between 0 And 1 
Procedure RGB2HSV(*c1.COLOUR, *hsv.HSV) 
    Define.f   themin,themax,delta 

    themin = MinF(*c1\r,MinF(*c1\g,*c1\b)) 
    themax = MaxF(*c1\r,MaxF(*c1\g,*c1\b)) 
    delta = themax - themin 
    
    Debug themax 
    Debug themin 
    Debug delta 
    
    *hsv\v = themax 
    *hsv\s = 0 
    If themax > 0 
        *hsv\s = delta / themax 
    EndIf 
    
    *hsv\h = 0 
    If delta > 0 
        If themax=*c1\r And themax<>*c1\g 
            *hsv\h = *hsv\h + ((*c1\g - *c1\b) / delta) 
        EndIf 
        
        If themax=*c1\g And themax<>*c1\b 
            *hsv\h = *hsv\h + (2 + (*c1\b - *c1\r) / delta) 
        EndIf 
        
        If themax=*c1\b And themax<>*c1\r 
            *hsv\h = *hsv\h + (4 + (*c1\r - *c1\g) / delta) 
        EndIf 
        
        *hsv\h = *hsv\h * 60 
    EndIf 
EndProcedure 


; Small demo 
Define.COLOUR  rgb 
Define.HSV     hsv 

rgb\r = 1 : rgb\g = 0 : rgb\b = 0 
RGB2HSV(@rgb, @hsv) 
Debug StrF(hsv\h)+", "+StrF(hsv\s)+", "+StrF(hsv\v) 

;hsv\h = 0 : hsv\s = 1 : hsv\v = 1 
HSV2RGB(@hsv, @rgb) 
Debug StrF(rgb\r)+", "+StrF(rgb\g)+", "+StrF(rgb\b) 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
