; www.PureArea.net
; Author: blueb (updated for PB4.00 by blbltheworm)
; Date: 02. November 2002
; OS: Windows
; Demo: No

;======================================================================
;   ShareCopy.PB -  A Muli-Function Copy Tool that uses: Shell32.dll
;                   I found a subroutine on VB web-site -  author unknown
;                   modified for PureBasic -  Public Domain
;                   Bob Houle - updated Nov 02/02    blueb@shaw.ca
;======================================================================
#Window1 = 1
#W1Btn1 = 1
#W1Btn2 = 2
#W1Btn3 = 3
#W1Btn4 = 4
#W1Btn5 = 5
#W1String1 = 6
#W1String2 = 7
#W1Check1 = 8
#W1Check2 = 9
#W1Check3 = 10
#W1Check4 = 11
#W1Check5 = 12
#W1Text1 = 13
#W1Text2 = 14

#Window1Flags = #PB_Window_MinimizeGadget | #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_WindowCentered 
#Text1Flags = #PB_Text_Right
#Text2Flags = #PB_Text_Right

;======================================================================
;                [ Declares ]
;======================================================================
Declare MyWindowCallback(WindowID, Message, wParam, lParam)
Declare Button_Click(Index.l)

;======================================================================
;                [ Globals ]
;======================================================================
Global SHFileOp.SHFILEOPSTRUCT    ;Windows API Structure

;========================================================================================

WinW=500
WinH=230 ; Window sizes.

hWnd.l = OpenWindow(#Window1,0,0,WinW,WinH,"Window-Like File Operations",#Window1Flags)
 If CreateGadgetList(WindowID(1))
   ButtonGadget(#W1Btn1,7,200 ,89,25,"Copy")
   ButtonGadget(#W1Btn2,105,200 ,89,25,"Move")
   ButtonGadget(#W1Btn3,205,200 ,89,25,"Rename")
   ButtonGadget(#W1Btn4,305,200 ,89,25,"Delete")
   ButtonGadget(#W1Btn5,405,200 ,89,25,"Quit", 1)
   StringGadget(#W1String1,220,8,250,21,"")
   StringGadget(#W1String2,220,30 ,250,21,"")
   CheckBoxGadget(#W1Check1,90,80 ,391,17,"Don't display a progress dialog box")
   CheckBoxGadget(#W1Check2,90,100 ,403,17,"Respond with 'Yes to all' for any dialog box that is displayed")
   CheckBoxGadget(#W1Check3,90,120 ,404,17,"Rename the file (eg:'Copy #1 of...') if the target name already exists")
   CheckBoxGadget(#W1Check4,90,140 ,384,17,"Do not confirm the creation of a new directory if the operation requires it")
   CheckBoxGadget(#W1Check5,90,160 ,398,17,"Perform the operation only on files if a wildcard filename (*.*) is specified")
   TextGadget(#W1Text1,50,12 ,161,17,"Source File or Folder", #Text1Flags)
   TextGadget(#W1Text2,50,35,161,17,"Destination File or Folder", #Text2Flags)
 EndIf
 
If hWnd 
;Message Loop

; ----- Windows Messages
  ; Callback is not required for this App, but included anyways :)
  ; Might want to reply to Windows messages.
  ; For now simply try re-sizing the window
  SetWindowCallback(@MyWindowCallback())
  
; ----- PB specific messages
 Repeat
   EventID.l = WaitWindowEvent()

  Select EventID

          Case #PB_Event_Gadget

              Select EventGadget()
               Case #W1Btn1 ;----------Copy
                    Button_Click(0)
               Case #W1Btn2 ;----------Move
                    Button_Click(1)
               Case #W1Btn3 ;----------Rename
                    Button_Click(2)
               Case #W1Btn4 ;----------Delete
                    Button_Click(3)
               Case #W1Btn5 ;----------Quit
                      EventID = #PB_Event_CloseWindow
              EndSelect

  EndSelect

 Until EventID = #PB_Event_CloseWindow

EndIf
End ; program finish

; *********************************************************************
;                [ Required Procedures ]
; *********************************************************************


;======================================================================
;                [ Callback Procedure ]
;======================================================================
Procedure MyWindowCallback(WindowID, Message, wParam, lParam) 
  Result = #PB_ProcessPureBasicEvents 
    Select message 
          Case #WM_SIZE    ;just testing
              Beep_(50,50) 
    EndSelect 
  ProcedureReturn Result 
EndProcedure 

;======================================================================
;                [ SHFileOperation API Procedure ]
;======================================================================
Procedure.l Button_Click(Index.l)

;define variables
 lFileOp.f
 lresult.l
 lFlags.w

;Get status of checkboxes
ChkDir.l = GetGadgetState(#W1Check4) 
ChkFilesOnly.l = GetGadgetState(#W1Check5) 
ChkRename.l = GetGadgetState(#W1Check3) 
ChkSilent.l = GetGadgetState(#W1Check1) 
ChkYesToAll.l = GetGadgetState(#W1Check2)  

;Get the edit box values
FromDirectory.s = GetGadgetText(#W1String1) 
ToDirectory.s = GetGadgetText(#W1String2)

;Find out which button was pressed 
 Select Index
    Case 0
        lFileOp = #FO_COPY
    Case 1
        lFileOp = #FO_MOVE
    Case 2
        lFileOp = #FO_RENAME
    Case 3
         ChkYesToAll = 0      ;No mattter what - confirm Deletes! Prevents OOPS!
         lFileOp = #FO_DELETE
 EndSelect

If ChkSilent:lFlags = lFlags | #FOF_SILENT: EndIf
If ChkYesToAll: lFlags = lFlags | #FOF_NOCONFIRMATION:EndIf
If ChkRename: lFlags = lFlags | #FOF_RENAMEONCOLLISION: EndIf
If ChkDir: lFlags = lFlags | #FOF_NOCONFIRMMKDIR: EndIf
If ChkFilesOnly: lFlags = lFlags | #FOF_FILESONLY: EndIf

; NOTE:  If you add the #FOF_ALLOWUNDO Flag you can move
;        a file to the Recycle Bin instead of deleting it.

  SHFileOp\wFunc = lFileOp
  SHFileOp\pFrom = @FromDirectory
  SHFileOp\pTo = @ToDirectory 
  SHFileOp\fFlags = lFlags

 lresult = SHFileOperation_(SHFileOp)

;  If User hit Cancel button While operation is in progress,
;  the fAnyOperationsAborted parameter will be true
;  - see win32api.inc For Structure details.

If lresult <> 0 | SHFileOp\fAnyOperationsAborted:EndIf: ProcedureReturn 0

 MessageRequester("Operation Has Completed", "PureBasic Rules!", 0)
  ProcedureReturn = lresult
EndProcedure
; ================================================================

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP