; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: Yes

hWnd.l=OpenWindow(0, 214, 17, 660, 500, "Dateien lesen",  #PB_Window_MinimizeGadget | #PB_Window_TitleBar  | #PB_Window_ScreenCentered ) 
If hWnd 
  CreateGadgetList(WindowID(0)) 
  
  EditorGadget(1, 10, 10, 640, 480) 
  DateiName$= ProgramParameter() ;Liest den Parameter z.B. "MeinPGR.exe Test.txt" übergibt "Test.txt" 
  If CheckFilename(GetFilePart(DateiName$)) And DateiName$<>"" ;Auf Dateinamen prüfen 
    If ReadFile(1,DateiName$) ;Datei zum lesen öffnen 
      While Eof(1)=0                      ;liest Datei Zeile für Zeile in's Editgadget 
        AddGadgetItem(1,-1,ReadString(1))  ; " 
      Wend                                ; " 
      CloseFile(1) 
    Else 
      MessageRequester("Datei laden","Datei nicht gefunden "+Chr(10)+Chr(34)+DateiName$+Chr(34),0) 
    EndIf 
  Else 
    MessageRequester("Programmparameter","Kein oder ungültiger Dateiname übergeben"+DateiName$,0) 
  EndIf 
Else 
  End 
EndIf 

Repeat 
;Dein Code hier 

Until WaitWindowEvent()=#PB_Event_CloseWindow 
End 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP