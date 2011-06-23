; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8404&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 19. November 2003
; OS: Windows
; Demo: No

Global buffer$ 
buffer$=Space(256) 

Procedure MCI(command.s) 
  result=mciSendString_(command,@buffer$,256,0) 
  ProcedureReturn result 
EndProcedure 

clip.s="Test.wav"      ;file to save to disk 
alignment=4 
bits=16                   ;16bit wave file 
channels=2                ;1=mono 2=stero 
samples=44100             ;44.1kHz sample rate 

If OpenWindow(0,10,200,300,200,"Record Audio",#PB_Window_SystemMenu)=0:End:EndIf 

If CreateGadgetList(WindowID(0))=0:End:EndIf 
TextGadget(0,100,100,100,40,"Recording") 

MCI("open new type waveaudio alias recsound") 
MCI("set recsound time format ms") 
MCI("set recsound alignment "+Str(alignment)+" bitspersample "+Str(bits)+" samplespersec "+Str(samples)+" channels "+Str(channels)+" bytespersec "+Str(samples*alignment) ) 
MCI("record recsound") 
Structure MIDIDATA 
  Channel.b 
  Note.b 
  Velocity.b 
  Null.b 
EndStructure 

midi.MIDIOUTCAPS 
devices=midiOutGetNumDevs_() 
For devnum=-1 To devices-1 
  If midiOutGetDevCaps_(devnum,@midi,SizeOf(MIDIOUTCAPS))=0 
    If midi\wVoices>0 : midiport=devnum :EndIf 
  EndIf 
Next 

*hMidiOut.l 
midiOutOpen_(@hMidiOut,midiport,0,0,0) 

Note.b=48 
Vel.b=127 
Channel.b=1 
Instrument.b=1  ;(1=Piano) 

dMsg.MIDIDATA\Note=Instrument 
dMsg\Channel=$BF+Channel 
result=midiOutShortMsg_(hMidiOut,PeekW(dMsg)) 

For x=1 To 30 
  dMsg\Velocity=Vel 
  dMsg\Note=Note 
  dMsg\Channel=$8F+Channel 
  result=midiOutShortMsg_(hMidiOut,PeekL(dMsg)) 
  Delay(100) 
  dMsg\Velocity=Vel 
  dMsg\Note=Note 
  dMsg\Channel=$7F+Channel 
  result=midiOutShortMsg_(hMidiOut,PeekL(dMsg)) 
  Note+2 
Next 

Delay(30) 

MCI("save recsound "+clip) 
MCI("close recsound") 
midiOutClose_(hMidiOut) 
SetGadgetText(0,"Wav file saved "+clip) 
MessageRequester("Done","",0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
