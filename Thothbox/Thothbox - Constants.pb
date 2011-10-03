; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Nom du projet : Thothbox
; Nom du fichier : Thothbox - Constants.pb
; Version du fichier : 0.0.0
; Programmation : En cours
; Programmé par : Guillaume Saumure
; Alias : Guimauve
; Courriel : gsaumure79@videotron.ca
; Date : 23-09-2011
; Mise à jour : 23-09-2011
; Code PureBasic : 4.60
; Plateforme : Windows, Linux, MacOS X
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#Program_Name = "Thothbox"
#Program_Version  = "0.1." ; + Str(#PB_Editor_BuildCount)

#GadgetHeight = 25
#GadgetSpacing = 4

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Constantes pour les fenêtres su programme

Enumeration
  
  #MainWin
  #CreditWin
  
EndEnumeration

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Constantes pour les menus et bar d'état du programme

Enumeration
  
  #Menu
  #Menu_Quit
  #Menu_About
  #Menu_Configuration
  
  #StatusBar 
  
EndEnumeration

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Constantes pour les Gadgets du programme

Enumeration
  
  #Container_Window_Search
  #Button_Connection_Status
  #Image_Logo
  #Text_Search
  #String_Search
  #ListIcon_Result
  
  
  #Container_Window_View
  #Button_View_Back
  #Text_Title
  #String_Title
  #Text_Author
  #String_Author
  #Panel ; GUIMAUVE : JE NE SAIS À QUOI VA SERVIR CE PANELGADGET, IL FAUDRA CORRIGER LE NOM DE LA CONSTANTE POUR CE DERNIER.
  #ProgressBar_Download
  #Button_Compile
  #ListIcon_Historic
  
  #Container_Window_Prefs
  #Button_Prefs_Back
  #Frame_Connection
  #Text_Prefs_Connection
  #String_Prefs_Connection
  #Button_Prefs_Connection_Test
  
  
  #CheckBox_UseAutoLogout
  #Text_AutoLogout_Time
  #Text_AutoLogout_Time_State
  #TrackBar_AutoLogout_Time
  
  #Frame_Proxy
  
  #CheckBox_UseProxy
  #Text_ProxyHost
  #String_ProxyHost
  #Text_ProxyPort
  #Spin_ProxyPort
  #Text_ProxyLogin
  #String_ProxyLogin
  #Text_ProxyPassword
  #String_ProxyPassword
  
  #Frame_Language
  #ComboBox_Prefs_Language
  
  
  
  #Font_Text_Search
  
  
  #ScrollArea_Credit_Informations
  #Image_Credit_Logo
  #Btn_Credit_Close
  
EndEnumeration

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; Constantes utiles pour la portabilité du code

CompilerSelect #PB_Compiler_OS
    
  CompilerCase #PB_OS_Windows 
    #EOL$ = #CRLF$
    #DirectorySeparator = "\"
    #Operating_System_Name = "Windows"
    
  CompilerCase #PB_OS_Linux   
    #EOL$ = #LF$ 
    #DirectorySeparator = "/"
    #Operating_System_Name = "Linux"
    
    #White = 16777215
    #LightGray = 15132390
    #Gray = 12500670
    #DarkGray = 6908265
    #Red = 255
    #Orange = 32767
    #Gold = 49151
    #Yellow = 65535
    #Green = 65280
    #DarkGreen = 32512
    #Chartreuse = 65407
    #SeaGreen = 32575
    #Aquamarine = 12582783
    #Turquoise = 12566335
    #Blue = 16711680
    #DarkBlue = 12517376
    #Cyan = 16776960
    #Purple = 16711850
    #Lavender = 16760767
    #Magenta = 16711935
    #Brown = 3755147
    #Black = 0
    
  CompilerCase #PB_OS_MacOS
    #EOL$ = #CR$ 
    #DirectorySeparator = "/"
    #Operating_System_Name = "Mac OS"
    
    #White = 16777215
    #LightGray = 15132390
    #Gray = 12500670
    #DarkGray = 6908265
    #Red = 255
    #Orange = 32767
    #Gold = 49151
    #Yellow = 65535
    #Green = 65280
    #DarkGreen = 32512
    #Chartreuse = 65407
    #SeaGreen = 32575
    #Aquamarine = 12582783
    #Turquoise = 12566335
    #Blue = 16711680
    #DarkBlue = 12517376
    #Cyan = 16776960
    #Purple = 16711850
    #Lavender = 16760767
    #Magenta = 16711935
    #Brown = 3755147
    #Black = 0
    
CompilerEndSelect

DataSection
  
  Logo:
  IncludeBinary "gfx" + #DirectorySeparator + "thotbox.png"
  
  OnLine:
  IncludeBinary "gfx" + #DirectorySeparator + "serverOnline.png"
  
  OffLine:
  IncludeBinary "gfx" + #DirectorySeparator + "serverOffline.png"
  
EndDataSection 

; <<<<<<<<<<<<<<<<<<<<<<<<<<
; <<<<< FIN DU FICHIER <<<<<
; <<<<<<<<<<<<<<<<<<<<<<<<<<
; IDE Options = PureBasic 4.60 RC 1 (Linux - x64)
; CursorPosition = 103
; FirstLine = 83
; Folding = -
; EnableXP