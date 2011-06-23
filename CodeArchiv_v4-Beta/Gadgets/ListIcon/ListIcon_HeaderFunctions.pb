; English forum: http://www.purebasic.fr/english/viewtopic.php?t=12751&highlight=
; Author: sverson (updated for PB 4.00 by Andre)
; Date: 04. February 2005
; OS: Windows
; Demo: No


; Functions for ListIcon headers:
; originally written by Eddy, improved by sverson)

; o listicon header : captured or released 
;   (works with several listicon gadgets in the same window) 
; o resize correctly the last column 
; o hidden columns 
; o second listicon gadget 
; o resize main window 
; 
; ...And new functions 
; + CountListIconColumns using #HDM_GETITEMCOUNT 
; + column click resize using #LVN_COLUMNCLICK / #LVSCW_AUTOSIZE 


;/ Tricks 'n' Tips: 12.10.2004 08:06    
;/                  listicon Header : captured Or released 
;/                  http://jconserv.net/purebasic/viewtopic.php?t=12751&highlight=Header+listicon 
;/                  by eddy 
;/ modified:        04.02.1005 sverson 

Enumeration;- Windows 
  #MainWindow 
EndEnumeration 

Enumeration;- Gadgets 
  #ListIcon01 
  #ListIcon02 
  #Splitter01 
EndEnumeration 

#LVM_GETHEADER = (#LVM_FIRST + 31) 

Global LastListiconHeaderCaptured 

Procedure.l CountListIconColumns(Gadget_ID.l);- count columns 
  Protected hHdr.l, lResult.l 
  hHdr    = SendMessage_(Gadget_ID,#LVM_GETHEADER,0,0) 
  lResult = SendMessage_(hHdr,#HDM_GETITEMCOUNT,#Null,#Null) 
  ProcedureReturn lResult 
EndProcedure 

Procedure ListIconLastColumnFixed(Gadget_ID.l);- resize last column 
  SendMessage_(Gadget_ID,#LVM_SETCOLUMNWIDTH, CountListIconColumns(Gadget_ID)-1,#LVSCW_AUTOSIZE_USEHEADER) 
EndProcedure 

Procedure.b ListIconHeaderCaptured(Gadget.l);- return captured header, if not return zero 
  Protected hHdr.l, bResult.b 
  hHdr.l  = SendMessage_(GadgetID(Gadget),#LVM_GETHEADER,0,0) 
  If GetCapture_()=hHdr 
    LastListiconHeaderCaptured = hHdr 
    bResult = LastListiconHeaderCaptured 
  Else 
    bResult = #False 
  EndIf 
  ProcedureReturn bResult 
EndProcedure 

Procedure.b ListIconHeaderReleased(Gadget.l);- return TRUE if mouse released listicon header 
  Protected hHdr.l, bResult.b 
  hHdr.l = SendMessage_(GadgetID(Gadget),#LVM_GETHEADER,0,0)    
  If LastListiconHeaderCaptured=hHdr             ; if listicon header was captured 
    If GetCapture_()<>LastListiconHeaderCaptured ; if it has been released 
      LastListiconHeaderCaptured=0 
      bResult = #True 
    EndIf 
  Else 
    bResult = #False 
  EndIf 
  ProcedureReturn bResult 
EndProcedure 

Procedure WindowCallBack(Window, message, wParam, lParam);- Window Callback 
  Protected wWidth.l, wHeight.l, Gadget_ID.l, AktColumn.l, LastColumn.l 
  ReturnValue = #PB_ProcessPureBasicEvents 
  Select message 
    Case #WM_SIZE 
      If Window = WindowID(#MainWindow) 
        wWidth = WindowWidth(#MainWindow)   : If wWidth<320  : wWidth=320  : ElseIf wWidth>800  : wWidth=800  : EndIf 
        wHeight = WindowHeight(#MainWindow) : If wHeight<240 : wHeight=240 : ElseIf wHeight>600 : wHeight=600 : EndIf 
        ResizeWindow(#MainWindow, #PB_Ignore, #PB_Ignore, wWidth, wHeight) 
        ResizeGadget(#Splitter01,-1,-1,wWidth-20,wHeight-20) 
        ListIconLastColumnFixed(GadgetID(#ListIcon01)) 
        ListIconLastColumnFixed(GadgetID(#ListIcon02)) 
      EndIf 
    Case #WM_NOTIFY 
      *nmHEADER.HD_NOTIFY = lParam 
      Gadget_ID = *nmHEADER\hdr\hwndFrom 
      Select *nmHEADER\hdr\code 
        Case #HDN_ITEMCHANGING ; is header item changing? 
          Select GetParent_(Gadget_ID) 
            Case GadgetID(#ListIcon01) 
              If *nmHEADER\iItem = 1 ; second col fixed 
                ;Beep_(1200,50) 
                ReturnValue = #True 
              EndIf 
            Case GadgetID(#ListIcon02) 
              If *nmHEADER\iItem = 0 Or *nmHEADER\iItem = 2 ; first and third col fixed (hidden) 
                ;Beep_(1200,50) 
                ReturnValue = #True 
              EndIf 
          EndSelect 
        Case #LVN_COLUMNCLICK 
          *pnmv.NM_LISTVIEW = lParam 
          AktColumn  = *pnmv\iSubItem 
          LastColumn = CountListIconColumns(Gadget_ID)-1 
          If AktColumn <> LastColumn 
            ;Beep_(600,50) 
            SendMessage_(Gadget_ID,#LVM_SETCOLUMNWIDTH,AktColumn,#LVSCW_AUTOSIZE) 
            SendMessage_(Gadget_ID,#LVM_SETCOLUMNWIDTH,LastColumn,#LVSCW_AUTOSIZE_USEHEADER) 
          EndIf 
      EndSelect 
  EndSelect 
  ProcedureReturn ReturnValue 
EndProcedure 

;{- START OF EXAMPLE 

OpenWindow(#MainWindow,0,0,640,480,"fixed & hidden columns / auto resize",#PB_Window_SystemMenu|#PB_Window_WindowCentered|#PB_Window_SizeGadget) 
If CreateGadgetList(WindowID(#MainWindow)) 
  ListIconGadget(#ListIcon01,10,10, WindowWidth(#MainWindow)-20, WindowHeight(#MainWindow)-20, "click" ,70,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect) 
    AddGadgetColumn(#ListIcon01,1,"fixed",50) 
    AddGadgetColumn(#ListIcon01,2,"click",50) 
    AddGadgetColumn(#ListIcon01,3,"auto resize",50) 
    ListIconLastColumnFixed(GadgetID(#ListIcon01))    
    AddGadgetItem(#ListIcon01,-1,"a long text ... a long text"+Chr(10)+"BB"+Chr(10)+"CC"+Chr(10)+"DD"+Chr(10)) 
    AddGadgetItem(#ListIcon01,-1,"AA"+Chr(10)+"BB"+Chr(10)+"a long text ... a long text"+Chr(10)+"DD"+Chr(10)) 
  ListIconGadget(#ListIcon02,10,10, WindowWidth(#MainWindow)-20, WindowHeight(#MainWindow)-20, "fixed hidden" ,0,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect) 
    AddGadgetColumn(#ListIcon02,1,"click",50) 
    AddGadgetColumn(#ListIcon02,2,"fixed hidden",0) 
    AddGadgetColumn(#ListIcon02,3,"auto resize",70) 
    ListIconLastColumnFixed(GadgetID(#ListIcon02))    
  SplitterGadget(#Splitter01,10,10, WindowWidth(#MainWindow)-20, WindowHeight(#MainWindow)-20,#ListIcon01,#ListIcon02) 
    AddGadgetItem(#ListIcon02,-1,"hidden"+Chr(10)+"visible"+Chr(10)+"hidden"+Chr(10)+"a long text ... a long text"+Chr(10)) 
    AddGadgetItem(#ListIcon02,-1,"hidden"+Chr(10)+"a long text ... a long text"+Chr(10)+"hidden"+Chr(10)+"visible"+Chr(10)) 
    SetWindowCallback(@WindowCallBack()) 
  
  Repeat 
    EventID.l = WaitWindowEvent()    
    
    ;if listicon header is captured 
    If EventID=#WM_MOUSEMOVE 
      If ListIconHeaderCaptured(#ListIcon01) Or ListIconHeaderCaptured(#ListIcon02) 
        Debug "move header" 
      EndIf 
    EndIf 
    ;if release listicon header 
    If EventID=#WM_LBUTTONUP 
      If ListIconHeaderReleased(#ListIcon01) 
        ListIconLastColumnFixed(GadgetID(#ListIcon01)) 
        Debug "** release header **" 
        Debug "--> resize last column" 
      EndIf 
      If ListIconHeaderReleased(#ListIcon02) 
        ListIconLastColumnFixed(GadgetID(#ListIcon02)) 
        Debug "** release header **" 
        Debug "--> resize last column" 
      EndIf 
    EndIf 
  Until EventID = #PB_Event_CloseWindow 
  
EndIf    

End ;}- END OF EXAMPLE 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --