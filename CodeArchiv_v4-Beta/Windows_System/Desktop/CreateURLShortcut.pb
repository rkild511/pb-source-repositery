; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1668&highlight=
; Author: ts-soft (updated for PB 4.00 by Andre)
; Date: 16. January 2005
; OS: Windows
; Demo: No


;############################################################## 

; Einfache Procedure, um eine Internetverknüpfung zu erstellen 

Procedure CreateURLShortcut(URLShortcut.s, Speicherort.s) 
  If UCase(GetExtensionPart(Speicherort)) <> "URL" 
    Speicherort + ".url" 
  EndIf 
  If CreatePreferences(Speicherort) 
    PreferenceGroup("InternetShortcut") 
    WritePreferenceString("URL", URLShortcut) 
    ClosePreferences() 
    ProcedureReturn #True 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

;############################################################## 

; Beispielcode erstellt eine Verknüpfung zu RobSite auf dem Desktop 

Structure EMID 
  cb.b 
  abID.b[1] 
EndStructure 

Procedure.s GetSpecialeFolder(folder.l) 
  *itemid.ITEMIDLIST = #Null 
  If SHGetSpecialFolderLocation_ (0, folder, @*itemid) = #NOERROR 
    location.s = Space (#MAX_PATH) 
    If SHGetPathFromIDList_ (*itemid, @location) 
      If Right(location, 1) <> "\" : location + "\" : EndIf 
      ProcedureReturn location 
    EndIf 
  EndIf 
EndProcedure 

Debug CreateURLShortcut("http://www.pure-board.de", GetSpecialeFolder(0) + "PureBasic Forum deutsch.url") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -