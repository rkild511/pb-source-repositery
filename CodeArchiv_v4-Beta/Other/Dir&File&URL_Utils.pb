; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8252&highlight=
; Author: dmoc (updated for PB 4.00 by Andre)
; Date: 08. November 2003
; OS: Windows
; Demo: No

Declare test() 
test() 

;- GENERAL 

Procedure DebugStringList(l.s, s.s) 
  ; l: list 
  ; s: seperator 
  ; 
  Protected i.l, t.s 
  i = 1 
  t.s = StringField(l, i, s) 
  While t 
    Debug t: i+1: t = StringField(l, i, "|") 
  Wend 
EndProcedure 

;- DIR/FILE UTILS 

Procedure.s CrtPath() 
  Protected cd.s 
  cd=Space(511) 
  GetCurrentDirectory_(Len(cd),@cd) 
  If (Right(cd,1)<>"\") Or (Right(cd,1)<>"/"): cd+"/": EndIf 
  ReplaceString(cd, "\", "/", 3) 
  ProcedureReturn cd 
EndProcedure 

Procedure.s GetDirList(d.s, p.s, t.l) 
  ; d: directory 
  ; p: pattern 
  ; t: type [0:File or directory | 1:File | 2:Directory] 
  ; 
  Protected f.s, l.s, et.l 
  
  If ExamineDirectory(0, d, p)=0: ProcedureReturn "": EndIf 
  et = NextDirectoryEntry(0) 
  While et 
    If (et=t) Or (t=0) 
      f = DirectoryEntryName(0) 
      If et=2: f+"/": EndIf 
      If l="": l=f: Else: l=l+"|"+f: EndIf 
    EndIf 
    et = NextDirectoryEntry(0) 
  Wend 
  ProcedureReturn l 
EndProcedure 

Procedure.l DirExistsD(d.s, p.s) 
  ; d: directory 
  ; p: pattern 
  ; 
  Protected l.s 
  l.s = GetDirList(d, p, 2) 
  If l<>"": ProcedureReturn 1: Else: ProcedureReturn 0: EndIf 
EndProcedure 

Procedure.l DirExists(p.s) 
  ProcedureReturn DirExistsD("", p) 
EndProcedure 

Procedure.l FileExistsD(d.s, p.s) 
  ; d: directory 
  ; p: pattern 
  ; 
  Protected l.s 
  l.s = GetDirList(d, p, 1) 
  If l<>"": ProcedureReturn 1: Else: ProcedureReturn 0: EndIf 
EndProcedure 

Procedure.l FileExists(p.s) 
  ProcedureReturn FileExistsD("", p) 
EndProcedure 

Procedure.s GetDirectoriesD(d.s, p.s) 
  ProcedureReturn GetDirList(d, p, 2) 
EndProcedure 

Procedure.s GetDirectories(p.s) 
  ProcedureReturn GetDirList("", p, 2) 
EndProcedure 

Procedure.s GetFilesD(d.s, p.s) 
  ProcedureReturn GetDirList(d, p, 1) 
EndProcedure 

Procedure.s GetFiles(p.s) 
  ProcedureReturn GetDirList("", p, 1) 
EndProcedure 

;- URL UTILS 

Procedure.s URLProtoPart(u.s) 
  Protected p.l 
  p = FindString(u,"://",1) 
  If p 
    ProcedureReturn Left(u,p-1) 
  Else 
    ProcedureReturn "" 
  EndIf 
EndProcedure 

Procedure.s URLHostPart(u.s) 
  If FindString(u,"://",1) 
    ProcedureReturn StringField(u,3,"/") 
  Else 
    ProcedureReturn StringField(u,1,"/") 
  EndIf 
EndProcedure 

Procedure.s URLResourcePart(u.s) 
  Protected r.s, p.l 
  
  If FindString(u,".",1)=0: ProcedureReturn "": EndIf 
  
  For p=Len(u) To 1 Step -1 
    If Mid(u, p, 1)="/" 
      Break 
    EndIf 
  Next 
  ProcedureReturn Right(u, Len(u)-p) 
EndProcedure 

Procedure.s URLPathPart(u.s) 
  Protected r.s, tl.l, tr.l 
  tl=0: tr=0 
  If UCase(Left(u,7))="HTTP://": tl=8: EndIf 
  tl+Len(URLHostPart(u)) 
  tr=Len(URLResourcePart(u)) 
  ProcedureReturn Mid(u, tl, Len(u)-tl-tr) 
EndProcedure 

;- TEST 

Procedure test() 
  ; May need your own test data in some cases below 
  
  Debug "Current Path: "+CrtPath() 
  
  Debug ">>>>> DIR LISTING >>>>" 
  DebugStringList(GetDirList("","*.*",0), "|") 
  Debug "" 

  Debug ">>>>> FILES ONLY >>>>" 
  DebugStringList(GetFiles(""),"|") 
  Debug "" 

  Debug ">>>>> DIR'S ONLY >>>>" 
  DebugStringList(GetDirectories(""),"|") 
  Debug "" 

  Debug ">>>>> DIR EXISTS? >>>>" 
  dn.s = ".." ; Replace with something else! 
  If DirExists(dn): Debug "Dir Found": Else: Debug "Dir not found!": EndIf 
  Debug ">>>>> FILE EXISTS? >>>>" 
  fn.s = "myfile.txt" ; Replace with something else! 
  If FileExists(fn): Debug "Found file": Else: Debug "File not found!": EndIf 
  Debug "" 
  
  Debug ">>>>> URL PARTS >>>>" 
  url.s = "http://www.purebasic.com/download/PureBasic_Demo.exe" 
  Debug "URL: "+url 
  Debug "PROTO: "+URLProtoPart(url) 
  Debug "HOST: "+URLHostPart(url) 
  Debug "PATH: "+URLPathPart(url) 
  Debug "RESOURCE: "+URLResourcePart(url) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
