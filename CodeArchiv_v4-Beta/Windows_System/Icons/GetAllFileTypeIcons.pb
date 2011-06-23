; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7028&highlight=
; Author: Inner (updated for PB4.00 by blbltheworm)
; Date: 27. July 2003
; OS: Windows
; Demo: No

#DEWINDOW=0 
#DEGAD_COLUM=1 

Structure SHELLICONLIST 
    hLarge.l 
   hSmall.l 
   szTypeName.s 
EndStructure 
Global NewList silist.SHELLICONLIST() 

Procedure Display_EntryWindowCallback(WindowID, Message, lParam, wParam) 
    Result = #PB_ProcessPureBasicEvents 
    Select Message 
        Case #WM_SIZE 
            ResizeGadget(#DEGAD_COLUM,#PB_Ignore,#PB_Ignore, WindowWidth(#DEWINDOW), WindowHeight(#DEWINDOW)) 
            InvalidateRect_(WindowID,#Null,#True) 
        EndSelect 
    ProcedureReturn Result 
EndProcedure 

If OpenWindow(#DEWINDOW, 0, 0,640,400,"SPACK", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_SizeGadget) 
    If CreateGadgetList(WindowID(#DEWINDOW)) 
        ListIconGadget(#DEGAD_COLUM,0,0,640,400,"Name",160,#LVS_AUTOARRANGE )        
    EndIf 
    SetWindowCallback(@Display_EntryWindowCallback()) 
    
    hKey.l 
    If(RegOpenKeyEx_(#HKEY_LOCAL_MACHINE,"SOFTWARE\Microsoft\Internet Explorer",0,#KEY_ALL_ACCESS,@hKey)=#ERROR_SUCCESS) 
        buffer.s=Space(64) 
        bufferlen.l=64                
      RegQueryValueEx_(hKey, "Version",#Null,#Null,@buffer.s,@bufferlen) 
    EndIf 
   RegCloseKey_(hKey); 

    If(Mid(buffer,0,4)="6.0.") 
      ;// Tries to manually grab the icon and information for ".cdf" by checking to 
      ;// see if it is a registered file type then by finding the dll which the icon 
      ;// is stored at    
        If(RegOpenKeyEx_(#HKEY_CLASSES_ROOT,"CLSID\{f39a0dc0-9cc8-11d0-a599-00c04fd64433}\InProcServer32",0,#KEY_ALL_ACCESS,@hKey)=#ERROR_SUCCESS) 
         dwSize.l=256 
         szValue.s=Space(256) 
            If(RegQueryValue_(hKey,"",@szValue,@dwSize)=ERROR_SUCCESS) 
                AddElement(silist()) 
            ExtractIconEx_(szValue,2,@silist()\hLarge,@silist()\hSmall,1) 
            silist()\szTypeName=".cdf"             
            EndIf    
        EndIf 
        RegCloseKey_(hKey); 
    EndIf 

    If(RegOpenKeyEx_(#HKEY_CLASSES_ROOT,"",0,#KEY_ENUMERATE_SUB_KEYS,@hKey)=#ERROR_SUCCESS) 
       szName.s=Space(#MAX_PATH) 
       dwBuf.l=#MAX_PATH 
       shInfo.SHFILEINFO 
        While(RegEnumKey_(hKey,dwIndex,@szName,@dwBuf)=0) 
            dwIndex+1 
            If(Mid(szName,0,1)=".") 
                If(szName<>".cdf") 
               SHGetFileInfo_(szName,FILE_ATTRIBUTE_NORMAL,@shInfo,SizeOf(SHFILEINFO),#SHGFI_USEFILEATTRIBUTES|#SHGFI_ICON|#SHGFI_SMALLICON) 
                    AddElement(silist()) 
                    silist()\hSmall=shInfo\hIcon 
                    silist()\szTypeName=szName 
                    AddGadgetItem(#DEGAD_COLUM,-1,silist()\szTypeName,shInfo\hIcon) 
                EndIf 
            EndIf 
        Wend        
    EndIf 

   RegCloseKey_(hKey); 

    Repeat 
        EventID=WaitWindowEvent() 
    Until EventID=#PB_Event_CloseWindow 

    ResetList(silist()) 
    While NextElement(silist()) 
        If((silist()\hLarge)<>0) 
            DestroyIcon_(silist()\hLarge) 
        EndIf 
        If((silist()\hSmall)<>0) 
            DestroyIcon_(silist()\hSmall) 
        EndIf 
    Wend 
        
EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
