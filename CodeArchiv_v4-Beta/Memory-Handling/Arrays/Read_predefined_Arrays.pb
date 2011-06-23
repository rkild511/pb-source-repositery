; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2010&highlight=
; Author: Friedhelm
; Date: 20. August 2003
; OS: Windows
; Demo: Yes

DataSection 
  data_VertexOffset: 
  ; OffS   0    1    2    3    4    5    6    7   ; Row 
  Data.f 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0   ;  0 
  Data.f 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 1.0   ;  1 
  Data.f 0.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0   ;  2 
EndDataSection 

  Structure X 
  x.f[3] 
  EndStructure 

  Structure X_Y 
    y.X[8] 
  EndStructure 
  
  *VertexOffset.X_Y = ?data_VertexOffset 
  
    
  For i1 = 0 To 7 
    For i2 = 0 To 2 
      Debug *VertexOffset\y[i1]\x[i2] 
    Next 
  Next 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
