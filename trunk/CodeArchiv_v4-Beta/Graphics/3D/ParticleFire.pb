; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7572&highlight=
; Author: J. Baker (updated to PB4 by ste123)
; Date: 17. September 2003
; OS: Windows
; Demo: Yes

; 
; ------------------------------------------------------------ 
; 
;   PureBasic - Particle 
; 
;    (c) 2003 - Fantaisie Software 
; 
; ------------------------------------------------------------ 
; 

#CameraSpeed = 10 

IncludeFile "Screen3DRequester.pb" 

Global KeyX.f, KeyY.f, MouseX.f, MouseY.f

If InitEngine3D() 

  Add3DArchive("Data\", #PB_3DArchive_FileSystem) 
  
  InitSprite() 
  InitKeyboard() 
  InitMouse() 
  
  If Screen3DRequester() 
    
    LoadTexture(0, "Flare.png") 
    
    CreateMaterial(0, TextureID(0)) 
      DisableMaterialLighting(0, 1) 
      MaterialBlendingMode   (0, 2) 
        
    CreateParticleEmitter(0, 5, 1, 1, 0) 
      ParticleMaterial    (0, MaterialID(0)) 
      ParticleTimeToLive  (0, 0.75, 0.75) 
      ParticleEmissionRate(0, 20) 
      ParticleSize        (0, 30, 45) 
      ParticleColorRange  (0, RGB(255,255,0), RGB(255,0,0)) 

    CreateCamera(0, 0, 0, 100, 100) 
    CameraLocate(0,0,0,400) 
          
    Repeat 
      Screen3DEvents() 
      
      ClearScreen( RGB(0, 0, 0) )
            
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
      
      RotateCamera(0, MouseX, MouseY, RollZ) 
      MoveCamera  (0, KeyX, 0, KeyY) 
    
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
