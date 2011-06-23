; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5151&highlight=
; Author: Hi-Toro (adapted for PB3.70 by Rings, updated for PB 4.00 by Andre)
; Date: 14. June 2003
; OS: Windows
; Demo: No

Procedure.s GetNetworkComputer (parentwindow, title$) 
  
  ; Note: take a look at the Win32 docs for SHBrowseForFolder, as you can easily 
  ; modify this function to return printers, etc... 
  #CSIDL_NETWORK = $12 
  ; Weird Windows structure (holds an internal reference to a folder location, I think)... 
  Structure EMID 
    cb.b 
    abID.b[1] 
  EndStructure 
  
  
  ; Create an item, whatever that may be, and stuff the required location into it... 
  itemid.ITEMIDLIST 
  
  If SHGetSpecialFolderLocation_ (0, #CSIDL_NETWORK, @itemid) = #NOERROR 
    
    ; Create a BROWSEINFO structure and zero it (there's probably a quicker way to do this  
    Define.BROWSEINFO bi 
    For b = 0 To SizeOf (BROWSEINFO) - 1 
      PokeB (@bi + b, 0) 
    Next 
    
    ; Create a buffer for the computer name to be placed in... 
    computer$ = Space (#MAX_PATH) 
    
    ; Fill in the structure... 
    bi\hwndOwner = parentwindow 
    bi\pidlRoot = *itemid 
    bi\pszDisplayName = @computer$ 
    bi\lpszTitle = @title$ 
    bi\ulFlags = #BIF_BROWSEFORCOMPUTER 
    
    ; Show the browser dialog... 
    pidl = SHBrowseForFolder_ (@bi) 
    
  EndIf 
  ; Set the computer name to "" if there's nothing returned... 
  If computer$ = Space (#MAX_PATH) 
    computer$ = "" 
  EndIf 
  
  ProcedureReturn computer$ 
  
EndProcedure 

Procedure.s GetNetworkComputerIP (computer$) 
  
  If computer$ 
    
    ; Create WSA version number (damn, ugly!)... 
    high.b = 1: low.b = 1 
    Define.w wsaversion 
    PokeB (@wsaversion, high) ; Gotta poke major version number into low byte... 
    PokeB (@wsaversion + 1, low) ; ... and minor version number into high byte 
    
    ; Try to access Windows sockets stuff... 
    If WSAStartup_ (wsaversion, wsa.WSAData) = #NOERROR 
      ; Get host information for named computer... 
      *host.HOSTENT = gethostbyname_ (computer$) 
      If *host <> #Null 
        ; Get IP address of named computer... 
          IP$ = PeekS (inet_ntoa_ (PeekL (*host\h_addr_list))) 
      EndIf 
      ; Close Windows sockets stuff... 
      WSACleanup_ () 
    EndIf 
    ProcedureReturn IP$ 
    
  EndIf 
  
EndProcedure 

; D E M O . . . 

; Show network computer selection dialog (note that '0' can be replaced by a window handle)... 

pc$ = GetNetworkComputer (0, "Select a local computer...") 

If pc$ 
  ; Get IP address of selected computer... 
  IP$ = GetNetworkComputerIP (pc$) 
  MessageRequester ("Selected PC...", "You selected " + pc$ + ", at IP address " + IP$, #MB_ICONINFORMATION) 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
