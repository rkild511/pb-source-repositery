; English forum: http://www.purebasic.fr/english/viewtopic.php?t==14344&highlight=
; Author: Froggerprogger (updated for PB 4.00 by Andre)
; Date: 11. March 2005
; OS: Windows
; Demo: Yes


;- 11.03.05 by Froggerprogger 
;- For further information on the WAV-format look at: http://www.sonicspot.com/guide/wavefiles.html 

#samplerate = 44100                 ; samplerate 
#bitrate = 16                       ; Bits per sample, #bitrate Mod 8 must be 0 ! 
#channels = 2                       ; number of channels 
#totalsamples = 5*#samplerate       ; length in samples (here 5 seconds) 

#avBytesPerSec  = #channels*#bitrate/8*#samplerate  ; calculate the average bytes per second 
#datachunkBytes = #totalsamples * #channels * #bitrate/8 

Structure PBUnion 
  StructureUnion 
    b.b 
    w.w 
    l.l 
    f.f 
    s.s 
  EndStructureUnion 
EndStructure 

*sound.l = AllocateMemory(44 + #datachunkBytes) 

*mem.PBUnion = *sound 

*mem\l = 'FFIR'                 : *mem+4      ; riff-chunk-ID "RIFF" 
*mem\l = 36 + #datachunkBytes   : *mem+4      ; normally filesize minus (these) 8 Bytes 
*mem\l = 'EVAW'                 : *mem+4      ; wave-chunk-ID "WAVE" 
*mem\l = ' tmf'                 : *mem+4      ; format-chunk-ID "FMT " 
*mem\l = 16                     : *mem+4      ; chunk data size (+ Extra Format Bytes) 
*mem\w = 1                      : *mem+2      ; compression code 
*mem\w = #channels              : *mem+2      ; number of channels 
*mem\l = #samplerate            : *mem+4      ; samplerate 
*mem\l = #avBytesPerSec         : *mem+4      ; average bytes per second, (channels)*(block align)*(samplerate) 
*mem\w = #bitrate/8*#channels   : *mem+2      ; Block Align ('bytes per sample') 
*mem\w = #bitrate               : *mem+2      ; Bits per sample 
*mem\l = 'atad'                 : *mem+4      ; data-chunk-ID "DATA" 
*mem\l = #datachunkBytes        : *mem+4      ; data chunk size in byes 





;/ Now lets write #totalsamples of a 440Hz-sinus 
;/ work only for 16 Bit or more. 8-Bit has zero-line at value 128, so it is unsigned 

#fq = 440 
Global maxAmp.l : maxAmp = Pow(2, #bitrate-1)-1 

For acttime = 1 To #totalsamples 
  For actchannel = 1 To #channels 
    *mem\w = maxAmp * Sin(2 * #PI * #fq * acttime / #samplerate) 
    *mem+2 
  Next 
Next 


;/ catch and play the sound 
InitSound() 
CatchSound(0, *sound) 
PlaySound(0) 
Delay(5000) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -