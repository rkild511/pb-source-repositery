; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3281&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 29. December 2003
; OS: Windows
; Demo: No

; 
; Calculate inner width+height of panel items 
; 
; by Danilo, 29.12.2003 
; 
Procedure GetPanelItemWidth(PanelGadget) 
  ; returns the inner width of panel items 
  tc.TC_ITEM\mask = #TCIF_PARAM 
  If SendMessage_(GadgetID(PanelGadget),#TCM_GETITEM,0,@tc) 
    GetClientRect_(tc\lParam,rect.RECT) 
    ProcedureReturn rect\right 
  EndIf 
EndProcedure 

Procedure GetPanelItemHeight(PanelGadget) 
  ; returns the inner height of panel items 
  tc.TC_ITEM\mask = #TCIF_PARAM 
  If SendMessage_(GadgetID(PanelGadget),#TCM_GETITEM,0,@tc) 
    GetClientRect_(tc\lParam,rect.RECT) 
    ProcedureReturn rect\bottom 
  EndIf 
EndProcedure 

Procedure ScrollbarWidth() 
  ; returns the width of windows scrollbars 
  ProcedureReturn GetSystemMetrics_(#SM_CXHSCROLL) 
EndProcedure 

Procedure ScrollbarHeight() 
  ; returns the height of windows scrollbars 
  ProcedureReturn GetSystemMetrics_(#SM_CYVSCROLL) 
EndProcedure 


OpenWindow(0,200,200,400,200,"Yo!",#PB_Window_SystemMenu) 
  CreateGadgetList(WindowID(0)) 
    PanelGadget(1,5,5,390,190) 
      AddGadgetItem(1,-1,"Panel Item 1") 
        ListViewGadget(2,0,0,GetPanelItemWidth(1),GetPanelItemHeight(1)) 
        For a = 1 To 50 
          AddGadgetItem(2,-1,"ListView Line "+Str(a)) 
        Next a 
      AddGadgetItem(1,-1,"Panel Item 2") 
        ScrollAreaGadget(3,0,0,GetPanelItemWidth(1),GetPanelItemHeight(1),GetPanelItemWidth(1)-ScrollbarWidth(),50*25+10,10,#PB_ScrollArea_BorderLess) 
          For a = 0 To 49 
            ButtonGadget(4+a,20,5+a*25,100,20,"Button "+Str(a+1)) 
          Next a 
        CloseGadgetList() 
    CloseGadgetList() 

Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
