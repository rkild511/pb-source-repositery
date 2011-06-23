; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2786&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 09. November 2003
; OS: Windows
; Demo: No

;info:Play Midis direct (with mci) 
Procedure GetMidiLength(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" length",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure SetMidiTimeFormatToMS(Nb) 
  ProcedureReturn mciSendString_("set mid"+Str(Nb)+" time format milliseconds",0,0,0) 
EndProcedure 
Procedure SetMidiTimeFormatToTick(Nb) 
  ProcedureReturn mciSendString_("set mid"+Str(Nb)+" time format song pointer",0,0,0) 
EndProcedure 
Procedure LoadMidi(Nb,file.s) 
  ;i=mciSendString_("open Sequencer!"+Chr(34)+file+Chr(34)+" alias mid"+Str(Nb),0,0,0) 
  i=mciSendString_("OPEN "+Chr(34)+file+Chr(34)+" Type SEQUENCER ALIAS mid"+Str(Nb),0,0,0) 
  If i=0 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure PlayMidi(Nb) 
  i=mciSendString_("play mid"+Str(Nb)+" from "+Str(0),0,0,0) 
  ProcedureReturn i 
EndProcedure 
Procedure PlayMidiFrom(Nb,Start,endPos) 
  i=mciSendString_("play mid"+Str(Nb)+" from "+Str(Start)+" to "+Str(endPos),0,0,0) 
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
Procedure GetMidiPosition(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" position",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure GetMidiTempo(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" Tempo",@a$,#MAX_PATH,0) 
  ProcedureReturn Val(a$) 
EndProcedure 
Procedure IsMidiPlaying(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  If a$="playing" 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure IsMidiPaused(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  If a$="paused" 
    ProcedureReturn #True 
  Else 
    ProcedureReturn #False 
  EndIf 
EndProcedure 
Procedure IsMidiReady(Nb) 
  a$=Space(#MAX_PATH) 
  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0) 
  Debug a$ 
  If a$="not ready" 
    ProcedureReturn #False 
  Else 
    ProcedureReturn #True 
  EndIf 
EndProcedure 


;- Example
OpenWindow(1,0,200,10,10,"Midi-Test",#PB_Window_SystemMenu) 

LoadMidi(1,"guitar_sample.mid") 
Debug GetMidiLength(1) 
SetMidiTimeFormatToMS(1) 
Debug GetMidiLength(1) 

PlayMidi(1) 

old=-1 
Repeat 
  If IsMidiPlaying(1) 
    event=WindowEvent() 
    x=GetMidiPosition(1)/100 
    If old<>x 
      Debug "+"+Str(x) 
      old=x 
    EndIf 
  Else 
    event=WaitWindowEvent() 
  EndIf 
Until event=#PB_Event_CloseWindow 
StopMidi(1) 
FreeMidi(1)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
