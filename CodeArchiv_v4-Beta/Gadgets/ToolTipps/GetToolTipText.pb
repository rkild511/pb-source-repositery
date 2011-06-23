; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11403&highlight=
; Author: edel
; Date: 02. January 2007
; OS: Windows
; Demo: No


 ; PUREBASIC V4 
  Procedure.s GetToolTipText(id) 
    Protected hTP.l,hParent.l 
    Protected Buffer.s,ti.TOOLINFO 
    !EXTRN _PB_Object_GetThreadMemory@4 
    !EXTRN _PB_Gadget_Globals 
    !MOV   Eax,[_PB_Gadget_Globals] 
    !PUSH  Eax 
    !CALL  _PB_Object_GetThreadMemory@4 
    !MOV Esi,[Eax] 
    !MOV [p.v_hParent],Esi 
    !MOV Eax,[Eax+24] 
    !MOV [p.v_hTP],Eax 
    Buffer = Space(255) 
    ti\cbSize = SizeOf(TOOLINFO) 
    ti\hwnd = hParent 
    ti\uId = GadgetID(id) 
    ti\lpszText = @Buffer 
    SendMessage_(hTP,#TTM_GETTEXT,0,@ti) 
    ProcedureReturn Buffer 
  EndProcedure 


  hwnd = OpenWindow(0,0,0,300,300,"") 

  CreateGadgetList(hwnd) 
  
  If ButtonGadget(0,10,10,100,24,"") 
    GadgetToolTip(0,"ToolTip") 
  EndIf 
  
  Debug GetToolTipText(0) 
  
  Repeat 
    event = WaitWindowEvent() 
    
  Until event = 16 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP