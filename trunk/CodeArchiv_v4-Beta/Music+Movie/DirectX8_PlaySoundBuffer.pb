; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8786&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 18. December 2003
; OS: Windows
; Demo: No

; 
; example of playing a sound buffer with DirectX 8 
;   by Danilo in co-operation with www.MasterCreating.de 
; 
#DD_OK = 0 
#DS_OK = 0 

#DSBCAPS_LOCSOFTWARE   = $8 
#DSBCAPS_CTRLFREQUENCY = $20 
#DSBCAPS_CTRLVOLUME    = $80 
#DSBCAPS_CTRLPAN       = $40 

Structure WAVEFORMATEX 
wFormatTag.w        ; Waveform-audio format type. A complete list of format tags can be found in the Mmreg.h header file. For one- Or two-channel PCM data, this value should be WAVE_FORMAT_PCM. 
nChannels.w         ; Number of channels in the waveform-audio data. Monaural data uses one channel and stereo data uses two channels. 
nSamplesPerSec.l    ; Sample rate, in samples per second (hertz). If wFormatTag is WAVE_FORMAT_PCM, then common values for nSamplesPerSec are 8.0 kHz, 11.025 kHz, 22.05 kHz, and 44.1 kHz. For non-PCM formats, this member must be computed according to the manufacturer's specification of the format tag. 
nAvgBytesPerSec.l   ; Required average data-transfer rate, in bytes per second, for the format tag. If wFormatTag is WAVE_FORMAT_PCM, nAvgBytesPerSec should be equal to the product of nSamplesPerSec and nBlockAlign. For non-PCM formats, this member must be computed according to the manufacturer's specification of the format tag. 
nBlockAlign.w       ; Block alignment, in bytes. The block alignment is the minimum atomic unit of data for the wFormatTag format type. If wFormatTag is WAVE_FORMAT_PCM or WAVE_FORMAT_EXTENSIBLE, nBlockAlign must be equal to the product of nChannels and wBitsPerSample divided by 8 (bits per byte). For non-PCM formats, this member must be computed according to the manufacturer's specification of the format tag.  :Software must process a multiple of nBlockAlign bytes of Data at a time. Data written To And Read from a device must always start at the beginning of a block. For example, it is illegal To start playback of PCM Data in the middle of a sample (that is, on a non-block-aligned boundary). 
wBitsPerSample.w    ; Bits per sample for the wFormatTag format type. If wFormatTag is WAVE_FORMAT_PCM, then wBitsPerSample should be equal to 8 or 16. For non-PCM formats, this member must be set according to the manufacturer's specification of the format tag. If wFormatTag is WAVE_FORMAT_EXTENSIBLE, this value can be any integer multiple of 8. Some compression schemes cannot define a value for wBitsPerSample, so this member can be zero. 
cbSize.w            ; Size, in bytes, of extra format information appended to the end of the WAVEFORMATEX structure. This information can be used by non-PCM formats to store extra attributes for the wFormatTag. If no extra information is required by the wFormatTag, this member must be set to zero. For WAVE_FORMAT_PCM formats (and only WAVE_FORMAT_PCM formats), this member is ignored. 
EndStructure 

Structure DSBUFFERDESC 
dwSize.l            ; Size of the Structure 
dwFlags.l           ; Flags specifying the capabilities of the buffer 
dwBufferBytes.l     ; Size of the new buffer, in bytes. This value must be 0 when creating a buffer with the DSBCAPS_PRIMARYBUFFER flag. For secondary buffers, the minimum and maximum sizes allowed are specified by DSBSIZE_MIN and DSBSIZE_MAX, defined in Dsound.h. 
dwReserved.l        ; Must be 0 
*lpwfxFormat        ; Address of a WAVEFORMATEX or WAVEFORMATEXTENSIBLE structure specifying the waveform format for the buffer. 
guid3DAlgorithm.GUID; Unique identifier of the two-speaker virtualization algorithm to be used by DirectSound3D hardware emulation. If DSBCAPS_CTRL3D is not set in dwFlags, this member must be GUID_NULL (DS3DALG_DEFAULT). 
EndStructure 


Procedure Delete(*obj.IUnknown) 
  ProcedureReturn *obj\Release() 
EndProcedure 

Procedure Error_Msg(String.s) 
MessageRequester("Error",String.s,0) 
End 
EndProcedure 

hwnd = OpenWindow(0,0,0,200,200,"Sound",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(hwnd) 
  TextGadget    (1,10,10,180,15,"Frequency: 44100") 
  TrackBarGadget(2,10,25,180,20,0,441) 
  SetGadgetState(2,441) 
  TextGadget    (3,10,50,180,15,"Pan: 0") 
  TrackBarGadget(4,10,65,180,20,0,200) 
  SetGadgetState(4,100) 
  TextGadget    (5,10,90,180,15,"Volume: 10000") 
  TrackBarGadget(6,10,105,180,20,0,10000) 
  SetGadgetState(6,10000) 


If OpenLibrary(0,"DSOUND.DLL") = 0 
Error_Msg("Can't open direct Sound") 
EndIf 

*RA_DirectSound.IDirectSound8 

; create DS8 Sound Object 
Result.l = CallFunction(0,"DirectSoundCreate8",0,@*RA_DirectSound,0) 
If Result.l <> #DD_OK 
Error_Msg("Can't do DirectSoundCreate8 : " + Str(Result.l)) 
EndIf 

; Set Coop Level 
Result.l = *RA_DirectSound\SetCooperativeLevel(hwnd,1) 
If Result.l <> #DD_OK 
Error_Msg("Can't Set Coop Level : " + Str(Result.l)) 
EndIf 


; Setting up Primary Buffer 
dsbd.DSBUFFERDESC                          ; Set up structure 
dsbd\dwSize        = SizeOf(DSBUFFERDESC)  ; Save structure size 
dsbd\dwFlags       = 1                     ; It is the primary Buffer (see DSound.h) 
dsbd\dwBufferBytes = 0                     ; NULL ? Because primary Buffer must be Null 
dsbd\lpwfxFormat   = 0                     ; NULL ? ? ? <- ist ein Pointer 

Result.l = *RA_DirectSound\CreateSoundBuffer(@dsbd,@*pDSBPrimary.IDirectSoundBuffer,0) 
If Result.l <> #DD_OK 
Error_Msg("Can't Set up primary sound buffer : " + Str(Result)) 
EndIf 

#channels = 2 

wfx.WAVEFORMATEX                ; Wave Format Structure 
RtlZeroMemory_(@wfx,SizeOf(WAVEFORMATEX)); 
wfx\wFormatTag      = #WAVE_FORMAT_PCM; 
wfx\nChannels       = #channels ;dwPrimaryChannels; 
wfx\nSamplesPerSec  = 44100     ;dwPrimaryFreq; 
wfx\wBitsPerSample  = 16        ;dwPrimaryBitRate; 
wfx\nBlockAlign     = (wfx\wBitsPerSample / 8 * wfx\nChannels) 
wfx\nAvgBytesPerSec = (wfx\nSamplesPerSec * wfx\nBlockAlign) 

; secondary Buffer (see DSound.h) 
dsbd\dwFlags       = #DSBCAPS_LOCSOFTWARE|#DSBCAPS_CTRLVOLUME|#DSBCAPS_CTRLFREQUENCY|#DSBCAPS_CTRLPAN 
dsbd\dwBufferBytes = 10 * wfx\nAvgBytesPerSec ; alloc 10 Seconds 
dsbd\lpwfxFormat   = @wfx 

; CREATE Secondary Buffer 
Result.l = *RA_DirectSound\CreateSoundBuffer(@dsbd,@*pDSB.IDirectSoundBuffer,0) 
If Result.l <> #DD_OK 
Error_Msg("Can't Set up secondary sound buffer : " + Str(Result)) 
EndIf 

; ASK for DirectSoundBuffer8 Interface 
*DSB8.IDirectSoundBuffer8 = 0 
*pDSB\QueryInterface(?IID_DirectSoundBuffer8,@*DSB8) 
Delete(*pDSB) 

If *DSB8 = 0 
Error_Msg("Can't get DirectSoundBuffer8 Interface") 
EndIf 

#DSBLOCK_ENTIREBUFFER = $2 
If *DSB8\Lock(0,0,@lpvWrite,@dwLength,0,0,#DSBLOCK_ENTIREBUFFER) = #DS_OK 

  ; OK, now copy data in buffer... 

  Structure SOUND_BUFFER ; channels, each 16 bit 
    channel.w[#channels] 
  EndStructure 

  *Buffer.SOUND_BUFFER = lpvWrite 


  ; GENERATE SOUND DATA ;) 
        For a = 0 To dwLength/SizeOf(SOUND_BUFFER) 
            If b < $FFFF And flag = 0 
              b + 1000 
              c + 5000 
            Else 
              flag = 1 
              b - 50 
              c - 700 
              If b <= 0: b=0: flag = 0: EndIf 
            EndIf 
            *Buffer\channel[0] = b 
            *Buffer\channel[1] = c 
            *Buffer + SizeOf(SOUND_BUFFER) 
        Next a 
  ; GENERATE SOUND END 


  *DSB8\UnLock(lpvWrite,dwLength,0,0) 
  #DSBPLAY_LOOPING = $1 
  *DSB8\Play(0,0,#DSBPLAY_LOOPING) ; PLAYYYYY!!! 
EndIf 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      Quit = 1 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case 2 ; Frequency Control 
          Frequ = GetGadgetState(2) 
          SetGadgetText(1,"Frequency: "+Str(Frequ*100)) 
          *DSB8\SetFrequency(Frequ*100) 
        Case 4 ; Pan: Left <> Right 
          Pan = GetGadgetState(4)*100-10000 
          SetGadgetText(3,"Pan: "+Str(Pan)) 
          *DSB8\SetPan(Pan) 
        Case 6 ; Volume 
          Vol = GetGadgetState(6) 
          SetGadgetText(5,"Volume: "+Str(Vol)) 
          *DSB8\SetVolume(Vol-10000) 
      EndSelect 
  EndSelect 
Until Quit 

*DSB8\Stop() 

; Release/Delete Objects 
; (reversed order of creation) 
Delete(*DSB8) 
Delete(*pDSBPrimary) 
Delete(*RA_DirectSound) 

End 

DataSection 
  IID_DirectSoundBuffer8:  ; DSOUND.h 
    Data.l $6825A449 
    Data.w $7524,$4D82 
    Data.b $92,$0F,$50,$E3,$6A,$B3,$AB,$1E 
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
