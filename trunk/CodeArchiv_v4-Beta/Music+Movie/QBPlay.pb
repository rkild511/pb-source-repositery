; German forum: http://www.purebasic.fr/german/viewtopic.php?t=359&highlight=
; Author: Froggerprogger  (examples of NicTheQuick added, updated for PB 4.00 by Andre)
; Date: 07. October 2004
; OS: Windows
; Demo: Yes



; - beliebig polyphon (durch Threads, gefährlich !["§$%&]?) 
; - Sounds: Saw(default)/Rect/Tan/Sin (Sin mit leichten Knacksern  ) 
; - Lautstärkeänderungen 
; - attack/decay 
; - Play/Stop/Pause - Steuerung 


;- QBPlay v1.1 
;- 2004/10/07 by Froggerprogger 
;/ 
;/  a,b,c,d,e,f,h = note to play (h = b) 
;/  # or +        = increase last note by one halftone (you might use multiple # or +) 
;/  -             = decrease last note by one halftone (you might use multiple -) 
;/  .             = add half of the length to the last note (you might use multiple .) 
;/  Oxx           = change octave for all following notes, xx is integer from 0-7 
;/  < or >        = changes octave by +1 or -1 for all following notes (you might use multiple < or >) 
;/  Nxx           = note to play given by it's ID (0 = pause, 1-96 = note-ID) 
;/  Txx           = sets the tempo in bpm, xx is integer from 10-360 
;/  Lxx           = length for all following notes, xx is integer from 1-64 
;/  P             = play a pause with the current length for notes 
;/  Pxx           = plays a pause with the given length. xx is integer from 1-64 
;/  ML            = play legato 
;/  MN            = play normal 
;/  MS            = play staccato 

;/ initialization 
#QBPlay_SampleRate  = 44100 
#HalftoneFac        = 1.05946309 ; = 2^(1/12) 
#C0                 = 32.7031956 ; Hz 

Enumeration ; Tone-types 
  #QBPlay_Tone_Rect 
  #QBPlay_Tone_Saw 
  #QBPlay_Tone_Tan 
  #QBPlay_Tone_Sin 
EndEnumeration 

;/ the song's structure 
Structure QBSong 
  playStatus.l        ; 0=stopped, 1=playing, 2=paused 
  playStr.s           ; contains the complete string to play, will be set by QBSong() ! 
  playStrLen.l        ; contains the length of the string 
  actPos.l            ; actual parsing position 
  tempo.l             ; current tempo in bpm 
  length.l            ; current note-length (1,2,...64) 
  octave.l            ; current octave (from c-b) from 0-7 
  legato.l            ; percent of note to hear (normal = 80, legato = 100, stacatto = 20) 
  pauseMs.l           ; following pause-time 
  nextUpdateMs.l      ; time of end of current note 
  pauseTime.l         ; point of time when setting song to paused 
  lpSound.l           ; pointer to current note's sound 
  volume.l            ; volume of song to set 
  actVolume.l         ; actual volume (incl. tone fade-ins/outs) 
  attack.l            ; attack-value (1 = slow - 100 = immediately) 
  decay.l             ; decay-value (1 = slow - 100 = immediately) 
  lpCx.l              ; pointer to memory holding the fq-values for C0 - C7 
  lpFactors.l         ; pointer to memory holding the fq-factors for 0-11 halftones above C 
  tonetype.l          ; holding a Tone-type-flag describing the toneformat 
EndStructure 

;/ some neccessary procedure declarations 
DeclareDLL.l QBPlayEx2(p_str.s, p_volume.l, p_paused.l, p_tonetype.l, p_attack.l, p_decay.l) 
DeclareDLL.l QBPlay_SetVolume(*p_song.QBSong, p_volume.l) 
DeclareDLL.l QBPlay_Free(*p_song.QBSong) 
DeclareDLL.l QBPlay_Stop(*p_song.QBSong) 
Declare.l QBPlay_InitSong(*song.QBSong) 
Declare.l QBPlay_UpdateThread(*p_song.QBSong) 

;/ playcontrol procedures 
ProcedureDLL.l QBPlay(p_str.s) 
  ProcedureReturn QBPlayEx2(p_str, 100, 0, #QBPlay_Tone_Saw, 5, 5) 
EndProcedure 

ProcedureDLL.l QBPlayEx(p_str.s, p_volume.l, p_paused.l) 
  ProcedureReturn QBPlayEx2(p_str, p_volume, p_paused, #QBPlay_Tone_Saw, 5, 5) 
EndProcedure 

ProcedureDLL.l QBPlayEx2(p_str.s, p_volume.l, p_paused.l, p_tonetype.l, p_attack.l, p_decay.l) 
  Protected *song.QBSong 

  If p_str = "" : ProcedureReturn 0 : EndIf 
  
  If p_attack <= 0  Or p_attack > 100 : p_attack = 100 : EndIf 
  If p_decay  <= 0  Or p_decay > 100  : p_decay = 100 : EndIf 

  *song = AllocateMemory(SizeOf(QBSong)) 
  If *song = 0 : ProcedureReturn 0 : EndIf 

  *song\tonetype = p_tonetype 

  If QBPlay_InitSong(*song) = 0 
    FreeMemory(*song) 
    ProcedureReturn 0 
  EndIf 
    
  ; set the defaults 
  *song\playStr       = UCase(p_str) + "Z" 
  *song\playStr       = ReplaceString(*song\playStr, " ", "") 
  *song\playStr       = ReplaceString(*song\playStr, "#", "+") 
  *song\playStr       = ReplaceString(*song\playStr, "h", "b") 
  *song\playStrLen    = Len(p_str) 
  *song\actPos        = 1 
  *song\tempo         = 120 
  *song\length        = 4 
  *song\octave        = 3 
  *song\legato        = 80 
  *song\pauseMs       = 0 
  *song\nextUpdateMs  = 0 
  *song\lpSound       = 0 
  *song\actVolume     = 0 
  *song\attack        = p_attack 
  *song\decay         = p_decay 

  QBPlay_SetVolume(*song, p_volume) 
  
  If p_paused = 0 
    *song\playStatus = 1 
  Else 
    *song\playStatus = 2 
  EndIf 
  
  If CreateThread(@QBPlay_UpdateThread(), *song) 
    ProcedureReturn *song 
  Else 
    QBPlay_Free(*song) 
    ProcedureReturn 0 
  EndIf 
EndProcedure 

ProcedureDLL.l QBPlay_Free(*p_song.QBSong) 
  Protected *l.LONG 
  
  If *p_song = 0 : ProcedureReturn 0 : EndIf 

  ; stop the song to quit it's thread 
  If *p_song\playStatus 
    QBPlay_Stop(*p_song) 
  EndIf 

  ; wait until updater-thread is quit 
  While *p_song\playStatus <> 0 : Delay(1) : Wend 
  
  ; 1st: free the sounds 
  *l = *p_song\lpCx 
  For i=0 To 7 
    FreeSound(*l\l) 
    *l + 4 
  Next 

  ; 2nd: free the soundarray 
  FreeMemory(*p_song\lpCx) 

  ; 3rd: free the factorsarray 
  FreeMemory(*p_song\lpFactors) 

  ; 4th: free the playstring 
  *p_song\playStr = "" 

  ; 5th: free itself 
  FreeMemory(*p_song) 
  
  ProcedureReturn 1 
EndProcedure 

ProcedureDLL.l QBPlay_Start(*p_song.QBSong) 
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  
  If *p_song\playStatus = 2 
    *p_song\playStatus = 3 
  ElseIf *p_song\playStatus = 0 
    *p_song\playStatus = 1 
    ProcedureReturn CreateThread(@QBPlay_UpdateThread(), *p_song) 
  Else 
    ProcedureReturn 0 
  EndIf 
  
  ProcedureReturn 1 
EndProcedure  

ProcedureDLL.l QBPlay_Stop(*p_song.QBSong) 
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  If *p_song > 0 
    *p_song\playStatus = 5 
  EndIf 
  ProcedureReturn 1 
EndProcedure 

ProcedureDLL.l QBPlay_Pause(*p_song.QBSong) 
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  If *p_song\playStatus = 0 Or *p_song\playStatus = 1 
    *p_song\playStatus = 4 
  Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure  

ProcedureDLL.l QBPlay_SetVolume(*p_song.QBSong, p_volume.l) 
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  
  If p_volume < 0 
    p_volume = 0 
  ElseIf p_volume > 100 
    p_volume = 0 
  EndIf 
  *p_song\volume = p_volume 
  
  ProcedureReturn 1 
EndProcedure 

;/ information 
ProcedureDLL.l QBPlay_IsPlaying(*p_song.QBSong) 
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  ProcedureReturn *p_song\playStatus 
EndProcedure 

;/ help procedures 
Procedure.l QBPlay_CreateWavs(p_fq.f, p_secs.l, p_samples.l, p_flags.l) 
  Protected *result.l, *sampleVal.WORD 
  Protected i.l, fi.f, dataSamples.l, dataBytes.l 
  
  dataSamples = p_secs * #QBPlay_SampleRate + p_samples 
  
  dataBytes   = dataSamples * 2 ; secs * samplerate * numchannels * blockalign 

  *result = AllocateMemory(46 + dataBytes) 
  
  PokeL(*result       , 'FFIR') ; id RIFF-chunk 
  PokeL(*result + 4   , 38 + dataBytes) ; size of RIFF-chunk 
  PokeL(*result + 8   , 'EVAW') ; id WAVE-chunk 
  PokeL(*result + 12  , ' tmf') ; id fmt-chunk 
  PokeL(*result + 16  , 18)     ; size fmt-chunk (incl. opt. extra-fmt-data-length-word here) 
  PokeW(*result + 20  , 1)      ; compression code, 1 = uncompressed 
  PokeW(*result + 22  , 1)      ; number of channels, 1 = mono 
  PokeL(*result + 24  , #QBPlay_SampleRate) ; samplerate 
  PokeL(*result + 28  , #QBPlay_SampleRate * 1 * 2) ; BytesPerSec = samplerate * number of channels * blockAlign 
  PokeW(*result + 32  , 2)      ; blockAlign = RoundUp(Bitrate / 8) 
  PokeW(*result + 34  , 16)     ; Bitrate 
  PokeW(*result + 36  , 0)      ; numuber of extra format bytes 
  PokeL(*result + 38  , 'atad') ; id data-chunk 
  PokeL(*result + 42  , dataBytes) ; size of data-chunk 

  *sampleVal = *result + 46 
  
  Select p_flags 
    Case #QBPlay_Tone_Sin 
      For i=0 To dataSamples - 1 
        fi = i 
        *sampleVal\w = 16383.0 * Sin((2.0 * #PI * fi * p_fq) / #QBPlay_SampleRate) ; -6 dB max 
        *sampleVal + 2 
      Next  
    
    Case #QBPlay_Tone_Tan 
      For i=0 To dataSamples - 1 
        fi = i 
        *sampleVal\w = 16383.0 * Tan((2.0 * #PI * fi * p_fq) / #QBPlay_SampleRate) ; -6 dB max 
        *sampleVal\w / 8.0 
        *sampleVal + 2 
      Next  

    Case #QBPlay_Tone_Saw 
      Protected count.l, countStep.l 
      count = 0 
      countStep = 65536 * p_fq / (#QBPlay_SampleRate) 
      For i=0 To dataSamples - 1 
        *sampleVal\w = count / 2.0 ; -6 dB max 
        count + countStep 
        If count > 32767 
          count = -32768 
        EndIf 
        *sampleVal\w / 8.0 
        *sampleVal + 2 
      Next 
    
    Case #QBPlay_Tone_Rect 
      For i=0 To dataSamples - 1 
        fi = i 
        *sampleVal\w = 16383.0 * Sin((2.0 * #PI * fi * p_fq) / #QBPlay_SampleRate) ; -6 dB max 
        If *sampleVal\w >= 0 
          *sampleVal\w = 16383 
        Else 
          *sampleVal\w = -16384 
        EndIf 
        *sampleVal\w / 8.0 
        *sampleVal + 2 
      Next 
  EndSelect 

  ProcedureReturn *result 
EndProcedure 

Procedure.l QBPlay_InitSong(*p_song.QBSong) 
  Protected i.l, temp.l, tempF.f, fq.l 
  Protected *l.LONG, *f.FLOAT 
  
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  
  *p_song\lpCx       = AllocateMemory(8 * SizeOf(LONG)) ; for 8 long-values (adresses) 
    If *p_song\lpCx = 0 : ProcedureReturn 0 : EndIf 
  *p_song\lpFactors  = AllocateMemory(12 * SizeOf(FLOAT)) ; for 12 float-values 
    If *p_song\lpCx = 0 
      FreeMemory(*p_song\lpCx) 
      *p_song\lpCx = 0 
      ProcedureReturn 0 
    EndIf 
  
  ; prepare the sounds 
  *l = *p_song\lpCx 
  For i=0 To 7 
    fq = #C0 * Pow (2, i) 
    temp = QBPlay_CreateWavs(fq, 0, #QBPlay_SampleRate / fq, *p_song\tonetype) 
      If temp = 0 : ProcedureReturn 0 : EndIf 
    temp = CatchSound(#PB_Any, temp) 
      If temp = 0 : ProcedureReturn 0 : EndIf 
    SoundVolume(temp, 0) 
    *l\l = temp 
    *l + 4 
  Next 

  ; prepare the factors 
  tempF = 1.0 
  *f = *p_song\lpFactors 
  *f\f = tempF 
  For i=1 To 11 
    tempF * #HalftoneFac 
    *f + 4 
    *f\f = tempF 
  Next 
  
  ProcedureReturn 1 
EndProcedure 

Procedure.l QBPlay_FadeOut(*p_song.QBSong) 
  Protected i.l 
  
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  
  If *p_song\lpSound 
    i = *p_song\actVolume 
    While i > *p_song\decay 
      i - *p_song\decay 
      SoundVolume(*p_song\lpSound, i) 
      Delay(1) 
    Wend 
    SoundVolume(*p_song\lpSound, 0) 
    StopSound(*p_song\lpSound) 
    *p_song\lpSound = 0 
  EndIf 
  
  *p_song\actVolume = 0 
  ProcedureReturn 1 
EndProcedure 

Procedure.l QBPlay_FadeIn(*p_song.QBSong) 
  Protected i.l 
  
  If *p_song = 0 : ProcedureReturn 0 : EndIf 
  
  If *p_song\lpSound 
    i = *p_song\actVolume 
    While i + *p_song\attack < *p_song\volume 
      i + *p_song\attack 
      SoundVolume(*p_song\lpSound, i) 
      Delay(1) 
    Wend 
    SoundVolume(*p_song\lpSound, *p_song\volume) 
  EndIf 
  *p_song\actVolume = *p_song\volume 
  ProcedureReturn 1 
EndProcedure 

Procedure.l QBPlay_Update(*p_song.QBSong) 
  Protected actTime.l 
  Protected *char.BYTE 
  Protected temp.l, tempF.f 
  Protected parseToNumEnd.l, parseToIncDecEnd.l, parseToDoubleEnd.l 
  Protected noteToPlay.l, noteLength.f, noteLengthMs.l, i.l 
  
  If *p_song = 0 Or *p_song\playStatus = 0 
    ProcedureReturn 0 
  EndIf 
  
  actTime = ElapsedMilliseconds() 

  If *p_song\nextUpdateMs > actTime 
    ProcedureReturn 1 
  EndIf 

  If *p_song\actPos > *p_song\playStrLen 
    *p_song\playStatus = 5 
  EndIf 

  If *p_song\playStatus = 2 ; is paused 
    ProcedureReturn 1 
  ElseIf *p_song\playStatus = 3 ; set to resume 
    If *p_song\nextUpdateMs = 0 
      *p_song\nextUpdateMs = actTime 
    Else 
      *p_song\nextUpdateMs + (actTime - *p_song\pauseTime) 
    EndIf 
    *p_song\playStatus = 1 
  ElseIf *p_song\playStatus = 4 ; set to pause 
    *p_song\pauseTime = actTime 
    *p_song\pauseMs = 0 
    QBPlay_FadeOut(*p_song) 
    *p_song\playStatus = 2 
    ProcedureReturn 1 
  ElseIf *p_song\playStatus = 5 ; set to stop 
    *p_song\nextUpdateMs = 0 
    *p_song\pauseMs = 0 
    *p_song\actPos = 1 
    QBPlay_FadeOut(*p_song) 
    ;*p_song\playStatus = 0 will be called inside the calling thread 
    ProcedureReturn 0 
  EndIf 

  If *p_song\nextUpdateMs = 0 
    *p_song\nextUpdateMs = actTime 
  EndIf 
  
  If *p_song\pauseMs 
    QBPlay_FadeOut(*p_song) 
    *p_song\nextUpdateMs  + *p_song\pauseMs 
    *p_song\pauseMs       = 0 
    If *p_song\nextUpdateMs < actTime 
      *p_song\lpSound = 0 
      ProcedureReturn 1 
    EndIf 
  EndIf 
  
  *char             = @*p_song\playStr + *p_song\actPos - 1 
  parseToNumEnd     = 0 
  parseToIncDecEnd  = 0 
  parseToDoubleEnd  = 0 
  noteToPlay        = 0 
  noteLength        = *p_song\length 
  
  While *p_song\nextUpdateMs <= actTime And *p_song\actPos <= *p_song\playStrLen And playNow = 0 
    Select *char\b & $FF 
      Case 'T' :  temp = Val(Mid(*p_song\playStr, *p_song\actPos + 1, *p_song\playStrLen - *p_song\actPos - 1)) 
                  If temp < 10    : temp = 10   : EndIf 
                  If temp > 360   : temp = 360  : EndIf 
                  *p_song\tempo   = temp 
                  parseToNumEnd   = 1 
      
      Case 'N' :  temp = Val(Mid(*p_song\playStr, *p_song\actPos + 1, *p_song\playStrLen - *p_song\actPos - 1)) 
                  If temp < 0     : temp = 0    : EndIf 
                  If temp > 96    : temp = 96   : EndIf 
                  noteToPlay      = temp 
                  parseToNumEnd   = 1 
                  playNow         = 1 
      
      Case 'L' :  temp = Val(Mid(*p_song\playStr, *p_song\actPos + 1, *p_song\playStrLen - *p_song\actPos - 1)) 
                  If temp < 1     : temp = 1    : EndIf 
                  If temp > 64    : temp = 64   : EndIf 
                  *p_song\length  = temp 
                  noteLength      = temp 
                  parseToNumEnd   = 1 

      Case 'O' :  temp = Val(Mid(*p_song\playStr, *p_song\actPos + 1, *p_song\playStrLen - *p_song\actPos - 1)) 
                  If temp < 0     : temp = 0    : EndIf 
                  If temp > 7     : temp = 7   : EndIf 
                  *p_song\octave  = temp 
                  parseToNumEnd   = 1 
      
      Case 'P' :  temp = Val(Mid(*p_song\playStr, *p_song\actPos + 1, *p_song\playStrLen - *p_song\actPos - 1)) 
                  If temp < 1     : temp = *p_song\length  : EndIf 
                  If temp > 64    : temp = 64   : EndIf 
                  noteToPlay      = 0 
                  noteLength      = temp 
                  parseToNumEnd   = 1 
                  playNow         = 1 
      
      Case '<' :  If *p_song\octave < 7 : *p_song\octave + 1 : EndIf 
      Case '>' :  If *p_song\octave > 0 : *p_song\octave - 1 : EndIf 
      
      Case 'A' :  noteToPlay = 1 + *p_song\octave * 12 + 9  : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'B' :  noteToPlay = 1 + *p_song\octave * 12 + 11 : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'C' :  noteToPlay = 1 + *p_song\octave * 12      : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'D' :  noteToPlay = 1 + *p_song\octave * 12 + 2  : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'E' :  noteToPlay = 1 + *p_song\octave * 12 + 4  : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'F' :  noteToPlay = 1 + *p_song\octave * 12 + 5  : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      Case 'G' :  noteToPlay = 1 + *p_song\octave * 12 + 7  : parseToIncDecEnd = 1 : *char + 1 : *p_song\actPos + 1 
      
      Case 'M' :  *char + 1 
                  *p_song\actPos + 1 
                  If *char\b & $FF = 'L' 
                    *p_song\legato = 100 
                  ElseIf *char\b & $FF = 'N' 
                    *p_song\legato = 75 
                  ElseIf *char\b & $FF = 'S' 
                    *p_song\legato = 20 
                  EndIf 
      
      Case '.' :  parseToDoubleEnd = 1 

      Case 'Z' : playNow = 1 
      
    EndSelect 
    
    If parseToIncDecEnd ; parse all following '+' or '-' 
      While *char\b & $FF = '+' Or *char\b & $FF = '-' 
        If *char\b & $FF = '+' 
          noteToPlay + 1 
        Else 
          noteToPlay - 1 
        EndIf 
        *char + 1 
        *p_song\actPos + 1 
      Wend 
      If noteToPlay < 1  : noteToPlay = 1  : EndIf 
      If noteToPlay > 96 : noteToPlay = 96 : EndIf 
      While *char\b & $FF = '.' 
        noteLength * 2.0 / 3.0 
        *char + 1 
        *p_song\actPos + 1 
      Wend 
      If noteLength < 1.0 : noteLength = 1.0 : EndIf 
      playNow = 1 
    
    ElseIf parseToDoubleEnd ; parse all following '.' 
      While *char\b & $FF = '.' 
        noteLength * 2.0 / 3.0 
        *char + 1 
        *p_song\actPos + 1 
      Wend 
      If noteLength < 1.0 : noteLength = 1.0 : EndIf 
      playNow = 1 
      
    ElseIf parseToNumEnd ; parse to end of number 
      *char + 1 
      *p_song\actPos + 1 
      While *char\b & $FF >= '0' And *char\b & $FF <= '9' And *p_song\actPos < *p_song\playStrLen 
        *char + 1 
        *p_song\actPos + 1 
      Wend 
    Else ; else just increase by 1 
      *char + 1 
      *p_song\actPos + 1 
    EndIf 
    
    parseToNumEnd = 0 
    
    If playNow ; check if we have to goon immediately 
      noteLengthMs = 2400 * *p_song\legato / (*p_song\tempo * noteLength) 
      *p_song\nextUpdateMs + noteLengthMs 
      *p_song\pauseMs = 2400 * (100 - *p_song\legato) / (*p_song\tempo * noteLength) 
      If *p_song\nextUpdateMs <= actTime 
        playNow = 0 
      EndIf 
    EndIf 
  Wend 
  
  If playNow 
    QBPlay_FadeOut(*p_song) 
    If noteToPlay 
      ; calculate the octave's C 
      *p_song\lpSound = PeekL(*p_song\lpCx + SizeOf(LONG) * Int((noteToPlay - 1) / 12)) 
      ; get the factor 
      temp = *p_song\lpFactors + SizeOf(FLOAT) * (noteToPlay - 1) % 12 
      tempF = PeekF(temp) 
      SoundFrequency(*p_song\lpSound, #QBPlay_SampleRate * tempF) 
      ; play the sound (volume will always be 0 at this point) 
      PlaySound(*p_song\lpSound, 1) 
      QBPlay_FadeIn(*p_song) 
    EndIf 
  EndIf 
  
  If *p_song\actPos > *p_song\playStrLen + 1 
    ProcedureReturn 0 
  Else 
    ProcedureReturn *p_song\nextUpdateMs 
  EndIf 
EndProcedure 

Procedure.l QBPlay_UpdateThread(*p_song.QBSong) 
  While QBPlay_Update(*p_song) 
    Delay(1) 
  Wend 
  *p_song\playStatus = 0 
EndProcedure 

;- EXAMPLE 
InitSound() 

;/ example 0 
*a = QBPlay("cdefgab<c") 

While QBPlay_IsPlaying(*a) 
  Delay(100) 
Wend 
QBPlay_Free(*a) 

;/ example 1 
playStr1.s = "o4T160L8 dd#e<c p >e<c p >e<l2c p4 l8cdd#ecde p >b<d p l4c p4 >c<" 
playStr1   + "l8cdecde p8 cdcecde p8 cdcecde p8 >b<d p8 l2c t250l16c<c<c<c>c>c>c" 

playBass.s = "o2T160L4MS p4 c>g<c>g<c>g<c>g MNbgbg MS<c>gc p4 MNl8<ce>g<ece>g<e l4c>g<c>g  l8b<d>g<d>b<d>g<d MSl4c>gc" 

*a = QBPlayEx2(playStr1, 100, 1, #QBPlay_Tone_Saw, 100, 100) 
*b = QBPlayEx2(playBass, 100, 1, #QBPlay_Tone_Rect, 100, 100) 

QBPlay_Start(*a) : QBPlay_Start(*b) 
Delay(2000) 
QBPlay_Stop(*a) : QBPlay_Stop(*b) 
Delay(1000) 
QBPlay_Start(*a) : QBPlay_Start(*b) 

While QBPlay_IsPlaying(*a) And QBPlay_IsPlaying(*b) 
  Delay(100) 
Wend 

QBPlay_Free(*a) : QBPlay_Free(*b) 

;/ example 2 
*a = QBPlayEx2(playStr1, 100, 0, #QBPlay_Tone_Tan, 2, 5) 
*b = QBPlayEx2(playBass, 100, 0, #QBPlay_Tone_Saw, 100, 100) 

Delay(6000) 

QBPlay_Free(*a) : QBPlay_Free(*b) 


;/ example 3 
*a = QBPlayEx2("t20MLL4g.", 35, 0, #QBPlay_Tone_Sin, 2, 2) 
*b = QBPlayEx2("t20MLp8L4e", 35, 0, #QBPlay_Tone_Sin, 2, 2) 
*c = QBPlayEx2("t20MLp4L8c", 35, 0, #QBPlay_Tone_Sin, 2, 2) 

While QBPlay_IsPlaying(*a) 
  Delay(100) 
Wend 


;/ example 4  (Smoke on the water)
QBPlay("o1 l4ega.  eg  l8a#l2a   l4ega.g   l8el2e") 
QBPlay("o1 l4h<de. >h<dl8fl2e    l4>h<de.d l8>hl2h") 
QBPlay("o2 l4ega.  eg  l8a#l2a   l4ega.g   l8el2e") 
Delay(8000)



;/ example 5  (Summertime)
Melodie.s = "T120 P1 P1 P1 P1 P1 P1 P2 L4 O4 ec L1 e P4 L8 dcde L4 c > L2 ae. P4 < L4 ec L8 d L2 d. P4 L8 c>a<c>a< L4 c L1 >b" 
Right_1.s = "T120 O3 L8 e-ce-dc>a<cd L2 e P08 L8 >a<cd P2 <afd>bgec>a P2 P1 P4 <<< L4 f+ P4 g+ P4 f+ >ec L1 e P4 L8 dcde L4 c > L2 a L1 e L4 <ec L8 d L2 d. L4 c L8 c>a<c>a< L4 c L8 >b>b<ee-d>h<f+f" 
Right_2.s = "T120 P1 P1 O3 L1 eeee L2 e P2 f+g+f+g+edc L4 g+f+f L8 gg+ L4 a L8 b-b L2 <c L4 >ed+ P8 >b. L2 a" 
Right_3.s = "T120 P1 P1 P1 P1 P1 P4 O4 L4 f+ P4 g+ P4 f+ P2 P1 P1 L2 >c P2 P1 P1 d P2 P1" 
Left_1.s  = "T120 O2 L8 -ec-edc>a<cd L2 e P08 L8 >a<cd P1 P2 L4 f+g+f+g+f+g+ L2 f+g+f+g+ <cdcd>f+g+f+ L4 <dc>a L8 b-b L4 <c. L8 c+ L4 >4deff+ L2 ed+" 
Left_2.s  = "T120 P1 P1 O2 L1 eeeee L2 eeee>aba L4 <ee L2 df L1 >a L2 g+b" 
Left_3.s  = "T120 P1 P1 P1 P1 P1 P1 P1 O1 L2 abab P1 P2 L4 ba P1 P1 P1" 

*Melodie = QBPlayEx2(Melodie, 100, 1, #QBPlay_Tone_Sin, 100, 100) 
*Right_1 = QBPlayEx2(Right_1,  60, 1, #QBPlay_Tone_Sin, 2, 100) 
*Right_2 = QBPlayEx2(Right_2,  60, 1, #QBPlay_Tone_Sin, 2, 100) 
*Right_3 = QBPlayEx2(Right_3,  60, 1, #QBPlay_Tone_Sin, 2, 100) 
*Left_1  = QBPlayEx2(Left_1,   60, 1, #QBPlay_Tone_Sin, 2, 100) 
*Left_2  = QBPlayEx2(Left_2,   60, 1, #QBPlay_Tone_Sin, 2, 100) 
*Left_3  = QBPlayEx2(Left_2,   60, 1, #QBPlay_Tone_Sin, 2, 100) 

QBPlay_Start(*Melodie) 

QBPlay_Start(*Right_1) 
QBPlay_Start(*Right_2) 
QBPlay_Start(*Right_3) 

QBPlay_Start(*Left_1) 
QBPlay_Start(*Left_2) 
QBPlay_Start(*Left_2) 

While QBPlay_IsPlaying(*Melodie) 
  Delay(100) 
Wend 

MessageRequester("Summertime", "Lied ist zu Ende")


;/ example 6  (Swing von Duke Ellington)
;{/ Satin Doll 
Melodie.s = "t120 p1 p1 p1 p1 o3 l8 a. l16 g l8 a l4 g a. p8 a. l8 g l4 a. l8 b. l16 a l8 b l4 a b. p8 b. l8 a l4 b. p8 <d. l8 c l4 d.> p8 b-.a- l8 b- l1 g. p2 p8" 

Right_1.s = "t120 o3 l8 a. l16 g+ l8 a l4 b-b-. l8 b. l16 a+ l8 b l4 b-b-. l8 a. l16 g+ l8 a l4 a-a-. gf+gg+ l8 a. l16 g l8 a l4 g a. p8 a. l8 g l4 a. l8 b. l16 a l8 b l4 a b. p8 b. l8 a l4 b. p8 <d. l8 c l4 d.> p8 b-.a- l8 b- l4 g p16 l16 e l8 f l4 g l8 ef l4 g p16 l16 e l8 f l4 g b-." 
Right_2.s = "t120 o3 l4 f.g-g-.g.g-g.f.f-f.e-de-ef. l2 f p4 l4 f. l2 f l4 g. l2 g p4 l4 g. l2 g p8 l4 g. l2 f+ p8 l4 g-.f.e- p4 l2 cd l8 e p8 l4 f+." 
Right_3.s = "t120 o3 l4 c.d-d-.d.d-d-.c.c-c-.>-bab-bc. l2 >b< p4 l4 c. l2 >b< l4 d. l2 c+ p4 l4 d. l2 c+ p8 l4 c. l2 d p8 l4 e-.d.c p4 l2 >ab l8 c+ p8 l4 c+." 

Left_1.s  = "t120 o1 l4 d.e-e-.e.e-e-.d.d-d-.c>b<c+c l2 d l4 gc+ l2 d l4 g l8 f+f l2 e l4 ad+ l2 e l4 ae l2 e-da- l4 d-. c p4 l2 fe l4 a a." 
Left_2.s  = "t120 p1 p1 p1 p1 p1 p1 p1 p1 p1 p1 p4 p8 o2 l2 c>b p8 p2" 
Left_3.s  = "t120 p1 p1 p1 p1 p1 p1 p1 p1 p1 p1 p4 p8 o2 l2 fe l4 gg." 

*Melodie = QBPlayEx2(Melodie, 100, 1, #QBPlay_Tone_Tan, 100, 5) 
*Right_1 = QBPlayEx2(Right_1,  60, 1, #QBPlay_Tone_Sin, 10, 100) 
*Right_2 = QBPlayEx2(Right_2,  60, 1, #QBPlay_Tone_Sin, 10, 100) 
*Right_3 = QBPlayEx2(Right_3,  60, 1, #QBPlay_Tone_Sin, 10, 100) 
*Left_1  = QBPlayEx2(Left_1,   80, 1, #QBPlay_Tone_Sin, 10, 100) 
*Left_2  = QBPlayEx2(Left_2,   80, 1, #QBPlay_Tone_Sin, 10, 100) 
*Left_3  = QBPlayEx2(Left_2,   80, 1, #QBPlay_Tone_Sin, 10, 100) 

QBPlay_Start(*Melodie) 

QBPlay_Start(*Right_1) 
QBPlay_Start(*Right_2) 
QBPlay_Start(*Right_3) 

QBPlay_Start(*Left_1) 
QBPlay_Start(*Left_2) 
QBPlay_Start(*Left_2) 

While QBPlay_IsPlaying(*Melodie) 
  Delay(100) 
Wend 

MessageRequester("Satin Doll", "Lied ist zu Ende")



QBPlay_Free(*a) : QBPlay_Free(*b) : QBPlay_Free(*c) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---