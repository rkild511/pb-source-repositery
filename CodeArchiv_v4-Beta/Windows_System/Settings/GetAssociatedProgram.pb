; German forum: http://www.purebasic.fr/german/viewtopic.php?t=705&highlight=
; Author: Robert (updated for PB 4.00 by Andre)
; Date: 01. November 2004
; OS: Windows
; Demo: No

; Prozedur für Dateiverknüpfungen, wenn man wissen möchte, mit welchem Pfad + 
; Programm z.B. ein Word-Dokument (Extension = doc) geöffnet wird. 

; Damit kann man jedoch keinen Pfad von Verknüpfungen auf dem Desktop oder der 
; Shortcut-Leiste ermitteln. 

Procedure.s GetAssociatedProgram(Extension.s) 
  hKey.l = 0 
  KeyValue.s = Space(255) 
  datasize.l = 255 
  AssociatedProgram$ = "" 
  If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, "." + Extension, 0, #KEY_READ, @hKey)  = #ERROR_SUCCESS 
    If RegQueryValueEx_(hKey, "", 0, 0, @KeyValue, @datasize) = #ERROR_SUCCESS 
      KeyNext.s = Left(KeyValue, datasize-1) 
      hKey.l = 0 
      KeyValue.s = Space(255) 
      datasize.l = 255 
      If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, Keynext + "\Shell\Open\Command", 0, #KEY_READ, @hKey) = #ERROR_SUCCESS 
        If RegQueryValueEx_(hKey, "", 0, 0, @KeyValue, @datasize) = #ERROR_SUCCESS 
          AssociatedProgram$ = Left(KeyValue, datasize-1) 
        EndIf 
      EndIf 
    EndIf 
  EndIf 
  Pos = FindString(LCase(AssociatedProgram$), ".exe", 1) 
  If Pos <> 0 
    AssociatedProgram$ = Left(AssociatedProgram$, Pos + 4) 
    AssociatedProgram$ = RemoveString(AssociatedProgram$, Chr(34), 1) 
  EndIf 
  ProcedureReturn AssociatedProgram$ 
EndProcedure 

Debug GetAssociatedProgram("doc") 
Debug GetAssociatedProgram("xls") 
Debug GetAssociatedProgram("mdb") 
Debug GetAssociatedProgram("jpg") 
Debug GetAssociatedProgram("gif") 
Debug GetAssociatedProgram("htm") 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -