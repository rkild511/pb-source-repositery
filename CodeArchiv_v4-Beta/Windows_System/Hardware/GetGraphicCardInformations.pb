; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8904&highlight=
; Author: Hi-Toro (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm + Andre)
; Date: 27. December 2003
; OS: Windows
; Demo: No


; This returns video driver information (name of gfx card, memory, driver version, etc).
; It's been written for, and briefly tested on, Windows 9x and XP (should work on all
; NTs in theory)... 


; Stuff required by GetSystemFolder ()... 

#CSIDL_SYSTEM = $25 

; Returns System folder (but doesn't seem to find C:\Windows\System on 9x, hence GetWindows9xRoot () below!)... 

Procedure.s GetSystemFolder (folder) 
    *itemid.ITEMIDLIST = #Null 
    If SHGetSpecialFolderLocation_ (0, folder, @*itemid) = #NOERROR 
        location$ = Space (#MAX_PATH) 
        If SHGetPathFromIDList_ (*itemid, @location$) 
            ProcedureReturn location$ 
        EndIf 
    EndIf 
EndProcedure 

; Returns path to Windows folder on Windows 9x (eg. "C:\Windows")... 

Procedure.s GetWindows9xRoot () 
    If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 
        If  RegQueryValueEx_ (vidkey, "SystemRoot", #Null, #Null, #Null, @Size) = #ERROR_SUCCESS 
            device$ = Space (Size) 
            RegQueryValueEx_ (vidkey, "SystemRoot", #Null, #Null, @device$, @Size) 
            ; device$ now contains driver name or ""... 
        EndIf 
        RegCloseKey_ (vidkey) 
    EndIf 
    ProcedureReturn device$ 
EndProcedure 

; Windows 9x or NT? Returns #VER_PLATFORM_WIN32_NT (NT, 2000, XP, etc) or #VER_PLATFORM_WIN32_WINDOWS (95, 98)... 

Procedure GetWindowsFamily () 
    Define.OSVERSIONINFO os 
    os\dwOSVersionInfoSize = SizeOf (OSVERSIONINFO) 
    GetVersionEx_ (@os) 
    ProcedureReturn os\dwPlatformId 
EndProcedure 

; Name of primary video driver... 

Procedure.s VideoDriver () 

    Select GetWindowsFamily () 
    
        Case #VER_PLATFORM_WIN32_NT 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "HARDWARE\DEVICEMAP\VIDEO", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    firstvid$ = Space (size) 

                    If RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, @firstvid$, @size) = #ERROR_SUCCESS 

                        If LCase (Left (firstvid$, 18)) = "\registry\machine\" 
                            firstdev$ = Right (firstvid$, Len (firstvid$) - 18) 
                        EndIf 

                        If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, firstdev$, 0, #KEY_READ, @devkey) = #ERROR_SUCCESS 

                            If  RegQueryValueEx_ (devkey, "Device Description", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 
                                device$ = Space (size) 
                                RegQueryValueEx_ (devkey, "Device Description", #Null, #Null, @device$, @size) 
                                ; Name is now in device$, or ""... 
                            EndIf 

                            RegCloseKey_ (devkey) 

                        EndIf 

                    EndIf 
                
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

        Case #VER_PLATFORM_WIN32_WINDOWS 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "DriverDesc", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    device$ = Space (size) 

                    RegQueryValueEx_ (vidkey, "DriverDesc", #Null, #Null, @device$, @size) 

                    ; device$ now contains driver name or ""... 
                    
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

    EndSelect 
    
    ProcedureReturn device$ 
    
EndProcedure 

; Returns primary video memory in bytes (use 'result / 1024 / 1024' for MB)... 

Procedure VideoMemory () 

    Select GetWindowsFamily () 
    
        Case #VER_PLATFORM_WIN32_NT 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "HARDWARE\DEVICEMAP\VIDEO", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    firstvid$ = Space (size) 

                    If RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, @firstvid$, @size) = #ERROR_SUCCESS 

                        If LCase (Left (firstvid$, 18)) = "\registry\machine\" 
                            firstdev$ = Right (firstvid$, Len (firstvid$) - 18) 
                        EndIf 

                        If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, firstdev$, 0, #KEY_READ, @devkey) = #ERROR_SUCCESS 

                            RegQueryValueEx_ (devkey, "HardwareInformation.MemorySize", #Null, #Null, @totalmem, @size) 
                            
                            ; totalmem contains memory size or 0... 
                            
                            RegCloseKey_ (devkey) 

                        EndIf 

                    EndIf 
                
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

        Case #VER_PLATFORM_WIN32_WINDOWS 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000\INFO", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "VideoMemory", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    firstvid$ = Space (size) 

                    RegQueryValueEx_ (vidkey, "VideoMemory", #Null, #Null, @totalmem, @size) 
                    
                    ; totalmem contains memory size or 0... 
                
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

    EndSelect 
    
    ProcedureReturn totalmem 
    
EndProcedure 

; Returns the actual video driver file name... 

Procedure.s VideoDriverDLL () 

    Select GetWindowsFamily () 
    
        Case #VER_PLATFORM_WIN32_NT 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "HARDWARE\DEVICEMAP\VIDEO", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    firstvid$ = Space (size) 

                    If RegQueryValueEx_ (vidkey, "\Device\Video0", #Null, #Null, @firstvid$, @size) = #ERROR_SUCCESS 

                        If LCase (Left (firstvid$, 18)) = "\registry\machine\" 
                            firstdev$ = Right (firstvid$, Len (firstvid$) - 18) 
                        EndIf 

                        If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, firstdev$, 0, #KEY_READ, @devkey) = #ERROR_SUCCESS 

                            If  RegQueryValueEx_ (devkey, "InstalledDisplayDrivers", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 
                                device$ = Space (size) 
                                If RegQueryValueEx_ (devkey, "InstalledDisplayDrivers", #Null, #Null, @device$, @size) = #ERROR_SUCCESS 
                                    device$ = GetSystemFolder (#CSIDL_SYSTEM) + "\" + device$ + ".dll" 
                                EndIf 
                            EndIf 

                            RegCloseKey_ (devkey) 

                        EndIf 

                    EndIf 
                
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

        Case #VER_PLATFORM_WIN32_WINDOWS 
        
            If RegOpenKeyEx_ (#HKEY_LOCAL_MACHINE, "System\CurrentControlSet\Services\Class\Display\0000\DEFAULT", 0, #KEY_READ, @vidkey) = #ERROR_SUCCESS 

                If  RegQueryValueEx_ (vidkey, "drv", #Null, #Null, #Null, @size) = #ERROR_SUCCESS 

                    device$ = Space (size) 

                    RegQueryValueEx_ (vidkey, "drv", #Null, #Null, @device$, @size) 

                    device$ = GetWindows9xRoot () + "\SYSTEM\" + device$ 
                    ; device$ now contains driver name or ""... 
                    
                EndIf 
                
                RegCloseKey_ (vidkey) 

            EndIf 

    EndSelect 
    
    ProcedureReturn device$ 
    
EndProcedure 

; Gets file version info. I've forgotten whose code this is -- it's not mine! Please let me know... 

Procedure.s GetVersionInfo (file$, getinfo$) 

    ;     getinfo$ = "FileDescription" 
    ;     getinfo$ = "ProductVersion" 
    ;     getinfo$ = "ProductName" 
    ;     getinfo$ = "CompanyName" 
    ;     getinfo$ = "LegalCopyright" 
    ;     getinfo$ = "Comments" 
    ;     getinfo$ = "FileVersion" 
    ;     getinfo$ = "InternalName" 
    ;     getinfo$ = "LegalTrademarks" 
    ;     getinfo$ = "PrivateBuild" 
    ;     getinfo$ = "SpecialBuild" 
    ;     getinfo$ = "Language" 

    info$="" 

    If FileSize (file$) > 0 

        zero = 10 

        If OpenLibrary (1, "version.dll") 

            length = CallFunction (1, "GetFileVersionInfoSizeA", file$, @zero) 

            If length 

                mem1 = AllocateMemory (length) 

                If mem1 

                    result = CallFunction (1, "GetFileVersionInfoA", file$, 0, length, mem1) 

                    If result 

                        infobuffer = 0 
                        infolen = 0 

                        getinfo$ = "\\StringFileInfo\\040904B0\\" + getinfo$ 
                        result = CallFunction (1, "VerQueryValueA", mem1, getinfo$, @infobuffer, @infolen) 

                        If result 
                            info$ = PeekS (infobuffer) 
                        EndIf 

                    EndIf 

                    FreeMemory (mem1) 

                EndIf 

            EndIf 

            CloseLibrary (1) 

        EndIf 

    EndIf  

ProcedureReturn info$ 

EndProcedure 

; ----------------------------------------------------------------------------- 
; D E M O . . . 
; ----------------------------------------------------------------------------- 

; Get manufacturer name from video driver DLL... 

manufacturer$ = GetVersionInfo (VideoDriverDLL (), "CompanyName") 
If manufacturer$ = "" 
    manufacturer$ = "[Not found]" 
EndIf 

info$ = "Manufacturer: " + manufacturer$ + Chr (10) + Chr (10) 

; Get video driver name (generally graphics card name)... 

video$ = VideoDriver () 
If video$ = "" 
    video$ = "[Not found]" 
EndIf 

info$ = info$ + "Video driver: " + video$ + Chr (10) 

; Get graphics memory... 

memory = VideoMemory () / 1024 / 1024 
If memory 
    mem$ = "Video memory: " + Str (memory) + " MB" 
Else 
    mem$ = "[Not found]" 
EndIf 

info$ = info$ + mem$ + Chr (10) + Chr (10) 

; Get name of video driver file... 

videodll$ = VideoDriverDLL () 
If videodll$ = "" 
    videodll$ = "[Not found]" 
EndIf 

info$ = info$ + "Video driver file: " + videodll$ + Chr (10) 

; Get version number of video driver... 

videoversion$ = GetVersionInfo (VideoDriverDLL (), "FileVersion") 
If videoversion$ = "" 
    videoversion$ = "[Not found]" 
EndIf 

info$ = info$ + "Video driver version: " + videoversion$ 

; Boing! 

MessageRequester ("Main video driver information", info$, #MB_ICONINFORMATION) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --