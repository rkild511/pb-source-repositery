; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14334&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 09. March 2005
; OS: Windows
; Demo: No


; Listbox, ComboboxEx, ColorComboBox 

; Yet again here is source for the above gadgets, with ownerdraw listboxes and comboboxes, 
; BUT with a color combobox picker seen in many applications. the combo color picker will 
; allow the user to add selected colors and select a color, and with a simple getcombocolor() 
; command, will return the RGB/$FF values associated with that color. 
; 
; This will all be released as ONE library, with NO NEED for SetWindowCallback() commands, 
; as ALL are subclassed. 
; 
; Included in this release will be listbox, comboboxEx, color combo picker, powerpoint 
; listview, paneDC gadget (like microsoft), a string-grid calendar much like Delphi 7 or 
; Visual basic 6, and possible a Scope-gadget, which will monitor and graph the input 
; given to it. i just need some feedback and alpha/bug testing. i think and hope this 
; library will really extend the functionality of PB. 


Global OriginProc.l, OriginProc1.l,lb,icontouse,hbrushDefault,hbrushSelected,hbrushSelectedFocus 

hbrushDefault.l = CreateSolidBrush_(#White) 
hbrushSelected.l = CreateSolidBrush_(RGB(200, 255, 200)) 
hbrushSelectedFocus.l = CreateSolidBrush_(RGB(0, 0, 80)) 
#DI_NORMAL = $0003 
#ODS_SELECTED=1 
#ODS_GRAYED=2 
#ODS_DISABLED=4 
#ODS_CHECKED=8 
#ODS_FOCUS=16 
#ODS_DEFAULT= 32 
#ODS_COMBOBOXEDIT= 4096 
#ODT_STATIC  = 5 
#SS_OWNERDRAW=13 

Procedure comboproc(hwnd,msg,wParam,lParam) 
  Select msg 
    Case #WM_DRAWITEM 
      *textbuffer.s=Space(255) 
      listb=GetWindow_(hwnd,#GW_CHILD) 
      *lpdis.DRAWITEMSTRUCT=lParam 
      *lptris.DRAWITEMSTRUCT=*lpdis.DRAWITEMSTRUCT 
      Select *lpdis\CtlType 
        Case #ODT_COMBOBOX 
          Select *lpdis\itemState 
            Case #ODS_SELECTED 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = CreateSolidBrush_(RGB(0, 0, 80)) 
              currentTextColor = #White 
            Case #ODS_SELECTED | #ODS_FOCUS 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = hbrushSelectedFocus 
              currentTextColor = #White 
            Case 0 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = #White 
              currentTextColor = RGB(0, 0, 0) 
          EndSelect 
          SendMessage_(*lpdis\hwndItem,#CB_GETLBTEXT,*lpdis\itemID,*textbuffer) 
          cbText$=*textbuffer 
          FillRect_(*lpdis\hdc, *lpdis\rcItem, currentBrush) 
          SetBkMode_(*lpdis\hdc, #TRANSPARENT) 
          SetTextColor_(*lpdis\hdc, currentTextColor) 
          *lpdis\rcItem\left+32 
          DrawText_(*lpdis\hdc, cbText$, Len(cbText$), *lptris\rcItem, dtFlags) 
          hbmpPicture = SendMessage_(*lpdis\hwndItem,#CB_GETITEMDATA, *lpdis\itemID,0) 
          hdcMem = CreateCompatibleDC_(*lpdis\hdc) 
          hbmpOld = SelectObject_(hdcMem, hbmpPicture) 
          BitBlt_(*lpdis\hdc, *lpdis\rcItem\left-32, *lpdis\rcItem\top, *lpdis\rcItem\right - *lpdis\rcItem\left,*lpdis\rcItem\bottom - *lpdis\rcItem\top, hdcMem, 0, 0, #SRCCOPY) 
          SelectObject_(hdcMem, hbmpOld); 
          DeleteDC_(hdcMem) 
          ProcedureReturn 0 
      EndSelect 
  EndSelect 
  ProcedureReturn CallWindowProc_(OriginProc1,hwnd,msg,wParam,lParam) 
EndProcedure 
    
Procedure ListboxProc( hwnd, msg,wParam,lParam) 
  Select msg 
    Case #WM_DRAWITEM 
     *textbuffer.s=Space(255) 
      listb=GetWindow_(hwnd,#GW_CHILD) 
      *lpdis.DRAWITEMSTRUCT=lParam 
      *lptris.DRAWITEMSTRUCT=*lpdis.DRAWITEMSTRUCT 
      Select *lpdis\CtlType 
        Case #ODT_LISTBOX 
          Select *lpdis\itemState 
            Case #ODS_SELECTED 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = CreateSolidBrush_(RGB(0, 0, 80)) 
              currentTextColor = #White 
            Case #ODS_SELECTED | #ODS_FOCUS 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = hbrushSelectedFocus 
              currentTextColor = #White 
            Case 0 
              dtFlags = #DT_LEFT | #DT_VCENTER 
              currentBrush = #White 
              currentTextColor = RGB(0, 0, 0) 
          EndSelect 
          SendMessage_(*lpdis\hwndItem,#LB_GETTEXT,*lpdis\itemID,*textbuffer) 
          lbText$=*textbuffer 
          FillRect_(*lpdis\hdc, *lpdis\rcItem, currentBrush) 
          SetBkMode_(*lpdis\hdc, #TRANSPARENT) 
          SetTextColor_(*lpdis\hdc, currentTextColor) 
          *lpdis\rcItem\left+32 
          DrawText_(*lpdis\hdc, lbText$, Len(lbText$), *lptris\rcItem, dtFlags) 
          hbmpPicture = SendMessage_(*lpdis\hwndItem,#LB_GETITEMDATA, *lpdis\itemID,0) 
          hdcMem = CreateCompatibleDC_(*lpdis\hdc) 
          hbmpOld = SelectObject_(hdcMem, hbmpPicture) 
          BitBlt_(*lpdis\hdc, *lpdis\rcItem\left-32, *lpdis\rcItem\top, *lpdis\rcItem\right - *lpdis\rcItem\left,*lpdis\rcItem\bottom - *lpdis\rcItem\top, hdcMem, 0, 0, #SRCCOPY) 
          SelectObject_(hdcMem, hbmpOld); 
          DeleteDC_(hdcMem) 
          ProcedureReturn 0 
      EndSelect 
  EndSelect 
  ProcedureReturn CallWindowProc_(OriginProc,hwnd,msg,wParam,lParam) 
EndProcedure    

ProcedureDLL Listbox(number,x,y,width,height,parent) 
  window=OpenWindow(#PB_Any,x,y,width,height,"",#PB_Window_BorderLess|#PB_Window_Invisible) 
  SetWindowLong_(WindowID(window),#GWL_STYLE, #WS_CHILD|#WS_DLGFRAME|#WS_EX_CLIENTEDGE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS ) 
  SetParent_(WindowID(window),parent) 
  ShowWindow_(WindowID(window),#SW_SHOW) 
  CreateGadgetList(WindowID(window)) 
  lb=ListViewGadget(#PB_Any,0,0,width,height,#LBS_OWNERDRAWFIXED|#LBS_HASSTRINGS) 
  OriginProc= SetWindowLong_(WindowID(window), #GWL_WNDPROC, @ListboxProc()) 
  SendMessage_(GadgetID(lb), #LB_SETITEMDATA, 0, icontouse) 
  SendMessage_(GadgetID(lb),#LB_SETITEMHEIGHT,0,32) 
  ProcedureReturn lb 
EndProcedure 

ProcedureDLL ComboBoxEx(number,x,y,width,height,parent) 
  combowindow=OpenWindow(#PB_Any,x,y,width,height,"",#PB_Window_BorderLess|#PB_Window_Invisible) 
  SetWindowLong_(WindowID(combowindow),#GWL_STYLE, #WS_CHILD|#WS_DLGFRAME|#WS_EX_CLIENTEDGE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS ) 
  SetParent_(WindowID(combowindow),parent) 
  ShowWindow_(WindowID(combowindow),#SW_SHOW) 
  CreateGadgetList(WindowID(combowindow)) 
  combo=ComboBoxGadget(#PB_Any, 0,0,width,height,#CBS_OWNERDRAWFIXED|#CBS_HASSTRINGS) 
  SendMessage_(GadgetID(combo),#CB_SETITEMHEIGHT,-1,32) 
  SendMessage_(GadgetID(combo),#CB_SETITEMHEIGHT,0,32) 
  OriginProc1= SetWindowLong_(WindowID(combowindow), #GWL_WNDPROC, @comboproc()) 
  ProcedureReturn combo 
EndProcedure 

ProcedureDLL ColorComboBox(number,x,y,width,height,parent) 
  combowindow=OpenWindow(#PB_Any,x,y,width,height,"",#PB_Window_BorderLess|#PB_Window_Invisible) 
  SetWindowLong_(WindowID(combowindow),#GWL_STYLE, #WS_CHILD|#WS_DLGFRAME|#WS_EX_CLIENTEDGE|#WS_CLIPCHILDREN|#WS_CLIPSIBLINGS ) 
  SetParent_(WindowID(combowindow),parent) 
  ShowWindow_(WindowID(combowindow),#SW_SHOW) 
  CreateGadgetList(WindowID(combowindow)) 
  combo=ComboBoxGadget(#PB_Any, 0,0,width,height,#CBS_OWNERDRAWFIXED|#CBS_HASSTRINGS) 
  SendMessage_(GadgetID(combo),#CB_SETITEMHEIGHT,-1,20) 
  SendMessage_(GadgetID(combo),#CB_SETITEMHEIGHT,0,20) 
  OriginProc1= SetWindowLong_(WindowID(combowindow), #GWL_WNDPROC, @comboproc()) 
  ProcedureReturn combo 
EndProcedure 

ProcedureDLL AddListboxItem(listbox.l,Position.l,text.s,imageid.l) 
  If Position =-1 
    itemreturn=SendMessage_(GadgetID(listbox),#LB_ADDSTRING,0,text) 
    SendMessage_(GadgetID(listbox),#LB_SETITEMDATA,itemreturn,imageid) 
    ProcedureReturn itemreturn 
  Else 
    itemreturn=SendMessage_(GadgetID(listbox),#LB_INSERTSTRING,Position,text) 
    SendMessage_(GadgetID(listbox),#LB_SETITEMDATA,itemreturn,imageid) 
    ProcedureReturn itemreturn 
  EndIf 
EndProcedure 

ProcedureDLL AddCBItem(combobox.l,Position.l,text.s,imageid.l) 
  If Position =-1 
    itemreturn=SendMessage_(GadgetID(combobox),#CB_ADDSTRING,0,text) 
    SendMessage_(GadgetID(combobox),#CB_SETITEMDATA,itemreturn,imageid) 
    ProcedureReturn itemreturn 
  Else 
    itemreturn=SendMessage_(GadgetID(combobox),#CB_INSERTSTRING,Position,text) 
    SendMessage_(GadgetID(combobox),#CB_SETITEMDATA,itemreturn,imageid) 
    ProcedureReturn itemreturn 
  EndIf 
EndProcedure 

ProcedureDLL AddColorCBItem(combobox.l,Position.l,text.s,ColorID.l) 
  ic = CreateImage(#PB_Any,16,16)
  icon=ImageID(ic)
  StartDrawing(ImageOutput(ic)) 
  DrawImage(icon,0,0) 
  Box(0,0,16,16,ColorID) 
  StopDrawing() 
  If Position =-1 
    itemreturn=SendMessage_(GadgetID(combobox),#CB_ADDSTRING,0,text) 
    SendMessage_(GadgetID(combobox),#CB_SETITEMDATA,itemreturn,icon) 
    ProcedureReturn itemreturn 
  Else 
    itemreturn=SendMessage_(GadgetID(combobox),#CB_INSERTSTRING,Position,text) 
    SendMessage_(GadgetID(combobox),#CB_SETITEMDATA,itemreturn,icon) 
    ProcedureReturn itemreturn 
  EndIf 
EndProcedure 
UseJPEGImageDecoder() 


icontouse=CreateImage(10,32,32) 
StartDrawing(ImageOutput(10)) 
DrawImage(icontouse,0,0) 
Box(0,0,32,32,#White) 
Box(0,0,20,20,#Red) 
StopDrawing() 

If OpenWindow(0,0,0,322,375,"StringGadget Flags",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  CreateGadgetList(WindowID(0)) 
  list=Listbox(0,8,10,200,200,WindowID(0)) 
  com=ComboBoxEx(8,8,215,300,300,WindowID(0)) 
  colcb=ColorComboBox(10,8,270,200,200,WindowID(0)) 
  nextcolcb=ColorComboBox(11,8,300,200,200,WindowID(0)) 
  For i = 1 To 11 
    AddColorCBItem(colcb,-1,"Item " + Str(i) + " of the Combo",RGB(i*30,i*20,i*30)) 
  Next 
  For i = 1 To 11 
    AddCBItem(com,-1,"Item " + Str(i) + " of the Combo",icontouse) 
  Next 
  For i = 1 To 11 
    AddListboxItem(list,-1,"Item " + Str(i) + " of the Listview",icontouse) 
  Next 
  
  AddColorCBItem(nextcolcb,-1,"Red",#Red) 
  AddColorCBItem(nextcolcb,-1,"Blue",#Blue) 
  AddColorCBItem(nextcolcb,-1,"Green",#Green) 
  AddColorCBItem(nextcolcb,-1,"Yellow",#Yellow) 
  AddColorCBItem(nextcolcb,-1,"Aqua",$FFF034) 
  
  Repeat 
    EventID.l=WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case list 
            Debug "rock on" 
          Case com 
            Debug " on" 
        EndSelect 
        
      Case #WM_CLOSE 
        Quit=1 
        DeleteObject_(hbrushDefault) 
        DeleteObject_(hbrushSelected) 
        DeleteObject_(hbrushSelectedFocus) 
        
    EndSelect  
  Until Quit=1 
EndIf   

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --