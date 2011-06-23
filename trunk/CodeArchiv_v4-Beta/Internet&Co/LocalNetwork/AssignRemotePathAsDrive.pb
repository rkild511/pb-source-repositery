; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9471&highlight=
; Author: Hi-Toro (updated for PB 4.00 by Andre)
; Date: 27. February 2004
; OS: Windows
; Demo: No

; Using a browser window to create a 'drive' assigned to the remote path... 

; Assign remote path to drive (eg. "Z:")... 

If WNetConnectionDialog_ (0, #RESOURCETYPE_DISK) = #NO_ERROR 

    ; Have a look... go on... 
    
    MessageRequester ("Cool!", "Look for the drive in My Computer now!", #MB_ICONINFORMATION) 
    
    ; Remove assigned drive... 
    
    WNetDisconnectDialog_ (0, #RESOURCETYPE_DISK) 

Else 

    MessageRequester ("Cool!", "Couldn't connect -- check paths and network!", #MB_ICONWARNING) 

EndIf 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -