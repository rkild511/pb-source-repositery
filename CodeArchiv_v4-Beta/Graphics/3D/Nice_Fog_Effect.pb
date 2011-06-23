; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7571&highlight=
; Author:  J. Baker (updated to PB4 by ste123)
; Date: 17. September 2003
; OS: Windows
; Demo: Yes
; 
; ------------------------------------------------------------ 
; 
;   PureBasic - Terrain 
; 
;    (c) 2003 - Fantaisie Software 
; 
; ------------------------------------------------------------ 
; 

#CameraSpeed = 5 

IncludeFile "Screen3DRequester.pb" 

Global KeyX.f, KeyY.f, MouseX.f, MouseY.f

If InitEngine3D() 
  Add3DArchive("Data\"          , #PB_3DArchive_FileSystem) 
  Add3DArchive("Data\Skybox.zip", #PB_3DArchive_Zip) 
  
  InitSprite() 
  InitKeyboard() 
  InitMouse() 
  
  If Screen3DRequester() 

    AmbientColor(RGB(255,255,255)) 
    
    CreateMaterial  (0, LoadTexture(0, "Terrain_Texture.jpg")) 
    AddMaterialLayer(0, LoadTexture(1, "Terrain_Detail.jpg"), 1) 
    
    CreateTerrain("Terrain.png", MaterialID(0), 4, 2, 4, 1) 
    
    Fog( RGB(0,0,255) , 2, 100, 3000) 

    CreateCamera(0, 0, 0, 100, 100) 
    CameraLocate(0, 128, 25, 128) 
    
    SkyDome("Clouds.jpg",10) 
    
    Repeat 
      Screen3DEvents() 
            
      If ExamineKeyboard() 
        
        If KeyboardPushed(#PB_Key_Left) 
          KeyX = -#CameraSpeed 
        ElseIf KeyboardPushed(#PB_Key_Right) 
          KeyX = #CameraSpeed 
        Else 
          KeyX = 0 
        EndIf 
                  
        If KeyboardPushed(#PB_Key_Up) 
          KeyY = -#CameraSpeed 
        ElseIf KeyboardPushed(#PB_Key_Down) 
          KeyY = #CameraSpeed 
        Else 
          KeyY = 0 
        EndIf 

      EndIf 
      
      If ExamineMouse() 
        MouseX = -(MouseDeltaX()/10)*#CameraSpeed/2 
        MouseY = -(MouseDeltaY()/10)*#CameraSpeed/2 
      EndIf 
      
      Height.f = TerrainHeight(CameraX(0), CameraZ(0)) + 50
      
      RotateCamera(0, MouseX, MouseY, RollZ) 
      MoveCamera  (0, KeyX, -CameraY(0)+Height+8, KeyY) 
            
      RenderWorld() 
      Screen3DStats() 
      FlipBuffers() 
    Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1 
  EndIf 
    
Else 
  MessageRequester("Error", "The 3D Engine can't be initialized",0) 
EndIf 
  
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
