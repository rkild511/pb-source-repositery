; German forum: http://www.purebasic.fr/german/viewtopic.php?t=4184&highlight=
; Author: FGK (updated for PB 4.00 by Andre)
; Date: 31. July 2005
; OS: Windows
; Demo: No

; Zuerst generiere ich einen Path auf dem DC des Windows. 
; Die Pfade können sehr komplex sein (auch Texte, Bezier, Polylines usw.) 
; Danach generiere ich einen Pen mit Stärke und Farbe und dann wird das 
; ganze einfach mit StrokePath_ ins DC des Windows gezeichnet. 
; Das schöne daran ist du kannst die komplizierte Figur vorher generieren 
; und nur mit einem Aufruf auf den Bildschirm bringen. 

If OpenWindow(0, 100, 200, 640,480,"PureBasic Window",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget|#PB_Window_MaximizeGadget|#PB_Window_WindowCentered) 
  
  dc=GetDC_(WindowID(0)) 
  BeginPath_(dc) 
    Rectangle_(dc,10,10,110,110) 
    Arc_(dc,120,10,220,110,0,90,0,90) 
  EndPath_(dc) 
  
  OldPen=GetCurrentObject_(dc,#OBJ_PEN) 
  NewPen=CreatePen_(#PS_SOLID,10,RGB(0,0,0)) 
  SelectObject_(dc,NewPen) 
  
  Repeat 
    EventID.l = WaitWindowEvent() 

    StrokePath_(dc) 
      
    If EventID = #PB_Event_CloseWindow  ; If the user has pressed on the close button 
      Quit = 1 
      
    EndIf 
    
  Until Quit = 1 
  
EndIf 
  DeleteObject_(NewPen) 
  SelectObject_(dc,OldPen) 
  
End 


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -