; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8107&highlight=
; Author: Cor
; Date: 29. October 2003
; OS: Windows
; Demo: No


Global hMidiOut
#Acoustic_Steel_Guitar = 25
#Channel1 = 1
#Channel2 = 2
#Channel3 = 3
#Channel4 = 4
#Channel5 = 5
#Channel6 = 6


Procedure MidiOutMessage(hMidi,iStatus,iChannel,iData1,iData2)
  dwMessage = iStatus | iChannel | (iData1 << 8 ) | (iData2 << 16)
  ProcedureReturn midiOutShortMsg_(hMidi, dwMessage) ;
EndProcedure

Procedure SetInstrument(channel,instrument)
  MidiOutMessage(hMidiOut, $C0,  channel, instrument, 0)
EndProcedure

Procedure PlayNote(channel,Note,velocity)
  MidiOutMessage(hMidiOut, $90, channel, Note , velocity)
EndProcedure


Procedure StopNote(channel,Note)
  MidiOutMessage(hMidiOut, $90, channel, Note , 0)
EndProcedure

midi.MIDIOUTCAPS
devices = midiOutGetNumDevs_()

For devnum=-1 To devices-1
  If midiOutGetDevCaps_(devnum,@midi,SizeOf(MIDIOUTCAPS))=0
    If midi\wVoices >0
      midiport=devnum
    EndIf
  EndIf
Next

*hMidiOut.l
If midiOutOpen_(@hMidiOut,midiport,0,0,0) = #MMSYSERR_NOERROR
  ; set acoustic steel guitar as instrument
  SetInstrument(#Channel1,#Acoustic_Steel_Guitar)
  SetInstrument(#Channel2,#Acoustic_Steel_Guitar)
  SetInstrument(#Channel3,#Acoustic_Steel_Guitar)
  SetInstrument(#Channel4,#Acoustic_Steel_Guitar)
  
  
  For  cnt = 1 To 5
    ; normal sound
    PlayNote(#Channel1,$2D,63)
    PlayNote(#Channel2,$39,63)
    PlayNote(#Channel3,$3C,63)
    PlayNote(#Channel4,$40,63)
    
    
    Delay (2000)
    StopNote(#Channel1,$2D)
    StopNote(#Channel2,$39)
    StopNote(#Channel3,$3C)
    StopNote(#Channel3,$40)
    
    ; this must be a staccato sound
    PlayNote(#Channel1,$39,100)
    PlayNote(#Channel2,$3C,100)
    PlayNote(#Channel3,$40,100)
    
    Delay (300)
    StopNote(#Channel1,$39)
    StopNote(#Channel2,$3C)
    StopNote(#Channel3,$40)
    Delay (200)
    
    ; this must be a muted sound
    PlayNote(#Channel1,$2D,80)
    PlayNote(#Channel2,$30,80)
    PlayNote(#Channel3,$34,80)
    
    Delay (300)
    StopNote(#Channel1,$2D)
    StopNote(#Channel2,$30)
    StopNote(#Channel3,$34 )
    Delay (285)
    
  Next
  
  ; end: reset instruments to 0 (default)
  SetInstrument(#Channel1,0)
  SetInstrument(#Channel2,0)
  SetInstrument(#Channel3,0)
  SetInstrument(#Channel4,0)
  
  ; end: close MIDI output
  midiOutClose_(hMidiOut)
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
