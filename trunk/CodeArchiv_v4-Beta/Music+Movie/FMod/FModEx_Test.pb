; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11370&highlight=
; Author: Froggerprogger
; Date: 02. January 2007
; OS: Windows
; Demo: No



;/ FMODEX-include for fmodex 4.06.01

;- SimplePlay with fmodex-include 

IncludeFile "fmodex.pb" 

If Not Init_FMOD() 
  MessageRequester("Error", "FModEx dll not found!")
  End
EndIf

FMOD_System_Create(@fmodsystem) 
FMOD_System_Init(fmodsystem, 32, 0, 0) 

str.s = OpenFileRequester("Choose a soundfile", GetClipboardText(), "*.*|*.*", 0) 
If str = "" : End : Else : SetClipboardText(str) : EndIf 

FMOD_System_CreateStream(fmodsystem, @str, #FMOD_SOFTWARE, 0, @sound) 
FMOD_System_PlaySound(fmodsystem, 0, sound, 0, @channel) 

Dim Arr.f(512) 

Repeat 
  FMOD_Channel_GetPosition(channel, @pos, #FMOD_TIMEUNIT_MS) 
  FMOD_Channel_IsPlaying(channel, @isPlaying) 
  FMOD_Channel_GetSpectrum(channel, Arr(), 512, 0, 0) 
  
  Debug "--------------------" 
  Debug "isPlaying: " + Str(isPlaying) 
  Debug "position: " + Str(pos) 
  Debug "spectrum: " + StrF(Arr(0),4) + "  " + StrF(Arr(1),4) + "  " +  StrF(Arr(2),4) + "  " +  StrF(Arr(3),4) + "  ..." 

  Delay(250) 
Until pos > 10000 Or isPlaying = #False 

FMOD_System_Release(fmodsystem) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP