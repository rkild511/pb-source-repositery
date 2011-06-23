; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8110&highlight=
; Author: sec (updated for PB3.93 by ts-soft)
; Date: 30. October 2003
; OS: Windows
; Demo: No

; get filename of current wallpaper 
unibuff=AllocateMemory(2*(#MAX_PATH+1)) 
ansibuff=AllocateMemory(#MAX_PATH) 
CoInitialize_(0) 
If CoCreateInstance_(?clsid_activedesktop,0,1,?iid_iactivedesktop,@iad.IActiveDesktop)=#S_OK 
    !PUSH dword 0      
    !PUSH dword 522; 2*(#max_path+1)          
    !MOV eax,dword [v_unibuff] 
    !PUSH eax 
    !MOV eax,dword [v_iad] 
    !PUSH eax 
    !MOV eax, [eax] 
    !CALL dword [eax+16]; iad\getwallpaper(unibuff,2*(#max_path+1),0) 
    WideCharToMultiByte_(#CP_ACP,#WC_COMPOSITECHECK,unibuff,-1,ansibuff,#MAX_PATH,0,0)  
    iad\release() 
EndIf 
CoUninitialize_() 
Debug PeekS(ansibuff) 
FreeMemory(unibuff) 
FreeMemory(ansibuff) 

DataSection 
clsid_activedesktop: 
Data.b $00,$87,$04,$75,$1F,$EF,$D0,$11,$98,$88,$00,$60,$97,$DE,$AC,$F9 
iid_iactivedesktop: 
Data.b $00,$EB,$90,$F4,$40,$12,$D1,$11,$98,$88,$00,$60,$97,$DE,$AC,$F9 
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -