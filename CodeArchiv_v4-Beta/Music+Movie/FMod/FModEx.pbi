; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11370&highlight=
; Author: Froggerprogger
; Date: 02. January 2007
; OS: Windows
; Demo: No



;/ FMODEX-include for fmodex 4.06.01
;/ (it should work for later version with unchanged API, too)
;/
;/ by Froggerprogger, 02.01.2007
;/ for contact see the PB-forums at http://www.purebasic.fr/english/



;-#############################
;-############################# from fmod_dsp
;-#############################

Structure FMOD_DSP
  userdata.l     ; '[in]'[out] User created data the dsp plugin writer wants to attach to this object. 
EndStructure

Enumeration ; FMOD_DSP_TYPE
  #FMOD_DSP_TYPE_UNKNOWN            ; This unit was created via a non FMOD plugin so has an unknown purpose. 
  #FMOD_DSP_TYPE_MIXER              ; This unit does nothing but take inputs and mix them together then feed the result to the soundcard unit. 
  #FMOD_DSP_TYPE_OSCILLATOR         ; This unit generates sine/square/saw/triangle or noise tones. 
  #FMOD_DSP_TYPE_LOWPASS            ; This unit filters sound using a high quality, resonant lowpass filter algorithm but consumes more CPU time. 
  #FMOD_DSP_TYPE_ITLOWPASS          ; This unit filters sound using a resonant lowpass filter algorithm that is used in Impulse Tracker, but with limited cutoff range (0 to 8060hz). 
  #FMOD_DSP_TYPE_HIGHPASS           ; This unit filters sound using a resonant highpass filter algorithm. 
  #FMOD_DSP_TYPE_ECHO               ; This unit produces an echo on the sound and fades out at the desired rate. 
  #FMOD_DSP_TYPE_FLANGE             ; This unit produces a flange effect on the sound. 
  #FMOD_DSP_TYPE_DISTORTION         ; This unit distorts the sound. 
  #FMOD_DSP_TYPE_NORMALIZE          ; This unit normalizes or amplifies the sound to a certain level. 
  #FMOD_DSP_TYPE_PARAMEQ            ; This unit attenuates or amplifies a selected frequency range. 
  #FMOD_DSP_TYPE_PITCHSHIFT         ; This unit bends the pitch of a sound without changing the speed of playback. 
  #FMOD_DSP_TYPE_CHORUS             ; This unit produces a chorus effect on the sound. 
  #FMOD_DSP_TYPE_REVERB             ; This unit produces a reverb effect on the sound. 
  #FMOD_DSP_TYPE_VSTPLUGIN          ; This unit allows the use of Steinberg VST plugins 
  #FMOD_DSP_TYPE_WINAMPPLUGIN       ; This unit allows the use of Nullsoft Winamp plugins 
  #FMOD_DSP_TYPE_ITECHO             ; This unit produces an echo on the sound and fades out at the desired rate as is used in Impulse Tracker. 
  #FMOD_DSP_TYPE_COMPRESSOR         ; This unit implements dynamic compression (linked multichannel, wideband) 
  #FMOD_DSP_TYPE_SFXREVERB          ; This unit implements SFX reverb 
  #FMOD_DSP_TYPE_LOWPASS_SIMPLE     ; This unit filters sound using a simple lowpass with no resonance, but has flexible cutoff and is fast. 
EndEnumeration

Structure FMOD_DSP_PARAMETERDESC
  min.f                                 ; [in] Minimum value of the parameter (ie 100.0). 
  max.f                                 ; [in] Maximum value of the parameter (ie 22050.0). 
  defaultval.f                          ; [in] Default value of parameter. 
  name.s                                ; [in] Name of the parameter to be displayed (ie "Cutoff frequency"). 
  label.s                               ; [in] Short string to be put next to value to denote the unit type (ie "hz"). 
  description.s                         ; [in] Description of the parameter to be displayed as a help item / tooltip for this parameter. 
EndStructure

Enumeration ; FMOD_DSP_OSCILLATOR
  #FMOD_DSP_OSCILLATOR_TYPE    ; Waveform type.  0 = sine.  1 = square. 2 = sawup. 3 = sawdown. 4 = triangle. 5 = noise.  
  #FMOD_DSP_OSCILLATOR_RATE    ; Frequency of the sinewave in hz.  1.0 to 22000.0.  Default = 220.0. 
EndEnumeration

Enumeration ; FMOD_DSP_LOWPASS
  #FMOD_DSP_LOWPASS_CUTOFF     ; Lowpass cutoff frequency in hz.   1.0 to 22000.0.  Default = 5000.0. 
  #FMOD_DSP_LOWPASS_RESONANCE  ; Lowpass resonance Q value. 1.0 to 10.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_ITLOWPASS
  #FMOD_DSP_ITLOWPASS_CUTOFF     ; Lowpass cutoff frequency in hz.  1.0 to 22000.0.  Default = 5000.0/ 
  #FMOD_DSP_ITLOWPASS_RESONANCE  ; Lowpass resonance Q value.  0.0 to 127.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_HIGHPASS
  #FMOD_DSP_HIGHPASS_CUTOFF     ; Highpass cutoff frequency in hz.  10.0 to output 22000.0.  Default = 5000.0. 
  #FMOD_DSP_HIGHPASS_RESONANCE  ; Highpass resonance Q value.  1.0 to 10.0.  Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_ECHO
  #FMOD_DSP_ECHO_DELAY        ; Echo delay in ms.  10  to 5000.  Default = 500. 
  #FMOD_DSP_ECHO_DECAYRATIO   ; Echo decay per delay.  0 to 1.  1.0 = No decay, 0.0 = total decay.  Default = 0.5. 
  #FMOD_DSP_ECHO_MAXCHANNELS  ; Maximum channels supported.  0 to 16.  0 = same as fmod's default output polyphony, 1 = mono, 2 = stereo etc.  See remarks for more.  Default = 0.  It is suggested to leave at 0! 
  #FMOD_DSP_ECHO_DRYMIX       ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 1.0. 
  #FMOD_DSP_ECHO_WETMIX       ; Volume of echo signal to pass to output.  0.0 to 1.0. Default = 1.0. 
EndEnumeration

Enumeration ; FMOD_DSP_FLANGE
  #FMOD_DSP_FLANGE_DRYMIX      ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 0.45. 
  #FMOD_DSP_FLANGE_WETMIX      ; Volume of flange signal to pass to output.  0.0 to 1.0. Default = 0.55. 
  #FMOD_DSP_FLANGE_DEPTH       ; Flange depth.  0.01 to 1.0.  Default = 1.0. 
  #FMOD_DSP_FLANGE_RATE        ; Flange speed in hz.  0.0 to 20.0.  Default = 0.1. 
EndEnumeration

Enumeration ; FMOD_DSP_DISTORTION
  #FMOD_DSP_DISTORTION_LEVEL    ; Distortion value.  0.0 to 1.0.  Default = 0.5. 
EndEnumeration

Enumeration ; FMOD_DSP_NORMALIZE
  #FMOD_DSP_NORMALIZE_FADETIME     ; Time to ramp the silence to full in ms.  0.0 to 20000.0. Default = 5000.0. 
  #FMOD_DSP_NORMALIZE_THRESHHOLD   ; Lower volume range threshold to ignore.  0.0 to 1.0.  Default = 0.1.  Raise higher to stop amplification of very quiet signals. 
  #FMOD_DSP_NORMALIZE_MAXAMP       ; Maximum amplification allowed.  1.0 to 100000.0.  Default = 20.0.  1.0 = no amplifaction, higher values allow more boost. 
EndEnumeration

Enumeration ; FMOD_DSP_PARAMEQ
  #FMOD_DSP_PARAMEQ_CENTER      ; Frequency center.  20.0 to 22000.0.  Default = 8000.0. 
  #FMOD_DSP_PARAMEQ_BANDWIDTH   ; Octave range around the center frequency to filter.  0.2 to 5.0.  Default = 1.0. 
  #FMOD_DSP_PARAMEQ_GAIN        ; Frequency Gain.  0.05 to 3.0.  Default = 1.0.  
EndEnumeration

Enumeration ; FMOD_DSP_PITCHSHIFT
  #FMOD_DSP_PITCHSHIFT_PITCH        ; Pitch value.  0.5 to 2.0.  Default = 1.0. 0.5 = one octave down, 2.0 = one octave up.  1.0 does not change the pitch. 
  #FMOD_DSP_PITCHSHIFT_FFTSIZE      ; FFT window size.  256, 512, 1024, 2048, 4096.  Default = 1024.  Increase this to reduce 'smearing'.  This effect is a warbling sound similar to when an mp3 is encoded at very low bitrates. 
  #FMOD_DSP_PITCHSHIFT_OVERLAP      ; Window overlap.  1 to 32.  Default = 4.  Increase this to reduce 'tremolo' effect.  Increasing it by a factor of 2 doubles the CPU usage. 
  #FMOD_DSP_PITCHSHIFT_MAXCHANNELS  ; Maximum channels supported.  0 to 16.  0 = same as fmod's default output polyphony, 1 = mono, 2 = stereo etc.  See remarks for more.  Default = 0.  It is suggested to leave at 0! 
EndEnumeration

Enumeration ; FMOD_DSP_CHORUS
  #FMOD_DSP_CHORUS_DRYMIX    ; Volume of original signal to pass to output.  0.0 to 1.0. Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX1   ; Volume of 1st chorus tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX2   ; Volume of 2nd chorus tap. This tap is 90 degrees out of phase of the first tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_WETMIX3   ; Volume of 3rd chorus tap. This tap is 90 degrees out of phase of the second tap.  0.0 to 1.0.  Default = 0.5. 
  #FMOD_DSP_CHORUS_DELAY     ; Chorus delay in ms.  0.1 to 100.0.  Default = 40.0 ms. 
  #FMOD_DSP_CHORUS_RATE      ; Chorus modulation rate in hz.  0.0 to 20.0.  Default = 0.8 hz. 
  #FMOD_DSP_CHORUS_DEPTH     ; Chorus modulation depth.  0.0 to 1.0.  Default = 0.03. 
  #FMOD_DSP_CHORUS_FEEDBACK  ; Chorus feedback.  Controls how much of the wet signal gets fed back into the chorus buffer.  0.0 to 1.0.  Default = 0.0. 
EndEnumeration

Enumeration ; FMOD_DSP_REVERB
  #FMOD_DSP_REVERB_ROOMSIZE  ; Roomsize. 0.0 to 1.0.  Default = 0.5 
  #FMOD_DSP_REVERB_DAMP      ; Damp.     0.0 to 1.0.  Default = 0.5 
  #FMOD_DSP_REVERB_WETMIX    ; Wet mix.  0.0 to 1.0.  Default = 0.33 
  #FMOD_DSP_REVERB_DRYMIX    ; Dry mix.  0.0 to 1.0.  Default = 0.0 
  #FMOD_DSP_REVERB_WIDTH     ; Width.    0.0 to 1.0.  Default = 1.0 
  #FMOD_DSP_REVERB_MODE      ; Mode.     0 (normal), 1 (freeze).  Default = 0 
EndEnumeration

Enumeration ; FMOD_DSP_ITECHO
  #FMOD_DSP_ITECHO_WETDRYMIX      ; Ratio of wet (processed) signal to dry (unprocessed) signal. Must be in the range from 0.0 through 100.0 (all wet). The default value is 50. 
  #FMOD_DSP_ITECHO_FEEDBACK       ; Percentage of output fed back into input, in the range from 0.0 through 100.0. The default value is 50. 
  #FMOD_DSP_ITECHO_LEFTDELAY      ; Delay for left channel, in milliseconds, in the range from 1.0 through 2000.0. The default value is 500 ms. 
  #FMOD_DSP_ITECHO_RIGHTDELAY     ; Delay for right channel, in milliseconds, in the range from 1.0 through 2000.0. The default value is 500 ms. 
  #FMOD_DSP_ITECHO_PANDELAY       ; Value that specifies whether to swap left and right delays with each successive echo. The default value is zero, meaning no swap. Possible values are defined as 0.0 (equivalent to FALSE) and 1.0 (equivalent to TRUE). 
EndEnumeration

Enumeration ; FMOD_DSP_COMPRESSOR
  #FMOD_DSP_COMPRESSOR_THRESHOLD   ; Threshold level (dB)in the range from -60 through 0. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_ATTACK      ; Gain reduction attack time (milliseconds), in the range from 10 through 200. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_RELEASE     ; Gain reduction release time (milliseconds), in the range from 20 through 1000. The default value is 50. 
  #FMOD_DSP_COMPRESSOR_GAINMAKEUP  ; Make-up gain applied after limiting, in the range from 0.0 through 100.0. The default value is 50. 
EndEnumeration

Enumeration ; FMOD_DSP_SFXREVERB
  #FMOD_DSP_SFXREVERB_DRYLEVEL             ; Dry Level      : Mix level of dry signal in output in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOM                 ; Room           : Room effect level at low frequencies in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOMHF               ; Room HF        : Room effect high-frequency level re. low frequency level in mB.  Ranges from -10000.0 to 0.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_ROOMROLLOFFFACTOR    ; Room Rolloff   : Like DS3D flRolloffFactor but for room effect.  Ranges from 0.0 to 10.0. Default is 10.0 
  #FMOD_DSP_SFXREVERB_DECAYTIME            ; Decay Time     : Reverberation decay time at low-frequencies in seconds.  Ranges from 0.1 to 20.0. Default is 1.0. 
  #FMOD_DSP_SFXREVERB_DECAYHFRATIO         ; Decay HF Ratio : High-frequency to low-frequency decay time ratio.  Ranges from 0.1 to 2.0. Default is 0.5. 
  #FMOD_DSP_SFXREVERB_REFLECTIONSLEVEL     ; Reflections    : Early reflections level relative to room effect in mB.  Ranges from -10000.0 to 1000.0.  Default is -10000.0. 
  #FMOD_DSP_SFXREVERB_REFLECTIONSDELAY     ; Reflect Delay  : Delay time of first reflection in seconds.  Ranges from 0.0 to 0.3.  Default is 0.02. 
  #FMOD_DSP_SFXREVERB_REVERBLEVEL          ; Reverb         : Late reverberation level relative to room effect in mB.  Ranges from -10000.0 to 2000.0.  Default is 0.0. 
  #FMOD_DSP_SFXREVERB_REVERBDELAY          ; Reverb Delay   : Late reverberation delay time relative to first reflection in seconds.  Ranges from 0.0 to 0.1.  Default is 0.04. 
  #FMOD_DSP_SFXREVERB_DIFFUSION            ; Diffusion      : Reverberation diffusion (echo density) in percent.  Ranges from 0.0 to 100.0.  Default is 100.0. 
  #FMOD_DSP_SFXREVERB_DENSITY              ; Density        : Reverberation density (modal density) in percent.  Ranges from 0.0 to 100.0.  Default is 100.0. 
  #FMOD_DSP_SFXREVERB_HFREFERENCE          ; HF Reference   : Reference high frequency in Hz.  Ranges from 20.0 to 20000.0. Default is 5000.0. 
EndEnumeration

Enumeration ; FMOD_DSP_LOWPASS_SIMPLE
  #FMOD_DSP_LOWPASS_SIMPLE_CUTOFF     ; Lowpass cutoff frequency in hz.  10.0 to 22000.0.  Default = 5000.0 
EndEnumeration




;-#############################
;-############################# from fmodex
;-#############################

Global fmodLib.l
Procedure Init_FMOD()
  fmodLib = OpenLibrary(#PB_Any, "fmodex.dll")
  ProcedureReturn IsLibrary(fmodLib)
EndProcedure

#FMOD_VERSION  = $40601

Structure FMOD_VECTOR
  x.f 
  y.f 
  z.f 
EndStructure

Enumeration ; FMOD_RESULT
  #FMOD_OK                         ; No errors.
  #FMOD_ERR_ALREADYLOCKED          ; Tried to call lock a second time before unlock was called.
  #FMOD_ERR_BADCOMMAND             ; Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound).
  #FMOD_ERR_CDDA_DRIVERS           ; Neither NTSCSI nor ASPI could be initialised.
  #FMOD_ERR_CDDA_INIT              ; An error occurred while initialising the CDDA subsystem.
  #FMOD_ERR_CDDA_INVALID_DEVICE    ; Couldn't find the specified device.
  #FMOD_ERR_CDDA_NOAUDIO           ; No audio tracks on the specified disc.
  #FMOD_ERR_CDDA_NODEVICES         ; No CD/DVD devices were found.
  #FMOD_ERR_CDDA_NODISC            ; No disc present in the specified drive.
  #FMOD_ERR_CDDA_READ              ; A CDDA read error occurred.
  #FMOD_ERR_CHANNEL_ALLOC          ; Error trying to allocate a channel.
  #FMOD_ERR_CHANNEL_STOLEN         ; The specified channel has been reused to play another sound.
  #FMOD_ERR_COM                    ; A Win32 COM related error occured. COM failed to initialize or a QueryInterface failed meaning a Windows codec or driver was not installed properly.
  #FMOD_ERR_DMA                    ; DMA Failure.  See debug output for more information.
  #FMOD_ERR_DSP_CONNECTION         ; DSP connection error.  Connection possibly caused a cyclic dependancy.
  #FMOD_ERR_DSP_FORMAT             ; DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format.
  #FMOD_ERR_DSP_NOTFOUND           ; DSP connection error.  Couldn't find the DSP unit specified.
  #FMOD_ERR_DSP_RUNNING            ; DSP error.  Cannot perform this operation while the network is in the middle of running.  This will most likely happen if a connection or disconnection is attempted in a DSP callback.
  #FMOD_ERR_DSP_TOOMANYCONNECTIONS ; DSP connection error.  The unit being connected to or disconnected should only have 1 input or output.
  #FMOD_ERR_FILE_BAD               ; Error loading file.
  #FMOD_ERR_FILE_COULDNOTSEEK      ; Couldn't perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format.
  #FMOD_ERR_FILE_EOF               ; End of file unexpectedly reached while trying to read essential data (truncated data?).
  #FMOD_ERR_FILE_NOTFOUND          ; File not found.
  #FMOD_ERR_FILE_UNWANTED          ; Unwanted file access occured.
  #FMOD_ERR_FORMAT                 ; Unsupported file or audio format.
  #FMOD_ERR_HTTP                   ; A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere.
  #FMOD_ERR_HTTP_ACCESS            ; The specified resource requires authentication or is forbidden.
  #FMOD_ERR_HTTP_PROXY_AUTH        ; Proxy authentication is required to access the specified resource.
  #FMOD_ERR_HTTP_SERVER_ERROR      ; A HTTP server error occurred.
  #FMOD_ERR_HTTP_TIMEOUT           ; The HTTP request timed out.
  #FMOD_ERR_INITIALIZATION         ; FMOD was not initialized correctly to support this function.
  #FMOD_ERR_INITIALIZED            ; Cannot call this command after System::init.
  #FMOD_ERR_INTERNAL               ; An error occured that wasnt supposed to.  Contact support.
  #FMOD_ERR_INVALID_ADDRESS        ; On Xbox 360, this memory address passed to FMOD must be physical, (ie allocated with XPhysicalAlloc.)
  #FMOD_ERR_INVALID_FLOAT          ; Value passed in was a NaN, Inf or denormalized float.
  #FMOD_ERR_INVALID_HANDLE         ; An invalid object handle was used.
  #FMOD_ERR_INVALID_PARAM          ; An invalid parameter was passed to this function.
  #FMOD_ERR_INVALID_SPEAKER        ; An invalid speaker was passed to this function based on the current speaker mode.
  #FMOD_ERR_INVALID_VECTOR         ; The vectors passed in are not unit length, or perpendicular.
  #FMOD_ERR_IRX                    ; PS2 only.  fmodex.irx failed to initialize.  This is most likely because you forgot to load it.
  #FMOD_ERR_MEMORY                 ; Not enough memory or resources.
  #FMOD_ERR_MEMORY_IOP             ; PS2 only.  Not enough memory or resources on PlayStation 2 IOP ram.
  #FMOD_ERR_MEMORY_SRAM            ; Not enough memory or resources on console sound ram.
  #FMOD_ERR_MEMORY_CANTPOINT       ; Can't use #FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if #FMOD_CREATECOMPRESSEDSAMPLE was used.
  #FMOD_ERR_NEEDS2D                ; Tried to call a command on a 3d sound when the command was meant for 2d sound.
  #FMOD_ERR_NEEDS3D                ; Tried to call a command on a 2d sound when the command was meant for 3d sound.
  #FMOD_ERR_NEEDSHARDWARE          ; Tried to use a feature that requires hardware support.  (ie trying to play a VAG compressed sound in software on PS2).
  #FMOD_ERR_NEEDSSOFTWARE          ; Tried to use a feature that requires the software engine.  Software engine has either been turned off or command was executed on a hardware channel which does not support this feature.
  #FMOD_ERR_NET_CONNECT            ; Couldn't connect to the specified host.
  #FMOD_ERR_NET_SOCKET_ERROR       ; A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere.
  #FMOD_ERR_NET_URL                ; The specified URL couldn't be resolved.
  #FMOD_ERR_NOTREADY               ; Operation could not be performed because specified sound is not ready.
  #FMOD_ERR_OUTPUT_ALLOCATED       ; Error initializing output device, but more specifically, the output device is already in use and cannot be reused.
  #FMOD_ERR_OUTPUT_CREATEBUFFER    ; Error creating hardware sound buffer.
  #FMOD_ERR_OUTPUT_DRIVERCALL      ; A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted.
  #FMOD_ERR_OUTPUT_FORMAT          ; Soundcard does not support the minimum features needed for this soundsystem (16bit stereo output).
  #FMOD_ERR_OUTPUT_INIT            ; Error initializing output device.
  #FMOD_ERR_OUTPUT_NOHARDWARE      ; #FMOD_HARDWARE was specified but the sound card does not have the resources nescessary to play it.
  #FMOD_ERR_OUTPUT_NOSOFTWARE      ; Attempted to create a software sound but no software channels were specified in System::init.
  #FMOD_ERR_PAN                    ; Panning only works with mono or stereo sound sources.
  #FMOD_ERR_PLUGIN                 ; An unspecified error has been returned from a 3rd party plugin.
  #FMOD_ERR_PLUGIN_MISSING         ; A requested output, dsp unit type or codec was not available.
  #FMOD_ERR_PLUGIN_RESOURCE        ; A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback)
  #FMOD_ERR_RECORD                 ; An error occured trying to initialize the recording device.
  #FMOD_ERR_REVERB_INSTANCE        ; Specified Instance in #FMOD_REVERB_PROPERTIES couldn't be set. Most likely because another application has locked the EAX4 FX slot.
  #FMOD_ERR_SUBSOUNDS              ; The error occured because the sound referenced contains subsounds.  (ie you cannot play the parent sound as a static sample, only its subsounds.)
  #FMOD_ERR_SUBSOUND_ALLOCATED     ; This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent's entry first.
  #FMOD_ERR_TAGNOTFOUND            ; The specified tag could not be found or there are no tags.
  #FMOD_ERR_TOOMANYCHANNELS        ; The sound created exceeds the allowable input channel count.  This can be increased using the maxinputchannels parameter in System::setSoftwareFormat.
  #FMOD_ERR_UNIMPLEMENTED          ; Something in FMOD hasn't been implemented when it should be! contact support!
  #FMOD_ERR_UNINITIALIZED          ; This command failed because System::init or System::setDriver was not called.
  #FMOD_ERR_UNSUPPORTED            ; A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified.
  #FMOD_ERR_UPDATE                 ; On PS2, System::update was called twice in a row when System::updateFinished must be called first.
  #FMOD_ERR_VERSION                ; The version number of this file format is not supported.
  
  #FMOD_ERR_EVENT_FAILED           ; An Event failed to be retrieved, most likely due to "just fail" being specified as the max playbacks behaviour.
  #FMOD_ERR_EVENT_INTERNAL         ; An error occured that wasn't supposed to.  See debug log for reason.
  #FMOD_ERR_EVENT_NAMECONFLICT     ; A category with the same name already exists.
  #FMOD_ERR_EVENT_NOTFOUND         ; The requested event, event group, event category or event property could not be found.
EndEnumeration

Enumeration ; FMOD_OUTPUTTYPE
  #FMOD_OUTPUTTYPE_AUTODETECT    ; Picks the best output mode for the platform.  This is the default.
  
  #FMOD_OUTPUTTYPE_UNKNOWN       ; All         - 3rd party plugin, unknown.  This is for use with System::getOutput only.
  #FMOD_OUTPUTTYPE_NOSOUND       ; All         - All calls in this mode succeed but make no sound.
  #FMOD_OUTPUTTYPE_WAVWRITER     ; All         - Writes output to fmodout.wav by default.  Use System::setSoftwareFormat to set the filename.
  #FMOD_OUTPUTTYPE_NOSOUND_NRT   ; All         - Non-realtime version of #FMOD_OUTPUTTYPE_NOSOUND.  User can drive mixer with System::update at whatever rate they want. 
  #FMOD_OUTPUTTYPE_WAVWRITER_NRT ; All         - Non-realtime version of #FMOD_OUTPUTTYPE_WAVWRITER.  User can drive mixer with System::update at whatever rate they want. 
  
  #FMOD_OUTPUTTYPE_DSOUND        ; Win32/Win64 - DirectSound output.  Use this to get hardware accelerated 3d audio and EAX Reverb support. (Default on Windows)
  #FMOD_OUTPUTTYPE_WINMM         ; Win32/Win64 - Windows Multimedia output.
  #FMOD_OUTPUTTYPE_ASIO          ; Win32       - Low latency ASIO driver.
  #FMOD_OUTPUTTYPE_OSS           ; Linux       - Open Sound System output.
  #FMOD_OUTPUTTYPE_ALSA          ; Linux       - Advanced Linux Sound Architecture output.
  #FMOD_OUTPUTTYPE_ESD           ; Linux       - Enlightment Sound Daemon output.
  #FMOD_OUTPUTTYPE_SOUNDMANAGER  ; Mac         - Macintosh SoundManager output.
  #FMOD_OUTPUTTYPE_COREAUDIO     ; Mac         - Macintosh CoreAudio output.
  #FMOD_OUTPUTTYPE_XBOX          ; Xbox        - Native hardware output.
  #FMOD_OUTPUTTYPE_PS2           ; PS2         - Native hardware output.
  #FMOD_OUTPUTTYPE_GC            ; GameCube    - Native hardware output.
  #FMOD_OUTPUTTYPE_XBOX360       ; Xbox 360    - Native hardware output.
  #FMOD_OUTPUTTYPE_PSP           ; PSP         - Native hardware output.
  #FMOD_OUTPUTTYPE_OPENAL        ; Win32/Win64 - OpenAL 1.1 output. Use this for lower CPU overhead than #FMOD_OUTPUTTYPE_DSOUND, and also Vista H/W support with Creative Labs cards.
  
  #FMOD_OUTPUTTYPE_MAX           ; Maximum number of output types supported. 
EndEnumeration

Enumeration ; FMOD_CAPS
  #FMOD_CAPS_NONE = $0                             ; Device has no special capabilities.
  #FMOD_CAPS_HARDWARE = $1                         ; Device supports hardware mixing.
  #FMOD_CAPS_HARDWARE_EMULATED = $2                ; Device supports #FMOD_HARDWARE but it will be mixed on the CPU by the kernel (not FMOD's software mixer).
  #FMOD_CAPS_OUTPUT_MULTICHANNEL = $4              ; Device can do multichannel output, ie greater than 2 channels.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM8 = $8               ; Device can output to 8bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM16 = $10             ; Device can output to 16bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM24 = $20             ; Device can output to 24bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCM32 = $40             ; Device can output to 32bit integer PCM.
  #FMOD_CAPS_OUTPUT_FORMAT_PCMFLOAT = $80          ; Device can output to 32bit floating point PCM.
  #FMOD_CAPS_REVERB_EAX2 = $100                    ; Device supports EAX2 reverb.
  #FMOD_CAPS_REVERB_EAX3 = $200                    ; Device supports EAX3 reverb.
  #FMOD_CAPS_REVERB_EAX4 = $400                    ; Device supports EAX4 reverb  
  #FMOD_CAPS_REVERB_I3DL2 = $800                   ; Device supports I3DL2 reverb.
  #FMOD_CAPS_REVERB_LIMITED = $1000                ; Device supports some form of limited hardware reverb, maybe parameterless and only selectable by environment.
EndEnumeration

Enumeration ; FMOD_DEBUGLEVEL
  #FMOD_DEBUG_LEVEL_NONE = $0
  #FMOD_DEBUG_LEVEL_LOG = $1
  #FMOD_DEBUG_LEVEL_ERROR = $2
  #FMOD_DEBUG_LEVEL_WARNING = $4
  #FMOD_DEBUG_LEVEL_HINT = $8
  #FMOD_DEBUG_LEVEL_ALL = $FF
  #FMOD_DEBUG_TYPE_MEMORY = $100
  #FMOD_DEBUG_TYPE_THREAD = $200
  #FMOD_DEBUG_TYPE_FILE = $400
  #FMOD_DEBUG_TYPE_NET = $800
  #FMOD_DEBUG_TYPE_EVENT = $1000
  #FMOD_DEBUG_TYPE_ALL = $FFFF
  #FMOD_DEBUG_DISPLAY_TIMESTAMPS = $1000000
  #FMOD_DEBUG_DISPLAY_LINENUMBERS = $2000000
  #FMOD_DEBUG_DISPLAY_COMPRESS = $4000000
  #FMOD_DEBUG_DISPLAY_ALL = $F000000
  #FMOD_DEBUG_ALL = $FFFFFFFF
EndEnumeration

Enumeration ; FMOD_MEMORY_TYPE
  #FMOD_MEMORY_NORMAL = $0                   ; Standard memory.
  #FMOD_MEMORY_XBOX360_PHYSICAL = $100000    ; Requires XPhysicalAlloc / XPhysicalFree.
EndEnumeration

Enumeration ; FMOD_SPEAKERMODE
  #FMOD_SPEAKERMODE_RAW              ; There is no specific speakermode.  Sound channels are mapped in order of input to output.  See remarks for more information.
  #FMOD_SPEAKERMODE_MONO             ; The speakers are monaural.
  #FMOD_SPEAKERMODE_STEREO           ; The speakers are stereo (DEFAULT).
  #FMOD_SPEAKERMODE_QUAD             ; 4 speaker setup.  This includes front left, front right, rear left, rear right.
  #FMOD_SPEAKERMODE_SURROUND         ; 4 speaker setup.  This includes front left, front right, center, rear center (rear left/rear right are averaged).
  #FMOD_SPEAKERMODE_5POINT1          ; 5.1 speaker setup.  This includes front left, front right, center, rear left, rear right and a subwoofer.
  #FMOD_SPEAKERMODE_7POINT1          ; 7.1 speaker setup.  This includes front left, front right, center, rear left, rear right, side left, side right and a subwoofer.
  #FMOD_SPEAKERMODE_PROLOGIC         ; Stereo output, but data is encoded in a way that is picked up by a Prologic/Prologic2 decoder and split into a 5.1 speaker setup.
  
  #FMOD_SPEAKERMODE_MAX              ; Maximum number of speaker modes supported.
EndEnumeration

Enumeration ; FMOD_SPEAKER
  #FMOD_SPEAKER_FRONT_LEFT
  #FMOD_SPEAKER_FRONT_RIGHT
  #FMOD_SPEAKER_FRONT_CENTER
  #FMOD_SPEAKER_LOW_FREQUENCY
  #FMOD_SPEAKER_BACK_LEFT
  #FMOD_SPEAKER_BACK_RIGHT
  #FMOD_SPEAKER_SIDE_LEFT
  #FMOD_SPEAKER_SIDE_RIGHT
  
  #FMOD_SPEAKER_MAX                                       ; Maximum number of speaker types supported.
  #FMOD_SPEAKER_MONO = #FMOD_SPEAKER_FRONT_LEFT            ; For use with #FMOD_SPEAKERMODE_MONO and Channel::SetSpeakerLevels.  Mapped to same value as #FMOD_SPEAKER_FRONT_LEFT.
  #FMOD_SPEAKER_BACK_CENTER = #FMOD_SPEAKER_LOW_FREQUENCY  ; For use with #FMOD_SPEAKERMODE_SURROUND and Channel::SetSpeakerLevels only.  Mapped to same value as #FMOD_SPEAKER_LOW_FREQUENCY.
EndEnumeration

Enumeration ; FMOD_PLUGINTYPE
  #FMOD_PLUGINTYPE_OUTPUT     ; The plugin type is an output module.  FMOD mixed audio will play through one of these devices.
  #FMOD_PLUGINTYPE_CODEC      ; The plugin type is a file format codec.  FMOD will use these codecs to load file formats for playback.
  #FMOD_PLUGINTYPE_DSP        ; The plugin type is a DSP unit.  FMOD will use these plugins as part of its DSP network to apply effects to output or generate sound in realtime.
EndEnumeration

Enumeration ; FMOD_INITFLAGS
  #FMOD_INIT_NORMAL = $0                           ; All platforms - Initialize normally.
  #FMOD_INIT_STREAM_FROM_UPDATE = $1               ; All platforms - No stream thread is created internally.  Streams are driven from System::update.  Mainly used with non-realtime outputs. 
  #FMOD_INIT_3D_RIGHTHANDED = $2                   ; All platforms - FMOD will treat +X as left, +Y as up and +Z as forwards.
  #FMOD_INIT_DISABLESOFTWARE = $4                  ; All platforms - Disable software mixer to save memory.  Anything created with #FMOD_SOFTWARE will fail and DSP will not work.
  #FMOD_INIT_DSOUND_HRTFNONE = $200                ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use simple stereo panning/doppler/attenuation when 3D hardware acceleration is not present.
  #FMOD_INIT_DSOUND_HRTFLIGHT = $400               ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use a slightly higher quality algorithm when 3D hardware acceleration is not present.
  #FMOD_INIT_DSOUND_HRTFFULL = $800                ; Win32 only - for DirectSound output - #FMOD_HARDWARE | #FMOD_3D buffers use full quality 3D playback when 3d hardware acceleration is not present.
  #FMOD_INIT_PS2_DISABLECORE0REVERB = $10000       ; PS2 only - Disable reverb on CORE 0 to regain SRAM.
  #FMOD_INIT_PS2_DISABLECORE1REVERB = $20000       ; PS2 only - Disable reverb on CORE 1 to regain SRAM.
  #FMOD_INIT_XBOX_REMOVEHEADROOM = $100000         ; XBox only - By default DirectSound attenuates all sound by 6db to avoid clipping/distortion.  CAUTION.  If you use this flag you are responsible for the final mix to make sure clipping / distortion doesn't happen.
EndEnumeration

Enumeration ; FMOD_SOUND_TYPE
  #FMOD_SOUND_TYPE_UNKNOWN         ; 3rd party / unknown plugin format.
  #FMOD_SOUND_TYPE_AAC             ; AAC.  Currently unsupported.
  #FMOD_SOUND_TYPE_AIFF            ; AIFF.
  #FMOD_SOUND_TYPE_ASF             ; Microsoft Advanced Systems Format (ie WMA/ASF/WMV).
  #FMOD_SOUND_TYPE_AT3             ; Sony ATRAC 3 format
  #FMOD_SOUND_TYPE_CDDA            ; Digital CD audio.
  #FMOD_SOUND_TYPE_DLS             ; Sound font / downloadable sound bank.
  #FMOD_SOUND_TYPE_FLAC            ; FLAC lossless codec.
  #FMOD_SOUND_TYPE_FSB             ; FMOD Sample Bank.
  #FMOD_SOUND_TYPE_GCADPCM         ; GameCube ADPCM
  #FMOD_SOUND_TYPE_IT              ; Impulse Tracker.
  #FMOD_SOUND_TYPE_MIDI            ; MIDI.
  #FMOD_SOUND_TYPE_MOD             ; Protracker / Fasttracker MOD.
  #FMOD_SOUND_TYPE_MPEG            ; MP2/MP3 MPEG.
  #FMOD_SOUND_TYPE_OGGVORBIS       ; Ogg vorbis.
  #FMOD_SOUND_TYPE_PLAYLIST        ; Information only from ASX/PLS/M3U/WAX playlists
  #FMOD_SOUND_TYPE_RAW             ; Raw PCM data.
  #FMOD_SOUND_TYPE_S3M             ; ScreamTracker 3.
  #FMOD_SOUND_TYPE_SF2             ; Sound font 2 format.
  #FMOD_SOUND_TYPE_USER            ; User created sound.
  #FMOD_SOUND_TYPE_WAV             ; Microsoft WAV.
  #FMOD_SOUND_TYPE_XM              ; FastTracker 2 XM.
  #FMOD_SOUND_TYPE_XMA             ; Xbox360 XMA
  #FMOD_SOUND_TYPE_VAG             ; PlayStation 2 / PlayStation Portable adpcm VAG format.
EndEnumeration

Enumeration ; FMOD_SOUND_FORMAT
  #FMOD_SOUND_FORMAT_NONE      ; Unitialized / unknown.
  #FMOD_SOUND_FORMAT_PCM8      ; 8bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM16     ; 16bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM24     ; 24bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCM32     ; 32bit integer PCM data.
  #FMOD_SOUND_FORMAT_PCMFLOAT  ; 32bit floating point PCM data.
  #FMOD_SOUND_FORMAT_GCADPCM   ; Compressed GameCube DSP data.
  #FMOD_SOUND_FORMAT_IMAADPCM  ; Compressed XBox ADPCM data.
  #FMOD_SOUND_FORMAT_VAG       ; Compressed PlayStation 2 ADPCM data.
  #FMOD_SOUND_FORMAT_XMA       ; Compressed Xbox360 data.
  #FMOD_SOUND_FORMAT_MPEG      ; Compressed MPEG layer 2 or 3 data.
  #FMOD_SOUND_FORMAT_MAX       ; Maximum number of sound formats supported.
EndEnumeration

Enumeration ; FMOD_MODE
  #FMOD_DEFAULT = $0                       ; #FMOD_DEFAULT is a default sound type.  Equivalent to all the defaults listed below.  #FMOD_LOOP_OFF, #FMOD_2D, #FMOD_HARDWARE.
  #FMOD_LOOP_OFF = $1                      ; For non looping sounds. (default).  Overrides #FMOD_LOOP_NORMAL / #FMOD_LOOP_BIDI.
  #FMOD_LOOP_NORMAL = $2                   ; For forward looping sounds.
  #FMOD_LOOP_BIDI = $4                     ; For bidirectional looping sounds. (only works on software mixed static sounds).
  #FMOD_2D = $8                            ; Ignores any 3d processing. (default).
  #FMOD_3D = $10                           ; Makes the sound positionable in 3D.  Overrides #FMOD_2D.
  #FMOD_HARDWARE = $20                     ; Attempts to make sounds use hardware acceleration. (default).
  #FMOD_SOFTWARE = $40                     ; Makes sound reside in software.  Overrides #FMOD_HARDWARE.  Use this for FFT,  DSP, 2D multi speaker support and other software related features.
  #FMOD_CREATESTREAM = $80                 ; Decompress at runtime, streaming from the source provided (standard stream).  Overrides #FMOD_CREATESAMPLE.
  #FMOD_CREATESAMPLE = $100                ; Decompress at loadtime, decompressing or decoding whole file into memory as the target sample format. (standard sample).
  #FMOD_CREATECOMPRESSEDSAMPLE = $200      ; Load MP2, MP3, IMAADPCM or XMA into memory and leave it compressed.  During playback the FMOD software mixer will decode it in realtime as a 'compressed sample'.  Can only be used in combination with #FMOD_SOFTWARE.
  #FMOD_OPENUSER = $400                    ; Opens a user created static sample or stream. Use #FMOD_CREATESOUNDEXINFO to specify format and/or read callbacks.  If a user created 'sample' is created with no read callback, the sample will be empty.  Use #FMOD_Sound_Lock and #FMOD_Sound_Unlock to place sound data into the sound if this is the case.
  #FMOD_OPENMEMORY = $800                  ; "name_or_data" will be interpreted as a pointer to memory instead of filename for creating sounds.
  #FMOD_OPENRAW = $1000                    ; Will ignore file format and treat as raw pcm.  User may need to declare if data is #FMOD_SIGNED or #FMOD_UNSIGNED 
  #FMOD_OPENONLY = $2000                   ; Just open the file, dont prebuffer or read.  Good for fast opens for info, or when #FMOD_Sound_ReadData is to be used.
  #FMOD_ACCURATETIME = $4000               ; For #FMOD_System_CreateSound - for accurate #FMOD_Sound_GetLength / #FMOD_Channel_SetPosition on VBR MP3, AAC and MOD/S3M/XM/IT/MIDI files.  Scans file first, so takes longer to open. #FMOD_OPENONLY does not affect this.
  #FMOD_MPEGSEARCH = $8000                 ; For corrupted / bad MP3 files.  This will search all the way through the file until it hits a valid MPEG header.  Normally only searches for 4k.
  #FMOD_NONBLOCKING = $10000               ; For opening sounds asyncronously, return value from open function must be polled for when it is ready.
  #FMOD_UNIQUE = $20000                    ; Unique sound, can only be played one at a time 
  #FMOD_3D_HEADRELATIVE = $40000           ; Make the sound's position, velocity and orientation relative to the listener.
  #FMOD_3D_WORLDRELATIVE = $80000          ; Make the sound's position, velocity and orientation absolute (relative to the world). (DEFAULT)
  #FMOD_3D_LOGROLLOFF = $100000            ; This sound will follow the standard logarithmic rolloff model where mindistance = full volume, maxdistance = where sound stops attenuating, and rolloff is fixed according to the global rolloff factor.  (default)
  #FMOD_3D_LINEARROLLOFF = $200000         ; This sound will follow a linear rolloff model where mindistance = full volume, maxdistance = silence.
  #FMOD_3D_CUSTOMROLLOFF = $4000000        ; This sound will follow a rolloff model defined by #FMOD_Sound_Set3DCustomRolloff / #FMOD_Channel_Set3DCustomRolloff.
  #FMOD_CDDA_FORCEASPI = $400000           ; For CDDA sounds only - use ASPI instead of NTSCSI to access the specified CD/DVD device.
  #FMOD_CDDA_JITTERCORRECT = $800000       ; For CDDA sounds only - perform jitter correction. Jitter correction helps produce a more accurate CDDA stream at the cost of more CPU time.
  #FMOD_UNICODE = $1000000                 ; Filename is double-byte unicode.
  #FMOD_IGNORETAGS = $2000000              ; Skips id3v2/asf/etc tag checks when opening a sound, to reduce seek/read overhead when opening files (helps with CD performance).
  #FMOD_LOWMEM = $8000000                  ; Removes some features from samples to give a lower memory overhead, like #FMOD_Sound_GetName.
EndEnumeration

Enumeration ; FMOD_OPENSTATE
  #FMOD_OPENSTATE_READY = 0        ; Opened and ready to play 
  #FMOD_OPENSTATE_LOADING          ; Initial load in progress 
  #FMOD_OPENSTATE_ERROR            ; Failed to open - file not found, out of memory etc.  See return value of Sound::getOpenState for what happened.
  #FMOD_OPENSTATE_CONNECTING       ; Connecting to remote host (internet sounds only) 
  #FMOD_OPENSTATE_BUFFERING        ; Buffering data 
EndEnumeration

Enumeration ; FMOD_CHANNEL_CALLBACKTYPE
  #FMOD_CHANNEL_CALLBACKTYPE_END                  ; Called when a sound ends.
  #FMOD_CHANNEL_CALLBACKTYPE_VIRTUALVOICE         ; Called when a voice is swapped out or swapped in.
  #FMOD_CHANNEL_CALLBACKTYPE_SYNCPOINT            ; Called when a syncpoint is encountered.  Can be from wav file markers.
  
  #FMOD_CHANNEL_CALLBACKTYPE_MAX
EndEnumeration

Enumeration ; FMOD_DSP_FFT_WINDOW
  #FMOD_DSP_FFT_WINDOW_RECT            ; w[n] = 1.0                                                                                            
  #FMOD_DSP_FFT_WINDOW_TRIANGLE        ; w[n] = TRI(2n/N)                                                                                      
  #FMOD_DSP_FFT_WINDOW_HAMMING         ; w[n] = 0.54 - (0.46 * COS(n/N) )                                                                      
  #FMOD_DSP_FFT_WINDOW_HANNING         ; w[n] = 0.5 *  (1.0  - COS(n/N) )                                                                      
  #FMOD_DSP_FFT_WINDOW_BLACKMAN        ; w[n] = 0.42 - (0.5  * COS(n/N) ) + (0.08 * COS(2.0 * n/N) )                                           
  #FMOD_DSP_FFT_WINDOW_BLACKMANHARRIS  ; w[n] = 0.35875 - (0.48829 * COS(1.0 * n/N)) + (0.14128 * COS(2.0 * n/N)) - (0.01168 * COS(3.0 * n/N)) 
  #FMOD_DSP_FFT_WINDOW_MAX
EndEnumeration

Enumeration ; FMOD_DSP_RESAMPLER
  #FMOD_DSP_RESAMPLER_NOINTERP        ; No interpolation.  High frequency aliasing hiss will be audible depending on the sample rate of the sound. 
  #FMOD_DSP_RESAMPLER_LINEAR          ; Linear interpolation (default method).  Fast and good quality, causes very slight lowpass effect on low frequency sounds. 
  #FMOD_DSP_RESAMPLER_CUBIC           ; Cubic interoplation.  Slower than linear interpolation but better quality. 
  #FMOD_DSP_RESAMPLER_SPLINE          ; 5 point spline interoplation.  Slowest resampling method but best quality. 
  
  #FMOD_DSP_RESAMPLER_MAX             ; Maximum number of resample methods supported. 
EndEnumeration

Enumeration ; FMOD_TAGTYPE
  #FMOD_TAGTYPE_UNKNOWN = 0
  #FMOD_TAGTYPE_ID3V1
  #FMOD_TAGTYPE_ID3V2
  #FMOD_TAGTYPE_VORBISCOMMENT
  #FMOD_TAGTYPE_SHOUTCAST
  #FMOD_TAGTYPE_ICECAST
  #FMOD_TAGTYPE_ASF
  #FMOD_TAGTYPE_MIDI
  #FMOD_TAGTYPE_PLAYLIST
  #FMOD_TAGTYPE_FMOD
  #FMOD_TAGTYPE_USER
EndEnumeration

Enumeration ; FMOD_TAGDATATYPE
  #FMOD_TAGDATATYPE_BINARY = 0
  #FMOD_TAGDATATYPE_INT
  #FMOD_TAGDATATYPE_FLOAT
  #FMOD_TAGDATATYPE_STRING
  #FMOD_TAGDATATYPE_STRING_UTF16
  #FMOD_TAGDATATYPE_STRING_UTF16BE
  #FMOD_TAGDATATYPE_STRING_UTF8
  #FMOD_TAGDATATYPE_CDTOC
EndEnumeration

Structure FMOD_TAG
  type.l         ; [out] The type of this tag.
  datatype.l     ; [out] The type of data that this tag contains 
  name.l                      ; [out] The name of this tag i.e. "TITLE", "ARTIST" etc.
  _data.l                      ; [out] Pointer to the tag data - its format is determined by the datatype member 
  datalen.l                   ; [out] Length of the data contained in this tag 
  udated.l                 ; [out] True if this tag has been updated since last being accessed with Sound::getTag 
EndStructure

Structure FMOD_CDTOC
  numtracks.l                 ; [out] The number of tracks on the CD 
  min.l[100]                  ; [out] The start offset of each track in minutes 
  sec.l[100]                  ; [out] The start offset of each track in seconds 
  frame.l[100]                ; [out] The start offset of each track in frames 
EndStructure

Enumeration ; FMOD_TIMEUNIT
  #FMOD_TIMEUNIT_MS = $1                        ; Milliseconds.
  #FMOD_TIMEUNIT_PCM = $2                       ; PCM Samples, related to milliseconds * samplerate / 1000.
  #FMOD_TIMEUNIT_PCMBYTES = $4                  ; Bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes).
  #FMOD_TIMEUNIT_RAWBYTES = $8                  ; Raw file bytes of (compressed) sound data (does not include headers).  Only used by Sound::getLength and Channel::getPosition.
  #FMOD_TIMEUNIT_MODORDER = $100                ; MOD/S3M/XM/IT.  Order in a sequenced module format.  Use Sound::getFormat to determine the format.
  #FMOD_TIMEUNIT_MODROW = $200                  ; MOD/S3M/XM/IT.  Current row in a sequenced module format.  Sound::getLength will return the number if rows in the currently playing or seeked to pattern.
  #FMOD_TIMEUNIT_MODPATTERN = $400              ; MOD/S3M/XM/IT.  Current pattern in a sequenced module format.  Sound::getLength will return the number of patterns in the song and Channel::getPosition will return the currently playing pattern.
  #FMOD_TIMEUNIT_SENTENCE_MS = $10000           ; Currently playing subsound in a sentence time in milliseconds.
  #FMOD_TIMEUNIT_SENTENCE_PCM = $20000          ; Currently playing subsound in a sentence time in PCM Samples, related to milliseconds * samplerate / 1000.
  #FMOD_TIMEUNIT_SENTENCE_PCMBYTES = $40000     ; Currently playing subsound in a sentence time in bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes).
  #FMOD_TIMEUNIT_SENTENCE = $80000              ; Currently playing sentence index according to the channel.
  #FMOD_TIMEUNIT_SENTENCE_SUBSOUND = $100000    ; Currently playing subsound index in a sentence.
  #FMOD_TIMEUNIT_BUFFERED = $10000000           ; Time value as seen by buffered stream.  This is always ahead of audible time, and is only used for processing.
EndEnumeration

Structure FMOD_CREATESOUNDEXINFO
  cbSize.l                          ; [in] Size of this structure.  This is used so the structure can be expanded in the future and still work on older versions of FMOD Ex.
  Length.l                          ; [in] Optional. Specify 0 to ignore. Size in bytes of file to load, or sound to create (in this case only if FMOD_OPENUSER is used).  Required if loading from memory.  If 0 is specified, then it will use the size of the file (unless loading from memory then an error will be returned).
  fileoffset.l                      ; [in] Optional. Specify 0 to ignore. Offset from start of the file to start loading from.  This is useful for loading files from inside big data files.
  Numchannels.l                     ; [in] Optional. Specify 0 to ignore. Number of channels in a sound specified only if FMOD_OPENUSER is used.
  defaultfrequency.l                ; [in] Optional. Specify 0 to ignore. Default frequency of sound in a sound specified only if FMOD_OPENUSER is used.  Other formats use the frequency determined by the file format.
  Format.l ; [in] Optional. Specify 0 or FMOD_SOUND_FORMAT_NONE to ignore. Format of the sound specified only if FMOD_OPENUSER is used.  Other formats use the format determined by the file format.
  decodebuffersize.l                ; [in] Optional. Specify 0 to ignore. For streams.  This determines the size of the double buffer (in PCM samples) that a stream uses.  Use this for user created streams if you want to determine the size of the callback buffer passed to you.  Specify 0 to use FMOD's default size which is currently equivalent to 400ms of the sound format created/loaded.
  initialsubsound.l                 ; [in] Optional. Specify 0 to ignore. In a multi-sample file format such as .FSB/.DLS/.SF2, specify the initial subsound to seek to, only if FMOD_CREATESTREAM is used.
  Numsubsounds.l                    ; [in] Optional. Specify 0 to ignore or have no subsounds.  In a user created multi-sample sound, specify the number of subsounds within the sound that are accessable with Sound::getSubSound.
  inclusionlist.l                   ; [in] Optional. Specify 0 to ignore. In a multi-sample format such as .FSB/.DLS/.SF2 it may be desirable to specify only a subset of sounds to be loaded out of the whole file.  This is an array of subsound indicies to load into memory when created.
  inclusionlistnum.l                ; [in] Optional. Specify 0 to ignore. This is the number of integers contained within the inclusionlist array.
  pcmreadcallback.l                 ; [in] Optional. Specify 0 to ignore. Callback to 'piggyback' on FMOD's read functions and accept or even write PCM data while FMOD is opening the sound.  Used for user sounds created with FMOD_OPENUSER or for capturing decoded data as FMOD reads it.
  pcmsetposcallback.l               ; [in] Optional. Specify 0 to ignore. Callback for when the user calls a seeking function such as Channel::setTime or Channel::setPosition within a multi-sample sound, and for when it is opened.
  nonblockcallback.l                ; [in] Optional. Specify 0 to ignore. Callback for successful completion, or error while loading a sound that used the FMOD_NONBLOCKING flag.
  dlsname.s                       ; [in] Optional. Specify 0 to ignore. Filename for a DLS or SF2 sample set when loading a MIDI file.   If not specified, on windows it will attempt to open /windows/system32/drivers/gm.dls, otherwise the MIDI will fail to open.
  encryptionkey.s                 ; [in] Optional. Specify 0 to ignore. Key for encrypted FSB file.  Without this key an encrypted FSB file will not load.
  maxpolyphony.l                    ; [in] Optional. Specify 0 to ingore. For sequenced formats with dynamic channel allocation such as .MID and .IT, this specifies the maximum voice count allowed while playing.  .IT defaults to 64.  .MID defaults to 32.
  userdata.l                        ; [in] Optional. Specify 0 to ignore. This is user data to be attached to the sound during creation.  Access via Sound::getUserData. 
  suggestedsoundtype.l              ; [in] Optional. Specify 0 Or FMOD_SOUND_TYPE_UNKNOWN To ignore.  Instead of scanning all codec types, use this To speed up loading by making it jump straight To this codec.
  useropen.l                        ; [in] Optional. Specify 0 to ignore. Callback for opening this file.
  userclose.l                       ; [in] Optional. Specify 0 to ignore. Callback for closing this file.
  userread.l                        ; [in] Optional. Specify 0 to ignore. Callback for reading from this file.
  userseek.l                        ; [in] Optional. Specify 0 to ignore. Callback for seeking within this file.
EndStructure

#FMOD_CREATESOUNDEXINFO_SIZE  = 92 ;sizeof(#FMOD_CREATESOUNDEXINFO)

Structure FMOD_REVERB_PROPERTIES
  Instance.l                 ; [in]     0     , 2     , 0      , EAX4 only. Environment Instance. 3 seperate reverbs simultaneously are possible. This specifies which one to set. (win32 only) 
  Environment.l              ; [in/out] 0     , 25    , 0      , sets all listener properties (win32/ps2) 
  EnvSize.f                ; [in/out] 1.0   , 100.0 , 7.5    , environment size in meters (win32 only) 
  EnvDiffusion.f           ; [in/out] 0.0   , 1.0   , 1.0    , environment diffusion (win32/xbox) 
  Room.l                     ; [in/out] -10000, 0     , -1000  , room effect level (at mid frequencies) (win32/xbox) 
  RoomHF.l                   ; [in/out] -10000, 0     , -100   , relative room effect level at high frequencies (win32/xbox) 
  RoomLF.l                   ; [in/out] -10000, 0     , 0      , relative room effect level at low frequencies (win32 only) 
  DecayTime.f              ; [in/out] 0.1   , 20.0  , 1.49   , reverberation decay time at mid frequencies (win32/xbox) 
  DecayHFRatio.f           ; [in/out] 0.1   , 2.0   , 0.83   , high-frequency to mid-frequency decay time ratio (win32/xbox) 
  DecayLFRatio.f           ; [in/out] 0.1   , 2.0   , 1.0    , low-frequency to mid-frequency decay time ratio (win32 only) 
  Reflections.l              ; [in/out] -10000, 1000  , -2602  , early reflections level relative to room effect (win32/xbox) 
  ReflectionsDelay.f       ; [in/out] 0.0   , 0.3   , 0.007  , initial reflection delay time (win32/xbox) 
  ReflectionsPan.f[3]      ; [in/out]       ,       , [0,0,0], early reflections panning vector (win32 only) 
  Reverb.l                   ; [in/out] -10000, 2000  , 200    , late reverberation level relative to room effect (win32/xbox) 
  ReverbDelay.f            ; [in/out] 0.0   , 0.1   , 0.011  , late reverberation delay time relative to initial reflection (win32/xbox) 
  ReverbPan.f[3]           ; [in/out]       ,       , [0,0,0], late reverberation panning vector (win32 only) 
  EchoTime.f               ; [in/out] .075  , 0.25  , 0.25   , echo time (win32 only) 
  EchoDepth.f              ; [in/out] 0.0   , 1.0   , 0.0    , echo depth (win32 only) 
  ModulationTime.f         ; [in/out] 0.04  , 4.0   , 0.25   , modulation time (win32 only) 
  ModulationDepth.f        ; [in/out] 0.0   , 1.0   , 0.0    , modulation depth (win32 only) 
  AirAbsorptionHF.f        ; [in/out] -100  , 0.0   , -5.0   , change in level per meter at high frequencies (win32 only) 
  HFReference.f            ; [in/out] 1000.0, 20000 , 5000.0 , reference high frequency (hz) (win32/xbox) 
  LFReference.f            ; [in/out] 20.0  , 1000.0, 250.0  , reference low frequency (hz) (win32 only) 
  RoomRolloffFactor.f      ; [in/out] 0.0   , 10.0  , 0.0    , like FMOD_3D_Listener_SetRolloffFactor but for room effect (win32/xbox) 
  Diffusion.f              ; [in/out] 0.0   , 100.0 , 100.0  , Value that controls the echo density in the late reverberation decay. (xbox only) 
  Density.f                ; [in/out] 0.0   , 100.0 , 100.0  , Value that controls the modal density in the late reverberation decay (xbox only) 
  flags.l                    ; [in/out] FMOD_REVERB_FLAGS - modifies the behavior of above properties (win32/ps2) 
EndStructure

#FMOD_REVERB_FLAGS_DECAYTIMESCALE         = $1               ; 'EnvSize' affects reverberation decay time 
#FMOD_REVERB_FLAGS_REFLECTIONSSCALE       = $2             ; 'EnvSize' affects reflection level 
#FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE  = $4        ; 'EnvSize' affects initial reflection delay time 
#FMOD_REVERB_FLAGS_REVERBSCALE            = $8        ; 'EnvSize' affects reflections level 
#FMOD_REVERB_FLAGS_REVERBDELAYSCALE       = $10       ; 'EnvSize' affects late reverberation delay time 
#FMOD_REVERB_FLAGS_DECAYHFLIMIT           = $20       ; AirAbsorptionHF affects DecayHFRatio 
#FMOD_REVERB_FLAGS_ECHOTIMESCALE          = $40       ; 'EnvSize' affects echo time 
#FMOD_REVERB_FLAGS_MODULATIONTIMESCALE    = $80       ; 'EnvSize' affects modulation time 
#FMOD_REVERB_FLAGS_DEFAULT                = (#FMOD_REVERB_FLAGS_DECAYTIMESCALE | #FMOD_REVERB_FLAGS_REFLECTIONSSCALE | #FMOD_REVERB_FLAGS_REFLECTIONSDELAYSCALE | #FMOD_REVERB_FLAGS_REVERBSCALE | #FMOD_REVERB_FLAGS_REVERBDELAYSCALE | #FMOD_REVERB_FLAGS_DECAYHFLIMIT)

Structure FMOD_REVERB_CHANNELPROPERTIES
  Direct.l                   ; [in/out] -10000, 1000,  0,       direct path level (at low and mid frequencies) (win32/xbox) 
  DirectHF.l                 ; [in/out] -10000, 0,     0,       relative direct path level at high frequencies (win32/xbox) 
  Room.l                     ; [in/out] -10000, 1000,  0,       room effect level (at low and mid frequencies) (win32/xbox) 
  RoomHF.l                   ; [in/out] -10000, 0,     0,       relative room effect level at high frequencies (win32/xbox) 
  Obstruction.l              ; [in/out] -10000, 0,     0,       main obstruction control (attenuation at high frequencies)  (win32/xbox) 
  ObstructionLFRatio.f     ; [in/out] 0.0,    1.0,   0.0,     obstruction low-frequency level re. main control (win32/xbox) 
  Occlusion.l                ; [in/out] -10000, 0,     0,       main occlusion control (attenuation at high frequencies) (win32/xbox) 
  OcclusionLFRatio.f       ; [in/out] 0.0,    1.0,   0.25,    occlusion low-frequency level re. main control (win32/xbox) 
  OcclusionRoomRatio.f     ; [in/out] 0.0,    10.0,  1.5,     relative occlusion control for room effect (win32) 
  OcclusionDirectRatio.f   ; [in/out] 0.0,    10.0,  1.0,     relative occlusion control for direct path (win32) 
  Exclusion.l                ; [in/out] -10000, 0,     0,       main exlusion control (attenuation at high frequencies) (win32) 
  ExclusionLFRatio.f       ; [in/out] 0.0,    1.0,   1.0,     exclusion low-frequency level re. main control (win32) 
  OutsideVolumeHF.l          ; [in/out] -10000, 0,     0,       outside sound cone level at high frequencies (win32) 
  DopplerFactor.f          ; [in/out] 0.0,    10.0,  0.0,     like DS3D flDopplerFactor but per source (win32) 
  RolloffFactor.f          ; [in/out] 0.0,    10.0,  0.0,     like DS3D flRolloffFactor but per source (win32) 
  RoomRolloffFactor.f      ; [in/out] 0.0,    10.0,  0.0,     like DS3D flRolloffFactor but for room effect (win32/xbox) 
  AirAbsorptionFactor.f    ; [in/out] 0.0,    10.0,  1.0,     multiplies AirAbsorptionHF member of FMOD_REVERB_PROPERTIES (win32) 
  flags.l                    ; [in/out] FMOD_REVERB_CHANNELFLAGS - modifies the behavior of properties (win32) 
EndStructure

Structure FMOD_DSP_DESCRIPTION
  name.s                   ; [in] Name of the unit to be displayed in the network.
  Version.l                  ; [in] Plugin writer's version number.
  Channels.l                 ; [in] Number of channels.  Use 0 to process whatever number of channels is currently in the network.  >0 would be mostly used if the unit is a fixed format generator and not a filter.
  create.l                   ; [in] Create callback.  This is called when DSP unit is created.  Can be null.
  release.l                  ; [in] Release callback.  This is called just before the unit is freed so the user can do any cleanup needed for the unit.  Can be null.
  reset.l                    ; [in] Reset callback.  This is called by the user to reset any history buffers that may need resetting for a filter, when it is to be used or re-used for the first time to its initial clean state.  Use to avoid clicks or artifacts.
  Read.l                     ; [in] Read callback.  Processing is done here.  Can be null.
  setpos.l                   ; [in] Setposition callback.  This is called if the unit becomes virtualized and needs to simply update positions etc.  Can be null.
  
  numparameters.l            ; [in] Number of parameters used in this filter.  The user finds this with DSP::getNumParameters 
  paramdesc.l                ; [in] Variable number of parameter structures.
  setparameter.l             ; [in] This is called when the user calls DSP::setParameter.  Can be null.
  getparameter.l             ; [in] This is called when the user calls DSP::getParameter.  Can be null.
  config.l                   ; [in] This is called when the user calls DSP::showConfigDialog.  Can be used to display a dialog to configure the filter.  Can be null.
  Configwidth.l              ; [in] Width of config dialog graphic if there is one.  0 otherwise.
  Configheight.l             ; [in] Height of config dialog graphic if there is one.  0 otherwise.
  userdata.l                 ; [in] Optional. Specify 0 to ignore. This is user data to be attached to the DSP unit during creation.  Access via DSP::getUserData.
EndStructure

#FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO  = $1        ; Automatic setting of 'Direct'  due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ROOMAUTO      = $2        ; Automatic setting of 'Room'  due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO    = $4        ; Automatic setting of 'RoomHF' due to distance from listener 
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT0  = $8        ; EAX4 only. Specify channel to target reverb instance 0.
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT1  = $10       ; EAX4 only. Specify channel to target reverb instance 1.
#FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT2  = $20       ; EAX4 only. Specify channel to target reverb instance 2.

#FMOD_REVERB_CHANNELFLAGS_DEFAULT       = (#FMOD_REVERB_CHANNELFLAGS_DIRECTHFAUTO | #FMOD_REVERB_CHANNELFLAGS_ROOMAUTO | #FMOD_REVERB_CHANNELFLAGS_ROOMHFAUTO | #FMOD_REVERB_CHANNELFLAGS_ENVIRONMENT0)

Structure FMOD_ADVANCEDSETTINGS
  cbSize.l          ; Size of structure.  Use sizeof(FMOD_ADVANCEDSETTINGS)
  maxMPEGcodecs.l   ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  Mpeg  codecs consume 48,696 per instance and this number will determine how many mpeg channels can be played simultaneously.  Default = 16.
  maxADPCMcodecs.l  ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  ADPCM codecs consume 1k per instance and this number will determine how many ADPCM channels can be played simultaneously.  Default = 32.
  maxXMAcodecs.l    ; For use with FMOD_CREATECOMPRESSEDSAMPLE only.  XMA   codecs consume 8k per instance and this number will determine how many XMA channels can be played simultaneously.  Default = 32.
EndStructure

Enumeration ; FMOD_CHANNELINDEX
  #FMOD_CHANNEL_FREE = -1     ; For a channel index, FMOD chooses a free voice using the priority system.
  #FMOD_CHANNEL_REUSE = -2    ; For a channel index, re-use the channel handle that was passed in.
EndEnumeration

Procedure.l FMOD_Memory_Initialize (poolmem.l, poollen.l, useralloc.l, userrealloc.l, userfree.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Memory_Initialize", poolmem.l, poollen.l, useralloc.l, userrealloc.l, userfree.l)
EndProcedure

Procedure.l FMOD_Memory_GetStats (*currentalloced.l, *maxalloced.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Memory_GetStats", *currentalloced.l, *maxalloced.l)
EndProcedure

Procedure.l FMOD_Debug_SetLevel (level.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Debug_SetLevel", level.l)
EndProcedure

Procedure.l FMOD_Debug_GetLevel (*level.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Debug_GetLevel", *level.l)
EndProcedure

Procedure.l FMOD_File_SetDiskBusy (busy.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_File_SetDiskBusy", busy.l)
EndProcedure

Procedure.l FMOD_File_GetDiskBusy (*busy.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_File_GetDiskBusy", *busy.l)
EndProcedure

Procedure.l FMOD_System_Create (*system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Create", *system.l)
EndProcedure

Procedure.l FMOD_System_Release (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Release", system.l)
EndProcedure

Procedure.l FMOD_System_SetOutput (system.l, Output.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetOutput", system.l, Output.l)
EndProcedure

Procedure.l FMOD_System_GetOutput (system.l, *Output.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetOutput", system.l, *Output.l)
EndProcedure

Procedure.l FMOD_System_GetNumDrivers (system.l, *Numdrivers.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetNumDrivers", system.l, *Numdrivers.l)
EndProcedure

Procedure.l FMOD_System_GetDriverName (system.l, id.l, *name.b, Namelen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetDriverName", system.l, id.l, *name.b, Namelen.l)
EndProcedure

Procedure.l FMOD_System_GetDriverCaps (system.l, id.l, *caps.l, *minfrequency.l, *maxfrequency.l, *controlpanelspeakermode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetDriverCaps", system.l, id.l, *caps.l, *minfrequency.l, *maxfrequency.l, *controlpanelspeakermode.l)
EndProcedure

Procedure.l FMOD_System_SetDriver (system.l, Driver.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetDriver", system.l, Driver.l)
EndProcedure

Procedure.l FMOD_System_GetDriver (system.l, *Driver.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetDriver", system.l, *Driver.l)
EndProcedure

Procedure.l FMOD_System_SetHardwareChannels (system.l, Min2d.l, Max2d.l, Min3d.l, Max3d.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetHardwareChannels", system.l, Min2d.l, Max2d.l, Min3d.l, Max3d.l)
EndProcedure

Procedure.l FMOD_System_GetHardwareChannels (system.l, *Num2d.l, *Num3d.l, *total.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetHardwareChannels", system.l, *Num2d.l, *Num3d.l, *total.l)
EndProcedure

Procedure.l FMOD_System_SetSoftwareChannels (system.l, Numsoftwarechannels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetSoftwareChannels", system.l, Numsoftwarechannels.l)
EndProcedure

Procedure.l FMOD_System_GetSoftwareChannels (system.l, *Numsoftwarechannels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSoftwareChannels", system.l, *Numsoftwarechannels.l)
EndProcedure

Procedure.l FMOD_System_SetSoftwareFormat (system.l, Samplerate.l, Format.l, Numoutputchannels.l, Maxinputchannels.l, Resamplemethod.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetSoftwareFormat", system.l, Samplerate.l, Format.l, Numoutputchannels.l, Maxinputchannels.l, Resamplemethod.l)
EndProcedure

Procedure.l FMOD_System_GetSoftwareFormat (system.l, *Samplerate.l, *Format.l, *Numoutputchannels.l, *Maxinputchannels.l, *Resamplemethod.l, *Bits.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSoftwareFormat", system.l, *Samplerate.l, *Format.l, *Numoutputchannels.l, *Maxinputchannels.l, *Resamplemethod.l, *Bits.l)
EndProcedure

Procedure.l FMOD_System_SetDSPBufferSize (system.l, Bufferlength.l, Numbuffers.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetDSPBufferSize", system.l, Bufferlength.l, Numbuffers.l)
EndProcedure

Procedure.l FMOD_System_GetDSPBufferSize (system.l, *Bufferlength.l, *Numbuffers.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetDSPBufferSize", system.l, *Bufferlength.l, *Numbuffers.l)
EndProcedure

Procedure.l FMOD_System_SetFileSystem (system.l, useropen.l, userclose.l, userread.l, userseek.l, Buffersize.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetFileSystem", system.l, useropen.l, userclose.l, userread.l, userseek.l, Buffersize.l)
EndProcedure

Procedure.l FMOD_System_AttachFileSystem (system.l, useropen.l, userclose.l, userread.l, userseek.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_AttachFileSystem", system.l, useropen.l, userclose.l, userread.l, userseek.l)
EndProcedure

Procedure.l FMOD_System_SetAdvancedSettings (system.l, *settings.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetAdvancedSettings", system.l, *settings.l)
EndProcedure

Procedure.l FMOD_System_GetAdvancedSettings (system.l, *settings.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetAdvancedSettings", system.l, *settings.l)
EndProcedure

Procedure.l FMOD_System_SetSpeakerMode (system.l, Speakermode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetSpeakerMode", system.l, Speakermode.l)
EndProcedure

Procedure.l FMOD_System_GetSpeakerMode (system.l, *Speakermode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSpeakerMode", system.l, *Speakermode.l)
EndProcedure

Procedure.l FMOD_System_SetPluginPath (system.l, Path.s)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetPluginPath", system.l, Path.s)
EndProcedure

Procedure.l FMOD_System_LoadPlugin (system.l, Filename.s, *Plugintype.l, *Index.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_LoadPlugin", system.l, Filename.s, *Plugintype.l, *Index.l)
EndProcedure

Procedure.l FMOD_System_GetNumPlugins (system.l, Plugintype.l, *Numplugins.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetNumPlugins", system.l, Plugintype.l, *Numplugins.l)
EndProcedure

Procedure.l FMOD_System_GetPluginInfo (system.l, Plugintype.l, Index.l, *name.b, Namelen.l, *version.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetPluginInfo", system.l, Plugintype.l, Index.l, *name.b, Namelen.l, *version.l)
EndProcedure

Procedure.l FMOD_System_UnloadPlugin (system.l, Plugintype.l, *Index.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_UnloadPlugin", system.l, Plugintype.l, *Index.l)
EndProcedure

Procedure.l FMOD_System_SetOutputByPlugin (system.l, Index.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetOutputByPlugin", system.l, Index.l)
EndProcedure

Procedure.l FMOD_System_GetOutputByPlugin (system.l, *Index.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetOutputByPlugin", system.l, *Index.l)
EndProcedure

Procedure.l FMOD_System_CreateCodec (system.l, CodecDescription.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateCodec", system.l, CodecDescription.l)
EndProcedure

Procedure.l FMOD_System_Init (system.l, Maxchannels.l, flags.l, Extradriverdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Init", system.l, Maxchannels.l, flags.l, Extradriverdata.l)
EndProcedure

Procedure.l FMOD_System_Close (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Close", system.l)
EndProcedure

Procedure.l FMOD_System_Update (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Update", system.l)
EndProcedure

Procedure.l FMOD_System_UpdateFinished (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_UpdateFinished", system.l)
EndProcedure

Procedure.l FMOD_System_Set3DSettings (system.l, Dopplerscale.f, Distancefactor.f, Rolloffscale.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Set3DSettings", system.l, Dopplerscale.f, Distancefactor.f, Rolloffscale.f)
EndProcedure

Procedure.l FMOD_System_Get3DSettings (system.l, *Dopplerscale.f, *Distancefactor.f, *Rolloffscale.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Get3DSettings", system.l, *Dopplerscale.f, *Distancefactor.f, *Rolloffscale.f)
EndProcedure

Procedure.l FMOD_System_Set3DNumListeners (system.l, Numlisteners.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Set3DNumListeners", system.l, Numlisteners.l)
EndProcedure

Procedure.l FMOD_System_Get3DNumListeners (system.l, *Numlisteners.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Get3DNumListeners", system.l, *Numlisteners.l)
EndProcedure

Procedure.l FMOD_System_Set3DListenerAttributes (system.l, Listener.l, *Pos.l, *Vel.l, *Forward.l, *Up.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Set3DListenerAttributes", system.l, Listener.l, *Pos.l, *Vel.l, *Forward.l, *Up.l)
EndProcedure

Procedure.l FMOD_System_Get3DListenerAttributes (system.l, Listener.l, *Pos.l, *Vel.l, *Forward.l, *Up.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_Get3DListenerAttributes", system.l, Listener.l, *Pos.l, *Vel.l, *Forward.l, *Up.l)
EndProcedure

Procedure.l FMOD_System_SetSpeakerPosition (system.l, Speaker.l, x.f, y.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetSpeakerPosition", system.l, Speaker.l, x.f, y.f)
EndProcedure

Procedure.l FMOD_System_GetSpeakerPosition (system.l, *Speaker.l, *X.f, *Y.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSpeakerPosition", system.l, *Speaker.l, *X.f, *Y.f)
EndProcedure

Procedure.l FMOD_System_SetStreamBufferSize (system.l, Filebuffersize.l, Filebuffersizetype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetStreamBufferSize", system.l, Filebuffersize.l, Filebuffersizetype.l)
EndProcedure

Procedure.l FMOD_System_GetStreamBufferSize (system.l, *Filebuffersize.l, *Filebuffersizetype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetStreamBufferSize", system.l, *Filebuffersize.l, *Filebuffersizetype.l)
EndProcedure

Procedure.l FMOD_System_GetVersion (system.l, *version.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetVersion", system.l, *version.l)
EndProcedure

Procedure.l FMOD_System_GetOutputHandle (system.l, *Handle.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetOutputHandle", system.l, *Handle.l)
EndProcedure

Procedure.l FMOD_System_GetChannelsPlaying (system.l, *Channels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetChannelsPlaying", system.l, *Channels.l)
EndProcedure

Procedure.l FMOD_System_GetCPUUsage (system.l, *Dsp.f, *Stream.f, *Update.f, *total.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetCPUUsage", system.l, *Dsp.f, *Stream.f, *Update.f, *total.f)
EndProcedure

Procedure.l FMOD_System_GetSoundRAM (system.l, *currentalloced.l, *maxalloced.l, *total.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSoundRAM", system.l, *currentalloced.l, *maxalloced.l, *total.l)
EndProcedure

Procedure.l FMOD_System_GetNumCDROMDrives (system.l, *Numdrives.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetNumCDROMDrives", system.l, *Numdrives.l)
EndProcedure

Procedure.l FMOD_System_GetCDROMDriveName (system.l, Drive.l, *Drivename.b, Drivenamelen.l, *Scsiname.b, Scsinamelen.l, *Devicename.b, Devicenamelen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetCDROMDriveName", system.l, Drive.l, *Drivename.b, Drivenamelen.l, *Scsiname.b, Scsinamelen.l, *Devicename.b, Devicenamelen.l)
EndProcedure

Procedure.l FMOD_System_GetSpectrum (system.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, *Windowtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetSpectrum", system.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, *Windowtype.l)
EndProcedure

Procedure.l FMOD_System_GetWaveData (system.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetWaveData", system.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
EndProcedure

Procedure.l FMOD_System_CreateSound (system.l, Name_or_data.l, Mode.l, *exinfo.l, *Sound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateSoundEx", system.l, Name_or_data.l, Mode.l, *exinfo.l, *Sound.l)
EndProcedure

Procedure.l FMOD_System_CreateStream (system.l, Name_or_data.l, Mode.l, *exinfo.l, *Sound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateStreamEx", system.l, Name_or_data.l, Mode.l, *exinfo.l, *Sound.l)
EndProcedure

Procedure.l FMOD_System_CreateDSP (system.l, *description.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateDSP", system.l, *description.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_System_CreateDSPByType (system.l, dsptype.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateDSPByType", system.l, dsptype.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_System_CreateDSPByIndex (system.l, Index.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateDSPByIndex", system.l, Index.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_System_CreateChannelGroup (system.l, name.s, *Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateChannelGroup", system.l, name.s, *Channelgroup.l)
EndProcedure

Procedure.l FMOD_System_PlaySound (system.l, channelid.l, sound.l, paused.l, *channel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_PlaySound", system.l, channelid.l, sound.l, paused.l, *channel.l)
EndProcedure

Procedure.l FMOD_System_PlayDSP (system.l, channelid.l, Dsp.l, paused.l, *channel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_PlayDSP", system.l, channelid.l, Dsp.l, paused.l, *channel.l)
EndProcedure

Procedure.l FMOD_System_GetChannel (system.l, channelid.l, *channel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetChannel", system.l, channelid.l, *channel.l)
EndProcedure

Procedure.l FMOD_System_GetMasterChannelGroup (system.l, *Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetMasterChannelGroup", system.l, *Channelgroup.l)
EndProcedure

Procedure.l FMOD_System_SetReverbProperties (system.l, *Prop.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetReverbProperties", system.l, *Prop.l)
EndProcedure

Procedure.l FMOD_System_GetReverbProperties (system.l, *Prop.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetReverbProperties", system.l, *Prop.l)
EndProcedure

Procedure.l FMOD_System_GetDSPHead (system.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetDSPHead", system.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_System_AddDSP (system.l, Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_AddDSP", system.l, Dsp.l)
EndProcedure

Procedure.l FMOD_System_LockDSP (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_LockDSP", system.l)
EndProcedure

Procedure.l FMOD_System_UnlockDSP (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_UnlockDSP", system.l)
EndProcedure

Procedure.l FMOD_System_SetRecordDriver (system.l, Driver.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetRecordDriver", system.l, Driver.l)
EndProcedure

Procedure.l FMOD_System_GetRecordDriver (system.l, *Driver.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetRecordDriver", system.l, *Driver.l)
EndProcedure

Procedure.l FMOD_System_GetRecordNumDrivers (system.l, *Numdrivers.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetRecordNumDrivers", system.l, *Numdrivers.l)
EndProcedure

Procedure.l FMOD_System_GetRecordDriverName (system.l, id.l, *name.b, Namelen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetRecordDriverName", system.l, id.l, *name.b, Namelen.l)
EndProcedure

Procedure.l FMOD_System_GetRecordPosition (system.l, *Position.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetRecordPosition", system.l, *Position.l)
EndProcedure

Procedure.l FMOD_System_RecordStart (system.l, sound.l, Loop_.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_RecordStart", system.l, sound.l, Loop_.l)
EndProcedure

Procedure.l FMOD_System_RecordStop (system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_RecordStop", system.l)
EndProcedure

Procedure.l FMOD_System_IsRecording (system.l, *Recording.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_IsRecording", system.l, *Recording.l)
EndProcedure

Procedure.l FMOD_System_CreateGeometry (system.l, MaxPolygons.l, MaxVertices.l, *Geometryf.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_CreateGeometry", system.l, MaxPolygons.l, MaxVertices.l, *Geometryf.l)
EndProcedure

Procedure.l FMOD_System_SetGeometrySettings (system.l, Maxworldsize.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetGeometrySettings", system.l, Maxworldsize.f)
EndProcedure

Procedure.l FMOD_System_GetGeometrySettings (system.l, *Maxworldsize.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetGeometrySettings", system.l, *Maxworldsize.f)
EndProcedure

Procedure.l FMOD_System_LoadGeometry (system.l, _data.l, _dataSize.l, *Geometry.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_LoadGeometry", system.l, _data.l, _dataSize.l, *Geometry.l)
EndProcedure

Procedure.l FMOD_System_SetNetworkProxy (system.l, Proxy.s)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetNetworkProxy", system.l, Proxy.s)
EndProcedure

Procedure.l FMOD_System_GetNetworkProxy (system.l, *Proxy.b, Proxylen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetNetworkProxy", system.l, *Proxy.b, Proxylen.l)
EndProcedure

Procedure.l FMOD_System_SetNetworkTimeout (system.l, timeout.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetNetworkTimeout", system.l, timeout.l)
EndProcedure

Procedure.l FMOD_System_GetNetworkTimeout (system.l, *timeout.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetNetworkTimeout", system.l, *timeout.l)
EndProcedure

Procedure.l FMOD_System_SetUserData (system.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_SetUserData", system.l, userdata.l)
EndProcedure

Procedure.l FMOD_System_GetUserData (system.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_System_GetUserData", system.l, *userdata.l)
EndProcedure

Procedure.l FMOD_Sound_Release (sound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Release", sound.l)
EndProcedure

Procedure.l FMOD_Sound_GetSystemObject (sound.l, *system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetSystemObject", sound.l, *system.l)
EndProcedure

Procedure.l FMOD_Sound_Lock (sound.l, Offset.l, Length.l, *Ptr1.l, *Ptr2.l, *Len1.l, *Len2.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Lock", sound.l, Offset.l, Length.l, *Ptr1.l, *Ptr2.l, *Len1.l, *Len2.l)
EndProcedure

Procedure.l FMOD_Sound_Unlock (sound.l, Ptr1.l, Ptr2.l, Len1.l, Len2.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Unlock", sound.l, Ptr1.l, Ptr2.l, Len1.l, Len2.l)
EndProcedure

Procedure.l FMOD_Sound_SetDefaults (sound.l, Frequency.f, Volume.f, Pan.f, Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetDefaults", sound.l, Frequency.f, Volume.f, Pan.f, Priority.l)
EndProcedure

Procedure.l FMOD_Sound_GetDefaults (sound.l, *Frequency.f, *Volume.f, *Pan.f, *Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetDefaults", sound.l, *Frequency.f, *Volume.f, *Pan.f, *Priority.l)
EndProcedure

Procedure.l FMOD_Sound_SetVariations (sound.l, Frequencyvar.f, Volumevar.f, Panvar.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetVariations", sound.l, Frequencyvar.f, Volumevar.f, Panvar.f)
EndProcedure

Procedure.l FMOD_Sound_GetVariations (sound.l, *Frequencyvar.f, *Volumevar.f, *Panvar.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetVariations", sound.l, *Frequencyvar.f, *Volumevar.f, *Panvar.f)
EndProcedure

Procedure.l FMOD_Sound_Set3DMinMaxDistance (sound.l, min.f, max.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Set3DMinMaxDistance", sound.l, min.f, max.f)
EndProcedure

Procedure.l FMOD_Sound_Get3DMinMaxDistance (sound.l, *min.f, *max.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Get3DMinMaxDistance", sound.l, *min.f, *max.f)
EndProcedure

Procedure.l FMOD_Sound_Set3DConeSettings (sound.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Set3DConeSettings", sound.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
EndProcedure

Procedure.l FMOD_Sound_Get3DConeSettings (sound.l, *Insideconeangle.f, *Outsideconeangle.f, *Outsidevolume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Get3DConeSettings", sound.l, *Insideconeangle.f, *Outsideconeangle.f, *Outsidevolume.f)
EndProcedure

Procedure.l FMOD_Sound_Set3DCustomRolloff (sound.l, *Points.l, numpoints.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Set3DCustomRolloff", sound.l, *Points.l, numpoints.l)
EndProcedure

Procedure.l FMOD_Sound_Get3DCustomRolloff (sound.l, *Points.l, *numpoints.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_Get3DCustomRolloff", sound.l, *Points.l, *numpoints.l)
EndProcedure

Procedure.l FMOD_Sound_SetSubSound (sound.l, Index.l, Subsound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetSubSound", sound.l, Index.l, Subsound.l)
EndProcedure

Procedure.l FMOD_Sound_GetSubSound (sound.l, Index.l, *Subsound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetSubSound", sound.l, Index.l, *Subsound.l)
EndProcedure

Procedure.l FMOD_Sound_SetSubSoundSentence (sound.l, *Subsoundlist.l, Numsubsounds.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetSubSoundSentence", sound.l, *Subsoundlist.l, Numsubsounds.l)
EndProcedure

Procedure.l FMOD_Sound_GetName (sound.l, *name.b, Namelen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetName", sound.l, *name.b, Namelen.l)
EndProcedure

Procedure.l FMOD_Sound_GetLength (sound.l, *Length.l, Lengthtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetLength", sound.l, *Length.l, Lengthtype.l)
EndProcedure

Procedure.l FMOD_Sound_GetFormat (sound.l, *Soundtype.l, *Format.l, *Channels.l, *Bits.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetFormat", sound.l, *Soundtype.l, *Format.l, *Channels.l, *Bits.l)
EndProcedure

Procedure.l FMOD_Sound_GetNumSubSounds (sound.l, *Numsubsounds.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetNumSubSounds", sound.l, *Numsubsounds.l)
EndProcedure

Procedure.l FMOD_Sound_GetNumTags (sound.l, *Numtags.l, *Numtagsupdated.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetNumTags", sound.l, *Numtags.l, *Numtagsupdated.l)
EndProcedure

Procedure.l FMOD_Sound_GetTag (sound.l, name.s, Index.l, *Tag.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetTag", sound.l, name.s, Index.l, *Tag.l)
EndProcedure

Procedure.l FMOD_Sound_GetOpenState (sound.l, *Openstate.l, *Percentbuffered.l, *Starving.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetOpenState", sound.l, *Openstate.l, *Percentbuffered.l, *Starving.l)
EndProcedure

Procedure.l FMOD_Sound_ReadData (sound.l, Buffer.l, Lenbytes.l, *_Read.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_ReadData", sound.l, Buffer.l, Lenbytes.l, *_Read.l)
EndProcedure

Procedure.l FMOD_Sound_SeekData (sound.l, Pcm.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SeekData", sound.l, Pcm.l)
EndProcedure

Procedure.l FMOD_Sound_GetNumSyncPoints (sound.l, *Numsyncpoints.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetNumSyncPoints", sound.l, *Numsyncpoints.l)
EndProcedure

Procedure.l FMOD_Sound_GetSyncPoint (sound.l, Index.l, *Point.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetSyncPoint", sound.l, Index.l, *Point.l)
EndProcedure

Procedure.l FMOD_Sound_GetSyncPointInfo (sound.l, Point.l, *name.b, Namelen.l, *Offset.l, Offsettype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetSyncPointInfo", sound.l, Point.l, *name.b, Namelen.l, *Offset.l, Offsettype.l)
EndProcedure

Procedure.l FMOD_Sound_AddSyncPoint (sound.l, Offset.l, Offsettype.l, name.s, *Point.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_AddSyncPoint", sound.l, Offset.l, Offsettype.l, name.s, *Point.l)
EndProcedure

Procedure.l FMOD_Sound_DeleteSyncPoint (sound.l, Point.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_DeleteSyncPoint", sound.l, Point.l)
EndProcedure

Procedure.l FMOD_Sound_SetMode (sound.l, Mode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetMode", sound.l, Mode.l)
EndProcedure

Procedure.l FMOD_Sound_GetMode (sound.l, *Mode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetMode", sound.l, *Mode.l)
EndProcedure

Procedure.l FMOD_Sound_SetLoopCount (sound.l, Loopcount.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetLoopCount", sound.l, Loopcount.l)
EndProcedure

Procedure.l FMOD_Sound_GetLoopCount (sound.l, *Loopcount.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetLoopCount", sound.l, *Loopcount.l)
EndProcedure

Procedure.l FMOD_Sound_SetLoopPoints (sound.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetLoopPoints", sound.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
EndProcedure

Procedure.l FMOD_Sound_GetLoopPoints (sound.l, *Loopstart.l, Loopstarttype.l, *Loopend.l, Loopendtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetLoopPoints", sound.l, *Loopstart.l, Loopstarttype.l, *Loopend.l, Loopendtype.l)
EndProcedure

Procedure.l FMOD_Sound_SetUserData (sound.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_SetUserData", sound.l, userdata.l)
EndProcedure

Procedure.l FMOD_Sound_GetUserData (sound.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Sound_GetUserData", sound.l, *userdata.l)
EndProcedure

Procedure.l FMOD_Channel_GetSystemObject (channel.l, *system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetSystemObject", channel.l, *system.l)
EndProcedure

Procedure.l FMOD_Channel_Stop (channel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Stop", channel.l)
EndProcedure

Procedure.l FMOD_Channel_SetPaused (channel.l, paused.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetPaused", channel.l, paused.l)
EndProcedure

Procedure.l FMOD_Channel_GetPaused (channel.l, *paused.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetPaused", channel.l, *paused.l)
EndProcedure

Procedure.l FMOD_Channel_SetVolume (channel.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetVolume", channel.l, Volume.f)
EndProcedure

Procedure.l FMOD_Channel_GetVolume (channel.l, *Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetVolume", channel.l, *Volume.f)
EndProcedure

Procedure.l FMOD_Channel_SetFrequency (channel.l, Frequency.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetFrequency", channel.l, Frequency.f)
EndProcedure

Procedure.l FMOD_Channel_GetFrequency (channel.l, *Frequency.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetFrequency", channel.l, *Frequency.f)
EndProcedure

Procedure.l FMOD_Channel_SetPan (channel.l, Pan.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetPan", channel.l, Pan.f)
EndProcedure

Procedure.l FMOD_Channel_GetPan (channel.l, *Pan.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetPan", channel.l, *Pan.f)
EndProcedure

Procedure.l FMOD_Channel_SetDelay (channel.l, Startdelay.l, Enddelay.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetDelay", channel.l, Startdelay.l, Enddelay.l)
EndProcedure

Procedure.l FMOD_Channel_GetDelay (channel.l, *Startdelay.l, *Enddelay.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetDelay", channel.l, *Startdelay.l, *Enddelay.l)
EndProcedure

Procedure.l FMOD_Channel_SetSpeakerMix (channel.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetSpeakerMix", channel.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
EndProcedure

Procedure.l FMOD_Channel_GetSpeakerMix (channel.l, *Frontleft.f, *Frontright.f, *Center.f, *Lfe.f, *Backleft.f, *Backright.f, *Sideleft.f, *Sideright.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetSpeakerMix", channel.l, *Frontleft.f, *Frontright.f, *Center.f, *Lfe.f, *Backleft.f, *Backright.f, *Sideleft.f, *Sideright.f)
EndProcedure

Procedure.l FMOD_Channel_SetSpeakerLevels (channel.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetSpeakerLevels", channel.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_Channel_GetSpeakerLevels (channel.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetSpeakerLevels", channel.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_Channel_SetMute (channel.l, Mute.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetMute", channel.l, Mute.l)
EndProcedure

Procedure.l FMOD_Channel_GetMute (channel.l, *Mute.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetMute", channel.l, *Mute.l)
EndProcedure

Procedure.l FMOD_Channel_SetPriority (channel.l, Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetPriority", channel.l, Priority.l)
EndProcedure

Procedure.l FMOD_Channel_GetPriority (channel.l, *Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetPriority", channel.l, *Priority.l)
EndProcedure

Procedure.l FMOD_Channel_SetPosition (channel.l, Position.l, Postype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetPosition", channel.l, Position.l, Postype.l)
EndProcedure

Procedure.l FMOD_Channel_GetPosition (channel.l, *Position.l, Postype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetPosition", channel.l, *Position.l, Postype.l)
EndProcedure

Procedure.l FMOD_Channel_SetReverbProperties (channel.l, *Prop.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetReverbProperties", channel.l, *Prop.l)
EndProcedure

Procedure.l FMOD_Channel_GetReverbProperties (channel.l, *Prop.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetReverbProperties", channel.l, *Prop.l)
EndProcedure

Procedure.l FMOD_Channel_SetChannelGroup (channel.l, Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetChannelGroup", channel.l, Channelgroup.l)
EndProcedure

Procedure.l FMOD_Channel_GetChannelGroup (channel.l, *Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetChannelGroup", channel.l, *Channelgroup.l)
EndProcedure

Procedure.l FMOD_Channel_SetCallback (channel.l, Type_.l, Callback.l, Command.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetCallback", channel.l, Type_.l, Callback.l, Command.l)
EndProcedure

Procedure.l FMOD_Channel_Set3DAttributes (channel.l, *Pos.l, *Vel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DAttributes", channel.l, *Pos.l, *Vel.l)
EndProcedure

Procedure.l FMOD_Channel_Get3DAttributes (channel.l, *Pos.l, *Vel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DAttributes", channel.l, *Pos.l, *Vel.l)
EndProcedure

Procedure.l FMOD_Channel_Set3DMinMaxDistance (channel.l, Mindistance.f, Maxdistance.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DMinMaxDistance", channel.l, Mindistance.f, Maxdistance.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DMinMaxDistance (channel.l, *Mindistance.f, *Maxdistance.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DMinMaxDistance", channel.l, *Mindistance.f, *Maxdistance.f)
EndProcedure

Procedure.l FMOD_Channel_Set3DConeSettings (channel.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DConeSettings", channel.l, Insideconeangle.f, Outsideconeangle.f, Outsidevolume.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DConeSettings (channel.l, *Insideconeangle.f, *Outsideconeangle.f, *Outsidevolume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DConeSettings", channel.l, *Insideconeangle.f, *Outsideconeangle.f, *Outsidevolume.f)
EndProcedure

Procedure.l FMOD_Channel_Set3DConeOrientation (channel.l, *Orientation.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DConeOrientation", channel.l, *Orientation.l)
EndProcedure

Procedure.l FMOD_Channel_Get3DConeOrientation (channel.l, *Orientation.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DConeOrientation", channel.l, *Orientation.l)
EndProcedure

Procedure.l FMOD_Channel_Set3DCustomRolloff (channel.l, *Points.l, numpoints.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DCustomRolloff", channel.l, *Points.l, numpoints.l)
EndProcedure

Procedure.l FMOD_Channel_Get3DCustomRolloff (channel.l, *Points.l, *numpoints.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DCustomRolloff", channel.l, *Points.l, *numpoints.l)
EndProcedure

Procedure.l FMOD_Channel_Set3DOcclusion (channel.l, DirectOcclusion.f, ReverbOcclusion.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DOcclusion", channel.l, DirectOcclusion.f, ReverbOcclusion.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DOcclusion (channel.l, *DirectOcclusion.f, *ReverbOcclusion.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DOcclusion", channel.l, *DirectOcclusion.f, *ReverbOcclusion.f)
EndProcedure

Procedure.l FMOD_Channel_Set3DSpread (channel.l, angle.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DSpread", channel.l, angle.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DSpread (channel.l, *angle.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DSpread", channel.l, *angle.f)
EndProcedure

Procedure.l FMOD_Channel_Set3DPanLevel (channel.l, float.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DPanLevel", channel.l, float.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DPanLevel (channel.l, *float.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DPanLevel", channel.l, *float.f)
EndProcedure

Procedure.l FMOD_Channel_Set3DDopplerLevel (channel.l, level.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Set3DDopplerLevel", channel.l, level.f)
EndProcedure

Procedure.l FMOD_Channel_Get3DDopplerLevel (channel.l, *level.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_Get3DDopplerLevel", channel.l, *level.f)
EndProcedure

Procedure.l FMOD_Channel_GetDSPHead (channel.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetDSPHead", channel.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_Channel_AddDSP (channel.l, Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_AddDSP", channel.l, Dsp.l)
EndProcedure

Procedure.l FMOD_Channel_IsPlaying (channel.l, *Isplaying.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_IsPlaying", channel.l, *Isplaying.l)
EndProcedure

Procedure.l FMOD_Channel_IsVirtual (channel.l, *Isvirtual.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_IsVirtual", channel.l, *Isvirtual.l)
EndProcedure

Procedure.l FMOD_Channel_GetAudibility (channel.l, *Audibility.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetAudibility", channel.l, *Audibility.f)
EndProcedure

Procedure.l FMOD_Channel_GetCurrentSound (channel.l, *Sound.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetCurrentSound", channel.l, *Sound.l)
EndProcedure

Procedure.l FMOD_Channel_GetSpectrum (channel.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, Windowtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetSpectrum", channel.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, Windowtype.l)
EndProcedure

Procedure.l FMOD_Channel_GetWaveData (channel.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetWaveData", channel.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
EndProcedure

Procedure.l FMOD_Channel_GetIndex (channel.l, *Index.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetIndex", channel.l, *Index.l)
EndProcedure

Procedure.l FMOD_Channel_SetMode (channel.l, Mode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetMode", channel.l, Mode.l)
EndProcedure

Procedure.l FMOD_Channel_GetMode (channel.l, *Mode.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetMode", channel.l, *Mode.l)
EndProcedure

Procedure.l FMOD_Channel_SetLoopCount (channel.l, Loopcount.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetLoopCount", channel.l, Loopcount.l)
EndProcedure

Procedure.l FMOD_Channel_GetLoopCount (channel.l, *Loopcount.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetLoopCount", channel.l, *Loopcount.l)
EndProcedure

Procedure.l FMOD_Channel_SetLoopPoints (channel.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetLoopPoints", channel.l, Loopstart.l, Loopstarttype.l, Loopend.l, Loopendtype.l)
EndProcedure

Procedure.l FMOD_Channel_GetLoopPoints (channel.l, *Loopstart.l, Loopstarttype.l, *Loopend.l, Loopendtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetLoopPoints", channel.l, *Loopstart.l, Loopstarttype.l, *Loopend.l, Loopendtype.l)
EndProcedure

Procedure.l FMOD_Channel_SetUserData (channel.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_SetUserData", channel.l, userdata.l)
EndProcedure

Procedure.l FMOD_Channel_GetUserData (channel.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Channel_GetUserData", channel.l, *userdata.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_Release (Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_Release", Channelgroup.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetSystemObject (Channelgroup.l, *system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetSystemObject", Channelgroup.l, *system.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_SetVolume (Channelgroup.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_SetVolume", Channelgroup.l, Volume.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetVolume (Channelgroup.l, *Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetVolume", Channelgroup.l, *Volume.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_SetPitch (Channelgroup.l, Pitch.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_SetPitch", Channelgroup.l, Pitch.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetPitch (Channelgroup.l, *Pitch.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetPitch", Channelgroup.l, *Pitch.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_Stop (Channelgroup.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_Stop", Channelgroup.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverrideVolume (Channelgroup.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverrideVolume", Channelgroup.l, Volume.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverridePaused (Channelgroup.l, paused.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverridePaused", Channelgroup.l, paused.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverrideFrequency (Channelgroup.l, Frequency.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverrideFrequency", Channelgroup.l, Frequency.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverridePan (Channelgroup.l, Pan.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverridePan", Channelgroup.l, Pan.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverrideMute (Channelgroup.l, Mute.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverrideMute", Channelgroup.l, Mute.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverrideReverbProperties (Channelgroup.l, *Prop.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverrideReverbProperties", Channelgroup.l, *Prop.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_Override3DAttributes (Channelgroup.l, *Pos.l, *Vel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_Override3DAttributes", Channelgroup.l, *Pos.l, *Vel.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_OverrideSpeakerMix (Channelgroup.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_OverrideSpeakerMix", Channelgroup.l, Frontleft.f, Frontright.f, Center.f, Lfe.f, Backleft.f, Backright.f, Sideleft.f, Sideright.f)
EndProcedure

Procedure.l FMOD_ChannelGroup_AddGroup (Channelgroup.l, Group.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_AddGroup", Channelgroup.l, Group.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetNumGroups (Channelgroup.l, *Numgroups.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetNumGroups", Channelgroup.l, *Numgroups.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetGroup (Channelgroup.l, Index.l, *Group.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetGroup", Channelgroup.l, Index.l, *Group.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetDSPHead (Channelgroup.l, *Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetDSPHead", Channelgroup.l, *Dsp.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_AddDSP (Channelgroup.l, Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_AddDSP", Channelgroup.l, Dsp.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetName (Channelgroup.l, *name.b, Namelen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetName", Channelgroup.l, *name.b, Namelen.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetNumChannels (Channelgroup.l, *Numchannels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetNumChannels", Channelgroup.l, *Numchannels.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetChannel (Channelgroup.l, Index.l, *channel.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetChannel", Channelgroup.l, Index.l, *channel.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetSpectrum (Channelgroup.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, Windowtype.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetSpectrum", Channelgroup.l, *Spectrumarray.f, Numvalues.l, Channeloffset.l, Windowtype.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetWaveData (Channelgroup.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetWaveData", Channelgroup.l, *Wavearray.f, Numvalues.l, Channeloffset.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_SetUserData (Channelgroup.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_SetUserData", Channelgroup.l, userdata.l)
EndProcedure

Procedure.l FMOD_ChannelGroup_GetUserData (Channelgroup.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_ChannelGroup_GetUserData", Channelgroup.l, *userdata.l)
EndProcedure

Procedure.l FMOD_DSP_Release (Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_Release", Dsp.l)
EndProcedure

Procedure.l FMOD_DSP_GetSystemObject (Dsp.l, *system.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetSystemObject", Dsp.l, *system.l)
EndProcedure

Procedure.l FMOD_DSP_AddInput (Dsp.l, Target.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_AddInput", Dsp.l, Target.l)
EndProcedure

Procedure.l FMOD_DSP_DisconnectFrom (Dsp.l, Target.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_DisconnectFrom", Dsp.l, Target.l)
EndProcedure

Procedure.l FMOD_DSP_Remove (Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_Remove", Dsp.l)
EndProcedure

Procedure.l FMOD_DSP_GetNumInputs (Dsp.l, *Numinputs.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetNumInputs", Dsp.l, *Numinputs.l)
EndProcedure

Procedure.l FMOD_DSP_GetNumOutputs (Dsp.l, *Numoutputs.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetNumOutputs", Dsp.l, *Numoutputs.l)
EndProcedure

Procedure.l FMOD_DSP_GetInput (Dsp.l, Index.l, *Input_.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetInput", Dsp.l, Index.l, *Input_.l)
EndProcedure

Procedure.l FMOD_DSP_GetOutput (Dsp.l, Index.l, *Output.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetOutput", Dsp.l, Index.l, *Output.l)
EndProcedure

Procedure.l FMOD_DSP_SetInputMix (Dsp.l, Index.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetInputMix", Dsp.l, Index.l, Volume.f)
EndProcedure

Procedure.l FMOD_DSP_GetInputMix (Dsp.l, Index.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetInputMix", Dsp.l, Index.l, Volume.f)
EndProcedure

Procedure.l FMOD_DSP_SetInputLevels (Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetInputLevels", Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_DSP_GetInputLevels (Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetInputLevels", Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_DSP_SetOutputMix (Dsp.l, Index.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetOutputMix", Dsp.l, Index.l, Volume.f)
EndProcedure

Procedure.l FMOD_DSP_GetOutputMix (Dsp.l, Index.l, Volume.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetOutputMix", Dsp.l, Index.l, Volume.f)
EndProcedure

Procedure.l FMOD_DSP_SetOutputLevels (Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetOutputLevels", Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_DSP_GetOutputLevels (Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetOutputLevels", Dsp.l, Index.l, Speaker.l, *Levels.f, Numlevels.l)
EndProcedure

Procedure.l FMOD_DSP_SetActive (Dsp.l, Active.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetActive", Dsp.l, Active.l)
EndProcedure

Procedure.l FMOD_DSP_GetActive (Dsp.l, *Active.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetActive", Dsp.l, *Active.l)
EndProcedure

Procedure.l FMOD_DSP_SetBypass (Dsp.l, Bypass.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetBypass", Dsp.l, Bypass.l)
EndProcedure

Procedure.l FMOD_DSP_GetBypass (Dsp.l, *Bypass.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetBypass", Dsp.l, *Bypass.l)
EndProcedure

Procedure.l FMOD_DSP_Reset (Dsp.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_Reset", Dsp.l)
EndProcedure

Procedure.l FMOD_DSP_SetParameter (Dsp.l, Index.l, Value.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetParameter", Dsp.l, Index.l, Value.f)
EndProcedure

Procedure.l FMOD_DSP_GetParameter (Dsp.l, Index.l, *Value.f, *Valuestr.b, Valuestrlen.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetParameter", Dsp.l, Index.l, *Value.f, *Valuestr.b, Valuestrlen.l)
EndProcedure

Procedure.l FMOD_DSP_GetNumParameters (Dsp.l, *Numparams.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetNumParameters", Dsp.l, *Numparams.l)
EndProcedure

Procedure.l FMOD_DSP_GetParameterInfo (Dsp.l, Index.l, *name.b, *label.b, *description.b, Descriptionlen.l, *min.f, *max.f)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetParameterInfo", Dsp.l, Index.l, *name.b, *label.b, *description.b, Descriptionlen.l, *min.f, *max.f)
EndProcedure

Procedure.l FMOD_DSP_ShowConfigDialog (Dsp.l, hwnd.l, Show.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_ShowConfigDialog", Dsp.l, hwnd.l, Show.l)
EndProcedure

Procedure.l FMOD_DSP_GetInfo (Dsp.l, *name.b, *version.l, *Channels.l, *Configwidth.l, *Configheight.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetInfo", Dsp.l, *name.b, *version.l, *Channels.l, *Configwidth.l, *Configheight.l)
EndProcedure

Procedure.l FMOD_DSP_SetDefaults (Dsp.l, Frequency.f, Volume.f, Pan.f, Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetDefaults", Dsp.l, Frequency.f, Volume.f, Pan.f, Priority.l)
EndProcedure

Procedure.l FMOD_DSP_GetDefaults (Dsp.l, *Frequency.f, *Volume.f, *Pan.f, *Priority.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetDefaults", Dsp.l, *Frequency.f, *Volume.f, *Pan.f, *Priority.l)
EndProcedure

Procedure.l FMOD_DSP_SetUserData (Dsp.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_SetUserData", Dsp.l, userdata.l)
EndProcedure

Procedure.l FMOD_DSP_GetUserData (Dsp.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_DSP_GetUserData", Dsp.l, *userdata.l)
EndProcedure

Procedure.l FMOD_Geometry_Release (Gemoetry.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_Release", Gemoetry.l)
EndProcedure

Procedure.l FMOD_Geometry_AddPolygon (Geometry.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l, NumVertices.l, *Vertices.l, *PolygonIndex.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_AddPolygon", Geometry.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l, NumVertices.l, *Vertices.l, *PolygonIndex.l)
EndProcedure

Procedure.l FMOD_Geometry_GetNumPolygons (Geometry.l, *NumPolygons.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetNumPolygons", Geometry.l, *NumPolygons.l)
EndProcedure

Procedure.l FMOD_Geometry_GetMaxPolygons (Geometry.l, *MaxPolygons.l, *MaxVertices.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetMaxPolygons", Geometry.l, *MaxPolygons.l, *MaxVertices.l)
EndProcedure

Procedure.l FMOD_Geometry_GetPolygonNumVertices (Geometry.l, PolygonIndex.l, *NumVertices.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetPolygonNumVertices", Geometry.l, PolygonIndex.l, *NumVertices.l)
EndProcedure

Procedure.l FMOD_Geometry_SetPolygonVertex (Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetPolygonVertex", Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.l)
EndProcedure

Procedure.l FMOD_Geometry_GetPolygonVertex (Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetPolygonVertex", Geometry.l, PolygonIndex.l, VertexIndex.l, *Vertex.l)
EndProcedure

Procedure.l FMOD_Geometry_SetPolygonAttributes (Geometry.l, PolygonIndex.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetPolygonAttributes", Geometry.l, PolygonIndex.l, DirectOcclusion.f, ReverbOcclusion.f, DoubleSided.l)
EndProcedure

Procedure.l FMOD_Geometry_GetPolygonAttributes (Geometry.l, PolygonIndex.l, *DirectOcclusion.f, *ReverbOcclusion.f, *DoubleSided.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetPolygonAttributes", Geometry.l, PolygonIndex.l, *DirectOcclusion.f, *ReverbOcclusion.f, *DoubleSided.l)
EndProcedure

Procedure.l FMOD_Geometry_SetActive (Geometry.l, Active.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetActive", Geometry.l, Active.l)
EndProcedure

Procedure.l FMOD_Geometry_GetActive (Geometry.l, *Active.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetActive", Geometry.l, *Active.l)
EndProcedure

Procedure.l FMOD_Geometry_SetRotation (Geometry.l, *Forward.l, *Up.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetRotation", Geometry.l, *Forward.l, *Up.l)
EndProcedure

Procedure.l FMOD_Geometry_GetRotation (Geometry.l, *Forward.l, *Up.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetRotation", Geometry.l, *Forward.l, *Up.l)
EndProcedure

Procedure.l FMOD_Geometry_SetPosition (Geometry.l, *Position.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetPosition", Geometry.l, *Position.l)
EndProcedure

Procedure.l FMOD_Geometry_GetPosition (Geometry.l, *Position.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetPosition", Geometry.l, *Position.l)
EndProcedure

Procedure.l FMOD_Geometry_SetScale (Geometry.l, *Scale_.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetScale", Geometry.l, *Scale_.l)
EndProcedure

Procedure.l FMOD_Geometry_GetScale (Geometry.l, *Scale_.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetScale", Geometry.l, *Scale_.l)
EndProcedure

Procedure.l FMOD_Geometry_Save (Geometry.l, _data.l, *_dataSize.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_Save", Geometry.l, _data.l, *_dataSize.l)
EndProcedure

Procedure.l FMOD_Geometry_SetUserData (Geometry.l, userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_SetUserData", Geometry.l, userdata.l)
EndProcedure

Procedure.l FMOD_Geometry_GetUserData (Geometry.l, *userdata.l)
  ProcedureReturn CallFunction(fmodLib, "FMOD_Geometry_GetUserData", Geometry.l, *userdata.l)
EndProcedure


;-#############################
;-############################# from fmod_errors
;-#############################

Procedure.s FMOD_ErrorString(errcode.l)
  Protected FMOD_ErrorString.s
  
  Select errcode
    Case #FMOD_OK:                         FMOD_ErrorString = "No errors."
    Case #FMOD_ERR_ALREADYLOCKED:          FMOD_ErrorString = "Tried to call lock a second time before unlock was called. "
    Case #FMOD_ERR_BADCOMMAND:             FMOD_ErrorString = "Tried to call a function on a data type that does not allow this type of functionality (ie calling Sound::lock on a streaming sound). "
    Case #FMOD_ERR_CDDA_DRIVERS:           FMOD_ErrorString = "Neither NTSCSI nor ASPI could be initialised. "
    Case #FMOD_ERR_CDDA_INIT:              FMOD_ErrorString = "An error occurred while initialising the CDDA subsystem. "
    Case #FMOD_ERR_CDDA_INVALID_DEVICE:    FMOD_ErrorString = "Couldn;t find the specified device. "
    Case #FMOD_ERR_CDDA_NOAUDIO:           FMOD_ErrorString = "No audio tracks on the specified disc. "
    Case #FMOD_ERR_CDDA_NODEVICES:         FMOD_ErrorString = "No CD/DVD devices were found. "
    Case #FMOD_ERR_CDDA_NODISC:            FMOD_ErrorString = "No disc present in the specified drive. "
    Case #FMOD_ERR_CDDA_READ:              FMOD_ErrorString = "A CDDA read error occurred. "
    Case #FMOD_ERR_CHANNEL_ALLOC:          FMOD_ErrorString = "Error trying to allocate a channel. "
    Case #FMOD_ERR_CHANNEL_STOLEN:         FMOD_ErrorString = "The specified channel has been reused to play another sound. "
    Case #FMOD_ERR_COM:                    FMOD_ErrorString = "A Win32 COM related error occured. COM failed to initialize or a QueryInterface failed meaning a Windows codec or driver was not installed properly. "
    Case #FMOD_ERR_DMA:                    FMOD_ErrorString = "DMA Failure.  See debug output for more information. "
    Case #FMOD_ERR_DSP_CONNECTION:         FMOD_ErrorString = "DSP connection error.  Connection possibly caused a cyclic dependancy. "
    Case #FMOD_ERR_DSP_FORMAT:             FMOD_ErrorString = "DSP Format error.  A DSP unit may have attempted to connect to this network with the wrong format. "
    Case #FMOD_ERR_DSP_NOTFOUND:           FMOD_ErrorString = "DSP connection error.  Couldn;t find the DSP unit specified. "
    Case #FMOD_ERR_DSP_RUNNING:            FMOD_ErrorString = "DSP error.  Cannot perform this operation while the network is in the middle of running.  This will most likely happen if a connection or disconnection is attempted in a DSP callback. "
    Case #FMOD_ERR_DSP_TOOMANYCONNECTIONS: FMOD_ErrorString = "DSP connection error.  The unit being connected to or disconnected should only have 1 input or output. "
    Case #FMOD_ERR_FILE_BAD:               FMOD_ErrorString = "Error loading file. "
    Case #FMOD_ERR_FILE_COULDNOTSEEK:      FMOD_ErrorString = "Couldn;t perform seek operation.  This is a limitation of the medium (ie netstreams) or the file format. "
    Case #FMOD_ERR_FILE_EOF:               FMOD_ErrorString = "End of file unexpectedly reached while trying to read essential data (truncated data?). "
    Case #FMOD_ERR_FILE_NOTFOUND:          FMOD_ErrorString = "File not found. "
    Case #FMOD_ERR_FILE_UNWANTED:          FMOD_ErrorString = "Unwanted file access occured."
    Case #FMOD_ERR_FORMAT:                 FMOD_ErrorString = "Unsupported file or audio format. "
    Case #FMOD_ERR_HTTP:                   FMOD_ErrorString = "A HTTP error occurred. This is a catch-all for HTTP errors not listed elsewhere. "
    Case #FMOD_ERR_HTTP_ACCESS:            FMOD_ErrorString = "The specified resource requires authentication or is forbidden. "
    Case #FMOD_ERR_HTTP_PROXY_AUTH:        FMOD_ErrorString = "Proxy authentication is required to access the specified resource. "
    Case #FMOD_ERR_HTTP_SERVER_ERROR:      FMOD_ErrorString = "A HTTP server error occurred. "
    Case #FMOD_ERR_HTTP_TIMEOUT:           FMOD_ErrorString = "The HTTP request timed out. "
    Case #FMOD_ERR_INITIALIZATION:         FMOD_ErrorString = "FMOD was not initialized correctly to support this function. "
    Case #FMOD_ERR_INITIALIZED:            FMOD_ErrorString = "Cannot call this command after System::init. "
    Case #FMOD_ERR_INTERNAL:               FMOD_ErrorString = "An error occured that wasnt supposed to.  Contact support. "
    Case #FMOD_ERR_INVALID_ADDRESS:        FMOD_ErrorString = "On Xbox 360, this memory address passed to FMOD must be physical, (ie allocated with XPhysicalAlloc.)"
    Case #FMOD_ERR_INVALID_FLOAT:          FMOD_ErrorString = "Value passed in was a NaN, Inf or denormalized float."
    Case #FMOD_ERR_INVALID_HANDLE:         FMOD_ErrorString = "An invalid object handle was used. "
    Case #FMOD_ERR_INVALID_PARAM:          FMOD_ErrorString = "An invalid parameter was passed to this function. "
    Case #FMOD_ERR_INVALID_SPEAKER:        FMOD_ErrorString = "An invalid speaker was passed to this function based on the current speaker mode. "
    Case #FMOD_ERR_INVALID_VECTOR:         FMOD_ErrorString = "The vectors passed in are not unit length, or perpendicular."
    Case #FMOD_ERR_IRX:                    FMOD_ErrorString = "PS2 only.  fmodex.irx failed to initialize.  This is most likely because you forgot to load it. "
    Case #FMOD_ERR_MEMORY:                 FMOD_ErrorString = "Not enough memory or resources. "
    Case #FMOD_ERR_MEMORY_IOP:             FMOD_ErrorString = "PS2 only.  Not enough memory or resources on PlayStation 2 IOP ram. "
    Case #FMOD_ERR_MEMORY_SRAM:            FMOD_ErrorString = "Not enough memory or resources on console sound ram. "
    Case #FMOD_ERR_MEMORY_CANTPOINT:       FMOD_ErrorString = "Can;t use FMOD_OPENMEMORY_POINT on non PCM source data, or non mp3/xma/adpcm data if FMOD_CREATECOMPRESSEDSAMPLE was used."
    Case #FMOD_ERR_NEEDS2D:                FMOD_ErrorString = "Tried to call a command on a 3d sound when the command was meant for 2d sound. "
    Case #FMOD_ERR_NEEDS3D:                FMOD_ErrorString = "Tried to call a command on a 2d sound when the command was meant for 3d sound. "
    Case #FMOD_ERR_NEEDSHARDWARE:          FMOD_ErrorString = "Tried to use a feature that requires hardware support.  (ie trying to play a VAG compressed sound in software on PS2). "
    Case #FMOD_ERR_NEEDSSOFTWARE:          FMOD_ErrorString = "Tried to use a feature that requires the software engine.  Software engine has either been turned off, or command was executed on a hardware channel which does not support this feature. "
    Case #FMOD_ERR_NET_CONNECT:            FMOD_ErrorString = "Couldn;t connect to the specified host. "
    Case #FMOD_ERR_NET_SOCKET_ERROR:       FMOD_ErrorString = "A socket error occurred.  This is a catch-all for socket-related errors not listed elsewhere. "
    Case #FMOD_ERR_NET_URL:                FMOD_ErrorString = "The specified URL couldn;t be resolved. "
    Case #FMOD_ERR_NOTREADY:               FMOD_ErrorString = "Operation could not be performed because specified sound is not ready. "
    Case #FMOD_ERR_OUTPUT_ALLOCATED:       FMOD_ErrorString = "Error initializing output device, but more specifically, the output device is already in use and cannot be reused. "
    Case #FMOD_ERR_OUTPUT_CREATEBUFFER:    FMOD_ErrorString = "Error creating hardware sound buffer. "
    Case #FMOD_ERR_OUTPUT_DRIVERCALL:      FMOD_ErrorString = "A call to a standard soundcard driver failed, which could possibly mean a bug in the driver or resources were missing or exhausted. "
    Case #FMOD_ERR_OUTPUT_FORMAT:          FMOD_ErrorString = "Soundcard does not support the minimum features needed for this soundsystem (16bit stereo output). "
    Case #FMOD_ERR_OUTPUT_INIT:            FMOD_ErrorString = "Error initializing output device. "
    Case #FMOD_ERR_OUTPUT_NOHARDWARE:      FMOD_ErrorString = "FMOD_HARDWARE was specified but the sound card does not have the resources nescessary to play it. "
    Case #FMOD_ERR_OUTPUT_NOSOFTWARE:      FMOD_ErrorString = "Attempted to create a software sound but no software channels were specified in System::init. "
    Case #FMOD_ERR_PAN:                    FMOD_ErrorString = "Panning only works with mono or stereo sound sources. "
    Case #FMOD_ERR_PLUGIN:                 FMOD_ErrorString = "An unspecified error has been  = ed from a 3rd party plugin. "
    Case #FMOD_ERR_PLUGIN_MISSING:         FMOD_ErrorString = "A requested output, dsp unit type or codec was not available. "
    Case #FMOD_ERR_PLUGIN_RESOURCE:        FMOD_ErrorString = "A resource that the plugin requires cannot be found. (ie the DLS file for MIDI playback) "
    Case #FMOD_ERR_RECORD:                 FMOD_ErrorString = "An error occured trying to initialize the recording device. "
    Case #FMOD_ERR_REVERB_INSTANCE:        FMOD_ErrorString = "Specified Instance in FMOD_REVERB_PROPERTIES couldn;t be set. Most likely because another application has locked the EAX4 FX slot. "
    Case #FMOD_ERR_SUBSOUNDS:              FMOD_ErrorString = "The error occured because the sound referenced contains subsounds.  (ie you cannot play the parent sound as a static sample, only its subsounds.) "
    Case #FMOD_ERR_SUBSOUND_ALLOCATED:     FMOD_ErrorString = "This subsound is already being used by another sound, you cannot have more than one parent to a sound.  Null out the other parent;s entry first. "
    Case #FMOD_ERR_TAGNOTFOUND:            FMOD_ErrorString = "The specified tag could not be found or there are no tags. "
    Case #FMOD_ERR_TOOMANYCHANNELS:        FMOD_ErrorString = "The sound created exceeds the allowable input channel count.  This can be increased using the maxinputchannels parameter in System::setSoftwareFormat."
    Case #FMOD_ERR_UNIMPLEMENTED:          FMOD_ErrorString = "Something in FMOD hasn;t been implemented when it should be! contact support! "
    Case #FMOD_ERR_UNINITIALIZED:          FMOD_ErrorString = "This command failed because System::init or System::setDriver was not called. "
    Case #FMOD_ERR_UNSUPPORTED:            FMOD_ErrorString = "A command issued was not supported by this object.  Possibly a plugin without certain callbacks specified. "
    Case #FMOD_ERR_UPDATE:                 FMOD_ErrorString = "On PS2, System::update was called twice in a row when System::updateFinished must be called first. "
    Case #FMOD_ERR_VERSION:                FMOD_ErrorString = "The version number of this file format is not supported. "
    Case #FMOD_ERR_EVENT_FAILED:           FMOD_ErrorString = "An Event failed to be retrieved, most likely due to ;just fail' being specified as the max playbacks behaviour."
    Case #FMOD_ERR_EVENT_INTERNAL:         FMOD_ErrorString = "An error occured that wasn;t supposed to.  See debug log for reason."
    Case #FMOD_ERR_EVENT_NAMECONFLICT:     FMOD_ErrorString = "A category with the same name already exists."
    Case #FMOD_ERR_EVENT_NOTFOUND:         FMOD_ErrorString = "The requested event, event group, event category or event property could not be found."
    Default:                               FMOD_ErrorString = "Unknown error."
  EndSelect
  
  ProcedureReturn FMOD_ErrorString
EndProcedure

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -----------------------------------------------