; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6563&start=45 
; Author: high key (updated for PB 4.00 by ts-soft)
; Date: 26. September 2003 
; OS: Windows 
; Demo: No 

Declare.s GetSpecialfolder(CSIDL) 


#CSIDL_DESKTOP = 0 
#CSIDL_PROGRAMS = 2 
#CSIDL_CONTROLS = 3 
#CSIDL_PRINTERS = 4 
#CSIDL_PERSONAL = 5 
#CSIDL_FAVORITES = 6 
#CSIDL_STARTUP = 7 
#CSIDL_RECENT = 8 
#CSIDL_SENDTO = 9 
#CSIDL_BITBUCKET = $A 
#CSIDL_STARTMENU = $B 
#CSIDL_DESKTOPDIRECTORY = $10 
#CSIDL_DRIVES = $11 
#CSIDL_NETWORK = $12 
#CSIDL_NETHOOD = $13 
#CSIDL_FONTS = $14 
#CSIDL_TEMPLATES = $15 



CompilerIf Defined(shItemID, #PB_Structure) = #False 
  Structure shItemID 
      cb.l 
      abID.b 
  EndStructure 
CompilerEndIf 

CompilerIf Defined(ItemIDlist, #PB_Structure) = #False 
  Structure ItemIDlist 
      mkid.shItemID 
  EndStructure 
CompilerEndIf 


a$= "Start menu folder: " + GetSpecialfolder(#CSIDL_STARTMENU) 
b$= "Favorites folder: " + GetSpecialfolder(#CSIDL_FAVORITES) 
c$= "Programs folder: " + GetSpecialfolder(#CSIDL_PROGRAMS) 
d$= "Desktop folder: " + GetSpecialfolder(#CSIDL_DESKTOP) 
e$= "Startup folder: " + GetSpecialfolder(#CSIDL_STARTUP) 

    
MessageRequester("Info",a$+Chr(13)+b$+Chr(13)+c$+Chr(13)+d$+Chr(13)+e$,0) 

Procedure.s GetSpecialFolder(CSIDL.l) 
  Protected *itemid.ITEMIDLIST = #Null 
  Protected location.s = Space (#MAX_PATH) 

  If SHGetSpecialFolderLocation_ (0, CSIDL, @*itemid) = #NOERROR 
    If SHGetPathFromIDList_ (*itemid, @location) 
      If Right(location, 1) <> "\" : location + "\" : EndIf 
      ProcedureReturn location 
    EndIf 
  EndIf 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
