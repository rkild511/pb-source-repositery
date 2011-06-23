; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5762&highlight=
; Author: GPI (updated for PB4.00 by blbltheworm)
; Date: 08. April 2003
; OS: Windows
; Demo: No


; Change on 09-Nov-2003 by Andre:
; Renamed SetMasterVolume/GetMasterVolume to SetMasterVolume2/GetMasterVolume2 to
; avoid conflicts with an userlib


;-MIXERCONTROL 
Structure MIXERCONTROL 
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
;-MIXERCONTROLDETAILSUNSIGNED 
Structure MIXERCONTROLDETAILSUNSIGNED 
  dwValue.l 
EndStructure 

Procedure ZeroMemory(adr,len) 
  For i=0 To len-1 
    PokeB(adr+i,0) 
  Next 
EndProcedure 

Procedure GetMasterVolumeControl(mixer,*control.MIXERCONTROL) 
  line.MIXERLINE 
  controls.mixerlinecontrols 
  
  ZeroMemory(line, SizeOf(MIXERLINE)) 
  line\cbStruct = SizeOf(MIXERLINE) 
  line\dwComponentType = #MIXERLINE_COMPONENTTYPE_DST_SPEAKERS; 
  Result = mixerGetLineInfo_(mixer,line,#MIXER_GETLINEINFOF_COMPONENTTYPE) 
  If Result = #MMSYSERR_NOERROR 
    ZeroMemory(controls, SizeOf(mixerlinecontrols)); 
    controls\cbStruct = SizeOf(mixerlinecontrols); 
    controls\dwLineID = line\dwLineID; 
    controls\cControls = 1; 
    controls\dwControlType = #MIXERCONTROL_CONTROLTYPE_VOLUME; 
    controls\cbmxctrl = SizeOf(MIXERCONTROL); 
    controls\pamxctrl = *control; 
    Result = mixerGetLineControls_(mixer,controls,#MIXER_GETLINECONTROLSF_ONEBYTYPE) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
Procedure GetMasterMuteControl(mixer,*control.MIXERCONTROL) 
  line.MIXERLINE 
  controls.mixerlinecontrols 
  
  ZeroMemory(line, SizeOf(MIXERLINE)) 
  line\cbStruct = SizeOf(MIXERLINE) 
  line\dwComponentType = #MIXERLINE_COMPONENTTYPE_DST_SPEAKERS; 
  Result = mixerGetLineInfo_(mixer,line,#MIXER_GETLINEINFOF_COMPONENTTYPE) 
  If Result = #MMSYSERR_NOERROR 
    ZeroMemory(controls, SizeOf(mixerlinecontrols)); 
    controls\cbStruct = SizeOf(mixerlinecontrols); 
    controls\dwLineID = line\dwLineID; 
    controls\cControls = 1; 
    controls\dwControlType = #MIXERCONTROL_CONTROLTYPE_MUTE; 
    controls\cbmxctrl = SizeOf(MIXERCONTROL); 
    controls\pamxctrl = *control; 
    Result = mixerGetLineControls_(mixer,controls,#MIXER_GETLINECONTROLSF_ONEBYTYPE) 
  EndIf 
  ProcedureReturn Result 
EndProcedure 
Procedure SetMasterVolume2(mixer,value) 
  MasterVolume.MIXERCONTROL 
  Details.MIXERCONTROLDETAILS 
  UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED 
  code.l 
  
  code=GetMasterVolumeControl(mixer,MasterVolume) 
  If code=#MMSYSERR_NOERROR 
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS); 
    Details\dwControlID = MasterVolume\dwControlID; 
    Details\cChannels = 1;  // set all channels 
    Details\Item = 0; 
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED); 
    Details\paDetails = @UnsignedDetails; 
    UnsignedDetails\dwValue=value 
    code=mixerSetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE); 
  EndIf 
  ProcedureReturn code 
EndProcedure 
Procedure SetMasterMute(mixer,value) 
  MasterVolume.MIXERCONTROL 
  Details.MIXERCONTROLDETAILS 
  UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED 
  code.l 
  
  code=GetMasterMuteControl(mixer,MasterVolume) 
  If code=#MMSYSERR_NOERROR 
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS); 
    Details\dwControlID = MasterVolume\dwControlID; 
    Details\cChannels = 1;  // set all channels 
    Details\Item = 0; 
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED); 
    Details\paDetails = @UnsignedDetails; 
    UnsignedDetails\dwValue=value 
    code=mixerSetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE); 
  EndIf 
  ProcedureReturn code 
EndProcedure 
Procedure GetMasterVolume2(mixer) 
  MasterVolume.MIXERCONTROL 
  Details.MIXERCONTROLDETAILS 
  UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED 
  code.l 
  
  code=GetMasterVolumeControl(mixer,MasterVolume) 
  If code=#MMSYSERR_NOERROR 
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS); 
    Details\dwControlID = MasterVolume\dwControlID; 
    Details\cChannels = 1;  // set all channels 
    Details\Item = 0; 
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED); 
    Details\paDetails = @UnsignedDetails; 
    code=mixerGetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE); 
  EndIf 
  ProcedureReturn UnsignedDetails\dwValue 
EndProcedure 
Procedure GetMasterMute(mixer) 
  MasterVolume.MIXERCONTROL 
  Details.MIXERCONTROLDETAILS 
  UnsignedDetails.MIXERCONTROLDETAILSUNSIGNED 
  code.l 
  
  code=GetMasterMuteControl(mixer,MasterVolume) 
  If code=#MMSYSERR_NOERROR 
    Details\cbStruct = SizeOf(MIXERCONTROLDETAILS); 
    Details\dwControlID = MasterVolume\dwControlID; 
    Details\cChannels = 1;  // set all channels 
    Details\Item = 0; 
    Details\cbDetails = SizeOf(MIXERCONTROLDETAILSUNSIGNED); 
    Details\paDetails = @UnsignedDetails; 
    code=mixerGetControlDetails_(mixer,Details, #MIXER_SETCONTROLDETAILSF_VALUE); 
  EndIf 
  ProcedureReturn UnsignedDetails\dwValue 
EndProcedure 
Procedure GetMasterVolumeMinimum(mixer) 
  Volume.MIXERCONTROL 
  GetMasterVolumeControl(mixer,Volume) 
  ProcedureReturn Volume\lMinimum 
EndProcedure 
Procedure GetMasterVolumeMaximum(mixer) 
  Volume.MIXERCONTROL 
  GetMasterVolumeControl(mixer,Volume) 
  ProcedureReturn Volume\lMaximum 
EndProcedure 

;little example 
Debug Hex(GetMasterVolume2(0)) 

;normal mixer 0 is the default soundcard 
Debug mixerGetNumDevs_(); -Numbers of Soundcards 
; mixer can be 0 to (mixerGetNumDevs()-1) 

For i=0 To $FF00 Step $100 
  SetMasterVolume2(0,i) 
  Delay(100) 
Next 

For i=0 To 3 
  Debug "mute" 
  SetMasterMute(0,1) 
  Delay(1000) 
  Debug "sound" 
  SetMasterMute(0,0) 
  Delay(1000) 
Next 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
