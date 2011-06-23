; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2875&highlight=
; Author: Rings (updated for PB4.00 by blbltheworm)
; Date: 18. November 2003
; OS: Windows
; Demo: No


; Delete your own Exe (for UnInstaller)
; Eigene Exe löschen (für UnInstaller)
Procedure.s GetExeName()
  sApp.s=Space(256)
  GetModuleFileName_(GetModuleHandle_(0), @sApp, 256)
  ProcedureReturn sApp
EndProcedure

Procedure UninstallApp ()
  sApp.s=GetExeName()
  #filehandle=99
  
  If OpenFile(#filehandle,Left(sApp.s,1) +":\~~uninst.bat" )
    WriteStringN(#filehandle," :DeleteFile")
    WriteStringN(#filehandle,"del " + sApp)
    WriteStringN(#filehandle,"if exist " + sApp + " goto StillExists")
    WriteStringN(#filehandle,"del " + Left(sApp, 1) + ":\~~uninst.bat")
    WriteStringN(#filehandle,"exit")
    WriteStringN(#filehandle,":StillExists")
    WriteStringN(#filehandle,"goto DeleteFile")
    CloseFile(#filehandle)
    
    lResult= RunProgram(Left(sApp, 1) + ":\~~uninst.bat","","",2)
  EndIf
EndProcedure

UninstallApp()
MessageRequester("Info","Hit me to delete myself" +GetExeName(),0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
