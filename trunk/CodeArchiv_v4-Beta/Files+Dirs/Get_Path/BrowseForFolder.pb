; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2578&highlight=
; Author: ts-soft
; Date: 24. March 2005
; OS: Windows
; Demo: No


; Requester displaying paths AND files, e.g. for creating desktop links
; Requester, welcher Pfade UND Dateien darstellt, z.B. für die Erstellung von Verknüpfungen

Procedure BrowseCallbackProc(hwnd, msg, lParam, lData) 
  szDir$ = Space(#MAX_PATH) 
  Select msg 
    Case #BFFM_INITIALIZED 
      SendMessage_(hwnd, #BFFM_SETSELECTION, #BFFM_INITIALIZED, lData) 
    Case #BFFM_SELCHANGED 
      If SHGetPathFromIDList_(lParam, @szDir$) 
        SendMessage_(hwnd, #BFFM_SETSTATUSTEXT, 0, @szDir$) 
      EndIf 
  EndSelect 
EndProcedure 

Procedure.s BrowseForFolder(Style, Titel.s, Path.s) 
  Folder.s = Space(#MAX_PATH) 
  Dir.BROWSEINFO 
  Dir\hwndOwner = GetActiveWindow_() 
  Dir\pszDisplayName = @Folder 
  Dir\lpszTitle = @Titel 
  Dir\ulFlags = Style 
  Dir\lpfn = @BrowseCallbackProc() 
  Dir\lParam = @Path 
  result.l = SHBrowseForFolder_(@Dir) 
  SHGetPathFromIDList_(result, @Folder) 
  If Folder <> "" 
    If FileSize(Folder) = - 2 
      If Right(Folder, 1) <> "\" : Folder + "\" : EndIf 
    EndIf 
  EndIf 
  CoTaskMemFree_(result) 
  ProcedureReturn Folder 
EndProcedure 

Style = #BIF_STATUSTEXT | #BIF_EDITBOX | #BIF_BROWSEINCLUDEFILES | #BIF_USENEWUI 
Debug BrowseForFolder(Style, "Wählen Sie das Ziel der Verknüpfung:", "C:\Windows\")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -