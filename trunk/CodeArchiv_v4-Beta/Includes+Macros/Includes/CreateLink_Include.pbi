; www.PureArea.net (Include collection by ts-soft)
; Author: Danilo
; Date: 09. December 2003
; OS: Windows
; Demo: No

;* _
;* create shell links/shortcuts _
;* translated from my old example that used CallCOM() _
;* _
;* by Danilo, 09.12.2003 _
;* _
;* changed for easy use in PB 4.0 > _
;* by ts-soft

;** CreateShortcut
;** .Path: for the Link ("c:\PureBasic\purebasic.exe")
;** .Link: "C:\Documents and Settings\User\Desktop\PureBasic.lnk"
;** .WorkingDir: "c:\PureBasic\"
;** .Argument: "%1"
;** .ShowCommand: #SW_SHOWNORMAL or #SW_SHOWMAXIMIZED or #SW_SHOWMINIMIZED
;** .Description: "Start PureBasic"
;** .HotKey: no need to use this :)
;** .IconFile: "c:\PureBasic\purebasic.exe"
;** .IconIndex: 1
Procedure CreateShortcut(Path.s, Link.s, WorkingDir.s = "", Argument.s = "", ShowCommand.l = #SW_SHOWNORMAL, Description.s = "", HotKey.l = #Null, IconFile.s = "|", IconIndex.l = 0)
  Protected psl.IShellLinkA, ppf.IPersistFile, mem.s, hres.l, Result.l
  If IconFile = "|" : IconFile = Path : EndIf
  If Not WorkingDir : WorkingDir = GetPathPart(Path) : EndIf
  CoInitialize_(0)
  If CoCreateInstance_(?CLSID_ShellLink,0,1,?IID_IShellLink,@psl) = 0
    Set_ShellLink_preferences:
    psl\SetPath(@Path)
    psl\SetArguments(@Argument)
    psl\SetWorkingDirectory(@WorkingDir)
    psl\SetDescription(@Description)
    psl\SetShowCmd(ShowCommand)
    psl\SetHotkey(HotKey)
    psl\SetIconLocation(@IconFile, IconIndex)
    ShellLink_SAVE:
    If psl\QueryInterface(?IID_IPersistFile,@ppf) = 0
      mem.s = Space(1000)
      MultiByteToWideChar_(#CP_ACP, 0, Link, -1, mem, 1000)
      hres = ppf\Save(@mem,#True)
      Result = 1
      ppf\Release()
    EndIf
    psl\Release()
  EndIf
  CoUninitialize_()
  ProcedureReturn Result
  DataSection
    CLSID_ShellLink:
    Data.l $00021401
    Data.w $0000,$0000
    Data.b $C0,$00,$00,$00,$00,$00,$00,$46
    IID_IShellLink:
    Data.l $000214EE
    Data.w $0000,$0000
    Data.b $C0,$00,$00,$00,$00,$00,$00,$46
    IID_IPersistFile:
    Data.l $0000010B
    Data.w $0000,$0000
    Data.b $C0,$00,$00,$00,$00,$00,$00,$46
  EndDataSection
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; HideErrorLog