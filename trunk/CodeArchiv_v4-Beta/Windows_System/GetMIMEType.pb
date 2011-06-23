; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6499&highlight=
; Author: Kale
; Date: 13. June 2003
; OS: Windows
; Demo: No

Procedure.s GetMIMEType(Extension.s) 
    Extension = "." + Extension 
    hKey.l = 0 
    KeyValue.s = Space(255) 
    datasize.l = 255 
    If RegOpenKeyEx_(#HKEY_CLASSES_ROOT, Extension, 0, #KEY_READ, @hKey) 
        KeyValue = "application/octet-stream" 
    Else 
        If RegQueryValueEx_(hKey, "Content Type", 0, 0, @KeyValue, @datasize) 
            KeyValue = "application/octet-stream" 
        Else 
            KeyValue = Left(KeyValue, datasize-1) 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn KeyValue 
EndProcedure 

key.s=GetMIMEType("gif") 
MessageRequester("ReadLocalKey",key,0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
