; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7383
; Author: fsw (updated to PB4 by ste123)
; Date: 30. August 2003
; OS: Windows
; Demo: No


; OutlookGadget For PureBasic 
; (c) 2003 - Franco 
; Uses my EventConnection Library :) 
; => get it from www.purearea.net - userlibs

; works with PureBasic v3.7 
; 
; USAGE: 
; 
; OutlookGadget(id,x,y,w,h,max_groups) 
; AddOutlookGadgetGroup(id,position,String$) - don't mix the positions! 
; AddOutlookGadgetItem(id,position,image$,parent_group) - don't mix the positions! 
; ActivateOutlookGadgetGroup(group_position) 
; 
; 
; Use max_groups in OutlookGadget as it should be used! 
; If max_groups is < the actual number of groups = not all groups will be shown 
; If max_groups is > the actual number of groups = ActivateOutlookGadgetGroup will crash 
; 
; Don't mix the positions with AddOutlookGadgetGroup and AddOutlookGadgetItem! 
; Start always with 1 and than 2,3,4... and so on. 
; You can't use -1 (as position value) for adding Groups or Items! 
; 
; FOR NOW YOU CAN'T RESIZE THE OUTLOOKGADGET 
; 
;- Start Main 

#MainWindow = 1 

Outlook.l   = OnEvent(?EventType_LeftClick) 

OutlookButton1.l = OnEvent(?Activate1) 
ScrollArea1Button1 = OnEvent(?EventType_LeftClick) 
ScrollArea1Button2 = OnEvent(?EventType_LeftClick) 
ScrollArea1Button3 = OnEvent(?EventType_LeftClick) 
ScrollArea1Button4 = OnEvent(?EventType_LeftClick) 

OutlookButton2.l = OnEvent(?Activate2) 
ScrollArea2Button1 = OnEvent(?EventType_LeftClick) 
ScrollArea2Button2 = OnEvent(?EventType_LeftClick) 
ScrollArea2Button3 = OnEvent(?EventType_LeftClick) 
ScrollArea2Button4 = OnEvent(?EventType_LeftClick) 

OutlookButton3.l = OnEvent(?Activate3) 
ScrollArea3Button1 = OnEvent(?EventType_LeftClick) 
ScrollArea3Button2 = OnEvent(?EventType_LeftClick) 
ScrollArea3Button3 = OnEvent(?EventType_LeftClick) 
ScrollArea3Button4 = OnEvent(?EventType_LeftClick) 

OutlookButton4.l = OnEvent(?Activate4) 
ScrollArea4Button1 = OnEvent(?EventType_LeftClick) 
ScrollArea4Button2 = OnEvent(?EventType_LeftClick) 
ScrollArea4Button3 = OnEvent(?EventType_LeftClick) 
ScrollArea4Button4 = OnEvent(?EventType_LeftClick) 

Procedure OutlookGadget(id,x,y,w,h,max) 
  If max < 1 : ProcedureReturn 0 : EndIf 
  
  Structure Gadget 
    x.l  ;this is used for the main gadget 
    StructureUnion 
      y.l  ;this is used for the main gadget 
      uy.l ;this is used for the upper y of the groups 
    EndStructureUnion 
    StructureUnion 
      w.l  ;this is used for the main gadget 
      ly.l ;this is used for the lower y of the groups 
    EndStructureUnion 
    StructureUnion 
      h.l  ;this is used for the main gadget 
      idg.l ;this is used for the id of the groups 
    EndStructureUnion 
    StructureUnion 
      m.l  ;this is used for the main gadget 
      ids.l ;this is used for the id of the scrollarea 
    EndStructureUnion 
  EndStructure 
  
  Global Dim Outlook.Gadget(max) 
  ; ZERO is always the main OutlookGadget! 
  ; >=1 is always used for OutlookGadgetGroups! 
  Outlook(0)\x = x 
  Outlook(0)\y = y 
  If w < 90 : w = 90 : EndIf 
  Outlook(0)\w = w 
  If h < max * 25 + 75 : h = max * 25 + 75 : EndIf 
  Outlook(0)\h = h 
  Outlook(0)\m = max ; max positions 
  
  hGadget = ContainerGadget(id,Outlook(0)\x,Outlook(0)\y,Outlook(0)\w,Outlook(0)\h,#PB_Container_Single) 
  hBrush = CreateSolidBrush_(GetSysColor_(#COLOR_APPWORKSPACE ) ) 
  SetClassLong_(hGadget, #GCL_HBRBACKGROUND, hBrush) 
  ProcedureReturn hGadget 
EndProcedure 

Procedure AddOutlookGadgetGroup(id,pos,String$) 
  If pos > Outlook(0)\m : ProcedureReturn 0 : EndIf 
  x=0 
  
  If pos = 1 : y=0 : EndIf 
  Outlook(pos)\uy = y 
  Outlook(pos)\ly = y 
  
  ;calculate upper y for pos > 1 
  If pos > 1 : y=pos*25+0-25 : EndIf 
  Outlook(pos)\uy = y ;this is used to store the upper y of the button so we can move it... 
  
  ;calculate lower y for pos > 1 
  If pos > 1 : y=Outlook(0)\h - (((Outlook(0)\m-pos+1)*25)+1) : EndIf 
  Outlook(pos)\ly = y ;this is not used for width info, but to store the lower y of the button so we can move it... 
  
  w = Outlook(0)\w - 1 
  
  ButtonGadget(id,x,y,w,25,String$) 
  Outlook(pos)\idg = id ;this is not used for height info, but to store the id of the button so we can move it... 

  y=pos*25+4

; different values are possible...  
  Scroll.l = ScrollAreaGadget(#PB_Any , 6, y, Outlook(0)\w-12, Outlook(0)\h - ((Outlook(0)\m+1)*25)+15, Outlook(0)\w-32, Outlook(0)\h - ((Outlook(0)\m+1)*25)+15, 42,#PB_ScrollArea_BorderLess) 

  Outlook(pos)\ids = Scroll ;this is not used for max info, but to store the id of the scrollarea so we can move it... 
  HideGadget(Scroll,1) 

  ;colorize all this stuff... 
  Area.l = GetWindow_(GadgetID(Scroll), #GW_CHILD) 
  hBrush = CreateSolidBrush_(GetSysColor_(#COLOR_APPWORKSPACE ) ) 
  SetClassLong_(Area, #GCL_HBRBACKGROUND, hBrush) 
  SetClassLong_(GadgetID(Scroll), #GCL_HBRBACKGROUND, hBrush) 

  ProcedureReturn Scroll 
EndProcedure 

Procedure AddOutlookGadgetItem(id,pos,image$,parent) 
  y=(pos-1)*50
  x=((Outlook(0)\w)/2-46) 
  
  img.l = LoadImage(#PB_Any,image$);
  ButtonImageGadget(id,x,y,48,48,ImageID(img))   ; Y is 2 = first one doesn't move
  
  SetGadgetAttribute( parent , #PB_ScrollArea_InnerHeight , y+50 );
EndProcedure 


Procedure ActivateOutlookGadgetGroup(pos) 
  
  ;move the buttons... 
  For i.l = 1 To Outlook(0)\m 
    If i < pos 
      MoveWindow_(GadgetID(Outlook(i)\idg), 0,Outlook(i)\uy,Outlook(0)\w-1,25,#True) 
    Else 
      MoveWindow_(GadgetID(Outlook(i)\idg), 0,Outlook(i)\ly,Outlook(0)\w-1,25,#True) 
    EndIf 
  Next 
  MoveWindow_(GadgetID(Outlook(pos)\idg), 0,Outlook(pos)\uy,Outlook(0)\w-1,25,#True) 
  
  ;hide the scrollareas... 
  For i.l = 1 To Outlook(0)\m 
    HideGadget( Outlook(i)\ids , 1) 
  Next 
  HideGadget(Outlook(pos)\ids, 0) 
  
EndProcedure 

;- start example 

If OpenWindow(#MainWindow,100,200,320,320,"Test",#PB_Window_SystemMenu | #PB_Window_SizeGadget) = 0 : End : EndIf 

CreateGadgetList(WindowID(1)) 

If OutlookGadget(Outlook,50,10,10,250,4) 
  ScrollArea1 = AddOutlookGadgetGroup(OutlookButton1,1,"Button 1") 
  If ScrollArea1 
    AddOutlookGadgetItem(ScrollArea1Button1,1,"../xGfx/GeeBee2.bmp",ScrollArea1) 
    AddOutlookGadgetItem(ScrollArea1Button2,2,"../xGfx/GeeBee2.bmp",ScrollArea1) 
    AddOutlookGadgetItem(ScrollArea1Button3,3,"../xGfx/GeeBee2.bmp",ScrollArea1) 
    AddOutlookGadgetItem(ScrollArea1Button4,4,"../xGfx/GeeBee2.bmp",ScrollArea1) 
    CloseGadgetList() ; this closes the Gadgetlist of ScrollArea1 
  EndIf 

  ScrollArea2 = AddOutlookGadgetGroup(OutlookButton2,2,"Button 2") 
  If ScrollArea2 
    AddOutlookGadgetItem(ScrollArea2Button1,1,"../xGfx/GeeBee2.bmp",ScrollArea2) 
    AddOutlookGadgetItem(ScrollArea2Button2,2,"../xGfx/GeeBee2.bmp",ScrollArea2) 
    AddOutlookGadgetItem(ScrollArea2Button3,3,"../xGfx/GeeBee2.bmp",ScrollArea2) 
    AddOutlookGadgetItem(ScrollArea2Button4,4,"../xGfx/GeeBee2.bmp",ScrollArea2) 
    CloseGadgetList() ; this closes the Gadgetlist of ScrollArea2 
  EndIf 

  ScrollArea3 = AddOutlookGadgetGroup(OutlookButton3,3,"Button 3") 
  If ScrollArea3 
    AddOutlookGadgetItem(ScrollArea3Button1,1,"../xGfx/GeeBee2.bmp",ScrollArea3) 
    AddOutlookGadgetItem(ScrollArea3Button2,2,"../xGfx/GeeBee2.bmp",ScrollArea3) 
    AddOutlookGadgetItem(ScrollArea3Button3,3,"../xGfx/GeeBee2.bmp",ScrollArea3) 
    AddOutlookGadgetItem(ScrollArea3Button4,4,"../xGfx/GeeBee2.bmp",ScrollArea3) 
    CloseGadgetList() ; this closes the Gadgetlist of ScrollArea3 
  EndIf 

  ScrollArea4 = AddOutlookGadgetGroup(OutlookButton4,4,"Button 4") 
  If ScrollArea4 
    AddOutlookGadgetItem(ScrollArea4Button1,1,"../xGfx/GeeBee2.bmp",ScrollArea4) 
    AddOutlookGadgetItem(ScrollArea4Button2,2,"../xGfx/GeeBee2.bmp",ScrollArea4) 
    AddOutlookGadgetItem(ScrollArea4Button3,3,"../xGfx/GeeBee2.bmp",ScrollArea4) 
    AddOutlookGadgetItem(ScrollArea4Button4,4,"../xGfx/GeeBee2.bmp",ScrollArea4) 
    CloseGadgetList() ; this closes the Gadgetlist of ScrollArea4 
  EndIf 

  CloseGadgetList() ; this closes the Gadgetlist of the OutlookGadget 
  ActivateOutlookGadgetGroup(1) 
EndIf 


Repeat 
  Event.l = WaitWindowEvent() 

  Select Event 

    Case #PB_Event_Gadget 
      CallEventFunction(EventGadget()) 
      
  EndSelect 
  
Until Event = #PB_Event_CloseWindow And EventWindow() = #MainWindow 

End 

;- User Functions 
Activate1: 
  ActivateOutlookGadgetGroup(1) 

Return 

Activate2: 
  ActivateOutlookGadgetGroup(2) 

Return 

Activate3: 
  ActivateOutlookGadgetGroup(3) 

Return 

Activate4: 
  ActivateOutlookGadgetGroup(4) 
Return 


EventType_LeftClick: 
  Debug "#PB_EventType_LeftClick" 
;  MessageRequester("Test PB_EventType_LeftClick", "Gadget #: " + Str(EventGadgetID()),0) 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
