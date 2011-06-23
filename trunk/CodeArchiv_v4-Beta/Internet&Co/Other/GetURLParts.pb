; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8249&highlight=
; Author: dmoc
; Date: 08. November 2003
; OS: Windows
; Demo: Yes

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

url$="http://www.purebasic.com/german/index.php3"
Debug "URL="       + url$
Debug "Protocol: " + URLProtoPart(url$)
Debug "Host: "     + URLHostPart(url$)
Debug "Path: "     + URLPathPart(url$)
Debug "Resource: " + URLResourcePart(url$)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
