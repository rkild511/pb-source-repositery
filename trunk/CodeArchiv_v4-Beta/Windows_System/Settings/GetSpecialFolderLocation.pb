; German forum: http://www.purebasic.fr/german/viewtopic.php?t=767&highlight=
; Author: FloHimself (updated for PB 4.00 by Andre)
; Date: 04. November 2004
; OS: Windows
; Demo: No


; Funktion zur Abfrage von Systemordnern (wie z.B. Favoriten, Dokumente, Verlauf u.s.w.) 

;This code was originally written by Dev Ashish. 
;It is not to be altered or distributed, 
;except as part of an application. 
;You are free to use it in any application, 
;provided the copyright notice is left unchanged. 
; 
;Code Courtesy of 
;Dev Ashish 
; 
;   The following table outlines the different DLL versions, 
;   and how they were distributed. 
; 
;   Version     DLL             Distribution Platform 
;   4.00        All             Microsoft® Windows® 95/Windows NT® 4.0. 
;   4.70        All             Microsoft® Internet Explorer 3.x. 
;   4.71        All             Microsoft® Internet Explorer 4.0 
;   4.72        All             Microsoft® Internet Explorer 4.01 and Windows® 98 
;   5.00        Shlwapi.dll     Microsoft® Internet Explorer 5 
;   5.00        Shell32.dll     Microsoft® Windows® 2000. 
;   5.80        Comctl32.dll    Microsoft® Internet Explorer 5 
;   5.81        Comctl32.dll    Microsoft® Windows 2000 
; 
; 

;   © Microsoft. Information copied from Microsoft;s 
;   Platform SDK Documentation in MSDN 
;   (http://msdn.microsoft.com) 
; 
;   If a special folder does not exist, you can force it to be 
;   created by using the following special CSIDL: 
;   (Version 5.0) 

#CSIDL_FLAG_CREATE = $8000 

;   Combine this CSIDL with any of the CSIDLs listed below 
;   to force the creation of the associated folder. 

;   The remaining CSIDLs correspond to either file system or virtual folders. 
;   Where the CSIDL identifies a file system folder, a commonly used path 
;   is given as an example. Other paths may be used. Some CSIDLs can be 
;   mapped to an equivalent %VariableName% environment variable. 
;   CSIDLs are much more reliable, however, and should be used if at all possible. 

;   File system directory that is used to store administrative tools for an individual user. 
;   The Microsoft Management Console will save customized consoles to 
;   this directory and it will roam with the user. 
;   (Version 5.0) 
#CSIDL_ADMINTOOLS = $30 

;   File system directory that corresponds to the user;s 
;   nonlocalized Startup program group. 
#CSIDL_ALTSTARTUP = $1D 

;   File system directory that serves as a common repository for application-specific 
;   data. A typical path is C:\Documents and Settings\username\Application Data. 
;   This CSIDL is supported by the redistributable ShFolder.dll for systems that do 
;   not have the Internet Explorer 4.0 integrated shell installed. 
;   (Version 4.71) 
#CSIDL_APPDATA = $1A 

;   Virtual folder containing the objects in the user;s Recycle Bin. 
#CSIDL_BITBUCKET = $A 

;   File system directory containing containing administrative tools 
;   for all users of the computer. 
;   Version 5 
#CSIDL_COMMON_ADMINTOOLS = $2F 

;   File system directory that corresponds to the nonlocalized Startup program 
;   group for all users. Valid only for Windows NT® systems. 
#CSIDL_COMMON_ALTSTARTUP = $1E 

;   Application data for all users. A typical path is 
;   C:\Documents and Settings\All Users\Application Data. 
;   Version 5 
#CSIDL_COMMON_APPDATA = $23 

;   File system directory that contains files and folders that appear on the 
;   desktop for all users. A typical path is C:\Documents and Settings\All Users\Desktop. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_DESKTOPDIRECTORY = $19 

;   File system directory that contains documents that are common to all users. 
;   A typical path is C:\Documents and Settings\All Users\Documents. 
;   Valid for Windows NT® systems and Windows 95 and Windows 98 
;   systems with Shfolder.dll installed. 
#CSIDL_COMMON_DOCUMENTS = $2E 

;   File system directory that serves as a common repository for all users; favorite items. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_FAVORITES = $1F 

;   File system directory that contains the directories for the common program 
;   groups that appear on the Start menu for all users. A typical path is 
;   C:\Documents and Settings\All Users\Start Menu\Programs. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_PROGRAMS = $17 

;   File system directory that contains the programs and folders that appear on 
;   the Start menu for all users. A typical path is 
;   C:\Documents and Settings\All Users\Start Menu. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_STARTMENU = $16 

;   File system directory that contains the programs that appear in the 
;   Startup folder for all users. A typical path is 
;   C:\Documents and Settings\All Users\Start Menu\Programs\Startup. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_STARTUP = $18 

;   File system directory that contains the templates that are available to all users. 
;   A typical path is C:\Documents and Settings\All Users\Templates. 
;   Valid only for Windows NT® systems. 
#CSIDL_COMMON_TEMPLATES = $2D 

;   Virtual folder containing icons for the Control Panel applications. 
#CSIDL_CONTROLS = $3 

;   File system directory that serves as a common repository for Internet cookies. 
;   A typical path is C:\Documents and Settings\username\Cookies. 
#CSIDL_COOKIES = $21 

;   Windows Desktop—virtual folder that is the root of the namespace.. 
#CSIDL_DESKTOP = $0 

;   File system directory used to physically store file objects on the desktop 
;   (not to be confused with the desktop folder itself). 
;   A typical path is C:\Documents and Settings\username\Desktop 
#CSIDL_DESKTOPDIRECTORY = $10 

;   My Computer—virtual folder containing everything on the local computer: 
;   storage devices, printers, and Control Panel. The folder may 
;   also contain mapped network drives. 
#CSIDL_DRIVES = $11 

;   File system directory that serves as a common repository for the user;s 
;   favorite items. A typical path is C:\Documents and Settings\username\Favorites. 
#CSIDL_FAVORITES = $6 

;   Virtual folder containing fonts. A typical path is C:\WINNT\Fonts. 
#CSIDL_FONTS = $14 

;   File system directory that serves as a common repository for 
;   Internet history items. 
#CSIDL_HISTORY = $22 

;   Virtual folder representing the Internet. 
#CSIDL_INTERNET = $1 

;   File system directory that serves as a common repository for 
;   temporary Internet files. A typical path is 
;   C:\Documents and Settings\username\Temporary Internet Files. 
#CSIDL_INTERNET_CACHE = $20 

;   File system directory that serves as a data repository for local 
;   (non-roaming) applications. A typical path is 
;   C:\Documents and Settings\username\Local Settings\Application Data. 
;   Version 5 
#CSIDL_LOCAL_APPDATA = $1C 

;   My Pictures folder. A typical path is 
;   C:\Documents and Settings\username\My Documents\My Pictures. 
;   Version 5 
#CSIDL_MYPICTURES = $27 

;   A file system folder containing the link objects that may exist in the 
;   My Network Places virtual folder. It is not the same as CSIDL_NETWORK, 
;   which represents the network namespace root. A typical path is 
;   C:\Documents and Settings\username\NetHood. 
#CSIDL_NETHOOD = $13 

;   Network Neighborhood—virtual folder representing the 
;   root of the network namespace hierarchy. 
#CSIDL_NETWORK = $12 

;   File system directory that serves as a common repository for documents. 
;   A typical path is C:\Documents and Settings\username\My Documents. 
#CSIDL_PERSONAL = $5 

;   Virtual folder containing installed printers. 
#CSIDL_PRINTERS = $4 

;   File system directory that contains the link objects that may exist in the 
;   Printers virtual folder. A typical path is 
;   C:\Documents and Settings\username\PrintHood. 
#CSIDL_PRINTHOOD = $1B 

;   User;s profile folder. 
;   Version 5 
#CSIDL_PROFILE = $28 

;   Program Files folder. A typical path is C:\Program Files. 
;   Version 5 
;#CSIDL_PROGRAM_FILES = $2A 

;   A folder for components that are shared across applications. A typical path 
;   is C:\Program Files\Common. 
;   Valid only for Windows NT® and Windows® 2000 systems. 
;   Version 5 
#CSIDL_PROGRAM_FILES_COMMON = $2B 

;   Program Files folder that is common to all users for x86 applications 
;   on RISC systems. A typical path is C:\Program Files (x86)\Common. 
;   Version 5 
#CSIDL_PROGRAM_FILES_COMMONX86 = $2C 

;   Program Files folder for x86 applications on RISC systems. Corresponds 
;   to the %PROGRAMFILES(X86)% environment variable. 
;   A typical path is C:\Program Files (x86). 
;   Version 5 
#CSIDL_PROGRAM_FILESX86 = $2A 

;   File system directory that contains the user;s program groups (which are 
;   also file system directories). A typical path is 
;   C:\Documents and Settings\username\Start Menu\Programs. 
#CSIDL_PROGRAMS = $2 

;   File system directory that contains the user;s most recently used documents. 
;   A typical path is C:\Documents and Settings\username\Recent. 
;   To create a shortcut in this folder, use SHAddToRecentDocs. In addition to 
;   creating the shortcut, this function updates the shell;s list of recent documents 
;   and adds the shortcut to the Documents submenu of the Start menu. 
#CSIDL_RECENT = $8 

;   File system directory that contains Send To menu items. A typical path is 
;   C:\Documents and Settings\username\SendTo. 
#CSIDL_SENDTO = $9 

;   File system directory containing Start menu items. 
;   A typical path is C:\Documents and Settings\username\Start Menu. 
#CSIDL_STARTMENU = $B 

;   File system directory that corresponds to the user;s Startup program group. 
;   The system starts these programs whenever any user logs onto Windows NT® or 
;   starts Windows® 95. A typical path is 
;   C:\Documents and Settings\username\Start Menu\Programs\Startup. 
#CSIDL_STARTUP = $7 

;   System folder. A typical path is C:\WINNT\SYSTEM32. 
;   Version 5 
#CSIDL_SYSTEM = $25 

;   System folder for x86 applications on RISC systems. 
;   A typical path is C:\WINNT\SYS32X86. 
;   Version 5 
#CSIDL_SYSTEMX86 = $29 

;   File system directory that serves as a common repository 
;   for document templates. 
#CSIDL_TEMPLATES = $15 

;   Version 5.0. Windows directory or SYSROOT. This corresponds to the %windir% 
;   or %SYSTEMROOT% environment variables. A typical path is C:\WINNT. 
#CSIDL_WINDOWS = $24 

#NOERROR = 0 

#MAX_PATH = 260 

Procedure.s GetSpecialFolderLocation(lngCSIDL.l) 
;   Returns path To a special folder on the machine 
; 
;   Refer to the comments in declarations for OS and 
;   IE dependent CSIDL values. 

  Protected lngRet.l 
  Protected strLocation.s 
  Protected pidl.l 
  
  strLocation = Space(#MAX_PATH) 

; retrieve a PIDL for the specified location 
  lngRet = SHGetSpecialFolderLocation_(0, lngCSIDL, @pidl) 
  
  If lngRet = #NOERROR 
;   convert the pidl to a physical path 
    SHGetPathFromIDList_(pidl, @strLocation) 
    If lngRet = #NOERROR 
;     If successful, Return the location 
      ProcedureReturn RTrim(strLocation) 
    EndIf        
;   calling application is responsible for freeing the allocated memory 
;   for pidl when calling SHGetSpecialFolderLocation. We have to 
;   call IMalloc::Release, but to get to IMalloc, a tlb is required. 
; 
;   According to Kraig Brockschmidt in Inside OLE,   CoTaskMemAlloc, 
;   CoTaskMemFree, and CoTaskMemRealloc take the same parameters 
;   as the interface functions and internally call CoGetMalloc, the 
;   appropriate IMalloc function, and then IMalloc::Release. 
    CoTaskMemFree_(pidl) 
  EndIf 
EndProcedure 

; TEST CALL 
Debug GetSpecialFolderLocation(#CSIDL_FAVORITES)

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -