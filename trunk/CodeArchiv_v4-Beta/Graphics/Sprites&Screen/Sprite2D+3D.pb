; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=448&start=10
; Author: Torsten (updated for PB4.00 by blbltheworm)
; Date: 21. April 2003
; OS: Windows
; Demo: Yes


;IncludeFile "Structuren.pbi" 
Structure GeoPOINT 
  x.l 
  y.l 
  z.l 
EndStructure 

Structure TRIANGLE 
  
  ;P2    P3 
  ;+-----+ 
  ;| 
  ;| 
  ;| 
  ;+ 
  ;P1 
  
  Point1.GeoPOINT 
  Point2.GeoPOINT 
  Point3.GeoPOINT 
EndStructure 


;IncludeFile "Konstanten.pbi" 
;Allgemein 
#Window           = 1 
#Texture          = 2 
#Texture3D        = 3 

;Keycodes 
#Up         = 38 
#Down       = 40 
#Left       = 37 
#Right      = 39 


;IncludeFile "Variablen.pbi" 
Global Quit.l 
Event.l 

;Dreieck erzeugen 
MeinDreieck.TRIANGLE 

MeinDreieck\Point1\x = 100 
MeinDreieck\Point1\y = 200 
MeinDreieck\Point1\z = 10 

MeinDreieck\Point2\x = 20 
MeinDreieck\Point2\y = 30 
MeinDreieck\Point2\z = 10 

MeinDreieck\Point3\x = 200 
MeinDreieck\Point3\y = 22 
MeinDreieck\Point3\z = 10 

;IncludeFile "Proceduren.pbi" 
Procedure.l InitTexture(Fenster.l) 
   
  If InitSprite() <> 0 
    If OpenWindowedScreen(WindowID(Fenster), 0, 0, WindowWidth(Fenster), WindowHeight(Fenster), 0, 0, 0) <> 0 
      TransparentSpriteColor(-1,RGB(255,255,255)) 

      UsePNGImageDecoder() 
      LoadSprite(#Texture, "..\gfx\PureBasicLogoNew.png", #PB_Sprite_Texture)      
            
      If InitSprite3D() <> 0        
        CreateSprite3D(#Texture3D, #Texture) 
        ClearScreen(RGB(255,255,255)) 
      Else 
        ProcedureReturn #False 
      EndIf 
    Else 
      ProcedureReturn #False 
    EndIf 
  Else 
    ProcedureReturn #False 
  EndIf 
  
  ProcedureReturn #True 
  
EndProcedure 

Procedure RebuildScreen(DreieckPointer.l) 
  
  Protected *Dreieck.TRIANGLE 

  *Dreieck = DreieckPointer 

  ; x1         x2 
  ;   --------- 
  ;   |      /| 
  ;   |    /  |      
  ;   |  /    | 
  ;   |/      | 
  ;   --------- 
  ; x4         x3 
  
  ClearScreen(RGB(255,255,255)) 
  
  Start3D() 
    Sprite3DQuality(1)    
    TransformSprite3D(#Texture3D, *Dreieck\Point2\x, *Dreieck\Point2\y, *Dreieck\Point3\x, *Dreieck\Point3\y, *Dreieck\Point3\x, *Dreieck\Point3\y, *Dreieck\Point1\x, *Dreieck\Point1\y) 
    DisplaySprite3D(#Texture3D, 0, 0, 255) 
  Stop3D() 
  
  FlipBuffers() 
  
EndProcedure 

Procedure Triangle(DreieckPointer.l) 
  
  Protected *Dreieck.TRIANGLE 
  
  ;P2    P3 
  ;+-----+ 
  ;| 
  ;| 
  ;| 
  ;+ 
  ;P1 
  
    
  *Dreieck = DreieckPointer 
  
  StartDrawing(ScreenOutput()) 
    LineXY(*Dreieck\Point1\x, *Dreieck\Point1\y, *Dreieck\Point2\x, *Dreieck\Point2\y) 
    LineXY(*Dreieck\Point2\x, *Dreieck\Point2\y, *Dreieck\Point3\x, *Dreieck\Point3\y) 
    LineXY(*Dreieck\Point3\x, *Dreieck\Point3\y, *Dreieck\Point1\x, *Dreieck\Point1\y) 
  StopDrawing() 
  
EndProcedure 


If OpenWindow(#Window,0,0,320,240,"Window#0",#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_SizeGadget)=0 
  MessageRequester("Fehler","Das Fenster konnte nicht erzeugt werden!",#MB_SETFOREGROUND|#PB_MessageRequester_Ok|#MB_ICONEXCLAMATION|#MB_DEFBUTTON1) 
  End 
EndIf 
  
If CreateGadgetList(WindowID(#Window)) <> 0 
  ;Hier die Gadgets 
Else 
  MessageRequester("Fehler","Das Fenster konnte nicht erzeugt werden!",#MB_SETFOREGROUND|#PB_MessageRequester_Ok|#MB_ICONEXCLAMATION|#MB_DEFBUTTON1) 
  End 
EndIf 

If InitTexture(#Window) = #False 
  MessageRequester("Fehler","Texture Engine konnte nicht gestartet werden!",#MB_SETFOREGROUND|#PB_MessageRequester_Ok|#MB_ICONEXCLAMATION|#MB_DEFBUTTON1) 
  End 
EndIf 

Triangle(@MeinDreieck) 
RebuildScreen(@MeinDreieck) 

Repeat 

   Event = WaitWindowEvent() 
    
   Select Event 
      Case #PB_Event_Gadget 
      
        Select EventGadget() 
        EndSelect 
          
      Case #PB_Event_CloseWindow 
        Quit = #True 
        
      Case #WM_PAINT 
        RebuildScreen(@MeinDreieck) 
        
      Case #WM_KEYDOWN 
        
        Select EventwParam() 
        
          Case #Down 
            MeinDreieck\Point2\y = MeinDreieck\Point2\y + 6 
            MeinDreieck\Point3\y = MeinDreieck\Point3\y + 6 
            RebuildScreen(@MeinDreieck) 
          
          Case #Up 
            MeinDreieck\Point2\y = MeinDreieck\Point2\y - 6 
            MeinDreieck\Point3\y = MeinDreieck\Point3\y - 6 
            RebuildScreen(@MeinDreieck) 
          
          Case #Left 
            MeinDreieck\Point2\x = MeinDreieck\Point2\x - 6 
            MeinDreieck\Point3\x = MeinDreieck\Point3\x - 6 
            RebuildScreen(@MeinDreieck) 
                      
          Case #Right 
            MeinDreieck\Point2\x = MeinDreieck\Point2\x + 6 
            MeinDreieck\Point3\x = MeinDreieck\Point3\x + 6            
            RebuildScreen(@MeinDreieck)            
                  
        EndSelect 
        
   EndSelect 

Until Quit 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
