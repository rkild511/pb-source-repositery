; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6698&highlight=
; Author: ebs
; Date: 24. June 2003
; OS: Windows
; Demo: No

; Changes background image of Windows desktop
Procedure SetWallpaper(FileName.s) 
  SystemParametersInfo_(#SPI_SETDESKWALLPAPER, 0, FileName, #SPIF_UPDATEINIFILE | #SPIF_SENDWININICHANGE) 
EndProcedure 

WPFileName.s = OpenFileRequester("Select Wallpaper image", "*.bmp", "Bitmap Files (*.bmp)|*.bmp|All Files (*.*)|*.*", 1, 0) 
If WPFileName <> "" 
  SetWallpaper(WPFileName) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
