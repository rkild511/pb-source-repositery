; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6405&start=15
; Author: El_Choni  (updated for PB3.92 by Andre)
; Date: 19. June 2003
; OS: Windows
; Demo: No

Global RTFPtr.l 

Procedure StreamFileInCallback(dwCookie, pbBuff, cb, pcb) 
  result = 0 
  If RTFPtr>=?RTFEnd 
    cb = 0 
    result = 1 
  ElseIf RTFPtr+cb>=?RTFEnd 
    cb = ?RTFEnd-RTFPtr 
  EndIf 
  CopyMemory(RTFPtr, pbBuff, cb) 
  RTFPtr+cb 
  PokeL(pcb, cb) 
  ProcedureReturn result 
EndProcedure 

Procedure _PutRTF() 
  RTFPtr=?RTFStart 
  uFormat = #SF_RTF 
  edstr.EDITSTREAM 
  edstr\dwCookie = 0 
  edstr\dwError = 0 
  edstr\pfnCallback = @StreamFileInCallback() 
  SendMessage_(GadgetID(0), #EM_STREAMIN, uFormat, edstr) 
EndProcedure 

If OpenWindow(0, 200, 200, 400, 200,"Memory Put", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget)=0:End:EndIf 
  If CreateGadgetList(WindowID(0))=0:End:EndIf 
  EditorGadget(0, 0, 0, WindowWidth(0), WindowHeight(0)) 
  SendMessage_(GadgetID(0), #EM_LIMITTEXT, -1, 0) 
  _PutRTF() 
  Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 
End 

End 

DataSection 
  RTFStart: 
  IncludeBinary "test.rtf"    ; change this path to you own file!
  RTFEnd: 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
