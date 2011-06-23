; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1928&highlight=
; Author: Danilo
; Date: 05. August 2003
; OS: Windows
; Demo: Yes


; Write a string-table into a PB-Dll

ProcedureDLL ShowStringTable() 
  If OpenConsole() 
    Restore StringTable 

    For a = 1 To 5 
      Read A$ 
      PrintN(A$) 
    Next a 

    Input() 
    CloseConsole() 
  EndIf 
EndProcedure 

ShowStringTable() 

DataSection 
  StringTable: 
    Data$ "Hallo!" 
    Data$ "Dies " 
    Data$ "ist ", "ein ", "Test" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
