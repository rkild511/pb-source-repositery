; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7957&highlight=
; Author: Num3 (updated for PB 4.00 by Andre)
; Date: 18. October 2003
; OS: Windows
; Demo: Yes


; *** UPC BARCODE ***
;
; by Num3 - 2003
;
; Credit must be given to me if procedure is used ;)


; A small procedure that generates a Universal Product Code Barcode
Procedure barcode(lnumber.s,rnumber.s,size.l,target.s)
  
  ; *** Check Input ***
  
  If lnumber="" Or rnumber="" Or size<1 Or target=""
    ProcedureReturn
  EndIf
  
  ; *** Barcode Digits ***
  ; Left Digits
  
  Dim digitsl.s(10)
  
  digitsl(0)="0001101"
  digitsl(1)="0011001"
  digitsl(2)="0010011"
  digitsl(3)="0111101"
  digitsl(4)="0100011"
  digitsl(5)="0110001"
  digitsl(6)="0101111"
  digitsl(7)="0111011"
  digitsl(8)="0110111"
  digitsl(9)="0001011"
  
  ; Rigth Digits
  Dim digitsr.s(10)
  
  digitsr(0)="1110010"
  digitsr(1)="1100110"
  digitsr(2)="1101100"
  digitsr(3)="1000010"
  digitsr(4)="1011100"
  digitsr(5)="1001110"
  digitsr(6)="1010000"
  digitsr(7)="1000100"
  digitsr(8)="1001000"
  digitsr(9)="1110100"
  
  
  ; *** CONVERSION ***
  
  out.s="101" ; Left start bars
  
  For x=1 To Len(lnumber)
    out.s + digitsl(Val(Mid(lnumber,x,1)))
  Next
  
  out.s + "01010"  ; Middle bars
  
  For x=1 To Len(rnumber)
    out.s + digitsr(Val(Mid(rnumber,x,1)))
  Next
  
  out.s+"101" ; Right end bars
  
  unit= size
  width= Len(out) * unit
  height=width/2
  
  
  ; *** DRAWING ***
  CreateImage(0,width,height)
  
  StartDrawing(ImageOutput(0))
  Box(0,0,width,height,RGB(255,255,255))
  For x=1 To Len(out)
    If Mid(out,x,1) = "0"
      color=RGB(255,255,255)
    ElseIf Mid(out,x,1) = "1"
      color=RGB(0,0,0)
    EndIf
    If x < 4 Or x > Len(out)-4
      Box(unit * (x-1), 0 ,unit,height,color)
    Else
      Box(unit * (x-1), 0 ,unit,height-(2*unit),color)
    EndIf
  Next
  StopDrawing()
  
  SaveImage(0,target+".bmp")
  
EndProcedure






; *** USAGE ***

; lnumber.s - Left Number
; rnumber.s - Right Number
; size.l    - Width in pixels of one bar
; target.s  - Location and file name (without extention)

barcode("423537","001012",2,"UPC_BARCODE")    ; original filename was "c:\UPC_BARCODE"
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
