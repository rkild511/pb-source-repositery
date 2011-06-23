;**
;* info: Read and change the Registry / FileAssociate _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _
;* _
;* With this function you can read, set, change and delete entries in the registry

Procedure Reg_SetValue(topKey, sKeyName.s, sValueName.s, vValue.s, lType, ComputerName.s = "")
  Protected lpData.s=Space(255)
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, lpcbData, lValue.l, ergebnis.l

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

    Select lType
      Case #REG_SZ
        GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_SZ, @vValue, Len(vValue) + 1)
      Case #REG_DWORD
        lValue = Val(vValue)
        GetHandle = RegSetValueEx_(hKey, sValueName, 0, #REG_DWORD, @lValue, 4)
    EndSelect

    RegCloseKey_(hKey)
    ergebnis = 1
    ProcedureReturn ergebnis
  Else
    MessageRequester("Fehler", "Ein Fehler ist aufgetreten", 0)
    RegCloseKey_(hKey)
    ergebnis = 0
    ProcedureReturn ergebnis
  EndIf
EndProcedure

Procedure.s Reg_GetValue(topKey, sKeyName.s, sValueName.s, ComputerName.s = "")
  Protected lpData.s=Space(255), GetValue.s
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, lpcbData.l, lType.l, lpType.l
  Protected lpDataDWORD.l

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
  ProcedureReturn GetValue
EndProcedure

Procedure.s Reg_ListSubKey(topKey, sKeyName.s, Index, ComputerName.s = "")
  Protected lpName.s=Space(255), ListSubKey.s
  Protected lpftLastWriteTime.FILETIME
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l
  Protected lpcbName.l = 255

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

    GetHandle = RegEnumKeyEx_(hKey, Index, @lpName, @lpcbName, 0, 0, 0, @lpftLastWriteTime)

    If GetHandle = #ERROR_SUCCESS
      ListSubKey.s = Left(lpName, lpcbName)
    Else
      ListSubKey.s = ""
    EndIf
  EndIf
  RegCloseKey_(hKey)
  ProcedureReturn ListSubKey
EndProcedure

Procedure Reg_DeleteValue(topKey, sKeyName.s, sValueName.s, ComputerName.s = "")
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, DeleteValue.l

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

Procedure Reg_CreateKey(topKey, sKeyName.s, ComputerName.s = "")
  Protected lpSecurityAttributes.SECURITY_ATTRIBUTES
  Protected GetHandle.l, hNewKey.l, lReturnCode.l, lhRemoteRegistry.l, CreateKey.l

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

Procedure Reg_DeleteKey(topKey, sKeyName.s, ComputerName.s = "")
  Protected GetHandle.l, lReturnCode.l, lhRemoteRegistry.l, DeleteKey.l

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

Procedure.s Reg_ListSubValue(topKey, sKeyName.s, Index, ComputerName.s = "")
  Protected lpName.s=Space(255), ListSubValue.s
  Protected lpftLastWriteTime.FILETIME
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l
  Protected lpcbName.l = 255

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

Procedure Reg_KeyExists(topKey, sKeyName.s, ComputerName.s = "")
  Protected GetHandle.l, hKey.l, lReturnCode.l, lhRemoteRegistry.l, KeyExists.l

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

Procedure Reg_DeleteKeyWithAllSub(topKey, sKeyName.s, ComputerName.s = "")
  Protected i.l
  Protected a$, b$
  Repeat
    b$ = a$
    a$ = Reg_ListSubKey(topKey,sKeyName,0,"")
    If a$ <> ""
      Reg_DeleteKeyWithAllSub(topKey,sKeyName+"\"+a$,"")
    EndIf
  Until a$ = b$
  Reg_DeleteKey(topKey, sKeyName, ComputerName)
EndProcedure

Procedure Reg_CreateKeyValue(topKey, sKeyName.s, sValueName.s, vValue.s, lType, ComputerName.s = "")
  Reg_CreateKey(topKey,sKeyName,ComputerName)
  ProcedureReturn Reg_SetValue(topKey,sKeyName,sValueName,vValue,lType,ComputerName)
EndProcedure

;** AssociateFileEx: With this function, you can easy add a file association for the explorer
;** .ext$: is the extension (without the dot, for example "PB")
;** .ext_description$: is the description of the file ("PureBasic Source")
;** .programm$: is the programm with the full path ("c:\programme\japbe\japbe.exe")
;** .icon$: is the icon, when you want the second icon of file, add this with ",2" ("jaPBe.exe,2")
;** .prgkey$: s the regestry-key of the applikation, normaly the filepart of programm$
;** .cmd_description$: You can add a entry in the context-menu of the file. this is the description. ("open file with jaPBe")
;** .cmd_key$: is the key, where the description is stored. Only for Win9X-System, but you should always add this ("open_file_with_jaPBe")
Procedure AssociateFileEx(ext$, ext_description$, programm$, icon$, prgkey$, cmd_description$, cmd_key$)
  Protected cmd$, Key$

  cmd$=Chr(34)+programm$+Chr(34)+" "+Chr(34)+"%1"+Chr(34)
  If GetVersion_() & $ff0000 ; Windows NT/XP
    Reg_CreateKeyValue(#HKEY_CLASSES_ROOT, "Applications\"+prgkey$+"\shell\"+cmd_description$+"\command","",cmd$,#REG_SZ,"")
    If ext_description$
      Key$=ext$+"_auto_file"
      Reg_CreateKeyValue(#HKEY_CLASSES_ROOT  ,"."+ext$           ,"",Key$            ,#REG_SZ,"")
      Reg_CreateKeyValue(#HKEY_CLASSES_ROOT  ,Key$               ,"",ext_description$,#REG_SZ,"")
      If icon$
        Reg_CreateKeyValue(#HKEY_CLASSES_ROOT,Key$+"\DefaultIcon","",icon$           ,#REG_SZ,"")
      EndIf
    EndIf
    Reg_CreateKeyValue(#HKEY_CURRENT_USER,"Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\."+ext$,"Application",prgkey$,#REG_SZ,"")
  Else ;Windows 9x
    Reg_CreateKeyValue(#HKEY_LOCAL_MACHINE  ,"Software\Classes\."+ext$                     ,"",prgkey$         ,#REG_SZ,"")
    If ext_description$
      Reg_CreateKeyValue(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$                   ,"",ext_description$,#REG_SZ,"")
    EndIf
    If icon$
      Reg_CreateKeyValue(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$+"\DefaultIcon"    ,"",icon$           ,#REG_SZ,"")
    EndIf
    If cmd_description$<>cmd_key$
      Reg_CreateKeyValue(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$+"\shell\"+cmd_key$,"",cmd_description$,#REG_SZ,"")
    EndIf
    Reg_CreateKeyValue(#HKEY_LOCAL_MACHINE  ,"Software\Classes\"+prgkey$+"\shell\"+cmd_key$+"\command","",cmd$,#REG_SZ,"")
  EndIf
EndProcedure

Procedure Remove_AssociateFile(ext$, prgkey$)
  Protected Key$
  If GetVersion_() & $ff0000 ; Windows NT/XP
    Reg_DeleteKeyWithAllSub(#HKEY_CLASSES_ROOT,"Applications\"+prgkey$,"")
    Key$=ext$+"_auto_file"
    Reg_DeleteKeyWithAllSub(#HKEY_CLASSES_ROOT,"."+ext$,"")
    Reg_DeleteKeyWithAllSub(#HKEY_CLASSES_ROOT,Key$,"")
    Reg_DeleteKeyWithAllSub(#HKEY_CURRENT_USER,"Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\."+ext$,"")
  Else ;Windows 9x
    Reg_DeleteKeyWithAllSub(#HKEY_LOCAL_MACHINE  ,"Software\Classes\."+ext$,"")
    Reg_DeleteKeyWithAllSub(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$,"")
  EndIf
EndProcedure

Procedure AssociateFile(ext$, ext_description$, programm$, icon$)
  AssociateFileEx(ext$,ext_description$,programm$,icon$,GetFilePart(programm$),"open","open")
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 274
; Folding = AA+
; EnableXP
; HideErrorLog