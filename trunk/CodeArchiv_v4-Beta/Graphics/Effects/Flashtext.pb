; German forum: 
; Author: Rings + Ses007 (updated for PB4.00 by blbltheworm)
; Date: 23. July 2002
; OS: Windows
; Demo: Yes


Procedure FlashText(Text.s,XPos,YPos,FontName.s,Fontsize,DelayTime, FontColour)

LoadFont(1, FontName, Fontsize)
 
For i=1 To 255 Step 3
   StartDrawing(ScreenOutput())
   DrawingMode(1)
   DrawingFont(FontID(1))
   FrontColor(RGB((Red(FontColour)/255*i),(Green(FontColour)/255*i),(Blue(FontColour)/255*i)))
   DrawText(XPos,YPos,Text)
   StopDrawing()
   FlipBuffers()
   If IsScreenActive()
     ClearScreen(RGB(0,0,0))
   EndIf
  Delay(1)
Next i
Delay(DelayTime)
 
 
For i=255 To 1 Step -6
 
   StartDrawing(ScreenOutput())
   DrawingMode(1)
   DrawingFont(FontID(1))
   FrontColor(RGB((Red(FontColour)/255*i),(Green(FontColour)/255*i),(Blue(FontColour)/255*i)))
   DrawText(XPos,YPos,Text)
   StopDrawing()
   FlipBuffers()
   If IsScreenActive()
     ClearScreen(RGB(0,0,0))
   EndIf

  Delay(1)
Next

FreeFont(1)
EndProcedure


If InitSprite() = 0
MessageRequester("Fehler", "Konnte DirectX nicht finden", 0)
End
EndIf


OpenScreen(800, 600, 16, "Netter Effeckt")

FlashText("It ...", 250, 300, "ARIAL", 20, 2000, RGB(0, 0, 255))

FlashText("... could be ...", 250, 300, "ARIAL", 20, 2000, RGB(0, 255, 255))

FlashText("... done by ...", 250, 300, "ARIAL", 20, 2000, RGB(255, 125, 255))

FlashText("Purebasic", 250, 300, "ARIAL", 30, 3000, RGB(255, 255, 255))

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -