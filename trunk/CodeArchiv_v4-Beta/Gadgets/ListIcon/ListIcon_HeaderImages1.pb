; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8912&start=15
; Author: Denis (updated for PB4.00 by blbltheworm)
; Date: 31. December 2003
; OS: Windows
; Demo: No


; ****************
; The following constants and structures need only be declared, if you don't have the
; WinConstantsToPB.res file from http://denislabarre.free.fr/index_en.html 

#LVM_GETHEADER = 4127 
#LVM_GETCOLUMN = 4121 
#HDM_SETITEM      = 4612 
#HDM_GETITEM      = 4611 
#LVM_GETIMAGELIST = 4098 
#LVM_SETIMAGELIST = 4099 
#LVSIL_SMALL       = 1 
#LVCF_TEXT         = 4 

#ILC_MASK          = 1 
#ILC_COLOR32       = 32 

#HDF_BITMAP_ON_RIGHT = 4096 
#HDF_IMAGE           = 2048 
#HDF_STRING          = 16384 
#HDI_TEXT            = 2 
#HDI_IMAGE           = 32 
#HDI_FORMAT          = 4

Structure HDITEM 
     mask.l 
     cxy.l 
     pszText.l 
     hbm.l 
     cchTextMax.l 
     fmt.l 
     lParam.l 
     iImage.l 
     iOrder.l 
     type.l 
     pvFilter.l 
EndStructure 
; ******************


; constantes des Gadgets 

Enumeration 
  #MainWindow 
  #ListIconGadget1 
  #Image 
EndEnumeration 

#HDF_SORTDOWN = $200 
#HDF_SORTUP = $400 


Structure LVCOLUMN 
  mask.l 
  fmt.l 
  cx.l 
  pszText.l 
  cchTextMax.l 
  iSubItem.l 
  iImage.l 
  iOrder.l 
EndStructure 

; ;======================================================================================== 
; ;======================================================================================== 
Procedure SetHeaderImage(Gadget.l, Image.l, Column.l, Align.l) 
  ; get headerID 
  HwndHeader = SendMessage_(GadgetID(Gadget), #LVM_GETHEADER, 0, 0) 
  TextColumn.s = Space(255) 
  Var.LVCOLUMN\mask = #LVCF_TEXT 
  Var\pszText = @TextColumn 
  Var\cchTextMax = 255 
  SendMessage_(GadgetID(Gadget), #LVM_GETCOLUMN, Column, @Var) 
  
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_BITMAP | #HDI_FORMAT | #HDI_TEXT 
  VarHeader\fmt = #HDF_BITMAP | Align | #HDF_STRING 
  VarHeader\hbm = ImageID(Image) 
  VarHeader\pszText = @TextColumn 
  VarHeader\cchTextMax = Len(TextColumn) 
  SendMessage_(HwndHeader, #HDM_SETITEM, Column, @VarHeader) 
EndProcedure 

; ;======================================================================================== 
; ;======================================================================================== 

Procedure.l GetHeaderImageID(Gadget.l, Column.l) 
  ; get headerID 
  HwndHeader = SendMessage_(GadgetID(Gadget), #LVM_GETHEADER, 0, 0) 
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_BITMAP | #HDI_FORMAT 
  VarHeader\fmt = #HDF_BITMAP 
  VarHeader\hbm = 0 ; to be sure that this value is not the useimage() value, but Pb put already it to 0 
  SendMessage_(HwndHeader, #HDM_GETITEM, Column, @VarHeader) 
  ProcedureReturn VarHeader\hbm 
EndProcedure 

; ;======================================================================================== 
; ;======================================================================================== 

Procedure.l GetHeaderImageAlignment(Gadget.l, Column.l) 
  ; get alignment of the image 
  ; return 0 if no image 
  ; return 1 if on the left 
  ; return 2 if on the right 
  
  ; get headerID 
  HwndHeader = SendMessage_(GadgetID(Gadget), #LVM_GETHEADER, 0, 0) 
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_BITMAP | #HDI_FORMAT 
  VarHeader\fmt = #HDF_BITMAP 
  VarHeader\hbm = 0 ; to be sure that this value as not the useimage()  value but Pb put already it to 0 
  SendMessage_(HwndHeader, #HDM_GETITEM, Column, @VarHeader) 
  
  If VarHeader\hbm ; teste if image exist 
    If VarHeader\fmt & #HDF_BITMAP_ON_RIGHT 
      result = 2 
    Else 
      result = 1 
    EndIf 
  Else 
    result = VarHeader\hbm 
  EndIf 
  ProcedureReturn result 
EndProcedure 

; ;======================================================================================== 
; ;======================================================================================== 

If OpenWindow(#MainWindow, 0, 0, 420, 300, " Header image", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(#MainWindow)) And ListIconGadget(#ListIconGadget1, 10, 55, 400, 236, "Colonne 1", 398 / 4, #PB_ListIcon_MultiSelect) 
    AddGadgetColumn(#ListIconGadget1, 1, "Column 2", 398 / 4) 
    AddGadgetColumn(#ListIconGadget1, 2, "Colonne 3", 398 / 4) 
    AddGadgetColumn(#ListIconGadget1, 3, "Column 4", 398 / 4) 
    
    For i.b = 1 To 10 
      AddGadgetItem(#ListIconGadget1, -1, "111" + Chr(10) + "222" + Chr(10) + "333" + Chr(10) + "444" ) 
    Next i 
    
    ItemImage = CatchImage(#Image, ?CroixIco) ; get the image Handle 
    
    ; ;============== first column  Image to the right ======================== 
    SetHeaderImage(#ListIconGadget1, #Image, 0, #HDF_BITMAP_ON_RIGHT) 
    ; ;============== 3th  column Image to the left =========================== 
    SetHeaderImage(#ListIconGadget1, #Image, 2, 0) 
    ; ; ======================================================================= 
    
    string.s = "" + Chr(10) + Chr(13) 

    ; because col 2 and 4 (index 1 & 3) have no image, GetHeaderImageID() return 0 
    For i = 0 To 3 ; 4 columns 
      string + "GetHeaderImageID(#ListIconGadget1, Column " + Str(i + 1) + ")  =  " 
      string + Str(GetHeaderImageID(#ListIconGadget1, i)) + Chr(10) + Chr(13) 
      string + "UseImage(#Image) =  " + Str(ImageID(#Image)) + Chr(10) + Chr(13) 
      
      If GetHeaderImageAlignment(#ListIconGadget1, i) = 1 ; left 
        string + "Image is on the left" + Chr(10) + Chr(13) 
        
      ElseIf GetHeaderImageAlignment(#ListIconGadget1, i) = 2 ; right 
        string + "Image is on the right" + Chr(10) + Chr(13) 
        
      Else 
        string + "No image" + Chr(10) + Chr(13) 
      EndIf 
      string + Chr(10) + Chr(13) 
    Next 
    
    MessageRequester(" Header Images Infos", string, 64) 
    
  EndIf 
EndIf 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 


DataSection ; icon values 
  
  CroixIco : 
    Data.l $03364D42, $00000000, $00360000, $00280000, $00100000, $00100000 
    Data.l $00010000, $00000018, $03000000, $0EC30000, $0EC30000, $00000000 
    Data.l $00000000, $C0C00000, $CECECEC0, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6 
    Data.l $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6 
    Data.l $C0CECECE, $C0C0C0C0, $FFDFFFC0, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFDFFFFF 
    Data.l $CEB6B6B6, $DFFFCECE, $E97E65FF, $13BD3713, $3F1DBD37, $BF3F1DBF 
    Data.l $18C03C18, $3812C03C, $C0350DC2, $05C12E05, $2C02C12E, $E8765BC0 
    Data.l $B6FFDFFF, $FFFFB6B6, $DE4119FF, $25DE4E25, $5835DE4E, $E25835E2 
    Data.l $2CE25431, $5223E455, $E94B13E6, $0AE8430A, $3904E843, $C02C02E0 
    Data.l $B6FFFFFF, $FFFFB6B6, $E24E26FF, $FFE35B3A, $FFFFFFFF, $E25835FF 
    Data.l $2CE25431, $5223E455, $E94B13E6, $FFFFFFFF, $430AFFFF, $C12E05E8 
    Data.l $B6FFFFFF, $FFFFB6B6, $E24E26FF, $FFE35B3A, $FFFFFFFF, $FFFFFFFF 
    Data.l $37E76640, $5D2CE863, $FFFFFFE9, $FFFFFFFF, $430AFFFF, $C12E05E8 
    Data.l $B6FFFFFF, $FFFFB6B6, $E25431FF, $46E56546, $FFFFE565, $FFFFFFFF 
    Data.l $37FFFFFF, $FFFFE863, $FFFFFFFF, $0EFFFFFF, $480EE948, $C0350DE9 
    Data.l $B6FFFFFF, $FFFFB6B6, $E45F3FFF, $50E66D50, $7054E66D, $FFFFFFE7 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $1CE65223, $4B1CE04B, $C03C18E0 
    Data.l $B6FFFFFF, $FFFFB6B6, $E5684BFF, $5AE8755A, $7356E875, $E66C4FE7 
    Data.l $FFFFFFFF, $FFFFFFFF, $E45024FF, $24DF4C1F, $5024E450, $BF3F1DE4 
    Data.l $B6FFFFFF, $FFFFB6B6, $E77054FF, $62E97C62, $755AE97C, $FFFFFFE8 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $2CE24E26, $502CE150, $BE4223E1 
    Data.l $B6FFFFFF, $FFFFB6B6, $E8785DFF, $6CEB866C, $FFFFEB86, $FFFFFFFF 
    Data.l $3FFFFFFF, $FFFFE45F, $FFFFFFFF, $2CFFFFFF, $512CE151, $BE4223E1 
    Data.l $B6FFFFFF, $FFFFB6B6, $E9836AFF, $FFED947E, $FFFFFFFF, $FFFFFFFF 
    Data.l $48E76F53, $5F3FE567, $FFFFFFE4, $FFFFFFFF, $5431FFFF, $BE4223E2 
    Data.l $B6FFFFFF, $FFFFB6B6, $E9836AFF, $FFED947E, $FFFFFFFF, $EB866CFF 
    Data.l $5EE97E65, $765BE879, $E77054E8, $FFFFFFFF, $5431FFFF, $BE4223E2 
    Data.l $B6FFFFFF, $FFFFB6B6, $EE9883FF, $7EF0A895, $947EED94, $EB866CED 
    Data.l $5EE97E65, $765BE879, $E77054E8, $48E56848, $5937E568, $BF4121E3 
    Data.l $B6FFFFFF, $DFFFB6B6, $F2B5A6FF, $65ED947E, $7E65E97E, $E8785DE9 
    Data.l $53E77356, $6D50E76F, $E56748E6, $3FE45F3F, $512CE45F, $EA8670E1 
    Data.l $CEFFDFFF, $C0C0CECE, $FFDFFFC0, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFDFFFFF 
    Data.b - 64, -64, -64, -64, -64, -64 
  
  
EndDataSection

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
