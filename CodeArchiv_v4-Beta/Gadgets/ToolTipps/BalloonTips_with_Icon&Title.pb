; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8166&highlight=
; Author: Berikco (updated for PB4.00 by blbltheworm)
; Date: 02. November 2003
; OS: Windows
; Demo: No


; PureBasic Visual Designer v3.80 build 1284 


;- Window Constants 
; 
Enumeration 
  #Window_0 
EndEnumeration 

;- Gadget Constants 
; 
Enumeration 
  #Button_0 
EndEnumeration 


; BalloonTip Constants 
#TOOLTIP_NO_ICON      = 0 
#TOOLTIP_INFO_ICON    = 1 
#TOOLTIP_WARNING_ICON = 2 
#TOOLTIP_ERROR_ICON   = 3 

Procedure BalloonTip(WindowID, Gadget, Text$ , Title$, Icon) 
  
  ToolTip=CreateWindowEx_(0,"ToolTips_Class32","",#WS_POPUP | #TTS_NOPREFIX | #TTS_BALLOON,0,0,0,0,WindowID,0,GetModuleHandle_(0),0) 
  SendMessage_(ToolTip,#TTM_SETTIPTEXTCOLOR,GetSysColor_(#COLOR_INFOTEXT),0) 
  SendMessage_(ToolTip,#TTM_SETTIPBKCOLOR,GetSysColor_(#COLOR_INFOBK),0) 
  SendMessage_(ToolTip,#TTM_SETMAXTIPWIDTH,0,180) 
  Balloon.TOOLINFO\cbSize=SizeOf(TOOLINFO) 
  Balloon\uFlags=#TTF_IDISHWND | #TTF_SUBCLASS 
  Balloon\hWnd=GadgetID(Gadget) 
  Balloon\uId=GadgetID(Gadget) 
  Balloon\lpszText=@Text$ 
  SendMessage_(ToolTip, #TTM_ADDTOOL, 0, Balloon) 
  If Title$ > "" 
    SendMessage_(ToolTip, #TTM_SETTITLE, Icon, @Title$) 
  EndIf 
  
EndProcedure 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 216, 0, 600, 300, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ButtonGadget(#Button_0, 48, 64, 136, 40, "Ok") 
      BalloonTip(WindowID(#Window_0), #Button_0, "Tooltip", "Balloon title", #TOOLTIP_ERROR_ICON) 
      
    EndIf 
  EndIf 
EndProcedure 
Open_Window_0() 

Repeat 
  
  Event = WaitWindowEvent() 
  
  If Event = #PB_Event_Gadget 
    
    ;Debug "WindowID: " + Str(EventWindowID()) 
    
    GadgetID = EventGadget() 
    
    If GadgetID = #Button_0 
      Debug "GadgetID: #Button_0" 
      
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
