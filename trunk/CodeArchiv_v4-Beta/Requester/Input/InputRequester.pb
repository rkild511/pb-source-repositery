; English forum:
; Author: fweil (updated for PB4.00 by blbltheworm)
; Date: 08. July 2002
; OS: Windows
; Demo: No


;==========================================================
;
; InputRequesterS is a Requester function displaying a string box
; and returning the entered string.
;
; A title and a default value are passed, and return key or OK button
; allow to return from procedure.
;
; If Escape key is pushed or the requester is closed without return or OK
; validation , the returned value is the default.
;

Procedure.s InputRequesterS(lTitle.s, lDefault.s)
  ;
  ; Constants are set for possible integration
  ;
  #InputRequesterSWID = 99
  #InputRequesterSGID = 198
  lXSize.l = 200
  lYSize.l = 25
  ;
  ; GetSystemMetrics_ API function gives access to screen dimensions
  ;
  If OpenWindow(#InputRequesterSWID, (GetSystemMetrics_(#SM_CXSCREEN) - lXSize) / 2, (GetSystemMetrics_(#SM_CYSCREEN) - lYSize) / 2, lXSize + 40, lYSize, lTitle, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)
    AddKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_Return, 10)
    AddKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_Escape, 99)
    If CreateGadgetList(WindowID(#InputRequesterSWID))
      StringGadget(#InputRequesterSGID, 2, 2, lXSize - 4, lYSize - 5, lDefault)
      ButtonGadget(#InputRequesterSGID + 1, lXSize + 5, lYSize - 25, 30, 20, "OK")
    EndIf
    lResult.s = GetGadgetText(#InputRequesterSGID)
    lQuit.l = #False
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          lQuit = #True
        Case #PB_Event_Menu
          Select EventMenu()
            Case 10
              lResult = GetGadgetText(#InputRequesterSGID)
              lQuit = #True
            Case 99
              lQuit = #True
          EndSelect
        Case #PB_Event_Gadget
          Select EventGadget()
            Case (#InputRequesterSGID + 1)
              lResult = GetGadgetText(#InputRequesterSGID)
              lQuit = #True
          EndSelect
      EndSelect
    Until lQuit
    RemoveKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_All)
    CloseWindow(#InputRequesterSWID)
  EndIf
  ProcedureReturn lResult
EndProcedure

;
; InputRequesterSML is a multilined string input requester.
; It is like InputRequesterS but does not return when using the return key
; and allows mulitple lines handling.
;
; Also this requester gives the possibility of resizing to meet user's needs
;
Procedure.s InputRequesterSML(lTitle.s, lDefault.s)
  #InputRequesterSWID = 99
  #InputRequesterSGID = 198
  lXSize.l = 200
  lYSize.l = 80
  If OpenWindow(#InputRequesterSWID, (GetSystemMetrics_(#SM_CXSCREEN) - lXSize) / 2, (GetSystemMetrics_(#SM_CYSCREEN) - lYSize) / 2, lXSize + 40, lYSize, lTitle, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
    AddKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_Escape, 99)
    If CreateGadgetList(WindowID(#InputRequesterSWID))
      StringGadget(#InputRequesterSGID, 2, 2, lXSize - 4, lYSize - 5, lDefault, #ES_MULTILINE | #ES_AUTOVSCROLL | #WS_VSCROLL | #WS_HSCROLL)
      ButtonGadget(#InputRequesterSGID + 1, lXSize + 5, lYSize - 25, 30, 20, "OK")
    EndIf
    lResult.s = GetGadgetText(#InputRequesterSGID)
    lQuit.l = #False
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          lQuit = #True
        Case #PB_Event_Menu
          Select EventMenu()
            Case 99
              lQuit = #True
          EndSelect
        Case #PB_Event_Gadget
          Select EventGadget()
            Case (#InputRequesterSGID + 1)
              lResult = GetGadgetText(#InputRequesterSGID)
              lQuit = #True
          EndSelect
      EndSelect
      If WindowWidth(#InputRequesterSWID) <> lXSize + 40 Or WindowHeight(#InputRequesterSWID) <> lYSize
        lXSize = WindowWidth(#InputRequesterSWID) - 40
        lYSize = WindowHeight(#InputRequesterSWID)
        ResizeGadget(#InputRequesterSGID, 2, 2, lXSize - 4, lYSize - 5)
        ResizeGadget(#InputRequesterSGID + 1, lXSize + 5, lYSize - 25, 30, 20)
      EndIf
    Until lQuit
    RemoveKeyboardShortcut(#InputRequesterSWID, #PB_Shortcut_All)
    CloseWindow(#InputRequesterSWID)
  EndIf
  ProcedureReturn lResult
EndProcedure

;
; Main test code
;
sString.s
; sString = InputRequesterS("Enter a text", "Default")
; Debug sString

sString = InputRequesterSML("Enter a text", "Default")
Debug sString

End
;==========================================================

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP