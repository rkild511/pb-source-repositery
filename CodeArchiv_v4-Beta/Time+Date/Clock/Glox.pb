; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1735
; Author: Wichtel (updated for PB4.00 by blbltheworm)
; Date: 18. July 2003
; OS: Windows
; Demo: No

#appname="glox" 
#version="1.03" 

#limit=7 

Global clox.l, block.l, maxx.l, maxy.l, height.l, ampm.l, oldmin.l, min.l, ampm.l, maxclox.l 
Global bgbrush.l, cloxbrush.l, cursor.POINT, child.l, set.l, winx.l, winy.l 
Global bgwin.l, fgwin.l, bgclox, fgclox, ontop.l 

min=0 
oldmin=-1 
block=196 
height=30 
set=0 

Structure cloxstruct 
  tid.l 
  cid.l 
  sid.l 
  oid.l 
  bid.l 
  name.s 
  offset.l 
EndStructure 

Global Dim clock.cloxstruct(#limit) 

For i=0 To #limit 
  clock(i)\tid=10+i 
  clock(i)\cid=20+i 
  clock(i)\sid=30+i 
  clock(i)\oid=40+i 
  clock(i)\bid=50+i 
Next 
  
maxx=GetSystemMetrics_(#SM_CXSCREEN) 
maxy=GetSystemMetrics_(#SM_CYSCREEN) 

#pop=9 
#add=0 
#remove=1 
#OnTop=2 
#set=3 
#ampm=4 
#bgwin=5 
#fgwin=6 
#bgclox=7 
#fgclox=8 
#title=9 
#close=10 
#font1=0 
#font2=1 

LoadFont(#font1, "comic sans ms", 11) 
LoadFont(#font2, "comic sans ms", 9) 

Procedure LoadPrefs(ininame.s) 
  OpenPreferences(ininame) 
  winx=ReadPreferenceLong("winx",0) 
  winy=ReadPreferenceLong("winy",0) 
  maxclox=ReadPreferenceLong("maxclox",0) 
  bgwin=ReadPreferenceLong("bgwin",$77FFFF) 
  fgwin=ReadPreferenceLong("fgwin",$111177) 
  bgclox=ReadPreferenceLong("bgclox",$FFFFFF) 
  fgclox=ReadPreferenceLong("fgclox",$771111) 
  ontop=ReadPreferenceLong("ontop",1) 
  ampm=ReadPreferenceLong("ampm",1) 
  For i=0 To #limit 
    clock(i)\name=ReadPreferenceString("clock"+Str(i)+"name","glox "+Str(i)) 
    clock(i)\offset=ReadPreferenceLong("clock"+Str(i)+"offset",0) 
  Next i 
  ClosePreferences() 
EndProcedure 

Procedure savePrefs(ininame.s) 
  CreatePreferences(ininame) 
  WritePreferenceLong("winx",WindowX(0)) 
  WritePreferenceLong("winy",WindowY(0)) 
  WritePreferenceLong("maxclox",clox-1) 
  WritePreferenceLong("bgwin",bgwin) 
  WritePreferenceLong("fgwin",fgwin) 
  WritePreferenceLong("bgclox",bgclox) 
  WritePreferenceLong("fgclox",fgclox) 
  WritePreferenceLong("ontop",ontop) 
  WritePreferenceLong("ampm",ampm) 
  For i=0 To #limit 
    WritePreferenceString("clock"+Str(i)+"name",clock(i)\name) 
    WritePreferenceLong("clock"+Str(i)+"offset",clock(i)\offset) 
  Next i 
  ClosePreferences() 
EndProcedure 

Procedure ToggleOnTop() 
  If GetMenuItemState(#pop,#OnTop) 
    SetWindowPos_(WindowID(0),#HWND_TOPMOST,0,0,0,0,#SWP_SHOWWINDOW|#SWP_NOMOVE|#SWP_NOSIZE) 
  Else 
    SetWindowPos_(WindowID(0),#HWND_NOTOPMOST,0,0,0,0,#SWP_SHOWWINDOW|#SWP_NOMOVE|#SWP_NOSIZE) 
  EndIf  
EndProcedure 

Procedure MyWindowCallback(WindowID,Msg,wParam,lParam) 
  ret.l = #PB_ProcessPureBasicEvents  
  If WindowID=WindowID(0) 
    Select Msg 
    Case #WM_CTLCOLORSTATIC 
      For i=0 To #limit 
        If GadgetID(clock(i)\tid)=lParam 
          SetBkMode_(wParam,#TRANSPARENT) 
          SetTextColor_(wParam, fgwin) 
          ret = bgbrush 
          i=#limit 
        EndIf 
        If GadgetID(clock(i)\cid)=lParam 
          SetBkMode_(wParam,#TRANSPARENT) 
          SetTextColor_(wParam, fgclox) 
          ret = cloxbrush 
          i=#limit 
        EndIf 
      Next 
    EndSelect 
  EndIf 
  ProcedureReturn ret 
EndProcedure 

Procedure myWindow() 
  OpenWindow(0,winx,winy,block,30,"",#PB_Window_BorderLess) 
  CreateGadgetList(WindowID(0)) 
  For i=0 To #limit 
    StringGadget(clock(i)\sid,  i*block+5      ,5,90,20,clock(i)\name, #PB_Text_Right) 
    ComboBoxGadget(clock(i)\oid,i*block+5+ 90+5,3,60, 200)        
    ButtonGadget(clock(i)\bid,  i*block+5+155+5,5,25,20,"set" ) 
    TextGadget(clock(i)\tid,    i*block+5      ,5,100,20,clock(i)\name+":", #PB_Text_Right) 
    TextGadget(clock(i)\cid,    i*block+5+100+5,3,80,24,"00:00",#PB_Text_Border | #PB_Text_Center) 
    HideGadget(clock(i)\tid,1) 
    HideGadget(clock(i)\cid,1) 
    HideGadget(clock(i)\sid,1) 
    HideGadget(clock(i)\oid,1) 
    HideGadget(clock(i)\bid,1) 
    SetGadgetFont(clock(i)\tid, FontID(#font1)) 
    SetGadgetFont(clock(i)\cid, FontID(#font1)) 
    SetGadgetFont(clock(i)\sid, FontID(#font2)) 
    SetGadgetFont(clock(i)\oid, FontID(#font2)) 
    SetGadgetFont(clock(i)\bid, FontID(#font2)) 
  Next i  
  CreatePopupMenu(#pop) 
  MenuBar() 
  MenuItem(#add,"add clock") 
  MenuItem(#remove,"remove clock") 
  MenuItem(#set,"set clock") 
  MenuBar() 
  MenuItem(#OnTop,"on top") 
  MenuItem(#ampm,"AM / PM") 
  MenuBar() 
  OpenSubMenu("set colors") 
    MenuItem(#bgwin,"glox background") 
    MenuItem(#fgwin,"glox text") 
    MenuItem(#bgclox,"time background") 
    MenuItem(#fgclox,"time text") 
  CloseSubMenu() 
  MenuBar() 
  MenuItem(#close,"exit clox") 
  MenuBar() 
  MenuItem(#title,#appname+" "+#version+" -oppi-") 
  DisableMenuItem(#pop,#title,1) 
  SetWindowCallback(@MyWindowCallback()) 
EndProcedure  

Procedure addclox() 
  ResizeWindow(0,#PB_Ignore,#PB_Ignore,(clox+1)*block,height) 
  HideGadget( clock(clox)\tid,0) 
  HideGadget( clock(clox)\cid,0) 
  DisableMenuItem(#pop,#remove,0) 
  clox+1 
  oldmin=-1 
  If clox=#limit Or WindowWidth(0)+block>=maxx 
    DisableMenuItem(#pop,#add,1) 
  EndIf 
EndProcedure 

Procedure removeclox()  
  ResizeWindow(0,#PB_Ignore,#PB_Ignore,WindowWidth(0)-block,height) 
  HideGadget( clock(clox)\tid,1) 
  HideGadget( clock(clox)\cid,1) 
  clox-1 
  DisableMenuItem(#pop,#add,0) 
  If clox=1 
    DisableMenuItem(#pop,#remove,1) 
  EndIf  
EndProcedure  
  
Procedure initWindow() 
    bgbrush = CreateSolidBrush_(bgwin) ; for coloring 
    cloxbrush = CreateSolidBrush_(bgclox) 
    SetClassLong_(WindowID(0), #GCL_HBRBACKGROUND, bgbrush) 
    InvalidateRect_(WindowID(0), #Null, #True) 
    
  For i=0 To maxclox 
    addclox() 
    HideGadget(clock(i)\tid,0) 
    HideGadget(clock(i)\cid,0) 
  Next 
  If clox=1 
    DisableMenuItem(#pop,#remove,1) 
  EndIf  
  SetMenuItemState(#pop,#ampm,ampm) 
  SetMenuItemState(#pop,#OnTop,ontop) 
  ToggleOnTop() 
  
  For i=0 To #limit 
    For o=-47 To 47 
      AddGadgetItem(clock(i)\oid,-1,StrF(o/2,1)) 
    Next o 
    f.f=clock(i)\offset 
    SetGadgetState(clock(i)\oid,f/3600*2+47) 
  Next i 
  
EndProcedure 

Procedure tick() 
  For i=0 To clox 
    If ampm=1 
      If Hour(Date()+clock(i)\offset)>12 
        SetGadgetText(clock(i)\cid,FormatDate("%hh:%ii",Date()+clock(i)\offset-12*3600)+" PM") 
      Else 
        SetGadgetText(clock(i)\cid,FormatDate("%hh:%ii",Date()+clock(i)\offset)+" AM") 
      EndIf  
    Else 
      SetGadgetText(clock(i)\cid,FormatDate("%hh:%ii",Date()+clock(i)\offset)) 
    EndIf  
  Next 
EndProcedure 

Procedure setclox(id) 
  HideGadget(clock(id)\tid,1) 
  HideGadget(clock(id)\cid,1) 
  HideGadget(clock(id)\bid,0) 
  HideGadget(clock(id)\sid,0) 
  HideGadget(clock(id)\oid,0) 
  SendMessage_(GadgetID(clock(id)\sid),#EM_LIMITTEXT, 11,0 ) 
EndProcedure 

Procedure cloxset(id) 
  HideGadget(clock(id)\bid,1) 
  HideGadget(clock(id)\sid,1) 
  HideGadget(clock(id)\oid,1) 
  HideGadget(clock(id)\tid,0) 
  HideGadget(clock(id)\cid,0) 
  clock(id)\offset=ValF(GetGadgetText(clock(id)\oid))*3600 
  clock(id)\name=GetGadgetText(clock(id)\sid) 
  SetGadgetText(clock(id)\tid,clock(id)\name) 
  oldmin=-1 
EndProcedure 

LoadPrefs(#appname+".ini") 
myWindow() 
initWindow() 

Repeat 
  EventID = WindowEvent() 
  Select EventID 
    Case #WM_LBUTTONDOWN 
      If set=0 
      ReleaseCapture_() 
      SendMessage_(WindowID(0), #WM_NCLBUTTONDOWN, #HTCAPTION, NULL) 
      EndIf 
    Case #WM_RBUTTONDOWN 
      If set=0 
        GetCursorPos_(cursor) 
        DisplayPopupMenu(9,WindowID(0),cursor\x,cursor\y) 
        MapWindowPoints_(0,WindowID(0),cursor,1) 
        child=ChildWindowFromPoint_(WindowID(0),cursor\x,cursor\y) 
      EndIf  
    Case #PB_Event_Menu 
      MenuID = EventMenu() 
      Select MenuID 
        Case #add 
          addclox() 
        Case #remove 
          removeclox() 
        Case #set 
          set=1 
          For i=0 To #limit 
            If GadgetID(clock(i)\tid)=child Or GadgetID(clock(i)\sid)=child Or GadgetID(clock(i)\oid)=child Or GadgetID(clock(i)\cid)=child Or GadgetID(clock(i)\bid)=child 
              setclox(i) 
            EndIf 
          Next i 
        Case #OnTop 
          SetMenuItemState(#pop,#OnTop,GetMenuItemState(#pop,#OnTop)!1) 
          ToggleOnTop() 
          ontop=ontop!1 
        Case #ampm 
          SetMenuItemState(#pop,#ampm,GetMenuItemState(#pop,#ampm)!1) 
          ampm=ampm!1 
          oldmin=-1 
        Case #close 
          EventID=#PB_Event_CloseWindow 
        Case #bgwin 
          ret=ColorRequester() 
          If ret<>-1 
            bgwin=ret 
            DeleteObject_(bgbrush) 
            bgbrush = CreateSolidBrush_(bgwin) ; for coloring 
            SetClassLong_(WindowID(0), #GCL_HBRBACKGROUND, bgbrush) 
            InvalidateRect_(WindowID(0), #Null, #True) 
          EndIf 
        Case #bgclox 
          ret=ColorRequester() 
          If ret<>-1 
            bgclox=ret 
            DeleteObject_(cloxbrush) 
            cloxbrush = CreateSolidBrush_(bgclox) ; for coloring 
            InvalidateRect_(WindowID(0), #Null, #True) 
          EndIf 
        Case #fgwin 
          ret=ColorRequester() 
          If ret<>-1 
            fgwin=ret 
            InvalidateRect_(WindowID(0), #Null, #True) 
          EndIf 
        Case #fgclox 
          ret=ColorRequester() 
          If ret<>-1 
            fgclox=ret 
            InvalidateRect_(WindowID(0), #Null, #True) 
          EndIf 
      EndSelect    
    Case #PB_Event_Gadget 
      GadgetID = EventGadget() 
       For i=0 To #limit 
         If (clock(i)\bid)=GadgetID 
           cloxset(i) 
           set=0 
         EndIf 
       Next 
  EndSelect 
  min=Minute(Date()) 
  If oldmin<>min 
    tick() 
    oldmin=min 
  EndIf  
  Delay(30) 
Until EventID = #PB_Event_CloseWindow 

savePrefs(#appname+".ini") 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
