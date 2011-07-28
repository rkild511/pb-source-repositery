Macro initCodeGadget(__gdt)
  ;#PB_Panel_TabHeight

  GOSCI_Create(__gdt, 10, 10, GetGadgetAttribute(#gdt_tab,#PB_Panel_ItemWidth)-20, GetGadgetAttribute(#gdt_tab,#PB_Panel_ItemHeight)-20, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN|#GOSCI_ALLOWCODEFOLDING)
  
  ;Set the padding added to the width of the line-number margin.
  GOSCI_SetAttribute(__gdt, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)
  
  ;Set folding symbols margin width.
  GOSCI_SetMarginWidth(__gdt, #GOSCI_MARGINFOLDINGSYMBOLS, 24)
  
  ;Set the back color of the line containing the caret.
  GOSCI_SetColor(__gdt, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)
  
  ;Set font.
  GOSCI_SetFont(__gdt, "Courier New", 10)
  
  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
  GOSCI_SetTabs(__gdt, 2)
  
  ;Set styles for our syntax highlighting.
  ;=======================================
  ;First define some constants to identify our various styles.
  ;You can name these as we wish.
  Enumeration
    #STYLES_COMMANDS = 1
    #STYLES_COMMENTS
    #STYLES_LITERALSTRINGS
    #STYLES_NUMBERS
    #STYLES_CONSTANTS
    #STYLES_FUNCTIONS
  EndEnumeration
  
  ;Set individual styles for commands.
  GOSCI_SetStyleFont(__gdt, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
  GOSCI_SetStyleColors(__gdt, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.
  
  ;Set individual styles for comments.
  GOSCI_SetStyleFont(__gdt, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
  GOSCI_SetStyleColors(__gdt, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.
  
  ;Set individual styles for literal strings.
  GOSCI_SetStyleColors(__gdt, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.
  
  ;Set individual styles for numbers.
  GOSCI_SetStyleColors(__gdt, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.
  
  ;Set individual styles for constants.
  GOSCI_SetStyleColors(__gdt, #STYLES_CONSTANTS, $2193DE)  ;We have omitted the optional back color.
  
  ;Set individual styles for functions.
  GOSCI_SetStyleColors(__gdt, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.
  
  ;Set keywords for our syntax highlighting.
  ;=========================================
  ;First some commands.
  GOSCI_AddKeywords(__gdt, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)
  ;Now set up a ; symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
  ;Note also that this symbol will act as an additional separator.
  GOSCI_AddKeywords(__gdt, ";", #STYLES_COMMENTS, #GOSCI_DELIMITTOENDOFLINE)
  ;Now set up quotes to denote literal strings.
  ;We do this by passing the beginning and end delimiting characters; in this case both are quotation marks. Note the use of #GOSCI_DELIMITBETWEEN.
  ;Note also that a quote will subsequently act as an additional separator.
  GOSCI_AddKeywords(__gdt, Chr(34) + Chr(34), #STYLES_LITERALSTRINGS, #GOSCI_DELIMITBETWEEN)
  ;Now set up a # symbol to denote a constant. Note the use of #GOSCI_LEFTDELIMITWITHOUTWHITESPACE.
  GOSCI_AddKeywords(__gdt, "#", #STYLES_CONSTANTS, #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
  ;Now set up a ( symbol to denote a function. Note the use of #GOSCI_RIGHTDELIMITWITHWHITESPACE.
  GOSCI_AddKeywords(__gdt, "(", #STYLES_FUNCTIONS, #GOSCI_RIGHTDELIMITWITHWHITESPACE)
  ;We arrange for a ) symbol to match the coloring of the ( symbol.
  GOSCI_AddKeywords(__gdt, ")", #STYLES_FUNCTIONS)
  
  ;Add some folding keywords.
  GOSCI_AddKeywords(__gdt, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD|#GOSCI_DELIMITNONE)
  GOSCI_AddKeywords(__gdt, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD|#GOSCI_DELIMITNONE)
  
  
  ;Additional lexer options.
  ;=========================
  ;The lexer needs to know what separator characters we are using.
  GOSCI_SetLexerOption(__gdt, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
  ;We can also set a style for numbers.
  GOSCI_SetLexerOption(__gdt, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)
  ;}  
EndMacro

Procedure clearTabcode()
  Protected gdt.i
  ForEach gp\file()
    gdt=#gdt_end+ListIndex(gp\file())
    If IsGadget(gdt)
      GOSCI_Free(gdt)
      FreeGadget(gdt)
    EndIf
    If IsImage(gdt)
      FreeImage(gdt)
    EndIf
  Next
  ClearGadgetItems(#gdt_tab)
EndProcedure

Procedure initTabCode()
  Protected z.l,gdt.i,code.s
  ForEach gp\file()
    OpenGadgetList(#gdt_tab)
    AddGadgetItem (#gdt_tab, ListIndex(gp\file()), gp\file()\filename)
    gdt=#gdt_end+ListIndex(gp\file())
    Select LCase(GetExtensionPart(gp\file()\filename))
      Case "pb","pbi",""
        initCodeGadget(gdt)
        code="";
        If ReadFile(0,GetTemporaryDirectory()+gp\file()\filename)
          While Eof(0) = 0           ; loop as long the 'end of file' isn't reached
            code=code+ ReadString(0)+#LF$      ; display line by line in the debug window
          Wend
          CloseFile(0)
          GOSCI_SetText(gdt, code)

        Else
          MessageRequester("Error InitTabCode()","Can't Read Code from"+#LFCR$+GetTemporaryDirectory()+gp\file()\filename)
        EndIf
        
      Case "jpb","png","bmp","jpeg"
        If LoadImage(gdt,GetTemporaryDirectory()+gp\file()\filename)
          ImageGadget(gdt,0,0,580,580,ImageID(gdt))
        EndIf
      Default
    EndSelect
    CloseGadgetList()
  Next  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 98
; FirstLine = 72
; Folding = -
; EnableXP