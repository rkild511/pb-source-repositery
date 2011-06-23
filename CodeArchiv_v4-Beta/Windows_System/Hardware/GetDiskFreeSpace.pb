; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8950&highlight=
; Author: Freak (based on code by High Key)
; Date: 31. December 2003
; OS: Windows
; Demo: No


Structure int64 
  Long1.l 
  Long2.l 
EndStructure 

drive$ = "c:\" 

; this prevents the 'please insert drive' requester. 
; GetDiskFreeSpaceEx_() will just return 0 if the drive is not avaiable, 
; without a prompt to the user: 
SetErrorMode_(#SEM_FAILCRITICALERRORS) 
                                        

If GetDiskFreeSpaceEx_(@drive$, BytesFreeToCaller.int64, TotalBytes.int64, TotalFreeBytes.int64) = 0 
  MessageRequester("","Drive not ready!",0) 
  End 
EndIf 

; reset the error behaviour 
SetErrorMode_(0) 

; calculate sizes in mb. 
TotalMB = ((TotalBytes\Long1 >> 20) & $FFF) | (TotalBytes\Long2 << 12) 
FreeMB = ((TotalFreeBytes\Long1 >> 20) & $FFF) | (TotalFreeBytes\Long2 << 12) 

Debug "Disk: "+drive$ 
Debug "Size: "+Str(TotalMB)+" Mb" 
Debug "Free: "+Str(FreeMB)+" Mb" 

End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
