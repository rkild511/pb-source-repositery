; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8741&highlight=
; Author: Karbon (updated for PB4.00 by blbltheworm)
; Date: 15. December 2003
; OS: Windows
; Demo: No

Structure LVCOLUMN 
  mask.l 
  fmt.l 
  cx.l 
  pszText.s 
  cchTextMax.l 
  iSubItem.l 
  iImage.l 
  iOrder.l 
EndStructure 


Procedure SetListIconColumnText(Gadget,index,HeaderText.s) 
  
  lvc.LVCOLUMN 
  lvc\mask    = #LVCF_TEXT 
  lvc\pszText = HeaderText 
  SendMessage_(GadgetID(Gadget),#LVM_SETCOLUMN,index,@lvc) 

EndProcedure 


Procedure.s GetListIconColumnText(Gadget,index) 
  
  lvc.LVCOLUMN 
  lvc\mask = #LVCF_TEXT 
  lvc\pszText = Space(255) 
  lvc\cchTextMax = 255 

  SendMessage_(GadgetID(Gadget),#LVM_GETCOLUMN,index,@lvc) 
  
  Result$=PeekS(Val(lvc\pszText))
  
  ProcedureReturn Result$
  
EndProcedure 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
