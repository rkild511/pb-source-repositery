; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2875&highlight=
; Author: manne (updated for PB4.00 by blbltheworm)
; Date: 19. November 2003
; OS: Windows
; Demo: No

; Es gibt noch eine weitere M�glichkeit eine Datei zu l�schen die gerade ge�ffnet ist. 
; Das Zauberwort hei�t unter NT/2000/XP "MoveFileEx_()". 
; Die entsprechende Datei wird Mithilfe des o.g. Befehls einfach beim n�chsten Reboot gel�scht. 
; Eine alternative M�glichkeit f�r Win 9x habe ich in folgendem Beispielcode auskommentiert,
; da hierzu ein Eingriff in die "wininit.ini" erforderlich w�re. 
; Zudem konnte ich diese M�glichkeit nicht austesten da mir kein Win 9x zur Verf�gung steht. 


#CSIDL_WINDOWS = $24 

osvi.OSVERSIONINFO 
Define.s sFile, WinDir 

Structure EMID 
  cb.b 
  abID.b[1] 
EndStructure 

Procedure.s GetSystemFolder (folder) 
  *itemID.ITEMIDLIST = #Null 
  If SHGetSpecialFolderLocation_ (0, folder, @*itemID) = #NOERROR 
    location$ = Space (#MAX_PATH) 
    If SHGetPathFromIDList_ (*itemID, @location$) 
      ProcedureReturn location$ 
    EndIf 
  EndIf 
EndProcedure 

Procedure.s GetExeName() 
  sApp.s=Space(256) 
  GetModuleFileName_(GetModuleHandle_(0), @sApp, 256)        
  ProcedureReturn sApp 
EndProcedure 

sFile = GetExeName() 
SetFileAttributes_(sFile, #FILE_ATTRIBUTE_NORMAL) 

osvi\dwOSVersionInfoSize = SizeOf(OSVERSIONINFO) 
GetVersionEx_(osvi) 

If osvi\dwPlatformId = #VER_PLATFORM_WIN32_NT Or osvi\dwMajorVersion <> 4 
  If MoveFileEx_(sFile, #Null, #MOVEFILE_DELAY_UNTIL_REBOOT) = 0 
    MessageRequester("Fehler", "Operation fehlgeschlagen!", 0) 
    End 
  Else 
    MessageRequester("Info", "Erfolgreich - Datei wird beim n�chsten Reboot gel�scht", 0) 
    End 
  EndIf 
Else ; <- Methode f�r WIN 9x 
;   GetShortPathName_(sFile, sFile, FileSize(sFile)) 
;   WinDir = GetSystemFolder(#CSIDL_WINDOWS) + "\" + "wininit.ini" 
;   If WritePrivateProfileString_("rename", "NULL", LTrim(sFile), WinDir) = 0 
;     MessageRequester("Fehler", "Operation fehlgeschlagen", 0) 
;     End 
;   Else 
;     MessageRequester("Info", "Erfolgreich - Datei wird beim n�chsten Reboot gel�scht", 0) 
;     End 
;   EndIf 
EndIf 
 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
