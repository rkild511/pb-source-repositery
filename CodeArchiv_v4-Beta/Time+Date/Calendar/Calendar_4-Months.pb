; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2997&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 03. December 2003
; OS: Windows
; Demo: No

#MCM_GETCURSEL = $1001 
#Auswahl=1 
#Abbruch = 2 

Structure InitCommon 
  dwSize.l 
  dwICC.l 
EndStructure 

my.InitCommon 
my\dwSize = 8 
my\dwICC = $100 

InitCommonControlsEx_(@my) 

hWnd=OpenWindow(0,0,0,640,480.0,"API-Kalender",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
If hWnd=0 Or CreateGadgetList(hWnd)=0:End:EndIf 

hCal=CreateWindowEx_(0,"SysMonthCal32","Kalender",#WS_CHILD|#WS_VISIBLE,10,80,600,300,hWnd,0,GetModuleHandle_(0),0) 
;ein wenig Farbe ins Spiel bringen 
SendMessage_(hCal,4106,0,$800000);MCM_SC_BACKGROUND 
SendMessage_(hCal,4106,4,$800000);MCM_SC_MONTHBACK 
SendMessage_(hCal,4106,2,$0000FF);MCM_SC_TITEL 
SendMessage_(hCal,4106,1,$00FFFF);MCM_SC_TEXT 
SendMessage_(hCal,4106,3,$00FFFF);MCM_SC_TITELTEXT 

ButtonGadget(#Auswahl,10,10,50,20,"Datum") 
ButtonGadget(#Abbruch,10,40,50,20,"Abbruch") 


Repeat 
  EventID.l = WaitWindowEvent() 
  
  If EventID = #PB_Event_Gadget 
    Select EventGadget() 
      Case #Auswahl 
        SendMessage_(hCal,#MCM_GETCURSEL,0,@time.SYSTEMTIME ) 
        year=time\wYear 
        month=time\wMonth 
        day=time\wDay 
        info.s = Str(day)+"."+Str(month)+"."+Str(year) 
        MessageRequester("",info,0) 
      Case #Abbruch 
        End 
    EndSelect 
  EndIf 
Until EventID = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
