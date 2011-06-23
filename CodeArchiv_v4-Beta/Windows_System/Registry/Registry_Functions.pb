; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1378&highlight=
; Author: Manne
; Date: 26. July 2003
; OS: Windows
; Demo: No

sKeyName.s = "SOFTWARE\Microsoft\Windows NT\CurrentVersion" 
sTopKey.l = #HKEY_LOCAL_MACHINE 


Procedure.l SetValue(topKey.l, sKeyName.s, sValueName.s, vValue.s, lType.l, ComputerName.s) 
  GetHandle.l 
  hKey.l 
  lType.l 
  lpcbData.l 
  lpData.s 
  lReturnCode.l 
  lhRemoteRegistry.l 
  
  If Left(sKeyName, 1) = "\" 
    sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
  EndIf 
  
  If ComputerName = "" 
    GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
  Else 
    lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
    GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
  EndIf 

  If GetHandle = #ERROR_SUCCESS 
    lpcbData = 255 
    lpData = Space(255) 
      
    Select lType 
      Case #REG_SZ 
        GetHandle = RegSetValueEx_(hkey, sValueName, 0, #REG_SZ, @vValue, Len(vValue) + 1) 
      Case #REG_DWORD 
        lValue = Val(vValue) 
        GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_DWORD, @lValue, 4) 
    EndSelect 
      
    RegCloseKey_(hkey) 
    ergebnis = 1 
    ProcedureReturn ergebnis 
  Else 
    MessageRequester("Fehler", "Ein Fehler ist aufgetreten", 0) 
    RegCloseKey_(hKey) 
    ergebnis  = 0 
    ProcedureReturn ergebnis 
  EndIf 
EndProcedure 

; ergebnis = SetValue(sTopKey, sKeyName, "Regtest", "12", #REG_DWORD, "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.l GetValue(topKey, sKeyName.s, sValueName.s, ComputerName.s) 
   GetHandle.l 
   hKey.l 
   lpData.s 
   lpDataDWORD.l 
   lpcbData.l 
   lType.l 
   lReturnCode.l 
   lhRemoteRegistry.l 
   Shared GetValue.s 
    
   If Left(sKeyName, 1) = "\" 
       sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
   EndIf 
    
   If ComputerName = "" 
       GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
   Else 
       lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
       GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
   EndIf 
            
   If GetHandle = #ERROR_SUCCESS 
       lpcbData = 255 
       lpData = Space(255) 
        
       GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData) 
            
       If GetHandle = #ERROR_SUCCESS 
           Select lType 
               Case #REG_SZ 
                   GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lType, @lpData, @lpcbData) 
                
                   If GetHandle = 0 
                       GetValue = Left(lpData, lpcbData - 1) 
                   Else 
                       GetValue = "" 
                   EndIf 
                    
               Case #REG_DWORD 
                   GetHandle = RegQueryValueEx_(hKey, sValueName, 0, @lpType, @lpDataDWORD, @lpcbData) 
                    
                   If GetHandle = 0 
                       GetValue = Str(lpDataDWORD) 
                   Else 
                       GetValue = "0" 
                   EndIf 
                
           EndSelect 
       EndIf 
   EndIf 
   RegCloseKey_(hKey) 
   ProcedureReturn GetHandle 
EndProcedure 

;ergebnis = GetValue(sTopKey, sKeyName, "RegisteredOwner", "")          
;---------------------------------------------------------------------------------------------------- 
Procedure.s ListSubKey(topKey.l, sKeyName.s, Index.l, ComputerName.s) 
    GetHandle.l 
    hKey.l 
    dwIndex.l 
    lpName.s 
    lpcbName.l 
    lpftLastWriteTime.FILETIME 
    i.l 
    lReturnCode.l 
    lhRemoteRegistry.l 
    ListSubKey.s 
    
    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    EndIf 
            
    If GetHandle = #ERROR_SUCCESS 
        lpcbName = 255 
        lpName = Space(255) 
                    
        GetHandle = RegEnumKeyEx_(hKey, Index, @lpName, @lpcbName, 0, 0, 0, @lpftLastWriteTime) 
                
        If GetHandle = #ERROR_SUCCESS 
            ListSubKey = Left(lpName, lpcbName) 
        Else 
            ListSubKey = "" 
        EndIf 
    EndIf 
    RegCloseKey_(hKey) 
    ProcedureReturn ListSubKey 
EndProcedure 

;ergebnis.s = ListSubKey(sTopKey, sKeyName, 20, "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.l DeleteValue(topKey.l, sKeyName.s, sValueName.s, ComputerName.s) 
    GetHandle.l 
    hKey.l 
    lReturnCode.l 
    lhRemoteRegistry.l 
    
    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    EndIf 

    If GetHandle = #ERROR_SUCCESS 
        GetHandle = RegDeleteValue_(hKey, @sValueName) 
        If GetHandle = #ERROR_SUCCESS 
            DeleteValue = #True 
        Else 
            DeleteValue = #False 
        EndIf 
    EndIf 
    RegCloseKey_(hKey) 
    ProcedureReturn DeleteValue 
EndProcedure 

;ergebnis = DeleteValue(sTopKey, sKeyName, "Test", "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.l CreateKey(topKey, sKeyName.s, ComputerName.s) 
    hNewKey.l 
    lpSecurityAttributes.SECURITY_ATTRIBUTES 
    GetHandle.l 
    lReturnCode.l 
    lhRemoteRegistry.l 

    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegCreateKeyEx_(topKey, sKeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, @lpSecurityAttributes, @hNewKey, @GetHandle) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegCreateKeyEx_(lhRemoteRegistry, sKeyName, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, @lpSecurityAttributes, @hNewKey, @GetHandle) 
    EndIf 

    If GetHandle = #ERROR_SUCCESS 
        GetHandle = RegCloseKey_(hNewKey) 
        CreateKey = #True 
    Else 
        CreateKey = #False 
    EndIf 
    ProcedureReturn CreateKey 
EndProcedure 

;sKeyName.s = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\temper" 
;ergebnis = CreateKey(sTopKey, sKeyName, "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.l DeleteKey(topKey.l, sKeyName.s, ComputerName.s) 
    GetHandle.l 
    lReturnCode.l 
    lhRemoteRegistry.l 
    
    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegDeleteKey_(topKey, @sKeyName) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegDeleteKey_(lhRemoteRegistry, @sKeyName) 
    EndIf 

    If GetHandle = #ERROR_SUCCESS 
        DeleteKey = #True 
    Else 
        DeleteKey = #False 
    EndIf 
    ProcedureReturn DeleteKey 
EndProcedure 

;sKeyName.s = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\temper" 
;ergebnis = DeleteKey(sTopKey, sKeyName, "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.s ListSubValue(topKey.l, sKeyName.s, Index.l, ComputerName.s) 
    GetHandle.l 
    hKey.l 
    dwIndex.l 
    lpName.s 
    lpcbName.l 
    lpftLastWriteTime.FILETIME 
    i.l 
    lhRemoteRegistry.l 
    lReturnCode.l 
    ListSubValue.s 

    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    EndIf 
    
            
    If GetHandle = #ERROR_SUCCESS 
        lpcbName = 255 
        lpName = Space(255) 
        
        GetHandle = RegEnumValue_(hKey, Index, @lpName, @lpcbName, 0, 0, 0, 0) 

        If GetHandle = #ERROR_SUCCESS 
            ListSubValue = Left(lpName, lpcbName) 
        Else 
            ListSubValue = "" 
        EndIf 
        RegCloseKey_(hKey) 
    EndIf 
    ProcedureReturn ListSubValue 
EndProcedure 

;ergebnis.s = ListSubValue(sTopKey, sKeyName, 1, "") 
;---------------------------------------------------------------------------------------------------- 
Procedure.l KeyExists(topKey.l, sKeyName.s, ComputerName.s) 
    hKey.l 
    GetHandle.l 
    lhRemoteRegistry.l 
    lReturnCode.l 
    
    If Left(sKeyName, 1) = "\" 
        sKeyName = Right(sKeyName, Len(sKeyName) - 1) 
    EndIf 
    
    If ComputerName = "" 
        GetHandle = RegOpenKeyEx_(topKey, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    Else 
        lReturnCode = RegConnectRegistry_(ComputerName, topKey, @lhRemoteRegistry) 
        GetHandle = RegOpenKeyEx_(lhRemoteRegistry, sKeyName, 0, #KEY_ALL_ACCESS, @hKey) 
    EndIf 
    
    If GetHandle = #ERROR_SUCCESS 
        KeyExists = #True 
    Else 
        KeyExists = #False 
    EndIf 
    ProcedureReturn KeyExists 
EndProcedure 

sKeyName.s = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\" 
ergebnis = KeyExists(sTopKey, sKeyName, "") 

OpenConsole() 
PrintN(Str(ergebnis)) 
;PrintN(GetValue) 
Input() 
CloseConsole() 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
