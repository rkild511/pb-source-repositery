; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2946&highlight=
; Author: hm (updated for PB4.00 by blbltheworm)
; Date: 27. November 2003
; OS: Windows
; Demo: No


; Enter a drive letter like 'C:\' and the autocompletion pops up!
; Gib einen Laufwerksbuchstaben wie 'C:\' ein und ein Fenster zum automatischen Vervollständigen erscheint!


; SHAutoComplete Beispiel 
; hm 
; 031127 
;  Die SHAutoComplete Function befindet sich in shlwapi.dll 
;  LWSTDAPI SHAutoComplete(hwnd hwndedit, DWORD dwFlags); 

; ab IE5: 
#SHACF_DEFAULT           = $00000000  ;// Currently (SHACF_FILESYSTEM | SHACF_URLALL) 
#SHACF_FILESYSTEM        = $00000001  ;// This includes the File System as well as the rest of the shell (Desktop\My Computer\Control Panel\) 
#SHACF_URLALL            = ( $00000002 | $00000004 )    ; (#SHACF_URLHISTORY | #SHACF_URLMRU) 
#SHACF_URLHISTORY        = $00000002  ;// URLs in the User's History 
#SHACF_URLMRU            = $00000004  ;// URLs in the User's Recently Used list. 
#SHACF_USETAB            = $00000008  ;// Use the tab To move thru the autocomplete possibilities instead of To the Next dialog/window Control. 
#SHACF_FILESYS_ONLY      = $00000010  ;// This includes the File System 

#SHACF_AUTOSUGGEST_FORCE_ON  = $10000000  ;// Ignore the registry Default And force the feature on. 
#SHACF_AUTOSUGGEST_FORCE_OFF = $20000000  ;// Ignore the registry Default And force the feature off. 
#SHACF_AUTOAPPEND_FORCE_ON   = $40000000  ;// Ignore the registry Default And force the feature on. (Also know as autocomplete) 
#SHACF_AUTOAPPEND_FORCE_OFF  = $80000000  ;// Ignore the registry Default And force the feature off. (Also know as autocomplete) 
; ab IE6: 
#SHACF_FILESYS_DIRS      = $00000020  ;// Same as SHACF_FILESYS_ONLY except it only includes directories, UNC servers, And UNC server shares. 
  
  
Enumeration 
  #Window_Main 
EndEnumeration 

Enumeration 
  #String_AutoComplete 
EndEnumeration 


If OpenWindow(#Window_Main, 217, 150, 292, 40, "SHAutoComplete Test",  #PB_Window_SystemMenu | #PB_Window_TitleBar ) 
  If CreateGadgetList(WindowID(#Window_Main)) 
    StringGadget(#String_AutoComplete, 10, 10, 270, 20, "") 

    CoInitialize_(#Null) 
    If OpenLibrary(0,"shlwapi.dll") 
      func_shautocomplete.l = GetFunction(0,"SHAutoComplete") 
      If func_shautocomplete <> #Null 
        If CallFunctionFast(func_shautocomplete, GadgetID(#String_AutoComplete), ( #SHACF_AUTOAPPEND_FORCE_ON | #SHACF_AUTOSUGGEST_FORCE_ON | #SHACF_FILESYSTEM ) ) = #S_OK 
        Else 
          MessageRequester("error","Fehler bei SHAutoComplete()") 
        EndIf 
      Else 
        MessageRequester("error","Funktion SHAutoComplete nicht gefunden in shlwapi.dll"); 
      EndIf 
      CloseLibrary(0) 
    Else 
      MessageRequester("error","Fehler beim Öffnen von shlwapi.dll") 
    EndIf 

  EndIf 
EndIf 

Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow 

CoUninitialize_() 

End 
; 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
