; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11768&start=20
; Author: atnheaderlen
; Date: 29. January 2007
; OS: Windows
; Demo: No


Global CG_01.l 

Structure Belegung 
  BNr.l 
  ONr.l 
  BBe.l 
  BEn.l 
EndStructure 

NewList T.Belegung() 

Structure Verlinkung 
  GNr.l 
  BNr.l 
EndStructure 

NewList L.Verlinkung()  

Procedure CreateGrafik(SL.Belegung(),LL.Verlinkung(),WINNr.l,XStart.l,YStart.l,XWidth.l,YWidth.l) 
  ResetList(LL()) 
  While NextElement(LL()) 
    FreeGadget(LL()\GNr) 
  Wend 
  ClearList(LL()) 
  ResetList(SL()) 
  OpenGadgetList(CG_01) 
  While NextElement(SL()) 
    BGID=ButtonGadget(#PB_Any,(XStart+(20*SL()\BBe)),(YStart+(20*SL()\ONr)),(SL()\BEn-SL()\BBe)*20,20,Str(SL()\BNr)) 
    AddElement(LL()) 
    LL()\GNr=BGID 
    LL()\BNr=ListIndex(SL()) 
  Wend 
  
EndProcedure 

Procedure GetData(SL.Belegung()) 
  For loop=1 To 10 
    AddElement(SL()) 
    Read SL()\BNr 
    Read SL()\ONr 
    Read SL()\BBe 
    Read SL()\BEn 
  Next 
EndProcedure 

;- main 

GetData(T()) 

  OpenWindow(1, 0, 0, 800, 600, "Booking", #PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
    CreateGadgetList(WindowID(1)) 
    CG_01.l=ContainerGadget(#PB_Any, 50, 50, 700, 450,#PB_Container_Double) 
    CloseGadgetList() 
    BG_01.l=ButtonGadget(#PB_Any,50,510,700,80,"STARTBUTTON") 
  
    
    Repeat 
      Event = WaitWindowEvent() 
      
      Select Event 
        
        Case #PB_Event_Gadget 
          EventGadgetID=EventGadget() 
          Select EventGadgetID 
            Case BG_01  
              CreateGrafik(T(),L(),1,0,0,20,20) 
            Default 
              ResetList(L()) 
              While NextElement(L()) 
                If L()\GNr=EventGadgetID 
                  MessageRequester("Gedrueckt","Eintrag :"+Str(L()\BNr)) 
                EndIf 
              Wend 
          EndSelect 

          
      EndSelect 
    Until Event = #PB_Event_CloseWindow 

  DataSection: 
    Data.l 1,1,1,9 
    Data.l 2,1,10,14 
    Data.l 3,1,14,17 
    Data.l 4,1,18,25 
    Data.l 5,2,10,19 
    Data.l 6,3,4,9 
    Data.l 7,3,10,15 
    Data.l 8,3,18,29 
    Data.l 9,4,10,29 
    Data.l 10,5,18,19 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP