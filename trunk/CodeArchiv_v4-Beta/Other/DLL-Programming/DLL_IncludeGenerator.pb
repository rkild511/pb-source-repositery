; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3216&highlight=
; Author: Mischa (updated for PB 4.00 by Andre)
; Date: 22. December 2003
; OS: Windows
; Demo: Yes


; Automatically creates an include file for standard dll in the same path,
; which includes the definitions of their functions...

; Einleitung:
; Das kleine Ding erstellt für Standard Dlls im gleichen Pfad eine 
; fertige Include-Datei mit den Definitionen ihrer Funktionen, zwecks 
; Nutzung mit CallFunctionFast(). 


;Include Generator 
;Mischa Brandt 


;Beispiel 'fmod.dll' 
;Folgende Filter/Schnittmuster passend für die fmod.dll 
;(Include gibt's schon, weiß ich. Ist nur zur Demonstration.) 
leftcut     = 1    
rightcut    = 0 
separator.s = "@" 

lib.s = "fmod.dll" ;<-Pfad anpassen 


;lib.s=ProgramParameter() ;<- executable erstellen und einfach Dll droppen. 
;leftcut     = 0          
;rightcut    = 0 
;separator.s = "" 

q.s=Chr(34):f1.s="DLLEntryPoint":f2.s="AttachProcess" 
f3.s="DetachProcess":f4.s="AttachThread":f5.s="DetachThread" 
If OpenLibrary(0,lib) 
  If ExamineLibraryFunctions(0) 
    If CreateFile(0,GetPathPart(lib)+"Include_"+ReplaceString(GetFilePart(lib),GetExtensionPart(lib),"pb")) 
      WriteStringN(0,"Procedure Init"+Left(GetFilePart(lib),Len(GetFilePart(lib))-4)+"(libid,libname.s)") 
      WriteStringN(0,"  If OpenLibrary(libid,libname)") 
      While NextLibraryFunction() 
        n.s  = LibraryFunctionName() 
        nn.s = StringField(Mid(n,leftcut+1,Len(n)-leftcut-rightcut),1,separator) 
        If n<>f1 And n<>f2 And n<>f3 And n<>f4 And n<>f5 
          WriteStringN(0,"    Global *"+nn) 
          WriteStringN(0,"    *"+nn+"=IsFunction(libid,"+q+n+q+")") 
        EndIf 
      Wend 
      WriteStringN(0,"  Else") 
      WriteStringN(0,"    MessageRequester("+q+"error!"+q+","+q+"Can't open library!"+q+",0)")  
      WriteStringN(0,"  Endif") 
      WriteStringN(0,"EndProcedure") 
      CloseFile(0) 
    Else 
      MessageRequester("Error!","Can't create include file",0) 
    EndIf 
  Else 
    CloseLibrary(0) 
    MessageRequester("Error!","Can't examine library!",0) 
  EndIf 
  CloseLibrary(0) 
Else 
  MessageRequester("Error!","Can't open library!",0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
