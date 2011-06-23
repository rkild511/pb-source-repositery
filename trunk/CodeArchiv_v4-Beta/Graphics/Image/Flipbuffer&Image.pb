; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=788&start=10&postdays=0&postorder=asc&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 29. April 2003
; OS: Windows
; Demo: Yes

If InitSprite() = 0                                              
  MessageRequester("Fehler","Konnte DirectX nicht finden",#MB_ICONERROR) 
  End        
EndIf    

If OpenScreen(320,200,16,"indy") = 0 
  MessageRequester("Fehler",  "openscreen geht nich", #MB_ICONERROR) 
  End 
EndIf 

If LoadImage(1,"..\Gfx\PureBasic.bmp" ) = 0 
  CloseScreen() 
  MessageRequester("Fehler", "Konnte Bild nicht laden !", #MB_ICONERROR) 
  End 
EndIf 

StartDrawing(ScreenOutput()) 
  Box(125, 100, 50, 50, RGB(255, 0, 0)) 
  DrawImage(ImageID(1),10,10) 
StopDrawing() 

FlipBuffers() 

Delay(4000) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
