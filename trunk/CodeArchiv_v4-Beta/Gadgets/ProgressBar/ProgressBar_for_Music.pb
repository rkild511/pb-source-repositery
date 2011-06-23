; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2302&highlight=
; Author: zomtex2003 (updated for PB4.00 by blbltheworm)
; Date: 16. September 2003
; OS: Windows
; Demo: No


; Hinweise:
; Ihr braucht die FMOD.DLL und die LIB
; und müßt bei MySoundFile$ das ogg-File ändern! 

#WINDOW_1         = 1 
#SOUND_1          = 1 

MySoundFile$ = "c:\mp3\01-Warriors Of The World United.ogg" 

Global EndPlay.b 
EndPlay = 1 

Declare UpdateSpec(value) 

Structure SpecArray 
  value.f[512] 
EndStructure 

If OpenWindow(#WINDOW_1, 0, 0, 915, 420, "MySpectrum", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  AddKeyboardShortcut(#WINDOW_1, #PB_Shortcut_Escape, 200) 
  If CreateGadgetList(WindowID(#WINDOW_1)) 
    b = 8 
    x = b 
    For i = 1 To 128 
      ProgressBarGadget(i,  x,  10, b, 400, 0, 255, #PB_ProgressBar_Smooth | #PB_ProgressBar_Vertical) 
      SetGadgetColor(i, RGB(0, 0, i + 100), RGB(0, 0, 0)) 
      x = x + 7 
    Next i 
  EndIf 
EndIf 


FSOUND_SetBufferSize(125) 
If FSOUND_Init(44100, 32, 0) 
  hSoundFile = FSOUND_Stream_OpenFile(MySoundFile$, 0, 0) 
  FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), #True) 
  FSOUND_Stream_Play(#SOUND_1, hSoundFile) 
EndIf 

hMyThread = CreateThread(@UpdateSpec(),0) 

Repeat 
EventID = WaitWindowEvent() 
If EventID = #PB_Event_Menu 
  If EventMenu() = 200 
    EndPlay = 0 
  EndIf 
EndIf 
Until EventID = #PB_Event_CloseWindow ; And EndPlay = 0 
;WaitThread(hMyThread) 
FSOUND_Stream_Stop(hSoundFile) 
FSOUND_DSP_SetActive(FSOUND_DSP_GetFFTUnit(), #False) 
FSOUND_Close() 

Procedure UpdateSpec(value.l) 
  While EndPlay 
    If FSOUND_DSP_GetActive(FSOUND_DSP_GetFFTUnit()) 
        CopyMemory(FSOUND_DSP_GetSpectrum(), hSpec.SpecArray, 4*512) 
    EndIf 

    Delay(100) 

    For i = 1 To 128 
      SetGadgetState(i,  (199 - Pow(0.0000001, hSpec\value[i])  * 199)) 
    Next i 
  Wend 
EndProcedure 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
