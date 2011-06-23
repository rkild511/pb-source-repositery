; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14350&highlight=
; Author: Kale
; Date: 11. March 2005
; OS: Windows
; Demo: No


;read a key from the registry 
Procedure.s ReadRegKey(OpenKey.l, SubKey.s, ValueName.s) 
    hKey.l = 0 
    KeyValue.s = Space(255) 
    Datasize.l = 255 
    If RegOpenKeyEx_(OpenKey, SubKey, 0, #KEY_READ, @hKey) 
        KeyValue = "Error Opening Key" 
    Else 
        If RegQueryValueEx_(hKey, ValueName, 0, 0, @KeyValue, @Datasize) 
            KeyValue = "Error Reading Key" 
        Else  
            KeyValue = Left(KeyValue, Datasize - 1) 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn KeyValue 
EndProcedure 

Debug ReadRegKey(#HKEY_CURRENT_USER, "Software\Microsoft\Internet Explorer\Main", "Start Page") 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -