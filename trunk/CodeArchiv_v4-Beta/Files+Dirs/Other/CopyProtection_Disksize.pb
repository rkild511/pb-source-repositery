; English forum:
; Author: Unknown
; Date: 11. March 2003
; OS: Windows
; Demo: No

If GetDiskFreeSpace_("c:\",lpSectorsPerCluster.l,lpBytesPerSector,lpNumberOfFreeClusters,lpTotalNumberOfClusters)=0
  ErrorBuffer$ = Space(1024)
  FormatMessage_(#FORMAT_MESSAGE_FROM_SYSTEM, 0, GetLastError_(), 0, ErrorBuffer$, Len(ErrorBuffer$), 0)
  MessageRequester("Error", "GetFreeDiskSpace_() failed:"+Chr(10)+Chr(10)+ErrorBuffer$, 0)
Else
  Debug "Error!"
EndIf

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -