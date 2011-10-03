; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Project name : Thothbox
; File name : Thothbox - Support Function.pb
; File Version : 0.0.0
; Programmation : In progress
; Programmed by : Your name here
; AKA : Your NickName here
; E-mail : address@something.com
; Creation Date : 11-09-2011
; Last update : 14-09-2011
; Coded for PureBasic V4.60
; Platform : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Procedure.s XOREncodeString(P_Key.s, P_Text.s)
  
  If P_Key = ""
    P_Key = "XOREncode"
  EndIf 
  
  KeyLength = Len(P_Key)
  TextLength = Len(P_Text)
  
  For TextIndex = 1 To TextLength
    
    For KeyIndex = 1 To KeyLength
      Char.c = Asc(Mid(P_Text, TextIndex, 1)) ! ~Asc(Mid(P_Key, KeyIndex, 1))
    Next
    
    Encoded.s = Encoded + Chr(Char)
    
  Next
  
  ProcedureReturn Encoded
EndProcedure

Procedure.b CreatePath(Path.s)
  
  If Right(Path, 1) <> #DirectorySeparator
    Path + #DirectorySeparator
  EndIf
  
  DirectoryQty = CountString(Path, #DirectorySeparator)
  
  For DirectoryID = 1 To DirectoryQty
    
    Directory.s = Directory + StringField(Path, DirectoryID, #DirectorySeparator) + #DirectorySeparator
    
    If FileSize(Directory) <> -2
      CreateDirectory(Directory)
    EndIf 
    
  Next
  
  If FileSize(Directory) = -2
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<
; <<<<< END OF FILE <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 22
; FirstLine = 15
; Folding = -
; EnableXP