; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2329
; Author: Leo (updated for PB 4.00 by Andre)
; Date: 06. March 2005
; OS: Windows
; Demo: Yes


; Getting sprite data from a DataSection instead of loading/including image files
; Sprite-Daten aus einer Data-Sektion lesen, anstelle Bilddateien zu lasen oder einzubinden

;############################################################################# 
;############################################################################# 
;Procedure!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
;############################################################################# 
;############################################################################# 
Procedure GetSpriteFromData(id,*ptr,Zoom) 
    Enumeration 
        #BLA 
        #BLU 
        #GRE 
        #ROT 
        #GRA 
    EndEnumeration 
    *a.LONG = *ptr 
    Breite = *a\l 
    *a + 4 
    Hoehe = *a\l 
    *a + 4 
    ; Zoom = *a\l 
    ; *a + 4 
    ret = CreateSprite(id,Breite*Zoom+Zoom,Hoehe*Zoom+Zoom) 
    StartDrawing(SpriteOutput(id)) 
    For Y = 0 To Hoehe 
        For X = 0 To Breite 
            Select *a\l 
                Case 0 : Color = RGB(0,0,0)       ;Schwarz 
                Case 1 : Color = RGB(0,0,255)     ;Blau 
                Case 2 : Color = RGB(0,255,0)     ;Grün 
                Case 3 : Color = RGB(255,0,0)     ;Rot 
                Case 4 : Color = RGB(128,128,128) ;Grau 
                ;Farben müssen noch erweitert werden... 
            EndSelect 
            Box(X*Zoom,Y*Zoom,Zoom,Zoom,Color) 
            *a + 4 
        Next 
    Next 
    StopDrawing() 
    ProcedureReturn ret 
EndProcedure 

;############################################################################# 
;############################################################################# 
;Beispiel!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
;############################################################################# 
;############################################################################# 
InitSprite() 
InitKeyboard() 

ExamineDesktops()
ScrWidth = DesktopWidth(0) : ScrHeight = DesktopHeight(0)
;#ScrWidth=1024:#ScrHeight=768 
OpenScreen(ScrWidth,ScrHeight,32,"Bild ohne externe Dateien!") 

GetSpriteFromData(0,?Bild1,5) 
GetSpriteFromData(1,?Bild2,30) 

Repeat 
    ExamineKeyboard() 
    ClearScreen(RGB(0,0,0))
    
    If KeyboardPushed(1) 
        Quit = #True 
    EndIf 
    
    For X = 0 To ScrWidth/SpriteWidth(0) 
        For Y = 0 To ScrHeight/SpriteHeight(0) 
            DisplaySprite(0,X*SpriteWidth(0),Y*SpriteHeight(0)) 
        Next 
    Next 
    DisplaySprite(1,ScrWidth/2-SpriteWidth(1)/2,ScrHeight/2-SpriteHeight(1)/2) 
    
    FlipBuffers() 
Until Quit = #True 

DataSection 
Bild1: 
Data.l 9,8 ;Breite,Hoehe 
Data.l 1,1,1,1,1,1,1,1,1,1 
Data.l 1,1,1,1,0,0,1,1,1,1 
Data.l 1,1,1,0,0,0,0,1,1,1 
Data.l 1,1,0,0,0,0,0,0,1,1 
Data.l 1,0,0,0,2,2,0,0,0,1 
Data.l 1,1,0,0,0,0,0,0,1,1 
Data.l 1,1,1,0,0,0,0,1,1,1 
Data.l 1,1,1,1,0,0,1,1,1,1 
Data.l 1,1,1,1,1,1,1,1,1,1 
Bild2: 
Data.l 9,8 ;Breite,Hoehe 
Data.l 4,4,4,4,4,4,4,4,4,4 
Data.l 4,1,1,1,1,1,1,1,1,4 
Data.l 4,1,1,0,3,3,0,1,1,4 
Data.l 4,1,0,0,3,3,0,0,1,4 
Data.l 4,1,3,3,3,3,3,3,1,4 
Data.l 4,1,0,0,3,3,0,0,1,4 
Data.l 4,1,1,0,3,3,0,1,1,4 
Data.l 4,1,1,1,1,1,1,1,1,4 
Data.l 4,4,4,4,4,4,4,4,4,4 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -