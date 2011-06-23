; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1820&highlight=
; Author: Stefan (updated for PB 4.00 by Andre)
; Date: 27. January 2005
; OS: Windows
; Demo: Yes


; Extended sound commands
; Erweiterte Sound-Befehle

Structure DSBCAPS 
  dwSize.l 
  dwFlags.l 
  dwBufferBytes.l 
  dwUnlockTransferRate.l 
  dwPlayCpuOverhead.l 
EndStructure 


Procedure IsSoundPlaying(Sound);returns weather the Sound is playing or not. 
  Address=IsSound(Sound) 
  If Address=0:ProcedureReturn 0:EndIf 
  *DSB.IDirectSoundBuffer=PeekL(Address) 
  *DSB\GetStatus(@Status) 
  If Status=1 Or Status=5 
    ProcedureReturn 1 
  EndIf 
  ProcedureReturn 0 
EndProcedure 

Procedure GetSoundPosition(Sound);returns the current position of the Sound.(in bytes) 
  Address=IsSound(Sound) 
  If Address=0:ProcedureReturn 0:EndIf 
  *DSB.IDirectSoundBuffer=PeekL(Address) 
  *DSB\GetCurrentPosition(@Position,0) 
  ProcedureReturn Position 
EndProcedure 

Procedure SetSoundPosition(Sound,Position);sets the current position of the Sound.(in bytes) 
  Address=IsSound(Sound) 
  If Address=0:ProcedureReturn 0:EndIf 
  *DSB.IDirectSoundBuffer=PeekL(Address) 
  ProcedureReturn *DSB\SetCurrentPosition(Position) 
EndProcedure 

Procedure GetSoundSize(Sound);Returns the size of the Sound in bytes. 
  Address=IsSound(Sound) 
  If Address=0:ProcedureReturn 0:EndIf 
  *DSB.IDirectSoundBuffer=PeekL(Address) 
  Caps.DSBCAPS\dwSize=SizeOf(DSBCAPS) 
  *DSB\GetCaps(@Caps) 
  ProcedureReturn Caps\dwBufferBytes 
EndProcedure 




;Example: 
InitSound() 

File$=OpenFileRequester("Load wav-file","*.wav","wav-file |*.wav",0) 

Result=LoadSound(1,File$) 

If Result=0:MessageRequester("ERROR","Can't load sound."):End:EndIf 

OpenWindow(1,0,0,400,25,"Play",#PB_Window_MinimizeGadget|#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

PlaySound(1) 
Repeat 
  Event=WindowEvent() 
  
  SetWindowTitle(1,Str(GetSoundPosition(1))+"/"+Str(GetSoundSize(1))) 
Until Event=#PB_Event_CloseWindow Or IsSoundPlaying(1)=0 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -