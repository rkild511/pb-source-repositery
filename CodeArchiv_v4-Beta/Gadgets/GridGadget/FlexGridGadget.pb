; English forum: http://www.purebasic.fr/english/viewtopic.php?t=9284&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 25. January 2004
; OS: Windows
; Demo: No

; PureBasic Visual Designer v3.81 BETA build 1302 

Global listiconnumber,clickedlisticon,currentitemselection,eventname$,totaleventitems 

;- Window Constants 
Enumeration 
  #Window_0 
  #Window_1 
EndEnumeration 

;- Gadget Constants 
Enumeration 
  #Button_0 
  #Button_1 
  #Combo_0 
  #Combo_1 
  #Text_0 
  #Text_1 
  #String_0 
  #Text_3 
  #Editor_0 
  #Text_5 
  #ScrollArea_1 
EndEnumeration 

Procedure Flexgridgadget(scrollareanumber,flexgridx,flexgridy,flexgridwidth,flexgridheight,scrollwidth,scrollheight) 
  ScrollAreaGadget(scrollareanumber, flexgridx, flexgridy, flexgridwidth, flexgridheight, scrollwidth, scrollheight, 10) 
  listiconnumber=scrollareanumber 
  ListIconGadget(listiconnumber+1, 40, 30, 110, 700, "Sunday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+2, 150, 30, 110, 700, "Monday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+3, 260, 30, 110, 700, "Tuesday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+4, 370, 30, 110, 700, "Wednesday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+5, 480, 30, 110, 700, "Thursday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+6, 590, 30, 110, 700, "Friday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ListIconGadget(listiconnumber+7, 700, 30, 110, 700, "Saturday", 105, #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
  ;add text boxes EVERY OTHER ITEM that mark the hours 
  starttimehour=5 
  textgadgetnumber=listiconnumber+7 
  y=25    ;start at height=25 
  For a=listiconnumber+7 To listiconnumber+30 
    y=y+28  ;this value works best to line up boxes with listicon rows 
    textgadgetnumber=textgadgetnumber+1 ;add one to the previous gadget number 
    starttimehour=starttimehour+1 ;add one to the previous hour 
    If starttimehour>=0 And  starttimehour<=11 
      ampm$="am" 
    ElseIf  starttimehour>=12 And  starttimehour<=23 
      ampm$="pm" 
    EndIf 
    If starttimehour=24 ;when we get to midnight, we start all over 
      starttimehour=starttimehour-24 
      ampm$="am" 
      TextGadget(textgadgetnumber,0,y,40,13,Str(starttimehour)+":00"+ampm$) 
    Else 
      TextGadget(textgadgetnumber,0,y,40,13,Str(starttimehour)+":00"+ampm$) 
    EndIf 
  Next 
;   For a= listiconnumber+1 To listiconnumber+7     ; deactivated this code by Andre, because the used command seems to need an userlib
;     LockColumnSize(a, #PB_LockAll ) 
;   Next 
  For a= listiconnumber+1 To listiconnumber+7   ;now we add empty spaces to the listicons 
    For b=0 To 47 
      AddGadgetItem(a,b,"") 
    Next 
  Next 
EndProcedure 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 108, 40, 830, 619, "PB FlexGrid", #PB_Window_SystemMenu | #PB_Window_TitleBar) 
    CreateGadgetList(WindowID(#Window_0)) 
    Flexgridgadget(#ScrollArea_1,0, 10, 830, 590, 850, 750) 
    CreateMenu(0, WindowID(#Window_0))    ; here the menu creating starts.... 
    MenuTitle("File") 
    MenuItem(1, "Open") 
    MenuItem(2, "Save") 
    MenuItem(3, "Save as") 
    MenuItem(4, "Print") 
  EndIf 
EndProcedure 

Procedure Open_Window_1() ;this is the information window 
  If OpenWindow(#Window_1, 237, 162, 458, 293, "Enter Information", #PB_Window_SizeGadget |#PB_Window_TitleBar) 
    If CreateGadgetList(WindowID(#Window_1)) 
      ButtonGadget(#Button_0, 110, 250, 90, 30, "Enter") 
      ButtonGadget(#Button_1, 240, 250, 90, 30, "Cancel") 
      ComboBoxGadget(#Combo_0, 170, 20, 100, 350) 
      ComboBoxGadget(#Combo_1, 170, 60, 100, 350) 
      TextGadget(#Text_0, 70, 20, 70, 20, "Start:", #PB_Text_Center) 
      TextGadget(#Text_1, 70, 60, 70, 20, "Stop:", #PB_Text_Center) 
      StringGadget(#String_0, 110, 100, 310, 20, "") 
      TextGadget(#Text_3, 40, 100, 70, 20, "Event:", #PB_Text_Center) 
      EditorGadget(#Editor_0, 110, 130, 310, 110) 
      TextGadget(#Text_5, 40, 170, 70, 20, "Notes:", #PB_Text_Center) 
    EndIf 
    hour=5 ;here we add all the times to the comboboxes 
    d=-2 
    For a=0 To 23 
      d=d+2 
      hour=hour+1 
      If hour>=0 And  hour<=11 
        ampm$="am" 
      ElseIf  hour>=12 And  hour<=23 
        ampm$="pm" 
      EndIf 
      If hour=24 
        hour=hour-24 
        ampm$="am" 
        AddGadgetItem(#Combo_0,d,Str(hour)+":00"+ampm$) 
        AddGadgetItem(#Combo_0,d+1,Str(hour)+":30"+ampm$) 
      Else 
        AddGadgetItem(#Combo_0,d,Str(hour)+":00"+ampm$) 
        AddGadgetItem(#Combo_0,d+1,Str(hour)+":30"+ampm$) 
      EndIf 
    Next 
    hour=5 ;here we add all the times to the comboboxes 
    d=-2 
    For a=0 To 23 
      d=d+2 
      hour=hour+1 
      If hour>=0 And  hour<=11 
        ampm$="am" 
      ElseIf  hour>=12 And  hour<=23 
        ampm$="pm" 
      EndIf 
      If hour=24 
        hour=hour-24 
        ampm$="am" 
        AddGadgetItem(#Combo_1,d,Str(hour)+":00"+ampm$) 
        AddGadgetItem(#Combo_1,d+1,Str(hour)+":30"+ampm$) 
      Else 
        AddGadgetItem(#Combo_1,d,Str(hour)+":00"+ampm$) 
        AddGadgetItem(#Combo_1,d+1,Str(hour)+":30"+ampm$) 
      EndIf 
    Next 
  EndIf 
EndProcedure 
  
  
  ;-Main Program 
Open_Window_0();open our window 
  ;-Event Loop 

Repeat 
  Event = WaitWindowEvent() 
  Select Event 
    Case #PB_Event_Gadget 
      eventtype=EventType() 
      Select EventType() 
        Case #PB_EventType_LeftClick 
          GadgetID = EventGadget() 
          Select GadgetID 
            Case #Button_1 
              EnableWindow_(WindowID(#Window_0),#True) 
              HideWindow(#Window_1,1) 
            Case #Button_0 
              timeresult=GetGadgetState(#Combo_0) 
              timeresult1=GetGadgetState(#Combo_1) 
              totaltime=timeresult1-timeresult 
              If totaltime<0 
                MessageRequester("Error","You Specified A Time Range That Goes Backwards",#PB_MessageRequester_Ok) 
              Else 
                EnableWindow_(WindowID(#Window_0),#True) 
                eventname$=GetGadgetText(#String_0) 
                If eventname$="" 
                Else 
                  SetGadgetItemText(clickedlisticon,currentitemselection,eventname$,0) 
                  For f=currentitemselection+1 To currentitemselection+totaltime 
                    SetGadgetItemText(clickedlisticon,f,"|||||||||||||||||||||||||||||||||||||||||||||||",0) 
                    Next 
                  If totaltime<>totaleventitems 
                    itemstoclear=totaleventitems-totaltime 
                    For s=currentitemselection+totaltime+1 To currentitemselection+totaltime+1+itemstoclear 
                      SetGadgetItemText(clickedlisticon,s,"",0) 
                    Next 
                  ElseIf eventname$="" 
                    For s=currentitemselection To totaleventitems 
                      SetGadgetItemText(clickedlisticon,s,"",0) 
                    Next 
                  EndIf 
                EndIf 
                HideWindow(#Window_1,1) 
              EndIf 
              
          EndSelect 
        Case #PB_EventType_LeftDoubleClick 
          GadgetID = EventGadget() 
          If GadgetID>=listiconnumber+1 And GadgetID<=listiconnumber+7 
            clickedlisticon=GadgetID 
            currentitemselection=GetGadgetState(clickedlisticon) 
            currentevent$=GetGadgetItemText(clickedlisticon,currentitemselection,0) 
            g=currentitemselection 
            totaleventitems=1 
            Repeat 
              g=g+1 
              result$=GetGadgetItemText(clickedlisticon,g,0) 
              If result$="|||||||||||||||||||||||||||||||||||||||||||||||" 
                totaleventitems=totaleventitems+1 
              ElseIf result$="" 
                Break 
              EndIf 
            Until result$<>"|||||||||||||||||||||||||||||||||||||||||||||||" 
            If currentevent$="|||||||||||||||||||||||||||||||||||||||||||||||" 
            Else 
              Open_Window_1() 
              SetGadgetState(#Combo_0,currentitemselection) 
              SetGadgetState(#Combo_1,currentitemselection+totaleventitems-1) 
              SetGadgetText(#String_0,currentevent$) 
              EnableWindow_(WindowID(#Window_0),#False);user double clicks, and presto--info window pops up 
            EndIf 
          EndIf 
      EndSelect 
      eventmenu=EventMenu() 
      Select eventmenu 
        
        
      EndSelect 
  EndSelect 
Until Event = #PB_Event_CloseWindow 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger