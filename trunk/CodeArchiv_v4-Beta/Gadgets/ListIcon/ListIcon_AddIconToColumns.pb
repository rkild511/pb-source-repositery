; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7059&postdays=0&postorder=asc&start=15
; Author: Denis (updated for PB 4.00 by Andre)
; Date: 30. July 2003
; OS: Windows
; Demo: No


; ListIconGadget : adding icons to other columns than 1st


;constantes des Gadgets 

#MainWindow      = 0 
#ListIconGadget1 = 1 
#ButtonGadget    = 2 
#ButtonGadget2   = 3 
#ButtonGadget3   = 4 
#Font            = 5 
#FontHeader      = 6 

#LVM_SETEXTENDEDLISTVIEWSTYLE = 4150 
#LVS_EX_SUBITEMIMAGES         = 2 
;;======================================================================================== 
;;======================================================================================== 


If OpenWindow(#MainWindow,0,0,450,300, " Icon - Icon - Icon", #PB_Window_ScreenCentered |#PB_Window_SystemMenu) 

   ;Attention.l = LoadImage(300, "c:\Program files\Icônes\Attention.ico") 
   Attention.l = CreateImage(300, 16,16)
   StartDrawing(ImageOutput(300))
     Box(4,4,8,8,RGB(255,30,30))
   StopDrawing()


    
   If CreateGadgetList(WindowID(#MainWindow)) And ListIconGadget(#ListIconGadget1,1,50,320,450,"Colonne 1", 298/3 ,#PB_ListIcon_MultiSelect|#PB_ListIcon_FullRowSelect) 
      AddGadgetColumn(#ListIconGadget1, 1, "Colonne 2",298/3) 
      AddGadgetColumn(#ListIconGadget1, 2, "Colonne 3",298/3) 
   EndIf 
   FontID = LoadFont(#Font, "ARIAL", 9) 
   SetGadgetFont(#ListIconGadget1, FontID) 

; set extended style to the listicongadget to set image for subitems 

   SendMessage_(GadgetID(#ListIconGadget1), #LVM_SETEXTENDEDLISTVIEWSTYLE , #LVS_EX_SUBITEMIMAGES, #LVS_EX_SUBITEMIMAGES) 

   For i.b = 0 To 5 
       AddGadgetItem(#ListIconGadget1, -1, "111"+Chr(10)+ "222"+Chr(10)+"333"+Chr(10)+ "444",Attention) 
   Next i 

; fill up var to set subitem icon and text 
   var.lv_item 
    
   Var\mask     = #LVIF_IMAGE | #LVIF_TEXT 
   Var\iItem    = 5  ; row number for change 
   Var\iSubItem = 2  ; 2nd subitem 
   Var\pszText  = @"Try"  ; text to change to 
   Var\iImage   = 1; index of icon in the list 

; set text + icon in the listicongadget 
   SendMessage_(GadgetID(#ListIconGadget1), #LVM_SETITEM, 0, @Var) 

EndIf 

  Repeat 
     Select WaitWindowEvent() 
  
         Case #PB_Event_CloseWindow 
         Quit = 1 

     EndSelect 

  Until Quit 

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -