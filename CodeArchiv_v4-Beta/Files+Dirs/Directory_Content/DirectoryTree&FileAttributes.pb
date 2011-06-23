; English forum: 
; Author: fweil (updated for PB4.00 by blbltheworm)
; Date: 22. July 2002
; OS: Windows
; Demo: Yes

;============================================================
Quit.l
NextEntry.l
NextEntrySize.l
Result.l
WEvent.l
EventGadget.l
FileAttributes.l
Directory.s
FileName.s
FileType.s
SNextEntrySize.s
sFileAttributes.s
Quit = 0
If OpenWindow(0, 200, 200, 480, 360, "", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_TitleBar)

  If CreateGadgetList(WindowID(0))
    ListIconGadget(10, 10, 10, 460, 300, "Name", 120)
    AddGadgetColumn(10, 1, "Type", 80)
    AddGadgetColumn(10, 2, "Size", 80)
    AddGadgetColumn(10, 3, "Attributes", 80)
  EndIf
  
  Directory = "C:\"
  NextEntry = ExamineDirectory(0, Directory, "*.*")
  While NextEntry
    NextEntry = NextDirectoryEntry(0)
    FileName = DirectoryEntryName(0)
    Select NextEntry
      Case 1
        FileType = "File"
      Case 2
        FileType = "Dir"
      Default
    EndSelect
    NextEntrySize = FileSize(Directory + "\" + FileName)
    Select NextEntrySize
      Case -1
        sNextEntrySize = "Not foud"
      Case -2
        sNextEntrySize = "."
      Default
        sNextEntrySize = Str(NextEntrySize)
    EndSelect
    FileAttributes = DirectoryEntryAttributes(0)
    sFileAttributes = " "
    If FileAttributes & #PB_FileSystem_Hidden
      sFileAttributes = "H" + Mid(sFileAttributes, 2, 5)
    EndIf
    If FileAttributes & #PB_FileSystem_Archive
      sFileAttributes = Mid(sFileAttributes, 1, 1) + "A" + Mid(sFileAttributes, 3, 4)
    EndIf
    If FileAttributes & #PB_FileSystem_Compressed
      sFileAttributes = Mid(sFileAttributes, 1, 2) + "C" + Mid(sFileAttributes, 4, 3)
    EndIf
    If FileAttributes & #PB_FileSystem_Normal
      sFileAttributes = Mid(sFileAttributes, 1, 3) + "N" + Mid(sFileAttributes, 5, 2)
    EndIf
    If FileAttributes & #PB_FileSystem_ReadOnly
      sFileAttributes = Mid(sFileAttributes, 1, 4) + "R" + Mid(sFileAttributes, 6, 1)
    EndIf
    If FileAttributes & #PB_FileSystem_System
      sFileAttributes = Mid(sFileAttributes, 1, 5) + "S"
    EndIf
    AddGadgetItem(10, -1, FileName + Chr(10) + FileType + Chr(10) + sNextEntrySize + Chr(10) + sFileAttributes)
  Wend
  
  Repeat
    WEvent = WaitWindowEvent()
    
    Select WEvent
      Case #PB_Event_Menu
      Case #PB_Event_Gadget
      Case #PB_Event_CloseWindow
        Quit = 1
      Case #PB_Event_Repaint
      Case #PB_Event_MoveWindow
      Default
    EndSelect

  Until Quit

EndIf

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP