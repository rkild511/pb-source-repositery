; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7131&highlight=
; Author: Lars Gretnes (updated to PB4 by ste123)
; Date: 06. August 2003
; OS: Windows
; Demo: Yes

; Attention! Needs the archives, pictures from original PureBasic Examples\data directory....

; 
; 
; Keeping constant distance to terrain example 
; by Lars Gretnes, 2003 
; 

#CameraSpeed  = 15 
#WalkSpeed    = 5 

IncludeFile "Screen3DRequester.pb" 

Global KeyX.f, KeyY.f, MouseX.f, MouseY.f

If InitEngine3D() 

  Add3DArchive("Data\"          , #PB_3DArchive_FileSystem) 
  ;Add3DArchive("Data\Skybox.zip", #PB_3DArchive_Zip) 
  
  InitSprite() 
  InitKeyboard() 
  InitMouse() 
  
  If Screen3DRequester() 

    AmbientColor(RGB(255,255,255)) 

    ; load the mesh (robot) 
    ;mesh.l = LoadMesh(#PB_Any, "robot.mesh") 
    ;texture.l = LoadTexture(#PB_Any, "r2skin.jpg") 
    ;material.l = CreateMaterial (#PB_Any, TextureID(texture)) 
    ;CreateEntity (0, MeshID(mesh), MaterialID(material), -1, -2, -3) 
    
    ; load terrain 
   	CreateMaterial  (0, LoadTexture(0, "Terrain_Texture.jpg"))
    AddMaterialLayer(0, LoadTexture(1, "Terrain_Detail.jpg"), 1)
    ;CreateTerrain("Terrain.png", MaterialID(0), 40, 20, 40, 1) 
    CreateTerrain("Terrain.png", MaterialID(0), 1, 1, 1, 1) 

    SkyDome("Clouds.jpg", 30) 

    ; create and place the camera 
    CreateCamera(0,0,0,100,100) 
    CameraLocate(0,0,50,0) 

    Repeat 
      Screen3DEvents() 

       ; get the key input 
       If ExamineKeyboard() 
        If KeyboardPushed(#PB_Key_Left) 
          KeyX = -#WalkSpeed 
        ElseIf KeyboardPushed(#PB_Key_Right) 
          KeyX = #WalkSpeed 
        Else 
          KeyX = 0 
        EndIf 
                  
        If KeyboardPushed(#PB_Key_Up) 
          KeyY = -#WalkSpeed 
        ElseIf KeyboardPushed(#PB_Key_Down) 
          KeyY = #WalkSpeed 
        Else 
          KeyY = 0 
        EndIf 

      EndIf 
      
      ; get mousemovement 
      If ExamineMouse() 
        MouseX = -(MouseDeltaX()/10)*#CameraSpeed/2 
        MouseY = -(MouseDeltaY()/10)*#CameraSpeed/2 
      EndIf 
      
      ; get the terrain heigh at the player coords 
      ypos = TerrainHeight(CameraX(0) ,CameraZ(0)) + 30; 

      ; move the camera, and keep the height at +50 
      RotateCamera (0, MouseX, MouseY, 0) 
      MoveCamera (0, KeyX, 0, KeyY) 
      CameraLocate (0, CameraX(0), ypos, CameraZ(0)) 

      ; render world 
      RenderWorld() 
      FlipBuffers() 

    Until KeyboardPushed(#PB_Key_Escape) 
  EndIf 
    
Else 
  MessageRequester("Error", "The 3D Engine can't be initialized",0) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
