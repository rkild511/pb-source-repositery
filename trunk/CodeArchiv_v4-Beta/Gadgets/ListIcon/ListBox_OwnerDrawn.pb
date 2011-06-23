; English forum: http://www.purebasic.fr/english/viewtopic.php?t=14310&highlight=
; Author: localmotion34 (updated for PB 4.00 by Andre)
; Date: 07. March 2005
; OS: Windows
; Demo: No


; Here is an example of an ownerdraw listbox that AVOIDS using SetWindowCallback(). 
; Much thanks to Sparkie for getting me back on track after being dazed and 
; confused with the very unclear win32 documentation on #wm_drawitem. 

; Here's how it works:
; -create a borderless window 
; -create a listviewgadget the EXACT same size And location 
; -SUBCLASS the borderless window To process the #wm_drawitem message of the listbox 
; -Use the ProcedureReturn to throw back the gadget identifier, so the listbox can 
;  be handled in the regular PB event loop, because the listbox has not been subclassed 
; 
; NOTE: this will become a PB library along with a similar version of an OWNERDRAW 
; COMBOBOX. i refuse to make a library that uses SetWindowCallback() because many 
; authors use this in their own program, which would then interfere with my LIB. 
; Instead i subclass, which then creates the ability to use otherwise difficult gadgets. 
; 

Global OriginProc.l ,lb,icontouse,hbrushDefault,hbrushSelected,hbrushSelectedFocus 

hbrushDefault.l = CreateSolidBrush_(#White) 
hbrushSelected.l = CreateSolidBrush_(RGB(200, 255, 200)) 
hbrushSelectedFocus.l = CreateSolidBrush_(RGB(0, 0, 80)) 

#ODS_SELECTED=1 
#ODS_GRAYED=2 
#ODS_DISABLED=4 
#ODS_CHECKED=8 
#ODS_FOCUS=16 
#ODS_DEFAULT= 32 
#ODS_COMBOBOXEDIT= 4096 
#ODT_STATIC  = 5 
#SS_OWNERDRAW=13 

Procedure ListboxProc( hwnd, msg,wParam,lParam) 
  Select msg 
    Case #WM_DRAWITEM 
      *lpdis.DRAWITEMSTRUCT=lParam 
      *lptris.DRAWITEMSTRUCT=*lpdis.DRAWITEMSTRUCT 
      ;*lptris\rcItem\left+18 
      Select *lpdis\CtlType 
        Case #ODT_LISTBOX 
          lbText$ = GetGadgetItemText(lb, *lpdis\itemID, 0) 
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

UseJPEGImageDecoder() 

;LoadImage(9,"INI.ico") 
icontouse=CreateImage(10,32,32) 
StartDrawing(ImageOutput(10)) 
Box(0,0,32,32,#White) 
Box(0,0,20,20,#Red) 
StopDrawing() 

If OpenWindow(0,0,0,322,275,"OwnerDrawn ListBox",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  CreateGadgetList(WindowID(0)) 
  list=Listbox(0,8,10,200,200,WindowID(0)) 
  For i = 1 To 11 
    AddListboxItem(list,-1,"Item " + Str(i) + " of the Listview",icontouse) 
  Next 
  
  Repeat 
    EventID.l=WaitWindowEvent() 
    Select EventID 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case list 
            Debug "rock on" 
          Case 2 
            
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
; Folding = -