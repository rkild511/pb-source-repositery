; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8182&highlight=
; Author: Hi-Toro (updated for PB3.93 by ts-soft, updated for PB 4.00 by Andre)
; Date: 06. November 2003
; OS: Windows
; Demo: No


; Well, let's see if this works for everyone (MSDN says it works on all
; versions of Windows with IE4.0+)... 

; The default demo code just lists the files, so don't be afraid! 

; More info here for anyone who wants to explore further: 
; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wininet/wininet/wininet_functions.asp 


; ----------------------------------------------------------------------------- 
; Internet Explorer cache file enumeration (with optional deletion)... 
; ----------------------------------------------------------------------------- 
; james @ hi - toro . com 
; ----------------------------------------------------------------------------- 

; Cache entry structure... 

Structure INTERNET_CACHE_ENTRY_INFO 
    dwStructSize.l 
    lpszSourceUrlName.s 
    lpszLocalFileName.s 
    CacheEntryType.l 
    dwUseCount.l 
    dwHitRate.l 
    dwSizeLow.l 
    dwSizeHigh.l 
    LastModifiedTime.FILETIME 
    ExpireTime.FILETIME 
    LastAccessTime.FILETIME 
    LastSyncTime.FILETIME 
    *lpHeaderInfo.l 
    dwHeaderInfoSize.l 
    lpszFileExtension.s 
    StructureUnion 
        dwReserved.l 
        dwExemptDelta.l 
    EndStructureUnion 
EndStructure 

; Library number we'll use for wininet.dll... 

#WININET = 9998 

Procedure ListCacheEntries (delete) 

    ; Open wininet.dll... 

    If OpenLibrary (#WININET, "wininet.dll") 

        ; First call must fail in order to get size required for structure's buffer (fbuffsize)... 
        
        enum = CallFunction (#WININET, "FindFirstUrlCacheEntryA", #Null, @fail, @fbuffsize) 
        
        If enum = #Null 
        
            ; Need larger buffer... 
            
            If GetLastError_ () = #ERROR_INSUFFICIENT_BUFFER 
            
                ; Allocate a buffer of the required size, with cache entry structure... 
                    
                *ic.INTERNET_CACHE_ENTRY_INFO = AllocateMemory (fbuffsize) 
                
                ; Try again with new size and buffer... 
                
                enum = CallFunction (#WININET, "FindFirstUrlCacheEntryA", #Null, *ic.INTERNET_CACHE_ENTRY_INFO, @fbuffsize) 
                
                If enum <> #Null 
                
                    ; Got first cache entry! 
                        
                    Debug *ic\lpszSourceUrlName    ; URL 
                    Debug *ic\lpszLocalFileName     ; Local cache file 

                    ; Delete cache entry if delete parameter = #TRUE... 

                    If delete 
                        If CallFunction (#WININET, "DeleteUrlCacheEntry", *ic\lpszSourceUrlName) 
                            Debug "(Deleted)" 
                        Else 
                            Debug "(Failed to delete)" 
                        EndIf 
                    EndIf 
                    
                    Debug "" 

                    ; Release the buffer... 
                    
                    FreeMemory (*ic.INTERNET_CACHE_ENTRY_INFO) 

                    ; Now iterate through the rest... 
                    
                    *ic = #Null ; Being a good citizen since I intend to use this pointer again... 
                    
                    Repeat 

                        ; *ic is #NULL on the first call, and nbuffsize is 0 (it will be given correct value if there is an entry)... 
                        
                        result = CallFunction (#WININET, "FindNextUrlCacheEntryA", enum, *ic.INTERNET_CACHE_ENTRY_INFO, @nbuffsize) 

                        If result = #False 

                            ; Failed, so was it due to insufficient buffer, or end of cache entries? 
                            
                            error = GetLastError_ () 

                            Select error 

                                Case #ERROR_NO_MORE_ITEMS 

                                    ; End of cache entries -- 'done' variable is used to exit Repeat... Until loop... 

                                    done = #True 

                                Case #ERROR_INSUFFICIENT_BUFFER 

                                    ; nbuffsize was 0, so allocate buffer (FindNextUrlCacheEntryA gave nbuffsize the correct value)... 
                                    
                                    *ic.INTERNET_CACHE_ENTRY_INFO = AllocateMemory (nbuffsize) 

                                    ; (This will then hit 'Until' and go back to 'Repeat', calling the function with a buffer, plus correct nbuffsize.) 
                                    
                            EndSelect 

                        Else 

                            ; FindNextUrlCacheEntryA returned #TRUE in 'result' variable... 
                            
                            Debug *ic\lpszSourceUrlName 
                            Debug *ic\lpszLocalFileName 

                            ; Delete cache entry if delete parameter = #TRUE... 
                            
                            If delete 
                                If CallFunction (#WININET, "DeleteUrlCacheEntry", *ic\lpszSourceUrlName) 
                                    Debug "(Deleted)" 
                                Else 
                                    Debug "(Failed to delete)" 
                                EndIf 
                            EndIf 
                            
                            Debug "" 

                            ; Free this buffer now... 
                            
                            FreeMemory (*ic.INTERNET_CACHE_ENTRY_INFO) 
                            
                            ; Reset nbuffsize to 0 so next FindNextUrlCacheEntryA will fail and allocate buffer as before... 
                            
                            nbuffsize = 0 

                        EndIf 

                    Until done 
                    
                    ; Release cache enumeration handle... 

                    CallFunction (#WININET, "FindCloseUrlCache", enum) 
                    
                EndIf 
                
            EndIf 
            
        EndIf 

        ; Close wininet.dll... 
        
        CloseLibrary (#WININET) 
        
    EndIf 

EndProcedure 

; D E M O . . . 

; Pass '1' instead to delete all cache files (use at own risk, but works fine here!)... 

ListCacheEntries (0) 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -