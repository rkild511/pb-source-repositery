;**
;* Info: Additional Sound-Functions _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _

;** CreateSound
;* This create a specific sound. _
;* This function create in the memory a wave And catch it _
;* With CatchSound(nr,*wave), so you can use PlaySound(),etc
Procedure CreateSound(nr,Frequency,Duration,SampleRate);
  Structure wave_
    wFormatTag.w
    nChannels.w
    nSamplesPerSec.l
    nAvgBytesPerSec.l
    nBlockAlign.w
    wBitsPerSample.w
    cbSize.w
  EndStructure

  Protected SoundValue.b
  Protected w.f; // omega ( 2 * pi * frequency)
  Protected wave_FormatEx.wave_
  Protected DataCount.l, RiffCount.l, start.l, MS.l, TempInt.l, i.l

  wave_FormatEx\wFormatTag=#WAVE_FORMAT_PCM;
  wave_FormatEx\nChannels =$0001;mono
  wave_FormatEx\nSamplesPerSec = SampleRate;
  wave_FormatEx\wBitsPerSample = $0008;
  wave_FormatEx\nBlockAlign = (wave_FormatEx\nChannels * wave_FormatEx\wBitsPerSample) /8
  wave_FormatEx\nAvgBytesPerSec = wave_FormatEx\nSamplesPerSec * wave_FormatEx\nBlockAlign;
  wave_FormatEx\cbSize = 0;

  DataCount = (Duration * SampleRate)/1000; // sound data
  RiffCount = 4+4 +4+ SizeOf(wave_)+4 +4+ DataCount

  start=GlobalAlloc_(#GMEM_FIXED|#GMEM_ZEROINIT,RiffCount+100)
  MS=start

  PokeS(MS,"RIFF"):MS+4   ;'RIFF'
  PokeL(MS,RiffCount):MS+4 ;file Data size
  PokeS(MS,"wave"):MS+4   ;'wave_'
  PokeS(MS,"fmt "):MS+4    ;'fmt '
  TempInt = SizeOf(wave_);
  PokeL(MS,TempInt):MS+4   ;Twave_Format data size

  PokeW(MS,wave_FormatEx\wFormatTag):MS+2; wave_FormatEx record
  PokeW(MS,wave_FormatEx\nChannels):MS+2
  PokeL(MS,wave_FormatEx\nSamplesPerSec):MS+4
  PokeL(MS,wave_FormatEx\nAvgBytesPerSec):MS+4
  PokeW(MS,wave_FormatEx\nBlockAlign):MS+2
  PokeW(MS,wave_FormatEx\wBitsPerSample):MS+2
  PokeW(MS,wave_FormatEx\cbSize):MS+2

  PokeS(MS,"data"):MS+4   ;'data'
  PokeL(MS,DataCount):MS+4 ;sound data size

  ; {Calculate And write out the tone signal}  // now the Data values

  w = 2 * 3.1415 * Frequency;  omega
  For i = 0 To DataCount - 1
   SoundValue = 127 + 127 * Sin(i * w / SampleRate);
   PokeB(MS,SoundValue):MS+1;
  Next
  CatchSound(Nr,start)
  GlobalFree_(start)
EndProcedure

;** PlayWaveDirect
;* This play a Wave-File direct with api. _
;* You don't must init a sound system or DirectX! _
;* Usefull For application
Procedure PlayWaveDirect(File$)
  PlaySound_(File$,0,#SND_ASYNC|#SND_FILENAME|#SND_NODEFAULT|#SND_NOWAIT)
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 71
; FirstLine = 29
; Folding = -
; EnableXP
; HideErrorLog