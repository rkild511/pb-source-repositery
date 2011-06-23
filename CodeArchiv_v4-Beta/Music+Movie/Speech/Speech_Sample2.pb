; English forum:
; Author: Danilo
; Date: 21. January 2003
; OS: Windows
; Demo: No


; an userlibrary is needed for CallCOM(), look at PureArea.net

;-----------------------------------------
;-----------------------------------------
#CLSCTX_INPROC_SERVER  = $1
#CLSCTX_INPROC_HANDLER = $2
#CLSCTX_LOCAL_SERVER   = $4
#CLSCTX_REMOTE_SERVER  = $10
#CLSCTX_ALL = (#CLSCTX_INPROC_SERVER|#CLSCTX_INPROC_HANDLER|#CLSCTX_LOCAL_SERVER|#CLSCTX_REMOTE_SERVER)

Procedure FemaleVoice()
  ; Select Female Voice
  Shared SelectedVoice
  SelectedVoice = 0
EndProcedure

Procedure MaleVoice()
  ; Select Male Voice
  Shared SelectedVoice
  SelectedVoice = 1
EndProcedure

Procedure SetVoiceVolume(Volume)
  ; Set Voice Volume ( 0 - 100 )
  Shared CurrentVolume
  If Volume < 0 Or Volume > 100 : Volume = 100 : EndIf
  CurrentVolume = Volume
EndProcedure

Procedure SetVoiceSpeed(Speed)
  ; Set Speed of Voice
  ;                 0 = default speed
  ; values can be between -10 and 10
  Shared CurrentSpeed
  CurrentSpeed = Speed
EndProcedure

Procedure SetVoicePitch(Pitch)
  ; Set Voice Pitch
  ; values can be between -10 and 10
  Shared CurrentPitch
  If Pitch < -10 : Pitch = -10 : EndIf
  If Pitch >  10 : Pitch =  10 : EndIf
  CurrentPitch = Pitch
EndProcedure

Procedure InitSpeech()
   Shared VoiceObject
   CoInitialize_(0)
   If CoCreateInstance_(?CLSID_SpVoice, 0, #CLSCTX_ALL, ?IID_ISpVoice, @VoiceObject) = 0
      SetVoiceVolume(100)
      SetVoiceSpeed(0)
      SetVoicePitch(0)
      MaleVoice()
      ProcedureReturn 1
   Else
      ProcedureReturn 0
   EndIf
        DataSection
          CLSID_SpVoice:
            ;96749377-3391-11D2-9EE3-00C04F797396
            Data.l $96749377
            Data.w $3391,$11D2
            Data.b $9E,$E3,$00,$C0,$4F,$79,$73,$96
          IID_ISpVoice:
            ;6C44DF74-72B9-4992-A1EC-EF996E0422D4
            Data.l $6C44DF74
            Data.w $72B9,$4992
            Data.b $A1,$EC,$EF,$99,$6E,$04,$22,$D4
        EndDataSection
EndProcedure

Procedure Speak(String.s)
   Shared VoiceObject, SelectedVoice, CurrentVolume, CurrentSpeed, CurrentPitch
   ; Set Voice (male or female)
   If SelectedVoice = 1
      Text$ = "<voice required="+Chr(34)+"Gender=Male"+Chr(34)+">"+String
   Else
      Text$ = "<voice required="+Chr(34)+"Gender=Female"+Chr(34)+">"+String
   EndIf
   ; Set Volume
   Text$ = "<volume level="+Chr(34)+Str(CurrentVolume)+Chr(34)+"/>"+Text$
   ; Set Speed
   Text$ = "<rate absspeed="+Chr(34)+Str(CurrentSpeed)+Chr(34)+">"+Text$
   ; Set Pitch
   Text$ = "<pitch absmiddle="+Chr(34)+Str(CurrentPitch)+Chr(34)+"/>"+Text$

   length = Len(Text$)*2+10
   ;*mem = AllocateMemory(1,length,0); old PB-version
   *mem = AllocateMemory(length)     ;changed by Falko
   MultiByteToWideChar_(#CP_ACP ,0,Text$,-1,*mem,length)
   CallCOM(80,VoiceObject,*mem,0,0)
EndProcedure

Procedure CloseSpeech()
   Shared VoiceObject
   CallCOM(08,VoiceObject)
   CoUninitialize_()
EndProcedure

; Voices
Procedure Speaker_Danilo()
  MaleVoice()
  SetVoiceSpeed(-2)
  SetVoicePitch(3)
EndProcedure

Procedure Speaker_Jennifer()
  FemaleVoice()
  SetVoiceSpeed(-2)
  SetVoicePitch(10)
EndProcedure

Procedure Speaker_Mother()
  FemaleVoice()
  SetVoicePitch(-10)
  SetVoiceSpeed(0)
EndProcedure


; start code
If InitSpeech()
  Speaker_Danilo()
      Speak("Hello everybody!")               : Delay(100)
      Speak("my girlfriend is here too now") : Delay(100)
      Speak("Say hello - babe") : Delay(100)
  Speaker_Jennifer()
      Speak("Hi e b s - my name is Jennifer")
  Speaker_Danilo()
      Speak("Hey, my mother just returned from supermarket"): Delay(50)
      Speak("Say hello mom"): Delay(50)
  Speaker_Mother()
      Speak("Hi, iam the big mother")
  Speaker_Danilo()
      Speak("Greetings...")
     SetVoiceSpeed(-10)
     SetVoicePitch(-10)
      Speak("Danilo")
  CloseSpeech()
Else
   MessageRequester("ERROR","MS Speech API not installed",0)
EndIf
;-----------------------------------------
;-----------------------------------------

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; DisableDebugger