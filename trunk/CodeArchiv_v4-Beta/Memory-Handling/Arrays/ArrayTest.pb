; www.purearea.net
; Author: Marcus Bode
; Date: 09. November 2003
; OS: Windows
; Demo: Yes

;;;;;;;;;;
; Array Test
;with the help of the german forum
;@NicTheQuick,Friedhelm
;2003-09-28
;Marcus
;;;;;;;;;;

;;;;;;;;;;
; Array 01
;;;;;;;;;;
#SIZEOF_BYTE  = 1 
#SIZEOF_WORD  = 2 
#SIZEOF_LONG  = 4 
#SIZEOF_FLOAT = 4 

Dim VertexOffset01.f(7,2) 
CopyMemory(?data_VertexOffset,VertexOffset01(), (8*3) *#SIZEOF_FLOAT) 

;;;;;;;;;;
; Array 02
;;;;;;;;;;
Dim VertexOffset02.f(7,2)
Restore data_VertexOffset
For i=0 To 7
  For ii=0 To 2
    Read VertexOffset02(i,ii)
  Next
Next

;;;;;;;;;;
; Array 03
;;;;;;;;;;
Dim VertexOffset03.f(7,2) 
VertexOffset03() = ?data_VertexOffset ; direkte Adresse 

;;;;;;;;;;
; Array 04
;;;;;;;;;;
Structure X
  x.f[3]
EndStructure

Structure X_Y
  y.X[8]
EndStructure

*VertexOffset04.X_Y = ?data_VertexOffset

;;;;;;;;;;
; Array 05
;;;;;;;;;;
Procedure GetArray(Zeile.l, Spalte.l)
  Protected MaxZeilen.l, MaxSpalten.l, *Value.Float
  MaxZeilen = 7
  MaxSpalten = 2
  If Zeile > MaxZeilen Or Spalte > MaxSpalten : ProcedureReturn 0 : EndIf
  *Value = ?data_VertexOffset + ((Zeile * (MaxSpalten+1)) + Spalte) * 4
  ProcedureReturn *Value\f
EndProcedure


;;;;;;;;;;
;Array Data
;;;;;;;;;;
DataSection 
  data_VertexOffset: 
      ; OffS   0     1     2  ; Row 
      Data.f  1.0,  2.0,  3.0 ;  0 
      Data.f  4.0,  5.0,  6.0 ;  1
      Data.f  7.0,  8.0,  9.0 ;  2
      Data.f 10.0, 11.0, 12.0 ;  3
      Data.f 13.0, 14.0, 15.0 ;  4
      Data.f 16.0, 17.0, 18.0 ;  5
      Data.f 19.0, 20.0, 21.0 ;  6
      Data.f 22.0, 23.0, 24.0 ;  7 
EndDataSection 

;;;;;;;;;;
;Array Debug
;;;;;;;;;;
For i=0 To 7
  For ii=0 To 2
    Debug ii+i*3+1
    Debug VertexOffset01(i,ii)
    Debug VertexOffset02(i,ii)
    Debug VertexOffset03(i,ii)
    Debug *VertexOffset04\y[i]\x[ii]
    Debug GetArray(i,ii)
  Next
Next


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -