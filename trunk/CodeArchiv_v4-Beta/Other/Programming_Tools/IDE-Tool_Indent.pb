; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10418&postdays=0&postorder=asc&start=10
; Author: HeX0R
; Date: 10. December 2006
; OS: Windows, Linux
; Demo: Yes

;/---------------
;| IDE-Tool
;| EinrÃ¼cker
;|
;| (c)HeX0R 2006
;| Do whatever you
;| like with this
;| source
;/---------------

Structure _TAGS_
  Name.s
  Tabs.l
EndStructure

Procedure.s AddTabs(Tabs.l, Tab.s)
  Protected i.l, Result.s

  For i = 1 To Tabs
    Result + Tab
  Next i

  ProcedureReturn Result
EndProcedure

Procedure.s MyTrim(Line.s)
  ;Normal Trim() doesn't handle Tabs correctly, so i had to write my own

  Protected *B.BYTE, Start.l = 1, Ende.l, Result.s

  If Line = ""
    ProcedureReturn ""
  EndIf

  *B = @Line
  Repeat
    If *B\b <> 32 And *B\b <> 9 And *B\b <> 0
      Break
    EndIf
    Start + 1
    *B + 1
  ForEver
  Ende = Len(Line)
  *B = @Line + Ende - 1
  Ende - Start
  Repeat
    If *B\b <> 32 And *B\b <> 9 And *B\b <> 0
      Break
    EndIf
    Ende - 1
    *B - 1
  ForEver
  Result = Mid(Line, Start, Ende + 1)

  ProcedureReturn Result
EndProcedure

Procedure.s FindCommand(Line.s, Index.l)
  ;Find next Command in this Line
  ;When User wrote more then
  ;just one Command in one Line via ':'
  ;For Example
  ;While WindowEvent() : Wend

  Protected i.l, DQ.l, *B.CHARACTER, Result.s

  If Line = ""
    ProcedureReturn ""
  EndIf

  i  = 1
  *B = @Line
  While *B\c <> 0
    If *B\c = 34
      DQ ! 1
    EndIf
    If *B\c = ':' And DQ = 0
      If i = Index
        Break
      Else
        i + 1
      EndIf
    ElseIf i = Index
      Result + Chr(*B\c)
    EndIf
    *B + 1
  Wend

  ProcedureReturn MyTrim(Result)

EndProcedure

Procedure.l CheckForEndTag(b$, Tag.s)
  ;Checks, whether the Start and End-Tag is in one line
  ;For Example
  ;While WindowEvent() : Wend
  Protected a$, Result.l = #True, i.l = 2

  a$ = FindCommand(b$, i)
  While a$ <> ""
    Select StringField(LCase(a$), 1, " ")
      Case "endif"
        If Tag = "if"
          Result = #False
          Break
        EndIf
      Case "endselect"
        If Tag = "select"
          Result = #False
          Break
        EndIf
      Case "until"
        If Tag = "repeat"
          Result = #False
          Break
        EndIf
      Case "forever"
        If Tag = "repeat"
          Result = #False
          Break
        EndIf
      Case "next"
        If Tag = "for" Or Tag = "foreach"
          Result = #False
          Break
        EndIf
      Case "wend"
        If Tag = "while"
          Result = #False
          Break
        EndIf
      Case "enddatasection"
        If Tag = "datasection"
          Result = #False
          Break
        EndIf
      Case "endprocedure"
        If Tag = "procedure" Or Tag = "procedurec" Or Tag = "proceduredll" Or Tag = "procedurecdll"
          Result = #False
          Break
        EndIf
      Case "endstructure"
        If Tag = "structure"
          Result = #False
          Break
        EndIf
      Case "endinterface"
        If Tag = "interface"
          Result = #False
          Break
        EndIf
      Case "endenumeration"
        If Tag = "enumeration"
          Result = #False
          Break
        EndIf
      Case "endwith"
        If Tag = "with"
          Result = #False
          Break
        EndIf
      Case "endimport"
        If Tag = "import" Or Tag = "importc"
          Result = #False
          Break
        EndIf
      Case "endmacro"
        If Tag = "macro"
          Result = #False
          Break
        EndIf
    EndSelect
    i + 1
    a$ = FindCommand(b$, i)
  Wend

  ProcedureReturn Result
EndProcedure

Procedure Main()
  Protected MyTab.s, a$, b$, Tabs.l, i.l, Found.l, *index, UTF_Flag.l

  NewList Lines.s()
  NewList Tags._TAGS_()
  NewList MTags._TAGS_()

  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  OpenPreferences(GetEnvironmentVariable("HOME") + ".purebasic/purebasic.prefs")
  CompilerElse
  OpenPreferences(GetPathPart(GetEnvironmentVariable("PB_TOOL_IDE")) + "purebasic.prefs")
  CompilerEndIf
  PreferenceGroup("Global")
  If ReadPreferenceLong("RealTab", 0)
    MyTab = #TAB$
  Else
    MyTab = Space(ReadPreferenceLong("TabLength", 2))
  EndIf
  ClosePreferences()

  a$ = ProgramParameter()
  If a$ = "" Or ReadFile(0, a$) = 0
    MessageRequester("Error!", "Datei '" + a$ + "' nicht auffindbar!")
    End
  EndIf
  UTF_Flag = ReadStringFormat(0)
  If UTF_Flag <> #PB_UTF8
    UTF_Flag = #PB_Ascii
  EndIf
  Tabs = 3

  Restore Tags
  Repeat
    Read b$
    If b$ = ""
      Tabs - 1
      If Tabs = 0
        Break
      EndIf
    Else
      AddElement(Tags())
      Tags()\Tabs = Tabs
      Tags()\Name = b$
    EndIf
  ForEver

  While Eof(0) = 0
    AddElement(Lines())
    b$ = MyTrim(ReadString(0, UTF_Flag))
    Lines() = b$
    i + 1
  Wend
  CloseFile(0)
  Tabs = 0
  ForEach Lines()
    b$ = LCase(StringField(StringField(Lines(), 1, " "), 1, "."))
    Found = #False
    ForEach Tags()
      If b$ = Tags()\Name
        Found = #True
        Select Tags()\Tabs
          Case 3
            ;StartTag
            Lines() = AddTabs(Tabs, MyTab) + Lines()
            If CheckForEndTag(Lines(), b$)
              If b$ = "if" Or b$ = "select"
                ;They have middletags!
                LastElement(MTags())
                AddElement(MTags())
                MTags()\Name = b$
                MTags()\Tabs = Tabs
              EndIf
              Tabs + 1
            EndIf
          Case 2
            ;MiddleTags need special treetment
            If LastElement(MTags())
              If MTags()\Name = "if"
                Tabs = MTags()\Tabs
              ElseIf MTags()\Name = "select"
                Tabs = MTags()\Tabs + 1
              EndIf
            EndIf
            Lines() = AddTabs(Tabs, MyTab) + Lines()
            Tabs + 1
          Case 1
            ;EndTag
            Tabs - 1
            ;Check for MiddleTags
            If b$ = "endif" And LastElement(MTags()) And MTags()\Name = "if"
              DeleteElement(MTags())
            ElseIf b$ = "endselect" And LastElement(MTags()) And MTags()\Name = "select"
              Tabs - 1
              DeleteElement(MTags())
            EndIf
            Lines() = AddTabs(Tabs, MyTab) + Lines()
        EndSelect
        Break
      EndIf
    Next
    If Found = #False
      If Lines()
        Lines() = AddTabs(Tabs, MyTab) + Lines()
      EndIf
    EndIf
  Next

  Found = #PB_MessageRequester_Yes
  If Tabs <> 0
    ;Something wrong with the code...
    Found = MessageRequester("Error!", "Something wrong with your Code!" + #LF$ + "Would you like to parse it anyway ?", #PB_MessageRequester_YesNo)
  EndIf
  If Found = #PB_MessageRequester_Yes

    If CreateFile(0, a$)
      WriteStringFormat(0, UTF_Flag)
      ForEach Lines()
        WriteStringN(0, Lines(), UTF_Flag)
      Next
      CloseFile(0)
    EndIf

  EndIf
EndProcedure

Main()
End

DataSection
  Tags:
  ;StartTags
  Data.s "if"
  Data.s "while"
  Data.s "repeat"
  Data.s "procedure"
  Data.s "procedurec"
  Data.s "proceduredll"
  Data.s "procedurecdll"
  Data.s "enumeration"
  Data.s "structure"
  Data.s "interface"
  Data.s "for"
  Data.s "foreach"
  Data.s "select"
  Data.s "datasection"
  Data.s "with"
  Data.s "import"
  Data.s "importc"
  Data.s "macro"
  Data.s ""
  ;MiddleTags
  Data.s "else"
  Data.s "elseif"
  Data.s "case"
  Data.s "default"
  Data.s ""
  ;EndTags
  Data.s "endif"
  Data.s "wend"
  Data.s "until"
  Data.s "forever"
  Data.s "endprocedure"
  Data.s "endstructure"
  Data.s "endinterface"
  Data.s "endenumeration"
  Data.s "next"
  Data.s "endselect"
  Data.s "enddatasection"
  Data.s "endwith"
  Data.s "endimport"
  Data.s "endmacro"
  Data.s ""
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; Executable = Hexor_Einrücker.exe