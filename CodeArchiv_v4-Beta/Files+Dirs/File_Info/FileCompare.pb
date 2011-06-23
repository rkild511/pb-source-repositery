; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3003&start=10
; Author: Sylvia (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 06. December 2003
; OS: Windows
; Demo: Yes


; Compares two files, their path given as parameter
; Vergleicht zwei Dateien, deren Pfade werden als Parameter übergeben

; *********************************** 
; * 06.Dec.2003 "Sylvia" German Forum 
; *********************************** 

Procedure FileCompare(Pfad1$,Pfad2$) 
     ; Inhaltsvergleich zweier Dateien 
     ; Result<0        Es ist ein Fehler aufgetreten 
     ; Result=0        Dateien sind ungleich 
     ; Result=1        Dateien sind gleich 
      
     Protected LOF1, LOF2, Count, Result, KSize 
      
     KSize=1024*32   ; FileRead-Size in KB 
      
     ; Dateien nicht vorhanden oder unterschiedlich gross ? 
     LOF1=FileSize(Pfad1$): If LOF1<0: ProcedureReturn -1: EndIf 
     LOF2=FileSize(Pfad2$): If LOF2<0: ProcedureReturn -1: EndIf 
      
     If LOF1<>LOF2: ProcedureReturn 0: EndIf 
      
     If ReadFile(101,Pfad1$)=0: Result=-1: Goto FileCompareEnd: EndIf 
     If ReadFile(102,Pfad2$)=0: Result=-1: Goto FileCompareEnd: EndIf 
      
     ; vorbereiten zum Vergleich 
     *Buffer1=AllocateMemory(KSize): If *Buffer1=0: Result=-1: Goto FileCompareEnd: EndIf 
     *Buffer2=AllocateMemory(KSize): If *Buffer2=0: Result=-1: Goto FileCompareEnd: EndIf 
     CopyMemory(*Buffer1,*Buffer2,KSize) 
      
     Result=1 
     Count=0 
      
     ; Vergleich Byte by Byte in KSize-Blöcken 
     While LOF1>Count 
          If (LOF1-Count)>KSize 
               FileSeek(101,Count): ReadData(101,*Buffer1,KSize) 
               FileSeek(102,Count): ReadData(102,*Buffer2,KSize) 
               Count+KSize 
          Else 
               FileSeek(101,Count): ReadData(101,*Buffer1,LOF1-Count) 
               FileSeek(102,Count): ReadData(102,*Buffer2,LOF1-Count) 
               Count=LOF1 
          EndIf 
          
          If CompareMemory(*Buffer1,*Buffer2,KSize)=0 
               Result=0 
               Count=LOF1 
          EndIf 
     Wend 
      
     FileCompareEnd: 
     CloseFile(101) : CloseFile(102) 
     FreeMemory(*Buffer1): FreeMemory(*Buffer2) 
      
     ProcedureReturn Result 
EndProcedure    

Debug FileCompare("a.txt","b.txt")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
