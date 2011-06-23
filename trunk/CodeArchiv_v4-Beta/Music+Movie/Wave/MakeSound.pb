; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=871
; Author: GPI (updated for PB3.91+ by Andre, updated for PB 4.00 by Andre)
; Date: 03. May 2003
; OS: Windows
; Demo: Yes

Structure WAVE
  wFormatTag.w
  nChannels.w
  nSamplesPerSec.l
  nAvgBytesPerSec.l
  nBlockAlign.w
  wBitsPerSample.w
  cbSize.w
EndStructure

Procedure MakeSound(nr,Frequency, duration);
  SoundValue.b
  w.f; // omega ( 2 * pi * frequency)
  #Mono= $0001;
  #SampleRate= 11025; // 8000, 11025, 22050, or 44100
  #RiffId = "RIFF";
  #WaveId=  "WAVE";
  #FmtId=   "fmt ";
  #DataId=  "data";

  WaveFormatEx.WAVE
  WaveFormatEx\wFormatTag=#WAVE_FORMAT_PCM;
  WaveFormatEx\nChannels =#Mono;
  WaveFormatEx\nSamplesPerSec = #SampleRate;
  WaveFormatEx\wBitsPerSample = $0008;
  WaveFormatEx\nBlockAlign = (WaveFormatEx\nChannels * WaveFormatEx\wBitsPerSample) /8
  WaveFormatEx\nAvgBytesPerSec = WaveFormatEx\nSamplesPerSec * WaveFormatEx\nBlockAlign;
  WaveFormatEx\cbSize = 0;

  DataCount = (duration * #SampleRate)/1000; // sound data
  RiffCount = 4+4 +4+ SizeOf(WAVE)+4 +4+ DataCount

  start=AllocateMemory(RiffCount+100)
  MS=start

  PokeS(MS,#RiffId):MS+4   ;'RIFF'
  PokeL(MS,RiffCount):MS+4 ;file Data size
  PokeS(MS,#WaveId):MS+4   ;'WAVE'
  PokeS(MS,#FmtId):MS+4    ;'fmt '
  TempInt = SizeOf(WAVE);
  PokeL(MS,TempInt):MS+4   ;TWaveFormat data size

  PokeW(MS,WaveFormatEx\wFormatTag):MS+2; WaveFormatEx record
  PokeW(MS,WaveFormatEx\nChannels):MS+2
  PokeL(MS,WaveFormatEx\nSamplesPerSec):MS+4
  PokeL(MS,WaveFormatEx\nAvgBytesPerSec):MS+4
  PokeW(MS,WaveFormatEx\nBlockAlign):MS+2
  PokeW(MS,WaveFormatEx\wBitsPerSample):MS+2
  PokeW(MS,WaveFormatEx\cbSize):MS+2

  PokeS(MS,#DataId):MS+4   ;'data'
  PokeL(MS,DataCount):MS+4 ;sound data size

  ;{Calculate And write out the tone signal}  // now the Data values

  w = 2 * #PI * Frequency;  omega
  For i = 0 To DataCount - 1
    ;// wt = w *i /SampleRate
    ;SoundValue := 127 + trunc(127 * Sin(i * w / SampleRate));
    SoundValue = 127 + 127 * Sin(i * w / #SampleRate);
    PokeB(MS,SoundValue):MS+1;
  Next
  ;// you could save the wave tone To file with :
  ;// MS.Seek(0, soFromBeginning);
  ;// MS.SaveToFile('C:\MyFile.wav');
  ;// then reload And play them without having To
  ;// construct them each time.
  ;{now play the sound}
  ;sndPlaySound(MS.Memory, SND_MEMORY Or SND_SYNC);
  ;MS.Free;

  CatchSound(nr,start)
  
  ProcedureReturn start
EndProcedure

Procedure QuitSound(nr, mem)
  StopSound(nr)
  FreeSound(nr)
  FreeMemory(mem)
EndProcedure

InitSound()
mem = MakeSound(0,600,2000)

PlaySound(0)
Delay(2000)
QuitSound(0, mem)
Debug "done"

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -