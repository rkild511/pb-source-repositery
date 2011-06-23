; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 19. January 2003
; OS: Windows
; Demo: No

;Here's my own version of an input requester, which is superior to the
;built-in InputRequester() command in these ways:
;
;(1) It's "modal" (it locks the calling window until done).
;(2) The prompt area is bigger And can have multi-line text.
;(3) You can hit Esc/Enter To abort/accept the requester.
;(4) It has a Cancel button in addition To an OK button.
;(5) It has a standard Windows look-and-feel about it.
;(6) It plays the "question" audio prompt sound.
;
;It works with Or without a calling window, And here's how you call it:



Procedure.s InputBox(CallerID.l,title$,prompt$,def$)
  ;
  ; Remember which window (if any) called this InputBox.
  ;
  If CallerID<>0 : CallerNum=EventWindow() : EndIf
  ;
  box=OpenWindow(999,0,0,357,120,title$,#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If box=0 Or CreateGadgetList(box)=0 : ProcedureReturn "" : EndIf
  ;
  TextGadget(996,10,8,265,73,prompt$)
  ButtonGadget(997,288,8,60,23,"OK",#PB_Button_Default)
  ButtonGadget(998,288,36,60,23,"Cancel")
  StringGadget(999,9,92,339,20,def$,#ES_MULTILINE|#ES_AUTOVSCROLL) ; Flags stop "ding" sounds.
  SendMessage_(GadgetID(999),#EM_SETSEL,0,Len(def$)) ; Select all of def$ (if declared).
  ;
  If CallerID<>0
    EnableWindow_(CallerID,#False) ; Disable caller until our InputBox closes ("modal" effect).
  EndIf
  SetWindowPos_(WindowID(999),#HWND_TOPMOST,0,0,0,0,#SWP_NOMOVE|#SWP_NOSIZE) ; InputBox always on top.
  ;
  GetAsyncKeyState_(#VK_RETURN) : GetAsyncKeyState_(#VK_ESCAPE) ; Clear key buffers before loop.
  SetForegroundWindow_(WindowID(999)) : SetActiveGadget(999) ; Activate InputBox and its StringGadget.
  MessageBeep_(#MB_ICONQUESTION) ; Play a sound prompt for the user (not supported on Win XP!).
  ;
  Repeat
    Sleep_(1) : ev=WindowEvent() : id=EventGadget() : where=GetForegroundWindow_()
    ret=GetAsyncKeyState_(#VK_RETURN) : esc=GetAsyncKeyState_(#VK_ESCAPE)
  Until where=box And ((ev=#PB_Event_Gadget And (id=997 Or id=998)) Or ret=-32767 Or esc=-32767 Or ev=#PB_Event_CloseWindow)
  ;
  If id=997 Or ret=-32767 : text$=GetGadgetText(999) : EndIf ; OK clicked or Return key pressed.
  ;
  CloseWindow(999) ; Close InputBox.
  ;
  If CallerID<>0
    EnableWindow_(CallerID,#True) ; Re-enable caller again.
    SetForegroundWindow_(CallerID) ; Give focus back to caller.
    ; And give event control back to caller.
    While WindowEvent() : Wend ; Clear events from caller (necessary!).
  EndIf
  ;
  ProcedureReturn text$
  ;
EndProcedure


;(Updated To fix a gadget number-clash problem, And To Select all of
;the Default text [def$] when the prompt opens, rather than just put
;the cursor at the End of it. Now you can just accept def$ by hitting
;Enter when the prompt opens, Or just start typing a new value without
;having To delete all the text first).  
;
;--------------------------------------------------------------------------------
;Edited by - PB on 19 Jan 2003 00:44:03  





;Usage:
;a$=InputBox(title$,prompt$,Default$)


;Example:
a$=InputBox(0,"InputBox","Please input a string:","This text is already there.... ;)")
Debug a$


;Naturally prompt$ can include Chr(13) For multi-line text, And Default$
;can be empty (null) If you don't want a default entry placed in it.
;I called it InputBox() so as not To clash with InputRequester(), And
;because it emulates the Visual Basic InputBox() command. 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -