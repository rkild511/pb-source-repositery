; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8504&highlight=
; Author: einander (updated for PB4.00 by blbltheworm)
; Date: 28. November 2003
; OS: Windows
; Demo: No


; Play midinotes without MIDI keyboard, using the mouse and only MIDI out. 
; It's tested only in WinXP; maybe in Win9x or in small screens the keyboard
; needs some adjustment. Improvements welcomed! 


;PB MIDI Keyboard - by Einander - Registered user 
;november 2003 - PB 3.80 

;Thanks to Danilo for the MIDIout routines 

Global hMIDIOut,KBD,WinDC,Keep$,Detach 
Global xKBD,yKBD,wKBD,wKey,hKey,W2,W3,W4,W5,W7,H2 
Global Chromatic$,GRAY,W2,W3 
GRAY=RGB(110,110,110) 

;Choose here your sharp / flat preferences  - 2 chars for each note 
Chromatic$="C C#D EbE F F#G AbA BbB C "    ; mixed # b 
;Chromatic$="C DbD EbE F GbG AbA BbB C "   ;all flats 
;Chromatic$="C C#D D#E F F#G G#A A#B C "   ;all sharps 

Procedure Mod(a,b) 
  If b = 0: b = 1:EndIf 
  ProcedureReturn a-a/b*b 
EndProcedure 

Procedure Even(num) 
  Protected n.f 
  n.f=num : n=n/2 
  If num/2=n 
    ProcedureReturn 1 
  Else 
    ProcedureReturn 0 
  EndIf 
EndProcedure 

Procedure Get(SRC,X,Y,WI,HE)    ; Get source image - returns image handle 
   IMGdc = CreateCompatibleDC_(SRC)  
   hIMG = CreateImage(0,WI,HE)          
   SelectObject_(IMGdc,hIMG)  
   BitBlt_(IMGdc,0,0,WI,HE,SRC,X,Y,#SRCCOPY) 
   ProcedureReturn IMGdc 
EndProcedure 

Procedure Put(SRC,X,Y,DEST,MODE) ; Draws image from SRC TO DEST (DEST = GetDC_(SrcID))  
    BitBlt_(DEST,X,Y,wKBD,hKey,SRC,0,0,MODE) 
EndProcedure 

Procedure.s MIDI_NT(Note)     ; naming one note 
    ProcedureReturn Mid(Chromatic$,Mod(Note,12)*2+1,2) 
EndProcedure 

Procedure.s MIDI_2_Notes(Note$)   ;naming multiple notes 
    For i=0 To Len(Note$)-1 
        Note=PeekB(@Note$+i) 
        Nt$=Nt$+Trim(Mid(Chromatic$,Mod(Note,12)*2+1,2))+Str(Note/12)+" " 
   Next i 
   ProcedureReturn Nt$ 
EndProcedure 

Procedure InMous(X,Y,x1,y1,mx,my)  
   ProcedureReturn mx > X And my > Y And mx < x1 And my < y1 
EndProcedure 

Procedure MX()  ;x mouse pos 
    ProcedureReturn WindowMouseX(0) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
EndProcedure 

Procedure MY() ;y mouse pos 
  ProcedureReturn WindowMouseY(0) - GetSystemMetrics_(#SM_CYCAPTION) - GetSystemMetrics_(#SM_CYSIZEFRAME) 
EndProcedure 

Procedure MIDIKbd()  ;returns selected MIDInote 
    mx=MX():my=MY() 
    If InMous(0,0,wKBD-1,hKey,mx,my) 
        NT=Mod(mx/wKey,7)    ;MIDInote 
        OV=(mx/wKey)/7*12     ; octave 
        Select NT 
            Case 0 :Note=OV 
            Case 1 :Note=OV+2 
            Case 2:Note=OV+4 
            Case 3:Note=OV+5 
            Case 4:Note=OV+7 
            Case 5:Note=OV+9 
            Case 6:Note=OV+11 
        EndSelect 
        If my>H2 :ProcedureReturn Note : EndIf 
        If NT=0 Or NT=3  Or Note<126: ProcedureReturn Note+1:EndIf  
        st=Mod(mx/W2,14) 
        If Even(st) Or NT=2 Or NT=6:  ProcedureReturn Note-1 :EndIf 
     EndIf 
    ProcedureReturn -1 
EndProcedure 

Procedure DrawKey(Note,C1)     ;draw midi keys 
    If C1=#Black: C2=#White : Else : C2=C1 : EndIf 
    OV=Note/12 
    NT=Mod(Note,12) 
    X=OV*W7 
    If NT=1 Or NT=3 Or NT=6 Or NT=8 Or NT=10 
        If NT>5:A=1:EndIf 
        X+(NT+A)*W2+1 
        Box (X+W3,1,W2,H2-3,C1) 
    Else 
        Select NT 
            Case 0 :  Box(X+1,0,W5,H2,C2) 
            Case 2 :  X+wKey:    Box(X+W3,0,W4,H2,C2) 
            Case 4:  X+wKey*2:  Box(X+W3,0,W5,H2,C2) 
            Case 5:  X+wKey*3 : Box(X+1,0,W5,H2,C2) 
            Case 7:  X+wKey*4:  Box(X+W3,0,W4,H2,C2) 
            Case 9:  X+wKey*5 : Box(X+W3,0,W4,H2,C2) 
            Case 11: X+wKey*6 :Box(X+W3,0,W5,H2,C2) 
        EndSelect 
       Box (X+1,0+H2,wKey-1,H2,C2) 
    EndIf 
    If Note=127:Box(X+W3,0,W5,H2,C2) :EndIf 
EndProcedure 

Procedure MIDIOutMessage(iStatus,iChannel,iData1,iData2) 
    dwMessage = iStatus | iChannel | iData1<<8 | iData2 <<16 
    ProcedureReturn midiOutShortMsg_(hMIDIOut, dwMessage) ; 
EndProcedure 

Procedure SetInstrument(Channel,Instrument) ;Instrument from 0 to 127 
    MIDIOutMessage($C0,  Channel, Instrument, 0) 
EndProcedure 

Procedure PlayNote(Channel,Note,Loudness)  ;Loudness 0 = no sound 
    MIDIOutMessage($90, Channel, Note , Loudness) 
EndProcedure 

Procedure AllOff()   ; All notes off - silence 
  MIDIOutMessage(176, 1, 123,0) 
EndProcedure 

Procedure.s SortString(A$) 
    Le=Len(A$)-1 
    Global Dim Srt.b(Le) 
    For i = 0 To Le 
        Srt(i)=PeekB(@A$+i)    
    Next 
    SortArray.b(Srt(),0) 
    For i = 0 To Le 
        PokeB(@A$+i,Srt(i))    
    Next 
    ProcedureReturn A$ 
EndProcedure 

Procedure KeepNote(Note,Sustain) 
    If Note>-1 
        A$=Chr(Note) 
        If FindString(Keep$, A$, 1)=0 
            Keep$=Keep$+A$ 
        EndIf 
    EndIf 
    If Len(Keep$)>Sustain 
        For i = 1 To Len(Keep$)-Sustain 
            PlayNote(1,Asc(Mid(Keep$,i,1)),0) 
        Next i  
        Keep$=Right(Keep$,Sustain) 
    EndIf 
    If Len(Keep$) 
        StatusBarText(0,1,"Sustained: "+MIDI_2_Notes(SortString(Keep$))+" (Ctrl or right MousButt  to stop sustain)") 
    Else 
        StatusBarText(0,1,"Sustained: None") 
    EndIf 
EndProcedure 

Procedure WindowCallback(Message, lParam, wParam) 
    If Message = #WM_PAINT 
        Box(0,0,wKBD+1,hKey+2,GRAY)  ;background & space between keys 
        Put(KBD,0,0,WinDC,#SRCCOPY) ;redraw KBD 
    EndIf 
    ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 
;______________________________________________________________________________- 

    _X=GetSystemMetrics_(#SM_CXSCREEN)    
    xKBD=25 : yKBD=120 ; key width it's up to screen width 
    wKey=(_X-50)/77 : wKey+Even(wKey+1)  ;white key width always even 
    hKey=70                     ;white key height 
    wKBD=wKey*75        ;keyboard width 
    H2=hKey/2                 ;half key height, to find black or white keys  
    W2=wKey/2               ;half  key width, for black keys 
    W3=wKey/3               ;black keys position 
    W4=wKey-W3*2+1   ; ditto 
    W5=wKey-W3           ; ditto 
    W7=wKey*7              ;7 keys = one octave width 
    #MouseOver=1:MouseOver=0 
    #Sustain=5 
    hWnd= OpenWindow(0,xKBD,yKBD,wKBD,hKey+22,"    PB MIDI Keyboard 0.01", #PB_Window_SystemMenu ) 
    CreateGadgetList(hWnd) 
    CheckBoxGadget(#MouseOver, 520, WindowHeight(0)-20, 140, 20,"Mouse Over (Alt)") 
    SpinGadget(#Sustain, 450, WindowHeight(0)-18, 30, 18,0,12) 
    SetGadgetState(#MouseOver,0) 
    SetGadgetState(#Sustain,3) 
    SetGadgetText(#Sustain,Str(GetGadgetState(#Sustain))) 
    WinDC=GetDC_(hWnd)  
    SetWindowPos_(hWnd,#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) ;always on top 
    CreateStatusBar(0, WindowID(0))  ; selected note info 
    AddStatusBarField(120) 
    AddStatusBarField(330) 
    StartDrawing(WindowOutput(0)) 
    Box(0,0,wKBD+1,hKey+2,GRAY)  ;background & space between keys 
    Loudness=120   ; choose from 0 To 127  : Loudness 0 = no sound 

For i=0 To 127                                   ;draw full MIDIkeyboard 
    DrawKey(i,#Black) 
Next i 

KBD=Get(WinDC,0,0,wKBD,hKey)    ;get MIDIKeyboard image 
If midiOutOpen_(@hMIDIOut,0, 0, 0, 0) = #MMSYSERR_NOERROR 
    Instrument=0                        ; choose any Instrument from 0 to 127 
    SetInstrument(1,Instrument)  ; many sound cards have  sounds only from 0 to 108 
    SetWindowCallback(@WindowCallback()) 
    Repeat 
        Event = WaitWindowEvent() 
        Note=MIDIKbd() 
        If EventGadget() = #Sustain 
            Sustain=GetGadgetState(#Sustain) 
            SetGadgetText(#Sustain,Str(Sustain)) 
            KeepNote(-1,Sustain)  
            WindowEvent()      ; absolutely needed to avoid endless event-loops 
        ElseIf EventGadget()=#MouseOver 
            MouseOver=GetGadgetState(#MouseOver) 
        EndIf 
        If Event=#WM_RBUTTONDOWN Or GetAsyncKeyState_(#VK_LCONTROL)=-32767 
            AllOff(): Keep$="" :StatusBarText(0,1,"") 
            KeepNote(-1,0) 
        ElseIf GetAsyncKeyState_(#VK_MENU)=-32767    ;tecla ALT 
            MouseOver=Abs(MouseOver-1)  ; switch 1 / 0 
            SetGadgetState(#MouseOver,MouseOver) 
        EndIf 
        If Note<0   ; no selected key 
            StatusBarText(0, 0, "") 
        Else 
            If Event=    #WM_LBUTTONDOWN  
                PlayNote(1,Note,0) 
                PlayNote(1,Note,Loudness) 
                KeepNote(Note,Sustain) 
            EndIf 
            If Note+1<>Detach 
                StatusBarText(0, 0, MIDI_NT(MIDI)+Str(Note/12)+"   MIDI Note: "+Str(Note)) 
                If Detach 
                    DrawKey(Detach-1,#Black) 
                    If GetGadgetState(#Sustain)=0  : PlayNote(1,Detach-1,0) : EndIf 
                EndIf 
                If MouseOver=1 : PlayNote(1,Note,Loudness) :KeepNote(Note,Sustain) : EndIf 
                DrawKey(Note,#Red) 
            EndIf 
            Detach=Note+1 
        EndIf 
    Until Event= #PB_Event_CloseWindow  
    midiOutClose_(hMIDIOut) 
Else 
    MessageRequester("ERROR","No midi device found",0) 
EndIf 
End   

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = ----
; EnableXP
