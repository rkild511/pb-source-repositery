; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; CODE GÉNÉRÉ AUTOMATIQUEMENT, NE PAS MODIFIER À
; MOINS D'AVOIR UNE RAISON TRÈS TRÈS VALABLE !!!
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Code généré par : Dev-Type V3.44.166
; Nom du projet : Le nom du projet ici
; Nom du fichier : Nom du fichier
; Version du fichier : 0.0.0
; Programmation : À vérifier
; Programmé par : Votre Nom Ici
; Alias : Votre Pseudo Ici
; Courriel : adresse@quelquechose.com
; Date : 24-09-2011
; Mise à jour : 02-10-2011
; Codé pour PureBasic V4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Déclaration de la Structure <<<<<

Structure Thothbox

  PrefFileName.s
  Language.Language
  Window.Window
  ConnectionStatus.TwinState
  Connection.Connection
  DisplayMode.b
  DownloadPath.s
  PurebasicPath.s
  PurebasicPrefsPath.s
  CreditWindow.Credit

EndStructure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les observateurs <<<<<

Macro GetThothboxPrefFileName(ThothboxA)

  ThothboxA\PrefFileName

EndMacro

Macro GetThothboxLanguage(ThothboxA)

  ThothboxA\Language

EndMacro

Macro GetThothboxWindow(ThothboxA)

  ThothboxA\Window

EndMacro

Macro GetThothboxConnectionStatus(ThothboxA)

  ThothboxA\ConnectionStatus

EndMacro

Macro GetThothboxConnection(ThothboxA)

  ThothboxA\Connection

EndMacro

Macro GetThothboxDisplayMode(ThothboxA)

  ThothboxA\DisplayMode

EndMacro

Macro GetThothboxDownloadPath(ThothboxA)

  ThothboxA\DownloadPath

EndMacro

Macro GetThothboxPurebasicPath(ThothboxA)

  ThothboxA\PurebasicPath

EndMacro

Macro GetThothboxPurebasicPrefsPath(ThothboxA)

  ThothboxA\PurebasicPrefsPath

EndMacro

Macro GetThothboxCreditWindow(ThothboxA)

  ThothboxA\CreditWindow

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Les mutateurs <<<<<

Macro SetThothboxPrefFileName(ThothboxA, P_PrefFileName)

  GetThothboxPrefFileName(ThothboxA) = P_PrefFileName

EndMacro

Macro SetThothboxLanguage(ThothboxA, P_Language)

  GetThothboxLanguage(ThothboxA) = P_Language

EndMacro

Macro SetThothboxWindow(ThothboxA, P_Window)

  GetThothboxWindow(ThothboxA) = P_Window

EndMacro

Macro SetThothboxConnectionStatus(ThothboxA, P_ConnectionStatus)

  GetThothboxConnectionStatus(ThothboxA) = P_ConnectionStatus

EndMacro

Macro SetThothboxConnection(ThothboxA, P_Connection)

  GetThothboxConnection(ThothboxA) = P_Connection

EndMacro

Macro SetThothboxDisplayMode(ThothboxA, P_DisplayMode)

  GetThothboxDisplayMode(ThothboxA) = P_DisplayMode

EndMacro

Macro SetThothboxDownloadPath(ThothboxA, P_DownloadPath)

  GetThothboxDownloadPath(ThothboxA) = P_DownloadPath

EndMacro

Macro SetThothboxPurebasicPath(ThothboxA, P_PurebasicPath)

  GetThothboxPurebasicPath(ThothboxA) = P_PurebasicPath

EndMacro

Macro SetThothboxPurebasicPrefsPath(ThothboxA, P_PurebasicPrefsPath)

  GetThothboxPurebasicPrefsPath(ThothboxA) = P_PurebasicPrefsPath

EndMacro

Macro SetThothboxCreditWindow(ThothboxA, P_CreditWindow)

  GetThothboxCreditWindow(ThothboxA) = P_CreditWindow

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Reset <<<<<

Macro ResetThothbox(ThothboxA)
  
  SetThothboxPrefFileName(ThothboxA, "")
  ResetLanguage(GetThothboxLanguage(ThothboxA))
  ResetWindow(GetThothboxWindow(ThothboxA))
  ResetTwinState(GetThothboxConnectionStatus(ThothboxA))
  ResetConnection(GetThothboxConnection(ThothboxA))
  SetThothboxDisplayMode(ThothboxA, 0)
  SetThothboxDownloadPath(ThothboxA, "")
  SetThothboxPurebasicPath(ThothboxA, "")
  SetThothboxPurebasicPrefsPath(ThothboxA, "")
  ResetCredit(GetThothboxCreditWindow(ThothboxA))

EndMacro

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Code généré en : 00.011 secondes (16545.45 lignes/seconde) <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Ouverture d'un fichier de Préférences <<<<<

Procedure OpenThothboxPreferences(*ThothboxA.Thothbox)

  If OpenPreferences(GetThothboxPrefFileName(*ThothboxA))

    ReadPreferenceLanguage("Language", GetThothboxLanguage(*ThothboxA))
    ReadPreferenceWindow("Window", GetThothboxWindow(*ThothboxA))
    ReadPreferenceConnection("Connection", GetThothboxConnection(*ThothboxA))
    
    ClosePreferences()

  EndIf

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Création d'un fichier de Préférences <<<<<

Procedure CreateThothboxPreferences(*ThothboxA.Thothbox)

  If CreatePreferences(GetThothboxPrefFileName(*ThothboxA))

    WritePreferenceLanguage("Language", GetThothboxLanguage(*ThothboxA))
    WritePreferenceWindow("Window", GetThothboxWindow(*ThothboxA))
    WritePreferenceConnection("Connection", GetThothboxConnection(*ThothboxA))
    
    ClosePreferences()

  EndIf

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< L'opérateur Initialize <<<<<

Procedure InitializeThothbox(*ThothboxA.Thothbox)
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; PureBasic Standard Module Initialization
  
  InitNetwork()
  UsePNGImageDecoder()
  UseJPEGImageDecoder()
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; We Set default values for Thothbox
  
  SetThothboxPrefFileName(*ThothboxA, #Program_Name + ".prefs")
  InitializeLanguage(GetThothboxLanguage(*ThothboxA),"", "locale")
  InitializeWindow(GetThothboxWindow(*ThothboxA))
  InitializeTwinStateEx(GetThothboxConnectionStatus(*ThothboxA), #Button_Connection_Status, ?OffLine, ?Online, 0) ; Par défaut, toujours offline
  InitializeConnection(GetThothboxConnection(*ThothboxA))
  InitializeCredit(GetThothboxCreditWindow(*ThothboxA))
  
  SetThothboxDisplayMode(*ThothboxA, #Container_Window_Search)
  
  SetThothboxDownloadPath(*ThothboxA, GetTemporaryDirectory() + LCase(#Program_Name))
  CreatePath(GetThothboxDownloadPath(*ThothboxA))

  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; We Get the PureBasic Environnement parameters
  
  If GetEnvironmentVariable("PUREBASIC_HOME") <> ""
    SetThothboxPurebasicPath(*ThothboxA, GetEnvironmentVariable("PUREBASIC_HOME"))
  EndIf
  
  If GetEnvironmentVariable("PB_TOOL_Preferences") <> ""
    SetThothboxPurebasicPrefsPath(*ThothboxA, GetPathPart(GetEnvironmentVariable("PB_TOOL_Preferences") + "Tools.prefs"))
  EndIf
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; We try to load the preferences (If the file don't exist we create 
  ; it then we run the program with the default parameters)
  
  If FileSize(GetThothboxPrefFileName(*ThothboxA)) = -1
    CreateThothboxPreferences(*ThothboxA)
  Else
    OpenThothboxPreferences(*ThothboxA)
  EndIf
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; We load the language file after we have loaded the prefs 
  ; file to make sure we work with the user preferences.
  
  LoadLanguageFile(GetThothboxLanguage(*ThothboxA))
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; We verify the windows position loaded from the prefs file
  ; to make sure that the window will open correctly and shown
  ; in the Desktop area.
  
  VerifyWindowPosition(GetThothboxWindow(*ThothboxA))
  
  CompilerSelect #PB_Compiler_OS
      
    CompilerCase #PB_OS_Windows 
      LoadFont(#Font_Text_Search, "Arial", 16)
      
    CompilerCase #PB_OS_Linux
      LoadFont(#Font_Text_Search, "Ubuntu", 16)
      
    CompilerCase #PB_OS_MacOS
      LoadFont(#Font_Text_Search, "Arial", 16)
      
  CompilerEndSelect
  
  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  ; Now we catch Logo
  
  CatchImage(#Image_Logo, ?Logo)

  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; Création du fichier *.desktop nécessaire au système linux pour
    ; intégrer le programme à l'affichage dans l'interface et à
    ; ajouter le programme dans le menu du principal du système. À 
    ; noter que lors de la compilation le fichier *.desktop est généré
    ; mais le chemin d'accès pour l'icône du programme ainsi que le 
    ; répertoire de travail ne sont pas les bons, il faut supprimer le 
    ; fichier manuellement et laisser la version stable de ThothBox 
    ; générer un nouveau fichier correct. Ceci est important uniquement
    ; pour les développeur sous Linux. L'utilisateur final n'y verra 
    ; rien du tout.
    
    InitializeDesktop(Desktop.Desktop, "", #Program_Name + ".desktop")
    
    AddDesktopEntryElement(Desktop, "Type", "Application")
    AddDesktopEntryElement(Desktop, "Exec", "'" + GetPathPart(ProgramFilename()) + "'")
    AddDesktopEntryElement(Desktop, "Name", #Program_Name)
    AddDesktopEntryElement(Desktop, "Comment", "Gestionnaire de partage de Code Source PureBasic")
    AddDesktopEntryElement(Desktop, "NoDisplay", "true")
    AddDesktopEntryElement(Desktop, "Icon", GetPathPart(ProgramFilename()) + "gfx/ibis.png")
    
    CreateDesktopFile(Desktop)
    ResetDesktop(Desktop)
    
  CompilerEndIf 
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Routine de fermeture du programme <<<<<

Procedure ShutDownThothbox(*ThothboxA.Thothbox)
  
  GetWindowCurrentPosition(#MainWin, GetThothboxWindow(*ThothboxA))
  CreateThothboxPreferences(*ThothboxA)
  CloseWindow(#MainWin)
  ResetThothbox(*ThothboxA)
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< SwitchThothboxDisplayMode <<<<<

Procedure SwitchThothboxDisplayMode(*ThothboxA.Thothbox, P_DisplayMode.b)
  
  SetThothboxDisplayMode(*ThothboxA, P_DisplayMode)
  
  Select GetThothboxDisplayMode(*ThothboxA)
      
    Case #Container_Window_Search
      HideGadget(#Container_Window_Search, 0)
      HideGadget(#Container_Window_View, 1)
      HideGadget(#Container_Window_Prefs, 1)
      
    Case #Container_Window_View
      HideGadget(#Container_Window_Search, 1)
      HideGadget(#Container_Window_View, 0)
      HideGadget(#Container_Window_Prefs, 1)
      
    Case #Container_Window_Prefs
      HideGadget(#Container_Window_Search, 1)
      HideGadget(#Container_Window_View, 1)
      HideGadget(#Container_Window_Prefs, 0)
      
  EndSelect

EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< SwitchThothboxLanguage <<<<<

Procedure SwitchThothboxLanguage(*ThothboxA.Thothbox)

  SetLanguageFileName(GetThothboxLanguage(*ThothboxA), FindLanguageFileName(GetLanguagePath(GetThothboxLanguage(*ThothboxA)), GetGadgetText(#ComboBox_Prefs_Language)))
  LoadLanguageFile(GetThothboxLanguage(*ThothboxA))
  FreeMenu(#Menu) 
  CreateLanguageImageMenu(GetThothboxLanguage(*ThothboxA))
  Language_To_GUI(GetThothboxLanguage(*ThothboxA))
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< ThothboxToggleConnectionStatus <<<<<

Procedure ThothboxToggleConnectionStatus(*ThothboxA.Thothbox, P_FirstShot.b = #False)
  
  If P_FirstShot = #True
    Language_To_StatusBar(GetThothboxLanguage(*ThothboxA), TwinStateToggleStatus(GetThothboxConnectionStatus(*ThothboxA), #True))
  Else
    
    If ToggleServerConnection(GetThothboxConnection(*ThothboxA)) = #True
      Language_To_StatusBar(GetThothboxLanguage(*ThothboxA), TwinStateToggleStatus(GetThothboxConnectionStatus(*ThothboxA)))
    Else
      LanguageErrorMessage(GetThothboxLanguage(*ThothboxA), #LANGUAGE_ERROR_SERVER_CONNECTION_IMPOSSIBLE)
    EndIf
    
  EndIf 
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< ThothboxSelectResult <<<<<

Procedure ThothboxSelectResult(*ThothboxA.Thothbox)
  
  ; Cette instruction n'est pas complète pour le moment.
  ; elle ne fait passer au mode de visualisation
  ; Il faut ajouter la recherche dans la ListIcon
  
  If EventType() = #PB_EventType_LeftDoubleClick
    SwitchThothboxDisplayMode(*ThothboxA, #Container_Window_View)
  EndIf
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< WaitWindowEvent_ThothboxConnectionAutoLogout <<<<<

Procedure WaitWindowEvent_ThothboxConnectionAutoLogout(*ThothboxA.Thothbox)
  
  If GetConnectionUseAutoLogout(GetThothboxConnection(*ThothboxA)) = #True
    
    If ConnectionAutoLogoutControl(GetThothboxConnection(*ThothboxA)) = #True
      TwinStateForceStatus(GetThothboxConnectionStatus(*ThothboxA), 0)
      Language_To_StatusBar(GetThothboxLanguage(*ThothboxA), 0)
    EndIf
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; on force une scrutation toute les 10 secondes 
    ; s'il n'y a pas d'événement provenant de la 
    ; fenètre
    
    WindowEventID = WaitWindowEvent(10000) 
    
  Else
    
    WindowEventID = WaitWindowEvent() 
    
  EndIf
  
  ProcedureReturn WindowEventID
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Redimensionnement de la fenètre principale <<<<<

Procedure ResizeThothboxWindow()

  ; Redimmensionnement du #Ctn_Search_Window
  ResizeGadget(#Container_Window_Search, #PB_Ignore, #PB_Ignore, WindowWidth(#MainWin) - 4, WindowHeight(#MainWin) - 4)
  
  ResizeGadget(#Image_logo, (WindowWidth(#MainWin) - 4 - ImageWidth(#Image_logo)) >> 1, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeSearchGadget(#Text_Search, (WindowWidth(#MainWin) - 404) >> 1, GadgetDown(#Image_Logo) + 5, 200, #PB_Ignore)
  ResizeGadget(#ListIcon_Result, #PB_Ignore, GadgetDown(#Text_search) + 25, WindowWidth(#MainWin) - 50,  WindowHeight(#MainWin) - GadgetDown(#Text_Search) - 145)
  
  ;-mode_viewWindow Resize
;   ResizeGadget(#Ctn_View_Window, 0, 0, WindowWidth(#Main_Win), WindowHeight(#Main_Win))
;   ResizeGadget(#Pan_Tab, 50, 150, WindowWidth(#Main_Win) - 100, WindowHeight(#Main_Win) - 200)
;   ResizeGadget(#Btn_compile, GadgetX(#Panel), GadgetY(#Panel) - 20, 100, #GadgetHeight)
;   ResizeGadget(#ListIcon_Historic, WindowWidth(#MainWin) - GadgetWidth(#ListIcon_Historic) - 50, 50, #PB_Ignore, GadgetY(#Pan_Tab) - GadgetY(#ListIcon_Historic))
;   
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Ouverture de la fenètre principale <<<<<

Procedure OpenThothboxWindow(*ThothboxA.Thothbox)
  
  If CreateWindow(#MainWin, GetThothboxWindow(*ThothboxA), "", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget)
    
    CreateLanguageImageMenu(GetThothboxLanguage(*ThothboxA))
    
    If CreateStatusBar(#StatusBar, WindowID(#MainWin))
      AddStatusBarField(#PB_Ignore)
    EndIf
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; On force une dimension minimale pour la grandeur de la fenêtre
    
    WindowBounds(#MainWin, 500, 375, #PB_Ignore, #PB_Ignore)
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; Search Window Mode Gadgets
    
    ContainerGadget(#Container_Window_Search, 2, 2, WindowWidth(#MainWin) - 4, WindowHeight(#MainWin) - 4)
      
      ButtonImageGadget(#Button_Connection_Status, 16, 16, 48, 48, 0)
      
      ImageGadget(#Image_Logo, (WindowWidth(#MainWin) - 4 - ImageWidth(#Image_Logo)) >> 1, 5, ImageWidth(#Image_Logo), ImageHeight(#Image_Logo), ImageID(#Image_Logo))
      SearchGadget(#Text_Search, (WindowWidth(#MainWin) - 404) >> 1, GadgetDown(#Image_Logo) + 5, 200, #GadgetHeight)
      
      If IsFont(#Font_Text_Search) <> 0
        SetGadgetFont(#Text_Search, FontID(#Font_Text_Search))
      EndIf
      
      ListIconGadget(#ListIcon_Result, 25, GadgetDown(#Text_Search) + 25, WindowWidth(#MainWin) - 50,  WindowHeight(#MainWin) - GadgetDown(#Text_Search) - 145, "", 400, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
      AddGadgetColumn(#ListIcon_Result, 1, "", 100)
      AddGadgetColumn(#ListIcon_Result, 2, "", 100)
      AddGadgetColumn(#ListIcon_Result, 3, "", 100)
      AddGadgetColumn(#ListIcon_Result, 4, "", 100)
      
    CloseGadgetList()
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; View Window Mode Gadgets
    
    ContainerGadget(#Container_Window_View, 2, 2, WindowWidth(#MainWin) - 4, WindowHeight(#MainWin) - 4)
      
      ButtonGadget(#Button_View_Back, 2, 2, 100, #GadgetHeight, "")
      
      TextGadget(#Text_Title, 50, GadgetDown(#Button_View_Back) + #GadgetSpacing, 50, #GadgetHeight, "")
      StringGadget(#String_Title, GadgetRight(#Text_Title), GadgetY(#Text_Title), 250, #GadgetHeight, "http download memory")
      
      TextGadget(#Text_Author, GadgetX(#Text_Title), GadgetDown(#Text_Title) + #GadgetSpacing, 50, #GadgetHeight, "")
      StringGadget(#String_Author, GadgetRight(#Text_Author), GadgetY(#Text_Author), 250, #GadgetHeight, "Bidule")

      PanelGadget(#Panel, 2, GadgetDown(#Text_Author) + #GadgetSpacing, WindowWidth(#MainWin) - 8, 400)
        AddGadgetItem(#Panel, 0,"Tab 01")
        AddGadgetItem(#Panel, 1,"Tab 02")
        AddGadgetItem(#Panel, 2,"Tab 03")
        AddGadgetItem(#Panel, 3,"Tab 04")
      CloseGadgetList()
      
      ProgressBarGadget(#ProgressBar_Download,  2,GadgetDown(#Panel) + #GadgetSpacing, WindowWidth(#MainWin) - 8,  #GadgetHeight, 0, 1000, #PB_ProgressBar_Smooth)
      SetGadgetState(#ProgressBar_Download, 50)
      
       ;  ButtonGadget(#Btn_Compile, GadgetX(#Pan_Tab), GadgetY(#Pan_Tab) - 20, 100, 20, "")
      ;       
      ;       ListIconGadget(#ListIcon_Historic,  0,  0, 300, 300, "", 75, #PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
      ;       AddGadgetColumn(#ListIcon_Historic, 1, "", 75)
      ;       AddGadgetColumn(#ListIcon_Historic, 2, "", 145)
      ;       
      ;       AddGadgetItem(#ListIcon_Historic, 0, "2011/10/01" + Chr(10) + "Thyphoon" + Chr(10) + "Pb 4.60 compatible code")
      ;       AddGadgetItem(#ListIcon_Historic, 1, "2007/12/03" + Chr(10) + "Bidule" + Chr(10) + "Pb 4.00 compatible code")
      ;       AddGadgetItem(#ListIcon_Historic, 2, "2004/17/02" + Chr(10) + "Bidule" + Chr(10) + "optimized code")
      ;       AddGadgetItem(#ListIcon_Historic, 3, "2004/16/02" + Chr(10) + "Bidule" + Chr(10) + "Pb 3.95 code")
       
    CloseGadgetList()
    
    ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    ; Preference Mode Gadgets
    
    ContainerGadget(#Container_Window_Prefs, 2, 2, WindowWidth(#MainWin) - 4, WindowHeight(#MainWin) - 4)
      
      ButtonGadget(#Button_Prefs_Back, 2, 2, 100, #GadgetHeight, "")
      Frame3DGadget(#Frame_Connection, 4, GadgetDown(#Button_Prefs_Back) + #GadgetSpacing, 400, 140, "")
      TextGadget(#Text_Prefs_Connection, GadgetX(#Frame_Connection) + 10, GadgetY(#Frame_Connection) + #GadgetHeight, 120, #GadgetHeight, "")
      StringGadget(#String_Prefs_Connection, GadgetRight(#Text_Prefs_Connection), GadgetY(#Text_Prefs_Connection), 200, #GadgetHeight, "")
      ButtonGadget(#Button_Prefs_Connection_Test, GadgetRight(#String_Prefs_Connection) + #GadgetSpacing, GadgetY(#Text_Prefs_Connection), 60, #GadgetHeight, "")
      
      CheckBoxGadget(#CheckBox_UseAutoLogout, GadgetX(#Frame_Connection) + 10, GadgetDown(#Button_Prefs_Connection_Test) + #GadgetSpacing, 250, #GadgetHeight, "")
      TextGadget(#Text_AutoLogout_Time, GadgetX(#CheckBox_UseAutoLogout), GadgetDown(#CheckBox_UseAutoLogout) + #GadgetSpacing, 120, #GadgetHeight, "")
      TextGadget(#Text_AutoLogout_Time_State, GadgetRight(#Text_AutoLogout_Time), GadgetY(#Text_AutoLogout_Time), 200, #GadgetHeight, "")
      TrackBarGadget(#TrackBar_AutoLogout_Time, GadgetX(#Text_AutoLogout_Time), GadgetDown(#Text_AutoLogout_Time) + #GadgetSpacing, 380, #GadgetHeight, 5, 60)

      Frame3DGadget(#Frame_Proxy, 4, GadgetDown(#Frame_Connection) + #GadgetSpacing, 400, 180, "")
      CheckBoxGadget(#CheckBox_UseProxy, GadgetX(#Frame_Proxy) + 10,  GadgetY(#Frame_Proxy) + #GadgetHeight, 250, #GadgetHeight, "") 
      TextGadget(#Text_ProxyHost, GadgetX(#CheckBox_UseProxy), GadgetDown(#CheckBox_UseProxy) + #GadgetSpacing, 120, #GadgetHeight, "")
      StringGadget(#String_ProxyHost, GadgetRight(#Text_ProxyHost) + 10, GadgetY(#Text_ProxyHost), 250, #GadgetHeight, "")
      TextGadget(#Text_ProxyLogin, GadgetX(#CheckBox_UseProxy), GadgetDown(#Text_ProxyHost) + #GadgetSpacing, 120, #GadgetHeight, "")
      StringGadget(#String_ProxyLogin, GadgetRight(#Text_ProxyLogin) + 10, GadgetY(#Text_ProxyLogin), 250, #GadgetHeight, "")
      TextGadget(#Text_ProxyPassword, GadgetX(#CheckBox_UseProxy), GadgetDown(#Text_ProxyLogin) + #GadgetSpacing, 120, #GadgetHeight, "")
      StringGadget(#String_ProxyPassword, GadgetRight(#Text_ProxyPassword) + 10, GadgetY(#Text_ProxyPassword), 250, #GadgetHeight, "")
      TextGadget(#Text_ProxyPort, GadgetX(#CheckBox_UseProxy), GadgetDown(#Text_ProxyPassword) + #GadgetSpacing, 60, #GadgetHeight, "")
      SpinGadget(#Spin_ProxyPort, GadgetRight(#Text_ProxyPort) + 10, GadgetY(#Text_ProxyPort), 80, #GadgetHeight, 0, 9999, #PB_Spin_Numeric)
      Frame3DGadget(#Frame_Language, 4, GadgetDown(#Frame_Proxy) + #GadgetSpacing, 400, 60, "")
      ComboBoxGadget(#ComboBox_Prefs_Language, GadgetX(#Frame_Language) + 10,  GadgetY(#Frame_Language) + #GadgetHeight, 380, #GadgetHeight)

    CloseGadgetList()
    
    SwitchThothboxDisplayMode(*ThothboxA, GetThothboxDisplayMode(*ThothboxA))
    
    Language_To_GUI(GetThothboxLanguage(*ThothboxA))
    Connection_To_GUI(GetThothboxConnection(*ThothboxA))
    
    ScanLanguageFolder(GetThothboxLanguage(*ThothboxA))
    
    ThothboxToggleConnectionStatus(*ThothboxA, #True)
    
  EndIf
  
EndProcedure 

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< Gestion des évènements <<<<<

Procedure ThothboxEventManager(*ThothboxA.Thothbox)

  Repeat
    
    WindowEventID = WaitWindowEvent_ThothboxConnectionAutoLogout(*ThothboxA)
    
    Select WindowEventID

      Case #PB_Event_Menu
      
        Select EventMenu()
            
          Case #Menu_About
            OpenCreditWindow(GetThothboxCreditWindow(*ThothboxA), GetThothboxLanguage(*ThothboxA))
            
          Case #Menu_Configuration
            SwitchThothboxDisplayMode(*ThothboxA, #Container_Window_Prefs)
            
            
          Case #Menu_Quit
            WindowEventID = #PB_Event_CloseWindow
            
        EndSelect
        
      Case #PB_Event_Gadget
        
        Select EventGadget()
            
          Case #ListIcon_Result
            ThothboxSelectResult(*ThothboxA)
            
          Case #Button_Prefs_Back
            GUI_To_Connection(GetThothboxConnection(*ThothboxA))
            SwitchThothboxDisplayMode(*ThothboxA, #Container_Window_Search)
  
          Case #Button_View_Back
            SwitchThothboxDisplayMode(*ThothboxA, #Container_Window_Search)
            
          Case #Button_Connection_Status
            ThothboxToggleConnectionStatus(*ThothboxA)
            
          Case #ComboBox_Prefs_Language
            SwitchThothboxLanguage(*ThothboxA)
            
          Case #CheckBox_UseProxy
            DisableDependentGadget(#CheckBox_UseProxy, #String_ProxyPassword)
            
          Case #CheckBox_UseAutoLogout
            DisableDependentGadget(#CheckBox_UseAutoLogout, #TrackBar_AutoLogout_Time)
            
          Case #TrackBar_AutoLogout_Time
            SetGadgetText(#Text_AutoLogout_Time_State, Str(GetGadgetState(#TrackBar_AutoLogout_Time)))
            
        EndSelect
        
      Case #PB_Event_SizeWindow 
        ResizeThothboxWindow()
 
    EndSelect
    
  Until WindowEventID = #PB_Event_CloseWindow
  
  ShutDownThothbox(*ThothboxA)
  
EndProcedure

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 586
; FirstLine = 490
; Folding = ---fH3-
; EnableXP