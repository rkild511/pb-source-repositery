; www.purearea.net
; Author: Rings (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 17. September 2002
; OS: Windows
; Demo: No

;GetFileVersionInfo for Purebasic
;Gets the Info from a DLL (If you want to write your own installer :)
;(c)2002 By Siegfried Rings (CodeGuru)

Procedure.s GetVersionInfo(Filename.s)
  sDummy.s=""
  If FileSize(Filename.s)>0
    Zero.l=10
    If OpenLibrary(1,"Version.dll")
      Length = CallFunction(1, "GetFileVersionInfoSizeA",Filename.s,@Zero.l)
      If Length>0
        Mem1=AllocateMemory(Length)
        If Mem1>0
          Result = CallFunction(1, "GetFileVersionInfoA",Filename.s,0,Length,Mem1)
          If Result>0
            
            lplpBuffer.l=0
            puLen.l=0
            
            WhichOne.s="\\StringFileInfo\\040904B0\\ProductVersion"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s="Productversion="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\ProductName"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"ProductName="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\CompanyName"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"CompanyName="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\LegalCopyright"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"LegalCopyright="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\Comments"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"Comments="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\FileDescription"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"FileDescription="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\FileVersion"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"FileVersion="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\InternalName"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"InternalName="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\LegalTrademarks"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"LegalTrademarks="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\PrivateBuild"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"PrivateBuild="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\SpecialBuild"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"SpecialBuild="+PeekS(lplpBuffer): EndIf
            
            WhichOne.s="\\StringFileInfo\\040904B0\\Language"
            Result = CallFunction(1, "VerQueryValueA",Mem1,WhichOne.s,@lplpBuffer,@puLen)
            If Result:sDummy.s=sDummy.s + Chr(10) +"Language="+PeekS(lplpBuffer): EndIf
          EndIf
          FreeMemory(Mem1)
        EndIf
      EndIf
      CloseLibrary(1)
    EndIf
  Else
    sDummy.s=Filename +" Not found !"
  EndIf
  ProcedureReturn sDummy.s
EndProcedure

Path.s=Space(256)
Result=GetSystemDirectory_(Path.s,256)
Filename.s=Path+"\MSVBVM60.DLL" ;Check your File !
MessageRequester("Fileinfo for "+Filename.s,GetVersionInfo(Filename),0)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; UseIcon = D:\vb6\Graphics\Icons\VS\Tools.ic
; Executable = D:\PureBasic\Examples\ARCHIVER\vLink.exe