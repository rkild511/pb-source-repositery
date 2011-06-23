; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1501&start=10 
; Author: Danilo (updated for PB 4.00 by ste123) 
; Date: 05. July 2003 
; OS: Windows 
; Demo: Yes 

If InitEngine3D() And InitSprite() And InitKeyboard() 
  OpenWindow(0,0,0,640,480,"3D Mesh Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  OpenWindowedScreen(WindowID(0),0,0,640,480,0,0,0) 
  BigFont = LoadFont(1,"Arial",38) 

    CreateTexture(0,100,100) 
    StartDrawing(TextureOutput(0)) 
      Box(0,0,100,100,$44FFFF) 
      LineXY(0,0,100,100,$FF9999) 
      LineXY(100,0,0,100,$FF9999) 
      FrontColor(RGB($FF,$77,$FF)) 
      DrawingMode(#PB_2DDrawing_Transparent) 
      DrawingFont(BigFont) 
      DrawText(0,0,"123") 
    StopDrawing() 
    
    CreateMaterial(0, TextureID(0)) 

    ; Viereck 1 
    CreateMesh(1,30) 
    SetMeshData(1,#PB_Mesh_Vertex       ,?Ecken            , 4) ; 4 Ecken 
    SetMeshData(1,#PB_Mesh_Face         ,?Viereck_1        , 2) ; 2 Dreicke 
    SetMeshData(1,#PB_Mesh_UVCoordinate ,?TexturKoordinaten, 4) 

    CreateEntity(1, MeshID(1), MaterialID(0)) 


    ; Viereck 2 
    CreateMesh(2,30) 
    SetMeshData(2,#PB_Mesh_Vertex       ,?Ecken            , 4) ; 4 Ecken 
    SetMeshData(2,#PB_Mesh_Face         ,?Viereck_2        , 2) ; 2 Dreiecke 
    SetMeshData(2,#PB_Mesh_UVCoordinate ,?TexturKoordinaten, 4) 

    CreateEntity(2, MeshID(2), MaterialID(0)) 


    ; Viereck 3 
    CreateMesh(3,30) 
    SetMeshData(3,#PB_Mesh_Vertex       ,?Ecken            , 4) ; 4 Ecken 
    SetMeshData(3,#PB_Mesh_Face         ,?Viereck_3        , 4) ; 4 Dreiecke (Vorder- und Rueckseite) 
    SetMeshData(3,#PB_Mesh_UVCoordinate ,?TexturKoordinaten, 4) 

    CreateEntity(3, MeshID(3), MaterialID(0)) 


    MoveEntity(1,-3,0,0) 
    MoveEntity(3, 3,0,0) 
    
    CreateCamera(0, 0, 0, 100, 100) 
    CameraLocate(0,0,0,10) 
    
    Repeat 
      ClearScreen(RGB(0,0,0) ) 
      ExamineKeyboard() 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow 
          Quit = #True 
      EndSelect 

      rot+1 
      If rot>=360 : rot=0 : EndIf 

      RotateEntity(1, rot, rot, 0) 
      RotateEntity(2, rot, 0, rot) 
      RotateEntity(3, rot, rot, 0) 
      RenderWorld() 
      FlipBuffers() 
    Until KeyboardPushed(#PB_Key_Escape) Or Quit 
Else 
  MessageRequester("Error", "Cant init DirectX 3D Engine",0) 
EndIf 
  
End 


DataSection 

  Ecken: 
    Data.f -1, -1,  0 ; Ecke 0             3-----2 
    Data.f  1, -1,  0 ; Ecke 1             |  .  | 
    Data.f  1,  1,  0 ; Ecke 2             |     | 
    Data.f -1,  1,  0 ; Ecke 3             0-----1 

  TexturKoordinaten: 
    Data.f 0.0, 0.0 ; Vertex 0 
    Data.f 1.0, 0.0 ; Vertex 1 
    Data.f 1.0, 1.0 ; Vertex 2 
    Data.f 0.0, 1.0 ; Vertex 3 

  Viereck_1: 
    Data.w 0, 1, 2  ; Dreieck 1 besteht aus den Ecken 0, 1 und 2 
    Data.w 2, 3, 0  ; Dreieck 2 besteht aus den Ecken 2, 3 und 0 
                    ; = 1 Viereck 

  Viereck_2: 
    Data.w 0, 3, 2  ; Dreieck 1 besteht aus den Ecken 0, 3 und 2 
    Data.w 2, 1, 0  ; Dreieck 2 besteht aus den Ecken 2, 1 und 0 
                    ; = 1 Viereck 

  Viereck_3: 
    Data.w 0, 1, 2  ; Dreieck 1 besteht aus den Ecken 0, 1 und 2 
    Data.w 2, 3, 0  ; Dreieck 2 besteht aus den Ecken 2, 3 und 0 
                    ; = 1 Viereck Vorderseite 
    Data.w 0, 3, 2  ; Dreieck 1 besteht aus den Ecken 0, 3 und 2 
    Data.w 2, 1, 0  ; Dreieck 2 besteht aus den Ecken 2, 1 und 0 
                    ; = 1 Viereck Rueckseite 

EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger