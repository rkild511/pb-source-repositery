; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9471&highlight=
; Author: Hi-Toro (updated for PB 4.00 by Andre)
; Date: 27. February 2004
; OS: Windows
; Demo: No

; Connecting a remote path as a local 'drive' (appears in My Computer)... 

; CHANGE THESE PATHS TO SUIT! 

remote$ = "\\Vampwillow\Downloads"      ; Remote path 
local$ = "Z:"                                       ; Local drive to be 'created' 

Define.NETRESOURCE res 

res\dwType = #RESOURCETYPE_DISK 
res\lpLocalName = @local$ 
res\lpRemoteName = @remote$ 
res\lpProvider = #Null 

If WNetAddConnection2_ (res, #Null, #Null, 0) = #NO_ERROR 

    MessageRequester ("Cool!", "Connected -- check My Computer!", #MB_ICONINFORMATION) 

    WNetCancelConnection2_ (local$, #CONNECT_UPDATE_PROFILE, 0) 

Else 

    MessageRequester ("Cool!", "Couldn't connect -- check paths and network!", #MB_ICONWARNING) 

EndIf 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -