; English forum:
; Author: Danilo
; Date: 21. January 2003
; OS: Windows
; Demo: No


; an userlibrary is needed for CallCOM(), look at PureArea.net

#CLSCTX_INPROC_SERVER  = $1
#CLSCTX_INPROC_HANDLER = $2
#CLSCTX_LOCAL_SERVER   = $4
#CLSCTX_REMOTE_SERVER  = $10
#CLSCTX_ALL = (#CLSCTX_INPROC_SERVER|#CLSCTX_INPROC_HANDLER|#CLSCTX_LOCAL_SERVER|#CLSCTX_REMOTE_SERVER)

Procedure InitSpeech()
   Shared VoiceObject
   CoInitialize_(0)
   If CoCreateInstance_(?CLSID_SpVoice, 0, #CLSCTX_ALL, ?IID_ISpVoice, @VoiceObject) = 0
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
   Shared VoiceObject
   length = Len(String)*2+10
   ;*mem = AllocateMemory(1,length,0); old PB-version
   *mem = AllocateMemory(length)     ; changed by Falko
   MultiByteToWideChar_(#CP_ACP ,0,String,-1,*mem,length)
   CallCOM(80,VoiceObject,*mem,0,0)
EndProcedure

Procedure CloseSpeech()
   Shared VoiceObject
   CallCOM(08,VoiceObject)
   CoUninitialize_()
EndProcedure


; start code
If InitSpeech()
   Speak("Hello e b s!")               : Delay(300)
   Speak("Iam your speaking computer") : Delay(100)
   Speak("Welcome to a new world!")    : Delay(100)
   Speak("Lets dance")                 : Delay(1000)
   Speak("Greetings... Danilo")
   CloseSpeech()
Else
   MessageRequester("ERROR","MS Speech API not installed",0)
EndIf
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -