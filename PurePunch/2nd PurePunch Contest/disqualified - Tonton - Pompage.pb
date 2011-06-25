
;*****************************************************************************
;*
;* nom   : Pompage
;* Auteur : Tonton
;* Date   : 1/06/2009
;* commentaire  : bouges la souris
;*
;*********************************************************************
#CameraSpeed=15:IncludeFile "Screen3DRequester.pb":Define.f KeyX,KeyY,MouseX
Define.f MouseY:InitEngine3D():Add3DArchive("Data\",#PB_3DArchive_FileSystem)
Add3DArchive("Data\Skybox.zip", #PB_3DArchive_Zip):InitSprite():InitKeyboard()
InitMouse():Screen3DRequester():CreateMaterial(0,LoadTexture(0,"r2skin.jpg"))
CreateEntity(0,LoadMesh(0,"Robot.mesh"),MaterialID(0)):SkyBox("desert07.jpg")
CreateCamera(0,0,0,100,100):CameraLocate(0,0,0,100):Repeat:Screen3DEvents()
ExamineMouse():MouseX =-(MouseDeltaX()/10)*#CameraSpeed/2
MouseY =-(MouseDeltaY()/10)*#CameraSpeed/2:RotateCamera(0,MouseX,MouseY, RollZ)
MoveCamera(0,KeyX,0,KeyY):RenderWorld():Screen3DStats():FlipBuffers()
Until KeyboardPushed(#PB_Key_Escape):End
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 18
; Folding = -