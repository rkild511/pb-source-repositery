; English forum: http://www.purebasic.fr/english/viewtopic.php?t=24639
; Author: freak
; Date: 16. November 2006
; OS: Windows
; Demo: No


; Browse network enviroment  
; Netzwerk-Umgebung durchsuchen

; Note: The Network environment is not part of the file system structure. 
; It is part of the shell namespace. 
; Thats why the Explorer type gadgets cannot read it as well. 
; You'll have to get the namespace object for the network environment and 
; examine its properties. 



; Special Shell folders CLSID values: 
; 
; Note: those are "relative" values, so since the control panel is inside 
;       "My Computer", the path to it is actually this: 
;       "::{20d04fe0-3aea-1069-a2d8-08002b30309d}\::{21ec2020-3aea-1069-a2dd-08002b30309d}" 
;       Some can be used directly (like My Network Places), but most need to 
;       be put together with their parents CLSIDs to work. 
; 
; ::{d20ea4e1-3957-11d2-a40b-0c5020524153}  Administrative Tools      
; ::{85bbd920-42a0-1069-a2e4-08002b30309d}    Briefcase     
; ::{21ec2020-3aea-1069-a2dd-08002b30309d}    Control Panel     
; ::{d20ea4e1-3957-11d2-a40b-0c5020524152}    Fonts     
; ::{ff393560-c2a7-11cf-bff4-444553540000}    History     
; ::{00020d75-0000-0000-c000-000000000046}    Inbox     
; ::{00028b00-0000-0000-c000-000000000046}    Microsoft Network     
; ::{20d04fe0-3aea-1069-a2d8-08002b30309d}    My Computer 
; ::{450d8fba-ad25-11d0-98a8-0800361b1103}    My Documents 
; ::{208d2c60-3aea-1069-a2d7-08002b30309d}    My Network Places 
; ::{1f4de370-d627-11d1-ba4f-00a0c91eedba}    Network Computers 
; ::{7007acc7-3202-11d1-aad2-00805fc1270e}    Network Connections 
; ::{2227a280-3aea-1069-a2de-08002b30309d}    Printers And Faxes 
; ::{7be9d83c-a729-4d97-b5a7-1b7313c39e0a}    Programs Folder     
; ::{645ff040-5081-101b-9f08-00aa002f954e}    Recycle Bin 
; ::{e211b736-43fd-11d1-9efb-0000f8757fcd}    Scanners And Cameras     
; ::{d6277990-4c6a-11cf-8d87-00aa0060f5bf}    Scheduled Tasks 
; ::{48e7caab-b918-4e58-a94d-505519c795dc}    Start Menu Folder     
; ::{7bd29e00-76c1-11cf-9dd0-00a0c9034933}    Temporary Internet Files     
; ::{bdeadf00-c265-11d0-bced-00a0c90ab50f}    Web Folders 

; Some stuff that is needed: 
; 
#SHCONTF_FOLDERS             = $0020;   // only want folders enumerated (SFGAO_FOLDER) 
#SHCONTF_NONFOLDERS          = $0040;   // include non folders 
#SHCONTF_INCLUDEHIDDEN       = $0080;   // show items normally hidden 
#SHCONTF_INIT_ON_FIRST_NEXT  = $0100;   // allow EnumObject() To Return before validating enum 
#SHCONTF_NETPRINTERSRCH      = $0200;   // hint that client is looking For printers 
#SHCONTF_SHAREABLE           = $0400;   // hint that client is looking sharable resources (remote shares) 
#SHCONTF_STORAGE             = $0800;   // include all items With accessible storage And their ancestors 

#_SHGDN_NORMAL             = $0000;  // Default (display purpose) 
#_SHGDN_INFOLDER           = $0001;  // displayed under a folder (relative) 
#_SHGDN_FOREDITING         = $1000;  // For in-place editing 
#_SHGDN_FORADDRESSBAR      = $4000;  // UI friendly parsing name (remove ugly stuff) 
#_SHGDN_FORPARSING         = $8000;  // parsing name For ParseDisplayName() 

Structure STRRET 
  uType.l 
  StructureUnion 
   *pOleStr 
    uOffset.l 
    cStr.b[#MAX_PATH] 
  EndStructureUnion 
EndStructure 

#STRRET_WSTR     = 0 
#STRRET_OFFSET   = $1 
#STRRET_CSTR     = $2 

DataSection 

  IID_IShellFolder: ; {000214E6-0000-0000-C000-000000000046} 
    Data.l $000214E6 
    Data.w $0000, $0000 
    Data.b $C0, $00, $00, $00, $00, $00, $00, $46 

EndDataSection 


; Helper function to read the content of the filled STRRET structure 
; correctly, and release any memory it allocated. 
; 
Procedure.s ReadSTRRET(*ret.STRRET) 
  If *ret\uType = #STRRET_WSTR And *ret\pOleStr 
    Result$ = PeekS(*ret\pOleStr, -1, #PB_Unicode) 
    CoTaskMemFree_(*ret\pOleStr) 
    *ret\pOleStr = 0 
        
  ElseIf *ret\uType = #STRRET_OFFSET 
    Result$ = "" ; SDK is not fully clear on how to handle this. 
  
  ElseIf *ret\uType = #STRRET_CSTR 
    Result$ = PeekS(@*ret\cstr[0], #MAX_PATH, #PB_Ascii) 
    
  EndIf 
  
  ProcedureReturn Result$ 
EndProcedure 


; Function to recursively scan a Shell folder up to a maximum level 
; of recursivity (so not the entire file structure is read.) 
; 
Procedure ScanShellFolder(Folder.IShellFolder, Sublevel, MaxSublevel) 

  ; Try to get an enumerator object for the children of this object. 
  ; Play around a bit with the flags to exclude certain objects from the enumeration 
  ; 
  If Folder\EnumObjects(0, #SHCONTF_FOLDERS|#SHCONTF_NONFOLDERS|#SHCONTF_INCLUDEHIDDEN|#SHCONTF_SHAREABLE, @Enum.IEnumIDList) = #S_OK 
  
    ; get the child *idl pointers from the enumerator object 
    ; 
    While Enum\Next(1, @*idl.ITEMIDLIST, 0) = #NOERROR 
      
      ; get the display name for the object 
      ; 
      If Folder\GetDisplayNameOf(*idl, #_SHGDN_NORMAL, @result.STRRET) = #S_OK 
        Name$ = ReadSTRRET(@result) 
      EndIf 

      ; get a "parsable" name for the object 
      ; for files or normal folders, this is a path 
      ; 
      If Folder\GetDisplayNameOf(*idl, #_SHGDN_FORPARSING, @result.STRRET) = #S_OK 
        Path$ = ReadSTRRET(@result) 
      EndIf      
      
      ; add to tree 
      ; 
      AddGadgetItem(0, -1, Name$ + "  (" + Path$ + ")", 0, Sublevel) 
      index = CountGadgetItems(0)-1 
      
      
      If Sublevel <= MaxSublevel  
        ;      
        ; To scan the children of this item as well, we need to get a IShellFolder 
        ; pointer from the *idl value 
        ; 
        If Folder\BindToObject(*idl, 0, ?IID_IShellFolder, @NewFolder.IShellFolder) = #S_OK 
          ; once again a scan 
          ScanShellFolder(NewFolder, Sublevel + 1, MaxSublevel)        
          NewFolder\Release() 
        EndIf                
      EndIf 
      
      SetGadgetItemState(0, index, #PB_Tree_Expanded) 
      
      ; free idl memory 
      CoTaskMemFree_(*idl) 
    Wend 
    
    ; free enumerator object 
    Enum\Release() 
  EndIf 

EndProcedure 

; Code Start 
; 
If OpenWindow(0, 0, 0, 400, 500, "Shell Folders", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  TreeGadget(0, 10, 10, 380, 480) 

  ; To get to a shell folder, we always start with the desktop object, so get it: 
  ;  
  If SHGetDesktopFolder_(@Desktop.IShellFolder) = #NOERROR 

    ; Now parse the CLSID to get to the "My Network Places". 
    ; Try the second line to explore the content of the Control Panel 
    ; 
    If Desktop\ParseDisplayName(0, 0, "::{208d2c60-3aea-1069-a2d7-08002b30309d}", 0, @*idl.ITEMIDLIST, 0) = #S_OK 
    ;If Desktop\ParseDisplayName(0, 0, "::{20d04fe0-3aea-1069-a2d8-08002b30309d}\::{21ec2020-3aea-1069-a2dd-08002b30309d}", 0, @*idl.ITEMIDLIST, 0) = #S_OK 

      ; What we have now is the *idl pointer. This sort of a path in the Shell 
      ; From that we get a new IShellFolder object representing the "My Network Places" 
      ; 
      If Desktop\BindToObject(*idl, 0, ?IID_IShellFolder, @Network.IShellFolder) = #S_OK 

        ; Lets get the display name of "My Network Places" 
        ; This is done on the parent object, with our *idl 
        ; 
        If Desktop\GetDisplayNameOf(*idl, #_SHGDN_NORMAL, @result.STRRET) = #S_OK 
          AddGadgetItem(0, -1, ReadSTRRET(@result), 0, 0) 
        EndIf 
        
        ; call our scan procedure for this object. max 4 levels depth 
        ; 
        ScanShellFolder(Network, 1, 3)      
        SetGadgetItemState(0, 0, #PB_Tree_Expanded) 
        
        ; Release objects 
        Network\Release() 
      EndIf 
      
      ; the memory used by an IDL must be freed 
      CoTaskMemFree_(*idl) 
    EndIf 
    
    ; Release desktop object 
    Desktop\Release() 
  EndIf 
  
  Repeat 
  Until WaitWindowEvent() = #PB_Event_CloseWindow 
EndIf 

End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP