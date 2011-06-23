; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14307&highlight=
; Author: Rescator (updated for PB 4.00 by Andre)
; Date: 07. March 2005
; OS: Windows
; Demo: Yes

; Need the bass.dll !

; Here's a quick'n'dirty include that I use whenever I use the BASS library. 
; (similar to FSOUND but personally I find BASS just as good or even a bit 
; easier.) 
;
; This is mostly wrappers and constants, nothing really fancy. 
; Warning! It's far from complete, but might save some typing for those 
; that would like to turn it into a PB lib/res. 


;- Error codes returned by BASS_GetErrorCode 
#BASS_OK   =         0   ; all is OK 
#BASS_ERROR_MEM   =   1   ; memory error 
#BASS_ERROR_FILEOPEN   =2   ; can't open the file 
#BASS_ERROR_DRIVER   =3   ; can't find a free/valid driver 
#BASS_ERROR_BUFLOST   =4   ; the sample buffer was lost 
#BASS_ERROR_HANDLE   =5   ; invalid handle 
#BASS_ERROR_FORMAT   =6   ; unsupported sample format 
#BASS_ERROR_POSITION   =7   ; invalid playback position 
#BASS_ERROR_INIT      =8   ; BASS_Init has not been successfully called 
#BASS_ERROR_START   =9   ; BASS_Start has not been successfully called 
#BASS_ERROR_ALREADY   =14   ; already initialized 
#BASS_ERROR_NOPAUSE   =16   ; not paused 
#BASS_ERROR_NOCHAN   =18   ; can't get a free channel 
#BASS_ERROR_ILLTYPE   =19   ;an illegal type was specified 
#BASS_ERROR_ILLPARAM   =20   ; an illegal parameter was specified 
#BASS_ERROR_NO3D      =21   ; no 3D support 
#BASS_ERROR_NOEAX   =22   ; no EAX support 
#BASS_ERROR_DEVICE   =23   ; illegal device number 
#BASS_ERROR_NOPLAY   =24   ; not playing 
#BASS_ERROR_FREQ      =25   ; illegal sample rate 
#BASS_ERROR_NOTFILE   =27   ; the stream is not a file stream 
#BASS_ERROR_NOHW      =29   ; no hardware voices available 
#BASS_ERROR_EMPTY   =31   ; the MOD music has no sequence Data 
#BASS_ERROR_NONET   =32   ; no internet connection could be opened 
#BASS_ERROR_CREATE   =33   ; couldn't create the file 
#BASS_ERROR_NOFX      =34   ;effects are not available 
#BASS_ERROR_PLAYING   =35   ; the channel is playing 
#BASS_ERROR_NOTAVAIL   =37   ; requested Data is not available 
#BASS_ERROR_DECODE   =38   ; the channel is a "decoding channel" 
#BASS_ERROR_DX      =39   ; a sufficient DirectX version is not installed 
#BASS_ERROR_TIMEOUT   =40   ; connection timedout 
#BASS_ERROR_FILEFORM   =41   ; unsupported file format 
#BASS_ERROR_SPEAKER   =42   ; unavailable speaker 
#BASS_ERROR_UNKNOWN   =-1   ; some other mystery error 

;- BASS Constants 
#BASS_MP3_SETPOS=$20000 ; enable pin-point seeking on the MP3/MP2/MP1 

#BASS_STREAM_AUTOFREE=$40000   ; automatically free the stream when it stop/ends 
#BASS_STREAM_RESTRATE=$80000   ; restrict the download rate of internet file streams 
#BASS_STREAM_BLOCK=$100000 ; download/play internet file stream in small blocks 
#BASS_STREAM_DECODE=$200000 ; don't play the stream, only decode (BASS_ChannelGetData) 
#BASS_STREAM_META=$400000 ; request metadata from a Shoutcast stream 
#BASS_STREAM_STATUS=$800000 ; give server status info (HTTP/ICY tags) in DOWNLOADPROC 

#BASS_SAMPLE_8BITS=1   ; 8 bit 
#BASS_SAMPLE_FLOAT=256   ; 32-bit floating-point 
#BASS_SAMPLE_MONO=2   ; mono, Else stereo 
#BASS_SAMPLE_LOOP=4   ; looped 
#BASS_SAMPLE_3D=8   ; 3D functionality enabled 
#BASS_SAMPLE_SOFTWARE=16   ; it's NOT using hardware mixing 
#BASS_SAMPLE_MUTEMAX=32   ; muted at max distance (3D only) 
#BASS_SAMPLE_VAM=64   ; uses the DX7 voice allocation & management 
#BASS_SAMPLE_FX=128   ; old implementation of DX8 effects are enabled 
#BASS_SAMPLE_OVER_VOL=$10000   ; override lowest volume 
#BASS_SAMPLE_OVER_POS=$20000   ; override longest playing 
#BASS_SAMPLE_OVER_DIST=$30000 ; override furthest from listener (3D only) 

#BASS_SPEAKER_FRONT=$1000000   ; front speakers 
#BASS_SPEAKER_REAR=$2000000   ; rear/side speakers 
#BASS_SPEAKER_CENLFE=$3000000   ; center & LFE speakers (5.1) 
#BASS_SPEAKER_REAR2=$4000000   ; rear center speakers (7.1) 
#BASS_SPEAKER_LEFT=$10000000   ; modifier: left 
#BASS_SPEAKER_RIGHT=$20000000   ; modifier: right 
#BASS_SPEAKER_FRONTLEFT=#BASS_SPEAKER_FRONT|#BASS_SPEAKER_LEFT 
#BASS_SPEAKER_FRONTRIGHT=#BASS_SPEAKER_FRONT|#BASS_SPEAKER_RIGHT 
#BASS_SPEAKER_REARLEFT=#BASS_SPEAKER_REAR|#BASS_SPEAKER_LEFT 
#BASS_SPEAKER_REARRIGHT=#BASS_SPEAKER_REAR|#BASS_SPEAKER_RIGHT 
#BASS_SPEAKER_CENTER   =#BASS_SPEAKER_CENLFE|#BASS_SPEAKER_LEFT 
#BASS_SPEAKER_LFE=#BASS_SPEAKER_CENLFE|#BASS_SPEAKER_RIGHT 
#BASS_SPEAKER_REAR2LEFT=#BASS_SPEAKER_REAR2|#BASS_SPEAKER_LEFT 
#BASS_SPEAKER_REAR2RIGHT=#BASS_SPEAKER_REAR2|#BASS_SPEAKER_RIGHT 

#BASS_UNICODE=$80000000 

#BASS_SYNC_MUSICPOS=0 
#BASS_SYNC_POS=0 
#BASS_SYNC_MUSICINST=1 
#BASS_SYNC_END=2 
#BASS_SYNC_MUSICFX=3 
#BASS_SYNC_META=4 
#BASS_SYNC_SLIDE=5 
#BASS_SYNC_STALL=6 
#BASS_SYNC_DOWNLOAD=7 
#BASS_SYNC_FREE=8 
#BASS_SYNC_MESSAGE=$20000000 
#BASS_SYNC_MIXTIME=$40000000 
#BASS_SYNC_ONETIME=$80000000 

#BASS_CONFIG_BUFFER=0 
#BASS_CONFIG_UPDATEPERIOD=1 
#BASS_CONFIG_MAXVOL=3 
#BASS_CONFIG_GVOL_SAMPLE=4 
#BASS_CONFIG_GVOL_STREAM=5 
#BASS_CONFIG_GVOL_MUSIC=6 
#BASS_CONFIG_CURVE_VOL=7 
#BASS_CONFIG_CURVE_PAN=8 
#BASS_CONFIG_FLOATDSP=9 
#BASS_CONFIG_3DALGORITHM=10 
#BASS_CONFIG_NET_TIMEOUT=11 
#BASS_CONFIG_NET_BUFFER=12 
#BASS_CONFIG_PAUSE_NOPLAY=13 
#BASS_CONFIG_NET_NOPROXY=14 

#BASS_ACTIVE_STOPPED=0 
#BASS_ACTIVE_PLAYING=1 
#BASS_ACTIVE_STALLED=2 
#BASS_ACTIVE_PAUSED=3 

#BASS_FILEPOS_DECODE=0 
#BASS_FILEPOS_DOWNLOAD=1 
#BASS_FILEPOS_END=2 
#BASS_FILEPOS_START=3 

;- Bass Globals 
Structure BASS_CHANNELINFO 
 freq.l 
 chans.l 
 flags.l 
 ctype.l 
 origres.l 
EndStructure 

Structure BASS_VERSION 
 ver.w 
 rev.w 
EndStructure 

Global bassdll.l 

;- Procedures 

Procedure.l BASS_OpenDLL() 
bassdll=OpenLibrary(#PB_Any,"bass.dll") 
ProcedureReturn bassdll 
EndProcedure 

Procedure.l BASS_CloseDLL() 
If bassdll 
 CallFunction(bassdll,"BASS_Free") 
 CloseLibrary(bassdll) 
 bassdll=0 
EndIf 
EndProcedure 

Procedure.l BASS_GetVersion() 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_GetVersion") 
EndIf 
EndProcedure 

Procedure.l BASS_CheckVersion(ver.l,rev.l) 
version.BASS_VERSION 
PokeL(@version,BASS_GetVersion()) 
If version/ver=ver ; if version match 
 If version/rev>=rev ; if revision match or higher 
  Result.l=#True 
 Else ; revision was lower 
  Result.l=#False 
 EndIf 
Else ; version was lower 
 Result.l=#False 
EndIf 
ProcedureReturn Result 
EndProcedure 

Procedure.l BASS_SetConfig(option.l,value.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_SetConfig",option,value) 
EndIf 
EndProcedure 

Procedure.l BASS_GetConfig(option.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_GetConfig",option) 
EndIf 
EndProcedure 

Procedure.l BASS_Init(device.l,freq.l,flags.l,window.l,guid.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_Init",device,freq,flags,window,guid) 
EndIf 
EndProcedure 

Procedure.l BASS_ChannelGetInfo(handle.l,*chaninfo) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_ChannelGetInfo",handle,*chaninfo) 
EndIf 
EndProcedure 

Procedure.l BASS_StreamGetFilePosition(handle.l,mode.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_StreamGetFilePosition",handle,mode) 
EndIf 
EndProcedure 

Procedure.l BASS_ChannelSetPosition(handle.l,position.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_ChannelSetPosition",handle,position,0) 
EndIf 
EndProcedure 

Procedure.l BASS_ChannelIsActive(handle.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_ChannelIsActive",handle) 
EndIf 
EndProcedure 

Procedure.l BASS_ChannelGetData(handle.l,buffer.l,length.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_ChannelGetData",handle,buffer.l,length.l) 
EndIf 
EndProcedure 

Procedure.l BASS_StreamCreateFile(mem.b,file$,offset.l,length.l,flags.l) 
If bassdll 
 ProcedureReturn CallFunction(bassdll,"BASS_StreamCreateFile",mem,file$,offset,length,flags) 
EndIf 
EndProcedure 
  
Procedure.l BASS_StreamFree(handle.l) 
If bassdll 
 CallFunction(bassdll,"BASS_StreamFree",handle) 
EndIf 
EndProcedure 

Procedure.s BASS_ErrorGetText() 
Protected errortxt.s 
If bassdll 
 errorcode.l=CallFunction(bassdll,"BASS_ErrorGetCode") 
 Select errorcode 
  Case #BASS_OK : errortxt="OK" 
  Case #BASS_ERROR_MEM :   errortxt="Memory error" 
  Case #BASS_ERROR_FILEOPEN    : errortxt="Can't open the file" 
  Case #BASS_ERROR_DRIVER    : errortxt="Can't find a free/valid driver" 
  Case #BASS_ERROR_BUFLOST : errortxt="The sample buffer was lost" 
  Case #BASS_ERROR_HANDLE : errortxt="Invalid handle" 
  Case #BASS_ERROR_FORMAT : errortxt="Unsupported sample format" 
  Case #BASS_ERROR_POSITION : errortxt="Invalid playback position" 
  Case #BASS_ERROR_INIT : errortxt="BASS_Init has not been successfully called" 
  Case #BASS_ERROR_START : errortxt="BASS_Start has not been successfully called" 
  Case #BASS_ERROR_ALREADY : errortxt="Already initialized" 
  Case #BASS_ERROR_NOPAUSE : errortxt="Not paused" 
  Case #BASS_ERROR_NOCHAN : errortxt="Can't get a free channel" 
  Case #BASS_ERROR_ILLTYPE : errortxt="An illegal type was specified" 
  Case #BASS_ERROR_ILLPARAM : errortxt="An illegal parameter was specified" 
  Case #BASS_ERROR_NO3D : errortxt="No 3D support" 
  Case #BASS_ERROR_NOEAX : errortxt="No EAX support" 
  Case #BASS_ERROR_DEVICE : errortxt="Illegal device number" 
  Case #BASS_ERROR_NOPLAY : errortxt="Not playing" 
  Case #BASS_ERROR_FREQ : errortxt="Illegal sample rate" 
  Case #BASS_ERROR_NOTFILE : errortxt="The stream is not a file stream" 
  Case #BASS_ERROR_NOHW : errortxt="No hardware voices available" 
  Case #BASS_ERROR_EMPTY    : errortxt="The MOD music has no sequence Data" 
  Case #BASS_ERROR_NONET : errortxt="No internet connection could be opened" 
  Case #BASS_ERROR_CREATE : errortxt="Couldn't create the file" 
  Case #BASS_ERROR_NOFX : errortxt="Effects are not available" 
  Case #BASS_ERROR_PLAYING : errortxt="The channel is playing" 
  Case #BASS_ERROR_NOTAVAIL : errortxt="Requested Data is not available" 
  Case #BASS_ERROR_DECODE : errortxt="The channel is a decoding channel" 
  Case #BASS_ERROR_DX : errortxt="A sufficient DirectX version is not installed" 
  Case #BASS_ERROR_TIMEOUT : errortxt="Connection timedout" 
  Case #BASS_ERROR_FILEFORM : errortxt="Unsupported file format" 
  Case #BASS_ERROR_SPEAKER : errortxt="Unavailable speaker" 
  Case #BASS_ERROR_UNKNOWN : errortxt="Some other mystery error" 
 EndSelect 
EndIf 
ProcedureReturn errortxt 
EndProcedure  

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ---