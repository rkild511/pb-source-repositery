; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=22766#22766
; Author: isidoro (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No

; Window Variablen
#MainWin=0
#WinX=300
#WinY=200
#WinW=200
#WinH=200

#BufferLength = 1000
#MEM_DROPFILES = 10
*Buffer = AllocateMemory(#BufferLength)

hWnd = OpenWindow(#MainWin, #WinX,#WinY, #WinW,#WinH, "DragTest", #PB_Window_SystemMenu)
If hWnd
  DragAcceptFiles_(WindowID(#MainWin), 1)
  Repeat
    Event= WaitWindowEvent()
    Select Event
    Case #PB_Event_CloseWindow
      Quit = 1
      
    Case #WM_DROPFILES
      *DropHandle = EventwParam()
      Debug *DropHandle
      If *DropHandle
        NbDroppedFiles = DragQueryFile_ (*DropHandle, $FFFFFFFF, *Buffer, #BufferLength)
        DragQueryFile_(*DropHandle, k, *Buffer, #BufferLength)
        DragFinish_(*DropHandle)
        File$=PeekS(*Buffer)
        MessageRequester("Gedropter Name", File$, 0)
      EndIf
    EndSelect
  Until Quit = 1
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
