;**
;* info:Play Midis direct (With mci) - Use MCI-Commands.pbi! _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _
;* _
;* This Include gives you the possibility To load And play Midis. _
;* You can also change the tempo While playing the midi.

Procedure GetMidiLength(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

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
  Protected i.l

  ;i=mciSendString_("open Sequencer!"+Chr(34)+file+Chr(34)+" alias mid"+Str(Nb),0,0,0)
  i=mciSendString_("OPEN "+Chr(34)+file+Chr(34)+" Type SEQUENCER ALIAS mid"+Str(Nb),0,0,0)
  If i=0
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure PlayMidi(Nb)
  Protected i.l

  i=mciSendString_("play mid"+Str(Nb)+" from "+Str(0),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure PlayMidiFrom(Nb,start,endPos)
  Protected i.l

  i=mciSendString_("play mid"+Str(Nb)+" from "+Str(Start)+" to "+Str(endPos),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure PauseMidi(Nb)
  Protected i.l

  i=mciSendString_("pause mid"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure ResumeMidi(Nb)
  Protected i.l

  i=mciSendString_("resume mid"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure StopMidi(Nb)
  Protected i.l

  i=mciSendString_("stop mid"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure FreeMidi(Nb)
  Protected i.l

  i=mciSendString_("close mid"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure SetMidiTempo(Nb,Tempo)
  Protected i.l

  i=mciSendString_("set mid"+Str(Nb)+" tempo "+Str(Tempo),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure GetMidiPosition(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status mid"+Str(Nb)+" position",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure GetMidiTempo(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status mid"+Str(Nb)+" Tempo",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure IsMidiPlaying(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0)
  If a$="playing"
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure IsMidiPaused(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0)
  If a$="paused"
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure IsMidiReady(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status mid"+Str(Nb)+" mode",@a$,#MAX_PATH,0)
  If a$="not ready"
    ProcedureReturn #False
  Else
    ProcedureReturn #True
  EndIf
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 7
; Folding = ---
; EnableXP
; HideErrorLog