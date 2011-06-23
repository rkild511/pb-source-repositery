; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1666&highlight=
; Author: WernerZ
; Date: 23. October 2003
; OS: Windows
; Demo: No

Procedure.s ExePath() 
  ExePath$ = Space(1024) 
  GetModuleFileName_(0,@ExePath$,1024) 
  ProcedureReturn GetPathPart(ExePath$) 
EndProcedure 


If WritePrivateProfileString_("section","keyname" ,"keyvalue",ExePath()+"\test.ini"  ) 
  a.s = Space(50) 
  GetPrivateProfileString_("section","keyname","Default Value",@a,Len(a),ExePath()+"\test.ini" ) 
  MessageRequester("",a,0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
