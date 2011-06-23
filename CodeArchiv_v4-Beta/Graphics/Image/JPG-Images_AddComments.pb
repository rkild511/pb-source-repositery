; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3366&highlight=
; Author: dige (updated for PB4.00 by blbltheworm)
; Date: 08. January 2004
; OS: Windows
; Demo: No


; Add comment text, like copyright etc., to jpeg-images 
; done by dige 01/2004 

; JPG bietet die Möglichkeit Text für Bemerkungen, Copyright Hinweise 
; etc. 'unsichtbar' direkt im Bild-Header zu speichern. 
; Der Text kann dann zum Beispiel mit IrfanView ausgelesen werden. 

; Add comment text, like copyright etc., to jpeg-images 
; done by dige 01/2004 

Procedure.b WriteJpgTxtToFile ( File.s, comment.s ) 
  Protected size.l, success.b, *mem.l 
  
  success = #False 
  #FID    = 0 
  size.l  = FileSize(File) 
  
  If size 
    *mem = GlobalAlloc_ (#GMEM_FIXED|#GMEM_ZEROINIT, size)    
    If *mem And ReadFile(#FID, File) 
      ReadData(#FID,*mem, size) 
      CloseFile(#FID) 
      If PeekW(*mem) & $FFFF = $D8FF And CreateFile(#FID, File) 
        WriteLong(#FID, $FEFFD8FF ) ; JPG & Comment Marker (Little Endian Format) 
        WriteByte(#FID, $00 ) : WriteByte(#FID, Len(comment) + 3 ) ; comment lenght incl. size 
        WriteString(#FID, comment ) : WriteByte(#FID, $00 ) 
        If PeekW (*mem + 2 ) & $FFFF = $FEFF 
          ; found comment 
          size - PeekB(*mem + 5) - 4 : *mem + PeekB(*mem + 5) + 4 
        Else 
          ; no comment found 
          size - 2 : *mem + 2 
        EndIf 
        WriteData(#FID,*mem, size) 
        CloseFile(#FID) 
        success = #True 
      EndIf 
      
    EndIf 
    GlobalFree_( *mem ) 
  EndIf 
  ProcedureReturn success 
EndProcedure 
CopyFile("..\Gfx\image1.jpg","test.jpg") ;als Beispieldatei wird eine Kopie erstellt
Debug WriteJpgTxtToFile ( "test.jpg", "(c) by DiGe" ) ; Der Datei wird ein Kommentar hinzugefügt
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
