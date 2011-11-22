;
; ------------------------------------------------------------
;
;   PureBasic - Camera
;
;    (c) 2002 - Fantaisie Software
;
; ------------------------------------------------------------
;

#CameraSpeed = 10

IncludeFile "Screen3DRequester.pb"

DefType.f KeyX, KeyY, MouseX, MouseY

If InitEngine3D()

  Add3DArchive("Data\", #PB_3DArchive_FileSystem)
  
  InitSprite()
  InitKeyboard()
  InitMouse()
  
  If Screen3DRequester()
    AmbientColor(RGB(0,200,0))  ; Green 'HUD' like color 
 
    CreateMaterial(0, LoadTexture(0, "r2skin.jpg"))
    CreateEntity(0, LoadMesh(0, "Robot.mesh"), MaterialID(0))
    AnimateEntity(0, "Walk")
    
    CreateCamera(0, 0, 0, 100, 50)  ; Front camera
    CameraLocate(0,0,0,100)
    
    Repeat
      Screen3DEvents()
      
      ClearScreen(0, 0, 0)
            
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
        MouseX = MouseX+MouseDeltaX()
        MouseY = MouseY+MouseDeltaY()
      EndIf
      
      RotateEntity(0, 1, 0, 0)
      
      CameraLookAt(0, CameraX(0), CameraY(0), CameraZ(0)-10) 
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
; ExecutableFormat=Windows
; CursorPosition=53
; FirstLine=1
; EOF