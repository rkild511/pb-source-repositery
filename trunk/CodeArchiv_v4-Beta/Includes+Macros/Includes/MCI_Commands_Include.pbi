;**
;* Info: MCI-Commands (To play mp3s, And so on) _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _

Enumeration 0
  #MCI_Unknown
  #MCI_Stopped
  #MCI_Playing
  #MCI_Paused
EndEnumeration

Procedure MCI_GetStatus(Nb)
  Protected Result.l, i, a$
  Result=#MCI_Unknown
  a$=Space(#MAX_PATH)
  i=mciSendString_("status MCI_"+Str(Nb)+" mode",@a$,#MAX_PATH,0)
  If i=0
    Select a$
      Case "stopped":Result=#MCI_Stopped
      Case "playing":Result=#MCI_Playing
      Case "paused":Result=#MCI_Paused
    EndSelect
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure MCI_Load(Nb,file.s)
  Protected i.l

  ;i=mciSendString_("open Sequencer!"+Chr(34)+file+Chr(34)+" alias mid"+Str(Nb),0,0,0)
  i=mciSendString_("OPEN "+Chr(34)+file+Chr(34)+" Type MPEGVIDEO ALIAS MCI_"+Str(Nb),0,0,0)
  If i=0
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure MCI_Play(Nb)
  Protected i.l

  i=mciSendString_("play MCI_"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_PlayStart(Nb)
  Protected i.l

  i=mciSendString_("play MCI_"+Str(Nb)+" from "+Str(0),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_PlayPart(Nb,start,endPos)
  Protected i.l

  i=mciSendString_("play MCI_"+Str(Nb)+" from "+Str(start)+" to "+Str(endPos),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_Pause(Nb)
  Protected i.l

  i=mciSendString_("pause MCI_"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_Resume(Nb)
  Protected i.l

  i=mciSendString_("resume MCI_"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_Stop(Nb)
  Protected i.l

  i=mciSendString_("stop MCI_"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_Free(Nb)
  Protected i.l

  i=mciSendString_("close MCI_"+Str(Nb),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_SetVolume(Nb,volume)
  Protected i.l

  i=mciSendString_("SetAudio MCI_"+Str(Nb)+" volume to "+Str(volume),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_GetVolume(Nb)
  Protected i.l
  Protected a$=Space(#MAX_PATH)
  i=mciSendString_("status MCI_"+Str(Nb)+" volume",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure MCI_SetSpeed(Nb,Tempo)
  Protected i.l

  i=mciSendString_("set MCI_"+Str(Nb)+" Speed "+Str(Tempo),0,0,0)
  ProcedureReturn i
EndProcedure

Procedure MCI_GetSpeed(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status MCI_"+Str(Nb)+" Speed",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure MCI_GetLength(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status MCI_"+Str(Nb)+" length",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure MCI_GetPosition(Nb)
  Protected a$=Space(#MAX_PATH)
  Protected i.l

  i=mciSendString_("status MCI_"+Str(Nb)+" position",@a$,#MAX_PATH,0)
  ProcedureReturn Val(a$)
EndProcedure

Procedure MCI_Seek(Nb,pos)
  Protected i.l

  i=mciSendString_("Seek MCI_"+Str(Nb)+" to "+Str(pos),0,0,0)
  ProcedureReturn i
EndProcedure
Procedure.s MCI_TimeString(Time)
  Protected sek.l, min.l

  Time/1000
  sek=Time%60:Time/60
  min=Time%60:Time/60
  ProcedureReturn RSet(Str(Time),2,"0")+":"+RSet(Str(min),2,"0")+":"+RSet(Str(sek),2,"0")
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 1
; Folding = ---
; EnableXP
; HideErrorLog