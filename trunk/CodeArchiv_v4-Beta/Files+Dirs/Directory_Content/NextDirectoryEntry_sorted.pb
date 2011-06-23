; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=605&highlight=
; Author: J-The-Grey (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: Yes

OpenWindow(0,100,120,300,300,"Test",#PB_Window_MinimizeGadget) 

If CreateGadgetList(WindowID(0)) 
   ListIconGadget(0,20,20,250,250,"Datei-Namen - sortiert ?", 246, #LVS_SORTASCENDING | #PB_ListIcon_GridLines) 
EndIf 


; Das Hauptverzeichnis durchsuchen und alle Dateinamen 
; in das Listicongadget schreiben. 

If ExamineDirectory(0, "c:\","*.*") 
    Repeat 
       FileType = NextDirectoryEntry(0) 
       If FileType 
          AddGadgetItem(0,-1,DirectoryEntryName(0)) 
          While WindowEvent(): Wend 
       EndIf 
    Until FileType = 0 
EndIf 


Repeat 
   EventID.l = WaitWindowEvent() 
   If EventID = #PB_Event_CloseWindow : End : EndIf 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
