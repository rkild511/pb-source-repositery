#CREATEPACKS = #True ;On va créer les packs. Si #False, on va utiliser les packs

DebugLevel 2 ;Pour voir les messages de la lib

XIncludeFile("packlib_release.pbi") ;On inclut la lib

If InitSprite() = 0 Or InitKeyboard() = 0
  MessageRequester("Error", "Sprite system can't be initialized", 0)
  End
EndIf

If OpenScreen(640, 480, 16, "Sprite")

  PackInit("mysprites.pak") ;On donne le nom du pack
  PackLoadSprite(0, #PB_Compiler_Home + "Examples\Sources\Data\PureBasic.bmp", 0) ;Charge un sprite (si #CREATEPACKS, l'ajoute au pack)
  ClosePack() ;On ferme le pack.
  
  Repeat
       
    FlipBuffers()

    ClearScreen(RGB(0,0,0))      
    DisplaySprite(0, x % 640, 100)
    
    x + 1
    
    ExamineKeyboard()
  Until KeyboardPushed(#PB_Key_Escape)
  
Else
  MessageRequester("Error", "Can't open a 640*480 - 16 bit screen !", 0)
EndIf

End   
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 5