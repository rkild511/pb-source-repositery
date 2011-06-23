; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6039&highlight=
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 02. May 2003
; OS: Windows
; Demo: Yes


; Note by Andre, 11-Jan-2004:
; You need the FMod.dll for using this example, get the latest version
; with PB wrapper on www.PureArea.net !


; >> Sinemouse 0.1 
; FMOD-callback-example by Froggerprogger (02. May 03) 
; You'll need the PB-Import for the fmod.dll and the fmod.dll itself in it's stdcall-version to run this code. 
; Get it from here: http://www.fmod.de/files/PureFmod_1.1.zip

;____________ Declaration 
Declare.l Buffercallback(hStream.l, BufferPointer.l, length.l, param.l) 
Declare mb(a.s,b.s,c.l) 
Global samplerate.l 
Global bits.l 
Global channels.l 
Global max_samplevalue.l 
Global angle.f 
Global fq.l 
Global mpos.POINT 

;____________ Initialization 
#FMOD_MONO = $20:#FMOD_STEREO = $40:#FMOD_16BIT = $10 ;so there's no need for the .res-file 
samplerate = 44100 : bits = 16 : channels = 2 
If channels = 2:wavetype = #FMOD_STEREO | #FMOD_16BIT:Else:wavetype = #FMOD_MONO | #FMOD_16BIT:EndIf 
buffer_size = 2048 * Int(bits/8) * channels 
max_samplevalue = Int(Pow(2,bits)/2) - 1  

FSOUND_SetBufferSize(100) ; -> de- or increase, if you want or need to 
If FSOUND_Init(samplerate,1,0) = 0 : mb("","Couldn't initialize FSOUND.",0):End:EndIf 

;____________ Create and start the callback-stream 
hStream.l = FSOUND_Stream_Create(@Buffercallback(), buffer_size, wavetype, samplerate, 0) 
        If hStream = 0 : mb("","Cannot create stream.",0):End:EndIf 
hChannel.l = FSOUND_Stream_Play(-1, hStream) 
        If hChannel = 0 : mb("","Cannot play stream.",0):End:EndIf 

;____________ Open a window and show some data on it 
hWnd = OpenWindow(1,0,0,240,20,"Sinemouse 0.1",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(hWnd) 
TextGadget(1,0,0,150,20,"") 
TextGadget(2,150,0,20,20,"=") 
TextGadget(3,170,0,70,20,"",#PB_Text_Right) 

;____________ ||: Beginning of main loop 
Repeat 
  SetGadgetText(1,"Y-Mouseposition: " + Str(mpos\y)) 
  SetGadgetText(3,Str(fq)+" Hz") 
  Delay(1) 
Until WindowEvent() = #PB_Event_CloseWindow 
;____________ End of main loop :|| 


;____________ Quit 
FSOUND_Stream_Stop(hStream) 
FSOUND_Close() 
End 



;============================================ PROCEDURES ============================================ 

;___________ Buffer-Callback 
Procedure.l BufferCallback(*hStream.l, *BufferPointer.l, length.l, param.l)  
    sample_act=0  
    sample_last=length-1 
    bytes_per_sample = Int(bits/8) * channels 

        While sample_act < sample_last 
            GetCursorPos_(mpos) 
            fq.l = mpos\y * 2 + 90 ; -> so frequences from 90 Hz to (screenheight*2) Hz 
            angle.f + 2 * #PI * (fq / samplerate) ; -> increase radian measure for the 'complex pointer' 
            If angle > 2 * #PI : angle - 2*#PI : EndIf ; -> avoid big (+ inaccurate ) floats 
            signed_word.w = Int(max_samplevalue * Sin(angle)) ; -> calculate the real (sine) part of the cp 

            For offset=0 To channels -1; (ok, not really stereo, just 'multichannel-mono' ;-) 
              PokeW(*BufferPointer + sample_act+Int(bits/8) * offset, signed_word) ; -> poke the same actual value for each channel 
            Next 
            sample_act + bytes_per_sample ; -> next sample 
        Wend 
    ProcedureReturn 1 
EndProcedure 

;_________ MB (this one really spares time !) 
Procedure MB(a.s , b.s, c.l) 
  MessageRequester(a,b,c) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
