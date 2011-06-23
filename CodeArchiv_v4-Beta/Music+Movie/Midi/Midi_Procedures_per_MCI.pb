; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1076&highlight=
; Author: Unknown
; Date: 20. May 2003
; OS: Windows
; Demo: No

Procedure LoadMidi(Nb,file.s) 
  i=mciSendString_("open "+file.s+" type sequencer alias mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure PlayMidi(Nb) 
  i=mciSendString_("play mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure PlayMidiFrom(Nb,Start,Ende) 
  i=mciSendString_("play mid"+Str(Nb)+" from "+Str(Start)+" to "+Str(Ende),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure PauseMidi(Nb) 
  i=mciSendString_("pause mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure ResumeMidi(Nb) 
  i=mciSendString_("resume mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure StopMidi(Nb) 
  i=mciSendString_("stop mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure FreeMidi(Nb) 
  i=mciSendString_("close mid"+Str(Nb),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure SetMidiTempo(Nb,Tempo) 
  i=mciSendString_("set mid"+Str(Nb)+" tempo "+Str(Tempo),0,0,0) 
  ProcedureReturn i 
EndProcedure 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
