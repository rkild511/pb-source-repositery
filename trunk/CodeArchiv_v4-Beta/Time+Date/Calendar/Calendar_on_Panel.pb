; German forum:
; Author: Unknown  (updated for PB4.00 by blbltheworm)
; Date: 21. June 2003
; OS: Windows
; Demo: No

; ------- Calendar Setup ------ 
#MCM_GETCURSEL=$1001 

MyCal.INITCOMMONCONTROLSEX 
MyCal\dwSize=8 
MyCal\dwICC=$100 
InitCommonControlsEx_(@MyCal) 
; ----------------------------- 


; PureBasic Visual Designer v3.62 


;- Window Constants 
; 
#Window_0 = 0 

;- Gadget Constants 
; 
#Gadget_1 = 0 
#Gadget_2 = 1 
#Gadget_3 = 2 
#Gadget_4 = 3 
#Gadget_5 = 4 
#Gadget_6 = 5 
#Gadget_7 = 6 
#Gadget_8 = 7 
#Gadget_9 = 8 
#Gadget_10 = 9 
#Gadget_11 = 10 
#Gadget_12 = 11 
#Gadget_13 = 12 


Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 244, 104, 459, 359, "Test",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      
      ;- Panel2000 
      PanelGadget(#Gadget_1, 10, 5, 440, 345) 
      AddGadgetItem(#Gadget_1, -1, "Einstellungen") 
       Frame3D_1=Frame3DGadget(#Gadget_2, 8, 8, 420, 90, "Zeitraum") ; Frame3D_1 = HINZUGEFÜGT 
       ComboBoxGadget(#Gadget_3, 168, 108, 260, 120) 
       TextGadget(#Gadget_4, 8, 113, 150, 20, "Zu benutzender Datenbestand:", #PB_Text_Center) 
       TextGadget(#Gadget_5, 18, 28, 75, 20, "Vom:") 
       TextGadget(#Gadget_6, 18, 63, 75, 20, "Bis") 

       ; Manual created calendar gadgets 
       datepick =CreateWindowEx_(#Window_0,"SysDateTimePick32","DateTime",#WS_CHILD|#WS_VISIBLE|4,120,20,200,22,WindowID(#Window_0),0,GetModuleHandle_(0),0) ; KOORDINATEN _GROB_ VERÄNDERT 
       datepick2=CreateWindowEx_(#Window_0,"SysDateTimePick32","DateTime",#WS_CHILD|#WS_VISIBLE|4,120,50,200,22,WindowID(#Window_0),0,GetModuleHandle_(0),0) ; KOORDINATEN _GROB_ VERÄNDERT 

       ComboBoxGadget(#Gadget_7, 168, 138, 260, 125) 
       TextGadget(#Gadget_8, 8, 143, 150, 20, "Statistik-Modus:") 
       ButtonGadget(#Gadget_9, 8, 203, 420, 25, "Auswertung anzeigen") 
       Frame3DGadget(#Gadget_9, 13, 233, 410, 75, "Informationen zum Datenbestand") 
       TextGadget(#Gadget_10, 33, 253, 380, 50, "Anzahl Datensätze:") 
       TextGadget(#Gadget_10, 8, 173, 150, 25, "Ergebnisse in:") 
       ComboBoxGadget(#Gadget_11, 168, 168, 260, 125) 
      AddGadgetItem(#Gadget_1, -1, "Test") 
      CloseGadgetList()           ; was ClosePanelGadget() until PB3.62

      SetParent_(datepick ,Frame3D_1) ; HINZUGEFÜGT 
      SetParent_(datepick2,Frame3D_1) ; HINZUGEFÜGT 

    EndIf 
  EndIf 
EndProcedure 


Open_Window_0() 

Repeat 
  EventID = WaitWindowEvent() 
Until EventID = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP