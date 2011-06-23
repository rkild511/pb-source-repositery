; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2165&highlight=
; Author: RayMan1970 (updated for PB4.00 by blbltheworm)
; Date: 01. September 2003
; OS: Windows
; Demo: Yes

; ************************************************************** 
; ****    Windows Uhr (c) 2003 by www.menzer-software.de   ***** 
; ************************************************************** 

Procedure BoxLine(X_Von,Y_Von,X_bis,Y_bis,Rot,Gruen,Blau) ; **  Eine Box nur aus Linien anzeigen ** 

LineXY(X_Von,Y_Von,X_bis,Y_Von,RGB( Rot,Gruen,Blau ) )  ; Line oben 
LineXY(X_bis,Y_Von,X_bis,Y_bis,RGB( Rot,Gruen,Blau ) )  ; Line rechts 
LineXY(X_Von,Y_bis,X_bis,Y_bis,RGB( Rot,Gruen,Blau ) )  ; Line unten 
LineXY(X_Von,Y_Von,X_Von,Y_bis,RGB( Rot,Gruen,Blau ) )  ; Line links 

EndProcedure ; ************************************************************************************ 



Procedure Uhr_Zeigen() ; ****************************** Zeit zeigen ******************************** 

LoadFont(1,"Arial",20) ;          Die Schrift 
StartDrawing( WindowOutput(0) ) 

  Box(1, 1, 130, 33 , RGB(163,142,178) )  ; Ausgefüllte Box anzeigen  

  BoxLine(0,0,131,34,255,0,0) ; Eine Box nur aus Linien anzeigen 
  DrawingFont(FontID(1))  
  DrawingMode(1) ;                               Setzt den Text-Hintergrund auf transparent 
  FrontColor(RGB(255,255,125)) ;                      Text Farbe 
  DrawText(4,0,FormatDate("%hh:%ii:%ss", Date() )) ; Text zeigen 
      
StopDrawing() 
  
EndProcedure ; ************************************************************************************* 




OpenWindow(0,0,0,132,35,"Rays Uhr", #PB_Window_ScreenCentered | #WS_POPUP) ; Fenster ohne alles öffnen * 
    
Repeat ; --------------------------  Hauptschleife --------------------------------------------- 

WindowEvent=WindowEvent() 

If zeit$<>FormatDate("%ss", Date() )  ; ---- Aktuelle Zeit zeigen ---- 
zeit$=FormatDate("%ss", Date() ) 
Uhr_Zeigen() 
EndIf ; ------------------------------------------------------------- 


If WindowEvent=#WM_LBUTTONDOWN ; *********** Fenster An/Aus ***************** 
Fenster_an_aus+1 

If Fenster_an_aus=1 ; ----- AN ----- 
OpenWindow(0,WindowX(0),WindowY(0),132,35,"Rays Uhr", #PB_Window_SystemMenu); Fenster mit Rahmen öffnen * 
Uhr_Zeigen() 
EndIf 

If Fenster_an_aus=2 ; ----- AUS ----- 
OpenWindow(0,WindowX(0),WindowY(0),132,35,"Rays Uhr", #WS_POPUP) ; Fenster ohne alles öffnen * 
Fenster_an_aus=0 
Uhr_Zeigen() 
EndIf 


EndIf ; ********************************************************************* 


Delay(50) 
Until WindowEvent=#PB_Event_CloseWindow ; ----------- Ende Hauptschleife ----------------------- 

CloseWindow(0)  
End ; Programm Ende

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
