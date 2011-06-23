; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2766
; Author: freak (updated to PB4 by ste123)
; Date: 08. November 2003
; OS: Windows
; Demo: Yes

; beispiel 
hBitmap = GetClipboardImage( #PB_Any ) 
If hBitmap
  ;RegisterBitmap(0, hBitmap) 
  SaveImage(hBitmap, "C:\test.bmp") 
Else
  Debug "Currently there is no image in the clipboard!"
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
