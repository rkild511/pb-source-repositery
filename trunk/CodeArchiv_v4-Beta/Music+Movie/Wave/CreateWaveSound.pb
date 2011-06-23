; http://rafb.net/paste/results/wMmfaj42.html
; Author: DarkDragon (updated for PB 4.00 by Andre)
; Date: 19. February 2006
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
 
Structure WAVE_EX
  RiffSig.l
  RiffCount.l
  WaveSig.l
  fmtSig.l
  TWaveFormat.l
 
  w.WAVE
 
  DataSig.l
  DataCount.l
EndStructure
 
Procedure WAV_CreateSound(Filename.s, *SoundData, SoundDataSize.l, Bits.b, SampleRate.l)
  If Bits = 0		  : Bits = 8	: EndIf
  If Bits > 32		: Bits = 32	: EndIf
 
  pFile = CreateFile(#PB_Any, Filename)
  If pFile
  	WaveFormatEx.WAVE_EX
 
  	With WaveFormatEx
  	  \RiffSig              = $46464952
	    \RiffCount            = SizeOf(WAVE_EX) + SoundDataSize
  	  \WaveSig              = $45564157
	    \fmtSig               = $20746D66
  	  \TWaveFormat          = SizeOf(WAVE)
 
  	  \w\wFormatTag		      =	#WAVE_FORMAT_PCM
  	  \w\nChannels        	=	1
  	  \w\nSamplesPerSec   	=	SampleRate
  	  \w\wBitsPerSample   	=	Bits
  	  \w\nBlockAlign      	=	(WaveFormatEx\w\nChannels * WaveFormatEx\w\wBitsPerSample) /8
  	  \w\nAvgBytesPerSec  	=	WaveFormatEx\w\nSamplesPerSec * WaveFormatEx\w\nBlockAlign
  	  \w\cbSize           	=	0
 
  	  \DataSig              = $61746164
	    \DataCount            = SoundDataSize
	  EndWith
 
  	WriteData(pFile, @WaveFormatEx, SizeOf(WAVE_EX))
 
  	WriteData(pFile, *SoundData, SoundDataSize)
 
  	CloseFile(pFile)
 
  	ProcedureReturn 1
  EndIf
EndProcedure
 
Procedure WAV_LoadSound(Filename.s, *Size.LONG, *Bits.LONG, *SampleRate.LONG)
  *Size\l = 0
 
  pFile = ReadFile(#PB_Any, Filename)
  If pFile
    WaveFormatEx.WAVE_EX
 
    ReadData(pFile, @WaveFormatEx, SizeOf(WAVE_EX))
 
    If WaveFormatEx\RiffSig = $46464952 And WaveFormatEx\WaveSig = $45564157 And WaveFormatEx\fmtSig = $20746D66 And WaveFormatEx\DataSig = $61746164
 
      SoundDataSize = WaveFormatEx\DataCount
      *Size\l       = SoundDataSize
      *SampleRate\l = WaveFormatEx\w\nSamplesPerSec
      *Bits\l       = WaveFormatEx\w\wBitsPerSample
      *SoundData = AllocateMemory(SoundDataSize)
      ReadData(pFile, *SoundData, SoundDataSize)
 
    EndIf
 
    CloseFile(pFile)
 
    ProcedureReturn *SoundData
  EndIf
EndProcedure
 
Procedure Rect(Value.d)
  Value = Sin(Value)*2
  Result = 0
  If Result = 0
    If Value > 0
      Result = 1
    Else
      Result = -1
    EndIf
  EndIf
  ProcedureReturn Result
EndProcedure
 
SampleRate = 11025
Global Dim SoundWaves.b(10000)
 
w = 2*#PI*500
For k=0 To 10000
  SoundWaves(k) = (127 + 127 * Sin(k * w / SampleRate))
Next
 
WAV_CreateSound("C:\test.wav", @SoundWaves(), 10000, 8, SampleRate)
 
Global Dim SoundWaves2.b(0)
SoundWaves2() = WAV_LoadSound("C:\test.wav", @Size.l, @Bits.l, @SR.l)
 
Debug Size
Debug Bits
Debug SR
Debug CompareMemory(@SoundWaves(), @SoundWaves2(), 10000)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP