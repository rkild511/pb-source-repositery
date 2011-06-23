; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1028&postdays=0&postorder=asc&start=10
; Author: Christian (updated for PB 4.00 by Andre)
; Date: 12. December 2004
; OS: Windows
; Demo: No


; Author: Sparkie & Christian
; Date: 12. December 2004


; Basics for drawing a custom multiline ListIconGadget
; ****************************************************
; You can specify wordwrap for each column as necessary.
; Here I use wordwrap in Column 0 and single line with ellipsis (...) as needed.

; Still To-Do list:
; ------------------
; Support #PB_ListIcon_CheckBoxes

; --> Constants
#LVM_GETSUBITEMRECT = #LVM_FIRST + 56
#LVM_GETEXTENDEDLISTVIEWSTYLE = #LVM_FIRST + 55
#LVS_EX_CHECKBOXES = $4
#LVS_SHOWSELALWAYS = $8

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

#NO_ICON = -1

#IconID = 0

; --> Needed Variables
Global ImgListHnd.l

; --> Create assorted brushes for passing on to device context
Global Dim brush(4)

Enumeration
  #C0Brush
  #C1Brush
  #C2Brush
  #SelectedBrush
  #AlwaysSelectedBrush
EndEnumeration

brush(#C0Brush) = CreateSolidBrush_(RGB(255, 155, 155))       ; column 0 brush
brush(#C1Brush) = CreateSolidBrush_(RGB(155, 255, 155))       ; column 1 brush
brush(#C2Brush) = CreateSolidBrush_(RGB(155, 155, 255))       ; column 2 brush
brush(#SelectedBrush) = CreateSolidBrush_(RGB(255, 255, 155)) ; selected row brush
brush(#AlwaysSelectedBrush) = CreateSolidBrush_(RGB(200, 200, 200)) ; AlwaysShowSelection row brush

; --> Load Icon

;LoadImage(#IconID, "Icon16.bmp") ; Specify your own path -> Image has to be 16*16 or 32*32 in size

; We create an image instead
CreateImage(#IconID,32,32)
StartDrawing(ImageOutput(#IconID))
Box(1,1,32,32,RGB(100,100,255))
Box(5,5,7,7,RGB(255,50,100))
Box(20,20,7,7,RGB(255,255,100))
StopDrawing()

; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                      Procedures
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; --> Get the Extended ListView Styles
Procedure GetExStyle(GadgetID)
  ProcedureReturn SendMessage_(GadgetID(GadgetID), #LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
EndProcedure

; --> Get the Styles of a Gadget
Procedure GetStyle(GadgetID)
  ProcedureReturn GetWindowLong_(GadgetID(GadgetID), #GWL_STYLE)
EndProcedure

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

            IconRect.RECT
            IconRect\left = #LVIR_ICON;
            SendMessage_(GadgetID(0), #LVM_GETITEMRECT, thisItem, IconRect);

            Select *lvCD\iSubItem
              Case 0
                ; --> Define text and background colors for column 0 and set Drawtext_() flags
                lvFlags =  #DT_END_ELLIPSIS | #DT_WORDBREAK;| #DT_MODIFYSTRING
                ; --> Paint over unused icon rect
                subItemRect\left = 0
                If GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected And GetActiveWindow_() = hwnd
                  ; --> If item is selected, colorize column 0
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush))
                ElseIf GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected And GetActiveWindow_() <> hwnd And GetFocus_() <> GadgetID(0) And GetStyle(0) & #PB_ListIcon_AlwaysShowSelection
                  ; --> If item is selected but gadget has no focus, colorize column 0
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#AlwaysSelectedBrush))
                Else
                  ; --> If item is not selected, colorize column 0
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C0Brush))
                EndIf
                ; --> Text color for column 0
                SetTextColor_(*lvCD\nmcd\hDC, RGB(100, 0, 0))

                ; --> Draw Icon if there is one
                ImageList_GetIconSize_(ImgListHnd, @IconWidth, @IconHeight)
                ImageList_Draw_(ImgListHnd, thisItem, *lvCD\nmcd\hDC, IconRect\left, subitemrect\top, #ILD_TRANSPARENT)

              Case 1
                ; --> Define text and background colors for column 1 and set Drawtext_() flags
                lvFlags = #DT_END_ELLIPSIS | #DT_SINGLELINE | #DT_VCENTER
                If GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected And GetActiveWindow_() = hwnd
                  ; --> If item is selected, colorize column 1
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush)) And GetActiveWindow_() <> hwnd And GetFocus_() <> GadgetID(0) And GetStyle(0) & #PB_ListIcon_AlwaysShowSelection
                ElseIf GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected
                  ; --> If item is selected but gadget has no focus, colorize column 1
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#AlwaysSelectedBrush))
                Else
                  ; --> If item is not selected, colorize column 1
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C1Brush))
                EndIf
                ; --> Text color for column 1
                SetTextColor_(*lvCD\nmcd\hDC, RGB(0, 100, 0))

              Case 2
                ; --> Define text and background colors for column 2 and set Drawtext_() flags
                lvFlags = #DT_END_ELLIPSIS | #DT_SINGLELINE | #DT_VCENTER
                If GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected And GetActiveWindow_() = hwnd
                  ; --> If item is selected, colorize column 2
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#SelectedBrush))
                ElseIf GetGadgetItemState(0, thisItem) & #PB_ListIcon_Selected And GetActiveWindow_() <> hwnd And GetFocus_() <> GadgetID(0) And GetStyle(0) & #PB_ListIcon_AlwaysShowSelection
                  ; --> If item is selected but gadget has no focus, colorize column 2
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#AlwaysSelectedBrush))
                Else
                  ; --> If item is not selected, colorize column 2
                  FillRect_(*lvCD\nmcd\hDC, subItemRect, brush(#C2Brush))
                EndIf
                ; --> Text color for column x
                SetTextColor_(*lvCD\nmcd\hDC, RGB(0, 0, 100))
            EndSelect

            ; --> Adjust rect for text margins
            subItemRect\left + 5 + IconWidth
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


; --> Own AddGadgetItem for better handling of the ImagleList
Procedure.l AddGadgetItem_(GadgetID.l, Position.l, Text.s, ImageID.l)
  ImgListHnd = SendMessage_(GadgetID(GadgetID), #LVM_GETIMAGELIST, #LVSIL_SMALL, 0)
  ; --> If there is no ImageList but an image that has to be drawn ...
  If ImgListHnd = 0  And ImageID <> -1
    ; --> ... create ImageList ...
    ImgListHnd = ImageList_Create_(32, 32, #ILC_COLORDDB|#ILC_MASK, 0, 0)
    SendMessage_(GadgetID(GadgetID), #LVM_SETIMAGELIST, #LVSIL_SMALL, ImgListHnd)

    ; -- ... check whether image is 16*16 or 32*32 ...
    ImageWidth = ImageWidth(ImageID) : ImageHeight = ImageHeight(ImageID)
    ; --> ... if 16*16, set size to 32*32 and centre picture ...
    If ImageWidth = 16 And ImageHeight = 16
      CreateImage(ImageID + 1, 32, 32)
      If StartDrawing(ImageOutput(ImageID))
        Box(0, 0, 32, 32, $000000)
        DrawImage(ImageID(ImageID), 16/2, 16/2)
        StopDrawing()
      EndIf
      ImageID = ImageID(ImageID + 1)
    ElseIf ImageWidth = 32 And ImageHeight = 32
      ImageID = ImageID(ImageID)
    EndIf

    If ImgListHnd
      ; --> ... and add item to ListIconGadget and transparent image to its ImageList
      AddGadgetItem(GadgetID, Position, Text) : ImageList_AddMasked_(ImgListHnd, ImageID, $000000)
    EndIf


    ; --> If there is an ImageList and an image that has to be drawn ...
  ElseIf ImgListHnd And ImageID <> -1
    ; -- ... check whether image is 16*16 or 32*32 ...
    ImageWidth = ImageWidth(ImageID) : ImageHeight = ImageHeight(ImageID)
    ; --> ... if 16*16, set size to 32*32 and centre picture ...
    If ImageWidth = 16 And ImageHeight = 16
      CreateImage(ImageID + 1, 32, 32)
      If StartDrawing(ImageOutput(ImageID))
        Box(0, 0, 32, 32, $000000)
        DrawImage(ImageID(ImageID), 16/2, 16/2)
        StopDrawing()
      EndIf
      ImageID = ImageID(ImageID + 1)
    ElseIf ImageWidth = 32 And ImageHeight = 32
      ImageID = ImageID(ImageID)
    EndIf

    ; --> ... and add item to ListIconGadget and transparent image to its ImageList
    AddGadgetItem(GadgetID, Position, Text) : ImageList_AddMasked_(ImgListHnd, ImageID, $000000)


    ; --> If there is no ImageList and no image that has to be drawn ...
  ElseIf ImgListHnd = 0 And ImageID = -1
    ; --> ... create ImageList for having two rows possible ...
    ImgListHnd = ImageList_Create_(1, 32, #ILC_COLORDDB|#ILC_MASK, 0, 0)
    SendMessage_(GadgetID(GadgetID), #LVM_SETIMAGELIST, #LVSIL_SMALL, ImgListHnd)

    If ImgListHnd
      ; --> ... and add item to ListIconGadget without image
      AddGadgetItem(GadgetID, Position, Text); : ImageList_AddMasked_(ImgListHnd, ImageID, $000000)
    EndIf


    ; --> If there is an ImageList and no image that has to be drawn ...
  ElseIf ImgListHnd And ImageID = -1
    ; --> ... add item to ListIconGadget without image
    AddGadgetItem(GadgetID, Position, Text)
  EndIf

  ProcedureReturn ImgListHnd
EndProcedure


; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;                        Main
; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If OpenWindow(0, 0, 0, 500, 260,"Sparkies Multiline ListIconGadget",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0))
  CreateStatusBar(0, WindowID(0))
  ListIconGadget(0, 10, 10, 490, 225, "Column 0", 170, #PB_ListIcon_FullRowSelect | #PB_ListIcon_MultiSelect | #PB_ListIcon_AlwaysShowSelection)
  AddGadgetColumn(0, 1, "Column 1", 150)
  AddGadgetColumn(0, 2, "Column 2", 150)

  For a=0 To 9
    addtext$ = "Locked Column 0 item #" + Str(a) + Chr(13) + "on 2 lines of text." + Chr(10) + "Column 1 item #" + Str(a) + " on 1 line" + Chr(10) + "Column 2 item #" + Str(a) + " on 1 line"
    atLen = Len(addtext$)
    AddGadgetItem_(0, a, addtext$, #IconID) ; last Parameter has to be #NO_ICON if you don't want to draw an icon
    ; else the #ImageID of your image
  Next
  SetWindowCallback(@myWindowCallback())

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