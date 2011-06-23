; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2480&highlight=
; Author: bingo
; Date: 07. October 2003
; OS: Windows
; Demo: No

; Check for a medium in a drive, without getting the requester "Please insert...."

Root$="a:\"         ; Root Directory NUR mit "\" 
VNB$=Space(100)     ; Volume Name Buffer 
VNS=100             ; Volume Name Size 
VSN=0               ; Volume Serial Number (Hex) 
MCL=0               ; Max.File Name Len 
FSF=0               ; File System Flags 
FSNB$=Space(100)    ; File System Name Buffer (FAT/NTFS usw) 
FSNS=100            ; File System Name BufferSize 

GetVolumeInformation_(@Root$,@VNB$,VNS,@VSN,@MCL,@FSF,@FSNB$,FSNS) 
; Man kann die Variablen auswerten (interessant ist die Volumen Serialnumber,
; mit der man viel mehr machen könnte !).
; Den Laufwerkstyp kann man mit GetDriveType ermitteln ...
          
Debug VNB$ 
Debug Hex(VSN)   ; give 0, if there is no disk

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
