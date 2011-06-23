; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1068
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 19. May 2003
; OS: Windows
; Demo: Yes

Structure Key 
  Zeichen.s 
  Code.l 
EndStructure 
Global NewList Key.Key() 

Procedure AddKey(Zeichen.s, Code.l) 
  AddElement(Key()) 
  Key()\Zeichen = Zeichen 
  Key()\Code = Code 
EndProcedure 

Procedure InitKeys() 
  ;Buchstaben von a bis z 
  AddKey("a", #PB_Key_A) 
  AddKey("b", #PB_Key_B) 
  AddKey("c", #PB_Key_C) 
  AddKey("d", #PB_Key_D) 
  AddKey("e", #PB_Key_E) 
  AddKey("f", #PB_Key_F) 
  AddKey("g", #PB_Key_G) 
  AddKey("h", #PB_Key_H) 
  AddKey("i", #PB_Key_I) 
  AddKey("j", #PB_Key_J) 
  AddKey("k", #PB_Key_K) 
  AddKey("l", #PB_Key_L) 
  AddKey("m", #PB_Key_M) 
  AddKey("n", #PB_Key_N) 
  AddKey("o", #PB_Key_O) 
  AddKey("p", #PB_Key_P) 
  AddKey("q", #PB_Key_Q) 
  AddKey("r", #PB_Key_R) 
  AddKey("s", #PB_Key_S) 
  AddKey("t", #PB_Key_T) 
  AddKey("u", #PB_Key_U) 
  AddKey("v", #PB_Key_V) 
  AddKey("w", #PB_Key_W) 
  AddKey("x", #PB_Key_X) 
  AddKey("y", #PB_Key_Y) 
  AddKey("z", #PB_Key_Z) 
  
  ;Zahlen von 1 bis 0 
  AddKey("1", #PB_Key_1) 
  AddKey("2", #PB_Key_2) 
  AddKey("3", #PB_Key_3) 
  AddKey("4", #PB_Key_4) 
  AddKey("5", #PB_Key_5) 
  AddKey("6", #PB_Key_6) 
  AddKey("7", #PB_Key_7) 
  AddKey("8", #PB_Key_8) 
  AddKey("9", #PB_Key_9) 
  AddKey("0", #PB_Key_0) 
  
  ;Sonderzeichen 
  AddKey(" ", #PB_Key_Space) 
EndProcedure 

Procedure.s GetKeyboardReleasedKey() 
  ResetList(Key()) 
  Shift.l = #False 
  While NextElement(Key()) 
    If KeyboardReleased(Key()\Code) 
      If KeyboardPushed(#PB_Key_LeftShift) Or KeyboardPushed(#PB_Key_RightShift) 
        Shift = #True 
        Zeichen.s = UCase(Key()\Zeichen) 
      Else 
        If Shift = #False : Zeichen.s = Key()\Zeichen : EndIf 
      EndIf 
    EndIf 
  Wend 
  ProcedureReturn Zeichen 
EndProcedure 

InitKeys() 

InitSprite() 
InitKeyboard() 
OpenScreen(800, 600, 16, "Eingabe") 
Eingabe.s = "" 
Repeat 
  ExamineKeyboard() 
  ClearScreen(RGB(0,0,0)) 
    Eingabe = Eingabe + GetKeyboardReleasedKey() 
    If KeyboardReleased(#PB_Key_Back) 
      If Len(Eingabe) 
        Eingabe = Mid(Eingabe, 1, Len(Eingabe) - 1) 
      EndIf 
    EndIf 
    
    StartDrawing(ScreenOutput()) 
      DrawingMode(1) 
      FrontColor(RGB(100,255,0)) 
      DrawText(0,100,Eingabe) 
    StopDrawing() 
    FlipBuffers() 
Until KeyboardPushed(#PB_Key_Escape) 
CloseScreen()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
