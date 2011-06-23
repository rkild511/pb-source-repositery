; www.purearea.net (Sourcecode collection by cnesm)
; Author: Christoffer Anselm
; Date: 22. November 2003
; OS: Windows
; Demo: Yes


; Need the UnRAR.dll for working, use Google... ;)

IncludeFile "UnRAR_Include.pb" 

If OpenConsole() 
   PrintN("RAR_Init") 
  If RAR_Init() 
       
      hArcData = RAR_OpenArchive("H.rar", #RAR_OM_LIST) 
       
      PrintN("hArcData = RAR_OpenArchive(" + Chr(34) + "H.rar" + Chr(34) + ", #RAR_OM_LIST)") 
      PrintN("hArcData = "+Str(hArcData)) 
      Print("ArchiveData\OpenResult = ") 
      Select ArchiveData\OpenResult 
         Case 0 
            PrintN("0") 
         Case #ERAR_NO_MEMORY 
            PrintN("#ERAR_NO_MEMORY") 
         Case #ERAR_BAD_DATA 
            PrintN("#ERAR_BAD_DATA") 
         Case #ERAR_BAD_ARCHIVE 
            PrintN("#ERAR_BAD_ARCHIVE") 
         Case #ERAR_EOPEN 
            PrintN("#ERAR_EOPEN") 
      EndSelect 
      PrintN("") 
      Repeat 
          
         i = RAR_ReadHeader(hArcData.l) 
          
         PrintN("i = RAR_ReadHeader(hArcData.l)") 
         PrintN("HeaderData\ArcName  = "+HeaderData\ArcName) 
         PrintN("HeaderData\FileName = "+HeaderData\FileName) 
         a$ = Bin(HeaderData\Flags) 
         b$ = "" 
         While a$ 
            b$ + Right(a$,1) 
            a$ = Left(a$,Len(a$) - 1) 
         Wend 
         bFlags.s = b$ 
         If Mid(bFlags, 1, 1) = "1" 
            PrintN("file continued from previous volume") 
         EndIf 
         If Mid(bFlags, 2, 1) = "1" 
            PrintN("file continued on next volume") 
         EndIf 
         If Mid(bFlags, 3, 1) = "1" 
            PrintN("file encrypted with password") 
         EndIf 
         If Mid(bFlags, 4, 1) = "1" 
            PrintN("file comment present") 
         EndIf 
         If Mid(bFlags, 5, 1) = "1" 
            PrintN("compression of previous files is used (solid flag)") 
         EndIf 
         If Mid(bFlags, 6, 3) = "111" 
            PrintN("file is directory") 
         Else 
            Print("dictionary size ") 
            Select Mid(bFlags, 6, 3) 
               Case "000" 
                  PrintN("  64 Kb") 
               Case "001" 
                  PrintN(" 128 Kb") 
               Case "010" 
                  PrintN(" 256 Kb") 
               Case "011" 
                  PrintN(" 512 Kb") 
               Case "100" 
                  PrintN("1024 Kb") 
               Case "101" 
               Case "110" 
            EndSelect 
         EndIf 
         PrintN("HeaderData\PackSize = "+Str(HeaderData\PackSize)) 
         PrintN("HeaderData\UnpSize = "+Str(HeaderData\UnpSize)) 
         Print("File was packed under ") 
         Select HeaderData\HostOS 
            Case 0 
               PrintN("MS-DOS") 
            Case 1 
               PrintN("OS/2") 
            Case 2 
               PrintN("Win32") 
            Case 3 
               PrintN("Unix") 
         EndSelect 
         PrintN("StrU(HeaderData\FileCRC, 2) = "+StrU(HeaderData\FileCRC, 2)) 
         PrintN("StrU(HeaderData\FileTime,2) = "+StrU(HeaderData\FileTime,2)) 
         PrintN("Left(Str(HeaderData\UnpVer),1)+" + Chr(34) + "." + Chr(34) + "+Right(Str(HeaderData\UnpVer),1) = "+Left(Str(HeaderData\UnpVer),1)+"."+Right(Str(HeaderData\UnpVer),1)) 
         PrintN("") 
         Select i 
            Case 0 
               PrintN("Success") 
            Case #ERAR_END_ARCHIVE 
               PrintN("Error: End of archive") 
            Case #ERAR_BAD_DATA 
               PrintN("Error: The File header is broken") 
         EndSelect 
          
         i = RAR_ProcessFile(hArcData, #RAR_SKIP, "", "") 
          
         PrintN("i = RAR_ProcessFile(hArcData, #RAR_SKIP, " + Chr(34) + Chr(34) + ", " + Chr(34) + Chr(34) + ")") 
         PrintN("i = " + Str(i)) 
         Select i 
            Case 0 
               PrintN("Aktion erfolgreich ausgeführt.") 
            Case #ERAR_BAD_DATA 
               PrintN("Datei CRC Fehler.") 
            Case #ERAR_BAD_ARCHIVE 
               PrintN("Diese Datei ist kein echtes RAR-Archiv.") 
            Case #ERAR_UNKNOWN_FORMAT 
               PrintN("Unbekanntes Archivformat.") 
            Case #ERAR_EOPEN 
               PrintN("Beim öffnen der Datei ist ein Fehler aufgetreten.") 
            Case #ERAR_ECREATE 
               PrintN("Beim erstellen der Datei ist ein Fehler aufgetreten.") 
            Case #ERAR_ECLOSE 
               PrintN("Beim schließen der Datei ist ein Fehler aufgetreten.") 
            Case #ERAR_EREAD 
               PrintN("Beim lesen ist ein Fehler aufgetreten.") 
            Case #ERAR_EWRITE 
               PrintN("Beim schreiben ist ein Fehler aufgetreten.") 
         EndSelect 
      Until i = #ERAR_END_ARCHIVE 
       
      i = RAR_CloseArchive(hArcData) 
       
      PrintN("i = RAR_CloseArchive(hArcData)") 
      Print("i = ") 
      Select i 
         Case 0 
            PrintN("0") 
         Case #ERAR_ECLOSE 
            PrintN("#ERAR_ECLOSE") 
      EndSelect 
      Input() 
   Else
     PrintN("Error while opening UnRAR.dll!")
     PrintN("Quit...")
     Input()
   EndIf 
  CloseConsole() 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -