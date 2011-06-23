; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7115&highlight=
; Author: ebs
; Date: 03. August 2003
; OS: Windows
; Demo: No


; Here is a Procedure similar to Visual Basic's SendKeys().
; It will send a specified string to the foreground application as if the keys
; had been pressed on the keyboard. It should work For all ASCII characters,
; including those that don't have a #VK_xxx constant value, like punctuation characters.

; To test the code, open any text editor. Start the program and quickly switch back
; to the text editor. You should see the 10 lines of text.


; send the specified key 
Procedure SendKey(Key.s) 
  ; get virtual key code and shift state 
  VK.w = VkKeyScan_(Asc(Key)) 
  If VK = -1 
    ProcedureReturn 
  EndIf 
  
  ; get scan code if an extended key 
  If MapVirtualKey_(VK, 2) = 0 
    Extended.l = #KEYEVENTF_EXTENDEDKEY 
    ; get scan code 
    Scan.l = MapVirtualKey_(VK, 0) 
  Else 
    Extended = 0 
    Scan = 0 
  EndIf 
  
  ; press shift/ctrl/alt if needed 
  Shift.l = VK & $100 
  Ctrl.l = VK & $200 
  Alt.l = VK & $400 
  If Shift 
    keybd_event_(#VK_SHIFT, 0, 0, 0) 
  EndIf 
  If Ctrl 
    keybd_event_(#VK_CONTROL, 0, 0, 0) 
  EndIf 
  If Alt 
    keybd_event_(#VK_MENU, 0, 0, 0) 
  EndIf 
  
  ; press and release key 
  VK & $ff 
  keybd_event_(VK, Scan, Extended, 0) 
  keybd_event_(VK, Scan, #KEYEVENTF_KEYUP | Extended, 0) 
  
  ; release shift/ctrl/alt if pressed 
  If Shift 
    keybd_event_(#VK_SHIFT, 0, #KEYEVENTF_KEYUP, 0) 
  EndIf 
  If Ctrl 
    keybd_event_(#VK_CONTROL, 0, #KEYEVENTF_KEYUP, 0) 
  EndIf 
  If Alt 
    keybd_event_(#VK_MENU, 0, #KEYEVENTF_KEYUP, 0) 
  EndIf 
EndProcedure 

; send string to foreground application  
Procedure SendKeys(String.s) 
  For Letter.l = 1 To Len(String) 
    SendKey(Mid(String, Letter, 1)) 
  Next 
EndProcedure 

; test 
For n.l = 1 To 10 
  Delay(2000) 
  SendKeys("Hello There!" + Chr(13)) 
Next 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
