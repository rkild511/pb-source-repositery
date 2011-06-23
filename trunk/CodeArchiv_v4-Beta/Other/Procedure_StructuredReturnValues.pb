; German forum: http://www.purebasic.fr/german/viewtopic.php?t=282&highlight=
; Author: NicTheQuick
; Date: 29. September 2004
; OS: Windows, Linux
; Demo: Yes

; Beispiel um mehrere Werte von einer Procedure zurückzubekommen
Structure IR_Ex 
  Text.s 
  Length.l 
  Ok.l 
EndStructure 

Procedure InputRequester_Ex(Title.s, Message.s, DefaultString.s, *Out.IR_Ex) 
  Protected Result.s 
  Result.s = InputRequester(Title, Message, DefaultString) 
  If *Out 
    *Out\Text = Result 
    *Out\Length = Len(Result) 
    If *Out\Length 
      *Out\Ok = #True 
    Else 
      *Out\Ok = #False 
    EndIf 
    ProcedureReturn #True 
  EndIf 
  ProcedureReturn #False 
EndProcedure 

InputRequester_Ex("Hallo", "Gib was ein.", "(da steht nix)", @Result.IR_Ex) 

If Result\Ok 
  MessageRequester("Hallo", "Es wurde folgender Text eingegeben:" + #LFCR$ + Result\Text + #LFCR$ + "Er hat die Länge " + Str(Result\Length) + " Bytes.") 
Else 
  MessageRequester("Hallo", "Es wurde nichts eingegeben") 
EndIf
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -