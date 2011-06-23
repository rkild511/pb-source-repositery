; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3294&start=10
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 17. January 2004
; OS: Windows
; Demo: Yes

;- example of how to do CatchSound with the fmod 3.7x-import 
;- you have to specify a soundfile (*.mp3, *.wav, etc.) at the end of this code 
;- by Froggerprogger 17.01.04 

Structure StringLong 
  StructureUnion 
    string.s 
    long.l 
  EndStructureUnion 
EndStructure 

Global Songdata.StringLong 

If FSOUND_Init(44100, 32, 0) = #False : End : EndIf 
If FSOUND_GetVersion() < 3.71 : End : EndIf 

OpenWindow(0, 0, 0, 400, 200, "FMOD-Sample with #FSOUND_LOADMEMORY", #PB_Window_ScreenCentered|#PB_Window_SystemMenu) 

Songdata\long = ?mySongStart 

*sample = FSOUND_Sample_Load(0, Songdata\string, #FSOUND_LOADMEMORY, 0, ?mySongEnd-?mySongStart) 
FSOUND_PlaySound(#FSOUND_FREE, *sample) 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 

FSOUND_StopSound(#FSOUND_ALL) 
FSOUND_Close() 

End 

mySongStart: 
IncludeBinary "test.mp3" ; specify your own filename here 
mySongEnd:


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
