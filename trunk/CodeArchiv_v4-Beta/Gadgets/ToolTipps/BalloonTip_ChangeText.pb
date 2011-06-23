; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1031&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 08. December 2004
; OS: Windows
; Demo: No


Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #Button_0 
EndEnumeration 


; BalloonTip Constants 
#TOOLTIP_NO_ICON      = 0 
#TOOLTIP_INFO_ICON    = 1 
#TOOLTIP_WARNING_ICON = 2 
#TOOLTIP_ERROR_ICON   = 3 
Global ToolTip 
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

Procedure DelBalloonTip(Gadget); Mein Tip (Falko) 
  Balloon.TOOLINFO\cbSize=SizeOf(TOOLINFO) 
  Balloon\hWnd=GadgetID(Gadget) 
  Balloon\uId=GadgetID(Gadget) 
  SendMessage_(ToolTip, #TTM_DELTOOL, 0, Balloon) 
EndProcedure 



Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 338, -11, 178, 138, "Change BalloonTip",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      ButtonGadget(#Button_0, 20, 20, 140, 90, "Press button to change BalloonTip",#PB_Button_MultiLine) 
      BalloonTip(WindowID(#Window_0), #Button_0, "Test", "", #TOOLTIP_NO_ICON) 
      SendMessage_(#Window_0, #TTM_ACTIVATE, 0, 0) 
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
      a=Random(2) 
      If a=0 
        Tip.s="Balloon 1" 
       ElseIf a=1 
        Tip="Balloon 2" 
       ElseIf a=2 
        Tip="Balloon 3" 
      EndIf      
    DelBalloonTip(#Button_0) 
    BalloonTip(WindowID(#Window_0), #Button_0, Tip, "", #TOOLTIP_NO_ICON) 
    EndIf 
    
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 
;
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP