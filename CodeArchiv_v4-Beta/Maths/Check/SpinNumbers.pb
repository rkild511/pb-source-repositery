; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14136&start=15
; Author: Guimauve
; Date: 28. March 2005
; OS: Windows, Linux
; Demo: Yes


ProcedureDLL.l SpinLong(No.l, mini.l, maxi.l, increment.l) 
     No + increment 
      
     If No > maxi 
          No = mini 
     EndIf 
      
     If No < mini 
          No = maxi 
     EndIf 

     ProcedureReturn No 
EndProcedure 


ProcedureDLL.f SpinFloat(No.f, mini.f, maxi.f, increment.f) 
     No + increment 
      
     If No > maxi 
          No = mini 
     EndIf 
      
     If No < mini 
          No = maxi 
     EndIf 
      
     ProcedureReturn No 
EndProcedure 


ProcedureDLL.b SpinByte(No.b, mini.b, maxi.b, increment.b) 
     No + increment 
      
     If No > maxi 
          No = mini 
     EndIf 
      
     If No < mini 
          No = maxi 
     EndIf 
      
     ProcedureReturn No 
EndProcedure 


ProcedureDLL.w SpinWord(No.w, mini.w, maxi.w, increment.w) 
     No + increment 
      
     If No > maxi 
          No = mini 
     EndIf 
      
     If No < mini 
          No = maxi 
     EndIf 
      
     ProcedureReturn No 
EndProcedure


;- Example 
For a = 70 To 90
  Debug SpinLong(a, 80, 90, 5)
Next

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -