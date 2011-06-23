; German forum: http://www.purebasic.fr/german/viewtopic.php?t=426&highlight=
; Author: zapman (updated for PB 4.00 by Andre)
; Date: 13. October 2004
; OS: Windows
; Demo: Yes



;; MIDI File decoder by Zapman 

Declare.s ReadStringl(Length.l) 
Declare ReadVLD () 
Declare ReadMidiFile() 

#SaveFile = 0

Global Dim MidiInstrument$ (127) 
Restore SMI 
For ct = 0 To 127 
  Read MidiInstrument$(ct) 
Next 

ReadMidiFile() 
; 
Procedure ReadMidiFile() 
  MidiFileName$= OpenFileRequester("", ".MID", ".MID", 0) 
  If ReadFile(0, MidiFileName$) 
    ChkName$ = ReadStringl(4) 
    ChkLength = (ReadByte(0)*256*256*256)+(ReadByte(0)*256*256)+(ReadByte(0)*256)+ReadByte(0) 
    If ChkName$<>"MThd" Or ChkLength <> 6 
      MessageRequester("Error","Unknown format !! : "+ChkName$+" / "+Str(ChkLength),0) 
      ProcedureReturn(0) 
    EndIf 
    mloc = Loc(0) 
    MFormatType = ReadByte(0)*256+ReadByte(0) 
    Debug "FormatType = "+Str(MFormatType ) 
    NbOfMTrk = ReadByte(0)*256+ReadByte(0) 
    Debug "Number of tracks = "+Str(NbOfMTrk) 
    DeltaTimeIncrement = ReadByte(0)*256+ReadByte(0) 
    Debug "DeltaTimeIncrement  = "+Str(DeltaTimeIncrement) 
    FileSeek(0, mloc+ChkLength) 
    While NbOfMTrk 
      ChkName$ = ReadStringl(4) 
      If ChkName$="" 
        MessageRequester("Error","Abnormal EndOfFile encountered.",0) 
        ProcedureReturn(0) 
      EndIf 
      ChkLength = (ReadByte(0)*256*256*256)+(ReadByte(0)*256*256)+(ReadByte(0)*256)+ReadByte(0) 
      NbOfMTrk - 1 
      If ChkName$<>"MTrk" 
        Debug "Unknown Track Type: "+ChkName$ 
        FileSeek(0, Loc(0)+ChkLength) 
      Else 
        ContRead = 1 
        While ContRead 
        Delta_time = ReadVLD () 
        MEvent = ReadByte(0) : If MEvent<0 : MEvent+256 : EndIf 
        If MEvent = $F0 Or MEvent = $F7 ; SYSEX Event 
          Debug "SYSEX Event" 
          LEvent = ReadVLD () 
          FileSeek(0, Loc(0)+LEvent) 
        ElseIf MEvent = $FF ; Meta Event 
          TEvent = ReadByte(0) 
          ;Debug "Meta Event type : "+Str(TEvent) 
          RS = 1 
          Select TEvent 
            Case 0 
              MetaEvent$ = "Sequence Number" 
              RS = 0 
              SeqNumberYesNo = ReadByte(0) 
              If SeqNumberYesNo 
                MIDICue = ReadByte(0)*256 + ReadByte(0) 
                MetaEvent$+" - MidiCue: "+Str(MIDICue) 
              EndIf 
            Case 1 
              MetaEvent$ = "Text" 
            Case 2 
              MetaEvent$ = "Copyright" 
            Case 3 
              MetaEvent$ = "Sequence/Track Name" 
            Case 4 
              MetaEvent$ = "Instrument Name" 
            Case 5 
              MetaEvent$ = "Lyric" 
            Case 6 
              MetaEvent$ = "Marker" 
            Case 7 
              MetaEvent$ = "Cue Point" 
            Case 8 
              MetaEvent$ = "Program Name" 
            Case 9 
              MetaEvent$ = "Device Name" 
            Case $20 
              MetaEvent$ = "MIDI Channel Prefix" 
            Case $2F 
              MetaEvent$ = "End of Track" 
              RS = 0 
              ReadByte(0) 
              ContRead = 0 
            Case $51 
              MetaEvent$ = "Set Tempo, in microseconds per MIDI quarter-note" 
              RS = 0 
              ReadByte(0) 
              MTempo = ReadByte(0)*256*256 + ReadByte(0)*256 + ReadByte(0) 
              MetaEvent$ + ": "+Str(MTempo) 
            Case $54 
              MetaEvent$ = "SMPTE Offset" 
              RS = 0 
              ReadByte(0) 
              SecOffset = ReadByte(0)*3600+ReadByte(0)*60+ReadByte(0) 
              FrameOffset = ReadByte(0)*100 + ReadByte(0) 
              MetaEvent$+": "+Str(SecOffset)+" sec. and "+Str(FrameOffset)+" 1/100 of frame" 
            Case $58 
              MetaEvent$ = "Time Signature" 
              RS = 0 
              ReadByte(0) 
              Numerator = ReadByte(0) 
              Denominator = ReadByte(0) 
              NbOfMidiClockPerMetronomeClick = ReadByte(0) 
              Notated32ndPerQuarterNote = ReadByte(0) 
              
            Case $59 
              MetaEvent$ = "Key Signature" 
              RS = 0 
              ReadByte(0) 
              sf = ReadByte(0) 
              MajorMinor = ReadByte(0) 
            Case $7F 
              MetaEvent$ = "Sequencer-Specific Meta-Event" 
            Default 
              MetaEvent$ = "Unknown Meta-Event ("+Hex(TEvent)+")" 
          EndSelect 
          If RS 
            LEvent = ReadVLD () 
            Debug MetaEvent$+": "+ReadStringl(LEvent ) 
          Else 
            Debug MetaEvent$ 
          EndIf 
        Else 
          ; MIDI Event 
          
          TEvent = MEvent 
          If TEvent<$80 ; This is not an Event. Keep the old Status 
            FileSeek(0, Loc(0)-1) 
            TEvent = mTEvent 
          Else 
            mTEvent = TEvent 
          EndIf 
          ;Debug "Midi Event type : "+Hex(TEvent) 
          If TEvent >=$80 And TEvent <=$8F 
            MNote = ReadByte(0) : If MNote <0 : MNote + 256 : EndIf 
            MVelocity = ReadByte(0) : If MVelocity <0 : MVelocity + 256 : EndIf 
            MidiEvent$ = "Note Off, channel "+Str(TEvent&$F)+" - Note : "+Str(MNote)+" - Velocity : "+Str(MVelocity) 
          ElseIf TEvent >=$90 And TEvent <=$9F 
            MNote = ReadByte(0) : If MNote <0 : MNote + 256 : EndIf 
            MVelocity = ReadByte(0) : If MVelocity <0 : MVelocity + 256 : EndIf 
            MidiEvent$ ="Note On, channel "+Str(TEvent&$F)+" - Note : "+Str(MNote)+" - Velocity : "+Str(MVelocity) 
          ElseIf TEvent >=$A0 And TEvent <=$AF 
            MNote = ReadByte(0) : If MNote <0 : MNote + 256 : EndIf 
            MPressure = ReadByte(0) : If MPressure <0 : MPressure + 256 : EndIf 
            MidiEvent$ ="After touch, channel "+Str(TEvent&$F)+" - Note : "+Str(MNote)+" - Pressure : "+Str(MPressure) 
          ElseIf TEvent >=$B0 And TEvent <=$BF 
            MControlerNumber = ReadByte(0) 
            MValue = ReadByte(0) : If Mvalue<0 : MValue + 256 : EndIf 
            Select MControlerNumber 
              Case 0 
                ControlerEvent$ = "Bank Select - Coarse: "+Str(MValue) 
              Case 32 
                ControlerEvent$ = "Bank Select - Fine: "+Str(MValue) 
              Case 1 
                ControlerEvent$ = "MOD Wheel - Coarse: "+Str(MValue) 
              Case 33 
                ControlerEvent$ = "MOD Wheel - Fine: "+Str(MValue) 
              Case 2 
                ControlerEvent$ = "Breath Control - Coarse: "+Str(MValue) 
              Case 34 
                ControlerEvent$ = "Breath Control - Fine: "+Str(MValue) 
              Case 4 
                ControlerEvent$ = "Foot Pedal - Coarse: "+Str(MValue) 
              Case 36 
                ControlerEvent$ = "Foot Pedal - Fine: "+Str(MValue) 
              Case 5 
                ControlerEvent$ = "Portamento Time - Coarse: "+Str(MValue) 
              Case 37 
                ControlerEvent$ = "Portamento Time - Fine: "+Str(MValue) 
              Case 6 
                ControlerEvent$ = "Data Slider - Coarse: "+Str(MValue) 
              Case 38 
                ControlerEvent$ = "Data Slider - Fine: "+Str(MValue) 
              Case 7 
                ControlerEvent$ = "Volume - Coarse: "+Str(MValue) 
              Case 39 
                ControlerEvent$ = "Volume - Fine: "+Str(MValue) 
              Case 8 
                ControlerEvent$ = "Balance - Coarse: "+Str(MValue) 
              Case 40 
                ControlerEvent$ = "Balance - Fine: "+Str(MValue) 
              Case 10 
                ControlerEvent$ = "Pan - Coarse: "+Str(MValue) 
              Case 42 
                ControlerEvent$ = "Pan - Fine: "+Str(MValue) 
              Case 11 
                ControlerEvent$ = "Expression - Coarse: "+Str(MValue) 
              Case 43 
                ControlerEvent$ = "Expression - Fine: "+Str(MValue) 
              Case 12 
                ControlerEvent$ = "Effect 1 - Coarse: "+Str(MValue) 
              Case 44 
                ControlerEvent$ = "Effect 1 - Fine: "+Str(MValue) 
              Case 13 
                ControlerEvent$ = "Effect 2 - Coarse: "+Str(MValue) 
              Case 45 
                ControlerEvent$ = "Effect 2 - Fine: "+Str(MValue) 
              Case 16 
                ControlerEvent$ = "General Purpose 1: "+Str(MValue) 
              Case 17 
                ControlerEvent$ = "General Purpose 2: "+Str(MValue) 
              Case 18 
                ControlerEvent$ = "General Purpose 3: "+Str(MValue) 
              Case 19 
                ControlerEvent$ = "General Purpose 4: "+Str(MValue) 
              Case 64 
                ControlerEvent$ = "Hold Pedal: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 65 
                ControlerEvent$ = "Portamento: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 66 
                ControlerEvent$ = "Sustenuto: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 67 
                ControlerEvent$ = "Soft Pedal: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 68 
                ControlerEvent$ = "Legato Pedal: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 69 
                ControlerEvent$ = "Hold 2 Pedal: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 70 
                ControlerEvent$ = "Sound Variation: "+Str(MValue) 
              Case 71 
                ControlerEvent$ = "Sound Timbre: "+Str(MValue) 
              Case 72 
                ControlerEvent$ = "Release Time: "+Str(MValue) 
              Case 73 
                ControlerEvent$ = "Attack Time: "+Str(MValue) 
              Case 74 
                ControlerEvent$ = "Sound Brightness: "+Str(MValue) 
              Case 75 
                ControlerEvent$ = "Sound Control 1: "+Str(MValue) 
              Case 76 
                ControlerEvent$ = "Sound Control 2: "+Str(MValue) 
              Case 77 
                ControlerEvent$ = "Sound Control 3: "+Str(MValue) 
              Case 78 
                ControlerEvent$ = "Sound Control 4: "+Str(MValue) 
              Case 79 
                ControlerEvent$ = "Sound Control 5: "+Str(MValue) 
              Case 80 
                ControlerEvent$ = "General Purpose Button1: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 81 
                ControlerEvent$ = "General Purpose Button2: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 82 
                ControlerEvent$ = "General Purpose Button3: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 83 
                ControlerEvent$ = "General Purpose Button4: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 91 
                ControlerEvent$ = "Effects Level: "+Str(MValue) 
              Case 92 
                ControlerEvent$ = "Tremolo Level: "+Str(MValue) 
              Case 93 
                ControlerEvent$ = "Chorus Level: "+Str(MValue) 
              Case 94 
                ControlerEvent$ = "Celeste Level: "+Str(MValue) 
              Case 95 
                ControlerEvent$ = "Phaser Level: "+Str(MValue) 
              Case 96 
                ControlerEvent$ = "Data Button Increment" 
              Case 97 
                ControlerEvent$ = "Data Button Decrement" 
              Case 99 
                ControlerEvent$ = "Non-Registered Parameter Number - Coarse: "+Str(MValue) 
              Case 98 
                ControlerEvent$ = "Non-Registered Parameter Number - Fine: "+Str(MValue) 
              Case 101 
                ControlerEvent$ = "Registered Parameter Number - Coarse: "+Str(MValue) 
              Case 100 
                ControlerEvent$ = "Registered Parameter Number - Fine: "+Str(MValue) 
              Case 120 
                ControlerEvent$ = "All Sound Off" 
              Case 121 
                ControlerEvent$ = "All Controllers Off" 
              Case 122 
                ControlerEvent$ = "Local Keyboard: " 
                If MValue >0 And MValue<64 
                  ControlerEvent$+"On" 
                Else 
                  ControlerEvent$+"Off" 
                EndIf 
              Case 123 
                ControlerEvent$ = "All Notes Off" 
              Case 124 
                ControlerEvent$ = "Omni Off" 
              Case 125 
                ControlerEvent$ = "Omni On" 
              Case 126 
                ControlerEvent$ = "Monophonic Mode"+Str(MValue) 
              Case 127 
                ControlerEvent$ = "Polyphonic Mode"+Str(MValue) 
              Default 
                ControlerEvent$ = "Unknown Controler Number: "+Str(MControlerNumber)+" - Value = "+Str(MValue) 
            EndSelect 
            MidiEvent$ ="Controller, channel "+Str(TEvent&$F)+" - "+ControlerEvent$ 
                
          ElseIf TEvent >=$C0 And TEvent <=$CF 
            MProgramNumber = ReadByte(0) : If MProgramNumber <0 : MProgramNumber + 256 : EndIf 
            MidiEvent$ ="Program Change, channel "+Str(TEvent&$F)+" - ProgramNumber : "+Str(MProgramNumber)+" : "+MidiInstrument$(MProgramNumber) 
          ElseIf TEvent >=$D0 And TEvent <=$DF 
            MPressure = ReadByte(0) : If MPressure <0 : MPressure + 256 : EndIf 
            MidiEvent$ ="ChannelPressure, channel "+Str(TEvent&$F)+" - Pressure : "+Str(MPressure) 
          ElseIf TEvent >=$E0 And TEvent <=$EF 
            MPitch = ReadByte(0) : If MPitch<0 : MPitch+256 : EndIf 
            MPitch<<7 
            MPitch = ReadByte(0) + MPitch - $2000 
            MidiEvent$ ="PitchWheel, channel "+Str(TEvent&$F)+" - Pitch : "+Str(MPitch) 
          ElseIf TEvent =$F1 
            MTimeCode = ReadByte(0) 
            MidiEvent$ ="MTC : "+Str(MTimeCode) 
          ElseIf TEvent =$F2 
            MBeat = ReadByte(0) : If MBeat <0 : MBeat +256 : EndIf 
            MBeat <<7 
            MBeat = ReadByte(0) + MBeat 
            MidiEvent$ ="Midi Beat : "+Str(MBeat) 
          ElseIf TEvent =$F3 
            MNumber = ReadByte(0) 
            MidiEvent$ ="SongSelect : "+Str(MNumber) 
          ElseIf TEvent =$F6 
            MidiEvent$ ="TuneRequest" 
          ElseIf TEvent =$F8 
            MidiEvent$ ="MidiClock" 
          ElseIf TEvent =$F9 
            MidiEvent$ ="MidiTick" 
          ElseIf TEvent =$FA 
            MidiEvent$ ="MidiStart" 
          ElseIf TEvent =$FC 
            MidiEvent$ ="MidiStop" 
          ElseIf TEvent =$FB 
            MidiEvent$ ="MidiCOntinue" 
          ElseIf TEvent =$FE 
            MidiEvent$ ="ActivSens" 
          ElseIf TEvent =$FF 
            MidiEvent$ ="Reset" 
          Else 
            MidiEvent$ ="Unknown Event: "+Hex(TEvent) 
            ReadVLD () 
          EndIf 
          Debug Str(Delta_time)+": "+MidiEvent$ 
        EndIf 
        Wend 
      EndIf 
    Wend 
      
    CloseFile(0) 
  EndIf 
EndProcedure 
; 
Procedure.s ReadStringl(Length.l) 
; by Zapman 
; (Read string Length from file) 
; Lit "Length" caractères dans le fichier actuellement ouvert et retourne le résultat 
; sous forme d'une chaine de caractere 

; Read "Length" caracteres from the open file and return the result 
; as a string. 
  compt.l=0 
  s$="" 
  While compt<Length 
    b=ReadByte(0) 
    s$=s$+Chr(b) 
    compt + 1 
  Wend 
  ProcedureReturn s$ 
EndProcedure 
; 
Procedure VLDToNum (v) ; Variable lenght Datas decoder 
  v&$7F7F7F7F 
  rv = 0 
  ct = 0 
  While v 
    l1 = v&$FF 
    ct2 = ct : While ct2 : l1*$80 : ct2 - 1 : Wend 
    rv + l1 
    v /256 
    ct + 1 
  Wend 
  ProcedureReturn rv 
EndProcedure 
; 
Procedure ReadVLD () 
  v = 0 
  Repeat 
    d = ReadByte(0) 
    v = v*256+d 
  Until d&$80 = 0 
  ProcedureReturn VLDToNum (v) 
EndProcedure 
; 
; 
; ******************* BONUS ******************* 
; 
; If you want to create your own MIDI Files 
; you will need that : 
; 
; 
Procedure NumToVLD (v) ; Variable lenght Datas encoder 
  ct = 0 
  rv = 0 
  While v 
    l1 = v&$7F 
    v = (v - l1)/$80 
    If ct > 0 
      l1+ $80 
    EndIf 
    ct2 = ct : While ct2 : l1*256 : ct2 - 1 : Wend 
    rv + l1 
    ct + 1 
  Wend 
  ProcedureReturn rv 
EndProcedure 
; 
Procedure WriteVLD (v) 
  vo = NumToVLD (v) 
  ct = 3 
  While PeekB(@vo+ct)=0 : ct - 1 : Wend 
  While ct>=0 
    v = PeekB(@vo+ct) : If v<0 : v + 256 : EndIf 
    WriteByte(#SaveFile, v) 
    ct - 1 
  Wend 
EndProcedure 


; 

DataSection 
SMI: 
  Data.s "Ac Gd Piano" 
  Data.s "Bght Ac Piano" 
  Data$ "El Gd Piano" 
  Data$ "Honky-tonk Piano" 
  Data$ "Electric Piano 1" 
  Data$ "Electric Piano 2" 
  Data$ "Harpsichord" 
  Data$ "Clavi" 
  Data$ "Celesta" 
  Data$ "Glockenspiel" 
  Data$ "Music Box" 
  Data$ "Vibraphone" 
  Data$ "Marimba" 
  Data$ "Xylophone" 
  Data$ "Tubular Bells" 
  Data$ "Dulcimer" 
  Data$ "Drawbar Organ" 
  Data$ "Percussive Organ" 
  Data$ "Rock Organ" 
  Data$ "Church Organ" 
  Data$ "Reed Organ" 
  Data$ "Accordion" 
  Data$ "Harmonica" 
  Data$ "Tango Accordion" 
  Data$ "Ac Guitar (nylon)" 
  Data$ "Ac Guitar (steel)" 
  Data$ "El Guitar (jazz)" 
  Data$ "El Guitar (clean)" 
  Data$ "El Guitar (muted)" 
  Data$ "Overdrive Guitar" 
  Data$ "Distortion Guitar" 
  Data$ "Guitar harmonic" 
  Data$ "Ac Bass" 
  Data$ "El Bass (finger)" 
  Data$ "El Bass (pick)" 
  Data$ "Fretless Bass" 
  Data$ "Slap Bass 1" 
  Data$ "Slap Bass 2" 
  Data$ "Synth Bass 1" 
  Data$ "Synth Bass 2" 
  Data$ "Violin" 
  Data$ "Viola" 
  Data$ "Cello" 
  Data$ "Contrabasse" 
  Data$ "Tremolo Strings" 
  Data$ "Pizzicato Strings" 
  Data$ "Orchestral Harp" 
  Data$ "Timpani" 
  Data$ "String Ensemble 1" 
  Data$ "String Ensemble 2" 
  Data$ "SynthStrings 1" 
  Data$ "SynthStrings 2" 
  Data$ "Choir Aahs" 
  Data$ "Voice Oohs" 
  Data$ "Synth Voice" 
  Data$ "Orchestra Hit" 
  Data$ "Trumpet" 
  Data$ "Trombone" 
  Data$ "Tuba" 
  Data$ "Muted Trumpet" 
  Data$ "French Horn" 
  Data$ "Brass Section" 
  Data$ "SynthBrass 1" 
  Data$ "SynthBrass 2" 
  Data$ "Soprano Sax" 
  Data$ "Alto Sax" 
  Data$ "Tenor Sax" 
  Data$ "Baritone Sax" 
  Data$ "Oboe" 
  Data$ "English Horn" 
  Data$ "Bassoon" 
  Data$ "Clarinet" 
  Data$ "Piccolo" 
  Data$ "Flute" 
  Data$ "Recorder" 
  Data$ "Pan Flute" 
  Data$ "Blown Bottle" 
  Data$ "Shakuhachi" 
  Data$ "Whistle" 
  Data$ "Ocarina" 
  Data$ "Lead 1 (square)" 
  Data$ "Lead 2 (sawtooth)" 
  Data$ "Lead 3 (calliope)" 
  Data$ "Lead 4 (chiff)" 
  Data$ "Lead 5" 
  Data$ "Lead 6 (voice)" 
  Data$ "Lead 7 (fifths)" 
  Data$ "Lead 8 (bass + lead)" 
  Data$ "Pad 1 (new age)" 
  Data$ "Pad 2 (warm)" 
  Data$ "Pad 3 (polysynth)" 
  Data$ "Pad 4 (choir)" 
  Data$ "Pad 5 (bowed" 
  Data$ "Pad 6 (metallic)" 
  Data$ "Pad 7 (halo)" 
  Data$ "Pad 8 (sweep)" 
  Data$ "FX 1 (rain)" 
  Data$ "FX 2 (soundtrack)" 
  Data$ "FX 3 (crystal)" 
  Data$ "FX 4 (atmosphere)" 
  Data$ "FX 5 (brightness)" 
  Data$ "FX 6 (goblins)" 
  Data$ "FX 7 (echoe)" 
  Data$ "FX 8 (sci-fi)" 
  Data$ "Sitar" 
  Data$ "Banjo" 
  Data$ "Shamisen" 
  Data$ "Koto" 
  Data$ "Kalimba" 
  Data$ "Bag pipe" 
  Data$ "Fiddle" 
  Data$ "Shanai" 
  Data$ "Tinkle Bell" 
  Data$ "Agogo" 
  Data$ "Steel Drums" 
  Data$ "Woodblock" 
  Data$ "Taiko Drum" 
  Data$ "Melodic Tom" 
  Data$ "Synth Drum" 
  Data$ "Reverse Cymba" 
  Data$ "Guitar Fret Noise" 
  Data$ "Breath Noise" 
  Data$ "Seashore" 
  Data$ "Bird Tweet" 
  Data$ "Telephone Ring" 
  Data$ "Helicopter" 
  Data$ "Applause" 
  Data$ "Gunshot" 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --