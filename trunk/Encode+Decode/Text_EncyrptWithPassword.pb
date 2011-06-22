; German forum: http://robsite.de/php/pureboard/viewtopic.php?t=3399&highlight=
; Author: manne
; Date: 11. January 2004


; Wer mal eben auf die schnelle einen Text verschlüsseln möchte, findet im
; folgenden Beispiel einen möglichen Ansatz. 


;- Encryption/Decryption part - could be separated as Include file
Procedure.l CalculateSeed(InputNumber.l) 
  ProcedureReturn Int(Log(InputNumber) * Cos(InputNumber) * 137) 
EndProcedure 

Procedure.l GetPasswordValue(Password.s) 
  ASCII_Vals.l 
  
  For i = 1 To Len(Password) 
    ASCII_Vals = ASCII_Vals + Asc(Mid(Password, i, 1)) 
  Next i 
  
  If ASCII_Vals > Len(Password) 
    ProcedureReturn Int(CalculateSeed(ASCII_Vals) / CalculateSeed(Len(Password) + 1)) 
  Else 
    ProcedureReturn CalculateSeed(ASCII_Vals) 
  EndIf 
EndProcedure 

Procedure.l WrapNumber(lngNumber.l, lngMinimum.l, lngMaximum.l) 
  DefType.l Range, check 
  Range = lngMaximum - lngMinimum 
  check = lngNumber 
  
  If lngNumber > lngMaximum 
    Repeat 
      check = check - Range 
    Until check <= lngMaximum 
  ElseIf lngNumber < lngMinimum 
    Repeat 
      check = check + Range 
    Until check >= lngMinimum 
  EndIf 
  ProcedureReturn check 
EndProcedure 

Procedure.s Encrypt(Password.s, Input.s) 
  DefType.l PasswordVal, CurrentChar, CurrentMod 
  enctxt.s  
  PasswordVal = GetPasswordValue(Password) 
    
  CurrentMod = 2 
    
  For i = 1 To Len(Input) 
    CurrentChar = Asc(Mid(Input, i, 1)) 
    CurrentChar = CurrentChar + PasswordVal 
    CurrentChar = CurrentChar - CalculateSeed(CurrentMod) 
    CurrentChar = WrapNumber(CurrentChar, 0, 255) 
    enctxt = enctxt + Chr(CurrentChar) 
    CurrentMod = CurrentMod + 1 
    
    If CurrentMod > 30 
      CurrentMod = 2 
    EndIf 
  Next i 
  ProcedureReturn enctxt  
EndProcedure 

Procedure.s Decrypt(Password.s, Input.s) 
  DefType.l PasswordVal, CurrentChar, CurrentMod 
  dectxt.s  
  PasswordVal = GetPasswordValue(Password) 
  CurrentMod = 2 
    
  For i = 1 To Len(Input) 
    CurrentChar = Asc(Mid(Input, i, 1)) 
    CurrentChar = CurrentChar - PasswordVal 
    CurrentChar = CurrentChar + CalculateSeed(CurrentMod) 
    CurrentChar = WrapNumber(CurrentChar, 0, 255) 
    dectxt = dectxt + Chr(CurrentChar) 
    CurrentMod = CurrentMod + 1 
    
    If CurrentMod > 30 
      CurrentMod = 2 
    EndIf 
  Next i 
  ProcedureReturn dectxt    
EndProcedure

;- GUI part
Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #Text_0 
  #String_0 
  #String_1 
  #Text_1 
  #Button_0 
  #Button_1 
  #String_2 
  #StatusBar_0 
EndEnumeration 

Global FontID1 
FontID1 = LoadFont(1, "Arial", 10, #PB_Font_Bold) 
Global FontID2 
FontID2 = LoadFont(2, "Arial", 8, #PB_Font_Bold) 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 433, 212, 322, 376,  #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered , "Text-Crypt") 
    If CreateStatusBar(#StatusBar_0, WindowID()) 
      AddStatusBarField(322) 
    EndIf 
    
    If CreateGadgetList(WindowID()) 
      TextGadget(#Text_0, 20, 20, 65, 20, "Passwort:") 
      SetGadgetFont(#Text_0, FontID2) 
      StringGadget(#String_0, 90, 18, 210, 20, "", #PB_String_Password) 
      SendMessage_(GadgetID(#String_0), #EM_LIMITTEXT, 100, 0) 
      StringGadget(#String_1, 20, 70, 280, 100, "", #PB_String_MultiLine|#ES_AUTOVSCROLL|#WS_VSCROLL|#ESB_DISABLE_LEFT|#ESB_DISABLE_RIGHT) 
      SendMessage_(GadgetID(#String_1), #EM_LIMITTEXT, 1000, 0) 
      TextGadget(#Text_1, 48, 50, 45, 15, "Input:") 
      ButtonGadget(#Button_0, 20, 180, 280, 30, "Verschlüsseln") 
      AddKeyboardShortcut(#Window_0, #PB_Shortcut_Control | #PB_Shortcut_E, #Button_0) 
      SetGadgetFont(#Button_0, FontID2) 
      ButtonGadget(#Button_1, 20, 210, 280, 30, "Entschlüsseln") 
      AddKeyboardShortcut(#Window_0, #PB_Shortcut_Control | #PB_Shortcut_D, #Button_1) 
      SetGadgetFont(#Button_1, FontID2) 
      StringGadget(#String_2, 20, 250, 280, 100, "", #PB_String_MultiLine|#ES_AUTOVSCROLL|#WS_VSCROLL|#ESB_DISABLE_LEFT|#ESB_DISABLE_RIGHT) 
      SendMessage_(GadgetID(#String_2), #EM_LIMITTEXT, 1000, 0) 
    EndIf 
  EndIf 
EndProcedure 

;- Main Program:
Open_Window_0() 
ActivateGadget(#String_0) 
DisableGadget(#Button_0, 1) 
DisableGadget(#Button_1, 1) 

Repeat 
  
  Event = WaitWindowEvent() 
  If Event = #PB_EventCloseWindow 
    Quit = 1 
  ElseIf Event = #PB_Event_Gadget Or Event = #PB_Event_Menu 
    
    Select EventGadgetID() 
      Case #Button_0  ;Encrypt 
        If GetGadgetText(#String_0) = "" 
          MessageRequester("Fehler", "Kein Passwort angegeben!", #MB_ICONWARNING) 
        Else 
          SetGadgetText(#String_2, Encrypt(GetGadgetText(#String_0), GetGadgetText(#String_1))) 
          If Len(GetGadgetText(#String_2)) <> Len(GetGadgetText(#String_1)) 
            SetGadgetText(#String_2, "")  
            StatusBarText(#StatusBar_0, 0, "Nicht darstellb. Zeichen gefunden, bitte anderes PW benutzen.") 
          Else 
            SetGadgetText(#String_1, "") 
            DisableGadget(#Button_0, 1) 
            DisableGadget(#Button_1, 0) 
            StatusBarText(#StatusBar_0, 0, "Verschlüsselung erfolgreich!") 
          EndIf 
        EndIf 
      Case #Button_1  ;Decrypt 
        If GetGadgetText(#String_0) = "" 
          MessageRequester("Fehler", "Kein Passwort angegeben!", #MB_ICONWARNING) 
        Else 
          SetGadgetText(#String_1, Decrypt(GetGadgetText(#String_0), GetGadgetText(#String_2))) 
          SetGadgetText(#String_2, "") 
          DisableGadget(#Button_1, 1) 
          DisableGadget(#Button_0, 0) 
          StatusBarText(#StatusBar_0, 0, "Entschlüsselung erfolgreich!") 
        EndIf 
      Case #String_1  ; Input 
        If EventType() = #PB_EventType_Change 
          DisableGadget(#Button_0, 0) 
        EndIf 
      Case #String_2  ; Output 
        If EventType() = #PB_EventType_Change 
          DisableGadget(#Button_1, 0) 
        EndIf 
    EndSelect 
  EndIf 
  
Until Quit 

End
; ExecutableFormat=Windows
; FirstLine=1
; EnableXP
; DisableDebugger
; EOF