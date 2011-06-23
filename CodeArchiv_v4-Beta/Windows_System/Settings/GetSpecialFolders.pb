; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13916&highlight=
; Author: DoubleDutch
; Date: 04. February 2005
; OS: Windows
; Demo: No


; If no version number is specified, the programming element is implemented in all versions. The following table outlines the different DLL versions, And how they were distributed. 

; Version  DLL  Distribution Platform 
; 4.00 All          Microsoft® Windows® 95/Windows NT® 4.0. 
; 4.70 All          Microsoft® Internet Explorer 3.x. 
; 4.71 All          Microsoft® Internet Explorer 4.0 (see note 2). 
; 4.72 All          Microsoft® Internet Explorer 4.01 And Windows® 98 (see note 2). 
; 5.00 Shlwapi.dll  Microsoft® Internet Explorer 5 (see note 3). 
; 5.00 Shell32.dll  Microsoft® Windows® 2000. (see note 3). 
; 5.80 Comctl32.dll Microsoft® Internet Explorer 5 (see note 3). 
; 5.81 Comctl32.dll Microsoft® Windows 2000 And Windows ME (see note 3). 
; 6.00 Comctl32.dll Microsoft® Windows XP. See note 4. 

; Note 1: 
; The 4.00 versions of Shell32.dll And Comctl32.dll are found on the original versions of Windows 95 And Windows NT 4. New versions of Commctl.dll were shipped with all Internet Explorer releases. Shlwapi.dll first shipped with Internet Explorer 4.0, so its first version number is 4.71. The Shell was not updated with the Internet Explorer 3.0 release, so Shell32.dll does not have a version 4.70. While Shell32.dll versions 4.71 And 4.72 were shipped with the corresponding Internet Explorer releases, they were not necessarily installed (see note 2). For subsequent releases, the version numbers For the three DLLs are not identical. In general, you should assume that all three DLLs may have different version numbers, And test each one separately. 

; Note 2: 
; All systems with Internet Explorer 4.0 Or 4.01 will have the associated version of Comctl32.dll And Shlwapi.dll (4.71 Or 4.72, respectively). However, For systems prior To Windows 98, Internet Explorer 4.0 And 4.01 can be installed with Or without the integrated Shell. If they are installed with the integrated Shell, the associated version of Shell32.dll will be installed. If they are installed without the integrated Shell, Shell32.dll is not updated. In other words, the presence of version 4.71 Or 4.72 of Comctl32.dll Or Shlwapi.dll on a system does not guarantee that Shell32.dll has the same version number. All Windows 98 systems have version 4.72 of Shell32.dll. 

; Note 3: 
; Version 5.80 of Comctl32.dll And version 5.0 of Shlwapi.dll are distributed with Internet Explorer 5. They will be found on all systems on which Internet Explorer 5 is installed, except Windows 2000. Internet Explorer 5 does not update the Shell, so version 5.0 of Shell32.dll will not be found on Windows NT, Windows 95, Or Windows 98 systems. Version 5.0 of Shell32.dll will be distributed with Windows 2000 And Windows Me, along with version 5.0 of Shlwapi.dll, And version 5.81 of Comctl32.dll. 

; Note 4: 
; ComCtl32.dll version 6 is not redistributable. If you want your application To use ComCtl32.dll version 6, you must add an application manifest that indicates that version 6 should be used If it is available. 
  
; Unknown at present: 
; $0f, $32, $33, $34, $3c 

#CSIDL_DESKTOP=$00                  ; Windows desktop—virtual folder that is the root of the name space. 
#CSIDL_INTERNET=$01                 ; Virtual folder that represents the Internet. 
#CSIDL_PROGRAMS=$02                 ; File system directory that contains the user's program groups (which are also file system directories). A typical path is C:\Documents and Settings\username\Start Menu\Programs. 
#CSIDL_CONTROLS=$03                 ; Control Panel - virtual folder containing icons for the control panel applications. 
#CSIDL_PRINTERS=$04                 ; Printers folder - virtual folder containing installed printers. 
#CSIDL_PERSONAL=$05                 ; File system directory that serves as a common repository for documents. A typical path is C:\Documents and Settings\username\My Documents. This is different from the My Documents virtual folder in the name space. To access that virtual folder, use the technique described in Managing the File System. 
#CSIDL_FAVORITES=$06                ; File system directory that serves as a common repository for the user's favourite items. A typical path is C:\Documents and Settings\username\Favorites. (Version 6.0. This is equivalent to CSIDL_MYDOCUMENTS) 
#CSIDL_STARTUP=$07                  ; File system directory that corresponds to the user's Startup program group. The system starts these programs whenever any user logs onto Microsoft® Windows NT® or starts Microsoft® Windows® 98. A typical path is C:\Documents and Settings\username\Start Menu\Programs\Startup 
#CSIDL_RECENT=$08                   ; File system directory that contains the user's most recently used documents. A typical path is C:\Documents and Settings\username\Recent. To create a shortcut in this folder, use SHAddToRecentDocs. In addition to creating the shortcut, this function updates the Shell's list of recent documents and adds the shortcut to the Documents submenu of the Start menu. 
#CSIDL_SENDTO=$09                   ; File system directory that contains Send To menu items. A typical path is C:\Documents and Settings\username\SendTo. 
#CSIDL_BITBUCKET=$0a                ; Virtual folder that contains the objects in the user's Recycle Bin. 
#CSIDL_STARTMENU=$0b                ; File system directory that contains Start Menu items. A typical path is C:\Documents and Settings\username\Start Menu. 
#CSIDL_MYDOCUMENTS=$0c              ; Virtual folder that contains the objects in the user's My Documents folder. 
#CSIDL_MYMUSIC=$0d                  ; File system directory that serves as a common repository for music files. A typical path is C:\My Music. 
#CSIDL_MYVIDEO=$0e                  ; File system directory that serves as a common repository for video files. 
#CSIDL_DESKTOPDIRECTORY=$10         ; File system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself). A typical path is C:\Documents and Settings\username\Desktop 
#CSIDL_DRIVES=$11                   ; My Computer - virtual folder containing everything on the local computer: storage devices, printers, and Control Panel. The folder may also contain mapped network drives. 
#CSIDL_NETWORK=$12                  ; Network Neighborhood—virtual folder that represents the root of the network namespace hierarchy. 
#CSIDL_NETHOOD=$13                  ; A file system folder that contains the link objects that can exist in the My Network Places virtual folder. It is not the same as CSIDL_NETWORK, which represents the network namespace root. A typical path is C:\Documents and Settings\username\NetHood. 
#CSIDL_FONTS=$14                    ; Virtual folder that contains fonts. A typical path is C:\WINNT\Fonts. 
#CSIDL_TEMPLATES=$15                ; File system directory that serves as a common repository for document templates. 
#CSIDL_COMMON_STARTMENU=$16         ; File system directory that contains the programs and folders that appear on the Start Menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu. Valid only for Windows NT systems. 
#CSIDL_COMMON_PROGRAMS=$17          ; File system directory that contains the directories for the common program groups that appear in the Start Menu for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs. Valid only for Windows NT systems. 
#CSIDL_COMMON_STARTUP=$18           ; File system directory that contains the programs that appear in the Startup folder for all users. A typical path is C:\Documents and Settings\All Users\Start Menu\Programs\Startup. Valid only for Windows NT systems. 
#CSIDL_COMMON_DESKTOPDIRECTORY=$19  ; File system directory that contains files and folders that appear on the desktop for all users. A typical path is C:\Documents and Settings\All Users\Desktop. Valid only for Windows NT systems. 
#CSIDL_APPDATA=$1a                  ; Version 4.71. File system directory that serves as a common repository for application-specific data. A typical path is C:\Documents and Settings\username\Application Data. This CSIDL is supported by the redistributable ShFolder.dll for systems that do not have the Microsoft® Internet Explorer 4.0 integrated Shell installed. 
#CSIDL_PRINTHOOD=$1b                ; File system directory that contains the link objects that can exist in the Printers virtual folder. A typical path is C:\Documents and Settings\username\PrintHood. 
#CSIDL_LOCAL_APPDATA=$1c            ; Version 5.0. File system directory that serves as a data repository for local (nonroaming) applications. A typical path is C:\Documents and Settings\username\Local Settings\Application Data. 
#CSIDL_ALTSTARTUP=$1d               ; File system directory that corresponds to the user's nonlocalized Startup program group. 
#CSIDL_COMMON_ALTSTARTUP=$1e        ; File system directory that corresponds to the nonlocalized Startup program group for all users. Valid only for Windows NT systems. 
#CSIDL_COMMON_FAVORITES=$1f         ; File system directory that serves as a common repository for all user's favorite items. Valid only for Windows NT systems. 
#CSIDL_INTERNET_CACHE=$20           ; Version 4.72. File system directory that serves as a common repository for temporary Internet files. A typical path is C:\Documents and Settings\username\Temporary Internet Files. 
#CSIDL_COOKIES=$21                  ; File system directory that serves as a common repository for Internet cookies. A typical path is C:\Documents and Settings\username\Cookies. 
#CSIDL_HISTORY=$22                  ; File system directory that serves as a common repository for Internet history items. 
#CSIDL_COMMON_APPDATA=$23           ; Version 5.0. Application data for all users. A typical path is C:\Documents and Settings\All Users\Application Data. 
#CSIDL_WINDOWS=$24                  ; Version 5.0. Windows directory or SYSROOT. This corresponds to the %windir% or %SYSTEMROOT% environment variables. A typical path is C:\WINNT. 
#CSIDL_SYSTEM=$25                   ; Version 5.0. System folder. A typical path is C:\WINNT\SYSTEM32. 
#CSIDL_PROGRAM_FILES=$26            ; Version 5.0. Program Files folder. A typical path is C:\Program Files. 
#CSIDL_MYPICTURES=$27               ; Version 5.0. My Pictures folder. A typical path is C:\Documents and Settings\username\My Documents\My Pictures. 
#CSIDL_PROFILE=$28                  ; Version 5.0. User's profile folder. 
#CSIDL_SYSTEMX86=$29                ; The x86 system directory on Reduced Instruction Set Computer (RISC) systems. 
#CSIDL_PROGRAM_FILESX86=$2a         ; The x86 Program Files folder on RISC systems. 
#CSIDL_PROGRAM_FILES_COMMON=$2b     ; Version 5.0. A folder for components that are shared across applications. A typical path is C:\Program Files\Common. Valid only for Windows NT and Windows 2000 systems. 
#CSIDL_PROGRAM_FILES_COMMONX86=$2c  ; The x86 Program Files Common folder on RISC systems. 
#CSIDL_COMMON_TEMPLATES=$2d         ; File system directory that contains the templates that are available to all users. A typical path is C:\Documents and Settings\All Users\Templates. Valid only for Windows NT systems. 
#CSIDL_COMMON_DOCUMENTS=$2e         ; File system directory that contains documents that are common to all users. Typical paths are C:\Documents and Settings\All Users\Documents. Valid for Windows NT systems and Windows 95 and Windows 98 systems with Shfolder.dll installed 
#CSIDL_COMMON_ADMINTOOLS=$2f        ; Version 5.0. File system directory that contains administrative tools for all users. 
#CSIDL_ADMINTOOLS=$30               ; Version 5.0. File system directory used to store administrative tools for an individual user. The Microsoft Management Console (MMC) saves customized consoles to this directory, and it roams with the user. 
#CSIDL_CONNECTIONS=$31              ; Virtual folder that contains network and dial-up connections. 
#CSIDL_COMMON_MUSIC=$35             ; Version 6.0. My Music folder for all users. 
#CSIDL_COMMON_PICTURES=$36          ; Version 6.0. My Pictures folder for all users. 
#CSIDL_COMMON_VIDEO=$37             ; Version 6.0. My Video folder for all users. 
#CSIDL_RESOURCES=$38                ; System resource directory. A typical path is C:\WINNT\Resources. 
#CSIDL_RESOURCES_LOCALIZED=$39      ; Localized resource directory. 
#CSIDL_COMMON_OEM_LINKS=$3a         ; Folder containing links to OEM specific applications for all users 
#CSIDL_CDBURN_AREA=$3b              ; Version 6.0. File system folder used to hold data for burning to a CD. Typically [User Profile Folder]\Local Settings\Applications Data\Microsoft\CD Burning. 
#CSIDL_COMPUTERSNEARME=$3d          ; Computers Near Me folder. Virtual folder that contains links to nearby computers on the network. Nearness it is established by common work group membership 
#CSIDL_PROFILES=$3e                 ; Version 6.0. The file system directory containing user profile folders. A typical path is C:\Documents and Settings. 

#CSIDL_FLAG_PER_USER_INIT=$800      ; Combine this flag with the desired CSIDL_ value to indicate per-user initialization. 
#CSIDL_FLAG_NO_ALIAS=$1000          ; Combine this flag with the desired CSIDL_ value to force a non-alias version of the PIDL. 
#CSIDL_FLAG_DONT_VERIFY=$4000       ; Combine this flag with the desired CSIDL_ value to return an unverified folder path. 
#CSIDL_FLAG_CREATE=$8000            ; Version 5.0. Combine this flag with the desired CSIDL_ value to force the creation of the associated folder. 
#CSIDL_FLAG_MASK=$FF00              ; Mask for all possible CSIDL flag values 

Procedure.s SpecialFolder(folderno) 
  listptr=0 
  result$=Space(270) 
  SHGetSpecialFolderLocation_(0,folderno,@listptr) 
  SHGetPathFromIDList_(listptr,@result$) 
  ProcedureReturn Trim(result$) 
EndProcedure 

Debug("#CSIDL_DESKTOP:"+SpecialFolder(#CSIDL_DESKTOP)) 
Debug("#CSIDL_COMMON_PICTURES:"+SpecialFolder(#CSIDL_COMMON_PICTURES)) 
Debug("#CSIDL_PROGRAMS:"+SpecialFolder(#CSIDL_PROGRAMS)) 
Debug("#CSIDL_HISTORY:"+SpecialFolder(#CSIDL_HISTORY)) 


MessageRequester("Program Files",SpecialFolder(#CSIDL_COMMON_PROGRAMS)) 
 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -