; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3554&highlight=
; Author: Andreas (updated for PB 4.00 by Andre)
; Date: 26. January 2004
; OS: Windows
; Demo: No

Procedure Paste_Clipboard() 
  clipadr = GetClipboardImage(0) 
  If clipadr 
    If GetObject_(clipadr,SizeOf(BITMAP),Bitmap.BITMAP) 
      Debug Bitmap\bmWidth 
      Debug Bitmap\bmHeight 
    EndIf 
  Else 
    MessageRequester("Einfügen","Kein Bild in der Zwischenablage vorhanden",0) 
  EndIf 
EndProcedure 

Paste_Clipboard() 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -