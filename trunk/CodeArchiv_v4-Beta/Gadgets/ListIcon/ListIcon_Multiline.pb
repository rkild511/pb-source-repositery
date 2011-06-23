; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13226&highlight=
; Author: Sparkie (updated for PB 4.00 by Andre)
; Date: 06. December 2004
; OS: Windows
; Demo: No

; Basics for drawing a custom multiline ListIconGadget
; ****************************************************
; You can specify wordwrap for each column as necessary. 
; Here I use wordwrap in Column 0 and single line with ellipsis (...) as needed.

; Still To-Do list: 
; ------------------
; Support #PB_ListIcon_CheckBoxes 
; Support #PB_ListIcon_AlwaysShowSelection 
; Support #PB_ListIcon_MultiSelect 
; Support icons 

; --> Constants 
#LVM_GETSUBITEMRECT = #LVM_FIRST + 56 

#DT_WORD_ELLIPSIS = $40000 
#DT_END_ELLIPSIS = $8000 
#DT_PATH_ELLIPSIS = $4000 
#DT_MODIFYSTRING = $10000 

#CDIS_CHECKED = 8 
#CDIS_DEFAULT = $20 
#CDIS_DISABLED = 4 
#CDIS_FOCUS = $10 
#CDIS_GRAYED = 2 
#CDIS_HOT = $40 
#CDIS_INDETERMINATE = $100 
#CDIS_MARKED = $80 
#CDIS_SELECTED = 1 
#CDIS_SHOWKEYBOARDCUES = $200 

#CDDS_ITEM = $10000 
#CDDS_MAPPART = 5 
#CDDS_POSTERASE = 4 
#CDDS_POSTPAINT = 2 
#CDDS_PREERASE = 3 
#CDDS_PREPAINT = 1 
#CDDS_ITEMPOSTERASE = #CDDS_ITEM | #CDDS_POSTERASE 
#CDDS_ITEMPOSTPAINT = #CDDS_ITEM | #CDDS_POSTPAINT 
#CDDS_ITEMPREERASE = #CDDS_ITEM | #CDDS_PREERASE 
#CDDS_ITEMPREPAINT = #CDDS_ITEM | #CDDS_PREPAINT 
#CDDS_SUBITEM = $20000 

#CDRF_DODEFAULT = 0 
#CDRF_NEWFONT = 2 
#CDRF_NOTIFYITEMDRAW = $20 
#CDRF_NOTIFYPOSTERASE = $40 
#CDRF_NOTIFYPOSTPAINT = $10 
#CDRF_NOTIFYSUBITEMDRAW = $20 
#CDRF_SKIPDEFAULT = 4 

; --> Create assorted brushes for passing on to device context 
Global Dim brush(4) 

Enumeration 
  #C0Brush 
  #C1Brush 
  #C2Brush 
  #SelectedBrush 
EndEnumeration 

brush(#C0Brush) = CreateSolidBrush_(RGB(255, 155, 155))       ; column 0 brush 
brush(#C1Brush) = CreateSolidBrush_(RGB(155, 255, 155))       ; column 1 brush 
brush(#C2Brush) = CreateSolidBrush_(RGB(155, 155, 255))       ; column 2 brush 
brush(#SelectedBrush) = CreateSolidBrush_(RGB(255, 255, 155)) ; selected row brush 

; --> Windowcallback 
Procedure myWindowCallback(hwnd, msg, wparam, lparam) 
  result = #PB_ProcessPureBasicEvents 
  Select msg 
     Case #WM_NOTIFY 
      *nmhdr.NMHEADER = lparam 
      ; --> Lock column 0 width 
      If *nmhdr\hdr\code = #HDN_ITEMCHANGING  And *nmhdr\iItem = 0 
        result = #True 
      EndIf 
      *lvCD.NMLVCUSTOMDRAW = lparam 
      If *lvCD\nmcd\hdr\hwndFrom=GadgetID(0) And *lvCD\nmcd\hdr\code = #NM_CUSTOMDRAW    
        Select *lvCD\nmcd\dwDrawStage 
          Case #CDDS_PREPAINT 
            result = #CDRF_NOTIFYITEMDRAW 
          Case #CDDS_ITEMPREPAINT 
            result = #CDRF_NOTIFYSUBITEMDRAW; 
          Case #CDDS_ITEMPREPAINT | #CDDS_SUBITEM 
            thisItem = *lvCD\nmcd\dwItemSpec 
            ; --> Define rect for text 
            subItemRect.RECT\left = #LVIR_LABEL 
            subItemRect.RECT\top = *lvCD\iSubItem 
            ; --> Get the subitem rect 
            SendMessage_(GadgetID(0), #LVM_GETSUBITEMRECT, thisItem, @subItemRect) 
            subItemText$ = GetGadgetItemText(0, *lvCD\nmcd\dwItemSpec, *lvCD\iSubItem) 
            sitLen = Len(subItemText$) 
            Select *lvCD\iSubItem 
              Case 0 
                ; --> Define text and background colors for column 0 and set Drawtext_() flags 
                lvFlags =  #DT_END_ELLIPSIS | #DT_WORDBREAK;| #DT_MODIFYSTRING 
                ; --> Paint over unused icon rect 
                subItemRect\left = 0 
                If GetGadgetState(0) = thisItem 
                  ; --> If item is selected, colorize column 0 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush)) 
                Else 
                  ; --> If item is not selected, colorize column 0 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C0Brush)) 
                EndIf 
              ; --> Text color for column 0 
              SetTextColor_(*lvCD\nmcd\hDC, RGB(100, 0, 0)) 
              Case 1 
                ; --> Define text and background colors for column 1 and set Drawtext_() flags 
                lvFlags = #DT_END_ELLIPSIS | #DT_SINGLELINE | #DT_VCENTER 
                If GetGadgetState(0) = thisItem 
                  ; --> If item is selected, colorize column 1 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush)) 
                Else 
                  ; --> If item is not selected, colorize column 1 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C1Brush)) 
                EndIf 
                ; --> Text color for column 1 
                SetTextColor_(*lvCD\nmcd\hDC, RGB(0, 100, 0)) 
              Case 2 
                ; --> Define text and background colors for column 2 and set Drawtext_() flags 
                lvFlags = #DT_END_ELLIPSIS | #DT_SINGLELINE | #DT_VCENTER 
                If GetGadgetState(0) = thisItem 
                  ; --> If item is selected, colorize column x 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush)) 
                Else 
                  ; --> If item is not selected, colorize column x 
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C2Brush)) 
                EndIf 
                ; --> Text color for column x 
                SetTextColor_(*lvCD\nmcd\hDC, RGB(0, 0, 100)) 
            EndSelect 
            ; --> Adjust rect for text margins 
            subItemRect\left +3 
            subItemRect\right -3 
            subItemRect\bottom -3 
            ; --> Draw our text 
            DrawText_(*lvCD\nmcd\hDC, subItemText$, sitLen, subItemRect, lvFlags) 
            result = #CDRF_SKIPDEFAULT 
        EndSelect 
      EndIf 
  EndSelect 
  ProcedureReturn result 
EndProcedure 

If OpenWindow(0, 0, 0, 480, 260,"Sparkies Multiline ListIconGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
  SetWindowCallback(@myWindowCallback()) 
  CreateStatusBar(0, WindowID(0)) 
  ListIconGadget(0, 10, 10, 470, 225, "Column 0", 150,#PB_ListIcon_FullRowSelect) 
  AddGadgetColumn(0, 1, "Column 1", 150) 
  AddGadgetColumn(0, 2, "Column 2", 150) 
  ; --> Create a new imagelist (1x30) to increase row hieght 
  imageList = ImageList_Create_(1, 30, #ILC_COLOR32, 0, 30) 
  SendMessage_(GadgetID(0), #LVM_SETIMAGELIST, #LVSIL_SMALL, imageList) 
  For a=0 To 9
    addtext$ = "Locked Column 0 item #" + Str(a) + Chr(13) + "on 2 lines of text." + Chr(10) + "Column 1 item #" + Str(a) + " on 1 line" + Chr(10) + "Column 2 item #" + Str(a) + " on 1 line" 
    atLen = Len(addtext$) 
    AddGadgetItem(0,-1, addtext$) 
  Next 
  Repeat 
    event = WaitWindowEvent() 
    Select event 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 0 
            ; --> Display selected ListIconGadget index in statusbar 
            StatusBarText(0, 0, "Selected item index is: " + Str(GetGadgetState(0))) 
        EndSelect 
    EndSelect 
  Until event = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -