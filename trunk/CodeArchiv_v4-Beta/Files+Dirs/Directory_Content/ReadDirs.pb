; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2260&highlight=
; Author: NicTheQuick (updated for PB4.00 by blbltheworm)
; Date: 12. September 2003
; OS: Windows
; Demo: Yes

#TreeGadget = 0 

Procedure ReadDirs(Path.s, Rek.l) 
  If Right(Path, 1) = "\" : Path = Left(Path, Len(Path) - 1) : EndIf 
  
  NextOK.l 
  Name.s 
  ExamineDirectory(Rek, Path, "") 
  
  Repeat 
    NextOK = NextDirectoryEntry(Rek) 
    Name = DirectoryEntryName(Rek) 
    If NextOK = 2 And Name <> "." And Name <> ".." 
      ReadDirs(Path + "\" + Name, Rek + 1) 
      While WindowEvent() : Wend 
    ElseIf NextOK = 1 
      AddGadgetItem(0, -1, Path + "\" + Name) 
    EndIf 
  Until NextOK = #False 
EndProcedure 

If OpenWindow(0, 216, 0, 310, 520, "ReadDirs...",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
  If CreateGadgetList(WindowID(0)) 
    ListViewGadget(0, 5, 5, 305, 515) 
  EndIf 
EndIf 

ReadDirs("C:\", 0) 

Repeat 
Until WaitWindowEvent() = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
