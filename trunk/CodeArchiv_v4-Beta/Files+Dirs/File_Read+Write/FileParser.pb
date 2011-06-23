; English forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 25. March 2005
; OS: Windows
; Demo: No

Global Dim AsciiConv.s(255)
Global Dim AllWords.s(10000000)
Global Dim UniqueWords.s(1000000)
Global Dim WordCount.l(1000000)

Global NLines.l, NWords.l, EOL.s, CurrentDirectory.s, AsciiConv, Allwords, UniqueWords, WordCount

Global MemFileOffset.l, MemFileSize.l, *FileBuffer

Procedure.l LoadFileToMem(fileID,fname.s) 
  ;Protected fileID,fname 
  If ReadFile(fileID,fname)
      MemFileSize = Lof(fileID)
      Debug "MemFileSize = " + Str(MemFileSize)
      *FileBuffer = AllocateMemory(MemFileSize)
      If *FileBuffer
          ReadData(fileID,*FileBuffer,MemFileSize)
      EndIf 
      CloseFile(fileID)
      MemFileOffset = 0 ; reset 
  EndIf 
  ProcedureReturn *FileBuffer
EndProcedure 

Procedure MoreInMem()
  If MemFileOffset < MemFileSize
      ok = 1
  EndIf
  ProcedureReturn ok
EndProcedure 

Procedure.s ReadLineFromMem() ; in case EOF: empty line is returned 
  If *FileBuffer And MoreInMem()
      Start = *FileBuffer + MemFileOffset
      Length = 0
      Repeat
        Length + 1
        Byte.b = PeekB(Start + Length)
      Until  Byte = 13 Or Byte = 10 Or MemFileOffset + Length >= MemFileSize
  EndIf
  Skip = 1
  Byte = PeekB(Start + Length + 1) 
  If Byte = 10 Or Byte = 13
      Length + 1
      Skip + 1
  EndIf
  MemFileOffset + Length
  ProcedureReturn PeekS(Start + 1, Length - Skip)
EndProcedure

Procedure CloseFileMem()
  FreeMemory(*FileBuffer)
EndProcedure

Procedure.l IMod(a.l, b.l)
  ProcedureReturn a - (b * (a / b))
EndProcedure

Procedure ParseFile(Filename.s)
  Debug "Parsing : " + Filename
  SetGadgetText(100, "Processing file " + Filename)
  CurrentDirectory = GetPathPart(Filename)
  If LoadFileToMem(0, Filename)
      While MoreInMem()
        NLines + 1
        a$ = LTrim(RTrim(ReadLineFromMem()))
        b$ = ""
        For i = 1 To Len(a$)
          b$ = b$ + AsciiConv(Asc(Mid(a$, i, 1)))
        Next
        While FindString(b$, "  ", 1) <> 0
          b$ = ReplaceString(b$, "  ", " ")
        Wend
        b$ = LTrim(RTrim(b$))
        If Len(b$) <> 0
            While FindString(b$, " ", 1) <> 0
              AllWords(NWords) = Mid(b$, 1, FindString(b$, " ", 1) - 1)
              NWords + 1
              b$ = Mid(b$, FindString(b$, " ", 1) + 1, Len(b$) - FindString(b$, " ", 1) - 1 + 1)
            Wend
            AllWords(NWords) = b$
            NWords + 1
        EndIf
        If IMod(NLines, 2500) = 0
            StatusBarText(0, 0, "Parsing line #" + Str(NLines) + " ... found " + Str(NWords) + " words.", 0)
        EndIf
      Wend
      StatusBarText(0, 0, "Parsing line #" + Str(NLines) + " ... found " + Str(NWords) + " words.", 0)
  EndIf
EndProcedure

;
;
;

  Quit.l = #False
  WindowXSize.l = 320
  WindowYSize.l = 240

  CurrentDirectory = Space(255)
  GetCurrentDirectory_(255, @CurrentDirectory)
  
  EOL.s = Chr(13) + Chr(10)
  
  For i = 0 To 255
    AsciiConv(i) = Chr(i)
  Next
  
  AsciiConv(Asc(".")) = " "
  AsciiConv(Asc(",")) = " "
  AsciiConv(Asc(":")) = " "
  AsciiConv(Asc(";")) = " "
  AsciiConv(Asc("+")) = " "
  AsciiConv(Asc("-")) = " "
  AsciiConv(Asc("*")) = " "
  AsciiConv(Asc("/")) = " "
  AsciiConv(Asc("(")) = " "
  AsciiConv(Asc(")")) = " "
  AsciiConv(Asc("[")) = " "
  AsciiConv(Asc("]")) = " "
  AsciiConv(Asc("'")) = " "
  AsciiConv(Asc("!")) = " "
  AsciiConv(Asc("?")) = " "
  AsciiConv(Asc("{")) = " "
  AsciiConv(Asc("}")) = " "
  AsciiConv(Asc("=")) = " "
  AsciiConv(Asc("<")) = " "
  AsciiConv(Asc(">")) = " "
  AsciiConv(Asc(Chr(34))) = " "
  AsciiConv(Asc(Chr(9))) = " "
  
  hwnd.l = OpenWindow(0, 200, 200, WindowXSize, WindowYSize, "MyWindow", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar)
  If hwnd
      AddKeyboardShortcut(0, #PB_Shortcut_Escape, 99)
      LoadFont(0, "Verdana", 12)
      FontID.l = FontID(0)
      If CreateMenu(0, WindowID(0))
        OpenSubMenu("General")
          MenuItem(11, "Open file")
          MenuItem(99, "Quit")
        CloseSubMenu()
      EndIf
      If CreateStatusBar(0, WindowID(0))
          StatusBarText(0, 0, "Idle ...", 0)
      EndIf
      If CreateGadgetList(WindowID(0))
          SetGadgetFont(#PB_Default,FontID)
          TextGadget(100, 10, 10, WindowXSize - 20, WindowYSize - 40, "")
      EndIf
      SetGadgetText(100, "Select a file to process ...")
      Repeat
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Quit = #True
          Case #PB_Event_Menu
            Select EventMenu()
              Case 11
                Filename.s = OpenFileRequester("Select a file", CurrentDirectory + "\" + "*.txt", "Text files|*.txt|All files|*.*", 0, #PB_Requester_MultiSelection)
                NLines.l = 0
                NWords.l = 0
                tz.l = GetTickCount_()
                ParseFile(Filename)
                NWords - 1
                SetGadgetText(100, "File : " + Filename + EOL + "Lines : " + Str(NLines) + EOL + "Words : " + Str(NWords + 1))

                SortArray(AllWords(), 0, 0, NWords)

                j = 0
                UniqueWords(j) = AllWords(j)
                WordCount(j) = 1
                For i = 1 To NWords
                  If AllWords(i) <> AllWords(i - 1)
                      j + 1
                      UniqueWords(j) = AllWords(i)
                      WordCount(j) = 1
                    Else
                      WordCount(j) + 1
                  EndIf
                Next
                NUniqueWords.l = j
                SetGadgetText(100, "File : " + Filename + EOL + "Lines : " + Str(NLines) + EOL + "Words : " + Str(NWords + 1) + EOL + "Unique words : " + Str(NUniqueWords + 1) + EOL + "Done in " + Str(GetTickCount_() - tz) + "ms")
                If CreateFile(0, "result.txt")
                    For z = 0 To NUniqueWords
                      WriteStringN(0,Str(z) + " " + UniqueWords(z) + Chr(9) + Chr(9) + Str(WordCount(z)))
                    Next
                    CloseFile(0)
                EndIf
                ShellExecute_(hwnd,"open","result.txt","","",#SW_SHOWNORMAL)
              Case 99
                Quit = #True
            EndSelect
        EndSelect
      Until Quit
  EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --