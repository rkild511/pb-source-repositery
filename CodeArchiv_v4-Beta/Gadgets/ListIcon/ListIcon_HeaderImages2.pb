; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8912&start=15 
; Author: Denis (updated for PB4.00 by Leonhard)
; Date: 01. January 2004 
; OS: Windows
; Demo: No


; Note from Denis about the creation of the image list , 
; Hwnd_ListSmall = ImageList_Create_(16, 16, #ILC_MASK | #ILC_COLOR32, 0, 30) 
;   The first and second parameters are the icon sizes, you could put another values like 
;   24 /24, 32/32 Or 16/24. 
;   For the third param, take a look to the MS Platform SDK and if you don't have it on 
;   your HD, it's here http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/commctls/imagelist/functions/imagelist_create.asp 


; **************** 
; The following constants and structures need only be declared, if you don't have the 
; WinConstantsToPB.res file from http://denislabarre.free.fr/index_en.html 

hLib=OpenLibrary(#PB_Any,"comctl32.dll") 
Prototype.l ImageList_Create(cx.l, cy.l, flags.l, cInitial.l, cGrow.l) 
Prototype.l ImageList_ReplaceIcon(himl, i, hIcon) 
Prototype.b ImageList_Destroy(himl.l) 
Global ImageList_Create.ImageList_Create           = GetFunction(hLib, "ImageList_Create") 
Global ImageList_ReplaceIcon.ImageList_ReplaceIcon = GetFunction(hLib, "ImageList_ReplaceIcon") 
Global ImageList_Destroy.ImageList_Destroy         = GetFunction(hLib, "ImageList_Destroy") 

;/ #define  ImageList_AddIcon(himl, hicon) ImageList_ReplaceIcon(himl, -1, hicon) 
Macro ImageList_AddIcon(himl, hicon) 
  ImageList_ReplaceIcon(himl, -1, hicon) 
EndMacro 


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

#ImageOnTheLeft = 1 
#ImageOnTheRight = 2 
#NoImage = 0 

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

Global Hwnd_ListSmall.l 

; ======================================================================================== 
; ======================================================================================== 
Procedure.l GetHeaderID(Gadget) 
  ProcedureReturn SendMessage_(GadgetID(Gadget), #LVM_GETHEADER, 0, 0) 
EndProcedure 

; ======================================================================================== 
; ======================================================================================== 

Procedure SetHeaderImage(Gadget.l, ImageIndex.l, Column.l, Align.l) 
  TextColumn.s = Space(255) 
  Var.LVCOLUMN\mask = #LVCF_TEXT 
  Var\pszText = @TextColumn 
  Var\cchTextMax = 255 
  SendMessage_(GadgetID(Gadget), #LVM_GETCOLUMN, Column, @Var) 
  
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_IMAGE | #HDI_FORMAT | #HDI_TEXT 
  VarHeader\fmt = #HDF_IMAGE | Align | #HDF_STRING 
  ; VarHeader\hbm = UseImage(Image) 
  VarHeader\iImage = ImageIndex 
  VarHeader\pszText = @TextColumn 
  VarHeader\cchTextMax = Len(TextColumn) 
  SendMessage_(GetHeaderID(Gadget), #HDM_SETITEM, Column, @VarHeader) 
EndProcedure 

; ======================================================================================== 
; ======================================================================================== 

Procedure.l GetHeaderImageIndexID(Gadget.l, Column.l) 
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_IMAGE | #HDI_FORMAT 
  VarHeader\fmt = #HDF_IMAGE 
  VarHeader\iImage = -1 ; to be sure that this value is not an image list icon index 
  SendMessage_(GetHeaderID(Gadget), #HDM_GETITEM, Column, @VarHeader) 
  ProcedureReturn VarHeader\iImage 
EndProcedure 

; ======================================================================================== 
; ======================================================================================== 

Procedure.l GetHeaderImageAlignment(Gadget.l, Column.l) 
  ; get alignment of the image 
  ; return 0 if no image 
  ; return 1 if on the left 
  ; return 2 if on the right 
  
  ; variable on HDITEM 
  VarHeader.HDITEM\mask = #HDI_IMAGE | #HDI_FORMAT 
  VarHeader\fmt = #HDF_IMAGE 
  VarHeader\iImage = -1 ; to be sure that this value is not an image list icon index 
  SendMessage_(GetHeaderID(Gadget), #HDM_GETITEM, Column, @VarHeader) 
  
  If VarHeader\iImage ; teste if image exist 
    If VarHeader\fmt & #HDF_BITMAP_ON_RIGHT 
      result = #ImageOnTheRight 
    Else 
      result = #ImageOnTheLeft 
    EndIf 
  Else 
    result = #NoImage 
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
      AddGadgetItem(#ListIconGadget1, -1, "111" + Chr(10) + "222" + Chr(10) + "333" + Chr(10) + "444") 
    Next i 
    
    ; To add an image to the header, an Image list must be assigned to the listicon. 
    ; 2 cases: 
    ; 
    ; The image list already exist with small icon (created by PB) 
    ; If not, you must create it 
    ; Get image List Handle if exist 
    Hwnd_ListSmall.l = SendMessage_(GadgetID(#ListIconGadget1), #LVM_GETIMAGELIST, #LVSIL_SMALL, 0) 
    
    If Hwnd_ListSmall ; Hwnd_ListSmall is no null, the list image exist 
      
      
    Else 
      ; here the list image does not exist, you create it 
      ; create the image list, take a look to put max number on image inside the list (last param) 
      Hwnd_ListSmall = ImageList_Create(16, 16, #ILC_MASK | #ILC_COLOR32, 0, 30) 
      If Hwnd_ListSmall 
        ; assign the image list to the ListIconGadget 
        SendMessage_(GadgetID(#ListIconGadget1), #LVM_SETIMAGELIST, #LVSIL_SMALL, Hwnd_ListSmall) 
        ; Because PB use an transpareent ico (index 0 of the list), you must put it if you create the list 
        TransparentIco.l = CatchImage(#image, ?TransparentIco) 
        IndexTransparentIco = ImageList_AddIcon(Hwnd_ListSmall, TransparentIco) 
        FreeImage(#image) 
      EndIf 
      
      ; Load the image from the DataSection 
      ; add the image To the list. Be carefull, in that example, only ico format ! 
      ; get the index image from the list. You will use this index to display the icon 
      ArrowL.l = CatchImage(#image, ?FlecheGIco) 
      IndexArrowL = ImageList_AddIcon(Hwnd_ListSmall, ArrowL) 
      FreeImage(#image) ; you can destroy the image because there is a copy inside the list 
      
      ArrowR.l = CatchImage(#image, ?FlecheDIco) 
      IndexArrowR = ImageList_AddIcon(Hwnd_ListSmall, ArrowR) 
      FreeImage(#image) 
      
      CroixB.l = CatchImage(#image, ?CroixBleueIco) 
      IndexCroixB = ImageList_AddIcon(Hwnd_ListSmall, CroixB) 
      FreeImage(#image) 
      
      PBIco.l = CatchImage(#image, ?PB_Ico) 
      IndexPBIco = ImageList_AddIcon(Hwnd_ListSmall, PBIco) 
      FreeImage(#image) 
      
      ; ;============== first column  Image to the right ======================== 
      SetHeaderImage(#ListIconGadget1, IndexArrowL, 0, #HDF_BITMAP_ON_RIGHT) 
      ; ;============== 2nd  column Image to the left =========================== 
      SetHeaderImage(#ListIconGadget1, IndexPBIco, 1, 0) 
      ; ;============== 3th  column Image to the left =========================== 
      SetHeaderImage(#ListIconGadget1, IndexArrowR, 2, 0) 
      ; ;============== 4th  column Image to the right =========================== 
      SetHeaderImage(#ListIconGadget1, IndexCroixB, 3, #HDF_BITMAP_ON_RIGHT) 
      ; ; ======================================================================= 
      
      string.s = "" + Chr(10) + Chr(13) 
      
      For i = 0 To 3 ; 4 columns 
        string + "GetHeaderImageIndexID(#ListIconGadget1, Column " + Str(i + 1) + ")  =  " 
        string + Str(GetHeaderImageIndexID(#ListIconGadget1, i)) + Chr(10) + Chr(13) 
        string + "Image Index in the list =  " + Str(IndexArrowL) 
        
        If GetHeaderImageAlignment(#ListIconGadget1, i) = #ImageOnTheLeft ; left 
          string + "Image is on the left" + Chr(10) + Chr(13) 
          
        ElseIf GetHeaderImageAlignment(#ListIconGadget1, i) = #ImageOnTheRight ; right 
          string + "Image is on the right" + Chr(10) + Chr(13) 
          
        Else ; #NoImage 
          string + "No image" + Chr(10) + Chr(13) 
        EndIf 
        string + Chr(10) + Chr(13) 
      Next 
      
      MessageRequester(" Header Images Infos", string, 64) 
      
      
    EndIf 
    
    Repeat 
      Select WaitWindowEvent() 
        Case #PB_Event_CloseWindow 
          End 
      EndSelect 
    ForEver 
    
    ; destroy the imagelist 
    ImageList_Destroy(Hwnd_ListSmall) 
  EndIf 
EndIf 
End 


DataSection 
  
  TransparentIco : 
    Data.l $00010000, $10100001, $00010000, $05680008, $00160000, $00280000 
    Data.l $00100000, $00200000, $00010000, $00000008, $01400000, $00000000 
    Data.l $00000000, $00000000, $00000000, $EA000000, $454500FF, $00000045 
    Data.l $CE000000, $C90000FF, $9D0000FF, $B40000FE, $FE9300FF, $FD1300FF 
    Data.l $FFC700FF, $E50000FF, $FFEB00FF, $000000FF, $FFFF0000, $000000FF 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $02020000, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $02020202 
    Data.l $02020202, $02020202, $02020202, $02020202, $02020202, $FFFF0202 
    Data.l $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202 
    Data.l $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202, $FFFF0202 
    Data.b 2, 2, -1, -1, 2, 2, -1, -1, 2, 2, -1, -1, 2, 2 
  
  FlecheGIco : 
    Data.l $00010000, $10100001, $00010000, $03680018, $00160000, $00280000 
    Data.l $00100000, $00200000, $00010000, $00000018, $03400000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $FFFFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $00FFFFFF, $FFFF0000, $DBE3F8FF, $F2B7C6F1 
    Data.l $C9F3B8C9, $B9C9F3B9, $F2B9C9F3, $C9F2B8C9, $B3C8F5B8, $F4B3C8F5 
    Data.l $C6F3B2C8, $B0C4F2B1, $FFD9E3F6, $FFFFFFFF, $AAC0F3FF, $FBB7CBF9 
    Data.l $CEFAB9CE, $BCCEFABC, $FBBBCEF9, $CFFAB9CF, $B6CDFBB8, $F9B2CDFB 
    Data.l $C9F9B0CB, $AEC8F7AD, $FFB0C5F2, $FFFFFFFF, $ADC3F6FF, $FCBED0FC 
    Data.l $D3FDC2D3, $C2D5FCC3, $FBC2D5FC, $D4FBC1D5, $BAD4FCBD, $FCB7D3FC 
    Data.l $CEFBB3D1, $AECAFAAF, $FFB1C8F3, $FFFFFFFF, $B1C7F6FF, $FCC2D3FC 
    Data.l $D6FCC5D6, $C5D6FCC5, $FCC3D5FD, $6185C2D5, $C2D5FC4D, $FBB2CFFB 
    Data.l $CFFBB2CF, $B1CBFAB2, $FFB3C8F5, $FFFFFFFF, $B7CAF5FF, $FBC8D6FB 
    Data.l $D6FCC8D6, $C5D6FCC5, $85C3D5FD, $61854D61, $4D61854D, $FBB6CEFB 
    Data.l $CEFBB6CE, $B6CDFBB6, $FFB9CBF3, $FFFFFFFF, $B8CBF6FF, $FDC9D8FC 
    Data.l $D6FBCAD8, $C1D3FBC8, $854D6185, $61854D61, $B6CEFB4D, $FBB6CEFB 
    Data.l $CDFCB6CE, $B9CDFBB7, $FFBACBF4, $FFFFFFFF, $B8CBF6FF, $FDC9D8FC 
    Data.l $D8FDCAD8, $4D6185CA, $854D6185, $D3FB4D61, $B6CEFBC1, $FBB6CEFB 
    Data.l $CDFCB6CE, $B9CDFBB7, $FFBACBF4, $FFFFFFFF, $BDCEF7FF, $FCCDDBFC 
    Data.l $6185CDDA, $4D61854D, $FB4D6185, $D3FBC1D3, $B6CEFBC1, $FCB9CDFB 
    Data.l $CDFBB7CD, $B9CDFBB9, $FFBCCCF3, $FFFFFFFF, $BED0F8FF, $FDD0DDFC 
    Data.l $D9FDCEDD, $4D6185CA, $854D6185, $CDFB4D61, $B9CDFBB9, $FBBACDFC 
    Data.l $CDFCB9CD, $BACDFCBA, $FFBCCCF3, $FFFFFFFF, $BED0F8FF, $FDD0DDFC 
    Data.l $D9FDCEDD, $C8D6FBCA, $854D6185, $61854D61, $BBCEFD4D, $FBBACDFC 
    Data.l $CDFCB9CD, $BACDFCBA, $FFBCCCF3, $FFFFFFFF, $C4D4F7FF, $FDD4E1FC 
    Data.l $DBFCD1E0, $C9D8FCCD, $85C9D8FC, $61854D61, $4D61854D, $FDBBCEFD 
    Data.l $CEFDBBCE, $BCCEFABB, $FFBCCCF3, $FFFFFFFF, $CAD8F9FF, $FCDAE6FE 
    Data.l $DEFDD8E3, $CEDBFDD1, $FCCAD9FD, $6185C9D8, $C5D5FC4D, $FCC5D3FC 
    Data.l $D0FCC2D3, $BCCDFABE, $FFBACCF4, $FFFFFFFF, $D0DFFCFF, $FEE1EAFE 
    Data.l $E1FCDAE6, $D1E0FDD4, $FDD0DDFC, $DBFCCEDB, $CAD9FDCD, $FCC8D8FB 
    Data.l $D3FCC5D6, $BCCEFAC2, $FFB9C9F3, $FFFFFFFF, $E6EEFCFF, $F9D0DFFC 
    Data.l $D2F7CAD8, $C0D0F7C4, $F5BDCEF7, $CDF5BBCD, $B8CBF6BB, $F7B7CAF5 
    Data.l $C7F5B5C8, $AFC5F4B3, $FFDCE6F9, $0000FFFF, $FFFFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $00FFFFFF, $01800000, $0000FFFF, $0000FFFF 
    Data.l $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF 
    Data.l $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF 
    Data.b - 1, -1, -128, 1, -1, -1 
  
  
  FlecheDIco : 
    Data.l $00010000, $10100001, $00010000, $03680018, $00160000, $00280000 
    Data.l $00100000, $00200000, $00010000, $00000018, $03400000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $FFFFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $00FFFFFF, $FFFF0000, $DBE3F8FF, $F2B7C6F1 
    Data.l $C9F3B8C9, $B9C9F3B9, $F2B9C9F3, $C9F2B8C9, $B3C8F5B8, $F4B3C8F5 
    Data.l $C6F3B2C8, $B0C4F2B1, $FFD9E3F6, $FFFFFFFF, $AAC0F3FF, $FBB7CBF9 
    Data.l $CEFAB9CE, $BCCEFABC, $FBBBCEF9, $CFFAB9CF, $B6CDFBB8, $F9B2CDFB 
    Data.l $C9F9B0CB, $AEC8F7AD, $FFB0C5F2, $FFFFFFFF, $ADC3F6FF, $FCBED0FC 
    Data.l $D3FDC2D3, $C2D5FCC3, $FBC2D5FC, $D4FBC1D5, $BAD4FCBD, $FCB7D3FC 
    Data.l $CEFBB3D1, $AECAFAAF, $FFB1C8F3, $FFFFFFFF, $B1C7F6FF, $FCC2D3FC 
    Data.l $D6FCC5D6, $C5D6FCC5, $85C3D5FD, $D4FC4D61, $BAD4FCBE, $FBB2CFFB 
    Data.l $CFFBB2CF, $B1CBFAB2, $FFB3C8F5, $FFFFFFFF, $B4C8F6FF, $FCC5D5FC 
    Data.l $D5FCC5D5, $C5D5FCC5, $854D6185, $61854D61, $BAD4FC4D, $FBB2CFFB 
    Data.l $CEFBB2CF, $B5CDFAB6, $FFB5C9F3, $FFFFFFFF, $B8CBF6FF, $FDC9D8FC 
    Data.l $D8FDCAD8, $CAD8FDCA, $85C5D5FC, $61854D61, $4D61854D, $FBBDD3FB 
    Data.l $CDFCB6CE, $B9CDFBB7, $FFBACBF4, $FFFFFFFF, $B8CBF6FF, $FDC9D8FC 
    Data.l $D8FDCAD8, $CAD8FDCA, $FBC1D3FB, $6185C1D3, $4D61854D, $FB4D6185 
    Data.l $CDFCB6CE, $B9CDFBB7, $FFBACBF4, $FFFFFFFF, $BDCEF7FF, $FCCDDBFC 
    Data.l $D8FCCDDA, $C9D8FCC9, $FBC1D3FB, $D3FBC1D3, $4D6185C1, $854D6185 
    Data.l $CDFB4D61, $B9CDFBB9, $FFBCCCF3, $FFFFFFFF, $BED0F8FF, $FDD0DDFC 
    Data.l $D9FDCEDD, $C8D6FBCA, $FDC9D8FC, $6185BBCE, $4D61854D, $FC4D6185 
    Data.l $CDFCB7CD, $BACDFCBA, $FFBCCCF3, $FFFFFFFF, $BED0F8FF, $FDD0DDFC 
    Data.l $D9FDCEDD, $C8D6FBCA, $85C8D6FB, $61854D61, $4D61854D, $FBBACDFC 
    Data.l $CDFCB9CD, $BACDFCBA, $FFBCCCF3, $FFFFFFFF, $C4D4F7FF, $FDD4E1FC 
    Data.l $DBFCD1E0, $C9D8FCCD, $854D6185, $61854D61, $BED0FC4D, $FDBBCEFD 
    Data.l $CEFDBBCE, $BCCEFABB, $FFBCCCF3, $FFFFFFFF, $CAD8F9FF, $FCDAE6FE 
    Data.l $DEFDD8E3, $CEDBFDD1, $85C9D8FC, $D6FB4D61, $C5D5FCC8, $FCC5D3FC 
    Data.l $D0FCC2D3, $BCCDFABE, $FFBACCF4, $FFFFFFFF, $D0DFFCFF, $FEE1EAFE 
    Data.l $E1FCDAE6, $D1E0FDD4, $FDD0DDFC, $DBFCCEDB, $CAD9FDCD, $FCC8D8FB 
    Data.l $D3FCC5D6, $BCCEFAC2, $FFB9C9F3, $FFFFFFFF, $E6EEFCFF, $F9D0DFFC 
    Data.l $D2F7CAD8, $C0D0F7C4, $F5BDCEF7, $CDF5BBCD, $B8CBF6BB, $F7B7CAF5 
    Data.l $C7F5B5C8, $AFC5F4B3, $FFDCE6F9, $0000FFFF, $FFFFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $00FFFFFF, $01800000, $0000FFFF, $0000FFFF 
    Data.l $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF 
    Data.l $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF, $0000FFFF 
    Data.b - 1, -1, -128, 1, -1, -1 
  
  CroixBleueIco : 
    Data.l $00010000, $10100001, $00010000, $03680018, $00160000, $00280000 
    Data.l $00100000, $00200000, $00010000, $00000018, $FF400000, $0000FFFF 
    Data.l $00000000, $00000000, $00000000, $00000000, $CECECE00, $B6B6B6B6 
    Data.l $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6, $B6B6B6B6 
    Data.l $B6B6B6B6, $B6B6B6B6, $00CECECE, $00000000, $FFDFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFDFFFFF, $CEB6B6B6, $DFFFCECE, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $FF5725FF, $25FF5725, $5725FF57, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFDFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $FF5725FF, $25FF5725, $5725FF57, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFFFFFF, $5725FFFF, $FF5725FF, $25FF5725, $5725FF57, $FFFFFFFF 
    Data.l $25FFFFFF, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FF5725FF, $25FF5725, $FFFFFF57, $FFFFFFFF 
    Data.l $25FFFFFF, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFF5725, $FFFFFFFF, $FFFFFFFF, $FFFF5725, $FFFFFFFF, $FFFFFFFF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $FFFFFF57, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $FFFFFFFF, $FFFFFFFF, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $FFFFFF57, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFF5725, $FFFFFFFF, $FFFFFFFF, $FFFF5725, $FFFFFFFF, $FFFFFFFF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FF5725FF, $25FF5725, $FFFFFF57, $FFFFFFFF 
    Data.l $25FFFFFF, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $FFFFFFFF, $5725FFFF, $FF5725FF, $25FF5725, $5725FF57, $FFFFFFFF 
    Data.l $25FFFFFF, $5725FF57, $B6FFFFFF, $FFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $FF5725FF, $25FF5725, $5725FF57, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $B6FFFFFF, $DFFFB6B6, $5725FFFF, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $FF5725FF, $25FF5725, $5725FF57, $FF5725FF 
    Data.l $25FF5725, $5725FF57, $CEFFDFFF, $0000CECE, $FFDFFF00, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFDFFFFF, $00000000, $01800000, $0080FF00, $0000FF00 
    Data.l $0000FF00, $0000FF00, $0000FF00, $0000FF00, $0000FF00, $0000FF00 
    Data.l $0000FF00, $0000FF00, $0000FF00, $0000FF00, $0000FF00, $0000FF00 
    Data.b 0, -1, -128, 3, 0, -1 
  
  PB_Ico : 
    Data.l $00010000, $20200002, $00000010, $02E80000, $00260000, $10100000 
    Data.l $00000010, $01280000, $030E0000, $00280000, $00200000, $00400000 
    Data.l $00010000, $00000004, $02800000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $80000080, $80000000, $00800080 
    Data.l $00800000, $80800080, $80800000, $C0C00080, $000000C0, $FF0000FF 
    Data.l $FF000000, $00FF00FF, $00FF0000, $FFFF00FF, $FFFF0000, $000000FF 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $11111111, $11111111 
    Data.l $00000000, $00000000, $11111101, $11111111, $00000010, $00000000 
    Data.l $99999900, $99999999, $00000099, $00000000, $99990900, $99999999 
    Data.l $00009099, $00000000, $00900000, $00000000, $00000000, $00000000 
    Data.l $00090000, $00000000, $00000000, $00000000, $90000000, $00000000 
    Data.l $00000000, $00000000, $09000000, $00000000, $00000000, $00000000 
    Data.l $11110000, $00111191, $00000000, $00000000, $11010000, $10111119 
    Data.l $00000000, $00000000, $99000000, $99999999, $00000090, $00000000 
    Data.l $00000000, $00000900, $00000000, $00000000, $00000000, $00900000 
    Data.l $00000000, $00000000, $00000000, $00090000, $00000000, $00000000 
    Data.l $00000000, $90000000, $00000000, $00000000, $00000000, $19111111 
    Data.l $00000010, $00000000, $00000000, $11111101, $00000091, $00000000 
    Data.l $00000000, $99999900, $00000099, $00000000, $00000000, $99990900 
    Data.l $00009099, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $FFFF0000, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $00F0FFFF, $00F8FF0F, $00FCFF07, $00FEFF03 
    Data.l $7FFFFF01, $BFFFFFFF, $DFFFFFFF, $EFFFFFFF, $00FFFFFF, $80FFFF3F 
    Data.l $C0FFFF1F, $FEFFFF07, $FFFFFFFF, $FFFFFF7F, $FFFFFFBF, $F0FFFFDF 
    Data.l $F8FFFF07, $FCFFFF03, $FEFFFF03, $FFFFFF01, $FFFFFFFF, $FFFFFFFF 
    Data.l $FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $0028FFFF, $00100000, $00200000 
    Data.l $00010000, $00000004, $00C00000, $00000000, $00000000, $00000000 
    Data.l $00000000, $00000000, $00000000, $80000080, $80000000, $00800080 
    Data.l $00800000, $80800080, $80800000, $C0C00080, $000000C0, $FF0000FF 
    Data.l $FF000000, $00FF00FF, $00FF0000, $FFFF00FF, $FFFF0000, $000000FF 
    Data.l $00000000, $00000000, $00000000, $00000000, $00000000, $11000000 
    Data.l $10111111, $09000000, $99999999, $00000000, $00000090, $00000000 
    Data.l $00000009, $00000000, $00119111, $00000000, $90999909, $00000000 
    Data.l $00900000, $00000000, $00090000, $00000000, $90111100, $00000000 
    Data.l $99990900, $00000000, $00000000, $00000000, $00000000, $00000000 
    Data.l $00000000, $FFFF0000, $FFFF0000, $FFFF0000, $1FC00000, $0FE00000 
    Data.l $FFF70000, $FFFB0000, $3FF00000, $1FF80000, $7FFF0000, $BFFF0000 
    Data.b 0, 0, -4, 31, 0, 0, -2, 15, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0, -1, -1, 0, 0 
  
  
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
