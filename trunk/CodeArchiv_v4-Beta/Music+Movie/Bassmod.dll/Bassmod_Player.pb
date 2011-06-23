; English forum:
; Author: Kale (updated for PB4.00 by Andre)
; Date: 13. April 2003
; OS: Windows
; Demo: Yes


;===========================================================================
; BASSMOD CONSTANTS
;===========================================================================

#BASSTRUE = 1 ;Use this instead of VB Booleans
#BASSFALSE = 0 ;Use this instead of VB Booleans

;Error codes returned by BASSMOD_GetErrorCode()
#BASS_OK = 0 ;all is OK
#BASS_ERROR_MEM = 1 ;memory error
#BASS_ERROR_FILEOPEN = 2 ;can't open the file
#BASS_ERROR_DRIVER = 3 ;can't find a free/valid driver
#BASS_ERROR_HANDLE = 5 ;invalid handle
#BASS_ERROR_FORMAT = 6 ;unsupported format
#BASS_ERROR_POSITION = 7 ;invalid playback position
#BASS_ERROR_INIT = 8 ;BASS_Init has not been successfully called
#BASS_ERROR_ALREADY = 14 ;already initialized/loaded
#BASS_ERROR_NOPAUSE = 16 ;not paused
#BASS_ERROR_ILLTYPE = 19 ;an illegal type was specified
#BASS_ERROR_ILLPARAM = 20 ;an illegal parameter was specified
#BASS_ERROR_DEVICE = 23 ;illegal device number
#BASS_ERROR_NOPLAY = 24 ;not playing
#BASS_ERROR_NOMUSIC = 28 ;no MOD music has been loaded
#BASS_ERROR_NOSYNC = 30  ;synchronizers have been disabled
#BASS_ERROR_UNKNOWN = -1 ;some other mystery error

;Device setup flags
#BASS_DEVICE_DEFAULT = -1 ;use default sound device
#BASS_LOAD_FROMMEMORY = 1 ;load file from memory
#BASS_LOAD_FROMFILE = 0 ; load file from a file
#BASS_DEVICE_8BITS = 1 ;use 8 bit resolution, Else 16 bit
#BASS_DEVICE_MONO = 2 ;use mono, Else stereo
#BASS_DEVICE_NOSYNC = 16 ;disable synchronizers
#BASS_DEVICE_LEAVEVOL = 32 ;leave volume as it is

;Music flags

;Ramping doesn't take a lot of extra processing And improves
;the sound quality by removing "clicks". Sensitive ramping will
;leave sharp attacked samples, unlike normal ramping.
#BASS_MUSIC_RAMP = 1 ;normal ramping
#BASS_MUSIC_RAMPS = 2 ;sensitive ramping

#BASS_MUSIC_LOOP = 4 ;loop music
#BASS_MUSIC_FT2MOD = 16 ;play .MOD as FastTracker 2 does
#BASS_MUSIC_PT1MOD = 32 ;play .MOD as ProTracker 1 does
#BASS_MUSIC_POSRESET = 256 ;stop all notes when moving position
#BASS_MUSIC_SURROUND = 512 ;surround sound
#BASS_MUSIC_SURROUND2 = 1024 ;surround sound (mode 2)
#BASS_MUSIC_STOPBACK = 2048 ;stop the music on a backwards jump effect
#BASS_MUSIC_CALCLEN = 8192 ;calculate playback length
#BASS_MUSIC_NOSAMPLE = $400000 ;don't load the samples

;Sync types (with BASSMOD_MusicSetSync() "param" And SYNCPROC "data"
;definitions) & flags.
#BASS_SYNC_POS = 0
#BASS_SYNC_MUSICPOS = 0
;Sync when the music reaches a position.
;param: LOWORD=order (0=first, -1=all) HIWORD=row (0=first, -1=all)
;Data : LOWORD=order HIWORD=row
#BASS_SYNC_MUSICINST = 1
;Sync when an instrument (sample For the non-instrument based formats)
;is played in the music (not including retrigs).
;param: LOWORD=instrument (1=first) HIWORD=note (0=c0...119=b9, -1=all)
;Data : LOWORD=note HIWORD=volume (0-64)
#BASS_SYNC_END = 2
;Sync when the music reaches the end.
;param: not used
;Data : not used
#BASS_SYNC_MUSICFX = 3
;Sync when the "sync" effect (XM/MTM/MOD: E8x/Wxx, IT/S3M: S2x) is used.
;param: 0:data=pos, 1:data="x" value
;Data : param=0: LOWORD=order HIWORD=row, param=1: "x" value
#BASS_SYNC_ONETIME = 2147483648 ; FLAG: sync only once, Else continuously
;Sync callback function. NOTE: a sync callback function should be very
;quick (eg. just posting a message) as other syncs cannot be processed
;Until it has finished.
;handle : The sync that has occured
;Data   : Additional Data associated with the sync's occurance

argv.s=ProgramParameter()

If OpenLibrary(0, "bassmod.dll")

  CallFunction(0, "BASSMOD_Init" , #BASS_DEVICE_DEFAULT, 44010, #BASS_DEVICE_NOSYNC)
  CallFunction(0, "BASSMOD_MusicLoad", #BASS_LOAD_FROMFILE, argv, 0, 0, #BASS_MUSIC_RAMP)
  CallFunction(0, "BASSMOD_MusicLoad", #BASS_LOAD_FROMMEMORY, ?music, 0, 0, #BASS_MUSIC_RAMP) ; for binaries
  CallFunction(0, "BASSMOD_SetVolume", 70)
  CallFunction(0, "BASSMOD_MusicPlay")
  
  MessageRequester("PureBasic - Module player", "Playing module: "+Chr(10)+"-----------------------------------"+Chr(10)+GetFilePart(argv), 0)
  
  CallFunction(0, "BASSMOD_MusicStop")
  CloseLibrary(0)    

Else
  
  MessageRequester("Error","Could not open bassmod.dll!")
  
EndIf

End

music:
IncludeBinary"test.xm"

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -