;
; ------------------------------------------------------------
;
;   PureBasic - Simple mesh viewer
;
;    (c) 2008 - djes (http://djes.free.fr)
;
; ------------------------------------------------------------
;

IncludeFile "Screen3DRequester.pb"

Define.f KeyX, KeyY, MouseX, MouseY

If InitEngine3D()

  InitSprite()
  InitKeyboard()
  InitMouse()

  Filter$ = " Mesh (*.mesh)|*.mesh;*.meshes|All files (*.*)|*.*"
  Filter  = 0
  File$   = OpenFileRequester("Choose a mesh to view", GetCurrentDirectory(), Filter$, Filter)
  If File$
    Path$ = GetPathPart(File$)
    MeshFileName$ = GetFilePart(File$)
  Else
    MessageRequester("Information", "No file selected", 0)
    End
  EndIf

  If Screen3DRequester()
    
    refresh_rate.l  =  60

    SetRefreshRate(refresh_rate)
    SetFrameRate(refresh_rate)

    Add3DArchive(Path$, #PB_3DArchive_FileSystem)

    Parse3DScripts()

    LoadMesh   (1, MeshFileName$)

    CreateEntity(1, MeshID(1), #PB_Material_None)

    AmbientColor(RGB(255, 255, 255))  
    
    CreateLight(0, RGB(255, 255, 255))
    LightLocate(0, -20000, 20000, 10000)

     ;--- Camera

    ;Little computation to convert our pixels window to the % ogre
    level_min_x  = 0
    level_min_y  = 0
    level_max_x  = 1024
    level_max_y  = 768
    level_width  = level_max_x - level_min_x
    level_height = level_max_y - level_min_y
    CreateCamera(0, (level_min_x * 100) / ScreenWidth, (level_min_y * 100) / ScreenHeight, (level_width * 100) / ScreenWidth, (level_width * 100) / ScreenWidth)

    cam_x.f = 0
    cam_y.f = 0
    cam_z.f = 5
    CameraLocate(0, cam_x, cam_y, cam_z)
                                             
    Repeat

      Screen3DEvents()
      
      ClearScreen(RGB(0, 0, 0))
                 
      i.f+0.002
      
      CameraLocate(0, (1 + Sin(i / 2)) * 5 * Sin(i * 0.4), 5 * Sin(i), (1 + Sin(i / 2)) * 5 * Cos(i * 0.4))
      CameraLookAt(0, 0 , 0, 0)
    
      RenderWorld()
      Screen3DStats()
      FlipBuffers(#PB_Screen_SmartSynchronization)

    Until KeyboardPushed(#PB_Key_Escape) Or Quit = 1
  EndIf
    
Else
  MessageRequester("Error", "The 3D Engine can't be initialized",0)
EndIf
  
End
; IDE Options = PureBasic 4.30 Beta 4 (Windows - x86)
; CursorPosition = 20
; Folding = -
; Executable = C:\0\fire.exe
; SubSystem = OpenGL
; DisableDebugger