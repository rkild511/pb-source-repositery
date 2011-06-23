; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1350&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 14. June 2003
; OS: Windows
; Demo: Yes

OpenConsole() 

If ReadFile(0,"test.mp3")    ; Pfad ggf. anpassen !!!
  MemPointer = AllocateMemory(128) ; 128 byte reservieren 
  If MemPointer
    FileSeek(0,Lof(0)-128) 
    ReadData(0,MemPointer, 128) ; die letzten 128 byte der Datei auslesen 

    header$    = PeekS(MemPointer, 3) 

    If header$ = "TAG"                               ;  3 Zeichen 
      songtitle$ = Trim(PeekS(MemPointer +   3,30)) ; 30 Zeichen 
      artist$    = Trim(PeekS(MemPointer +  33,30)) ; 30 Zeichen 
      album$     = Trim(PeekS(MemPointer +  63,30)) ; 30 Zeichen 
      year$      = Trim(PeekS(MemPointer +  93, 4)) ;  4 Zeichen 
      comment$   = Trim(PeekS(MemPointer +  97,30)) ; 30 Zeichen 
      genre      = PeekB(MemPointer + 127)          ;  1 Zeichen 
      
      PrintN("Titel: " + songtitle$) 
      PrintN("Kuenstler: " + artist$) 
      PrintN("Album: " + album$) 
      PrintN("Jahr: " + year$) 
      PrintN("Kommentar: " + comment$) 
      PrintN("Genre: " + Str(genre)) 
    Else 
      PrintN("Keine ID3-V1 Tags gefunden!") 
    EndIf 
  EndIf 
Else
  PrintN("Datei nicht gefunden!")
EndIf 
      
Input() 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
