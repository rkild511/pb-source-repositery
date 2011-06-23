;**
;* <b>Info:</b> Change the Volume _
;* Original from jaPBe IncludesPack _
;* change for PB4 by ts-soft _
;* _
;* This rountines can handle also system with more than one Soundcard. _
;* All functions are 0 based. Only GetSoundcardCount() is 1 based. _
;* That means, when GetSoundcardCount() returns 5, you can use 0 - 5 For all the other procedures _
;* _
;* <b>NOTE:</b> This change the System-Settings of the mixers, so you should restore the old settings! _
;* (For restoring, please use GetVolume() And SetVolume(), Not GetVolume1000() And SetVolume1000(), _
;* because this routines calculate the values For the new range And basis). _
;* _
;* <b>NOTE 2:</b> For GetVolume() and SetVolume() you must check GetVolumeMinimum() and GetVolumeMaximum(), _
;* because this can change from System To system (also from Mixer-Type And Soundcard). _
;* Use GetVolume1000() And SetVolume1000()

Structure MIXERLINE_
  cbStruct.l
  dwDestination.l
  dwSource.l
  dwLineID.l
  fdwLine.l
  dwUser.l
  dwComponentType.l
  cChannels.l
  cConnections.l
  cControls.l
  szShortName.b[#MIXER_SHORT_NAME_CHARS]
  szName.b[#MIXER_LONG_NAME_CHARS]
  ;target
  dwType.l
  dwDeviceID.l
  wMid.w
  wPid.w
  vDriverVersion.l
  szPname.b[#MAXPNAMELEN]
EndStructure

Structure MIXERCONTROL_
  cbStruct.l
  dwControlID.l
  dwControlType.l
  fdwControl.l
  cMultipleItems.l
  szShortName.b[#MIXER_SHORT_NAME_CHARS]
  szName.b[#MIXER_LONG_NAME_CHARS];
  lMinimum.l
  lMaximum.l
  dwMinimum.l
  dwMaximum.l
  Reserved.l[6];
  cSteps.l
  cbCustomData.l;
  dwReserved.l[6];
EndStructure

Structure MIXERCONTROLDETAILSUNSIGNED_
  dwValue.l
EndStructure

#Mixer_Type_Headphone =#MIXERLINE_COMPONENTTYPE_DST_HEADPHONES
#Mixer_Type_Speaker   =#MIXERLINE_COMPONENTTYPE_DST_SPEAKERS
#Mixer_Type_WaveIn    =#MIXERLINE_COMPONENTTYPE_DST_WAVEIN
#Mixer_Type_WaveOut   =#MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT
#Mixer_Type_Aux       =#MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY
#Mixer_Type_CD        =#MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC
#Mixer_Type_Microphone=#MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE
#Mixer_Type_Midi      =#MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER

;** GetVolumeName
;* Returns the intern name of the selected Soundcard and Mixer-Type.
Procedure.s GetVolumeName(mixer,Type)
  Protected line.MIXERLINE_
  Protected controls.MIXERLINECONTROLS
  Protected Result.l

  RtlZeroMemory_(line, SizeOf(MIXERLINE_))
  line\cbStruct = SizeOf(MIXERLINE_)
  line\dwComponentType = type
  Result = mixerGetLineInfo_(mixer,line,#MIXER_GETLINEINFOF_COMPONENTTYPE)
  If Result = #MMSYSERR_NOERROR
    ProcedureReturn PeekS(@line\szPname,#MIXER_LONG_NAME_CHARS)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

Procedure GetVolumeControl(mixer,Type,*control.MIXERCONTROL_)
  Protected line.MIXERLINE_
  Protected controls.MIXERLINECONTROLS
  Protected Result.l

  RtlZeroMemory_(line, SizeOf(MIXERLINE_))
  line\cbStruct = SizeOf(MIXERLINE_)
  line\dwComponentType = type
  Result = mixerGetLineInfo_(mixer,line,#MIXER_GETLINEINFOF_COMPONENTTYPE)
  If Result = #MMSYSERR_NOERROR
    RtlZeroMemory_(controls, SizeOf(MIXERLINECONTROLS));
    controls\cbStruct = SizeOf(MIXERLINECONTROLS);
    controls\dwLineID = line\dwLineID;
    controls\cControls = 1;
    controls\dwControlType = #MIXERCONTROL_CONTROLTYPE_VOLUME;
    controls\cbmxctrl = SizeOf(MIXERCONTROL_);
    controls\pamxctrl = *control;
    Result = mixerGetLineControls_(mixer,controls,#MIXER_GETLINECONTROLSF_ONEBYTYPE)
  EndIf
  ProcedureReturn Result
EndProcedure

Procedure GetMuteControl(mixer,Type,*control.MIXERCONTROL_)
  Protected line.MIXERLINE_
  Protected controls.MIXERLINECONTROLS
  Protected Result.l

  RtlZeroMemory_(line, SizeOf(MIXERLINE_))
  line\cbStruct = SizeOf(MIXERLINE_)
  line\dwComponentType = type
  Result = mixerGetLineInfo_(mixer,line,#MIXER_GETLINEINFOF_COMPONENTTYPE)
  If Result = #MMSYSERR_NOERROR
    RtlZeroMemory_(controls, SizeOf(MIXERLINECONTROLS));
    controls\cbStruct = SizeOf(MIXERLINECONTROLS);
    controls\dwLineID = line\dwLineID;
    controls\cControls = 1;
    controls\dwControlType = #MIXERCONTROL_CONTROLTYPE_MUTE;
    controls\cbmxctrl = SizeOf(MIXERCONTROL_);
    controls\pamxctrl = *control;
    Result = mixerGetLineControls_(mixer,controls,#MIXER_GETLINECONTROLSF_ONEBYTYPE)
  EndIf
  ProcedureReturn Result
EndProcedure

;** SetVolume
;* With this routines can you set the Volume of the soundcard/mixer
Procedure SetVolume(mixer,Type,value)
  Protected MasterVolume.MIXERCONTROL_
  Protected Details.MIXERCONTROLDETAILS
  Protected UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED_
  Protected code.l

  code=GetVolumeControl(mixer,type,MasterVolume)
  If code=#MMSYSERR_NOERROR
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS);
    Details\dwControlID = MasterVolume\dwControlID;
    Details\cChannels = 1;  // set all channels
    Details\Item = 0;
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED_);
    Details\paDetails = @UnsignedDetails;
    UnsignedDetails\dwValue=value
    code=mixerSetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE);
  EndIf
  ProcedureReturn code
EndProcedure

;** SetMute
;* Change the mute-state of the soundcard/mixer-type
Procedure SetMute(mixer,Type,value)
  Protected MasterVolume.MIXERCONTROL_
  Protected Details.MIXERCONTROLDETAILS
  Protected UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED_
  Protected code.l

  code=GetMuteControl(mixer,type,MasterVolume)
  If code=#MMSYSERR_NOERROR
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS);
    Details\dwControlID = MasterVolume\dwControlID;
    Details\cChannels = 1;  // set all channels
    Details\Item = 0;
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED_);
    Details\paDetails = @UnsignedDetails;
    UnsignedDetails\dwValue=value
    code=mixerSetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE);
  EndIf
  ProcedureReturn code
EndProcedure

;** GetVolume
;* With this routines can you get the Volume of the soundcard/mixer
Procedure GetVolume(mixer,Type)
  Protected MasterVolume.MIXERCONTROL_
  Protected Details.MIXERCONTROLDETAILS
  Protected UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED_
  Protected code.l

  code=GetVolumeControl(mixer,type,MasterVolume)
  If code=#MMSYSERR_NOERROR
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS);
    Details\dwControlID = MasterVolume\dwControlID;
    Details\cChannels = 1;  // set all channels
    Details\Item = 0;
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED_);
    Details\paDetails = @UnsignedDetails;
    code=mixerGetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE);
  EndIf
  ProcedureReturn UnsignedDetails\dwValue
EndProcedure

;** GetMute
;* Get the mute-state of the soundcard/mixer-type
Procedure GetMute(mixer,Type)
  Protected MasterVolume.MIXERCONTROL_
  Protected Details.MIXERCONTROLDETAILS
  Protected UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED_
  Protected code.l

  code=GetMuteControl(mixer,type,MasterVolume)
  If code=#MMSYSERR_NOERROR
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS);
    Details\dwControlID = MasterVolume\dwControlID;
    Details\cChannels = 1;  // set all channels
    Details\Item = 0;
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED_);
    Details\paDetails = @UnsignedDetails;
    code=mixerGetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE);
  EndIf
  ProcedureReturn UnsignedDetails\dwValue
EndProcedure

;** GetVolumeMinimum
;* Returns the minimum range of the soundcard/mixer-type
Procedure GetVolumeMinimum(mixer,Type)
  Protected Volume.MIXERCONTROL_
  GetVolumeControl(mixer,type,Volume)
  ProcedureReturn Volume\lMinimum
EndProcedure

;** GetVolumeMaximum
;* Returns the maximum range of the soundcard/mixer-type
Procedure GetVolumeMaximum(mixer,Type)
  Protected Volume.MIXERCONTROL_
  GetVolumeControl(mixer,type,Volume)
  ProcedureReturn Volume\lMaximum
EndProcedure

;** SetVolume1000
;* Nearly the same like Get/SetVolume(), but with fixed range from 0 to 1000
Procedure SetVolume1000(mixer,Type,value)
  Protected min.l, max.l, width.l

  min=GetVolumeMinimum(mixer,type)
  max=GetVolumeMaximum(mixer,type)
  width=max-min
  SetVolume(mixer,type,min+(width*value/1000))
EndProcedure

;** GetVolume1000
;* Nearly the same like Get/SetVolume(), but with fixed range from 0 to 1000
Procedure GetVolume1000(mixer,Type)
  Protected min.l, max.l, width.l

  min=GetVolumeMinimum(mixer,type)
  max=GetVolumeMaximum(mixer,type)
  width=max-min
  ProcedureReturn (GetVolume(mixer,type)*1000/width)
EndProcedure

;** GetSoundcardCount
;* Returns the numbers of installed Soundcards on the system. _
;* This Value is 1 based
Procedure GetSoundcardCount()
  ProcedureReturn mixerGetNumDevs_ ()
EndProcedure


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 246
; FirstLine = 65
; Folding = AA-
; EnableXP
; HideErrorLog