; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6169&highlight=
; Author: Inner (updated for PB4.00 by blbltheworm)
; Date: 16. May 2003
; OS: Windows
; Demo: No

;----------------------------------------------------------------------------- 
; Expand TreeView 
;----------------------------------------------------------------------------- 
Procedure TreeViewExpandAll(Gadget.l) 
    hwndTV.l = GadgetID(Gadget)  
    hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)  
    hItem.l = hRoot  
    Repeat 
        SendMessage_(hwndTV, #TVM_EXPAND, #TVE_EXPAND, hItem) 
        hItem = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXTVISIBLE , hItem)  
    Until hItem = #Null  
    SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hRoot) 
EndProcedure 
;----------------------------------------------------------------------------- 
; Collapse TreeView 
;----------------------------------------------------------------------------- 
Procedure TreeViewCollapseAll(Gadget.l) 
    hwndTV.l = GadgetID(Gadget)  
    hRoot.l = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_ROOT, 0)  
    hItem.l = hRoot  
    Repeat 
        SendMessage_(hwndTV, #TVM_EXPAND, #TVE_COLLAPSE, hItem) 
        hItem = SendMessage_(hwndTV, #TVM_GETNEXTITEM, #TVGN_NEXTVISIBLE , hItem)  
    Until hItem = #Null  
    SendMessage_(hwndTV, #TVM_ENSUREVISIBLE, 0, hRoot) 
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
