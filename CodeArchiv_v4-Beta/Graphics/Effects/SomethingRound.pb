; German forum: http://www.purebasic.fr/german/viewtopic.php?t=3626&highlight=
; Author: benny (updated for PB 4.00 by Andre)
; Date: 09. June 2005
; OS: Windows
; Demo: Yes


; [oldDmoFX] was rundes. 

; was rundes. 
; a conversion of an old demoFX (author unknown) 
; by benny|weltenkonstrukteur.de 
; o8.o6.o5 

winTitle.s  = "was rundes." 
#LOOPTIME   = 1000/14  ; 14 frames per 1000ms (1second) 

hwnd.l = OpenWindow(0, 0,0, 320, 240, winTitle.s, #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
If hwnd 
  If InitSprite() 
    If OpenWindowedScreen(hwnd, 0, 0, 320, 240, 0, 0, 0) 
      
        Dim px.f(15) 
        Dim py.f(15) 
        
        Repeat    
          
          Select WindowEvent() 
            Case #PB_Event_CloseWindow 
              Quit = #True 
          EndSelect 
          
          FlipBuffers() 
          If IsScreenActive()  
                ClearScreen(RGB(0,0,0))
                StartDrawing(ScreenOutput())    
                px(0) = 160+8*Cos(a.f) 
                py(0) = 120+8*Sin(a.f) 
                For i=1 To 14 
                  px(i-1) = px (i) 
                  py(i-1) = py (i) 
                  px(i) = 160+8*Cos (a.f * (1+i*0.1)) 
                  py(i) = 120+8*Sin (a.f * (1+i*0.1)) 
                  Circle(px(i-1), py(i-1), 100-i*8, RGB(0,0,0)) 
                  Circle(px(i), py(i), 110-i*8, RGB(255,255,255)) 
                Next i 
                a + 0.4 
                StopDrawing() 
          EndIf 
          
          ; Run Program at a constant rate  
          While ( ElapsedMilliseconds()-LoopTimer )<#LOOPTIME : Delay(1) : Wend  
          LoopTimer = ElapsedMilliseconds() 
        Until Quit = #True 
        
    EndIf 
  EndIf 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger