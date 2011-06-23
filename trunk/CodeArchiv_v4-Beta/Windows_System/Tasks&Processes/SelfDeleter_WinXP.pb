; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=5235&highlight=
; Author: bobobo (updated for PB 4.00 by Andre)
; Date: 03. August 2004
; OS: Windows
; Demo: No

MessageRequester ("","Ich lösch mich mal lieber selber",0)
dpf$=Space(255)
GetModuleFileName_(0,dpf$,255)
pf$=GetPathPart(dpf$)

MessageRequester("","ich stehe übrigens in "+dpf$,0)
MessageRequester("","vielmehr stand ich da :-)",0)
MessageRequester("","der Löschauftrag steht in "+pf$+"delself.cmd , der löscht sich eh selber",0)

If OpenFile(0,pf$+"delself.cmd")
  WriteStringN(0, "echo off")
  WriteStringN(0, "del "+Chr(34)+dpf$+Chr(34))
  WriteStringN(0, "del "+Chr(34)+pf$+"delself.cmd"+Chr(34))
  CloseFile(0)

  RunProgram(pf$+"delself.cmd",Chr(34)+pf$+Chr(34),"",2)
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -