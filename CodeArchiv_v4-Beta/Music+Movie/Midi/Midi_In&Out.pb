; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8504&highlight=
; Author: einander
; Date: 27. November 2003
; OS: Windows
; Demo: No


; Here is a simple code to read and play on MIDI channel 0. 
; When the program is running, play on your MIDI keyboard. 

; This example is very short and is only for monitoring the keyboard input. 

; To monitoring a midifile is necessary a MIDI parser. 
; I'ts not too complicated to program, but you must first understand SMF, the standard
; MIDIfile format, to deal with Data Chunks, Headers, Variable Lenght format and other
; MIDIfile stuff. 
; Is a very interesting work; the MIDI File Spec is old but still useful. 
; http://ourworld.compuserve.com/homepages/mark_clay/midi.htm 

; You can do a search in Google with "MIDI file parser" To found the basics, And here
; is a starting point: 
; http://www.ec.vanderbilt.edu/computermusic/musc216site/MIDI.resources.html 


;MIDI IN & OUT 
;By Einander - 27 Nov -2003 
;************************************************ 
;Only works with a MIDI Keyboard attached 
;************************************************ 
Global Chromatic$ 
Chromatic$="C C#D EbE F F#G AbA BbB C " 

Procedure.s MIDI_Note(Note)      ; returns note's name 
    ProcedureReturn Mid(Chromatic$,(Note % 12)*2+1,2) 
EndProcedure 

Procedure MIDIin(hMi, wMsg, Data1, Data2) 
    Select wMsg    ; process MIDI in events 
    Case #MM_MIM_DATA 
        Status = Data1 & 255 
        If Status =144 
            NT=(Data1 >> 8) & 255 
            Vel= (Data1 >> 16) & 255 
            If Vel 
                Debug "Note On" 
            Else 
                Debug "Note Off" 
            EndIf 
            Debug " Note : "+MIDI_Note(NT)+" "+Str(NT) 
            Debug "  Vel : " + Str(Vel) 
       EndIf 
    EndSelect 
EndProcedure 
;_______________________________________________________________________________________ 
Instrument=24   ;************* choose any instrument from 0 to 127 ************** 
OutDev.l : InDev.l 
PokeL(@OutDev, 0)  : PokeL(@InDev, 1) 
If midiInOpen_(@hMi, InDev, @MIDIin(), 0, #CALLBACK_FUNCTION) = #MMSYSERR_NOERROR 
    If midiInStart_(hMi) <> #MMSYSERR_NOERROR : MessageRequester("Error","Can't start MIDI IN",0) :End:  EndIf 
Else 
    MessageRequester("Error","Can't open MIDI IN",0) : End 
EndIf 
midiOutOpen_(@hMo, OutDev, 0, 0, 0) 
midiOutShortMsg_(hMo, 192  | instrument<<8 ) 
If hMi And hMo 
    If midiConnect_(hMi, hMo, 0) = 0 
        Debug "MIDI OK!  Play MIDI KEYBOARD" 
    Else 
        MessageRequester("Error","Can't connect MIDI",0) :End: 
    EndIf 
EndIf 
OpenWindow(0, x,y,600,400, "PB MIDI Test", #WS_OVERLAPPEDWINDOW | #PB_Window_WindowCentered) 
Repeat 
    EventID.l = WaitWindowEvent() 
Until EventID = #PB_Event_CloseWindow 
midiDisconnect_(hMi, hMo, 0) 
While midiInClose_(hMi) = #MIDIERR_STILLPLAYING : Wend 
While midiOutClose_(hMo) = #MIDIERR_STILLPLAYING : Wend 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
