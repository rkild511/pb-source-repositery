; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2297&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 15. September 2003
; OS: Windows
; Demo: No


; MIDI-Connecter 
; by NicTheQuick 

Procedure MIDIRequester(*OutDevice.l, *InDevice.l) 
  #MOD_WAVETABLE = 6 
  #MOD_SWSYNTH = 7 
  #MIDIRequ_InSet = 2 
  #MIDIRequ_OutSet = 1 

  #Width = 400 
  If OpenWindow(0, 0, 0, #Width, 270, "MIDI-Requester", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    If CreateGadgetList(WindowID(0)) 
      #Column = (#Width - 20) / 2 
      #Offset = (#Width / 2) + 5 

      TextGadget(0, 5, 5, #Column, 18, "Output-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(2, 5, 23, #Column, 100) 
        MaxOutDev.l = midiOutGetNumDevs_() 
        InfoOut.MIDIOUTCAPS 
        If MaxOutDev 
          For a.l = -1 To MaxOutDev - 1 
            midiOutGetDevCaps_(a, InfoOut, SizeOf(MIDIOUTCAPS)) 
            AddGadgetItem(2, -1, PeekS(@InfoOut\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(2, -1, "(no output device)") 
          DisableGadget(2, 1) 
        EndIf 

      TextGadget(1, #Offset, 5, #Column, 18, "Input-Device:", #PB_Text_Center | #PB_Text_Border) 
      ListViewGadget(3, #Offset, 23, #Column, 100) 
        MaxInDev.l = midiInGetNumDevs_() 
        InfoIn.MIDIINCAPS 
        If MaxInDev 
          For a.l = 0 To MaxInDev - 1 
            midiInGetDevCaps_(a, InfoIn, SizeOf(MIDIINCAPS)) 
            AddGadgetItem(3, -1, PeekS(@InfoIn\szPname[0], 32)) 
          Next 
        Else 
          AddGadgetItem(3, -1, "(no input device)") 
          DisableGadget(3, 1) 
        EndIf 

      ButtonGadget(4, 5, 240, #Column, 24, "&OK") 
      ButtonGadget(5, #Offset, 240, #Column, 24, "&Cancel") 
      
      Frame3DGadget(6, 5, 130, #Width - 10, 100, "Info of Output-Device", 0) 
       TextGadget(7, 10, 145, #Width - 20, 18, "Version:") 
       TextGadget(8, 10, 165, #Width - 20, 18, "Technology:") 
       TextGadget(9, 10, 185, #Width - 20, 18, "Max. Voices:") 
       TextGadget(10, 10, 205, #Width - 20, 18, "Polyphonie:") 
      
      OutDev.l = 0 
      InDev.l = 0 
      Quit.l = #False 
      OK.l = #False 
      Repeat 
        If GetGadgetState(2) > -1 Or GetGadgetState(3) > -1 
          DisableGadget(4, 0) 
        Else 
          DisableGadget(4, 1) 
        EndIf 
        
        If InDev.l <> GetGadgetState(3) 
          InDev.l = GetGadgetState(3) 
        EndIf 

        If GetGadgetState(2) <> OutDev 
          OutDev.l = GetGadgetState(2) 
          midiOutGetDevCaps_(OutDev - 1, InfoOut, SizeOf(MIDIOUTCAPS)) 
          SetGadgetText(7, "Version: " + Str(InfoOut\vDriverVersion >> 8) + "." + Str(InfoOut\vDriverVersion & FF)) 
          Select InfoOut\wTechnology 
            Case #MOD_MIDIPORT :  TmpS.s = "Hardware Port" 
            Case #MOD_SYNTH :     TmpS.s = "Synthesizer" 
            Case #MOD_SQSYNTH :   TmpS.s = "Square Wave Synthesizer" 
            Case #MOD_FMSYNTH :   TmpS.s = "FM Synthesizer" 
            Case #MOD_MAPPER :    TmpS.s = "Microsoft MIDI Mapper" 
            Case #MOD_WAVETABLE : TmpS.s = "Hardware Wavetable Synthesizer" 
            Case #MOD_SWSYNTH :   TmpS.s = "Software Synthesizer" 
            Default: TmpS.s = "(Error Code " + Str(InfoOut\wTechnology) + ")" 
          EndSelect 
          SetGadgetText(8, "Technology: " + TmpS) 
          If InfoOut\wVoices = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wVoices) : EndIf 
          SetGadgetText(9, "Max. Voices: " + TmpS) 
          If InfoOut\wNotes = 0 : TmpS.s = "inf" : Else : TmpS.s = Str(InfoOut\wNotes) : EndIf 
          SetGadgetText(10, "Polyphonie: " + TmpS) 
        EndIf 
        
        EventID.l = WaitWindowEvent() 
        Select EventID 
          Case #PB_Event_CloseWindow 
            Quit = #True 
            OK = #False 
          Case #PB_Event_Gadget 
            Select EventGadget() 
              Case 4 
                PokeL(*OutDevice, OutDev - 1) 
                PokeL(*InDevice, InDev) 
                Quit = #True 
                OK = 3 
                If (OutDev = -1 Or CountGadgetItems(2) = 0) And OK & #MIDIRequ_OutSet : OK ! #MIDIRequ_OutSet : EndIf 
                If (InDev = -1 Or CountGadgetItems(3) = 0) And OK & #MIDIRequ_InSet : OK ! #MIDIRequ_InSet : EndIf 
              Case 5 
                Quit = #True 
                OK = #False 
            EndSelect 
        EndSelect 
      Until Quit 
      CloseWindow(0) 
      ProcedureReturn OK 
    Else 
      End 
    EndIf 
  Else 
    End 
  EndIf 
EndProcedure 

Structure MIDIData 
  Channel.b 
  Note.b 
  Velocity.b 
  Null.b 
EndStructure 

;Channel from 0 to 15 
Procedure ProgramChange(Channel.b, Instr.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $C0 + Channel 
  NoteDat\Note = Instr 
  If midiOutShortMsg_(HandleOut, PeekW(NoteDat)) = #MMSYSERR_NOERROR : Debug "Kanal gewechselt..." : EndIf 
EndProcedure 
Procedure NoteOn(Channel.b, Note.b, Velocity.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $90 + Channel 
  NoteDat\Note = Note 
  NoteDat\Velocity = Velocity 
  NoteDat\Null = #Null 
  If midiOutShortMsg_(HandleOut, PeekL(NoteDat)) = #MMSYSERR_NOERROR : Debug "Ton gestartet..." : EndIf 
EndProcedure 
Procedure NoteOff(Channel.b, Note.b, Velocity.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $80 + Channel 
  NoteDat\Note = Note 
  NoteDat\Velocity = Velocity 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure NoteOffAlternate(Channel.b, Note.b, Velocity.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $90 + Channel 
  NoteDat\Note = Note 
  NoteDat\Velocity = 0 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure AllNotesOff(Channel.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $B0 + Channel 
  NoteDat\Note = $7B 
  NoteDat\Velocity = 0 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure ChangeController(Channel.b, Controller.b, Value.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $B0 + Channel 
  NoteDat\Note = Controller 
  NoteDat\Velocity = Value 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure ChannelPressure(Channel.b, Value.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $D0 + Channel 
  NoteDat\Note = Value 
  NoteDat\Velocity = #Null 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure KeyAftertouch(Channel.b, Note.b, Value.b) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $A0 + Channel 
  NoteDat\Note = Note 
  NoteDat\Velocity = Value 
  NoteDat\Null = #Null 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 
Procedure PitchWheel(Channel.b, Value.w) 
  Shared HandleOut 
  Protected NoteDat.MIDIData 
  NoteDat\Channel = $E0 + Channel 
  NoteDat\Null = #Null 
  PokeW(@NoteDat\Note, Value) 
  midiOutShortMsg_(HandleOut, PeekL(NoteDat)) 
EndProcedure 

Global Dim Controller.s(127) 
Procedure InitController() 
  Protected a.l 
  Restore ControllerNames 
  For a = 0 To 127 
    Read Controller(a) 
  Next 
EndProcedure 
Procedure.s GetControllerName(Number.l) 
  If Number >= 0 And Number <= 127 
    ProcedureReturn RSet(Str(Number), 3, "0") + " " + Controller(Number) 
  EndIf 
EndProcedure 

;- MAINPROGRAM 

Procedure MidiInProc(hMidiIn.l, wMsg.l, dwInstance.l, dwParam1.l, dwParam2.l) 
  Protected Status.l, OnOf.l, NoteNr.l, Velocity.l 
  
  
  Select wMsg 
    Case #MM_MIM_OPEN 
      Debug "open" 
    
    Case #MM_MIM_CLOSE 
      Debug "close" 
      
    Case #MM_MIM_DATA 
      Status = dwParam1 & $FF 
      If Status < $F0 
        Select Status / 16 
          Case $8 
            Debug "Note On" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Note: " + Str((dwParam1 >> 8) & $FF) 
            Debug "  Velocity: " + Str((dwParam1 >> 16) & $FF) 
          Case $9 
            If dwParam1 & $FF0000 
              Debug "Note On" 
            Else 
              Debug "Note Off" 
            EndIf 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Note: " + Str((dwParam1 >> 8) & $FF) 
            Debug "  Velocity: " + Str((dwParam1 >> 16) & $FF) 
          Case $A 
            Debug "Key Aftertouch" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Note: " + Str((dwParam1 >> 8) & $FF) 
            Debug "  Value: " + Str((dwParam1 >> 16) & $FF) 
          Case $B 
            Debug "Controller Change" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Controller: " + GetControllerName((dwParam1 >> 8) & $FF) 
            Debug "  Wert: " + Str((dwParam1 >> 16) & $FF) 
          Case $C 
            Debug "Program Change" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Instrument: " + Str((dwParam1 >> 8 ) & $FF) 
          Case $D 
            Debug "Channel Pressure" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Value: " + Str((dwParam1 >> 8) & $FF) 
          Case $E 
            Debug "Pitch Wheel" 
            Debug "  Kanal: " + Str(dwParam1 & $F) 
            Debug "  Value: " + Str((dwParam >> 16) & $FFFF) 
          Default 
            Debug Hex(Status) 
        EndSelect 
      EndIf 
    
    Case #MM_MIM_LONGDATA 
      Debug "Longdata: " + RSet(Hex(dwParam1), 2, "0") + RSet(Hex(dwParam2), 2, "0") 
      
    Case #MM_MIM_ERROR 
      Debug "Error: " + RSet(Hex(dwParam1), 2, "0") + RSet(Hex(dwParam2), 2, "0") 
    
    Case #MM_MIM_LONGERROR 
      Debug "LongError" 
    
    Default 
      Debug "???" 
  EndSelect 
EndProcedure 

InitController() 

OutDevice.l 
InDevice.l 
MIDIResult.l = MIDIRequester(@OutDevice, @InDevice) 

If MIDIResult & #MIDIRequ_InSet 
  hMidiIn.l 
  If midiInOpen_(@hMidiIn, InDevice, @MidiInProc(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    Debug "OPEN: MidiIn" 
    If midiInStart_(hMidiIn) = #MMSYSERR_NOERROR 
      Debug "START: MidiIn" 
    EndIf 
  EndIf 
EndIf 
  
If MIDIResult & #MIDIRequ_OutSet 
  hMidiOut.l 
  If midiOutOpen_(@hMidiOut, OutDevice, 0, 0, 0) = 0 
    Debug "OPEN: MidiOut" 
  EndIf 
EndIf 

If hMidiIn And hMidiOut 
  If midiConnect_(hMidiIn, hMidiOut, 0) = 0 

  EndIf 
EndIf 

If OpenWindow(0, 0, 0, 400, 300, "WaitWindow", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  Repeat 
    EventID.l = WaitWindowEvent() 
  Until EventID = #PB_Event_CloseWindow 
EndIf 

midiDisconnect_(hMidiIn, hMidiOut, 0) 
While midiInClose_(hMidiIn) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMidiOut) = #MIDIERR_STILLPLAYING : Wend 

DataSection 
  ControllerNames: 
    Data.s "Bank Select", "Modulation", "Breath Controller", "", "4 (0x04) Foot Controller"                   ;0 - 4 
    Data.s "Portamento time", "Data Entry (MSB)", "Main Volume", "Balance", "", "Pan"                         ;5 - 10 
    Data.s "Expression Controller", "Effect Control 1", "Effect Control 2", "", ""                            ;11 - 15 
    Data.s "General-Purpose Controllers 1", "General-Purpose Controllers 2", "General-Purpose Controllers 3"  ;16 - 18 
    Data.s "General-Purpose Controllers 4", "", "", "", "", "", "", "", "", "", "", "", ""                    ;19 - 31 
    Data.s "LSB for Controller 0", "LSB for Controller 1", "LSB for Controller 2", "LSB for Controller 3"     ;32 - 35 
    Data.s "LSB for Controller 4", "LSB for Controller 5", "LSB for Controller 6", "LSB for Controller 7"     ;36 - 39 
    Data.s "LSB for Controller 8", "LSB for Controller 9", "LSB for Controller 10", "LSB for Controller 11"   ;40 - 43 
    Data.s "LSB for Controller 12", "LSB for Controller 13", "LSB for Controller 14", "LSB for Controller 15" ;44 - 47 
    Data.s "LSB for Controller 16", "LSB for Controller 17", "LSB for Controller 18", "LSB for Controller 19" ;48 - 51 
    Data.s "LSB for Controller 20", "LSB for Controller 21", "LSB for Controller 22", "LSB for Controller 23" ;52 - 55 
    Data.s "LSB for Controller 24", "LSB for Controller 25", "LSB for Controller 26", "LSB for Controller 27" ;56 - 59 
    Data.s "LSB for Controller 28", "LSB for Controller 29", "LSB for Controller 30", "LSB for Controller 31" ;60 - 63 
    Data.s "Damper pedal (sustain)", "Portamento", "Sostenuto", "Soft Pedal", "Legato Footswitch"             ;64 - 68 
    Data.s "Hold 2", "Sound Controller 1 (Default: Timber Variation)"                                         ;69 - 70 
    Data.s "Sound Controller 2 (Default: Timber/Harmonic Content)"                                            ;71 - 71 
    Data.s "Sound Controller 3 (Default: Release time)", "Sound Controller 4 (Default: Attack time)"          ;72 - 73 
    Data.s "Sound Controller 6", "Sound Controller 7", "Sound Controller 8", "Sound Controller 9"             ;74 - 77 
    Data.s "Sound Controller 10", "", "General-Purpose Controllers 5", "General-Purpose Controllers 6"        ;78 - 81 
    Data.s "General-Purpose Controllers 7", "General-Purpose Controllers 8", "Portamento Control"             ;82 - 84 
    Data.s "", "", "", "", "", "", "Effects 1 Depth (formerly External Effects Depth)"                        ;85 - 91 
    Data.s "Effects 2 Depth (formerly Tremolo Depth)", "Effects 3 Depth (formerly Chorus Depth)"              ;92 - 93 
    Data.s "Effects 4 Depth (formerly Celeste Detune)", "Effects 5 Depth (formerly Phaser Depth)"             ;94 - 95 
    Data.s "Data Increment", "Data Decrement", "Non-Registered Parameter Number (LSB)"                        ;96 - 98 
    Data.s "Non-Registered Parameter Number (MSB)", "Registered Parameter Number (LSB)"                       ;99 - 100 
    Data.s "Registered Parameter Number (MSB)", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""    ;101 - 116 
    Data.s "", "", "", "", "Mode Messages", "Mode Messages", "Mode Messages", "Mode Messages"                 ;117 - 124 
    Data.s "Mode Messages", "Mode Messages", "Mode Messages"                                                  ;125 - 127 
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ---
