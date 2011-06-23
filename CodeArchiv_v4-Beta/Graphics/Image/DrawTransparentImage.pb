; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=717&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 22. April 2003
; OS: Windows
; Demo: No


;Images transparent anzeigen via (API)ImageList 
;nach einer Vorlage von Justin aus dem englischen Forum 
; 
;Es lassen sich nat�rlich mehrere Images in eine Imagelist einf�gen, 
;allerdings m�ssen diese in Einheitsgr��e vorhanden sein. 
;Desweiteren macht es Sinn die API zu studieren, da es noch 
;weitere interessante Flags gibt. 
; 
;PS: Dies ist nur ein simples Beispiel, das zwar �bersichtlich aber 
;daf�r in der Geschwindigkeit etwas eingeschr�nkt ist. 
;K�nnt ihr ja den eigenen Bed�rfnissen anpassen. 


Procedure DrawTransparentImage(outputDC,image,x,y,transcolor) 
  id=ImageID(image) 
  imglist=ImageList_Create_(ImageWidth(image),ImageHeight(image),#ILC_COLORDDB|#ILC_MASK,1,0) 
  ImageList_AddMasked_(imglist,id,transcolor) 
  ImageList_Draw_(imglist,0,outputDC,x,y,#ILD_TRANSPARENT) 
  ImageList_Destroy_(imglist) 
EndProcedure 

Procedure MyWindowCallback(hwnd,msg,wparam,lparam) 
  Result = #PB_ProcessPureBasicEvents 
  Select msg 
    Case #WM_PAINT 
      outputDC=StartDrawing(WindowOutput(0)) 
        DrawImage(ImageID(1),0,0) ;<-Hintergrund zeichnen 
        DrawTransparentImage(outputDC,0,0,0,RGB(255,0,255)) ;<-Transparente Farbe beachten 
      StopDrawing() 
  EndSelect 
  ProcedureReturn Result 
EndProcedure 


OpenWindow(0,0,0,400,300,"Transparent Image",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 

LoadImage(0,"..\Gfx\Geebee2.bmp") ;<-Pfad/Image bitte anpassen 
ResizeImage(0,400,300)            ;<-Auf Fenstergr��e anpassen 

;Hintergrund erstellen 
CreateImage(1,400,300) 
StartDrawing(ImageOutput(1)) 
  For c=0 To 299 
    FrontColor(RGB(c/1.5,0,c/1.5)) 
    Line(0, c,400, 1) 
  Next 
StopDrawing() 

SetWindowCallback(@MyWindowCallback()) 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
