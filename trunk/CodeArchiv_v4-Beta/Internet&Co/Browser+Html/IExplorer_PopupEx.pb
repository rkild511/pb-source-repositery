; German forum: http://www.purebasic.fr/german/viewtopic.php?t=427&highlight=
; Author: computerkranker (updated for PB 4.00 by Andre)
; Date: 14. October 2004
; OS: Windows
; Demo: No


; Allows opening of multiple IExplorer windows
; Erlaubt das Öffnen mehrerer IExplorer Fenster

Global NewList IEPopupID.l() 

Procedure IEPopup(x,y,xLen,yLen,url.s) 
  Protected Result 
  Result=OpenWindow(#PB_Any,x,y,xLen,yLen,url.s,#PB_Window_SystemMenu) 
  If Result 
    If CreateGadgetList(WindowID(Result)) 
      WebGadget(#PB_Any,0,0,xLen,yLen,url.s) 
    EndIf 
    AddElement(IEPopupID()) 
    IEPopupID()=Result 
  EndIf 
  ProcedureReturn Result 
EndProcedure 

Procedure IEPopupClose(id.l) 
  ForEach IEPopupID() 
    If IEPopupID()=id.l 
      CloseWindow(id.l) 
      DeleteElement(IEPopupID()) 
      Break 
    EndIf 
  Next 
EndProcedure 

OpenWindow(1,0,0,100,100,"Test",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(WindowID(1)) 
ButtonGadget(1,0,0,100,24,"New Popup") 
StringGadget(2,0,26,100,24,"http://purebasic.de") 

Repeat 
  Select WindowEvent() 
    Case #PB_Event_Gadget 
      If EventGadget()=1 And EventType()=#PB_EventType_LeftClick 
        IEPopup(Random(200),Random(200),200,200,GetGadgetText(2)) 
      EndIf 
    Case #PB_Event_CloseWindow 
      If EventWindow()=1 
        Quit=#True 
      Else 
        IEPopupClose(EventWindow()) 
      EndIf 
  EndSelect 
Until Quit 
 

; 
; MSDN.... 
; 
; Explorer Params 
; ---------------
; /root,object 
; Wenn Sie diesen Parameter angeben, wird der Pfad im Explorer als Root angezeigt (Sie können nicht weiter zurückblättern) 
; 
; Beispiel: Explorer /e,/root,c:\windows\system 
; 
; /e 
; Auf der linken Seite wird ein Verzeichnisbaum angezeigt. Wenn Sie diesen Parameter weglassen, wird im Explorer nur der Ordnerinhalt angezeigt. 
; 
; /n 
; Öffnet immer einen neuen Explorer, auch wenn schon einer geöffnet ist. 
; 
; subobject 
; Legt den Ordner fest, der den FOCUS erhält, wenn der Explorer gestartet wird. Als Standard ist root definiert. Ist nicht in Verbindung mit /Select möglich 
; 
; /select 
; Legt fest, dass ein Ordner geöffnet wird und ein Objekt im Ordner selektiert ist 
; 
; IExplore params 
; ---------------
; -channelband Internet Explorer as a Desktop Toolbar, displaying the 
; Channels Directory of the currently logged on user. This 
; option only applies when Active Desktop is off. 
; 
; -e Launch Internet Explorer in Explorer mode (standard two 
; pane view, My Computer on left, Content on right) 
; 
; -new Start up Internet Explorer in a separate process. 
; 
; -nohome Open Internet Explorer And don't open any Web page at all. 
; 
; -k Launch Internet Explorer in Kiosk mode.

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP