; German forum:
; Author: Unknown
; Date: 09. February 2003
; OS: Windows
; Demo: No

Procedure MsgBoxEx(Message.s,Caption.s,Iconfile.s,Index.l)
  #MB_USERICON = $080
  Protected hDll.l
  hDll = OpenLibrary(0,Iconfile)
  mbox.MSGBOXPARAMS
  mBox\cbSize = SizeOf(MSGBOXPARAMS)
  mbox\hwndOwner = 0
  mbox\hInstance = hDll
  mbox\lpszText = @Message
  mbox\lpszCaption = @Caption
  mbox\dwStyle = #MB_OK|#MB_USERICON
  mbox\lpszIcon = Index
  mbox\dwContextHelpId = 0
  mbox\lpfnMsgBoxCallback = 0
  mbox\dwLanguageId = 0
  Result = MessageBoxIndirect_(mbox)
  CloseLibrary(0)
  ProcedureReturn Result
EndProcedure


MsgBoxEx("Testmeldung","Caption","Shell32",5)
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -