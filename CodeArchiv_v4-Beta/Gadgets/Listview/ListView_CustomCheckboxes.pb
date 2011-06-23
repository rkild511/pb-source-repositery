; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11341&highlight=
; Author: Fluid Byte
; Date: 27. December 2006
; OS: Windows
; Demo: No

; Title:  Custom ListView Checkboxes 
; Author: Fluid Byte 
; Date:   December 27, 2006 

CreateImage(0,32,16) 

hdc = StartDrawing(ImageOutput(0)) 
Box(0,0,32,16,GetSysColor_(#COLOR_WINDOW)) 
Box(2,2,13,13) : Box(18,2,13,13) 
SetRect_(erc.RECT,3,3,14,14) 
DrawEdge_(hdc,erc,#BDR_RAISEDINNER,#BF_RECT | #BF_MIDDLE) 
OffsetRect_(erc,16,0) 
DrawEdge_(hdc,erc,#BDR_RAISEDINNER,#BF_RECT | #BF_MIDDLE) 

hPenLine = CreatePen_(0,2,0) 
SelectObject_(hdc,hPenLine) 
LineXY(20,4,28,12) : LineXY(28,4,20,12) 
DeleteObject_(hPenLine) 
StopDrawing() 

OpenWindow(0,0,0,400,300,"Custom ListView Checkboxes",#WS_OVERLAPPEDWINDOW | 1) 
CreateGadgetList(WindowID(0)) 
ListIconGadget(0,5,5,390,290,"Name",350) 

himlListview = ImageList_Create_(16,16,#ILC_COLOR16,0,0) 
ImageList_Add_(himlListview,ImageID(0),0) 
SendMessage_(GadgetID(0),#LVM_SETIMAGELIST,#LVSIL_SMALL,himlListview) 
SendMessage_(GadgetID(0),#LVM_SETIMAGELIST,#LVSIL_NORMAL,himlListview) 

For i=1 To 30 : AddGadgetItem(0,-1,"List-View Item #" + Str(i)) : Next 

While WaitWindowEvent() ! 16 
   If EventType() = #PB_EventType_LeftClick 
      GetCursorPos_(cpt.POINT)       
      ScreenToClient_(GadgetID(0),cpt) 

      MX = cpt\x : MY = cpt\y 

      lvh.LVHITTESTINFO 
      lvh\pt\x = MX : lvh\pt\y = MY 
      SendMessage_(GadgetID(0),#LVM_HITTEST,0,lvh) 
       
      If lvh\flags = #LVHT_ONITEMICON 
         lvi.LV_ITEM 
         lvi\mask = #LVIF_IMAGE 
         lvi\iItem = GetGadgetState(0)    
         SendMessage_(GadgetID(0),#LVM_GETITEM,0,lvi) 
          
         lvi\iImage = 1 - lvi\iImage 
         SendMessage_(GadgetID(0),#LVM_SETITEM,0,lvi) 
      EndIf 
   EndIf 
Wend 

ImageList_Destroy_(himlListview)
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP