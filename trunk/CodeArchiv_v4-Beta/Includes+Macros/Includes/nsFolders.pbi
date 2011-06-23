; English forum: 
; Author: Alberto Gonzalez
; Date: 20. February 2004
; OS: Windows
; Demo: Yes

XIncludeFile "nsConstants.pbi"

;=================================================================
; PureBasic routines to retrieve special Microsoft Windows
; folders like My Documents or Desktop
;
; Version 1.0 	2004 Feb 20      initial release for PureBasic
;
; EMail: support@nomscon.com
; URL: http://www.nomscon.com
;
;-- License/Terms and Conditions ---------------------------------
; This code is free for all to use without acknowledging the
; author, Alberto Gonzalez. Use this code as you see fit. By
; using or compiling this code or derivative thereof, you are
; consenting to hold the author, Alberto Gonzalez, harmless
; for all effects or side-effects of its use.
;
; In other words, this code works for me, but you are using it
; at your own risk.
;
; All support of this code will be provided (or not provided)
; at the discretion of the author and with no guarantee as to
; the accuracy or timeliness of any response. But I;ll do my
; best.
;
;=================================================================

;-- Folder Ids
#CSIDL_SYSTEM = $25
#CSIDL_WINDOWS = $24

#CSIDL_NETHOOD = $13
#CSIDL_PRINTHOOD = $1B

#CSIDL_ADMINTOOLS = $30
#CSIDL_APPDATA = $1A
#CSIDL_COOKIES = $21
#CSIDL_DESKTOP = 0
#CSIDL_FAVORITES = 6
#CSIDL_FONTS = $14
#CSIDL_HISTORY = $22
#CSIDL_INTERNET_CACHE = $20
#CSIDL_LOCAL_APPDATA = $1C
#CSIDL_MYMUSIC = $D                 ; XP Only?
#CSIDL_MYPICTURES = $27
#CSIDL_MYVIDEO = $E                 ; XP Only?
#CSIDL_PERSONAL = 5
#CSIDL_PROFILE = $28
#CSIDL_PROGRAMS = 2
#CSIDL_PROGRAM_FILES = $26
#CSIDL_RECENT = 8
#CSIDL_SENDTO = 9
#CSIDL_STARTMENU = $B
#CSIDL_STARTUP = 7
#CSIDL_TEMPLATES = $15

#CSIDL_COMMON_ADMINTOOLS = $2F
#CSIDL_COMMON_APPDATA = $23
#CSIDL_COMMON_DESKTOPDIRECTORY = $19
#CSIDL_COMMON_DOCUMENTS = $2E
#CSIDL_COMMON_FAVORITES = $1F
#CSIDL_COMMON_MUSIC = $35           ; XP Only?
#CSIDL_COMMON_PICTURES = $36        ; XP Only?
#CSIDL_PROGRAM_FILES_COMMON = $2B
#CSIDL_COMMON_PROGRAMS = $17
#CSIDL_COMMON_STARTMENU = $16
#CSIDL_COMMON_STARTUP = $18
#CSIDL_COMMON_TEMPLATES = $2D
#CSIDL_COMMON_VIDEO = $37           ; XP Only?

Procedure.s nsFldrFromId(folderId.l)
    Protected result.s
    Protected pidl.l

    result = Space(#MAXFILELEN)
    pidl = #Null

    SHGetSpecialFolderLocation_(0, folderId, @pidl)
    SHGetPathFromIDList_(pidl, @result)
    CoTaskMemFree_(pidl)

    ProcedureReturn result
EndProcedure

;-- System Info
Procedure.s nsFldrSystem()
    ProcedureReturn nsFldrFromId(#CSIDL_SYSTEM)
EndProcedure
Procedure.s nsFldrWindows()
    ProcedureReturn nsFldrFromId(#CSIDL_WINDOWS)
EndProcedure

Procedure.s nsFldrNetworkHood()
    ProcedureReturn nsFldrFromId(#CSIDL_NETHOOD)
EndProcedure
Procedure.s nsFldrPintHood()
    ProcedureReturn nsFldrFromId(#CSIDL_PRINTHOOD)
EndProcedure

;-- User Info
Procedure.s nsFldrAdminTools()
    ProcedureReturn nsFldrFromId(#CSIDL_ADMINTOOLS)
EndProcedure
Procedure.s nsFldrAppData()
    ProcedureReturn nsFldrFromId(#CSIDL_APPDATA)
EndProcedure
Procedure.s nsFldrCookies()
    ProcedureReturn nsFldrFromId(#CSIDL_COOKIES)
EndProcedure
Procedure.s nsFldrDesktop()
    ProcedureReturn nsFldrFromId(#CSIDL_DESKTOP)
EndProcedure
Procedure.s nsFldrFavorites()
    ProcedureReturn nsFldrFromId(#CSIDL_FAVORITES)
EndProcedure
Procedure.s nsFldrFonts()
    ProcedureReturn nsFldrFromId(#CSIDL_FONTS)
EndProcedure
Procedure.s nsFldrHistory()
    ProcedureReturn nsFldrFromId(#CSIDL_HISTORY)
EndProcedure
Procedure.s nsFldrInternetCache()
    ProcedureReturn nsFldrFromId(#CSIDL_INTERNET_CACHE)
EndProcedure
Procedure.s nsFldrLocalAppData()
    ProcedureReturn nsFldrFromId(#CSIDL_LOCAL_APPDATA)
EndProcedure
Procedure.s nsFldrMyDocuments()
    ProcedureReturn nsFldrFromId(#CSIDL_PERSONAL)
EndProcedure
Procedure.s nsFldrMyMusic()         ; XP Only?
    ProcedureReturn nsFldrFromId(#CSIDL_MYMUSIC)
EndProcedure
Procedure.s nsFldrMyPictures()
    ProcedureReturn nsFldrFromId(#CSIDL_MYPICTURES)
EndProcedure
Procedure.s nsFldrMyVideo()         ; XP Only?
    ProcedureReturn nsFldrFromId(#CSIDL_MYVIDEO)
EndProcedure
Procedure.s nsFldrProfile()
    ProcedureReturn nsFldrFromId(#CSIDL_PROFILE)
EndProcedure
Procedure.s nsFldrProgramFiles()
    ProcedureReturn nsFldrFromId(#CSIDL_PROGRAM_FILES)
EndProcedure
Procedure.s nsFldrPrograms()
    ProcedureReturn nsFldrFromId(#CSIDL_PROGRAMS)
EndProcedure
Procedure.s nsFldrRecent()
    ProcedureReturn nsFldrFromId(#CSIDL_RECENT)
EndProcedure
Procedure.s nsFldrSendTo()
    ProcedureReturn nsFldrFromId(#CSIDL_SENDTO)
EndProcedure
Procedure.s nsFldrStartMenu()
    ProcedureReturn nsFldrFromId(#CSIDL_STARTMENU)
EndProcedure
Procedure.s nsFldrStartUp()
    ProcedureReturn nsFldrFromId(#CSIDL_STARTUP)
EndProcedure
Procedure.s nsFldrTemplates()
    ProcedureReturn nsFldrFromId(#CSIDL_TEMPLATES)
EndProcedure

;-- Common Folders
Procedure.s nsFldrCommonAdminTools()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_ADMINTOOLS)
EndProcedure
Procedure.s nsFldrCommonAppData()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_APPDATA)
EndProcedure
Procedure.s nsFldrCommonDesktop()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_DESKTOPDIRECTORY)
EndProcedure
Procedure.s nsFldrCommonDocuments()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_DOCUMENTS)
EndProcedure
Procedure.s nsFldrCommonFavorites()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_FAVORITES)
EndProcedure
Procedure.s nsFldrCommonMusic()     ; XP Only?
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_MUSIC)
EndProcedure
Procedure.s nsFldrCommonPictures()  ; XP Only?
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_PICTURES)
EndProcedure
Procedure.s nsFldrCommonProgramFiles()
    ProcedureReturn nsFldrFromId(#CSIDL_PROGRAM_FILES_COMMON)
EndProcedure
Procedure.s nsFldrCommonPrograms()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_PROGRAMS)
EndProcedure
Procedure.s nsFldrCommonStartMenu()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_STARTMENU)
EndProcedure
Procedure.s nsFldrCommonStartUp()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_STARTUP)
EndProcedure
Procedure.s nsFldrCommonTemplates()
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_TEMPLATES)
EndProcedure
Procedure.s nsFldrCommonVideo()     ; XP Only?
    ProcedureReturn nsFldrFromId(#CSIDL_COMMON_VIDEO)
EndProcedure

;-- Demonstration with output to Console
Procedure nsFldrDemo()
    Protected key.s

    If OpenConsole()
        ConsoleColor(14, 0)
        ClearConsole()
        PrintN(">>>>> Demonstration of the nsFldr... Routines <<<<<")
        PrintN("")
        ConsoleColor(15, 0)
        PrintN(">>> System Info Folders")
        PrintN("-----------------------")
        ConsoleColor(10, 0) : Print("System: ")
        ConsoleColor(11, 0) : PrintN(nsFldrSystem())
        ConsoleColor(10,0) : Print("Windows: ")
        ConsoleColor(11,0) : PrintN(nsFldrWindows())
        ConsoleColor(10,0) : Print("Network: ")
        ConsoleColor(11,0) : PrintN(nsFldrNetworkHood())
        ConsoleColor(10,0) : Print("Pinters: ")
        ConsoleColor(11,0) : PrintN(nsFldrPintHood())
        PrintN("")
        ConsoleColor(14, 0)
        Print("Press a key for more folders or Esc to quit > ")
        key = "" : Repeat : key = Inkey() : Until Len(key) > 0
        If Asc(Mid(key, 1, 1)) = 27 : ProcedureReturn : EndIf : PrintN("")
        PrintN("")
        ConsoleColor(15, 0)
        PrintN(">>> User Info Folders")
        PrintN("---------------------")
        ConsoleColor(10,0) : Print("AdminTools: ")
        ConsoleColor(11,0) : PrintN(nsFldrAdminTools())
        ConsoleColor(10,0) : Print("Application Data: ")
        ConsoleColor(11,0) : PrintN(nsFldrAppData())
        ConsoleColor(10,0) : Print("Cookies: ")
        ConsoleColor(11,0) : PrintN(nsFldrCookies())
        ConsoleColor(10,0) : Print("Desktop: ")
        ConsoleColor(11,0) : PrintN(nsFldrDesktop())
        ConsoleColor(10,0) : Print("Favorites: ")
        ConsoleColor(11,0) : PrintN(nsFldrFavorites())
        ConsoleColor(10,0) : Print("Fonts: ")
        ConsoleColor(11,0) : PrintN(nsFldrFonts())
        ConsoleColor(10,0) : Print("History: ")
        ConsoleColor(11,0) : PrintN(nsFldrHistory())
        ConsoleColor(10,0) : Print("InternetCache: ")
        ConsoleColor(11,0) : PrintN(nsFldrInternetCache())
        ConsoleColor(14, 0)
        Print("Press a key for more folders or Esc to quit > ")
        key = "" : Repeat : key = Inkey() : Until Len(key) > 0
        If Asc(Mid(key, 1, 1)) = 27 : ProcedureReturn : EndIf : PrintN("")
        ConsoleColor(10,0) : Print("LocalAppData: ")
        ConsoleColor(11,0) : PrintN(nsFldrLocalAppData())
        ConsoleColor(10,0) : Print("MyDocuments: ")
        ConsoleColor(11,0) : PrintN(nsFldrMyDocuments())
        ConsoleColor(10,0) : Print("MyMusic: ")
        ConsoleColor(11,0) : PrintN(nsFldrMyMusic())
        ConsoleColor(10,0) : Print("MyPictures: ")
        ConsoleColor(11,0) : PrintN(nsFldrMyPictures())
        ConsoleColor(10,0) : Print("MyVideo: ")
        ConsoleColor(11,0) : PrintN(nsFldrMyVideo())
        ConsoleColor(10,0) : Print("Profile: ")
        ConsoleColor(11,0) : PrintN(nsFldrProfile())
        ConsoleColor(10,0) : Print("Program Files: ")
        ConsoleColor(11,0) : PrintN(nsFldrProgramFiles())
        ConsoleColor(10,0) : Print("Programs: ")
        ConsoleColor(11,0) : PrintN(nsFldrPrograms())
        ConsoleColor(10,0) : Print("Recent: ")
        ConsoleColor(11,0) : PrintN(nsFldrRecent())
        ConsoleColor(10,0) : Print("SendTo: ")
        ConsoleColor(11,0) : PrintN(nsFldrSendTo())
        ConsoleColor(10,0) : Print("StartMenu: ")
        ConsoleColor(11,0) : PrintN(nsFldrStartMenu())
        ConsoleColor(10,0) : Print("StartUp: ")
        ConsoleColor(11,0) : PrintN(nsFldrStartUp())
        ConsoleColor(10,0) : Print("Templates: ")
        ConsoleColor(11,0) : PrintN(nsFldrTemplates())
        PrintN("")
        ConsoleColor(14, 0)
        Print("Press a key for more folders or Esc to quit > ")
        key = "" : Repeat : key = Inkey() : Until Len(key) > 0
        If Asc(Mid(key, 1, 1)) = 27 : ProcedureReturn : EndIf : PrintN("")
        PrintN("")
        ConsoleColor(15, 0)
        PrintN(">>> Common Folders")
        PrintN("------------------")
        ConsoleColor(10,0) : Print("AdminTools Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonAdminTools())
        ConsoleColor(10,0) : Print("AppData Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonAppData())
        ConsoleColor(10,0) : Print("Desktop Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonDesktop())
        ConsoleColor(10,0) : Print("Documents Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonDocuments())
        ConsoleColor(10,0) : Print("Favorites Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonFavorites())
        ConsoleColor(10,0) : Print("Music Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonMusic())
        ConsoleColor(10,0) : Print("Pictures Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonPictures())
        ConsoleColor(10,0) : Print("ProgramFiles Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonProgramFiles())
        ConsoleColor(10,0) : Print("Programs Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonPrograms())
        ConsoleColor(10,0) : Print("StartMenu Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonStartMenu())
        ConsoleColor(10,0) : Print("StartUp Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonStartUp())
        ConsoleColor(10,0) : Print("Templates Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonTemplates())
        ConsoleColor(10,0) : Print("Video Folder: ")
        ConsoleColor(11,0) : PrintN(nsFldrCommonVideo())
        PrintN("")
        ConsoleColor(14, 0)
        Print("Press Enter to Continue: ")       
        Input()
        CloseConsole()
    Else
        MessageRequester("nsFldrDemo", "Unable to access console for output!", 0)
    EndIf
EndProcedure

;-- Demo - UnComment the following line run all the available procedures
; nsFldrDemo()

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -------
; DisableDebugger