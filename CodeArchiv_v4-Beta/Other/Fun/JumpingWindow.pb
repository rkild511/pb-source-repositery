; German forum: http://www.purebasicforums.com/german/viewtopic.php?t=2890&highlight= 
; Author: Konne (updated for PB 4.00 by edel)
; Date: 08. April 2005 
; OS: Windows 
; Demo: No 


; Make a physical correct jumping of a window... 
; Lustige Procedure, um ein Fenster physikalisch korrekt springen zu lassen 

  
 ;              _________Physik_Fenster___________ 
  ;            |                                  | 
   ;           |Programmierer: Konstantin *****   | 
    ;          |Firma:         KoMaNi             | 
  ;            |                                  |    
  ;            |--------|Beschreibung|------------|  
     ;         |Ist eine lustige Procedure um ein | 
      ;        |Fenster springen zu lassen        | 
        ;      |__________________________________| 


Procedure PhysikFenster() 
  
  Protected Anziehung   ;Gibt die Geschwindigkeit der Anziehung an 
  Protected Huepfen     ;Gibt die Hüpfkraft an 
  Protected Abweichung  ;Gibt die Geschwindigkeit der Abweichung an 
  Protected Abweichung2 ;Gibt die Seitliche Abweichung nach rechts + | links- an 
  Protected Anziehung2  ;Gibt die Anziehung nach unten + | oben- an 
  Protected Geschwindigkeit  ;Gibt an wie oft das Fenster verschoben wird 
  Protected WHoehe      ;Bild Hoehe 
  Protected WBreite     ;Bildbreite 
  Protected Breite      ;Breiten koordinaten start punkt 
  Protected Hoehe       ;Gibt die Hoehe des Fensters aus (zB zum Debugen) 
  Protected oldHoehe    ;Brechnung der max. Hoehe 
  Protected AufHoehe    ;Auflösung Hoehe 
  Protected AufBreite   ;Auflösung Breite 
  Protected i           ;Zähl Variable 
  Protected v           ;Zähl Variable 
  Protected c           ;Zähl Variable 
  Protected l           ;Zähl Variable 
  Protected a           ;Zähl Variable 
  Protected x           ;Zähl Variable 
  
  
  ;______Hier_können_die_einzelnen_Faktoren_geändert_werden___________________________________________ 
  
  Anziehung      =10   ;Je mehr desto schwächer 
  Huepfen        =15  ;Je mehr deto höher 
  Abweichung     =1   ;weniger is mehr 
  
  
  ;______Änderungen_hier_können_zu_einem_Ruckeln_führen_______________________________________________ 
  
  Abweichung2    =5   ;5 ist gut, mehr is mehr 
  Anziehung2     =3   ;3 ist gut 
  Geschwindigkeit=10  ;Bild refresh zeit 
  
  
  
  ;______Fenstereinstellungen_________________________________________________________________________ 
  
  WHoehe       =369  ;Hoehe des Bildes 
  WBreite      =548  ;Breite des Bildes 
  Breite       =100  ;Je mehr desto weiter rechts 
  
  ;___________________________________________________________________________________________________ 
  
  
  
  
  ;UseJPEGImageDecoder()  ;Um JPGs einbinden zu können 
  
  If OpenWindow(1,Breite,0, WBreite, WHoehe, "Physik", #PB_Window_Invisible|#PB_Window_SystemMenu) ;Fenster erstellen 
    
    
    
    ;SkinWin(WindowID(1),CatchImage(0,?SkinPicture))    ;Fenster erstellen 
    
    
    HideWindow(1,0)   ;Fenster anzeigen 
  EndIf 
  
  
  i=1            
  v=0 
  oldHoehe=8000          ;NUR zur höhenmessung benötigt 
  
  ExamineDesktops()   ;Die Auflösung auslesen um das Bild dynamisch zur Auflösung springen zu lassen 
  
  AufHoehe=DesktopHeight(0)  ;Hoehe ermitteln 
  AufBreite=DesktopWidth(0)  ;Breite ermitteln 
  
  Repeat            ;Hauptschleife öffnen 
    e = WaitWindowEvent(Geschwindigkeit) 
    
    If Not e 
      oldticks=ElapsedMilliseconds()  ;oldticks dem tickcount gleichstellen 
      
      
      If c=Abweichung And l=0       ;Seitliche Abweichung 
        Breite=Breite+Abweichung2      
        c=0 
      EndIf 
      
      If c=Abweichung And l=1 
        Breite=Breite-Abweichung2 
        c=0 
      EndIf 
      
      If v<3 
        c=c+1 
      EndIf 
      
      If Breite>AufBreite-WBreite 
        l=1 
      EndIf 
      
      If Breite<0 
        l=0 
      EndIf 
      
      ;________________________________________________________________ 
      
      
      If x=Anziehung  ;Berechnet die Anziehung 
        a=a+Anziehung2 
        x=0 
      EndIf 
      
      x=x+1 
      
      
      If v=0            ;lässt den Gegenstand fallen 
        Hoehe=Hoehe+a 
      EndIf 
      
      
      If  Hoehe=>AufHoehe-30-WHoehe And v=0  ;Wenn es den Boden erreicht... 
        v=1 
        a=0 
        oldHoehe=AufHoehe+800 
        y=0 
      EndIf 
      
      If v=1                                ;Aufspringen 
        If Huepfen/i> 1.5 
          Hoehe=Hoehe-Huepfen+a+i*2.5+1 
          
          If Hoehe>AufHoehe-30-WHoehe 
            i=i+1 
            a=0 
            oldHoehe=AufHoehe+800 
            y=0 
          EndIf 
          
        Else 
          v=2 
        EndIf 
      EndIf 
      
      
      If v=2 And Hoehe>AufHoehe-WHoehe-30     ;wenn es auf dem Boden ist... 
        v=3 
        Hoehe=AufHoehe+60-WHoehe 
        ResizeWindow(1,Breite, Hoehe,#PB_Ignore,#PB_Ignore) 
        Delay(500) 
      EndIf 
      
      If v=3                    ;Bild runterziehen ... 
        s=s+2 
        Hoehe=Hoehe+s 
        Delay(10) 
        If Hoehe > AufHoehe+200 
          v=4 
          a=0 
        EndIf 
      EndIf 
      
      If v=4                     ;Bild hochspringen lassen... 
        Hoehe=Hoehe-50 
        Delay(10) 
      EndIf 
      
      If v=4 And Hoehe<0           ;Wenn es oben ist die ganze sache nomal wiederholen 
        i=1 
        v=0 
        a=0 
      EndIf 
      
      ;_________Höchster Punkt ausrechnen (nicht nötig)_____________________________________ 
      
      
      ;Höchsten Punkt ausrechnen 
      
      If Hoehe < oldHoehe 
        oldHoehe = Hoehe 
        
        ;  If y=1 
        
      EndIf 
      
      ;Höchsten Punkt debugen 
      
      If Hoehe > oldhoehe And y=0 
        Debug(oldHoehe)  
        y=y+1 
        
      EndIf 
      
      
      
      ;________________________________________________________________- 
      
      
      ResizeWindow(1,Breite, Hoehe,#PB_Ignore,#PB_Ignore)    ;Fenster an die angegebenen Koordinaten bewegen 
      
      
      
      ;___________________________________________________________________________________________ 
      
    EndIf 
    
  ForEver 
EndProcedure 

physikfenster()   ;Ruft das Programm auf 


; DataSection 
; SkinPicture: 
; IncludeBinary "Bilder\bg1.jpg" 
; EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -