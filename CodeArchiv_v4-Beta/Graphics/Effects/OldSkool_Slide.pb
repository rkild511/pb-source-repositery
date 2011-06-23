; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6770&highlight=
; Author: fenix (updated for PB4.00 by blbltheworm)
; Date: 30. June 2003
; OS: Windows
; Demo: Yes


; Insert your own path/file name in the include section at the end of the code
; Fügen Sie Ihren eigenen Pfad/Dateinamen in der Include-Sektion am Ende des Codes ein

; SLIDE 
; ----- 
; 
; oldskool fx 
; 
; 29.06.2003 
; 
; coding: Fenix 


#WIDTH = 1024 
#HEIGHT = 768 

#False = 0 

#TOP2BOTTOM = 1                                                   ; used as parameter for the fx-procedures 
#BOTTOM2TOP = 2 


Procedure SlideIn(lType.l)                              ; lType selects fx 
; if Fred includes variable steps to for/next, we could do this in one loop 
; Hi Fred ;) 

   Select lType 
      Case #TOP2BOTTOM 
         lStartY.l = 0 
         lEndY.l = #HEIGHT 
         For lCounter.l = lStartY To lEndY                              ; slide draws the pic line by line 
            FlipBuffers()                                                ; and takes the actual line to draw to the rest of the screen 
            ClipSprite(1, 0, lCounter, #WIDTH, 1) 
            For lCounterY.l = lCounter To lEndY                         ; loop from actual Y position to the bottom of the screen 
               DisplaySprite(1, 0, lCounterY) 
            Next 
         Next 
      Case #BOTTOM2TOP 
         lStartY.l = #HEIGHT 
         lEndY.l = 0 
         For lCounter.l = lStartY To lEndY Step -1                      ; slide draws the pic line by line 
            FlipBuffers()                                                ; and takes the actual to draw to the rest of the screen 
            ClipSprite(1, 0, lCounter, #WIDTH, 1) 
            For lCounterY.l = lCounter To lEndY Step -1                 ; loop from actual Y position to the top of the screen 
               DisplaySprite(1, 0, lCounterY) 
            Next 
         Next 
   EndSelect    
EndProcedure 

Procedure SlideOut(lType.l) 
   Select lType 
      Case #TOP2BOTTOM 
         lStartY.l = 0 
         lEndY.l = #HEIGHT 
         For lCounter.l = lStartY To lEndY                              ; from top to bottom 
            FlipBuffers() 
            GrabSprite(2, 0, lCounter, #WIDTH, 1)                        ; grab the line from screen 
            For lCounterY.l = lCounter To 0 Step -1                     ; go from actual position up to the start of the screen 
               DisplaySprite(2, 0, lCounterY) 
            Next 
         Next 
      Case #BOTTOM2TOP 
         lStartY.l = #HEIGHT 
         lEndY.l = 0 
         For lCounter.l = lStartY To lEndY Step -1                      ; from bottom to top 
            FlipBuffers() 
            GrabSprite(2, 0, lCounter, #WIDTH, 1) 
            For lCounterY.l = lCounter To lStartY                       ; go from actual position down to the end of the screen 
               DisplaySprite(2, 0, lCounterY) 
            Next 
         Next 
   EndSelect 
   ClearScreen(RGB(255,255,255)) 
   FlipBuffers()          
EndProcedure 




MAIN: 
;UseJPEGImageDecoder()                                                            ; or any other imagedecoder, depending on your imageformat 

If InitSprite() = #False                                                         ; needed for our fx 
   MessageRequester("ERROR", "InitSprite() failed", #PB_MessageRequester_Ok) 
   End 
EndIf 
OpenWindow(1,0,0,#WIDTH,#HEIGHT, "oldskool fc",#PB_Window_BorderLess) 
If OpenWindowedScreen(WindowID(1), 0, 0, #WIDTH, #HEIGHT, 0, 0, 0) = #False       ;OpenScreen(#WIDTH, #HEIGHT, 32, "oldskool fx") = #FALSE 
   MessageRequester("ERROR", "OpenScreen() failed", #PB_MessageRequester_Ok) 
   End 
EndIf 
If CatchSprite(1, ?image) = #False                                               ; get our image as sprite 
   MessageRequester("ERROR", "CatchSprite() failed", #PB_MessageRequester_Ok)     ; if failed -> end 
   End 
EndIf 

ClearScreen(RGB(255,255,255))

SlideIn(#TOP2BOTTOM) 
SlideOut(#TOP2BOTTOM) 

FreeSprite(1) 
FreeSprite(2) 
CloseScreen() 
End 


image: 
IncludeBinary "..\Gfx\Map.bmp"
imageEnd: 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; Executable = K:\Pure-Basic\Gradient\Gradient.exe
; DisableDebugger
