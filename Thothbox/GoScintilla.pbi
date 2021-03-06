﻿

CompilerIf Defined(INCLUDE_GOSCINTILLA, #PB_Constant)=0
  #INCLUDE_GOSCINTILLA=1
  ;/////////////////////////////////////////////////////////////////////////////////
  ;***Go-Scintilla***  Version 1.1.
  ;*=================
  ;*
  ;*©nxSoftWare (www.nxSoftware.com) 2009.
  ;*======================================
  ;*  Stephen Rodriguez (srod) with thanks to ts-soft for his ScintillaHelper library upon which this is, in some part, based.
  ;*  Created with Purebasic 4.4 for Windows.
  ;*
  ;*  Platforms:  All.
  ;*    
  ;*  This source code utility attempts to wrap some of the Scintilla api, concentrating in particular upon syntax highlighting.
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;*NOTES.
  ;
  ; i)      This helper-library allows easy access to syntax highlighting etc.
  ;
  ; ii)     Uses Purebasic's Scintilla library, which, under Windows, requires initialising with InitScintilla().
  ;
  ; iii)    Scintilla gadgets created with this library should not be accessed by multiple-threads at the same time. Not without mutex protection anyhow.
  ;
  ; iv)     This uses the #SC_CP_UTF8 (UTF-8) code-page.
  ;
  ; v)      Do not use Get/SetGadgetData() with Scintilla gadgets created through this library.
  ;         Use GOSCI_Get/GOSCI_SetUseData() instead.
  ;
  ; vi)     All 'keywords' (used by the syntax lexer) must contain only Ascii characters. Unicode characters can appear in comments and literal strings only.
  ;
  ; vii)    Use the GOSCI_SetLineStylingFunction() function to use your own lexer/styler. See the default function for details on how to construct
  ;         your own function.
  ;
  ;         If using your own function to style individual lines then you will need to use certain Scintilla functions to style the
  ;         different lexical entities making up the line.
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;***Go-Scintilla***
  ;*=================
  ;*
  ;*'Header' file for public use.
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-CONSTANTS.
  
  ;Creation flags.  Use a combination of the following.
  Enumeration
    #GOSCI_AUTOSIZELINENUMBERSMARGIN    = 1
    #GOSCI_KEYWORDSCASESENSITIVE        = 2   ;Use if the keywords lists (syntax highlighting etc.) are case sensitive.
    #GOSCI_ALLOWCODEFOLDING             = 4
  EndEnumeration
  
  ;Margins.
  Enumeration 
    #GOSCI_MARGINLINENUMBERS
    #GOSCI_MARGINNONFOLDINGSYMBOLS
    #GOSCI_MARGINFOLDINGSYMBOLS
    #GOSCI_MARGINUSER1
    #GOSCI_MARGINUSER2
  EndEnumeration
  
  ;Colors. Used when setting colors for the entire control (not individual styles).
  ;Some (but not all) of the colors can be retrieved with GOSCI_GetColor().
  Enumeration 1
    #GOSCI_BACKCOLOR                    ;Get/Set.
    #GOSCI_FORECOLOR                    ;Get/Set.
    #GOSCI_SELECTIONBACKCOLOR           ;Set.
    #GOSCI_SELECTIONFORECOLOR           ;Set.
    #GOSCI_LINENUMBERBACKCOLOR          ;Get/Set.
    #GOSCI_LINENUMBERFORECOLOR          ;Get/Set.
    #GOSCI_CARETLINEBACKCOLOR           ;Get/Set. Set color to -1 to remove the visible line.
    #GOSCI_CARETFORECOLOR               ;Get/Set.
    ;The following colors require #SC_MASK_FOLDERS mask bits to be set for the symbol margin. Set by default for margin #GOSCI_MARGINFOLDINGSYMBOLS.
    #GOSCI_FOLDMARGINLOBACKCOLOR    ;Set.
    #GOSCI_FOLDMARGINHIBACKCOLOR    ;Set.
    #GOSCI_FOLDMARKERSBACKCOLOR     ;Set.
    #GOSCI_FOLDMARKERSFORECOLOR     ;Set.
  EndEnumeration
  
  ;Attributes.  All can be set, some can be retrieved as well.
  ;Use with GOSCI_SetAttribute() and GOSCI_GetAttribute() as appropriate.
  Enumeration 1
    #GOSCI_READONLY                     ;Get/Set.
    #GOSCI_LINENUMBERAUTOSIZEPADDING    ;Get/Set.
    ;Added to the calculated line-number margin width when the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag is used.
    #GOSCI_CANUNDO                      ;Get/Set.
    #GOSCI_WRAPLINES                    ;Get/Set.
    #GOSCI_WRAPLINESVISUALMARKER        ;Get/Set.
    ;Value = 0 for no marker, 1 for marker at the end of the subline, 2 for beginning of subline.
  EndEnumeration
  
  ;Keywords.
  ;Use with the GOSCI_AddKeywords() function as the optional flags parameter.
  ;Use a combination of delimiter constants combined (or'd) with one folding constant.
  ;One left delimiter can be combined with one right delimiter; otherwise use at most one delimiter constant.
  Enumeration
    ;Delimiter flags.
    #GOSCI_DELIMITNONE                      = 1  ;Default.
    #GOSCI_DELIMITBETWEEN                   = 2   ;Ex. 1, set a keyword to "" (a pair of quotes) to have everything between quotes treated as a single keyword.
    ;Ex. 2, set a keyword to [] to have everything within square paranthesis treated as a single keyword.
    ;The first symbol in such a pairing will be regarded AS AN ADDITIONAL SEPARATOR.
    ;The following all require single character (Ascii) keywords.
    #GOSCI_DELIMITTOENDOFLINE             = 4   ;Ex.1 set a keyword to ; to have everything from this symbol to the end of a line treated as a single keyword.
    ;Such symbols will be regarded AS ADDITIONAL SEPARATORS.
    #GOSCI_LEFTDELIMITWITHWHITESPACE      = 8   ;Ex. set a keyword to # to have every symbol (e.g. #Test, #   test) beginning with this character treated as a keyword.
    #GOSCI_LEFTDELIMITWITHOUTWHITESPACE   = 16  ;Same as above, but does not count symbols such as '#   test' (those with white space).
    #GOSCI_RIGHTDELIMITWITHWHITESPACE     = 32  ;Ex. set a keyword to [ to have every symbol (e.g. test[, test   [) ending with this character treated as a keyword.
    #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE  = 64  ;Same as above, but does not count symbols such as 'test   [' (those with white space).
    ;Add the following to have the delimiter not behave like a separator.
    #GOSCI_NONSEPARATINGDELIMITER         =$8000
    ;Folding flags.
    #GOSCI_OPENFOLDKEYWORD              = $10000
    #GOSCI_CLOSEFOLDKEYWORD             = $20000
  EndEnumeration
  
  ;Lexer options.
  ;Use with GOSCI_GetLexerOption()/GOSCI_SetLexerOption().
  Enumeration 1
    #GOSCI_LEXEROPTION_SEPARATORSYMBOLS   ;E.g. "+-*/,()". Used by the default Lexer to separate lexical entities when coloring lines.
    ;For GOSCI_SetLexerOption(), set value to the address of a character buffer containing the separator symbols.
    ;GOSCI_GetLexerOption() returns the address of the character buffer etc. Use PeekS() to get the string.
    ;Non-ascii separators are not supported by our default lexer.
    #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX  ;For GOSCI_SetLexerOption(), set value to a style index. Default is #STYLE_DEFAULT.
  EndEnumeration
  
  ;Lexer states. Use a combination of values.
  ;Use with GOSCI_GetLexerState()/GOSCI_SetLexerState().
  Enumeration
    #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING   = 1   ;Enabled by default.
  EndEnumeration
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-User defined line styling function.
  
  ;GoScintilla allows the user to declare an additional (and optional) line styling function which is invoked whenever a line requires
  ;re-styling. This function can call on GoScintilla to style parts of the line as appropriate.
  ;The return value from this function determines whether additional lines are to be styled beyond those originally marked for styling etc.
  ;(Typically, a few lines are 'marked' for styling at any given time.)
  
  ;The user-defined line styling function must follow the prototype given :
  Prototype.i GOSCI_proto_StyleLine(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
  ;where *utf8Buffer points to a character buffer containing the bytes to style and numUtf8Bytes gives the number of UTF-8 bytes (not characters)
  ;in the line to style. This will include any EOL bytes (typically #CRLF$).
  ;The remaining parameters are provided for information only.
  ;Your function must return one of the following values as appropriate :
  Enumeration
    #GOSCI_STYLELINESASREQUIRED       ;Continue styling lines as directed by the Scintilla library. Stop once the lines originally marked for
    ;restyling have been styled.
    #GOSCI_STYLENEXTLINEREGARDLESS    ;Style the next line regardless of whether it is one of the lines originally marked for styling.
  EndEnumeration  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-STRUCTURES.
  
  ;The following is held in a PB map (has to be global because PB does not allow us to embed maps within structures) and contains
  ;information on individual keywords.
  ;Use the GOSCI_GetKeywordInfo() function to retrieve this info for any given keyword. Only really useful for those apps which decide to
  ;user their own customised lexer etc.
  Structure GoScintillaKeywords
    id.i                    ;Scintilla#    
    styleIndex.i            ;0-based index of the style to apply.
    flags.i                 ;Set with the GOSCI_AddKeywords() function. A combination of the constants listed above.
    closeDelimiter.a        ;Used for delimiters of type #GOSCI_DELIMITBETWEEN to record the character used as the close delimiter.
  EndStructure
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-CONSTANTS.
  
  ;Used to separate the delimiter constants from the folding ones.
  #GOSCI_KEYWORDDELIMITERMASK = $7fff
  #GOSCI_KEYWORDFOLDINGMASK   = $ffff0000
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; GUIMAUVE : Les constantes pour les couleurs de base sont définies dans le fichier
  ;            "Thothbox - Constants.pb"
  
  ;   CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  ;     #White = 16777215
  ;     #Gray = 8421504
  ;     #Red = 255
  ;     #Blue = 16711680
  ;   CompilerEndIf

  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-PROTOTYPES.
  Prototype GOSCI_proto_Callback(id, *scinotify.SCNotification)
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-STRUCTURES.
  
  ;The following structure holds information (such as syntax highlighting info) on individual Scintilla controls.
  Structure _GoScintilla
    ;Creation fields.
    id.i
    callback.GOSCI_proto_Callback
    flags.i
    state.i
    ;Custom line styling function.
    stylingFunction.GOSCI_proto_StyleLine
    ;Additional user-supplied data.
    userData.i
    lineNumberAutoSizePadding.i
    lexerSeparators$
    lexerNumbersStyleIndex.i
    ;Code folding.
    blnLineCodeFoldOption.i     ;0 = no code folding, 1 = open fold, 2 = close fold.
    foldLevel.i
    ;Styling.
    previouslyRecordedStyle.i   ;Used for left delimiters (separators).
    *bytePointer.i              ;Used for left delimiters (separators).
    ;Miscellaneous.
    blnEmptyLineAdded.i
  EndStructure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-DECLARES.
  
  Declare.i GOSCI_IsSeparatorXXX(*this._GoScintilla, symbol.a, *keyword.INTEGER)
  Declare.i GOSCI_GetKeywordInfo(id, keyWord$)
  Declare GOSCI_SetStyleFont(id, styleIndex, fontName$, fontSize=-1, fontStyle=-1)
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-GLOBALS.
  
  Global NewMap gGOSCI_Keywords.GoScintillaKeywords()
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-INTERNAL FUNCTIONS.
  ;-=====================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following internal function adjusts the line number margin in the case that the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag was set.
  Procedure GOSCI_AutosizeLineNumberMarginXXX(id)
    Protected *this._GoScintilla, numLines, numChars, t1, utf8Buffer
    *this = GetGadgetData(id)
    If *this And *this\flags & #GOSCI_AUTOSIZELINENUMBERSMARGIN
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      numChars = Len(Str(numLines))
      ;Fill a UTF-8 buffer with the appropriate number of '9' 's.
      utf8Buffer = AllocateMemory(numChars+1)
      If utf8Buffer
        FillMemory(utf8Buffer, numChars, '9')
        t1 = ScintillaSendMessage(id, #SCI_TEXTWIDTH, #STYLE_LINENUMBER, utf8Buffer) + *this\lineNumberAutoSizePadding + 10
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, #GOSCI_MARGINLINENUMBERS, t1)
        FreeMemory(utf8Buffer)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is used to free structured strings.
  Procedure GOSCI_FreeStructureStringXXX(*Address) 
    Protected String.String 
    PokeI(@String, *Address)
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-INTERNAL FUNCTIONS - Default lexer functions.
  ;-========================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is used by the default line styler to determine if the next symbol is a valid number?
  ;Returns the total number of bytes in the number string (so zero if not a valid number). In the case of the symbol being a number, the number of digits is placed into the specified buffer.
  Procedure.i GOSCI_IsNumberXXX(*this._GoScintilla, *bytePtr.ASCII, numBytesRemaining, *numDigits.INTEGER)
    Protected numBytesInNumber, numDecimalPoints, numDigits, t1
    While numBytesInNumber < numBytesRemaining
      If *bytePtr\a = '.'
        If numDecimalPoints
          numBytesInNumber = 0
          Break
        EndIf
        numDecimalPoints + 1
      ElseIf *bytePtr\a >= '0' And *bytePtr\a <= '9'
        numDigits + 1
      ElseIf *bytePtr\a = 9 Or *bytePtr\a = 32 Or GOSCI_IsSeparatorXXX(*this, *bytePtr\a, @t1)
        Break
      Else
        numBytesInNumber = 0
        Break
      EndIf
      *bytePtr + 1
      numBytesInNumber + 1
    Wend
    If numBytesInNumber
      *numDigits\i = numDigits
    EndIf
    ProcedureReturn numBytesInNumber
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is used by the default line styler to determine if the given symbol represents a separator character or not?
  ;Returns #True or #False as appropriate. In the case of the symbol being a separator, it also fills the *keyword buffer with any associated keyword info.
  Procedure.i GOSCI_IsSeparatorXXX(*this._GoScintilla, symbol.a, *keyword.INTEGER)
    Protected result = #False, *ptrChar.CHARACTER, *ptrKeyword.GoScintillaKeywords
    ;First check the list of separators.
    *ptrChar = @*this\lexerSeparators$  ;External Lexer's should use GOSCI_GetLexerOption() to retrieve this address.
    If symbol = #LF Or symbol = #CR
      result = #True
    Else
      While *ptrChar\c
        If *ptrChar\c = symbol
          result = #True
          Break
        EndIf
        *ptrChar + SizeOf(CHARACTER)
      Wend
    EndIf
    ;Retrieve any associated keyword info.
    *ptrKeyword = GOSCI_GetKeywordInfo(*this\id, Chr(symbol))
    ;If symbol not identified as an explicit separator then we check if it is a delimiter.
    If result = #False
      If *ptrKeyword 
        If *ptrKeyword\flags&#GOSCI_KEYWORDDELIMITERMASK <> #GOSCI_DELIMITNONE And *ptrKeyword\flags&#GOSCI_NONSEPARATINGDELIMITER=0
          result = #True
        EndIf
      EndIf
    EndIf
    If result = #True
      *keyword\i = *ptrKeyword
    Else
      *keyword\i = 0
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is called by our default line-styling function to style individual symbols.
  ;The optional blnDoNotApplyStyle parameter will prevent all styling / code folding being applied to the symbol in question. Intended for
  ;use by user-defined line styling functions which may need to look ahead at additional symbols before styling them.
  ;Returns the number of bytes styled.
  Procedure.i GOSCI_StyleNextSymbolXXX(*this._GoScintilla, *bytePtr.ASCII, numBytesRemaining, blnDoNotApplyStyle=#False)
    Protected numBytesToStyle, styleToUse, *ptrBytes.ASCII, *ptrBytes2.ASCII, *keyword.GoScintillaKeywords, *keywordNext.GoScintillaKeywords
    Protected text$, t1, t2, openDelimeter.a, numSpaces
    *ptrBytes = *bytePtr
    styleToUse = *this\previouslyRecordedStyle
    ;Have we white space?
    If *ptrBytes\a = 32 Or *ptrBytes\a = 9
      While numBytesToStyle < numBytesRemaining And (*ptrBytes\a = 32 Or *ptrBytes\a = 9)
        numBytesToStyle + 1
        *ptrBytes+1
      Wend
      ;Else, have we a separator?
    ElseIf GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keyword)
      If blnDoNotApplyStyle = #False
        *this\previouslyRecordedStyle = #STYLE_DEFAULT
      EndIf
      numBytesToStyle = 1
      styleToUse = #STYLE_DEFAULT
      If *keyword
        styleToUse = *keyword\styleIndex
      EndIf
      ;Is the separator a '.' character?
      If *ptrBytes\a = '.'
        numBytesToStyle = GOSCI_IsNumberXXX(*this, *ptrBytes, numBytesRemaining, @t1)
        If t1
          styleToUse = *this\lexerNumbersStyleIndex
          Goto GOSCI_StyleNextSymbolXXX_ApplyStyle
        Else
          numBytesToStyle = 1
        EndIf
      EndIf
      If numBytesToStyle < numBytesRemaining
        If *keyword
          If *keyword\flags & #GOSCI_DELIMITBETWEEN
            openDelimeter = *ptrBytes\a
            ;We need to track down the close delimiter. Skipping additional open delimiters as we proceed.
            *ptrBytes + 1
            t1 = 1 ; A temporary count of how many 'open' delimiters we have encountered.
            While numBytesToStyle < numBytesRemaining And t1 > 0
              numBytesToStyle + 1
              If *ptrBytes\a = *keyword\closeDelimiter
                t1 - 1
                If t1 = 0
                  Break
                EndIf
              ElseIf *ptrBytes\a = openDelimeter
                t1 + 1
              ElseIf *ptrBytes\a = #LF Or *ptrBytes\a = 13 ;We style these separately with the default style.
                numBytesToStyle - 1
                Break
              EndIf
              *ptrBytes+1
            Wend
          ElseIf *keyword\flags & #GOSCI_DELIMITTOENDOFLINE
            numBytesToStyle = numBytesRemaining
            ;Need to avoid applying the style to the EOL characters which instead must receive the default style.
            ;This is to avoid Scintilla then instructing us to style the whole document needlessly!
            *ptrBytes + numBytesRemaining - 1
            While *ptrBytes\a = #LF Or *ptrBytes\a = #CR
              numBytesToStyle - 1
              *ptrBytes - 1
            Wend          
          ElseIf *keyword\flags & (#GOSCI_LEFTDELIMITWITHWHITESPACE | #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
            *ptrBytes + 1
            If (*ptrBytes\a <> 9 And *ptrBytes\a <> 32) Or *keyword\flags & #GOSCI_LEFTDELIMITWITHWHITESPACE
              If blnDoNotApplyStyle = #False
                *this\previouslyRecordedStyle = styleToUse
              EndIf
            EndIf
          EndIf
        EndIf    
      EndIf
    Else ;A keyword or unknown symbol.
      ;First check for a number.
      t2 = GOSCI_IsNumberXXX(*this, *ptrBytes, numBytesRemaining, @t1)
      If t2
        If blnDoNotApplyStyle = #False
          *this\previouslyRecordedStyle = #STYLE_DEFAULT
        EndIf
        numBytesToStyle = t2
        styleToUse = *this\lexerNumbersStyleIndex
      Else
        ;Retrieve all bytes up to the next whitespace / separator.
        numBytesToStyle = 1
        *ptrBytes + 1
        While numBytesToStyle < numBytesRemaining
          If GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keywordNext) Or *ptrBytes\a = 32 Or *ptrBytes\a = 9
            Break
          EndIf
          numBytesToStyle + 1
          *ptrBytes + 1
        Wend
        text$ = PeekS(*bytePtr, numBytesToStyle, #PB_UTF8)
        ;Is this a registered keyword?
        *keyword = GOSCI_GetKeywordInfo(*this\id, text$)
        If *this\previouslyRecordedStyle <> #STYLE_DEFAULT ;A left delimiter was previously encountered.
          If blnDoNotApplyStyle = #False
            *this\previouslyRecordedStyle = #STYLE_DEFAULT
          EndIf
        ElseIf *keyword
          If blnDoNotApplyStyle = #False
            *this\previouslyRecordedStyle = #STYLE_DEFAULT
          EndIf
          styleToUse = *keyword\styleIndex
        Else
          ;Perhaps the first character is a non-separating left delimiter?
          *keyword = GOSCI_GetKeywordInfo(*this\id, Chr(*bytePtr\a))
          If *keyword
            If *keyword\flags & (#GOSCI_LEFTDELIMITWITHWHITESPACE | #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
              If blnDoNotApplyStyle = #False
                *this\previouslyRecordedStyle = #STYLE_DEFAULT
              EndIf
              styleToUse = *keyword\styleIndex
            EndIf
            *keyword = 0 ;Do not allow code-folding for a non-separating delimiter.
          Else
            ;Perhaps the last character is a non-separating right delimiter?
            *ptrBytes2 = *ptrBytes-1
            *keyword = GOSCI_GetKeywordInfo(*this\id, Chr(*ptrBytes2\a))
            If *keyword
              If *keyword\flags & (#GOSCI_RIGHTDELIMITWITHWHITESPACE | #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE)
                If blnDoNotApplyStyle = #False
                  *this\previouslyRecordedStyle = #STYLE_DEFAULT
                EndIf
                styleToUse = *keyword\styleIndex
              EndIf
              *keyword = 0 ;Do not allow code-folding for a non-separating delimiter.
            Else
              ;We check if the next non-space character (if any) following this symbol is a right delimiter. Need to also record if space characters were located.
              If *keywordNext = 0
                numSpaces = 1
                *ptrBytes + 1
                While numBytesToStyle + numSpaces < numBytesRemaining
                  If *ptrBytes\a <> 9 And *ptrBytes\a <> 32
                    GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keywordNext)
                    Break
                  EndIf
                  numSpaces + 1
                  *ptrBytes + 1
                Wend
              EndIf
              If *keyWordNext
                If *keyWordNext\flags & (#GOSCI_RIGHTDELIMITWITHWHITESPACE | #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE)
                  If *keyWordNext\flags & #GOSCI_RIGHTDELIMITWITHWHITESPACE Or numSpaces = 0
                    numBytesToStyle + numSpaces
                    styleToUse = *keyWordNext\styleIndex 
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
    GOSCI_StyleNextSymbolXXX_ApplyStyle:
    If blnDoNotApplyStyle = #False
      ;Apply the appropriate style.
      If *this\state & #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING = 0
        styleToUse = #STYLE_DEFAULT
      EndIf
      ScintillaSendMessage(*this\id, #SCI_SETSTYLING, numBytesToStyle, styleToUse)
      ;Was the symbol a folding symbol?
      If *keyword
        If *keyword\flags & #GOSCI_KEYWORDFOLDINGMASK = #GOSCI_OPENFOLDKEYWORD
          *this\blnLineCodeFoldOption + 1
        EndIf
        If *keyword\flags & #GOSCI_CLOSEFOLDKEYWORD And (*this\foldLevel > #SC_FOLDLEVELBASE Or *this\blnLineCodeFoldOption)
          *this\blnLineCodeFoldOption - 1
        EndIf
      EndIf
    EndIf
    ProcedureReturn numBytesToStyle
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is the default line-styling function. numUtf8Bytes is guaranteed to be > 0 and does not include the terminating null in the count.
  Procedure GOSCI_StyleLineXXX(id, *utf8Buffer.ASCII, numUtf8Bytes)
    Protected *this._GoScintilla, numBytesStyled
    Protected ascii.a
    *this = GetGadgetData(id)
    While numUtf8Bytes > 0
      numBytesStyled = GOSCI_StyleNextSymbolXXX(*this, *utf8Buffer, numUtf8Bytes)
      numUtf8Bytes - numBytesStyled
      *utf8Buffer + numBytesStyled
    Wend
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following internal function is called in order to a force a restyling of a range of lines.
  ;The #SCI_COLOURISE message doesn't appear to work! Set 'endLine' to -1 to restyle up to the end of the document.
  ;No return.
  Procedure GOSCI_RestyleLinesXXX(id, startLine, endLine, finalByteToStyle = -1)
    Protected i, lineLength, utf8Buffer, startPos, *this._GoScintilla, blnApplyCodeFolding, t1
    Protected resultFromUserLineStylingFunction, numLines, originalEndLine, numBytesToStyle
    *this = GetGadgetData(id)
    numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
    If endLine = -1 Or endLine >= numLines
      endLine = numLines - 1
    EndIf
    originalEndLine = endLine
    If startLine < 0 
      startLine = 0
    EndIf
    If *this\flags & #GOSCI_ALLOWCODEFOLDING
      blnApplyCodeFolding = #True
      If startLine = 0
        *this\foldLevel = #SC_FOLDLEVELBASE    
      Else
        ;We begin the styling at the previous line as it's fold level will be exact and not subject to change.
        ;It may, however, dictate the fold level of subsequent lines (e.g. in the case of a close-fold keyword).
        startLine - 1
        *this\foldLevel = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, startLine)&#SC_FOLDLEVELNUMBERMASK
      EndIf
    EndIf
    startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, startLine)
    numBytesToStyle = finalByteToStyle - startPos
    ;Debug "Startline = " + Str(startLine) + ", Endline = " + Str(endline) + ", Startpos = " + Str(startPos) + ", Endpos = " + Str(finalByteToStyle)
    ScintillaSendMessage(id, #SCI_STARTSTYLING, startpos, $1f)
    For i = startLine To endLine
      *this\bytePointer = 0
      *this\previouslyRecordedStyle = #STYLE_DEFAULT
      *this\blnLineCodeFoldOption = 0 ;No code folding.
      lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, i)
      ;The final line being styled may need truncating else we will inevitably be styling more bytes than required. This can impact upon code folding.
      If resultFromUserLineStylingFunction = #GOSCI_STYLELINESASREQUIRED And finalByteToStyle <> -1 And lineLength > numBytesToStyle
        lineLength = numBytesToStyle
      EndIf
      numBytesToStyle - lineLength
      If lineLength > 0
        utf8Buffer = AllocateMemory(lineLength + 1)
        If utf8Buffer
          If ScintillaSendMessage(id, #SCI_GETLINE, i, utf8Buffer)
            ;Call the user-defined line styling function, if present.
            If *this\stylingFunction
              resultFromUserLineStylingFunction = *this\stylingFunction(id, utf8Buffer, lineLength, i, startLine, originalEndLine)
              If resultFromUserLineStylingFunction = #GOSCI_STYLENEXTLINEREGARDLESS
                endLine = numLines - 1
              Else
                endLine = originalEndLine
              EndIf
            Else
              GOSCI_StyleLineXXX(id, utf8Buffer, lineLength)
            EndIf
          EndIf
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
      ;Sort out the fold level.
      If blnApplyCodeFolding
        t1 = 0
        If *this\blnLineCodeFoldOption >= 1 ;Open fold.
          t1 = #SC_FOLDLEVELHEADERFLAG
        EndIf
        ScintillaSendMessage(id, #SCI_SETFOLDLEVEL, i, t1|*this\foldLevel)
        *this\foldLevel + *this\blnLineCodeFoldOption
        If *this\foldLevel < #SC_FOLDLEVELBASE
          *this\foldLevel = #SC_FOLDLEVELBASE
        EndIf
      EndIf
    Next
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-INTERNAL FUNCTIONS - Scintilla callback.
  ;-===================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is the internal Scintilla callback. From here, if appropriate, we call the user's callback.
  
  ProcedureDLL GOSCI_ScintillaCallBackXXX(id, *scinotify.SCNotification)
    Protected *this._GoScintilla, startLine, endLine, lineLength, utf8Buffer, i, level, newLevel, startPos
    *this = GetGadgetData(id)
    Select *scinotify\nmhdr\code
      Case #SCN_NEEDSHOWN
        ;Here we arrange for lines which may be collapsed to be expanded in the case that the folded section has been altered by the user.
        startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
        endLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position + *scinotify\length)
        For i = startLine To endLine
          ScintillaSendMessage(id, #SCI_ENSUREVISIBLE, i)
        Next
        If ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine)&#SC_FOLDLEVELHEADERFLAG
          level = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine) & #SC_FOLDLEVELNUMBERMASK
          newLevel = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine+1) & #SC_FOLDLEVELNUMBERMASK
          If newLevel > level
            ScintillaSendMessage(id, #SCI_ENSUREVISIBLE, endLine+1)
          EndIf  
        EndIf
      Case #SCN_MARGINCLICK
        Select *scinotify\margin
          Case #GOSCI_MARGINFOLDINGSYMBOLS
            startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
            ;Check it is a header line.
            If ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, startLine) & #SC_FOLDLEVELHEADERFLAG
              ScintillaSendMessage(id, #SCI_TOGGLEFOLD, startLine)
            EndIf
        EndSelect
      Case #SCN_MODIFIED
        If *scinotify\linesAdded
          GOSCI_AutosizeLineNumberMarginXXX(id)
        EndIf
      Case #SCN_STYLENEEDED
        startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, ScintillaSendMessage(id, #SCI_GETENDSTYLED))  
        startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, startLine)
        endLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
        endLine = ScintillaSendMessage(id, #SCI_VISIBLEFROMDOCLINE, endLine)
        ;For some reason, endLine can sometimes be less than startLine (especially after code folding).
        If endLine < startLine
          t1 = startLine
          startLine = endLine
          endLine = t1+1
        EndIf
        GOSCI_RestyleLinesXXX(id, startLine, endLine, *scinotify\position)
    EndSelect
    
    ;Call the user's Scintilla callback.
    If *this And *this\callback
      *this\callback(id, *scinotify)
    EndIf
    
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-PUBLIC FUNCTIONS - General functions.
  ;-=================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function clears all text (unless the control is read-only).
  ;No return.
  Procedure GOSCI_Clear(id)
    
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ScintillaSendMessage(id, #SCI_CLEARALL)
    EndIf
    
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function creates a Scintilla gadget within the current gadget list and initialises it as appropriate.
  ;Returns either a gadget# or hWnd as per usual.
  
  Procedure.i GOSCI_Create(id, x, y, Width, Height, callbackAddress=0, flags=0)
    Protected result, *this._GoScintilla
    ;Allocate memory for a _GoScintilla structure.
    *this = AllocateMemory(SizeOf(_GoScintilla))
    If *this
      ;Create the gadget, but redirect the callback to our own one.
      result = ScintillaGadget(id, x, y, Width, Height, @GOSCI_ScintillaCallBackXXX())
      If result
        If id = #PB_Any
          id = result
        EndIf
        With *this
          \id = id
          \callback = callbackAddress
          \flags = flags
          \state = #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING
          \lexerSeparators$ = ""
          \lexerNumbersStyleIndex = #STYLE_DEFAULT
        EndWith
        ;Set utf-8 codepage.
        ScintillaSendMessage(id, #SCI_SETCODEPAGE, #SC_CP_UTF8, 0)
        ;Set lexer.
        ScintillaSendMessage(id, #SCI_SETLEXER, #SCLEX_CONTAINER)
        ;Zero all margins.
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, #GOSCI_MARGINNONFOLDINGSYMBOLS, 0)
        ;Set some defaults for the folding  margin for future use.
        ScintillaSendMessage(id, #SCI_SETMARGINSENSITIVEN, #GOSCI_MARGINFOLDINGSYMBOLS, #True)  ;Ensure that #SCN_MARGINCLICK notifications are sent for this margin.
        ScintillaSendMessage(id, #SCI_SETMARGINMASKN, #GOSCI_MARGINFOLDINGSYMBOLS, #SC_MASK_FOLDERS)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_BOXMINUS)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, RGB(255,255,255))
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_BOXPLUS)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, RGB(255,255,255))
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNER)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_BOXPLUSCONNECTED)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, 0)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, RGB(255,255,255))
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_BOXMINUSCONNECTED)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, 0)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, RGB(255,255,255))
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNER)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, 0)
        ;Clear all styles.
        ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        ;Record a pointer to our _GoScintilla structure.
        SetGadgetData(id, *this)
        ;Auto size the margin if appropriate.
        GOSCI_AutosizeLineNumberMarginXXX(id)
      Else
        FreeMemory(*this)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function removes the specified line of text.
  ;No return value.
  Procedure GOSCI_DeleteLine(id, lineIndex)
    Protected numLines, lineLength, startPos, endPos, char.a
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If ScintillaSendMessage(id, #SCI_GETLENGTH)
        numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
        If lineIndex >=0 And lineIndex < numLines
          lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
          startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
          endPos = startPos + lineLength
          If lineIndex = numLines - 1
            ;We may have to delete the EOL characters in the previous line.
            If lineIndex
              startPos-1
              char = ScintillaSendMessage(id, #SCI_GETCHARAT, startPos)
              While char = 10 Or char = 13
                startPos-1
                char = ScintillaSendMessage(id, #SCI_GETCHARAT, startPos)
              Wend
              startPos+1
            EndIf
          EndIf
          ;We now replace the text with an empty string.
          ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
          ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
          ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, @"")
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function creates a Scintilla gadget within the current gadget list and initialises it as appropriate.
  ;Returns either a gadget# or hWnd as per usual.
  Procedure GOSCI_Free(id)
    Protected *this._GoScintilla
    ;Remove all appropriate elements from the global keyword map.
    ForEach gGOSCI_Keywords()
      If gGOSCI_Keywords()\id = id
        DeleteMapElement(gGOSCI_Keywords())
      EndIf
    Next
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        ;Free structured strings.
        GOSCI_FreeStructureStringXXX(@*this\lexerSeparators$)
        FreeMemory(*this)
      EndIf
      FreeGadget(id)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves control attributes. See header file for more details of which attributes can be retrieved.
  Procedure.i GOSCI_GetAttribute(id, attribute)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select attribute
        Case #GOSCI_READONLY
          result = ScintillaSendMessage(id, #SCI_GETREADONLY)
        Case #GOSCI_LINENUMBERAUTOSIZEPADDING
          *this = GetGadgetData(id)
          If *this
            result = *this\lineNumberAutoSizePadding
          EndIf
        Case #GOSCI_CANUNDO
          result = ScintillaSendMessage(id, #SCI_GETUNDOCOLLECTION)
        Case #GOSCI_WRAPLINES
          result = ScintillaSendMessage(id, #SCI_GETWRAPMODE) 
        Case #GOSCI_WRAPLINESVISUALMARKER
          result = ScintillaSendMessage(id, #SCI_GETWRAPVISUALFLAGS)
      EndSelect
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the specified color for the entire control (not individual styles).
  ;See header file for more details of which color constants can be used here (not all colors can be retrieved).
  Procedure.i GOSCI_GetColor(id, colorType)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select colorType
        Case #GOSCI_BACKCOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETBACK, #STYLE_DEFAULT) 
        Case #GOSCI_FORECOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETFORE, #STYLE_DEFAULT) 
        Case #GOSCI_LINENUMBERBACKCOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETBACK, #STYLE_LINENUMBER)  
        Case #GOSCI_LINENUMBERFORECOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETFORE, #STYLE_LINENUMBER)  
        Case #GOSCI_CARETLINEBACKCOLOR
          result = ScintillaSendMessage(id, #SCI_GETCARETLINEBACK)
        Case #GOSCI_CARETFORECOLOR
          result = ScintillaSendMessage(id, #SCI_GETCARETFORE)
      EndSelect
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves a line's user data value.
  Procedure.i GOSCI_GetLineData(id, lineIndex)
    Protected result, numLines
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        result = ScintillaSendMessage(id, #SCI_GETLINESTATE, lineIndex)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the text (minus any EOL characters) for a given line.
  Procedure.s GOSCI_GetLineText(id, lineIndex)
    Protected text$, numLines, lineLength, utf8Buffer, *ptrAscii.ASCII
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
        If lineLength
          utf8Buffer = AllocateMemory(lineLength+1)
          If utf8Buffer
            ScintillaSendMessage(id, #SCI_GETLINE, lineIndex, utf8Buffer)
            ;Remove any terminating EOL characters.
            *ptrAscii = utf8Buffer + lineLength - 1
            While (*ptrAscii\a = 10 Or *ptrAscii\a = 13) And lineLength
              lineLength - 1
              *ptrAscii - 1
            Wend
            text$ = PeekS(utf8Buffer, lineLength, #PB_UTF8)
            FreeMemory(utf8Buffer)
          EndIf
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function gets the width of the specified margin.
  Procedure.i GOSCI_GetMarginWidth(id, margin)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETMARGINWIDTHN, margin)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the number of lines of text.
  Procedure.i GOSCI_GetNumberOfLines(id)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the selected text.
  Procedure.s GOSCI_GetSelectedText(id)
    Protected text$, numBytes, utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numBytes = ScintillaSendMessage(id, #SCI_GETSELTEXT)
      If numBytes
        utf8Buffer = AllocateMemory(numBytes)
        If utf8Buffer
          ScintillaSendMessage(id, #SCI_GETSELTEXT, 0, utf8Buffer)
          text$ = PeekS(utf8Buffer, -1, #PB_UTF8)
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the tab width.
  Procedure.i GOSCI_GetTabWidth(id)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETTABWIDTH)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the text for the entire control.
  Procedure.s GOSCI_GetText(id)
    Protected text$, utf8Buffer, numBytes
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numBytes = ScintillaSendMessage(id, #SCI_GETLENGTH)
      If numBytes
        utf8Buffer = AllocateMemory(numBytes+1)
        If utf8Buffer 
          ScintillaSendMessage(id, #SCI_GETTEXT, numBytes + 1, utf8Buffer)
          text$ = PeekS(utf8Buffer, -1, #PB_UTF8)
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the control's user data.
  Procedure.i GOSCI_GetUserData(id)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\userData
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function moves the caret (and clears the selection) to the beginning of the specified line and scrolls the view if required.
  ;If lineIndex is out of range then either the first or last row is used.
  ;No return.
  Procedure GOSCI_GotoLine(id, lineIndex)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ScintillaSendMessage(id, #SCI_GOTOLINE, lineIndex)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function inserts a line of text at the specified lineIndex position (o to numLines). Set lineIndex = -1 to append the line.
  Procedure GOSCI_InsertLineOfText(id, lineIndex, text$)
    Protected numLines, pos, utf8Buffer, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ;Remove all EOL characters.
      text$ = RemoveString(text$, #LF$)
      text$ = RemoveString(text$, #CR$)
      ;Decide the insertion row.
      If ScintillaSendMessage(id, #SCI_GETLENGTH) = 0
        *this = GetGadgetData(id)
        If *this
          If *this\blnEmptyLineAdded
            text$ = #LF$
            *this\blnEmptyLineAdded = #False
          Else
            *this\blnEmptyLineAdded = #True
          EndIf
        EndIf
        lineIndex = 0
      Else
        numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
        If lineIndex < 0 Or lineIndex >= numLines
          lineIndex = numLines
          text$ = #LF$ + text$
        Else
          text$ + #LF$
        EndIf
      EndIf
      ;Determine the insertion pos.
      pos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
      ;Insert text
      ;Need to convert to utf-8 first.
      utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_INSERTTEXT, pos, utf8Buffer)
        FreeMemory(utf8Buffer)
        GOSCI_RestyleLinesXXX(id, lineIndex, lineIndex)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns #True if the Scintilla control is empty.
  Procedure.i GOSCI_IsEmpty(id)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If ScintillaSendMessage(id, #SCI_GETLENGTH) = 0
        result = #True
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function replaces the current selection with the given text.
  ;No return value.
  Procedure GOSCI_ReplaceSelectedText(id, text$, blnScrollCaretIntoView=#False)
    Protected startPost, endPos, utf8Buffer, byteLength
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      startPos = ScintillaSendMessage(id, #SCI_GETSELECTIONSTART)
      endPos = ScintillaSendMessage(id, #SCI_GETSELECTIONEND)
      ;Need to convert text to utf-8 first.
      byteLength = StringByteLength(text$, #PB_UTF8)
      utf8Buffer = AllocateMemory(byteLength+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
        ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
        ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, utf8Buffer)
        startPos + byteLength
        ScintillaSendMessage(id, #SCI_SETCURRENTPOS, startpos)
        ScintillaSendMessage(id, #SCI_SETANCHOR, startpos)
        If blnScrollCaretIntoView
          ScintillaSendMessage(id, #SCI_GOTOPOS, startPos)
        EndIf
        FreeMemory(utf8Buffer)
        GOSCI_RestyleLinesXXX(id, 0, -1)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets control attributes. See header file for more details.
  ;No return.
  Procedure GOSCI_SetAttribute(id, attribute, value)
    Protected *this._GoScintilla, scinotify.SCNotification
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select attribute
        Case #GOSCI_READONLY
          ScintillaSendMessage(id, #SCI_SETREADONLY, value)
        Case #GOSCI_LINENUMBERAUTOSIZEPADDING
          If value >= 0
            *this = GetGadgetData(id)
            If *this And *this\lineNumberAutoSizePadding <> value
              *this\lineNumberAutoSizePadding = value
              ;Auto size the margin if appropriate.
              GOSCI_AutosizeLineNumberMarginXXX(id)
            EndIf
          EndIf
        Case #GOSCI_CANUNDO
          If value = #False
            ScintillaSendMessage(id, #SCI_EMPTYUNDOBUFFER)
          EndIf
          ScintillaSendMessage(id, #SCI_SETUNDOCOLLECTION, value)
        Case #GOSCI_WRAPLINES
          ScintillaSendMessage(id, #SCI_SETWRAPMODE, value) 
        Case #GOSCI_WRAPLINESVISUALMARKER
          ScintillaSendMessage(id, #SCI_SETWRAPVISUALFLAGS, value)
      EndSelect
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets colors for the entire control (not individual styles).
  ;See header file for more details.
  ;No return.
  Procedure GOSCI_SetColor(id, colorType, color)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select colorType
        Case #GOSCI_BACKCOLOR
          ScintillaSendMessage(id, #SCI_STYLESETBACK, #STYLE_DEFAULT, color)  
          ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        Case #GOSCI_FORECOLOR
          ScintillaSendMessage(id, #SCI_STYLESETFORE, #STYLE_DEFAULT, color)  
          ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        Case #GOSCI_SELECTIONBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETSELBACK, #True, color)  
        Case #GOSCI_SELECTIONFORECOLOR
          ScintillaSendMessage(id, #SCI_SETSELFORE, #True, color)  
        Case #GOSCI_LINENUMBERBACKCOLOR
          ScintillaSendMessage(id, #SCI_STYLESETBACK, #STYLE_LINENUMBER, color)  
        Case #GOSCI_LINENUMBERFORECOLOR
          ScintillaSendMessage(id, #SCI_STYLESETFORE, #STYLE_LINENUMBER, color)  
        Case #GOSCI_CARETLINEBACKCOLOR
          If color = -1
            ScintillaSendMessage(id, #SCI_SETCARETLINEVISIBLE, #False)
          Else
            ScintillaSendMessage(id, #SCI_SETCARETLINEBACK, color)
            ScintillaSendMessage(id, #SCI_SETCARETLINEVISIBLE, #True)
          EndIf
        Case #GOSCI_CARETFORECOLOR
          ScintillaSendMessage(id, #SCI_SETCARETFORE, color)
        Case #GOSCI_FOLDMARGINLOBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETFOLDMARGINCOLOUR, 1, color)
        Case #GOSCI_FOLDMARGINHIBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETFOLDMARGINHICOLOUR, 1, color)
        Case #GOSCI_FOLDMARKERSBACKCOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, color)
        Case #GOSCI_FOLDMARKERSFORECOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, color)
      EndSelect
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the main font. Can set bold and italic.
  ;Set fontName$ to "" to skip changing font face. Set fontSize to -1 to skip altering the size. Ditto for fontStyle.
  ;No return value.
  Procedure GOSCI_SetFont(id, fontName$, fontSize=-1, fontStyle=-1)
    GOSCI_SetStyleFont(id, #STYLE_DEFAULT, fontName$, fontSize, fontStyle)
    ScintillaSendMessage(id, #SCI_STYLECLEARALL)
    ;Auto size the margin if appropriate.
    GOSCI_AutosizeLineNumberMarginXXX(id)
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets a line's user data value.
  ;Returns the original value.
  Procedure.i GOSCI_SetLineData(id, lineIndex, value)
    Protected result, numLines
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        result = ScintillaSendMessage(id, #SCI_GETLINESTATE, lineIndex)
        ScintillaSendMessage(id, #SCI_SETLINESTATE, lineIndex, value)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function changes the text for a given line.
  ;No return value.
  Procedure GOSCI_SetLineText(id, lineIndex, text$)
    Protected numLines, lineLength, startPos, endPos, char.a, utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        ;Remove all EOL characters.
        text$ = RemoveString(text$, #LF$)
        text$ = RemoveString(text$, #CR$)
        ;Find the beginning and the end of the text to replace.
        lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
        startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
        endPos = startPos + lineLength
        ;We ignore any EOL characters.
        endPos - 1
        char = ScintillaSendMessage(id, #SCI_GETCHARAT, endPos)
        While (char = 10 Or char = 13) And endPos >= startPos
          endPos-1
          char = ScintillaSendMessage(id, #SCI_GETCHARAT, endPos)
        Wend
        endPos + 1
        ;Need to convert text to utf-8 first.
        utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
        If utf8Buffer 
          PokeS(utf8Buffer, text$, -1, #PB_UTF8)
          ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
          ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
          ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, utf8Buffer)
          FreeMemory(utf8Buffer)
          GOSCI_RestyleLinesXXX(id, lineIndex, lineIndex)  
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the width of the specified margin.
  ;In the case of the line number margin, this function will fail if the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag was set.
  ;No return value.
  Procedure GOSCI_SetMarginWidth(id, margin, width)
    Protected *this._GoScintilla, blnDoNotProceed
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If width < 0
        width = 0
      EndIf
      If margin = #GOSCI_MARGINLINENUMBERS
        *this = GetGadgetData(id)
        If *this
          If *this\flags & #GOSCI_AUTOSIZELINENUMBERSMARGIN
            blnDoNotProceed = #True
          EndIf
        EndIf
      EndIf
      If blnDoNotProceed = #False
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, margin, width)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the tab width and whether hard or soft tabs are used. A soft tab inserts spaces.
  ;For this to work, you must remove the default keyboard shortcut for the tab key from the main PB window.
  ;No return value.
  Procedure GOSCI_SetTabs(id, width, blnUseSoftTabs = #False)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ScintillaSendMessage(id, #SCI_SETTABWIDTH, width)
      ScintillaSendMessage(id, #SCI_SETUSETABS, 1-blnUseSoftTabs)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the text for the entire control.
  ;Set the optional clearUndoStack parameter to non-zero to have the undo stack cleared so that this operation cannot be undone.
  ;No return value.
  Procedure GOSCI_SetText(id, text$, clearUndoStack=#False)
    Protected utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ;Need to convert to utf-8 first.
      utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_SETTEXT, 0, utf8Buffer)
        FreeMemory(utf8Buffer)
        If clearUndoStack
          ScintillaSendMessage(id, #SCI_EMPTYUNDOBUFFER)
        EndIf
        GOSCI_RestyleLinesXXX(id, 0, -1)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the control's user data.
  ;Returns the original value.
  Procedure.i GOSCI_SetUserData(id, value)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\userData
        *this\userData = value
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-PUBLIC FUNCTIONS - Functions to assist with the syntax highlighting lexer.
  ;-============================================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function records a list of keywords to use the style specified. The list of words are to be separated by space characters.
  ;Note that only Ascii characters must be used within each keyword.
  ;Duplicates are simply replaced.
  ;Set flags to one (or more) of the constants #GOSCI_DELIMITNONE or #GOSCI_DELIMITBETWEEN or ... etc.
  Procedure GOSCI_AddKeywords(id, keyWords$, styleIndex, flags=#GOSCI_DELIMITNONE)
    Protected *this._GoScintilla, wordCount, i, t1$, t2$, blnProceed
    keyWords$ = Trim(keyWords$)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And keyWords$
      *this = GetGadgetData(id)  
      If *this And *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
        keyWords$ = LCase(keyWords$)
      EndIf
      wordCount = CountString(keyWords$, " ") + 1
      For i = 1 To wordCount
        blnProceed = #True
        t1$ = StringField(keyWords$, i, " ")
        t2$ = ""
        Select flags&#GOSCI_KEYWORDDELIMITERMASK
          Case 0, #GOSCI_DELIMITNONE
            flags | #GOSCI_DELIMITNONE
          Case #GOSCI_DELIMITBETWEEN
            If Len(t1$) = 2
              t2$ = Right(t1$, 1)
              t1$ = Left(t1$, 1)
            Else
              blnProceed = #False
            EndIf
          Default
            If Len(t1$) <> 1
              blnProceed = #False
            EndIf
        EndSelect
        If blnProceed
          If AddMapElement(gGOSCI_Keywords(), t1$+#LF$+Str(id))
            gGOSCI_Keywords()\id = id
            gGOSCI_Keywords()\styleIndex = styleIndex
            gGOSCI_Keywords()\flags = flags
            gGOSCI_Keywords()\closeDelimiter = Asc(t2$)
          EndIf
        EndIf
      Next
      GOSCI_RestyleLinesXXX(id, 0, -1)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to decrement the current line's fold level
  ;(as in the line currently being styled). DO NOT call this function from outside of a user-defined line styling function!
  ;No return value.
  Procedure GOSCI_DecFoldLevel(id)
    Protected *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this\flags & #GOSCI_ALLOWCODEFOLDING
        If *this\foldLevel > #SC_FOLDLEVELBASE Or *this\blnLineCodeFoldOption
          *this\blnLineCodeFoldOption - 1
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves info for the specified keyword in the form of a pointer to it's associated GoScintillaKeywords structure.
  ;Returns 0 if the keyword is not found.
  Procedure.i GOSCI_GetKeywordInfo(id, keyWord$)
    Protected result, *this._GoScintilla
    keyWord$ = Trim(keyWord$)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And keyWord$
      *this = GetGadgetData(id)  
      If *this And *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
        keyWord$ = LCase(keyWord$)
      EndIf
      result = FindMapElement(gGOSCI_Keywords(), keyWord$ + #LF$ + Str(id))
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves a Lexer option. See the GoScintilla_HeaderFile.pbi file for a list of possible options.
  Procedure.i GOSCI_GetLexerOption(id, option)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this 
        Select option
          Case #GOSCI_LEXEROPTION_SEPARATORSYMBOLS
            result = @*this\lexerSeparators$
          Case #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX
            result = *this\lexerNumbersStyleIndex
        EndSelect
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the lexer state.
  Procedure.i GOSCI_GetLexerState(id)
    Protected *this._GoScintilla, result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\state
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to determine the number of bytes in the next 'symbol',
  ;that which would be retrieved by GoScintilla's lexer whilst styling the current line.
  ;DO NOT call this function from outside of a user-defined line styling function!
  Procedure.i GOSCI_GetNextSymbolByteLength(id, *bytePtr.ASCII, numBytesRemaining)
    Protected *this._GoScintilla, result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And numBytesRemaining
      *this = GetGadgetData(id)  
      result = GOSCI_StyleNextSymbolXXX(*this, *bytePtr, numBytesRemaining, #True)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to increment the current line's fold level
  ;(as in the line currently being styled). DO NOT call this function from outside of a user-defined line styling function!
  ;No return value.
  Procedure GOSCI_IncFoldLevel(id)
    Protected *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this\flags & #GOSCI_ALLOWCODEFOLDING
        *this\blnLineCodeFoldOption + 1
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets an option for the lexer. See the GoScintilla_HeaderFile.pbi file for a list of possible options.
  Procedure GOSCI_SetLexerOption(id, option, value)
    Protected *this._GoScintilla, text$
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this 
        Select option
          Case #GOSCI_LEXEROPTION_SEPARATORSYMBOLS
            If value
              text$ = PeekS(value)
            EndIf
            If *this\lexerSeparators$ <> text$
              *this\lexerSeparators$ = text$
              GOSCI_RestyleLinesXXX(id, 0, -1)
            EndIf
          Case #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX
            If *this\lexerNumbersStyleIndex <> value
              *this\lexerNumbersStyleIndex = value
              GOSCI_RestyleLinesXXX(id, 0, -1)
            EndIf
        EndSelect
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets various lexer states; e.g. disables syntax styling.
  ;No return value.
  Procedure GOSCI_SetLexerState(id, state)
    Protected *this._GoScintilla, blnNeedRestyle
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        ;Do we need to restyle the whole document?
        If *this\state & #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING <> state & #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING
          blnNeedRestyle = #True
        EndIf
        *this\state = state
        If blnNeedRestyle
          GOSCI_RestyleLinesXXX(id, 0, -1)
        EndIf 
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the colors for the specified style.
  ;Set the various color values to -1 to skip that color.
  ;No return value.
  Procedure GOSCI_SetStyleColors(id, styleIndex, foreColor=-1, backColor=-1)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If foreColor <> -1
        ScintillaSendMessage(id, #SCI_STYLESETFORE, styleIndex, foreColor)  
      EndIf
      If backColor <> -1
        ScintillaSendMessage(id, #SCI_STYLESETBACK, styleIndex, backColor)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the font for the specified style. Can set bold, italic and underline.
  ;Set fontName$ to "" to skip changing font face. Set fontSize to -1 to skip altering the size. Ditto for fontStyle.
  ;No return value.
  Procedure GOSCI_SetStyleFont(id, styleIndex, fontName$, fontSize=-1, fontStyle=-1)
    Protected asciiBuffer, bold, italic, underline
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If fontName$
        ;Convert the fontName$ to Ascii.
        asciiBuffer = AllocateMemory(Len(fontName$) + 1)
        If asciiBuffer
          PokeS(asciiBuffer, fontName$, -1, #PB_Ascii)
          ScintillaSendMessage(id, #SCI_STYLESETFONT, styleIndex, asciiBuffer)
          FreeMemory(asciiBuffer)    
        EndIf
      EndIf
      If fontSize <> -1
        ScintillaSendMessage(id, #SCI_STYLESETSIZE, styleIndex, fontSize)
      EndIf
      If fontStyle <> -1
        If fontStyle & #PB_Font_Bold
          bold = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETBOLD, styleIndex, bold)
        If fontStyle & #PB_Font_Italic
          italic = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETITALIC, styleIndex, italic)
        If fontStyle & #PB_Font_Underline
          underline = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETUNDERLINE, styleIndex, underline)
      EndIf
      If styleIndex = #STYLE_LINENUMBER
        ;Auto size the margin if appropriate.
        GOSCI_AutosizeLineNumberMarginXXX(id)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the user-defined line styling function.
  ;Such a function, if present, is called before the default GoScintilla's line styling function and is invoked once for each line to be styled
  ;and it's return value directs GoScintilla as to whether it should style any part of the line etc. (See header file).
  ;Set addressOfFunction to 0 to remove this optional function.
  ;Returns the previous function address.
  Procedure.i GOSCI_SetLineStylingFunction(id, addressOfFunction)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this
        result = *this\stylingFunction
        *this\stylingFunction = addressOfFunction
        GOSCI_RestyleLinesXXX(id, 0, -1)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to invoke GoScintilla's default lexer to style
  ;the next symbol in the line. DO NOT call this function from outside of a user-defined line styling function!
  ;Returns the number of bytes actually styled.
  Procedure.i GOSCI_StyleNextSymbol(id, *bytePtr.ASCII, numBytesRemaining)
    Protected *this._GoScintilla, numBytesStyled
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And numBytesRemaining
      *this = GetGadgetData(id)  
      ;Reset the left-delimiter previously recorded style if this function is being called out of order.
      If *this\bytePointer <> *bytePtr
        *this\previouslyRecordedStyle = #STYLE_DEFAULT
      EndIf
      numBytesStyled = GOSCI_StyleNextSymbolXXX(*this, *bytePtr, numBytesRemaining)
      *this\bytePointer = *bytePtr + numBytesStyled
    EndIf
    ProcedureReturn numBytesStyled
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
CompilerEndIf
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; ExecutableFormat = Shared .so
; CursorPosition = 715
; FirstLine = 710
; Folding = ----------
; EnableUnicode
; EnableThread
; Executable = d.exe.dll.exe.dll