; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2216&highlight=
; Author: RayMan1970 (updated for PB4.00 by blbltheworm)
; Date: 05. September 2003
; OS: Windows
; Demo: Yes


; ********************** Fotos heller oder dunkler machen ************************** 
; Code 2003 by Rayman1970 / HP www.menzer-software.de 
; ********************************************************************************** 



#x_window_groesse=640 ; Fenster Größe Breite 
#y_window_groesse=400 ; Fenster Größe Höhe 

#window=0 ; Aktuelles Fenster 

#dunkel_hell=10 ; Schritte für Hell und Dunkel 


; ************************* Bild laden *********************************** 

LoadImage(0,"..\gfx\map.bmp") ; Bild laden 

x_image=ImageWidth(0) ; Image Breite 
y_image=ImageHeight(0) ; Image Höhe 
; ************************************************************************ 

; ************* Hier ist der Speicher für die Pixel ( RGB ) Farben ******************** 
Global Dim rot(x_image,y_image) 
Global Dim gruen(x_image,y_image) 
Global Dim blau(x_image,y_image) 
; ************************************************************************************** 



Procedure Fenster_zeigen(x_image,y_image) ; **************** Das Fenster zeigen ******************** 
OpenWindow(#window,0,0,#x_window_groesse,#y_window_groesse+16,"Fotos hell oder dunkel machen",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
    
CreateGadgetList(WindowID( #window )) ; * Gadget Liste erstellen für Buttons und scrollbarer Bereich * 

ButtonGadget(1,10,10,60,20,"Hell") 
ButtonGadget(2,10,30,60,20,"Dunkel") 

ScrollAreaGadget(0, 80, 0,#x_window_groesse-80,#y_window_groesse, x_image, y_image, 30) 
      
ImageGadget(3, 0, 0, ImageWidth(0), ImageHeight(0), ImageID(0) ) ; Das Bild zeigen 
      
CloseGadgetList() ; ******************************* Ende der Liste ************************************ 

EndProcedure ; *************************************************************************************** 




Fenster_zeigen(x_image,y_image)  

Repeat ; ++++++++++++++++++++++++++++ Hauptschleife +++++++++++++++++++++++++++++++++++ 

Event_windows= WaitWindowEvent() 


Select Event_windows 
Case #PB_Event_Gadget 
  Select EventGadget() 

Case 1 ; ******************************** Bild heller machen **************************************** 
    StartDrawing(ImageOutput(0) )  
    
    For x=0 To x_image ; --------- Pixel Farben speichern ------------- 
    For y=0 To y_image 
    farbe=Point(x,y) 
    rot(x,y)=Red(farbe) 
    gruen(x,y)=Green(farbe) 
    blau(x,y)=Blue(farbe) 
    Next y 
    Next x ; ----------------------------------------------------------- 
    
        
    
    For x=0 To x_image : For y=0 To y_image ; ------------ Neue Farben setzen  --------------- 

    rot=rot(x,y)+#dunkel_hell : If rot>255 : rot=255 : EndIf         ; Rot heller machen 
    gruen=gruen(x,y)+#dunkel_hell : If gruen>255 : gruen=255 : EndIf ; Grün heller machen 
    blau=blau(x,y)+#dunkel_hell : If blau>255 : blau=255 : EndIf     ; Blau heller machen 

    Plot(x,y, RGB(rot,gruen,blau) ) ; Neue Farbe setzen 
    
    Next y : Next x ; ------------------------------------------------------------------------ 
    
    StopDrawing() 
    
    Fenster_zeigen(x_image,y_image) 

; *************************** Ende Bild heller machen ************************************************ 


Case 2 ; ****************************** Bild dunkler machen **************************************** 
    StartDrawing(ImageOutput(0) ) 
    
    For x=0 To x_image ; ---------- Pixel Farben speichern ------------- 
    For y=0 To y_image 
    farbe=Point(x,y) 
    rot(x,y)=Red(farbe) 
    gruen(x,y)=Green(farbe) 
    blau(x,y)=Blue(farbe) 
    Next y 
    Next x ; ---------------------------------------------------------- 
    
      

    For x=0 To x_image : For y=0 To y_image ; ----------- Neue Farben setzen -------------- 

    rot=rot(x,y)-#dunkel_hell : If rot<1 :rot=1 : EndIf           ; Rot dunkel machen 
    gruen=gruen(x,y)-#dunkel_hell : If gruen<1 : gruen=1 : EndIf  ; Grün dunkel machen 
    blau=blau(x,y)-#dunkel_hell : If blau<1 :blau=1 : EndIf       ; Blau dunkel machen 

    Plot(x,y, RGB(rot,gruen,blau) ) ; Neue Farbe setzen 
    
    Next y : Next x ; --------------------------------------------------------------------- 
    
    StopDrawing() 
    
    Fenster_zeigen(x_image,y_image) 

; *********************** Ende Bild dunkler machen ************************************************** 



EndSelect : EndSelect 
    
    
Until Event_windows= #PB_Event_CloseWindow ; +++++++++++++++++ Ende Hauptschleife +++++++++++++++++ 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
