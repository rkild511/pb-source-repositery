; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6049&highlight=
; Author: Froggerprogger (updated for PB4.00 by blbltheworm)
; Date: 03. May 2003
; OS: Windows
; Demo: Yes


; Note by Andre, 11-Jan-2004:
; You need the FMod.dll for using this example, get the latest version
; with PB wrapper on www.PureArea.net !

; Realtime-Keyboard 0.3 by Froggerprogger 
; 
; This little program lets us play on a Gadget-Keyboard! 
; The sound is generated in realtime by a callback-procedure using the _stdcall-version 
; of FMOD.DLL and the PB-Import for it. You'll get both here : 
; 
;     http://www.fmod.de/files/PureFmod_1.1.zip 
; 
; --> Just copy the extracted FMOD.DLL into this program's directory and 
; --> copy the FMOD.DLL-IMPORT in your PBs UserLibrary-Directory and restart PB. 
; 
; New features in 0.3: 
; - fixed a bug that comes along with the newer PB-versions 
; - some new comments 
; - try typ 1 osznum 4 and oszdiff 7 -> FAT !! 
; 
; New features in 0.2: 
; - the design has changed a bit 
; - the oscillators can also produce a FAT SAW-Waveform now!! 
; 
; (c) 2003, Sven Kurras, www.schalldesign.com 


Declare.l Buffercallback(hStream.l, BufferPointer.l, length.l, param.l) 
Declare Info(a.s,b.s,c.l) 
Declare _CreateGadgetlist(hWnd) 

InitKeyboard() 

#FMOD_MONO = $20:#FMOD_STEREO = $40:#FMOD_16BIT = $10 ; From FMOD-API 

Define.f osz1, amp_max, osz1start 
Define.l samplerate, osz_num, bits, buffer_num, buffer_size, wavetype, channels, change, Resume, osz_diff 

samplerate = 44100 : bits = 16 : channels = 2 
buffer_num = 4 : buffer_size = 2048 ;increase _size to 2048 | 4096 etc. when sound output is not continuous 
osz_num = 4 : osz_diff = 12 ;play with these parametes through the gadgets to affect the sound! 
osz1start = Int(440/osz_num) ;start-FQ and the basis of all following (440 Hz) 
osz1.f = osz1start * Pow(Pow(2.0 , 1/12),3000); osz1 is the actual heard basisFQ for the first Oszillator - here not audible (to high) = pause 
amp_max = Int(Pow(2, bits) / osz_num / 2)-1 ;to prevent clipping - not really the correct algor. yet, but ok 
osz_typ.b = 1 ;There are two modes, "Sinus" = 0 and "Saw" = 1, toggled by a Gadget. 
Global Dim Saw_lastW.w(osz_num) 

FSOUND_SetBufferSize(125) 
If FSOUND_Init(samplerate,32,0) = 0 : Info("","Couldn't initialize FSOUND.",0):End:EndIf 

If channels = 2 
    wavetype = #FMOD_STEREO | #FMOD_16BIT 
Else 
    wavetype = #FMOD_MONO | #FMOD_16BIT 
EndIf 

;Create stream and set callback to @BufferCallback 
hStream.l = FSOUND_Stream_Create(@Buffercallback(), buffer_num*buffer_size, wavetype, samplerate, 0) 
        If hStream = 0 : Info("","Cannot create stream.",0):End:EndIf 
;Start playing 
hChannel.l = FSOUND_Stream_Play(-1, hStream) 
        If hChannel = 0 : Info("","Cannot play stream.",0):End:EndIf 

hWnd=OpenWindow(1,0,0,720,125,"Realtime-Keyboard 0.2",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
_CreateGadgetlist(hWnd) ;'paints' the Keyboard 

;Plays the beginning of 'the Entertainer' 
;FQ *|/ (12th Square of 2) is +|- 1 Semitone, so FQ 
;Semitone 0 is the a in the middle of the keyboard here 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),-7) : Delay(250) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),-6) : Delay(250) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),-5) : Delay(250) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),3) : Delay(500) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),-5) : Delay(250) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),3) : Delay(500) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),-5) : Delay(250) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),3) : Delay(500) 
osz1 = osz1start * Pow(Pow(2.0 , 1/12),3000) ;just an easy-made pause (as above) - can't you hear it ? ;-) 

Resume=1 
While Resume 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      Resume=0 
      FSOUND_Close() ;Closes FMOD 
    Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 999 
            osz1 = osz1start * Pow(Pow(2.0 , 1/12),3000); pause 
            
          Case 998 
            osz_diff-1 : If osz_diff < 1 : osz_diff = 12 : EndIf; changes relative osz-tune 
            _CreateGadgetlist(hWnd);redraw 
            
          Case 997 
            osz_typ!1 ;toggles osz_typ between 0 and 1 
            _CreateGadgetlist(hWnd);redraw 
            
          Case 996 
            osz_num-1 : If osz_num < 1 : osz_num = 5 : EndIf; changes number of oszs 
            amp_max = Int((Pow(2, bits) / osz_num) / 2)-1 ;to prevent clipping 
            Global Dim Saw_lastW.w(osz_num) 
            osz1start = Int(440/osz_num) ;start-FQ and the basis of all following 
            _CreateGadgetlist(hWnd);redraw 
            
          Default ;HERE THE KEYBOARD-KEYS ARE HANDLED 
            _CreateGadgetlist(hWnd);redraw 
            Diff = EventGadget()-22 ;sets the offset, so it works like a transpose 
            osz1 = osz1start * Pow(Pow(2.0 , 1/12),Diff); set osz1 - the current frequenz - to the selected tone 
        EndSelect 
  EndSelect 
Wend 
Info("","Hope you enjoyed it."+Chr(13)+Chr(13)+"(c) 2002, Sven Kurras, www.schalldesign.com",0) 
End 
  
Procedure.l Buffercallback(*hStream.l, *BufferPointer.l, length.l, param.l)  
    Shared osz1, amp_max 
    Shared samplerate, osz_num, bits, channels, osz_diff 
    Shared time_run.l, signed_word_last.l 
    Shared osz_typ.b 

    sample_act=0 
    sample_last=length-1 
    bytes_per_sample = Int(bits/8) * channels 

    Select osz_typ 
    Case 0 
        While sample_act < sample_last 
            signed_word.w=0 ;it will be signed for 'signed-PCM-Output' automatically, because it's type signed WORD 
            osz_act_fq_amp.f=amp_max ;set actual max_amp to global max_amp 
            For osz_act = 0 To osz_num-1    
                osz_act_fq.f = Pow(Pow(2.0 , 1/12), osz_diff * osz_act) * osz1 ;sets the actual_fq 
                signed_word + Int(osz_act_fq_amp * Sin(2 * #PI * osz_act_fq * time_run/samplerate));a little maths 
                time_run + 1 
                If time_run > samplerate ;to prevent overflow 
                  If time_run <= 100 And time_run > 0 ;to prevent clipping caused by time_run-reset 
                    time_run=0 
                  EndIf 
                EndIf 
            Next 
            For j=0 To channels-1 ;OK, not really stereo, just Dual-Mono ;-) 
              PokeW(*BufferPointer + sample_act+Int(bits/8)*j, signed_word) 
            Next 
            sample_act + bytes_per_sample 
        Wend 
    
    Case 1 ;a SAW-Wave 
        While sample_act < sample_last 
            signed_word.w = 0 
            osz_act_fq_amp.f=amp_max ;set actual max_amp to global max_amp 
            For osz_act = 0 To osz_num-1 
                osz_act_fq.f = Pow(Pow(2.0 , 1/12), osz_diff * osz_act) * osz1  ;sets the actual_fq 
                upstep.w = Int(osz_act_fq * osz_act_fq_amp / samplerate) 
                Saw_lastW(osz_act) + upstep 
                If Saw_lastW(osz_act) > Int(osz_act_fq_amp) 
                    Saw_lastW(osz_act) = Int(-1 * osz_act_fq_amp) 
                EndIf 
                signed_word + Saw_lastW(osz_act) 
            Next 
            For j=0 To channels-1 
              PokeW(*BufferPointer + sample_act+Int(bits/8)*j, signed_word) 
            Next 
            sample_act + bytes_per_sample 
        Wend 
    EndSelect 
    ProcedureReturn 1 
EndProcedure 

Procedure _CreateGadgetlist(hWnd) 
  Shared osz_diff, osz_typ, osz_num 
  CreateGadgetList(hWnd) 
  For oktaven=1 To 4 
    For part2=5 To 7 Step 2 
      run=0 
      For part=1 To part2 
        i+1 
        k+12 
        run!1 
        FreeGadget(i) 
        ButtonGadget(i,k,10+20*run,12+13*run,40,"") 
      Next 
      k+12 
    Next 
  Next 
  run=1 : i+1 : k+12 
  FreeGadget(i) 
  ButtonGadget(i,k,10+20*run,12+13*run,40,"") 
  ;FreeGadget(999) 
  ButtonGadget(999,300,78,120,20,"stop sound") 
  FreeGadget(900) 
  TextGadget(900, 440, 78, 260, 20, " ______ oszillator section ______" , #PB_Text_Center) 
  FreeGadget(997) 
  ButtonGadget(997,440,103,80,20,"typ (0-1): "+Str(osz_typ)) 
  FreeGadget(998) 
  ButtonGadget(998,620,103,80,20,"diff (1-12): "+Str(osz_diff)) 
  FreeGadget(996) 
  ButtonGadget(996,530,103,80,20,"num (1-5): "+Str(osz_num)) 
EndProcedure 

Procedure Info(a.s , b.s, c.l) ;this one really spares time ;-) 
  MessageRequester(a,b,c) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
