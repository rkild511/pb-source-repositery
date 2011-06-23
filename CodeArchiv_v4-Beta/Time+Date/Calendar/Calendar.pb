; English forum:
; Author: Franco (updated for PB4.00 by blbltheworm)
; Date: 31. December 2002
; OS: Windows
; Demo: No


;Orignal gepostet von Franco
;Win-API Kalendar
;Konstanten Definition:

#MCM_GETCURSEL = $1001
#Auswahl=1
#Abbruch = 2

my.INITCOMMONCONTROLSEX 
my\dwSize = 8
my\dwICC = $100
;-Initialisieren

InitCommonControlsEx_(@my)

hWnd=OpenWindow(0,0,0,200,200.0,"API-Kalender",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
If hWnd=0 Or CreateGadgetList(hWnd)=0:End:EndIf

hCal=CreateWindowEx_(0,"SysDateTimePick32","Datum",#WS_CHILD|#WS_VISIBLE,20,20,100,25,hWnd,0,GetModuleHandle_(0),0)
ButtonGadget(#Auswahl,130,170,50,20,"Datum")
ButtonGadget(#Abbruch,20,170,50,20,"Abbruch")

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