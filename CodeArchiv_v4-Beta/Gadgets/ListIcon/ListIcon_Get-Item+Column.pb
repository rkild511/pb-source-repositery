; http://www.purebasic-lounge.de
; Author: Hroudtwolf
; Date: 10. November 2006
; OS: Windows
; Demo: No


; ###############################################
; # GetItemUnderCursor                          #
; # GetColumnUnderCursor                        #
; ###############################################
; # 2006 By Hroudtwolf                          #
; # Last Update: 10.11.2006                     #
; # PB 4.01                                     #
; ###############################################


Declare GetItemUnderCursor   (Gadget.l)
Declare GetColumnUnderCursor (Gadget.l , NumberOfColumns.l)


; ###############################################
; # Hauptprogramm                               #
; ###############################################

*Window.Long = OpenWindow(#PB_Any , #PB_Ignore , #PB_Ignore , 500 , 400 , "ListIcon Mouse-Infos", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
If *Window = #False Or CreateGadgetList(*Window\l) = #False
   MessageBox_(0,"Ubekannter Fehler.","Fehler",#MB_OK|#MB_ICONERROR)
   End
EndIf   
 
CreateStatusBar (1, *Window\l)

Global *List.Long = ListIconGadget(#PB_Any, 0, 0, 500, 400 - StatusBarHeight (1), "Name", 100, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection|#PB_ListIcon_GridLines|#PB_ListIcon_HeaderDragDrop)


AddGadgetColumn (*List , 1 , "Strasse" , 100)
AddGadgetColumn (*List , 2 , "PLZ"     ,  60)
AddGadgetColumn (*List , 3 , "Ort"     , 140)
AddGadgetColumn (*List , 4 , "Telefon" , 95)

Restore Personal
For x = 0 To 3
   Read PersData.s
   AddGadgetItem     (*List , x  , StringField (PersData.s , 1 , ";"))
   SetGadgetItemText (*List , x  , StringField (PersData.s , 2 , ";") , 1)
   SetGadgetItemText (*List , x  , StringField (PersData.s , 3 , ";") , 2)
   SetGadgetItemText (*List , x  , StringField (PersData.s , 4 , ";") , 3)
   SetGadgetItemText (*List , x  , StringField (PersData.s , 5 , ";") , 4)
Next x




Repeat
Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
    End
    Case #WM_MOUSEMOVE
    StatusBarText (1,0,"Item:  "+Str(GetItemUnderCursor   (*List))+"   Column:"+Str(GetColumnUnderCursor (*List , 5)))
EndSelect

ForEver


Procedure GetItemUnderCursor (Gadget.l)
  Protected HitTestInfo.LV_HITTESTINFO
  Protected hwnd       .l              =GadgetID(Gadget.l)
  Protected re         .rect
  Protected pt         .POINT
  GetWindowRect_(hwnd.l,re)
  GetCursorPos_(pt.POINT)
  If PtInRect_(re,pt\x,pt\y)
    HitTestInfo\pt\x = pt\x - re\left
    HitTestInfo\pt\y = pt\y - re\top
    ClientToScreen_(GetActiveWindow_(), @HitTestInfo\pt)
    ScreenToClient_(hwnd .l, @HitTestInfo\pt)
    ProcedureReturn SendMessage_(hwnd .l, #LVM_HITTEST, 0, @HitTestInfo)
  EndIf
  ProcedureReturn #False
EndProcedure


Procedure GetColumnUnderCursor (Gadget.l , NumberOfColumns.l)
  Protected hwnd       .l              =GadgetID(Gadget.l)
  Protected re         .rect
  Protected pt         .POINT
  Protected width      .l
  Protected prevwidth  .l
  NumberOfColumns.l - 1
  GetWindowRect_(hwnd.l,re)
  GetCursorPos_(pt.POINT)
  If PtInRect_(re,pt\x,pt\y)
    While CurrentCol.l <= NumberOfColumns.l
    width.l + SendMessage_(hwnd .l , #LVM_GETCOLUMNWIDTH  , CurrentCol.l , 0)
    If pt\x - re\left > prevwidth.l And pt\x - re\left < width.l
       ProcedureReturn CurrentCol.l + 1
    EndIf
    prevwidth.l = width.l
    CurrentCol.l + 1
    Wend
  EndIf
  ProcedureReturn #False
EndProcedure

DataSection
   Personal:
   Data.s "Olaf Maier;Rheinstrasse 3;64283;Darmstadt;06151-303071;"
   Data.s "Herbert Schmiedt;Neue Strasse 44;64572;Gross-Gerau;06152-5478196;"
   Data.s "Franz Bauer;Europaring 12;64319;Pfungstadt;06157-33054;"
   Data.s "Heinz Huber;Zehntgasse 34;64285;Darmstadt;06151-22344;"
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -