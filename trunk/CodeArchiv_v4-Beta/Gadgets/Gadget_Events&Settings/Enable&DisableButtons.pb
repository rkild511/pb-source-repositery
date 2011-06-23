; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8384&highlight=
; Author: akj (updated for PB4.00 by blbltheworm)
; Date: 17. November 2003
; OS: Windows
; Demo: Yes


; Button Demo  AKJ  17-Nov-03
; This program demonstrates the EnableButtons() procedure.
; It does nothing more than enabling/disabling buttons in a fixed sequence.
; Keep pressing the 'Next' button to cycle through the sequence.
; Click the 'Exit' button to prematurely terminate the program.


;- Demo
Enumeration
  #window
  #butOpen ; O
  #butSave ; S
  #butClos ; C
  #butNext ; N
  #butExit ; X
  #listbox
EndEnumeration
#butLAST = #butExit ; The last button, usually the exit button
#butLIST$ = "OSCNX" ; List of button codes in the same order as the buttons

Declare EnableButtons(buttons$)

; Draw GUI interface
bord=30 ; Border width
butw=100: buth=50: butx=bord: buty=bord ; Button metrics
col1w = 24: col2w=butw ; Listbox column widths
lboxw=col1w+col2w+4; Listbox width (The +4 is a kludge to suppress the h. scrollbar)
winw=bord+butw+bord+lboxw+bord ; Window width
winh=bord+(buth+bord)*Len(#butLIST$)
If OpenWindow(#window,0,0,winw,winh,"Button Demo:  Keep clicking the Next button",#PB_Window_ScreenCentered)=0
  MessageRequester("Error","Failed to open window")
EndIf
UseGadgetList(WindowID(#window))
ButtonGadget(#butOpen, bord, buty, butw, buth, "Open") : buty+buth+bord
ButtonGadget(#butSave, bord, buty, butw, buth, "Save") : buty+buth+bord
ButtonGadget(#butClos, bord, buty, butw, buth, "Close") : buty+buth+bord
ButtonGadget(#butNext, bord, buty, butw, buth, "Next (Click_Me)",#PB_Button_MultiLine|#PB_Button_Default) : buty+buth+bord
ButtonGadget(#butExit, bord, buty, butw, buth, "Exit")
ListIconGadget(#listbox,bord+butw+bord,bord,lboxw,winh-bord*2,"->",col1w) ; Listbox
AddGadgetColumn(#listbox,1,"Code",col2w)

; Populate listbox
AddGadgetItem(#listbox,-1,"__"+Chr(10)+"Initial state")
Read codecount
For i=1 To codecount
  Read code$
  AddGadgetItem(#listbox,-1,Chr(10)+code$)
Next i

; Main loop
Restore codes
codecount=1
Repeat
  If WaitWindowEvent()=#PB_Event_Gadget And EventGadget()=#butNext
    SetGadgetItemText(#listbox,codecount-1,"",0) ; Move the pointer
    SetGadgetItemText(#listbox,codecount,"__",0)
    codecount+1
    Read code$
    EnableButtons(code$) ; Change the state of the buttons
  EndIf
Until EventGadget()=#butExit
CloseWindow(#window)
End

DataSection
Data.l 10 ; Number of code strings below
codes:
Data.s "$NX-", "O", "-S", "-C", "c", "=", "=", "=", "+", "0X"
; The code "$NX-" declares 'Next' and 'Exit' buttons as sticky,
; enables those buttons and then disables all other buttons.
; Sticky buttons are unaffected by codes "+" and "-".
EndDataSection



;- EnableButtons
Procedure EnableButtons(buttons$) ; AKJ  17-Nov-03
  ; Enable or disable up to 26 buttons using the code string in buttons$.
  ; The buttons must have sequential gadget numbers without any gaps.
  
  ; Before calling this procedure for the first time:-
  ; #butLAST must contain the gadget number of the last (usually 'Exit') button.
  ; #butLIST$ must contain a list of all assigned button codes,
  ;   in the same order as the button gadget numbers.
  ;   Each button code is any single UPPERCASE letter, unique to that button.
  
  ; Example button gadget numbers: (Must be consecutive and in the main program):
  ;   Enumeration ; Does not have to start at zero
  ;     #butOpen  ; "O" ; "O" is the button code assigned to the Open button
  ;     #butClose ; "C"
  ;     #butExit  ; "X"
  ;   EndEnumeration
  ; Required by EnableButtons():-
  ;   #butLAST = #butExit
  ;   #butLIST$ = "OCX" ; UPPERCASE letters in the same order as the buttons
  
  ; Codes in button$ on calling this procedure:
  ;   "A"  (uppercase letter[s]) Enable the associated button[s]  E.g. "OC".
  ;   "a"  (lowercase letter[s]) Disable the associated button[s]  E.g. "co".
  ;   "?A" or "?a" Toggle enable/disable for the associated button[s] E.g. "?C" or "?oc".
  ;        It is irrelevant whether the letters are upper- or lower-case.
  ;   "$A" or "$a" Designate the associated button[s] as sticky (see "+" and "-").
  ;        Also enable/disable the associated button[s] as if the $ was not present.
  ;        Useful when some buttons rarely change state, such as "About" And "Exit".
  ;        If no letters immediately follow the $, no buttons will be sticky.
  ;        Initially, no buttons are sticky.
  ;   "+"  Enable all non-sticky buttons
  ;   "-"  Disable all non-sticky buttons
  ;   "*"  Enable ALL buttons, including sticky buttons
  ;   "0"  Disable ALL buttons, including sticky buttons
  ;   "="  Pop the state of ALL buttons and make them current  E.g. "==="
  ;   "|"  End the scope of "?" and "$" (see the example below)
  ;        Actually, any valid non-alphabetic code will end the scope of "?" and "$".
  
  ; Codes $ + - * 0 = normally occur only at the start of buttons$
  ; Invalid codes are ignored.
  ; Sticky buttons are unaffected by codes "+" and "-".
  
  ; Examples:
  ; 1. EnableButtons("$OX-") declares O and X as a sticky buttons, enables them and
  ;    then disables all other buttons.
  ; 2. EnableButtons("$X|O") declares X as a sticky button then enables X and O.
  ; 3. EnableButtons("-C") disables all non-sticky buttons then enables button C.
  ; 4. EnableButtons("=c?Xo") retrieves the previous state for all buttons,
  ;    then disables C and toggles the enable/disable states of X and O.
  
  ; Stack pushes are automatic (the post-states of the buttons are stacked)
  ; N.B. The first call to EnableButtons() assumes all buttons are currently enabled
  
  ; Convention: All variables are either a single letter or are prefixed by "but"
  Shared butstack$ ; An empty stack (as it is initially) assumes all buttons are enabled
  Shared butsticky$ ; List of sticky buttons, initially empty
  butmenu$="+-*0=?$|" ; Special codes
  s=#False ; Sticky button mode is off
  t=#False ; Button toggle mode is off
  w=Len(#butLIST$) ; Each stack entry is w+1 bytes long
  If buttons$=""
    buttons$="-" ; Disable all non-sticky buttons if the string is null
  EndIf
  ; Get the current state (pre-state) of the buttons (hopefully as they really are)
  If Len(butstack$)>w ; If the stack is non-empty
    butprestate$=Left(butstack$,w) ; Current state of the buttons
  Else
    butprestate$=#butLIST$ ; Assume all buttons are currently enabled
  EndIf
  ; Count the number of pop requests ("=")
  n=-1 : p=0
  Repeat
    n+1: p=FindString(buttons$, "=", p+1)
  Until p=0
  ; Process any pop requests
  If n
    If Len(butstack$)>w ; If the stack is non-empty
      butstack$=Mid(butstack$,w+2,999) ; Drop the top-of-stack item
    EndIf
    ; Retrieve an earlier button state from stack entry n
    If Len(butstack$)>=n*(w+1) ; If there are >=n entries on the stack
      ; Pop button state from entry n
      buttons$=Mid(butstack$,n*w+n-w,w)+buttons$ ; Enhance the request list
      butstack$=Mid(butstack$,n*w+n+1,999) ; Remove stack entries 1..n
    Else
      buttons$="*"+buttons$ ; Assume all buttons were enabled if the stack is too small
      butstack$="" ; Remove all (<n) stack entries
    EndIf
  EndIf ; n
  ; Determine the post-state of the buttons by processing any non-pop requests
  butstate$=butprestate$ ; Initialise the post-state
  For p=1 To Len(buttons$)
    c$=Mid(buttons$,p,1)
    If FindString(butmenu$,c$,1)
      t=#False ; Turn off toggle mode
      s=#False ; Turn off sticky mode
    EndIf
    Select c$
    Case "+" ; Enable all non-sticky buttons
      x$=butstate$
      butstate$=#butLIST$ ; Result if no buttons are sticky
      For q=1 To Len(butsticky$)
        d$=LCase(Mid(butsticky$,q,1))
        r=FindString(x$,d$,1)
        If r ; If sticky letter was originally lower case
          butstate$=Left(butstate$,r-1)+d$+Mid(butstate$,r+1,999) ; Reinstate the original
        EndIf
      Next q
    Case "-" ; Disable all non-sticky buttons
      x$=butstate$
      butstate$=LCase(#butLIST$) ; Result if no buttons are sticky
      For q=1 To Len(butsticky$)
        d$=UCase(Mid(butsticky$,q,1))
        r=FindString(x$,d$,1)
        If r ; If sticky letter was originally upper case
          butstate$=Left(butstate$,r-1)+d$+Mid(butstate$,r+1,999) ; Reinstate the original
        EndIf
      Next q
    Case "*" ; Enable all buttons
      butstate$=#butLIST$
    Case "0" ; Disable all buttons
      butstate$=LCase(#butLIST$)
    Case "=" ; Pop the button stack
      ; Do nothing (already done)
    Case "?" ; Toggle any following buttons
      t=#True ; Turn on toggle mode
    Case "$" ; Designate following buttons as sticky
      butsticky$=""
      s=#True ; Turn on sticky mode
      Default ; Invalid code or (A..Z or a..z) Button code letter
      q=FindString(#butLIST$,UCase(c$),1)
      If q ; If valid
        If s ; If in sticky mode
          butsticky$ + c$
        EndIf
        If t ; If in toggle mode
          If Mid(butstate$,q,1)=UCase(c$) ; If button is currently on
            c$=LCase(c$) ; Turn it off
          Else
            c$=UCase(c$) ; Turn it on
          EndIf
        EndIf
        butstate$=Left(butstate$,q-1)+c$+Mid(butstate$,q+1,999)
      EndIf
    EndSelect
  Next p
  ; Push the post-state of the buttons on to the stack
  butstack$=butstate$+"~"+butstack$ ; Stack entries are separated by "~"
  ; Kludge to keep the stack size managable:
  ; Truncate the stack if the fourth entry or later has all buttons enabled
  p=FindString(butstack$,#butLIST$,4*w+4)
  If p
    butstack$=Left(butstack$,p-1)
  EndIf
  ; Implement required button state changes
  g=#butLAST-w ; Button gadget number
  For p=1 To w
    d$=Mid(butstate$,p,1) ; Button post-state
    c$=Mid(butprestate$,p,1) ; Button pre-state
    If d$<>c$ ; If a button needs to change state
      If UCase(d$)=d$
        DisableGadget(g+p, #False) ; If uppercase, enable button
      Else
        DisableGadget(g+p, #True) ; If lowercase, disable button
      EndIf
    EndIf
  Next p
EndProcedure


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
