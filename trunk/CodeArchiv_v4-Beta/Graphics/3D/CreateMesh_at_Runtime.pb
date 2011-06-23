; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8257&highlight=
; Author: Danilo (updated for PB 4.00 by benny)
; Date: 09. November 2003
; OS: Windows
; Demo: Yes


; Danilo 3d-Mesh zur Laufzeit 
 
; Backpanes von bobobo 
 
If InitEngine3D() And InitSprite() And InitKeyboard() 
  OpenWindow(0,0,0,640,480,"3D Mesh Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  OpenWindowedScreen(WindowID(0),0,0,640,480,0,0,0) 
  BigFont = LoadFont(1,"Arial",20) 
    CreateMesh(0,1000) 
    SetMeshData(0, #PB_Mesh_Vertex , ?CubeVertices          , 6) 
    SetMeshData(0, #PB_Mesh_Face , ?CubeFacesIndexes      , 4) 
    SetMeshData(0, #PB_Mesh_UVCoordinate, ?CubeTextureCoordinates, 4) 
 
    CreateTexture(0,64,64) 
    StartDrawing(TextureOutput(0)) 
      Box(0,0,64,64,$00FFFF) 
      LineXY(0,0,64,64,$000000) 
      LineXY(64,0,0,64,$000000) 
      FrontColor(RGB(0,0,255))
      DrawingMode(1) 
      DrawingFont(BigFont) 
      DrawText(0,0,"123") 
    StopDrawing() 
    CreateEntity(0, MeshID(0), CreateMaterial(0, TextureID(0))) 
    
    ;ScaleEntity(0, 3, 3, 3) 
    
    CreateCamera(0, 0, 0, 100, 100) 
    CameraLocate(0,1.5,1.5,10) 
    
    Repeat 
      ExamineKeyboard() 
      Select WindowEvent() 
        Case #PB_Event_CloseWindow 
          Quit = #True 
      EndSelect 
      RotateEntity(0, 5, 5, 0) 
      
      ClearScreen(RGB(0,0,0))
      RenderWorld() 
      FlipBuffers() 
    Until KeyboardPushed(#PB_Key_Escape) Or Quit 
Else 
  MessageRequester("Error", "Cant init DirectX 3D Engine",0) 
EndIf 
  
End 
DataSection 
  CubeVertices: 
    Data.f 0, 0, 0 ; Vertex index 0 
    Data.f 3, 0, 0 ; Vertex index 1 
    Data.f 3, 4, 0 ; Vertex index 2 
    Data.f 0, 4, 0 ; Vertex index 3 
    Data.f 0,0,3 ;Vertex index 4  Normale 0-4 
    Data.f 3,4,3 ;Vertex index 5  für Nomale 2-5 
  CubeFacesIndexes: 
    Data.w 0,1,2; 3Eck1bottom face (clockwise as it's reversed...) 
    Data.w 0,2,3;3Eck2 
    Data.w 0,3,2;3Eck1 back 
    Data.w 0,2,1 ;3Eck2 back 
  CubeTextureCoordinates: 
    Data.f 0.0, 0.0 ; Vertex 0 
    Data.f 2.0, 0.0 ; Vertex 1 
    Data.f 2.0, 1.0 ; Vertex 2 
    Data.f 0.0, 1.0 ; Vertex 3 
    
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
