; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6763&highlight=
; Author: GPI (updated for PB3.92+ by Lars)
; Date: 29. June 2003
; OS: Windows
; Demo: No
;
;- ATTENTION
; This code changes your standard program to open pb files and creates 
; an right-click.menu item for pb files. You have to undo these changes 
; yourself.

Procedure SetKey(fold,Key$,Subkey$,Type,Adr,len) 
  If RegCreateKeyEx_(fold, Key$, 0, 0, #REG_OPTION_NON_VOLATILE, #KEY_ALL_ACCESS, 0, @NewKey, @KeyInfo) = #ERROR_SUCCESS 
    RegSetValueEx_(NewKey, Subkey$, 0, Type,  Adr, len) 
    RegCloseKey_(NewKey) 
  EndIf 
EndProcedure 

Procedure AssociateFileEx(ext$,ext_description$,programm$,Icon$,prgkey$,cmd_description$,cmd_key$) 
  cmd$=Chr(34)+programm$+Chr(34)+" "+Chr(34)+"%1"+Chr(34) 
  If GetVersion_() & $FF0000  ; Windows NT/XP 
    SetKey(#HKEY_CLASSES_ROOT, "Applications\"+prgkey$+"\shell\"+cmd_description$+"\command","",#REG_SZ    ,@cmd$,Len(cmd$)+1) 
    If ext_description$ 
      Key$=ext$+"_auto_file" 
      SetKey(#HKEY_CLASSES_ROOT  ,"."+ext$           ,"",#REG_SZ,@Key$,Len(Key$)+1) 
      SetKey(#HKEY_CLASSES_ROOT  ,Key$               ,"",#REG_SZ,@ext_description$,Len(ext_description$)+1) 
      If Icon$ 
        SetKey(#HKEY_CLASSES_ROOT,Key$+"\DefaultIcon","",#REG_SZ,@Icon$,Len(Icon$)+1) 
      EndIf 
    EndIf 
    SetKey(#HKEY_CURRENT_USER, "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\."+ext$,"Application",#REG_SZ,@prgkey$         ,Len(prgkey$)+1) 
  Else ;Windows 9x 
    SetKey(#HKEY_LOCAL_MACHINE,"Software\Classes\."+ext$                        ,"",#REG_SZ,@prgkey$         ,Len(prgkey$)+1) 
    If ext_description$ 
      SetKey(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$                   ,"",#REG_SZ,@ext_description$,Len(ext_description$)+1) 
    EndIf 
    If Icon$ 
      SetKey(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$+"\DefaultIcon"    ,"",#REG_SZ,@Icon$           ,Len(Icon$)+1) 
    EndIf 
    If cmd_description$<>cmd_key$ 
      SetKey(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$+"\shell\"+cmd_key$,"",#REG_SZ,@cmd_description$,Len(cmd_description$)+1) 
    EndIf 
    SetKey(#HKEY_LOCAL_MACHINE,"Software\Classes\"+prgkey$+"\shell\"+cmd_key$+"\command","",#REG_SZ,@cmd$   ,Len(cmd$)+1) 
  EndIf 
EndProcedure 
Procedure AssociateFile(ext$,ext_description$,programm$,Icon$) 
  AssociateFileEx(ext$,ext_description$,programm$,Icon$,GetFilePart(programm$),"open","open")  
EndProcedure 

;and now an addition context-item 
AssociateFileEx("pb","","F:\alternate rich\jaPBe.exe","","PureBasic.exe","Open with jaPBe","open_with_japbe") 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
