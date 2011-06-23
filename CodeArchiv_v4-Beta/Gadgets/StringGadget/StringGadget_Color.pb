; German forum:
; Author: Unknown  (updated for PB4.00 by blbltheworm)
; Date: 22. June 2003
; OS: Windows
; Demo: No

Global HintergrundFarbe1 
Global HintergrundFarbe2 
HintergrundFarbe1=CreateSolidBrush_(RGB(0,0,0))         ; schwarz 
HintergrundFarbe2=CreateSolidBrush_(RGB(255,255,255))   ; wei� 
; 
Procedure COL_STRINGGADGET(WindowID,Message,wParam,lParam) 
;:::::F�RBT STRINGGADGET UM::::: 
Result=#PB_ProcessPureBasicEvents 
Select Message 
  Case #WM_CTLCOLOREDIT 
; ::: #WM_CTLCOLOREDIT funktioniert f�r alle SkinGadget und StringGadget ::: 
    Select lParam 
      Case GadgetID(1)                      ; hier die Gadget-Nummer angegeben 
        SetBkMode_(wParam,#TRANSPARENT) 
        SetTextColor_(wParam,RGB(0,255,0))   ; Schriftfarbe (gr�n) 
        Result=HintergrundFarbe1           ; Hintergrundfarbe (schwarz) 
    EndSelect 
  Case #WM_CTLCOLORSTATIC 
; ::: #WM_CTLCOLORSTATIC funktionert f�r alle Frame3DGadget, OptionGadget,  ::: 
; ::: TextGadget und TrackBarGadget ::: 
    Select lParam 
      Case GadgetID(2)                      ; das ist die GadgetID f�r das TextGadget(2,...) 
        SetBkMode_(wParam,#TRANSPARENT) 
        SetTextColor_(wParam,RGB(0,0,0))     ; Schriftfarbe (schwarz) 
        Result=HintergrundFarbe2           ; Hintergrundfarbe (wei�) 
      Case GadgetID(3)                      ; das ist die GadgetID f�r das TextGadget(3,...) 
        SetBkMode_(wParam,#TRANSPARENT) 
        SetTextColor_(wParam,RGB(255,0,0))  ; Schriftfarbe (rot) 
        Result=HintergrundFarbe2           ; Hintergrundfarbe (wei�) 
    EndSelect 
; ::: Case #WM_CTLCOLORLISTBOX 
; ::: #WM_CTLCOLORLISTBOX funktioniert f�r alle ListBoxGadget ::: 
; ::: k�nntest hier den gleichen Code wie bei den anderen verwenden und brauchst 
; ::: blo� die GadgetID zu �ndern (oder auch die Farben) 
EndSelect 
ProcedureReturn Result 
EndProcedure 


OpenWindow(0,100,300,400,200,"Testfenster",#PB_Window_SystemMenu) 
SetWindowCallback(@COL_STRINGGADGET()) 

CreateGadgetList(WindowID(0)) 
StringGadget(1,10,10,90,20,"StringGadget") 
TextGadget(2,10,40,300,100,"TextGadget 2",#PB_Text_Border) 
TextGadget(3,10,160,300,30,"TextGadget 3",#PB_Text_Center) 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow 
DeleteObject_(HintergrundFarbe1) 
DeleteObject_(HintergrundFarbe2) 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP