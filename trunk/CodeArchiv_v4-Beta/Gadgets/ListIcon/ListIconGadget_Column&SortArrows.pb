; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3404&highlight=
; Author: Danilo (updated for PB 4.00 by Ligatur)
; Date: 11. January 2004
; OS: Windows
; Demo: 


; Hier mal der Code für die "Pfeile" und ein paar andere
; nützliche Funktionen fürs ListIconGadget.
; Wie man sieht sind die Pfeile nur ein Bilder, d.h. man
; kann auch eigene Bilder mit der Größe 16x16 verwenden.

;
; ListIconGagdet column header images
; with image switching
;
; by Danilo, 11.01.2004
;
;
; credits:
;   - sort function from PureArea.net code archive,
;     file  : ListIcon_SortbyColumn.pb
;     writer: unknown
;
Procedure CreateListIconArrows(StartImage)
  ; by Danilo, 11.01.2004
  ;
  ; generate 2 small 16x16 arrows, up & down
  ;
  For img = 0 To 1
    CreateImage(StartImage+img,16,16)
    StartDrawing(ImageOutput(StartImage+img))
      background = GetSysColor_(#COLOR_BTNFACE)
      FrontColor(background)
      Box(0,0,16,16)
      If img = 0 : Start=7 : Else : Start = 2 : EndIf
      For a = 6 To 10
        Line(Start,a,13-Start*2,0,0)
        Start+1
      Next a
    StopDrawing()
  Next
EndProcedure


Procedure AddListIconColumn(gadget,pos,width,align,text$,hImage)
  ; by Danilo, 11.01.2004
  ;
  ; Add column to ListIconGadget
  ;
  ;   gadget = the PB gadget number
  ;   pos    = position of the new column
  ;   width  = with     of the new column
  ;   align  = align    of the text in the column:
  ;            #LI_CENTERED, #LI_LEFT, #LI_RIGHT
  ;   text$  = column header text
  ;   hImage = image handle __OR__ index of already added image!
  ;
  #LVCF_IMAGE = $10
  #LVCFMT_COL_HAS_IMAGES = $8000
  #LI_CENTERED = #LVCFMT_CENTER
  #LI_LEFT     = #LVCFMT_LEFT
  #LI_RIGHT    = #LVCFMT_RIGHT
  Structure LVCOLUMN
    lv.LV_COLUMN
    iImage.l
    iOrder.l
  EndStructure
  If GetObjectType_(hImage)=#OBJ_BITMAP
    ; Add Image to List
    hImgL = SendMessage_(GadgetID(gadget),#LVM_GETIMAGELIST,#LVSIL_SMALL,0)
    If hImgL=0
      hImgL = ImageList_Create_(16,16,#ILC_COLOR32,1,1)
      SendMessage_(GadgetID(gadget),#LVM_SETIMAGELIST,#LVSIL_SMALL,hImgL)
    EndIf
    idx = ImageList_Add_(hImgL,hImage,0)
  Else
    ; was an index
    idx = hImage
  EndIf
  LVC.LVCOLUMN
  LVC\lv\mask = #LVCF_IMAGE|#LVCF_TEXT|#LVCF_WIDTH|#LVCF_FMT
  LVC\lv\fmt     = align|#LVCFMT_COL_HAS_IMAGES
  LVC\lv\pszText = @text$
  LVC\lv\cchTextMax = Len(text$)
  LVC\lv\iSubItem = pos
  LVC\lv\cx   = width
  LVC\iImage  = idx
  LVC\iOrder  = pos
  SendMessage_(GadgetID(gadget),#LVM_INSERTCOLUMN,pos,@LVC)
EndProcedure


Procedure GetListIconColumnImage(gadget,column)
  ; by Danilo, 11.01.2004
  ;
  ; returns the image_index of the column-header-image
  ;
  LVC.LVCOLUMN
  LVC\lv\mask = #LVCF_IMAGE
  SendMessage_(GadgetID(gadget),#LVM_GETCOLUMN,column,@LVC)
  ProcedureReturn LVC\iImage
EndProcedure


Procedure ChangeListIconColumnImage(gadget,column,Image_Index)
  ; by Danilo, 11.01.2004
  ;
  ; change the image_index of the column-header-image
  ;
  LVC.LVCOLUMN
  LVC\lv\mask = #LVCF_IMAGE
  LVC\iImage  = Image_Index
  ProcedureReturn SendMessage_(GadgetID(gadget),#LVM_SETCOLUMN,column,@LVC)
EndProcedure


Procedure SetListIconColumnText(gadget,index,Text$)
  ; by Danilo, 15.12.2003 - english chat (for 'Karbon')
  ;
  ; change column header text
  ;
  lvc.LV_COLUMN
  lvc\mask    = #LVCF_TEXT
  lvc\pszText = @Text$
  SendMessage_(GadgetID(gadget),#LVM_SETCOLUMN,index,@lvc)
EndProcedure


Procedure SetListIconColumnWidth(gadget,index,new_width)
  ; by Danilo, 15.12.2003 - english chat (for 'Karbon')
  ;
  ; change column header width
  ;
  SendMessage_(GadgetID(gadget),#LVM_SETCOLUMNWIDTH,index,new_width)
EndProcedure


Procedure SetListIconColumnFormat(gadget,index,format)
  ; by Danilo, 15.12.2003 - english chat (for 'Karbon')
  ;
  ; change text alignment for columns
  ;
  lvc.LV_COLUMN
  lvc\mask = #LVCF_FMT
  Select format
    Case 0: lvc\fmt = #LVCFMT_LEFT
    Case 1: lvc\fmt = #LVCFMT_CENTER
    Case 2: lvc\fmt = #LVCFMT_RIGHT
  EndSelect
  SendMessage_(GadgetID(gadget),#LVM_SETCOLUMN,index,@lvc)
EndProcedure




Procedure UpdatelParam(ListIconGadget,columns)
  ;
  ; PureArea.net CodeArchiv, by unknown
  ;
  ; modified by Danilo, 11.01.2004
  ;
  ItemCount = SendMessage_(ListIconGadget, #LVM_GETITEMCOUNT, 0, 0)
  lvi.LV_ITEM
  lvi\mask = #LVIF_PARAM
  lvi\iItem = 0
  While ItemCount>0
    lvi\lParam = lvi\iItem
    For SubItem = 0 To columns-1
      lvi\iSubItem = SubItem
      SendMessage_(ListIconGadget, #LVM_SETITEM, 0, @lvi)
    Next SubItem
    lvi\iItem +1
    ItemCount -1
  Wend
EndProcedure


Procedure ListIconSortFunction(lParam1,lParam2,lParamSort)
  ;
  ; PureArea.net CodeArchiv, by unknown
  ;
  ; modified by Danilo, 11.01.2004
  ;
  A$ = Space(200)
  B$ = Space(200)
  result = 0
  lvi.LV_ITEM
  lvi\iSubItem = lParamSort&$FFFF
  lvi\pszText = @A$
  lvi\cchTextMax = 200
  lvi\mask = #LVIF_TEXT
  SendMessage_(GadgetID(0), #LVM_GETITEMTEXT,lParam1,@lvi)
  lvi\pszText = @B$
  SendMessage_(GadgetID(0), #LVM_GETITEMTEXT,lParam2,@lvi)

  If A$ = B$
    ProcedureReturn 0 ; equal
  EndIf

  x = (lParamSort>>16)&$FFFF
  If x
    If A$ > B$
      ProcedureReturn  1
    Else
      ProcedureReturn -1
    EndIf
  Else
    If A$ > B$
      ProcedureReturn -1
    Else
      ProcedureReturn  1
    EndIf
  EndIf
  ProcedureReturn result
EndProcedure




;
;- Window Callback
;
Procedure WinProc(hWnd,Msg,wParam,lParam)
  result = #PB_ProcessPureBasicEvents
  Select Msg
    Case #WM_NOTIFY
      *NMHDR.NMHDR = lParam
      If *NMHDR\hWndFrom = GadgetID(0) ; comes from our ListIconGadget
        If *NMHDR\code = #LVN_COLUMNCLICK
          *NMLV.NMLISTVIEW = lParam
          column = *NMLV\iSubItem
          ; switch images:
          index  = GetListIconColumnImage(0,column)
          ChangeListIconColumnImage(0,column,index!1)
          ; sort
          SendMessage_(GadgetID(0),#LVM_SORTITEMS,column|((index)<<16),@ListIconSortFunction())
          UpdatelParam(GadgetID(0),5)
        EndIf
      EndIf
      result = 0
  EndSelect
  ProcedureReturn result
EndProcedure


;
;- program start
;
CreateListIconArrows(0)

OpenWindow(0,0,0,500,200,"LV",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  SetWindowCallback(@WinProc())
  CreateGadgetList(WindowID(0))
  ListIconGadget(0,0,0,500,200,"",0,#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
   AddListIconColumn(0,1,150,#LI_LEFT    ,"Column 1",ImageID(0)) ; add Image 0
   AddListIconColumn(0,2,120,#LI_CENTERED,"Column 2",ImageID(1)) ; add Image 1
   AddListIconColumn(0,3, 90,#LI_CENTERED,"Column 3",0)           ; use Image index 0
   AddListIconColumn(0,4,105,#LI_RIGHT   ,"Column 4",1)           ; use Image index 1
   
   For a = 0 To 100
     A$ = "COLUMN 1, Row "+RSet(Str(  a  ),3,"0")+Chr(10)
     x = Random($FFFF)
     B$ =                  RSet(Str(  x  ),5,"0")+Chr(10)
     x = Random($7FFFFFFF)
     C$ =              "$"+RSet(Hex(  x  ),8,"0")+Chr(10)
     D$ = "COL 4, Row "   +RSet(Str(100-a),3,"0")
     AddGadgetItem(0,-1,Chr(10)+A$+B$+C$+D$)
   Next
   
   UpdatelParam(GadgetID(0),5)
   
Repeat:Until WaitWindowEvent()=#PB_Event_CloseWindow 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = --
; EnableXP