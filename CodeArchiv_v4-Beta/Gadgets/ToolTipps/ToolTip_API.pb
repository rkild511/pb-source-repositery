; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2658&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 26. October 2003
; OS: Windows
; Demo: No

Procedure ToolTip(WindowID.l,Handle,Text.s) 
  ObjektBeschreibung=CreateWindowEx_(#WS_EX_TOPMOST,"Tooltips_Class32",0,#TTS_ALWAYSTIP|#TTS_NOPREFIX|#WS_POPUP|$40,#CW_USEDEFAULT,#CW_USEDEFAULT,#CW_USEDEFAULT,#CW_USEDEFAULT,WindowID,0,GetModuleHandle_(0),0) 
  SendMessage_(ObjektBeschreibung,#TTM_SETDELAYTIME,#TTDT_INITIAL,100) 
  SendMessage_(ObjektBeschreibung,$413,RGB(255,255,255),0) 
  SendMessage_(ObjektBeschreibung,$414,RGB(0,0,0),0) 
  SendMessage_(ObjektBeschreibung,#WM_SETFONT,LoadFont(0,"Arial",54),#True)  
  Tool.TOOLINFO 
  Tool\cbSize=SizeOf(TOOLINFO) 
  Tool\uFlags=#TTF_SUBCLASS|#TTF_IDISHWND 
  Tool\hwnd=Handle 
  Tool\uID=Handle 
  Tool\hInst=GetModuleHandle_(0) 
  Tool\lpszText=@Text 
  SendMessage_(ObjektBeschreibung,#TTM_ADDTOOL,0,@Tool) 
EndProcedure 

If OpenWindow(0,0,0,222,200,"ButtonGadgets",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  ButtonGadget(0, 10, 10, 200, 20, "Standard Button") 
  ToolTip(WindowID(0),GadgetID(0),"ToolTip") 
  Repeat : Until WaitWindowEvent()=#PB_Event_CloseWindow 
EndIf 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
