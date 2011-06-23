; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2374&highlight=
; Author: NicTheQuick (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 24. September 2003
; OS: Windows
; Demo: Yes

; Read (then you can do probably some changes) and write files blockwise
; (example here works with 4096 Byte memory blocks

; Die Procedure liest die erste Datei ein und entfernt aus ihr alle Zeichen mit dem
; ASCII-Code 32, 13 und 10. Bei meiner 10 MB Primzahlen-Datei dauert das ganze ca.
; 2 Sekunden mit aktiviertem Debugger.

#Block = 4096 
Procedure CopyFiles(File1.s, File2.s) 
  Protected *Mem0.BYTE, *Mem1.BYTE 
  Protected MaxBytes.l, ChangedBytes.l 
  
  If ReadFile(0, File1)   ;1. Datei zum Lesen ˆffnen 
    If CreateFile(1, File2)   ;2. Datei zum Schreiben ˆffnen 
      Mem0 = AllocateMemory(#Block)  ;Speicher 0 mit 4096 Bytes reservieren 
      If Mem0
        Mem1 = AllocateMemory(#Block)  ;Speicher 1  mit 4096 Bytes reservieren 
        If Mem1
          While Eof(0) = 0  ;Wiederhole diese Schleife bis die Datei zu Ende ist 
            ;Benutze Lesedatei 
            If Lof(0) - Loc(0) > #Block   ;Wenn die restlichen Bytes in der Datei mehr als 4096 
              MaxBytes = #Block         ;Bytes betragen, dann begrenze das auf 4096 Bytes, 
            Else                        ;ansonsten nimm den Rest. 
              MaxBytes = Lof(0) - Loc(0) 
            EndIf 
            
            ReadData(0,*Mem0, MaxBytes)   ;Lies den n‰chsten Datenblock in der Datei in Speicher 0 ein 
            
            ;Quelle ‰ndern 
            ChangedBytes = 0 
            For a = 1 To MaxBytes   ;Wiederhole die Schleife so oft wie Bytes vorhanden sind 
              If *Mem0\b <> 32 And *Mem0\b <> 13 And *Mem0\b <> 10  ;Wenn kein Zeichen mit 32, 13, 10 da ist 
                *Mem1\b = *Mem0\b   ;Speichere das Byte von Speicher 0 in Speicher 1 
                *Mem1 + 1           ;Gehe in Speicher 1 um ein Byte weiter 
                ChangedBytes + 1    ;Z‰hle die in Speicher 1 abgelegten Bytes 
              EndIf 
              *Mem0 + 1     ;Gehe in Speicher 0 um ein Byte weiter 
            Next 
            ;Benutze die Schreibdatei 
            WriteData(1,Mem1, ChangedBytes)   ;Schreibe die in Speicher 1 abgelegten Bytes in die Datei 
          Wend 
          FreeMemory(Mem1)   ;Gib Speicher 1 wieder frei 
        EndIf 
        FreeMemory(Mem0)   ;Gib Speicher 0 wieder frei 
      EndIf 
      CloseFile(1)    ;Schlieﬂe Datei 1 
    EndIf 
    CloseFile(0)    ;Schlieﬂe Datei 0 
  EndIf 
EndProcedure 

CopyFiles("c:\Primzahlen1.txt", "c:\Primzahlen1.txt2")

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
