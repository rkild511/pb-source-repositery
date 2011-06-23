; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8851&highlight=
; Author: Num3 (updated for PB4.00 by blbltheworm)
; Date: 23. December 2003
; OS: Windows
; Demo: Yes


;/// Size of cube 
#squarex = 164 
#squarey = 164 

Procedure face(sprite.b,type.b,zoom.b) 
    
  dif=16+#squarex-#squarey 
  
  Select type 
    Case 1 ; ///// square 
      TransformSprite3D(sprite,0,0,#squarex,0,#squarex,#squarey,0,#squarey) 
      
    Case 2 ; ///// left face 
      TransformSprite3D(sprite,0,0,(#squarex-dif)/5,0+dif,(#squarex-dif)/5,#squarey-dif,0,#squarey) 
      
  EndSelect 
  
  
EndProcedure 

If OpenWindow(0,0,0,640,400,"Dungeon",#PB_Window_ScreenCentered) 
  If InitSprite():EndIf : If InitSprite3D() : EndIf 
  InitKeyboard() 
  
  
  
  If OpenWindowedScreen(WindowID(0),0,0,640,480,0,0,0) 
    LoadSprite(1,"..\Gfx\PB.bmp",#PB_Sprite_Texture) ; /// change this to your texture 
    CreateSprite3D(0,1) 
    CreateSprite3D(1,1) 
    ; _startworld()    
    
    ClearScreen(RGB(0,0,0)) 
    Repeat 
      ClearScreen(RGB(0,0,0)) 
      
      Start3D() 
        face(0,1,0) 
        DisplaySprite3D(0,0,50) 
        face(0,2,0) 
        DisplaySprite3D(0,#squarex,50,180) 
      Stop3D() 
      
      FlipBuffers() 
      ExamineKeyboard() 
    Until KeyboardPushed(#PB_Key_Escape) 
    
    ;GrabSprite(100,0,0,640,480) 
    
    ;SaveSprite(100,"SBS.bmp") 
  EndIf 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
