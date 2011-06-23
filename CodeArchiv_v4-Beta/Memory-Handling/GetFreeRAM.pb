; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1776
; Author: Thorsten
; Date: 23. July 2003
; OS: Windows
; Demo: No

Procedure.f FreeRAM()  

   ;Eine leere Struktur erstellen 
   Info.MEMORYSTATUS 
    
   ;Die Größe der Struktur ermitteln und in ihr selbst speichern 
   Info\dwLength = SizeOf(MEMORYSTATUS) 
    
   ;Vom System die Speicherinfos hohlen 
   GlobalMemoryStatus_(@Info) 
    
   ;Zuweisen der Daten 
   Total.f = Info\dwTotalPhys 
   Free.f = Info\dwAvailPhys    
    
   ;Rückgabe der Ergebnisse, prozentual 
   ProcedureReturn (100 / Total) * Free 
EndProcedure 

Debug FreeRAM()  ; Give free memory in percent

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
