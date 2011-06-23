; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3078&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 09. December 2003
; OS: Windows
; Demo: No
; 
; create shell links/shortcuts 
; translated from my old example that used CallCOM() 
; 
; by Danilo, 09.12.2003 
; 
; requires PB 3.81+ !!!
; 
Procedure CreateShellLink(PATH$, LINK$, Argument$, DESCRIPTION$, WorkingDirectory$, ShowCommand.l, HotKey.l, IconFile$, IconIndexInFile.l) 
   CoInitialize_(0) 
   If CoCreateInstance_(?CLSID_ShellLink,0,1,?IID_IShellLink,@psl.IShellLinkA) = 0 
      
   Set_ShellLink_preferences: 
      
      ; The file TO which is linked ( = target for the Link ) 
      ; 
      psl\SetPath(@PATH$) 
      
      ; Arguments for the Target 
      ; 
      psl\SetArguments(@Argument$) 
      
      ; Working Directory 
      ; 
      psl\SetWorkingDirectory(@WorkingDirectory$) 
      
      ; Description ( also used as Tooltip for the Link ) 
      ; 
      psl\SetDescription(@DESCRIPTION$) 
      
      ; Show command: 
      ;               SW_SHOWNORMAL    = Default 
      ;               SW_SHOWMAXIMIZED = aehmm... Maximized 
      ;               SW_SHOWMINIMIZED = play Unreal Tournament 
      psl\SetShowCmd(ShowCommand) 
      
      ; Hotkey: 
      ; The virtual key code is in the low-order byte, 
      ; and the modifier flags are in the high-order byte. 
      ; The modifier flags can be a combination of the following values: 
      ; 
      ;         HOTKEYF_ALT     = ALT key 
      ;         HOTKEYF_CONTROL = CTRL key 
      ;         HOTKEYF_EXT     = Extended key 
      ;         HOTKEYF_SHIFT   = SHIFT key 
      ; 
      psl\SetHotkey(HotKey) 
      
      ; Set Icon for the Link: 
      ; There can be more than 1 icons in an icon resource file, 
      ; so you have to specify the index. 
      ; 
      psl\SetIconLocation(@IconFile$, IconIndexInFile) 
      
      
   ShellLink_SAVE: 
      ; Query IShellLink For the IPersistFile interface For saving the 
      ; shortcut in persistent storage. 
      If psl\QueryInterface(?IID_IPersistFile,@ppf.IPersistFile) = 0 
        ; Ensure that the string is Unicode. 
        mem.s = Space(1000) ;AllocateMemory(1,1000) 
        MultiByteToWideChar_(#CP_ACP, 0, LINK$, -1, mem, 1000) 
        ;Save the link by calling IPersistFile::Save. 
        hres = ppf\Save(@mem,#True) 
        result = 1 
        ppf\Release() 
      EndIf 
      psl\Release() 
   EndIf 
   CoUninitialize_() 
   ProcedureReturn result 
    
   DataSection 
     CLSID_ShellLink: 
       ; 00021401-0000-0000-C000-000000000046 
       Data.l $00021401 
       Data.w $0000,$0000 
       Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
     IID_IShellLink: 
       ; DEFINE_SHLGUID(IID_IShellLinkA,         0x000214EEL, 0, 0); 
       ; C000-000000000046 
       Data.l $000214EE 
       Data.w $0000,$0000 
       Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
     IID_IPersistFile: 
       ; 0000010b-0000-0000-C000-000000000046 
       Data.l $0000010B 
       Data.w $0000,$0000 
       Data.b $C0,$00,$00,$00,$00,$00,$00,$46 
   EndDataSection 

EndProcedure 


; CreateLink 
;             - TARGET$ for the Link ("c:\PureBasic\purebasic.exe") 
;             - LINK$ - name of the Link ("c:\pb.lnk") 
;             - Argument$ for the target  ("%1") 
;             - Description$ = Description and Tooltip ("Start PureBasic") 
;             - Working Directory ("c:\PureBasic\") 
;             - Show command: #SW_SHOWNORMAL or #SW_SHOWMAXIMIZED or #SW_SHOWMINIMIZED 
;             - HotKey - no need to use this :) 
;             - IconFile + Index ( "c:\PureBasic\purebasic.exe" , 1 ) 


If CreateShellLink("D:\BASIC\PureBasic\purebasic.exe","c:\PB.lnk","","Pure FUN","D:\BASIC\PureBasic\",#SW_SHOWMAXIMIZED,0,"%SystemRoot%\system32\SHELL32.dll",12) 
  Beep_(800,100) 
EndIf 

WinDir$ = Space(100): GetSystemDirectory_(WinDir$,100) 
If CreateShellLink(WinDir$+"\calc.exe","c:\CALC.lnk","","Calculator","",0,0,"%SystemRoot%\system32\SHELL32.dll",23) 
  Beep_(800,100) 
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
