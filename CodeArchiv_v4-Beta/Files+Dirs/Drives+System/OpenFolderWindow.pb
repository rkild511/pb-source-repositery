; http://www.purebasic-lounge.de
; Author: Hroudtwolf
; Date: 17. March 2006
; OS: Windows
; Demo: No

Procedure OpenFolderWindow (Folder.s)
  OpInfo.s="explore"
  ShellExecute_(0,@OpInfo,@Folder,0,0,#SW_SHOW   )
EndProcedure

OpenFolderWindow ("c:")

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -