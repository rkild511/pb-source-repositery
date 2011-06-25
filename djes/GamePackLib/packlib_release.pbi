;******************************************************************************************************
; GAMEPACKLIB
; djes (Jésahel Benoist) 2007-2009
;
; Automagically manage games ressources (sprites, images, sound, entities...) and create crypted 
; packs for release version.
;  
; S'occupe automagiquement de la gestion des ressources dans les jeux (sprites, images, 
; sons, entités...) en créant des packs cryptés pour les versions définitives.
;
; DOCUMENTATION (EN)
;
; When you're coding a game, you often have to manage a lot of files : packing, crypting,
; allocating/freeing memory, lists. Especially because the graphic and sound are 
; changing constantly, you certainly are bored to use another code just to 
; recreate packs.
; More than that, for every level you have to worry about loading/unloading files and
; releasing ressources, entities, cameras...
;
; This lib does everything for you, and you'll not have to swap, ever!
; 
; Just include this file in your source code, replace the Purebasic LoadSprite(), 
; LoadImage(), LoadSound()... with the PackLibLoadSprite(), PackLibLoadImage()... 
; equivalent, and choose what to do with the CREATEPACKS constant.
;
; #CREATEPACKS = #True and it will load original files (PNG, TIF, WAV...), encrypt 
;   file headers (only headers to make it fast), create packs, and run normally.
; #CREATEPACKS = #False for release code, packs are used normally.
;
; DOCUMENTATION (FR)
;
; Quand vous programmez un jeu, vous devez souvent vous occuper de beaucoup de fichiers : 
; packer, allouer/libérer la mémoire, les listes. Comme les graphs et les sons
; changent tout le temps, vous devez passer votre temps à basculer sur un autre code
; pour recréer les packs. 
; En plus, pour tous les niveaux vous devez vous occuper des
; chargements/déchargements de fichiers et de la libération des ressources, entités, caméras...
; Cette bibliothèque fait tout cela pour vous, et vous n'aurez plus jamais à swapper!
; 
; Incluez ce fichier dans le source de votre jeu, remplacez les LoadSprite(), 
; LoadImage(), LoadSound()... de Purebasic avec les équivalents PackLibLoadSprite(), 
; PackLibLoadImage()... puis décidez quoi faire avec la constante CREATEPACKS.
;
; #CREATEPACKS = #True pour charger les fichiers originaux (PNG, TIF, WAV...), encrypter 
; les entêtes de fichiers (seulement les entêtes pour que ce soit rapide), créer les 
; packs, and démarrer normalement.
; #CREATEPACKS = #False pour le programme à diffuser, les packs sont alors utilisés.
;
; USAGE (EN) 
;
;  At the game start :
;   #CREATEPACKS = #True  ; When you want to create packs
;   #CREATEPACKS = #False ; When you want to use packs (release mode)
;
;  To load files :
;   PackInit("mypacks/mysprites.pak") ; Say in what pack following files will be
;   PackLoadSprite(#SPRITE0, "mysprites/car.png") ; Like LoadSprite()
;   PackLoadSprite(#SPRITE1, "mysprites/paperboy.png")
;   ClosePack() 
;   PackInit("mypacks/mysounds.pak")
;   PackLoadSound(Sound1, "mysfx/kaboom.wav") ; Like LoadSound()
;   PackLoadSound(Sound2, "mysfx/ouch.wav")
;   ClosePack() 
;
;  Special levels routines
;
;   At the level start :
;    PackInit("mypacks/level1.pak")
;    PackLevelLoadSprite(#SPRITE0, "sprites/mysprite.png")
;    ClosePack()
;
;   At the level end :
;    FreeLevelRessources()
;
; USAGE (FR)
;
;  Au démarrage :
;   #CREATEPACKS = #True  ; Pour créer les packs
;   #CREATEPACKS = #False ; Pour utiliser les packs (release mode)
;
;  Pour charger les fichiers :
;   PackInit("mypacks/mysprites.pak") ; Indique le nom du pack à utiliser/créer
;   PackLoadSprite(#SPRITE0, "mysprites/car.png") ; Comme LoadSprite()
;   PackLoadSprite(#SPRITE1, "mysprites/paperboy.png")
;   ClosePack() 
;   PackInit("mypacks/mysounds.pak")
;   PackLoadSound(Sound1, "mysfx/kaboom.wav") ; Comme LoadSound()
;   PackLoadSound(Sound2, "mysfx/ouch.wav")
;   ClosePack() 
;
;  Routines spéciales pour les niveaux
;
;   Avant le niveau :
;    PackInit("mypacks/level1.pak")
;    PackLevelLoadSprite(#SPRITE0, "sprites/mysprite.png") ; Comme LoadSprite()
;    ClosePack()
;
;   A la fin du niveau :
;    FreeLevelRessources()
;
;******************************************************************************************************

;- Place this constant at the start of your code
;#CREATEPACKS = #False 

; - PB objects types
Enumeration
  #SPRITE_OBJECT
  #SPRITE3D_OBJECT
  #IMAGE_OBJECT
  #FONT_OBJECT
  #SOUND_OBJECT
  #MESH_OBJECT
  #TEXTURE_OBJECT
  #ENTITY_OBJECT
  #MATERIAL_OBJECT
  #CAMERA_OBJECT
  #LIGHT_OBJECT
EndEnumeration

; - Structure Ressource
Structure Ressource
  ObjectType.i  ; See constants : PB objects types
  ObjectNb.l
EndStructure

; - List
Global NewList LevelRessources.Ressource()
Global PackName.s, PackCounter.l

;******************************************************************************************************

Procedure PackInit(Name.s)
   PackName = Name
   PackCounter = 0
EndProcedure

;******************************************************************************************************
Procedure TheEnd(info.s)
	;CloseScreen()
	MessageRequester("Alert", info, #PB_MessageRequester_Ok)
	;ExitProcess_(0)
	End
EndProcedure

;******************************************************************************************************
Procedure AddRessource(Type.l, Nb.l)
  Shared PackName.s, PackCounter.l
  AddElement(LevelRessources())
  LevelRessources()\ObjectType = Type
  LevelRessources()\ObjectNb = Nb
  Debug "Ressource N°" + Str(Nb), 2
EndProcedure

;******************************************************************************************************
;load specified sprite else quit and add it to level ressources list
Procedure OrgLevelLoadsprite(Nb.l, Name.s, Mode = 0)

  If IsSprite(Nb)
    FreeSprite(Nb)
  EndIf
  
	If LoadSprite(Nb, Name, Mode) <> 0
    AddRessource(#SPRITE_OBJECT, Nb)
	Else
		TheEnd(Name + " loading problem")
	EndIf

EndProcedure

;******************************************************************************************************
;load specified sprite3d else quit and add it to level ressources list
Procedure OrgLevelLoadSprite3D(Nb.l, Name.s, Mode)

  If IsSprite3D(Nb)
    FreeSprite3D(Nb)
  EndIf
  
  If IsSprite(Nb)
    FreeSprite(Nb)
  EndIf
  
  ;Mode should be #PB_Sprite_Texture|#PB_Sprite_AlphaBlending
  If LoadSprite(Nb, Name, Mode) <> 0
    AddRessource(#SPRITE3D_OBJECT, Nb)
    CreateSprite3D(Nb, Nb)
  Else
    TheEnd(Name + " loading problem")
  EndIf

EndProcedure

;******************************************************************************************************
;load specified mesh else quit and add it to level ressources list
Procedure OrgLevelLoadmesh(Nb.l, Name.s)

  If IsMesh(Nb)
    FreeMesh(Nb)
  EndIf
  
  If LoadMesh(Nb, Name) <> 0
    AddRessource(#MESH_OBJECT, Nb)
  Else
    TheEnd(Name + " loading problem")
  EndIf

EndProcedure

;******************************************************************************************************
;load specified texture else quit and add it to level ressources list
Procedure OrgLevelLoadTexture(Nb.l, Name.s)

  If IsTexture(Nb)
    FreeTexture(Nb)
  EndIf
  
  If LoadTexture(Nb, Name) <> 0
    AddRessource(#TEXTURE_OBJECT, Nb)
  Else
    TheEnd(Name + " loading problem")
  EndIf

EndProcedure


;******************************************************************************************************
;create a material else quit and add it to level ressources list
Procedure OrgLevelCreateMaterial(MaterialNb.l, TextureNb.l)

  If IsMaterial(MaterialNb)
    FreeMaterial(MaterialNb)
  EndIf
  
  If CreateMaterial(MaterialNb, TextureID(TextureNb)) <> 0
    AddRessource(#MATERIAL_OBJECT, MaterialNb)
  Else
    TheEnd("Material " + Str(MaterialNb) + " creation problem")
  EndIf

EndProcedure

;******************************************************************************************************
;create a material else quit and add it to level ressources list
Procedure OrgLevelCreateEntity(EntityNb.l, MeshNb.l, MaterialNb.l, X.d = 0, Y.d = 0, Z.d = 0 )

  If IsEntity(EntityNb)
    FreeEntity(EntityNb)
  EndIf
  
  If CreateEntity(EntityNb, MeshID(MeshNb), MaterialID(MaterialNb), X, Y, Z) <> 0
    AddRessource(#ENTITY_OBJECT, EntityNb)
  Else
    TheEnd("Entity " + Str(EntityNb) + " creation problem")
  EndIf

EndProcedure

;******************************************************************************************************
;create a camera else quit and add it to level ressources list
Procedure OrgLevelCreateCamera(CameraNb.l, X.d, Y.d, Width.d, Height.d)

  If IsCamera(CameraNb)
    FreeCamera(CameraNb)
  EndIf
  
  If CreateCamera(CameraNb, X, Y, Width, Height) <> 0
    AddRessource(#CAMERA_OBJECT, CameraNb)
  Else
    TheEnd("Camera " + Str(CameraNb) + " creation problem")
  EndIf

EndProcedure

;******************************************************************************************************
;create a camera else quit and add it to level ressources list
Procedure OrgLevelCreateLight(LightNb.l, Color.l, X.d = 0, Y.d = 0, Z.d = 0 )

  If IsLight(LightNb)
    FreeLight(LightNb)
  EndIf
  
  If CreateLight(LightNb, Color, X, Y, Z) <> 0
    AddRessource(#LIGHT_OBJECT, LightNb)
  Else
    TheEnd("Light " + Str(LightNb) + " creation problem")
  EndIf

EndProcedure

;******************************************************************************************************
;load specified image else quit
Procedure OrgLoadImage(Nb.l, Name.s, Options.i = 0)

  If IsImage(Nb)
    FreeImage(Nb)
  EndIf

	If LoadImage(Nb, Name, Options) <> 0
	Else
		TheEnd(Name + " loading problem")
	EndIf

EndProcedure

;******************************************************************************************************
;load specified sprite else quit
Procedure OrgLoadSprite(Nb.l, Name.s, Mode.i = 0)

  If IsSprite(Nb)
    FreeSprite(Nb)
  EndIf

	If LoadSprite(Nb, Name, Mode) <> 0
	Else
		TheEnd(Name + " loading problem")
	EndIf

EndProcedure

;******************************************************************************************************
;load specified sound else quit
Procedure OrgLoadSound(Nb.l, Name.s, Options.i = 0)

  If IsSound(Nb)
    FreeSound(Nb)
  EndIf

	If LoadSound(Nb, Name, Options) <> 0
	Else
		TheEnd(Name + " loading problem")
	EndIf
EndProcedure

;******************************************************************************************************
;load specified sprite3d else quit
Procedure OrgLoadSprite3D(Nb.l, Name.s, Mode.i = 0)

  If IsSprite3D(Nb)
    FreeSprite3D(Nb)
  EndIf
 
  If IsSprite(Nb)
    FreeSprite(Nb)
  EndIf

 ;mode should be #PB_Sprite_Texture|#PB_Sprite_AlphaBlending
  If LoadSprite(Nb, Name, Mode) <> 0
    CreateSprite3D(Nb, Nb)
  Else
    TheEnd(Name + " loading problem")
  EndIf

EndProcedure

;******************************************************************************************************
Procedure CipherAddPackFile(Name.s, CompressionRatio.l)

  If Name

    If ReadFile(0, Name) 

      Length = Lof(0)                            ; get the length of opened file
      *MemoryID = AllocateMemory(Length)         ; allocate the needed memory

      If *MemoryID
        bytes = ReadData(0, *MemoryID, Length)   ; read all data into the memory block
        Debug "Bytes : " + Str(bytes), 2
      EndIf

      If Lof(0) >=  256
        
        ;Cipher on place a 128 bytes header
        AESEncoder(*MemoryID, *MemoryID , 128, *MemoryID + 128, 128, *MemoryID + 128)
        
      EndIf

      CloseFile(0)
    
      ;AddPackFile(Name, CompressionRatio)
      If AddPackMemory(*MemoryID, Length, CompressionRatio)
        FreeMemory(*MemoryID)
      Else
        TheEnd("Can't compress " + Name)
      EndIf

    EndIf

  EndIf

EndProcedure

;******************************************************************************************************
Procedure DecipherNextPackFile()

  MemoryID.l = NextPackFile()
  Length.l = PackFileSize()

  Debug " - - - - - - - - - - - - - - - - - - - - - - - - ", 2
  Debug "Memory : " + Str(MemoryID), 2
  Debug "   Length : " + Str(Length), 2

  If MemoryID <> 0 And Length >=  256

    ;Dedipher a 128 bytes header
    *CipheredBuffer   = AllocateMemory(256)
    CopyMemory(MemoryID, *CipheredBuffer, 128)
    AESDecoder(*CipheredBuffer, MemoryID, 128, MemoryID + 128, 128, MemoryID + 128)
    FreeMemory(*CipheredBuffer)
    
  EndIf

  ProcedureReturn MemoryID

EndProcedure

;******************************************************************************************************
Procedure CreatePackAndAdd(Name.s)

  If PackCounter = 0
    CreatePack(PackName)
    Debug "Pack created : " + PackName, 2
  EndIf

  CipherAddPackFile(Name, 9)
;    AddPackFile(Name, 9)
  Debug "file " + Str(PackCounter + 1) + " added : " + Name, 2
  PackCounter + 1

EndProcedure

;******************************************************************************************************
;If first object loaded, open level pack
Procedure PackLibOpenPack()

  If PackCounter = 0

    n = OpenPack(PackName)
  
    If n <> 0
      Debug "Pack opened : " + PackName, 2
    Else
  		TheEnd(PackName + " loading problem")
    EndIf

  EndIf

EndProcedure


;******************************************************************************************************
;load specified sprite else quit and add it to level ressources list. 
Procedure PackLevelLoadSprite(Nb.l, Name.s, Mode.i = 0)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLevelLoadsprite(Nb.l, Name.s, Mode)

  CompilerElse

    PackLibOpenPack()
  
    If CatchSprite(Nb, DeCipherNextPackFile(), Mode) <> 0
      Debug " Sprite " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
      AddRessource(#SPRITE_OBJECT, Nb)
  	Else
  		TheEnd(Name + " loading problem")
  	EndIf

  CompilerEndIf

EndProcedure

;******************************************************************************************************
;catch specified sprite3d else quit and add it to level ressources list
Procedure PackLevelLoadSprite3D(Nb.l, Name.s, Mode.i = 0)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)    
    OrgLevelLoadSprite3D(Nb.l, Name.s, Mode)
 
  CompilerElse
  
    PackLibOpenPack()
  
    ;Mode should be #PB_Sprite_Texture|#PB_Sprite_AlphaBlending
    If CatchSprite(Nb, DeCipherNextPackFile(), Mode) <> 0
      Debug " Sprite3D " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
      AddRessource(#SPRITE3D_OBJECT, Nb)
      
      CompilerIf #PB_Compiler_Debugger
      
        If SpriteWidth(Nb) <> SpriteHeight(Nb)
          Debug Name + " is not square", 2
        EndIf
        
        Debug "  Size : " + Str(SpriteWidth(Nb)) + "*" + Str(SpriteHeight(Nb)), 2
      
      CompilerEndIf
      
      CreateSprite3D(Nb, Nb)
    Else
      TheEnd(Name + " loading problem")
    EndIf

  CompilerEndIf

EndProcedure

;******************************************************************************************************
;Load a sound and add it to level ressources list
Procedure PackLevelLoadSound(Nb.l, Name.s, Flags.i = 0)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLoadsound(Nb.l, Name.s, Flags)
  
  CompilerElse
  
    PackLibOpenPack()
  
    u = DeCipherNextPackFile()

  	If CatchSound(Nb, u, PackFileSize(), Flags) <> 0 ;PackFileSize() needed for ogg
      Debug " Sound " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
      AddRessource(#SOUND_OBJECT, Nb)
    Else
      TheEnd(Name + " loading problem")
    EndIf

  CompilerEndIf

EndProcedure


;******************************************************************************************************
;load specified sprite else quit
Procedure PackLoadImage(Nb.l, Name.s, Flags.i)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLoadimage(Nb.l, Name.s, Flags)
  
  CompilerElse
  
    PackLibOpenPack()

    If IsImage(Nb) <> 0 : FreeImage(Nb) : EndIf
    
  	If CatchImage(Nb, DeCipherNextPackFile(), PackFileSize()) <> 0
      Debug " Image " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
  	Else
  		TheEnd(Name + " loading problem")
  	EndIf

  CompilerEndIf

EndProcedure


;******************************************************************************************************
;load specified sprite else quit
Procedure PackLoadSprite(Nb.l, Name.s, Mode.i)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLoadsprite(Nb.l, Name.s, Mode)
  
  CompilerElse
  
    PackLibOpenPack()
  
    If IsSprite(Nb) <> 0 : FreeSprite(Nb) : EndIf
    
  	If CatchSprite(Nb, DeCipherNextPackFile(), Mode) <> 0
      Debug " Sprite " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
  	Else
  		TheEnd(Name + " loading problem")
  	EndIf

  CompilerEndIf

EndProcedure

;******************************************************************************************************
;load specified sprite3d else quit
Procedure PackLoadSprite3D(Nb.l, Name.s, Mode.i)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLoadSprite3D(Nb.l, Name.s, Mode)  

  CompilerElse

    PackLibOpenPack()

    If IsSprite3D(Nb) <> 0 
      FreeSprite3D(Nb) 
      
      If IsSprite(Nb) <> 0 
        FreeSprite(Nb)
      EndIf
      
    EndIf
    
    ;Mode should be #PB_Sprite_Texture|#PB_Sprite_AlphaBlending
    If CatchSprite(Nb, DeCipherNextPackFile(), Mode) <> 0
    
      Debug " Sprite3D " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      Debug " Name constant : " + Str(Nb), 2
      PackCounter + 1
      
      CompilerIf #PB_Compiler_Debugger
        If SpriteWidth(Nb) <> SpriteHeight(Nb)
          Debug Name + " is not square", 2
        EndIf
        Debug "  Size : " + Str(SpriteWidth(Nb)) + "*" + Str(SpriteHeight(Nb)), 2
      CompilerEndIf
      
      CreateSprite3D(Nb, Nb)
    Else
      TheEnd(Name + " loading problem")
    EndIf

  CompilerEndIf
EndProcedure

;******************************************************************************************************
;load specified sound else quit
Procedure PackLoadSound(Nb.l, Name.s, Flags.i = 0)

  ;Creates pack If needed
  CompilerIf #CREATEPACKS = #True

    CreatePackAndAdd(Name)
    OrgLoadsound(Nb.l, Name.s, Flags)
  
  CompilerElse
  
    PackLibOpenPack()
  
    u = DeCipherNextPackFile()

    If IsSound(Nb) <> 0 : FreeSound(Nb) : EndIf
    
  	If CatchSound(Nb, u, PackFileSize(), Flags) <> 0 ;PackFileSize() needed for ogg
      Debug " Sound " + Str(PackCounter) + " loaded : " + Name + " as Nb " + Str(Nb), 2
      PackCounter + 1
  	Else
  		TheEnd(Name + " loading problem")
  	EndIf

  CompilerEndIf

EndProcedure

;******************************************************************************************************
; Automagically free levels objects
Procedure FreeLevelRessources()

  With LevelRessources()
  ForEach LevelRessources()
    Select \ObjectType
    Case #SPRITE_OBJECT
      If IsSprite(\ObjectNb)   : FreeSprite(\ObjectNb)   : EndIf
    Case #SPRITE3D_OBJECT
      If IsSprite3D(\ObjectNb) : FreeSprite3D(\ObjectNb) : EndIf
      If IsSprite(\ObjectNb)   : FreeSprite(\ObjectNb)   : EndIf
    Case #IMAGE_OBJECT
      If IsImage(\ObjectNb)    : FreeImage(\ObjectNb)    : EndIf
    Case #FONT_OBJECT
      If IsFont(\ObjectNb)     : FreeFont(\ObjectNb)     : EndIf
    Case #SOUND_OBJECT
      If IsSound(\ObjectNb)    : FreeSound(\ObjectNb)    : EndIf
    Case #MESH_OBJECT
      If IsMesh(\ObjectNb)     : FreeMesh(\ObjectNb)     : EndIf
    Case #TEXTURE_OBJECT
      If IsTexture(\ObjectNb)  : FreeTexture(\ObjectNb)  : EndIf
    Case #ENTITY_OBJECT
      If IsEntity(\ObjectNb)   : FreeEntity(\ObjectNb)   : EndIf
    Case #MATERIAL_OBJECT
      If IsMaterial(\ObjectNb) : FreeMaterial(\ObjectNb) : EndIf
    Case #CAMERA_OBJECT
      If IsCamera(\ObjectNb)   : FreeCamera(\ObjectNb) : EndIf
    Case #LIGHT_OBJECT
      If IsLight(\ObjectNb)    : FreeLight(\ObjectNb) : EndIf
    EndSelect
  Next
  EndWith
  
  CompilerIf #PB_Compiler_Debugger = #False
    Delay(1000) ;You don't want to suppress this.
  CompilerEndIf
  
  ClearList(LevelRessources())
  
EndProcedure
; IDE Options = PureBasic 4.51 (Windows - x86)
; CursorPosition = 624
; FirstLine = 621
; Folding = -----