; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14289&highlight=
; Author: chippy73 (updated for PB 4.00 by Andre)
; Date: 23. March 2005
; OS: Windows
; Demo: Yes


; Change the sampling speed of the soundcard
If Not OpenLibrary(1,"winmm.dll")
  Debug "winmm.dll couldn't be opened!"
  End
EndIf

Structure WAVEFORMATEX
  wFormatTag.w
  nChannels.w
  nSamplesPerSec.l
  nAvgBytesPerSec.l
  nBlockAlign.w
  wBitsPerSample.w
  cbSize.w
EndStructure

Global waveheader1.WAVEHDR
Global waveform.WAVEFORMATEX

Procedure changesample(sample$)
  waveform\wFormatTag = #WAVE_FORMAT_PCM
  waveform\nChannels = 1
  waveform\nSamplesPerSec = Val(sample$)
  waveform\wBitsPerSample = 8
  waveform\nBlockAlign = waveform\nChannels * waveform\wBitsPerSample / 8
  waveform\nAvgBytesPerSec = waveform\nSamplesPerSec * waveform\nBlockAlign
  waveform\cbSize=0

  dwRet.l=CallFunction(1,"waveInOpen",@wavehandle, #WAVE_MAPPER, @waveform,0,0,0)
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -