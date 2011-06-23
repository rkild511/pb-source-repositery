; English forum: http://www.purebasic.fr/english/viewtopic.php?t=3695&highlight=
; Author: PB
; Date: 30. January 2002
; OS: Windows
; Demo: No

#Desk = #False     ; set to #True, if you want screenshot of full desktop
                   ; set to #False, if you want only capture active window
                   
If #Desk = #True      ; make screenshot of full desktop
  keybd_event_(#VK_SNAPSHOT,0,0,0) ; Snapshot of entire desktop
  ; Note: Win 9x needs 1,0,0 for the entire desktop. 
Else                  ; make screenshot of active window
  keybd_event_(#VK_SNAPSHOT,1,0,0) ; Snapshot of current active window.
EndIf

MessageRequester("Message","OK, paste the current clipboard data to your favorite Gfx program to see screenshot.",#MB_ICONEXCLAMATION)



; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
