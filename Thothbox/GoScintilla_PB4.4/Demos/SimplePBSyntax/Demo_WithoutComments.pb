;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla***
;*=================
;*
;*©nxSoftWare (www.nxSoftware.com) 2009.
;*======================================
;*  Stephen Rodriguez (srod) with thanks to ts-soft for his ScintillaHelper library upon which this is, in some part, based.
;*  Created with Purebasic 4.4 for Windows.
;*
;*  Platforms:  All.
;*    
;*  Uncommented demo program.
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "..\..\"
XIncludeFile "GoScintilla.pbi"


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 600, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.

  ;Create our Scintilla control. Note that we do not specify a callback; this is optional for GoSctintilla.
    GOSCI_Create(1, 10, 10, 580, 580, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN|#GOSCI_ALLOWCODEFOLDING)

  ;Set the padding added to the width of the line-number margin.
    GOSCI_SetAttribute(1, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)

  ;Set folding symbols margin width.
    GOSCI_SetMarginWidth(1, #GOSCI_MARGINFOLDINGSYMBOLS, 24)

  ;Set the back color of the line containing the caret.
    GOSCI_SetColor(1, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)

  ;Set font.
    GOSCI_SetFont(1, "Courier New", 10)

  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
    GOSCI_SetTabs(1, 2)

  ;Set styles for our syntax highlighting.
  ;=======================================
      Enumeration
        #STYLES_COMMANDS = 1
        #STYLES_COMMENTS
        #STYLES_LITERALSTRINGS
        #STYLES_NUMBERS
        #STYLES_CONSTANTS
        #STYLES_FUNCTIONS
      EndEnumeration

    ;Set individual styles for commands.
      GOSCI_SetStyleFont(1, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
      GOSCI_SetStyleColors(1, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.

    ;Set individual styles for comments.
      GOSCI_SetStyleFont(1, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
      GOSCI_SetStyleColors(1, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.

    ;Set individual styles for literal strings.
      GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.

    ;Set individual styles for numbers.
      GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

    ;Set individual styles for constants.
      GOSCI_SetStyleColors(1, #STYLES_CONSTANTS, $2193DE)  ;We have omitted the optional back color.

    ;Set individual styles for functions.
      GOSCI_SetStyleColors(1, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.


  ;Set keywords for our syntax highlighting.
  ;=========================================
      GOSCI_AddKeywords(1, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)
      GOSCI_AddKeywords(1, ";", #STYLES_COMMENTS, #GOSCI_DELIMITTOENDOFLINE)
      GOSCI_AddKeywords(1, Chr(34) + Chr(34), #STYLES_LITERALSTRINGS, #GOSCI_DELIMITBETWEEN)
      GOSCI_AddKeywords(1, "#", #STYLES_CONSTANTS, #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
      GOSCI_AddKeywords(1, "(", #STYLES_FUNCTIONS, #GOSCI_RIGHTDELIMITWITHWHITESPACE)
      GOSCI_AddKeywords(1, ")", #STYLES_FUNCTIONS)

    ;Add some folding keywords.
      GOSCI_AddKeywords(1, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD|#GOSCI_DELIMITNONE)
      GOSCI_AddKeywords(1, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD|#GOSCI_DELIMITNONE)


  ;Additional lexer options.
  ;=========================
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Set some initial text.
  ;======================
    text$ = "; GoScintilla." + #CRLF$
    text$ + "; By Stephen Rodriguez." + #CRLF$ + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
    
    GOSCI_SetText(1, text$)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_Gadget
        Select EventGadget()
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow 

  ;Free the Scintilla gadget.
    GOSCI_Free(1)
EndIf


; IDE Options = PureBasic 4.40 Beta 7 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 79
; FirstLine = 65
; EnableUnicode
; EnableThread
; EnableXP
; Executable = d.exe.dll.exe.dll