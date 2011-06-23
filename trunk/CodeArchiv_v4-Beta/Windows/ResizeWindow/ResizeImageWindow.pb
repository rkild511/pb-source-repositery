; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3265&highlight=
; Author: RayMan1970 (updated for PB3.93 by Andre, updated for PB4.00 by blbltheworm)
; Date: 28. December 2003
; OS: Windows, Linux
; Demo: Yes


; Simple example of resizing an image inside a window, could be improved with
; using Callbacks (realtime-resizing) or better by using ImageGadgets....

; ****************************** Kleines Resize Demo ******************************** 
; **               Code 2003 by Rayman1970 / HP www.menzer-software.de             ** 
; *********************************************************************************** 


; Die Fenster grösse festlegen 
#window_x = 640 
#window_y = 400 
#Fenster = 1 


grafik = 0 ;     0 = Grafik erstellen    /    1 = Grafik laden ( BMP ) 


OpenWindow(#Fenster,0,0,#window_x,#window_y,"Resize Demo für PureBasic" , #PB_Window_ScreenCentered | #PB_Window_MaximizeGadget | #PB_Window_MinimizeGadget | #PB_Window_SizeGadget) 


; --------- Die Grafik erstellen für Image 1 --------------------------------- 
If grafik = 0 
  CreateImage(1, WindowWidth(#Fenster), WindowHeight(#Fenster))               ; Image nr und grösse festlegen 
  StartDrawing( ImageOutput(1) )                               ; Auf das Image malen 
    Box(0,0,WindowWidth(#Fenster),WindowHeight(#Fenster), RGB( 255,255,255 ) )  ; Eine Box 
    Circle( WindowWidth(#Fenster)/2,WindowHeight(#Fenster)/2,100,RGB(255,0,0) ) ; Ein Kreis 
    LineXY(0,0,WindowWidth(#Fenster),WindowHeight(#Fenster), RGB(0,0,255 ) )    ; Line 
    LineXY(0,WindowHeight(#Fenster),WindowWidth(#Fenster),0, RGB(0,0,255 ) )    ; Line 
  StopDrawing()                                               ; Fertig 
EndIf 
; ---------------------------------------------------------------------------- 



; ------- Image Grafik laden ------------------------------------------------- 
If grafik = 1 
  LoadImage(1 , "test.bmp")    
EndIf 
; ---------------------------------------------------------------------------- 


Gosub UpdateImage


; ----------------------------------- Hauptschleife --------------------------------------    
Repeat 

  Event = WaitWindowEvent() 
  If Event = #WM_SIZE Or Event = #WM_PAINT 
    Gosub UpdateImage
  EndIf      
Until Event = #PB_Event_CloseWindow                  ; Programm Ende 
; -------------------------------- Ende Hauptschleife ------------------------------------  


UpdateImage:
  CopyImage( 1, 2 )                                  ; Das Orginale Image Kopieren 
  ResizeImage(2, WindowWidth(#Fenster), WindowHeight(#Fenster) )     ; Die Kopie am Fenster anpassen 
    
  StartDrawing(  WindowOutput(#Fenster) )                    ; Grafik auf das Fenster Starten !! 
  DrawImage(ImageID( 2 ) , 0,0 )                    ; Die Copy vom Image 1 malen 
  StopDrawing()                                      ; Ende Grafik 
Return

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
