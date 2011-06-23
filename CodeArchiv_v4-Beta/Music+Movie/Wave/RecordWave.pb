; www.purearea.net (Sourcecode collection by cnesm)
; Author: Unknown
; Date: 29. October 2003
; OS: Windows
; Demo: No

Procedure RecordWav(filename$,ms) 
  buffer$=Space(128) : DeleteFile_(filename$) 
  mciSendString_("open new type waveaudio alias capture",buffer$,128,0) 
  mciSendString_("set capture samplesperbuffer 8000 bytesperbuffer 8000",0,0,0) 
  mciSendString_("record capture",buffer$,128,0) 
  Sleep_(ms) ; Wait for specified capture time to end. 
  mciSendString_("save capture "+filename$,buffer$,128,0) 
EndProcedure 
; 
MessageRequester("Info","Click OK to capture audio to c:\test.wav for 2 secs",0) 

RecordWav("c:\test.wav",2000) 
MessageRequester("Info","Done!",0) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -