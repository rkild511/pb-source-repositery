; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5235&highlight=
; Author: Rings
; Date: 03. August 2004
; OS: Windows
; Demo: No


; Code um zum Beispiel einen 'UnInstaller' nach dem Beenden zu löschen
; (ohne Neustart oder Batch-File), diese Version nutzt die Möglichkeit,
; Code auf dem Stack auszuführen.

; Getestet unter: Win2000 / NT4
; Läuft nicht unter: WinXP (ab SP2)

; Anmerkung (basierend auf Danilo):
; Bei diesem Code handelt es sich um einen "Hack"!!
; ExitProcess wird hier direkt aufgerufen, d.h. die PB-Internen Sachen
; beim Beenden werden komplett weggelassen. Somit wird bei keiner
; PB-Library die "EndFunction" aufgerufen.

; Name: Self deleter
; Purpose:Good to use for an Uninstaller
;
; This file (if compiled to exe) delete itself after finishing (executes code on the stack ;) )
; should also work under Win89, but never tested
;
;Enable InlineASM !

;
; coded/adapted/enhanced  (Powerbasic-version from Wayne Diamond, thx wayne :) )
; by Siegfried Rings
; have fun !
MessageRequester("info","self-deleter",0)


DeleteItself:
hModule = GetModuleHandle_(0)
szModuleName.s=Space(512)
GetModuleFileName_(hModule, szModuleName, Len(szModuleName))
hKrnl32 = GetModuleHandle_("kernel32.dll")
pExitProcess = GetProcAddress_(hKrnl32, "ExitProcess")
pDeleteFile = GetProcAddress_(hKrnl32, "DeleteFileA")
pFreeLibrary = GetProcAddress_(hKrnl32, "FreeLibrary")
pUnmapViewOfFile = GetProcAddress_(hKrnl32, "UnmapViewOfFile")


;Set Fileattributes if Writeprotectet!
SetFileAttributes_(szModuleName,0)

#Win9x = 0  ;do OS-detection code by yourself !
If #Win9x <> 0
  ; MessageRequester("Info"," Win95/98/ME ",0)
  MOV eax,szModuleName
  PUSH 0
  PUSH 0
  PUSH eax
  PUSH pExitProcess
  PUSH hModule
  PUSH pDeleteFile
  PUSH pFreeLibrary
  RET
Else
  ; MessageRequester("Info"," NT4/2K/XP/.NET ",0)
  CloseHandle_(4)
  MOV eax,szModuleName
  PUSH 0
  PUSH 0
  PUSH eax
  PUSH pExitProcess
  PUSH hModule
  PUSH pDeleteFile
  PUSH pUnmapViewOfFile
  RET
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableAsm
; DisableDebugger