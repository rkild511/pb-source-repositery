;**
;* Operating System: Microsoft Windows _
;* Library: RichEdit.h ( From Win95 To WinXP SP1 ) _
;* addapted to PB4: Flype

;// Constants

Enumeration ; EM_
  #EM_SETCUEBANNER     = #ECM_FIRST + 1
  #EM_GETCUEBANNER     = #ECM_FIRST + 2
  #EM_SHOWBALLOONTIP   = #ECM_FIRST + 3
  #EM_HIDEBALLOONTIP   = #ECM_FIRST + 4
  #EM_GETPAGEROTATE    = #WM_USER + 235
  #EM_SETPAGEROTATE    = #WM_USER + 236
  #EM_GETVIEWKIND      = #WM_USER + 226
  #EM_SETVIEWKIND      = #WM_USER + 227
  #EM_GETPAGE          = #WM_USER + 228
  #EM_SETPAGE          = #WM_USER + 229
  #EM_GETHYPHENATEINFO = #WM_USER + 230
  #EM_SETHYPHENATEINFO = #WM_USER + 231
  #EM_GETPAGEROTATE    = #WM_USER + 235
  #EM_SETPAGEROTATE    = #WM_USER + 236
  #EM_GETCTFMODEBIAS   = #WM_USER + 237
  #EM_SETCTFMODEBIAS   = #WM_USER + 238
  #EM_GETCTFOPENSTATUS = #WM_USER + 240
  #EM_SETCTFOPENSTATUS = #WM_USER + 241
  #EM_GETIMECOMPTEXT   = #WM_USER + 242
  #EM_ISIME            = #WM_USER + 243
  #EM_GETIMEPROPERTY   = #WM_USER + 244
EndEnumeration

Enumeration ; EN_
  #EN_MSGFILTER = $0700
  #EN_REQUESTRESIZE
  #EN_SELCHANGE
  #EN_DROPFILES
  #EN_PROTECTED
  #EN_CORRECTTEXT
  #EN_STOPNOUNDO
  #EN_IMECHANGE
  #EN_SAVECLIPBOARD
  #EN_OLEOPFAILED
  #EN_OBJECTPOSITIONS
  #EN_LINK
  #EN_DRAGDROPDONE
  #EN_PARAGRAPHEXPANDED
  #EN_PAGECHANGE
  #EN_LOWFIRTF
  #EN_ALIGNLTR
  #EN_ALIGNRTL
EndEnumeration

Enumeration ; ENM_
  #ENM_NONE            = $0
  #ENM_CHANGE          = $1
  #ENM_UPDATE          = $2
  #ENM_SCROLL          = $4
  #ENM_SCROLLEVENTS    = $8
  #ENM_DRAGDROPDONE    = $10
  #ENM_KEYEVENTS       = $10000
  #ENM_MOUSEEVENTS     = $20000
  #ENM_REQUESTRESIZE   = $40000
  #ENM_SELCHANGE       = $80000
  #ENM_DROPFILES       = $100000
  #ENM_PROTECTED       = $200000
  #ENM_CORRECTTEXT     = $400000
  #ENM_IMECHANGE       = $800000
  #ENM_OBJECTPOSITIONS = $2000000
  #ENM_LINK            = $4000000
EndEnumeration

Enumeration ; KHYPH_
  #khyphNil
  #khyphNormal
  #khyphAddBefore
  #khyphChangeBefore
  #khyphDeleteBefore
  #khyphChangeAfter
  #khyphDelAndChange
EndEnumeration

Enumeration ; TM_
  #TM_PLAINTEXT = 1
  #TM_RICHTEXT = 2
  #TM_SINGLELEVELUNDO = 4
  #TM_MULTILEVELUNDO = 8
  #TM_SINGLECODEPAGE = 16
  #TM_MULTICODEPAGE = 32
EndEnumeration

Enumeration ; UID_
  #UID_UNKNOWN
  #UID_TYPING
  #UID_DELETE
  #UID_DRAGDROP
  #UID_CUT
  #UID_PASTE
EndEnumeration

Enumeration ; TTI_
 #TTI_NONE
 #TTI_INFO
 #TTI_WARNING
 #TTI_ERROR
EndEnumeration

;// Macros

Macro EM_AutourLDetect(hWndControl, bool)
  SendMessage_(hWndControl, #EM_AUTOURLDETECT, bool, #Null)
EndMacro

Macro EM_CanPaste(hWndControl, ClipboardFormat)
  SendMessage_(hWndControl, #EM_CANPASTE, ClipboardFormat, #Null)
EndMacro

Macro EM_CanRedo(hWndControl)
  SendMessage_(hWndControl, #EM_CANREDO, #Null, #Null)
EndMacro

Macro EM_CanUndo(hWndControl)
  SendMessage_(hWndControl, #EM_CANUNDO, #Null, #Null)
EndMacro

Macro EM_CharFromPos(hWndControl, lpPointL)
  SendMessage_(hWndControl, #EM_CHARFROMPOS, #Null, lpPointL)
EndMacro

Macro EM_DisplayBand(hWndControl, lpRect)
  SendMessage_(hWndControl, #EM_DISPLAYBAND, #Null, lpRect)
EndMacro

Macro EM_EmptyUndoBuffer(hWndControl)
  SendMessage_(hWndControl, #EM_EMPTYUNDOBUFFER, #Null, #Null)
EndMacro

Macro EM_FindText(hWndControl, param, lpFindText)
  SendMessage_(hWndControl, #EM_FINDTEXT, param, lpFindText)
EndMacro

Macro EM_FindTextW(hWndControl, param, lpFindText)
  SendMessage_(hWndControl, #EM_FINDTEXTEXW, param, lpFindText)
EndMacro

Macro EM_FindTextEx(hWndControl, param, lpFindTextEx)
  SendMessage_(hWndControl, #EM_FINDTEXTEX, param, lpFindTextEx)
EndMacro

Macro EM_FindTextExW(hWndControl, param, lpFindTextEx)
  SendMessage_(hWndControl, #EM_FINDTEXTW, param, lpFindTextEx)
EndMacro

Macro EM_FindWordBreak(hWndControl, type, CharPos)
  SendMessage_(hWndControl, #EM_FINDWORDBREAK, type, CharPos)
EndMacro

Macro EM_FmtLines(hWndControl, bool)
  SendMessage_(hWndControl, #EM_FMTLINES, bool, #Null)
EndMacro

Macro EM_FormatRange(hWndControl, render, lpFormatRange)
  SendMessage_(hWndControl, #EM_FORMATRANGE, render, lpFormatRange)
EndMacro

Macro EM_HideBalloonTip(hWndControl)
  SendMessage_(hWndControl, #EM_HIDEBALLOONTIP, #Null, #Null)
EndMacro

Macro EM_HideSelection(hWndControl, bool)
  SendMessage_(hWndControl, #EM_HIDESELECTION, bool, #Null)
EndMacro

Macro EM_IsIME(hWndControl)
  SendMessage_(hWndControl, #EM_ISIME, #Null, #Null)
EndMacro

Macro EM_LimitText(hWndControl, maximum)
  SendMessage_(hWndControl, #EM_LIMITTEXT, maximum, #Null)
EndMacro

Macro EM_LimitTextEx(hWndControl, maximum)
  SendMessage_(hWndControl, #EM_EXLIMITTEXT, #Null, maximum)
EndMacro

Macro EM_LineFromChar(hWndControl, CharPos)
  SendMessage_(hWndControl, #EM_LINEFROMCHAR, CharPos, #Null)
EndMacro

Macro EM_LineFromCharEx(hWndControl, CharPos)
  SendMessage_(hWndControl, #EM_EXLINEFROMCHAR, #Null, CharPos)
EndMacro

Macro EM_LineIndex(hWndControl, line)
  SendMessage_(hWndControl, #EM_LINEINDEX, line, #Null)
EndMacro

Macro EM_LineLength(hWndControl, CharLinePos)
  SendMessage_(hWndControl, #EM_LINELENGTH, CharLinePos, #Null)
EndMacro

Macro EM_LineScroll(hWndControl, number)
  SendMessage_(hWndControl, #EM_LINESCROLL, #Null, number)
EndMacro

Macro EM_PasteSpecial(hWndControl, ClipboardFormat, lpRepasteSpecial)
  SendMessage_(hWndControl, #EM_PASTESPECIAL, ClipboardFormat, lpRepasteSpecial)
EndMacro

Macro EM_PosFromChar(hWndControl, lpPointL, CharPos)
  SendMessage_(hWndControl, #EM_POSFROMCHAR, lpPointL, CharPos)
EndMacro

Macro EM_Reconversion(hWndControl)
  SendMessage_(hWndControl, #EM_RECONVERSION, #Null, #Null)
EndMacro

Macro EM_Redo(hWndControl)
  SendMessage_(hWndControl, #EM_REDO, #Null, #Null)
EndMacro

Macro EM_ReplaceSel(hWndControl, undoable, lpszText)
  SendMessage_(hWndControl, #EM_REPLACESEL, undoable, lpszText)
EndMacro

Macro EM_RequestResize(hWndControl)
  SendMessage_(hWndControl, #EM_REQUESTRESIZE, #Null, #Null)
EndMacro

Macro EM_Scroll(hWndControl, type)
  SendMessage_(hWndControl, #EM_SCROLL, type, #Null)
EndMacro

Macro EM_ScrollCaret()
  SendMessage_(hWndControl, #EM_SCROLLCARET, #Null, #Null)
EndMacro

Macro EM_SelectionType(hWndControl)
  SendMessage_(hWndControl, #EM_SELECTIONTYPE, #Null, #Null)
EndMacro

Macro EM_ShowBalloonTip(hWndControl, lpEditBalloonTip)
  SendMessage_(hWndControl, #EM_SHOWBALLOONTIP, #Null, lpEditBalloonTip)
EndMacro

Macro EM_ShowScrollBar(hWndControl, type, bool)
  SendMessage_(hWndControl, #EM_SHOWSCROLLBAR, type, bool)
EndMacro

Macro EM_StopGroupTyping(hWndControl)
  SendMessage_(hWndControl, #EM_STOPGROUPTYPING, #Null, #Null)
EndMacro

Macro EM_StreamIn(hWndControl, format, lpEditStream)
  SendMessage_(hWndControl, #EM_STREAMIN, format, lpEditStream)
EndMacro

Macro EM_StreamOut(hWndControl, format, lpEditStream)
  SendMessage_(hWndControl, #EM_STREAMOUT, format, lpEditStream)
EndMacro

Macro EM_Undo(hWndControl)
  SendMessage_(hWndControl, #EM_UNDO, #Null, #Null)
EndMacro


Macro EM_GetAutourLDetect(hWndControl)
  SendMessage_(hWndControl, #EM_GETAUTOURLDETECT, #Null, #Null)
EndMacro

Macro EM_GetBIDIOptions(hWndControl, lpBIDIOptions)
  SendMessage_(hWndControl, #EM_GETBIDIOPTIONS, #Null, lpBIDIOptions)
EndMacro

Macro EM_GetCharFormat(hWndControl, format, lpCharFormat)
  SendMessage_(hWndControl, #EM_GETCHARFORMAT, format, lpCharFormat)
EndMacro

Macro EM_GetCTFModeBias(hWndControl)
  SendMessage_(hWndControl, #EM_GETCTFMODEBIAS, #Null, #Null)
EndMacro

Macro EM_GetCTFOpenStatus(hWndControl)
  SendMessage_(hWndControl, #EM_GETCTFOPENSTATUS, #Null, #Null)
EndMacro

Macro EM_GetCueBanner(hWndControl, lpcwText, cchText)
  SendMessage_(hWndControl, #EM_GETCUEBANNER, lpcwText, cchText)
EndMacro

Macro EM_GetEditStyle(hWndControl)
  SendMessage_(hWndControl, #EM_GETEDITSTYLE, #Null, #Null)
EndMacro
Macro EM_GetEventMask(hWndControl)
  SendMessage_(hWndControl, #EM_GETEVENTMASK, #Null, #Null)
EndMacro

Macro EM_GetFirstVisibleLine(hWndControl)
  SendMessage_(hWndControl, #EM_GETFIRSTVISIBLELINE, #Null, #Null)
EndMacro

Macro EM_GetHandle(hWndControl)
  SendMessage_(hWndControl, #EM_GETHANDLE, #Null, #Null)
EndMacro

Macro EM_GetHyphenateInfo(hWndControl, lpHyphenateInfo)
  SendMessage_(hWndControl, #EM_GETHYPHENATEINFO, lpHyphenateInfo, #Null)
EndMacro

Macro EM_GetIMEColor(hWndControl, lpCompColor)
  SendMessage_(hWndControl, #EM_GETIMECOLOR, #Null, lpCompColor)
EndMacro

Macro EM_GetIMECompMode(hWndControl)
  SendMessage_(hWndControl, #EM_GETIMECOMPMODE, #Null, #Null)
EndMacro

Macro EM_GetIMECompText(hWndControl, lpIMECompText, lpszText)
  SendMessage_(hWndControl, #EM_GETIMECOMPTEXT, lpIMECompText, lpszText)
EndMacro

Macro EM_GetIMEModeBias(hWndControl)
  SendMessage_(hWndControl, #EM_GETIMEMODEBIAS, #Null, #Null)
EndMacro

Macro EM_GetIMEOptions(hWndControl)
  SendMessage_(hWndControl, #EM_GETIMEOPTIONS, #Null, #Null)
EndMacro

Macro EM_GetIMEProperty(hWndControl, type)
  SendMessage_(hWndControl, #EM_GETIMEPROPERTY, type, #Null)
EndMacro

Macro EM_GetIMEStatus(hWndControl, type)
  SendMessage_(hWndControl, #EM_GETIMESTATUS, type, #Null)
EndMacro

Macro EM_GetLangOptions(hWndControl)
  SendMessage_(hWndControl, #EM_GETLANGOPTIONS, #Null, #Null)
EndMacro

Macro EM_GetLimitText(hWndControl)
  SendMessage_(hWndControl, #EM_GETLIMITTEXT, #Null, #Null)
EndMacro

Macro EM_GetLine(hWndControl, line, lpszText)
  SendMessage_(hWndControl, #EM_GETLINE, line, lpszText)
EndMacro

Macro EM_GetLineCount(hWndControl)
  SendMessage_(hWndControl, #EM_GETLINECOUNT, #Null, #Null)
EndMacro

Macro EM_GetMargins(hWndControl)
  SendMessage_(hWndControl, #EM_GETMARGINS, #Null, #Null)
EndMacro

Macro EM_GetModify(hWndControl)
  SendMessage_(hWndControl, #EM_GETMODIFY, #Null, #Null)
EndMacro

Macro EM_GetPasswordChar(hWndControl)
  SendMessage_(hWndControl, #EM_GETPASSWORDCHAR, #Null, #Null)
EndMacro

Macro EM_GetOLEInterface(hWndControl, lplpIRichEditOle)
  SendMessage_(hWndControl, #EM_GETOLEINTERFACE, #Null, lplpIRichEditOle)
EndMacro

Macro EM_GetOptions(hWndControl)
  SendMessage_(hWndControl, #EM_GETOPTIONS, #Null, #Null)
EndMacro

Macro EM_GetPageRotate(hWndControl)
  SendMessage_(hWndControl, #EM_GETPAGEROTATE, #Null, #Null)
EndMacro

Macro EM_GetParaFormat(hWndControl, lpParaFormat)
  SendMessage_(hWndControl, #EM_GETPARAFORMAT, #Null, lpParaFormat)
EndMacro

Macro EM_GetPunctuation(hWndControl, type, lpPunctuation)
  SendMessage_(hWndControl, #EM_GETPUNCTUATION, type, lpPunctuation)
EndMacro

Macro EM_GetRect(hWndControl, lpRect)
  SendMessage_(hWndControl, #EM_GETRECT, #Null, lpRect)
EndMacro

Macro EM_GetRedoName(hWndControl)
  SendMessage_(hWndControl, #EM_GETREDONAME, #Null, #Null)
EndMacro

Macro EM_GetScrollPos(hWndControl, lpPoint)
  SendMessage_(hWndControl, #EM_GETSCROLLPOS, #Null, lpPoint)
EndMacro

Macro EM_GetSel(hWndControl, lpCharPos1, lpCharPos2)
  SendMessage_(hWndControl, #EM_GETSEL, lpCharPos1, lpCharPos2)
EndMacro

Macro EM_GetSelEx(hWndControl, lpCharRange)
  SendMessage_(hWndControl, #EM_EXGETSEL, #Null, lpCharRange)
EndMacro

Macro EM_GetSelText(hWndControl, lpText)
  SendMessage_(hWndControl, #EM_GETSELTEXT, #Null, lpText)
EndMacro

Macro EM_GetTextEx(hWndControl, lpGetTextEx, lpszText)
  SendMessage_(hWndControl, #EM_GETTEXTEX, lpGetTextEx, lpszText)
EndMacro

Macro EM_GetTextLengthEx(hWndControl, lpGetTextLengthEx)
  SendMessage_(hWndControl, #EM_GETTEXTLENGTHEX, lpGetTextLengthEx, #Null)
EndMacro

Macro EM_GetTextMode(hWndControl)
  SendMessage_(hWndControl, #EM_GETTEXTMODE, #Null, #Null)
EndMacro

Macro EM_GetTextRange(hWndControl, lpTextRange)
  SendMessage_(hWndControl, #EM_GETTEXTRANGE, #Null, lpTextRange)
EndMacro

Macro EM_GetThumb(hWndControl)
  SendMessage_(hWndControl, #EM_GETTHUMB, #Null, #Null)
EndMacro

Macro EM_GetTypographyOptions(hWndControl)
  SendMessage_(hWndControl, #EM_GETTYPOGRAPHYOPTIONS, #Null, #Null)
EndMacro

Macro EM_GetUndoName(hWndControl)
  SendMessage_(hWndControl, #EM_GETUNDONAME, #Null, #Null)
EndMacro

Macro EM_GetWordBreakProc(hWndControl)
  SendMessage_(hWndControl, #EM_GETWORDBREAKPROC, #Null, #Null)
EndMacro

Macro EM_GetWordBreakProcEx(hWndControl)
  SendMessage_(hWndControl, #EM_GETWORDBREAKPROCEX, #Null, #Null)
EndMacro

Macro EM_GetWordWrapMode(hWndControl)
  SendMessage_(hWndControl, #EM_GETWORDWRAPMODE, #Null, #Null)
EndMacro

Macro EM_GetZoom(hWndControl, lpNumerator, lpDenominator)
  SendMessage_(hWndControl, #EM_GETZOOM, lpNumerator, lpDenominator)
EndMacro

Macro EM_SetBIDIOptions(hWndControl, lpBIDIOptions)
  SendMessage_(hWndControl, #EM_SETCTFMODEBIAS, #Null, lpBIDIOptions)
EndMacro

Macro EM_SetBkgndColor(hWndControl, color)
  SendMessage_(hWndControl, #EM_SETBKGNDCOLOR, #Null, color)
EndMacro

Macro EM_SetCharFormat(hWndControl, type, lpFormat)
  SendMessage_(hWndControl, #EM_SETCHARFORMAT, type, lpFormat)
EndMacro

Macro EM_SetCTFModeBias(hWndControl, mode)
  SendMessage_(hWndControl, #EM_SETCTFMODEBIAS, mode, #Null)
EndMacro

Macro EM_SetCTFOpenStatus(hWndControl, bool)
  SendMessage_(hWndControl, #EM_SETCTFOPENSTATUS, bool, #Null)
EndMacro

Macro EM_SetCueBanner(hWndControl, lpszText)
  SendMessage_(hWndControl, #EM_SETCUEBANNER, #Null, lpszText)
EndMacro

Macro EM_SetEditStyle(hWndControl, type, mask)
  SendMessage_(hWndControl, #EM_SETEDITSTYLE, type, mask)
EndMacro

Macro EM_SetEventMask(hWndControl, mask)
  SendMessage_(hWndControl, #EM_SETEVENTMASK, #Null, mask)
EndMacro

Macro EM_SetFontSize(hWndControl, size)
  SendMessage_(hWndControl, #EM_SETFONTSIZE, size, #Null)
EndMacro

Macro EM_SetHandle(hWndControl, lpBuffer)
  SendMessage_(hWndControl, #EM_SETHANDLE, lpBuffer, #Null)
EndMacro

Macro EM_SetHyphenateInfo(hWndControl, lpHyphenateInfo)
  SendMessage_(hWndControl, #EM_SETHYPHENATEINFO, lpHyphenateInfo, #Null)
EndMacro

Macro EM_SetIMEColor(hWndControl, lpCompColor)
  SendMessage_(hWndControl, #EM_SETIMECOLOR, #Null, lpCompColor)
EndMacro

Macro EM_SetIMEModeBias(hWndControl, mode)
  SendMessage_(hWndControl, #EM_SETIMEMODEBIAS, mode, mode)
EndMacro

Macro EM_SetIMEOptions(hWndControl, ecoop, imf)
  SendMessage_(hWndControl, #EM_SETIMEOPTIONS, ecoop, imf)
EndMacro

Macro EM_SetIMEStatus(hWndControl, type, lpData)
  SendMessage_(hWndControl, #EM_SETIMESTATUS, type, lpData)
EndMacro

Macro EM_SetLangOptions(hWndControl, option)
  SendMessage_(hWndControl, #EM_SETLANGOPTIONS, #Null, option)
EndMacro

Macro EM_SetLimitText(hWndControl, maximum)
  SendMessage_(hWndControl, #EM_SETLIMITTEXT, maximum, #Null)
EndMacro

Macro EM_SetMargins(hWndControl, types, width)
  SendMessage_(hWndControl, #EM_SETMARGINS, types, width)
EndMacro

Macro EM_SetModify(hWndControl, bool)
  SendMessage_(hWndControl, #EM_SETMODIFY, bool, #Null)
EndMacro

Macro EM_SetOLECallback(hWndControl, lpIRichEditOle)
  SendMessage_(hWndControl, #EM_SETOLECALLBACK, #Null, lpIRichEditOle)
EndMacro

Macro EM_SetOptions(hWndControl, ecoop, eco)
  SendMessage_(hWndControl, #EM_SETOPTIONS, ecoop, eco)
EndMacro

Macro EM_SetPageRotate(hWndControl, layout)
  SendMessage_(hWndControl, #EM_SETPAGEROTATE, layout, #Null)
EndMacro

Macro EM_SetPalette(hWndControl, lpPalette)
  SendMessage_(hWndControl, #EM_SETPALETTE, lpPalette, #Null)
EndMacro

Macro EM_SetParaFormat(hWndControl, lpParaFormat)
  SendMessage_(hWndControl, #EM_SETPARAFORMAT, #Null, lpParaFormat)
EndMacro

Macro EM_SetPasswordChar(hWndControl, char)
  SendMessage_(hWndControl, #EM_SETPASSWORDCHAR, char, #Null)
EndMacro

Macro EM_SetPunctuation(hWndControl, type, lpPunctuation)
  SendMessage_(hWndControl, #EM_SETPUNCTUATION, type, lpPunctuation)
EndMacro

Macro EM_SetReadOnly(hWndControl, bool)
  SendMessage_(hWndControl, #EM_SETREADONLY, bool, #Null)
EndMacro

Macro EM_SetRect(hWndControl, bool, lpRect)
  SendMessage_(hWndControl, #EM_SETRECT, bool, lpRect)
EndMacro

Macro EM_SetRectNP(hWndControl, bool, lpRect)
  SendMessage_(hWndControl, #EM_SETRECTNP, bool, lpRect)
EndMacro

Macro EM_SetScrollPos(hWndControl, lpPoint)
  SendMessage_(hWndControl, #EM_SETSCROLLPOS, #Null, lpPoint)
EndMacro

Macro EM_SetSel(hWndControl, CharPos1, CharPos2)
  SendMessage_(hWndControl, #EM_SETSEL, CharPos1, CharPos2)
EndMacro

Macro EM_SetSelEx(hWndControl, lpCharRange)
  SendMessage_(hWndControl, #EM_EXSETSEL, #Null, lpCharRange)
EndMacro

Macro EM_SetTabStops(hWndControl, number, lpArray)
  SendMessage_(hWndControl, #EM_SETTABSTOPS, number, lpArray)
EndMacro

Macro EM_SetTargetDevice(hWndControl, hDC, lineWidth)
  SendMessage_(hWndControl, #EM_SETTARGETDEVICE, hDC, lineWidth)
EndMacro

Macro EM_SetTextEx(hWndControl, lpSetTextEx, lpszText)
  SendMessage_(hWndControl, #EM_SETTEXTEX, lpSetTextEx, lpszText)
EndMacro

Macro EM_SetTextMode(hWndControl, mode)
  SendMessage_(hWndControl, #EM_SHOWSCROLLBAR, mode, #Null)
EndMacro

Macro EM_SetTypographyOptions(hWndControl, type, mask)
  SendMessage_(hWndControl, #EM_SETTYPOGRAPHYOPTIONS, type, mask)
EndMacro

Macro EM_SetUndoLimit(hWndControl, maximum)
  SendMessage_(hWndControl, #EM_SETUNDOLIMIT, maximum, #Null)
EndMacro

Macro EM_SetWordBreakProc(hWndControl, lpEditWordBreakProc)
  SendMessage_(hWndControl, #EM_SETWORDBREAKPROC, #Null, lpEditWordBreakProc)
EndMacro

Macro EM_SetWordBreakProcEx(hWndControl, lpEditWordBreakProcEx)
  SendMessage_(hWndControl, #EM_SETWORDBREAKPROCEX, #Null, lpEditWordBreakProcEx)
EndMacro

Macro EM_SetWordWrapMode(hWndControl, mode)
  SendMessage_(hWndControl, #EM_SETWORDWRAPMODE, mode, #Null)
EndMacro

Macro EM_SetZoom(hWndControl, numerator, denominator)
  SendMessage_(hWndControl, #EM_SETZOOM, numerator, denominator)
EndMacro


; IDE Options = PureBasic v4.00 (Windows - x86)
; CursorPosition = 3
; Folding = ----------------------
; EnableXP
; HideErrorLog