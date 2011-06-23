; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1895&highlight=
; Author: DataMiner (updated for PB 4.00 by Andre)
; Date: 05. February 2005
; OS: Windows
; Demo: No


Define.l Serial, type, i 
Define.s Lfwrk, FileSystem, VolName 

For i=65 To 90 
  Lfwrk=Chr(i)+":\" 
  type =GetDriveType_(Lfwrk) 
  FileSystem = Space(256) 
  VolName= Space(256) 
  GetVolumeInformation_(@Lfwrk, @VolName, 255, @Serial, 0, 0, @FileSystem, 255) 
  Select type 
    Case 0 
      Debug Lfwrk+" The drive type cannot be determined." 
    Case 2 
      Debug Lfwrk+" = DRIVE_REMOVABLE, "+VolName+", "+FileSystem+", "+  Hex(Serial) 
    Case 3 
      Debug Lfwrk+" = DRIVE_FIXED, "+VolName+", "+FileSystem+", "+  Hex(Serial) 
    Case 4 
      Debug Lfwrk+" = DRIVE_REMOTE, "+VolName+", "+FileSystem+", "+  Hex(Serial) 
    Case 5 
      Debug Lfwrk+" = DRIVE_CDROM, "+VolName+", "+FileSystem+", "+  Hex(Serial) 
    Case 6 
      Debug Lfwrk+" =  DRIVE_RAMDISK,   "+VolName+", "+FileSystem+", "+  Hex(Serial) 
  EndSelect 
Next 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -