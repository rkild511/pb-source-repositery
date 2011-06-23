; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7431
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 04. September 2003
; OS: Windows
; Demo: Yes
 
; Creates a .wav testfile with a sinus tone

;-  04.09.03 by Froggerprogger 
;-  04.09.03 by Froggerprogger 
;- 
;-  Tip: You can replace the byte-text-output with the following: 
;- 
;-  WriteLong($46464952) = "RIFF" 
;-  WriteLong($45564157) = "WAVE" 
;-  WriteLong($20746D66) = "fmt " 
;- 
;-  You can even use WriteString("RIFF") and WriteString("WAVEfmt "), because PB doesn't write a 
;-  terminating 0 - but I don't like this way, perhaps it's too easy ;-) 
;- 
;- For further information on the WAV-format look at: http://www.sonicspot.com/guide/wavefiles.html 

#fq = 220                           ; frequenz in Hz for sinustone 
#samplerate = 44100                 ; samplerate 
#bitrate = 16                       ; Bits per sample, #bitrate Mod 8 must be 0 ! 
#channels = 2                       ; number of channels 
#secs = 4                           ; time for the sinustone in seconds 
#soundfilename = "wavtest.wav"      ; filename for the soundfile 

avBytesPerSec.l = #channels*#bitrate/8*#samplerate  ; calculate the average bytes per second 

CreateFile(0, #soundfilename) 
  WriteByte(0,Asc("R"))               ; here you can use WriteLong($46464952) instead - see the tip on top 
  WriteByte(0,Asc("I")) 
  WriteByte(0,Asc("F")) 
  WriteByte(0,Asc("F")) 
  WriteLong(0,36+avBytesPerSec*#secs) ; normally filesize - 8 Bytes, here a bit tricky, fmt-chunk + data-chunk 

  WriteByte(0,Asc("W")) 
  WriteByte(0,Asc("A")) 
  WriteByte(0,Asc("V")) 
  WriteByte(0,Asc("E")) 
  
  WriteByte(0,Asc("f")) 
  WriteByte(0,Asc("m")) 
  WriteByte(0,Asc("t")) 
  WriteByte(0,Asc(" ")) 
  WriteLong(0,16)                     ; chunk data size 

  WriteWord(0,1)                      ; compression code 
  WriteWord(0,#channels)              ; number of channels 
  WriteLong(0,#samplerate)            ; samplerate 
  WriteLong(0,avBytesPerSec)          ; average bytes per second, here 2(channels)*2(block align)*44100(samplerate) 
  WriteWord(0,#bitrate/8*#channels)   ; Block Align ('bytes per sample') 
  WriteWord(0,#bitrate)               ; Bits per sample 
  WriteByte(0,Asc("d")) 
  WriteByte(0,Asc("a")) 
  WriteByte(0,Asc("t")) 
  WriteByte(0,Asc("a")) 
  WriteLong(0,avBytesPerSec*#secs)    ; data chunk size in byes 

  Global  actsamplevalue.w         ; for signed RAW data 
  
  For acttime = 1 To #samplerate * #secs 
    For actchannel = 1 To #channels 
        actsamplevalue = 32767 * Sin(2 * #PI * #fq * acttime / #samplerate) 
        WriteWord(0,actsamplevalue) 
    Next 
  Next 
CloseFile(0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
