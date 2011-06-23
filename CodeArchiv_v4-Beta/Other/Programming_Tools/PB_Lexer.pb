; http://www.purebasic-lounge.de
; Author: remi_meier (example added by edel)
; Date: 03. Juny 2006
; OS: Windows
; Demo: Yes

EnableExplicit

Enumeration 0
  #PBSC_Other  ; Operators, other symbols
  #PBSC_Identifier ; all variables, structures, pseudotypes, functions, pointer, constants...
  #PBSC_Number ; 'numb', 466, $ FFFF, %10001, 1.0e-4, etc.
  #PBSC_String ; "this is a String!"
  #PBSC_Comment ; the whole rest of the line starting with a ';'
  #PBSC_NewLine ; a new line begins, Token = #LF$
EndEnumeration

Interface iPBSC
  SetFile.l(FileName.s)
  SetFileString(FileAsString.s)
  SetFileLine(Line.l)
  IsNextToken.l()
  GetNextToken.s()
  GetCurrentLineNb.l()
  GetCurrentType.l()
  CloseFile()
EndInterface

Structure cPBSC
  *VTable
 
  File.s
  FileLine.l
  FileMaxLine.l
 
  Line.s
  Started.l
 
  CurrentType.l
 
  LastToken.s
  LastTokenType.l
  PreLastToken.s
  PreLastTokenType.l
  PrePreLastToken.s
  PrePreLastTokenType.l
EndStructure


Procedure _PBSC_SetLastToken(*this.cPBSC, s.s)
  ;Static PreLastToken.s = #LF$
  If *this\PreLastToken = "" : *this\PreLastToken = #LF$ : EndIf
  *this\PrePreLastToken = *this\PreLastToken
  *this\PreLastToken = *this\LastToken
  *this\LastToken = s
EndProcedure

Procedure _PBSC_SetTokenType(*this.cPBSC, Type.l)
  If Type = -1
    *this\PrePreLastTokenType = #PBSC_Other
    *this\PreLastTokenType = #PBSC_Other
    *this\LastTokenType = #PBSC_Other
    *this\CurrentType = #PBSC_Other
  Else
    *this\PrePreLastTokenType = *this\PreLastTokenType
    *this\PreLastTokenType = *this\CurrentType
    *this\LastTokenType = Type
    *this\CurrentType = Type
  EndIf
EndProcedure

Procedure.l PBSC_SetFile(*this.cPBSC, FileName.s)
  Protected FileID.l, Format.l
 
  FileID = ReadFile(#PB_Any, FileName)
  If Not IsFile(FileID)
    ProcedureReturn #False
  EndIf
 
  *this\FileLine = 1
  _PBSC_SetLastToken(*this, #LF$)
  _PBSC_SetTokenType(*this, -1)
  *this\Line = ""
  *this\Started = #True
 
  Format = ReadStringFormat(FileID)
  Select Format
    Case #PB_Ascii, #PB_UTF8, #PB_Unicode
     
      *this\FileMaxLine = 0
      While Not Eof(FileID)
        *this\FileMaxLine + 1
        *this\File + ReadString(FileID, Format) + #LF$
      Wend
     
      CloseFile(FileID)
      ProcedureReturn #True
     
    Default
      CloseFile(FileID)
      ProcedureReturn #False
  EndSelect
EndProcedure

Procedure PBSC_SetFileString(*this.cPBSC, FileAsString.s) ; lines separated with #LF$!
  *this\File = FileAsString
  *this\FileLine = 1
  _PBSC_SetLastToken(*this, #LF$)
  _PBSC_SetTokenType(*this, -1)
  *this\Line = ""
  *this\Started = #True
  *this\FileMaxLine = CountString(*this\File, #LF$) + 1
EndProcedure

Procedure PBSC_SetFileLine(*this.cPBSC, Line.l)
  *this\FileLine = Line
  *this\Line = ""
  *this\Started = #True
  _PBSC_SetLastToken(*this, #LF$)
  _PBSC_SetTokenType(*this, -1)
EndProcedure

Procedure.l PBSC_IsNextToken(*this.cPBSC)
  If *this\File And (*this\FileLine <= *this\FileMaxLine Or Len(*this\Line) <> 0)
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf
EndProcedure

Procedure.s _PBSC_ReadLine(*this.cPBSC)
 
  If *this\File
    *this\FileLine + 1
    ProcedureReturn StringField(*this\File, *this\FileLine - 1, #LF$)
  EndIf
 
  ProcedureReturn ""
EndProcedure

Procedure.s _PBSC_Trim(*this.cPBSC, s.s)
  Protected *p.CHARACTER, *n.CHARACTER
 
  *p = @s
  While (*p\c = ' ' Or *p\c = 9) And *p\c
    *p + SizeOf(CHARACTER)
  Wend
  ; *p zeigt auf Start des Textes
 
  ; suche Ende
  *n = *p
  While *n\c <> 0
    *n + SizeOf(CHARACTER)
  Wend
 
  *n - SizeOf(CHARACTER)
  While (*n\c = ' ' Or *n\c = 9) And *n > *p
    *n - SizeOf(CHARACTER)
  Wend
 
  ProcedureReturn PeekS(*p, (*n + SizeOf(CHARACTER) - *p)/SizeOf(CHARACTER))
EndProcedure

Procedure.l _PBSC_GetIdentifier(*this.cPBSC, s.s)
  Protected z.l, Len.l, ToLen.l = 0, Const.l = 0, PseudoType.l = 0, Temp.s
  Protected LastToken.s, notptr.l
 
  If *this\LastToken = "." And (PeekC(@s) = 'p' Or PeekC(@s) = 'P') And PeekC(@s+SizeOf(CHARACTER)) = '-'
    PseudoType = 1
    ToLen = 2
  EndIf
 
  If PseudoType = 0
    If PeekC(@s) = '#'
      If *this\LastTokenType = #PBSC_Identifier Or *this\LastTokenType = #PBSC_Other
        Temp = LCase(*this\LastToken)
        Select Temp
          Case "to", "procedurereturn", "select", "case", "if", "elseif", "compilerselect"
            Const = 1 : ToLen = 1
          Case "compilercase", "compilerif", "compilerelseif", "break", "while", "until"
            Const = 1 : ToLen = 1
          Case "debug", "end", "and", "or", "xor", "not", "#"
            Const = 1 : ToLen = 1
          Case ",","/","+","-","%","!","~","|","&","<<",">>","<",">","<=",">=","=","<>","(","[","{",":"
            Const = 1 : ToLen = 1
          Case "*"
            If *this\LastTokenType = #PBSC_Identifier
              ProcedureReturn 0
            Else
              Const = 1 : ToLen = 1
            EndIf
          Default
            ProcedureReturn 0
        EndSelect
      ElseIf *this\LastTokenType = #PBSC_NewLine
        Const = 1 : ToLen = 1
      Else
        ProcedureReturn 0
      EndIf
     
    ElseIf PeekC(@s) = '*'
      notptr = #True
      If *this\LastTokenType = #PBSC_Identifier Or *this\LastTokenType = #PBSC_Other
        Temp = LCase(*this\LastToken)
        Select Temp
          Case "to", "procedurereturn", "select", "case", "if", "elseif", "compilerselect"
            notptr = #False
          Case "while", "until", "protected", "define", "global", "shared", "static"
            notptr = #False
          Case "debug", "end", "and", "or", "xor", "not", "#"
            notptr = #False
          Case ",","/","+","-","%","!","~","|","&","<<",">>","<",">","<=",">=","=","<>","@","(","[","{",":"
            notptr = #False
          Case "*"
            If *this\LastTokenType = #PBSC_Identifier
              notptr = #True
            Else
              notptr = #False
            EndIf
          Default
            notptr = #True
        EndSelect
      ElseIf *this\LastTokenType = #PBSC_NewLine
        notptr = #False
      EndIf
      If notptr And *this\PrePreLastTokenType = #PBSC_Identifier
        Temp = LCase(LastToken)
        Select Temp
          Case "protected", "define", "global", "shared", "static"
            notptr = #False
        EndSelect
      EndIf
     
      If notptr = #False
        Const = 1 : ToLen = 1
      EndIf
     
      If Const <> 1
        ProcedureReturn 0
      EndIf
    EndIf
   
    If Const
      z = 1
      While (PeekC(@s+z*SizeOf(CHARACTER)) = ' ' Or PeekC(@s+z*SizeOf(CHARACTER)) = 9)
        Const + 1
        z + 1
        ToLen + 1
      Wend
    EndIf
   
    Select PeekC(@s + Const*SizeOf(CHARACTER))
      Case '_', 'a' To 'z', 'A' To 'Z'
        ToLen + 1
      Default
        ProcedureReturn 0
    EndSelect
  EndIf
 
  Len = Len(s)
  For z = 2+Const+PseudoType To Len
    Select Asc(Mid(s, z, 1))
      Case '_', 'a' To 'z', 'A' To 'Z', '0' To '9', '$'
        ToLen + 1
      Default
        _PBSC_SetTokenType(*this, #PBSC_Identifier)
        ProcedureReturn ToLen
    EndSelect
  Next
 
  _PBSC_SetTokenType(*this, #PBSC_Identifier)
  ProcedureReturn ToLen
EndProcedure

Procedure.l _PBSC_GetString(*this.cPBSC, s.s)
  Protected z.l, Len.l, ToLen.l = 0, SearchString.l
 
 
  If PeekC(@s) = '"'
    SearchString = #True
    ToLen = 1
  ElseIf PeekC(@s) = Asc("'")
    SearchString = #False
    ToLen = 1
  Else
    ProcedureReturn 0
  EndIf
 
  Len = Len(s)
  For z = 2 To Len
    If SearchString
      Select Asc(Mid(s, z, 1))
        Case '"'
          _PBSC_SetTokenType(*this, #PBSC_String)
          ProcedureReturn ToLen + 1
        Default
          ToLen + 1
      EndSelect
    Else
      Select Asc(Mid(s, z, 1))
        Case Asc("'")
          _PBSC_SetTokenType(*this, #PBSC_Number)
          ProcedureReturn ToLen + 1
        Default
          ToLen + 1
      EndSelect
    EndIf
  Next
 
  _PBSC_SetTokenType(*this, #PBSC_String)
  ProcedureReturn ToLen
EndProcedure

Procedure.l _PBSC_GetNumber(*this.cPBSC, s.s)
  Protected z.l, Len.l, ToLen.l = 0, Digit.l = #False, Hex.l = #False, Spec.l = 0
  Protected lastChar.c
 
  If PeekC(@s) = '$'
    Hex = #True
    ToLen = 1
    Spec = 1
  ElseIf PeekC(@s) = '%'
    If *this\LastTokenType = #PBSC_Identifier Or *this\LastTokenType = #PBSC_Number
      ProcedureReturn 0
    ElseIf *this\LastToken = ")" Or *this\LastToken = "]"
      ProcedureReturn 0
    EndIf
    ToLen = 1
    Spec = 1
  EndIf
 
  Len = Len(s)
  For z = (1+Spec) To Len
    If Hex
      Select Asc(Mid(s, z, 1))
        Case '0' To '9', 'a' To 'f', 'A' To 'F'
          ToLen + 1
          Digit = #True
        Case ' ', 9
          ToLen + 1
        Default
          If Digit
            _PBSC_SetTokenType(*this, #PBSC_Number)
            ProcedureReturn ToLen
          Else
            ProcedureReturn 0
          EndIf
      EndSelect
    Else
      Select Asc(Mid(s, z, 1))
        Case '0' To '9', '.', 'e'
          If Digit = #False And (Asc(Mid(s, z, 1)) = '.' Or Asc(Mid(s, z, 1)) = 'e')
            ProcedureReturn 0
          EndIf
          If Mid(s, z, 1) = "e"
            Select Asc(Mid(s, z-1, 1))
              Case '0' To '9', '.'
              Default
                _PBSC_SetTokenType(*this, #PBSC_Number)
                ProcedureReturn ToLen
            EndSelect
          EndIf
          lastChar = Asc(Mid(s, z, 1))
          ToLen + 1
          Digit = #True
        Case '+', '-'
          If Digit
            If lastChar = 'e'
              ToLen + 1
            Else
              _PBSC_SetTokenType(*this, #PBSC_Number)
              ProcedureReturn ToLen
            EndIf
          Else
            ProcedureReturn 0
          EndIf
        Case ' ', 9
          ToLen + 1
        Default
          If Digit
            _PBSC_SetTokenType(*this, #PBSC_Number)
            ProcedureReturn ToLen
          Else
            ProcedureReturn 0
          EndIf
      EndSelect
    EndIf
  Next
 
  _PBSC_SetTokenType(*this, #PBSC_Number)
  ProcedureReturn ToLen
EndProcedure

Procedure.l _PBSC_GetDOperator(*this.cPBSC, s.s)
  Select PeekC(@s)
    Case '<', '>'
      Select PeekC(@s+SizeOf(CHARACTER))
        Case '>', '<', '='
          _PBSC_SetTokenType(*this, #PBSC_Other)
          ProcedureReturn 2
      EndSelect
  EndSelect
 
  ProcedureReturn 0
EndProcedure

Procedure.l _PBSC_FindToken(*this.cPBSC, s.s)
  ; ok: Kommentare als Ganzes
  ; ok: Strings als Ganzes (auch mit ' umklammerte)
  ; ok: Bezeichner als Ganzes (auch #KONST, String$, *Ptr)
  ; ok: Pseudotypen als Ganzes
  ; ok: Zahlen: 2001, $5461, %454
  ; ok: Doppeloperatoren
  Static RetVal.l = 0
 
  If PeekC(@s) = ';'
    _PBSC_SetLastToken(*this, s)
    _PBSC_SetTokenType(*this, #PBSC_Comment)
    ProcedureReturn Len(s)
  EndIf
 
  RetVal = _PBSC_GetIdentifier(*this, s)
  If RetVal
    _PBSC_SetLastToken(*this, Left(s, RetVal))
    ProcedureReturn RetVal
  EndIf
 
  RetVal = _PBSC_GetString(*this, s)
  If RetVal
    _PBSC_SetLastToken(*this, Left(s, RetVal))
    ProcedureReturn RetVal
  EndIf
 
  RetVal = _PBSC_GetNumber(*this, s)
  If RetVal
    _PBSC_SetLastToken(*this, Left(s, RetVal))
    ProcedureReturn RetVal
  EndIf
 
  RetVal = _PBSC_GetDOperator(*this, s)
  If RetVal
    _PBSC_SetLastToken(*this, Left(s, RetVal))
    ProcedureReturn RetVal
  EndIf
 
  _PBSC_SetLastToken(*this, Mid(s, 1, 1))
  _PBSC_SetTokenType(*this, #PBSC_Other)
  ProcedureReturn 1
EndProcedure

Procedure.s PBSC_GetNextToken(*this.cPBSC)
  Protected s0.s, Token.s, Len.l
 
  If *this\File And (*this\FileLine <= *this\FileMaxLine Or Len(*this\Line) <> 0)
   
    If *this\Line = ""
      _PBSC_SetTokenType(*this, #PBSC_NewLine)
      _PBSC_SetLastToken(*this, #LF$)
     
      s0 = _PBSC_ReadLine(*this)
      *this\Line = _PBSC_Trim(*this, s0)
     
      If ( Not *this\Started) Or (*this\Started And *this\Line = "")
        ProcedureReturn #LF$
      Else
        *this\Started = #False
      EndIf
    EndIf
   
    Len = _PBSC_FindToken(*this.cPBSC, *this\Line)
    Token = Left(*this\Line, Len)
   
    *this\Line = _PBSC_Trim(*this, Mid(*this\Line, FindString(*this\Line, Token, 1)+Len(Token), Len(*this\Line)-Len(Token)))
   
    ProcedureReturn _PBSC_Trim(*this, Token)
  Else
    ProcedureReturn ""
  EndIf
EndProcedure

Procedure.l PBSC_GetCurrentLineNb(*this.cPBSC)
  If *this\Started = #False And *this\LastToken = #LF$
    ProcedureReturn *this\FileLine - 2
  Else
    ProcedureReturn *this\FileLine - 1
  EndIf
EndProcedure

Procedure.l PBSC_GetCurrentType(*this.cPBSC)
  ProcedureReturn *this\CurrentType
EndProcedure

Procedure PBSC_CloseFile(*this.cPBSC)
  *this\File = ""
EndProcedure

DataSection
  cPBSC_VT:
  Data.l @PBSC_SetFile(), @PBSC_SetFileString(), @PBSC_SetFileLine(), @PBSC_IsNextToken(), @PBSC_GetNextToken()
  Data.l @PBSC_GetCurrentLineNb(), @PBSC_GetCurrentType(), @PBSC_CloseFile()
EndDataSection

Procedure.l New_PBSC()
  Protected *obj.cPBSC
 
  *obj = AllocateMemory(SizeOf(cPBSC))
  If Not *obj : ProcedureReturn #False : EndIf
 
  *obj\VTable = ?cPBSC_VT
 
  ProcedureReturn *obj
EndProcedure




Define.iPBSC Lexer = New_PBSC() 
Define.s     Text,Token 
Define.l     Typ 

Text = "procedure Testproc(a.l,b.s,c.l = 10)" + #LF$ 
Text + "  protected d = a+b*c"                + #LF$ 
Text + "procedureReturn d"                    + #LF$ 
Text + "endprocedure"                          

;- String 

Lexer\SetFileString(Text) 
  
While Lexer\IsNextToken() 
  
  Token = Lexer\GetNextToken() 
  Typ   = Lexer\GetCurrentType() 
  
  Select Typ 
    Case #PBSC_Other        : Debug "Other        : " + Token 
    Case #PBSC_Identifier   : Debug "Identifier   : " + Token 
    Case #PBSC_Number       : Debug "Number       : " + Token 
    Case #PBSC_String       : Debug "String       : " + Token 
    Case #PBSC_Comment      : Debug "Comment      : " + Token 
    Case #PBSC_NewLine      : Debug "NewLine  : LF"  
  EndSelect 
  
Wend 


;- Datei 

; If Lexer\SetFile("test.pb") 
  ; 
  ; While Lexer\IsNextToken() 
    ; Token = Lexer\GetNextToken() 
    ; Typ   = Lexer\GetCurrentType() 
    ; 
    ; Select Typ 
      ; Case #PBSC_Other        : Debug "Other        : " + Token 
      ; Case #PBSC_Identifier   : Debug "Identifier   : " + Token 
      ; Case #PBSC_Number       : Debug "Number       : " + Token 
      ; Case #PBSC_String       : Debug "String       : " + Token 
      ; Case #PBSC_Comment      : Debug "Comment  : " + Token 
      ; Case #PBSC_NewLine      : Debug "NewLine  : LF"  
    ; EndSelect 
  ; Wend 
  ; 
  ; Lexer\CloseFile() 
; EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----