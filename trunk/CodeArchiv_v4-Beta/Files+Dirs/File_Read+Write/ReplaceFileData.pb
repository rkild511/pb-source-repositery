; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3102&highlight=
; Author: Froggerprogger (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 11. December 2003
; OS: Windows
; Demo: Yes


; Function:
; Replaces data in a file. The data can be in any form (array, memory, string)
; and different lengths.

; Funktion:
; Ersetzt in einer Datei Daten. Diese können in irgendeiner Form vorliegen
; (Array, Memory, Strings) und unterschiedliche Längen haben. 


;- 10.11.2003 by Froggerprogger 
;- 
;- ReplaceFileData: 
;- filename.s       : Dateiname der Input-Datei 
;- outputfilename.s : Dateiname der Output-Datei - kann auch mit der Input-Datei übereinstimmen 
;- *searchdata.l    : ein Pointer auf die Daten die zu suchen sind, z.B. @"TEST" oder @myArray oder *mem etc.. 
;- searchdataLen.l  : Länge der Suchdaten in Bytes 
;- *replacedata.l   : ein Pointer auf die Daten mit denen zu ersetzen ist, z.B. @"Testing" oder @myArray2 oder *mem2 etc.. 
;- replacedataLen   : Länge der Daten, mit denen ersetzt wird 
;- 
;- Die Funktion liefert die Anzahl der Ersetzungen zurück oder einen Wert < 0, falls ein 
;- Fehler auftauchte: 
;- Fehlercodes:  -1 = Länge der Input-Datei ist < 1 oder ist ein Verzeichnis oder nicht gefunden (kann mit FileSize(spezifiziert werden)) 
;-               -2 = die Input-Datei konnte nicht geöffnet werden 
;-               -3 = die Output-Datei konnte nicht geöffnet/erstellt werden 

#TempFile = 0 

Procedure.l ReplaceFileData(Filename.s, outputfilename.s, *searchdata.l, searchdataLen.l, *replacedata, replacedataLen.l) 
  Protected templ.l 
  Protected *tempmem.l 
  Protected fileLen.l 
  Protected numResults.l 
    
  fileLen = FileSize(Filename)  
  If fileLen < 1 Or searchdataLen < 1 
    ProcedureReturn -1 
  EndIf 
  
  If OpenFile(#TempFile, Filename) 
    *tempmem = AllocateMemory(fileLen) 
    ReadData(#TempFile,*tempmem, fileLen) 
    CloseFile(#TempFile) 
    
    If CreateFile(#TempFile, outputfilename) 
      i = 0 
      While i <= fileLen - 1 
        If PeekB(*tempmem + i) <> PeekB(*searchdata) 
          WriteByte(#TempFile,PeekB(*tempmem + i)) 
          i + 1 
        Else 
          same = #True : j=1 
          While same = #True And j < searchdataLen 
            If PeekB(*tempmem + i + j) <> PeekB(*searchdata + j) 
              same = #False 
            Else 
              j+1 
            EndIf 
          Wend 
          If same = #True 
            WriteData(#TempFile,*replacedata, replacedataLen) 
            numResults + 1 
          Else 
            WriteData(#TempFile,*tempmem + i, j) 
          EndIf 
          i + j 
        EndIf 
      Wend 
      
      FreeMemory(*tempmem)
      CloseFile(#TempFile) 
    Else 
      ProcedureReturn -3 
    EndIf 
      
  Else 
    ProcedureReturn -2 
  EndIf 
  
  ProcedureReturn numResults 
EndProcedure 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
