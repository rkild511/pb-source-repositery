; German forum: http://www.purebasic.fr/german/viewtopic.php?t=906&highlight=
; Author: Falko (updated for PB 4.00 by Andre)
; Date: 07. December 2004
; OS: Windows
; Demo: No


; Move scrollbar of a ListIcon by command
; Scrollbalken eines ListIcons mittels Befehl verschieben

#MyWindow = 0 
 #MyGadget = 1 
 If OpenWindow(#MyWindow,100,100,300,500,"ListIcon Beispiel",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
   If CreateGadgetList(WindowID(#MyWindow)) 
     ListIconGadget(#MyGadget,5,5,290,490,"Name",150,#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection) 
     AddGadgetColumn(#MyGadget,1,"Adresse",250) 
     For i=1 To 500 
     AddGadgetItem(#MyGadget,-1,Str(i)+" Harry Rannit"+Chr(10)+"12 Parliament Way, Battle Street, By the Bay") 
     Next i 
      
     For a=1 To 401 
        SetScrollPos_(GadgetID(#MyGadget),#SB_VERT,a,#True) 
        SendMessage_(GadgetID(#MyGadget),#WM_VSCROLL,#SB_LINEDOWN,0) 
        Delay(10) 
       Next a 
     For a=401 To 1 Step -1 
        SetScrollPos_(GadgetID(#MyGadget),#SB_VERT,a,#True) 
        SendMessage_(GadgetID(#MyGadget),#WM_VSCROLL,#SB_LINEUP,0) 
        Delay(10) 
       Next a 

      
      
     Repeat 
       EventID = WindowEvent() 
        
     Until EventID = #PB_Event_CloseWindow And EventWindow() = #MyWindow 
   EndIf 
 EndIf 
 
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -