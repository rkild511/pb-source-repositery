; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6064&highlight=
; Author: Fangbeast (updated for PB4.00 by blbltheworm)
; Date: 05. May 2003
; OS: Windows
; Demo: No
 
#Tree = 1 
#List = 2 
#Text = 3 

#folder = 4 
#drive = 5 
#imail = 6 
; 
Global fver.s,fid0.s,fname.s,ftype.s,fcat.s,fcoll.s,fdisp.s,tmark.s,tlink.s,fid1.s,fid2.s,fid3.s,fid4.s,fid5.s 
; 
Declare DirScan(DirectoryID.l, DirectoryName.s) 
Declare FileScan(FilePath.s) 
Declare ProcessFile(FileInfo.s) 
Declare.s GetIni(key.s, section.s)                          ; Get data from content.ini file 
; 
Global NewList FullPaths.s() 
; 
OpenWindow(0, 0, 0, 800, 600, "Dir Scan...", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(0)) 
TreeGadget(#Tree,  10,  10, 180, 530, #PB_Tree_AlwaysShowSelection) 
ListIconGadget(#List, 200, 10, 590, 530, "File", 150, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
  AddGadgetColumn(#List, 1, "Size", 50) 
  AddGadgetColumn(#List, 2, "Attr", 50) 
  AddGadgetColumn(#List, 3, "Type", 80) 
  AddGadgetColumn(#List, 4, "Cat",  80) 
  AddGadgetColumn(#List, 5, "Col", 80) 

TextGadget(#Text,  10, 550, 770,  40, "", #PB_Text_Border) 
; 
AddGadgetItem(#Tree, -1, "C:", CatchImage(#drive,?drive)) : DirScan(0, "C:\") 
AddGadgetItem(#Tree, -1, "D:", CatchImage(#drive,?drive)) : DirScan(0, "D:\") 
AddGadgetItem(#Tree, -1, "E:", CatchImage(#drive,?drive)) : DirScan(0, "E:\") 
; 
SetGadgetItemState(#Tree, 0, #PB_Tree_Expanded | #PB_Tree_Selected) 
  SelectElement(FullPaths(), 0) 
  FileScan(FullPaths()) 
; 
Repeat 
  EventID = WaitWindowEvent() 
    If EventID = #PB_Event_Gadget 
      Select EventGadget() 
        Case #Tree  : Gosub TreeClicked 
      EndSelect 
    EndIf 
Until EventID = #PB_Event_CloseWindow 
End 
; 
TreeClicked: 
  If EventType() = #PB_EventType_LeftClick And GetGadgetState(#Tree) <> -1 
    ClearGadgetItemList(#List) 
    CurrentLine = GetGadgetState(#Tree) 
    SelectElement(FullPaths(), CurrentLine) 
    FileScan(FullPaths()) 
  EndIf 
Return 
; 
Procedure DirScan(DirectoryID.l, DirectoryName.s) 
  AddElement(FullPaths()) 
  FullPaths() = DirectoryName 
  SetGadgetText(#Text, DirectoryName) 
  
  
  ;OpenTreeGadgetNode(#Tree) 
  If ExamineDirectory(DirectoryID, DirectoryName, "*.*") 
    Repeat 
      entry.l = NextDirectoryEntry(DirectoryID) 
      If entry = 1  
        AddGadgetItem(#Tree, -1, DirectoryEntryName(DirectoryID),0,1) ;(FileName found) 
      ElseIf entry = 2 
        name.s = DirectoryEntryName(DirectoryID) 
        If name <> "." And name <> ".." 
          While WindowEvent():Wend 
          AddGadgetItem(#Tree, -1, name, CatchImage(#folder,?folder)) 
          DirScan(DirectoryID + 1, DirectoryName + name + "\") 
        EndIf 
      EndIf 
    Until entry = 0 
  EndIf 
  ;CloseTreeGadgetNode(#Tree) 
EndProcedure 
; 
Procedure FileScan(FilePath.s) 
  If ExamineDirectory(1024, FilePath.s, "*.*") 
    Repeat 
      FileType     = NextDirectoryEntry(1024) 
      FileName.s   = DirectoryEntryName(1024) 
      FileSize     = FileSize(FilePath.s + "\" + DirectoryEntryName(1024)) 
      Mattribute   = DirectoryEntryAttributes(1024) 
      LetrType.s   = UCase(Right(FileName, 4)) 

      If Mattribute & #PB_FileSystem_Normal         : Attributes.s = "-----" 
      ElseIf Mattribute & #PB_FileSystem_ReadOnly   : Attributes.s = "R----" 
      ElseIf Mattribute & #PB_FileSystem_Archive    : Attributes.s = "-A---" 
      ElseIf Mattribute & #PB_FileSystem_System     : Attributes.s = "--S--" 
      ElseIf Mattribute & #PB_FileSystem_Hidden     : Attributes.s = "---H-" 
      ElseIf Mattribute & #PB_FileSystem_Compressed : Attributes.s = "----C" 
      EndIf 

;      Select LetrType 
;        Case ".IMF" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IMA" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IME" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IMI" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IMN" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IMS" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Case ".IMW" : ProcessFile(FilePath.s + "\" + FileName.s) 
;        Default     : ftype.s = ""  : fcat.s = "" : fcoll.s = "" 
;      EndSelect 
      
      If FileType = 1 
        While WindowEvent():Wend 
        AddGadgetItem(#List, -1, FileName.s + Chr(10) + Str(FileSize) + Chr(10) + Attributes + Chr(10) + ftype.s + Chr(10) + fcat.s + Chr(10) + fcoll.s) 
      EndIf 
    Until FileType = 0 
  EndIf 
EndProcedure 
; 
; Process the files found during the directory search 
; 

Procedure ProcessFile(FileInfo.s) 

  If ReadFile(0, FileInfo.s) 
    ; 
    unpacker.s = "C:\iCat2\cabarc.exe"                        ; Drive and directory for extract.exe 
    params.s = " -o x " + Chr(34) + FileInfo.s + Chr(34) + " content.ini C:\iCat2\" 

    If RunProgram(unpacker.s, params.s, "", 1 | 2) <> 0 
    EndIf 

    section.s   = "Version" 
      fver.s    = GetIni("Number", section.s) 
    section.s   = "General" 
      fid0.s    = GetIni("ID", section.s) 
      fname.s   = GetIni("File", section.s) 
      ftype.s   = GetIni("Type", section.s) 
      fcat.s    = GetIni("Category", section.s) 
      fcoll.s   = GetIni("Collection", section.s) 
      fdisp.s   = GetIni("Display", section.s) 
    section.s   = "Trademark" 
      tmark.s   = GetIni("TradeMark", section.s) 
    section.s   = "X-Extensions" 
      tlink.s   = GetIni("TradeMarkLink", section.s) 
    section.s   = "Depend" 
      fid1.s    = GetIni("id0", section.s) 
      fid2.s    = GetIni("id1", section.s) 
      fid3.s    = GetIni("id2", section.s) 
      fid4.s    = GetIni("id3", section.s) 
      fid5.s    = GetIni("id4", section.s) 

  DeleteFile("C:\iCat2\content.ini") 
  
  EndIf 

EndProcedure 

; API procedure for INI file reading 

Procedure.s GetIni(key.s, section.s)                                            ; Procedure returns a string 

  Empty.s = ""                                                                   ; Default value if nothing found 
  ReturnSpace.s = Space(255)                                                     ; Make sure the variable has plenty of room 
  IniData = GetPrivateProfileString_(section.s, key.s, Empty.s, @ReturnSpace.s, 255, "C:\iCat2\content.ini") 
  
  ProcedureReturn ReturnSpace.s                                                ; Return the data to the calling line 

EndProcedure 

DataSection 
folder: IncludeBinary "..\..\Graphics\Gfx\Folder.ico" 
  drive:  IncludeBinary "..\..\Graphics\Gfx\Disk.ico" 
  imail:  IncludeBinary "..\..\Graphics\Gfx\Mail.ico" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
