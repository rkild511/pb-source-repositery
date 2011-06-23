; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5208&highlight=
; Author: El_Choni (updated for PB4.00 by blbltheworm)
; Date: 25. February 2003
; OS: Windows
; Demo: No

#LVBKIF_SOURCE_NONE = 0
#LVBKIF_SOURCE_HBITMAP = 1
#LVBKIF_SOURCE_URL = 2
#LVBKIF_SOURCE_MASK = 3
#LVBKIF_STYLE_NORMAL = 0
#LVBKIF_STYLE_TILE = $10
#LVBKIF_STYLE_MASK = $10
#LVM_SETBKIMAGE = #LVM_FIRST + 68
#LVM_SETBKIMAGEW = #LVM_FIRST + 138
#LVM_GETBKIMAGE = #LVM_FIRST + 69
#LVM_GETBKIMAGEW = #LVM_FIRST + 139

Structure LVBKIMAGE
  ulFlags.l
  hbm.l
  pszImage.l
  cchImageMax.l
  xOffsetPercent.l
  yOffsetPercent.l
EndStructure

OleInitialize_(0)
If OpenWindow(0, 384, 288, 640, 480, "ListIconGadget background image example", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
  LVWidth = WindowWidth(0)
  LVCWidth = Int(LVWidth/4)-1
  If CreateGadgetList(WindowID(0))
    ListIconGadget = ListIconGadget(0, 0, 0, LVWidth, WindowHeight(0), "Column 0", LVCWidth, #PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect)
    AddGadgetColumn(0, 1, "Column 1", LVCWidth)
    AddGadgetColumn(0, 2, "Column 2", LVCWidth)
    AddGadgetColumn(0, 3, "Column 3", LVCWidth)
    AddGadgetItem(0, 0, "Aaa 1"+Chr(10)+"Bcc 3"+Chr(10)+"Cdd 2"+Chr(10)+"Eee 3"+Chr(10), 0)
    AddGadgetItem(0, 1, "Aab 2"+Chr(10)+"Bbc 2"+Chr(10)+"Ddd 3"+Chr(10)+"Dde 1"+Chr(10), 0)
    AddGadgetItem(0, 2, "Abb 3"+Chr(10)+"Baa 1"+Chr(10)+"Ccd 1"+Chr(10)+"Dee 2"+Chr(10), 0)
    SendMessage_(ListIconGadget, #LVM_SETTEXTCOLOR, 0, $FF0000)
    SendMessage_(ListIconGadget, #LVM_SETBKCOLOR, 0, #CLR_NONE)
    SendMessage_(ListIconGadget, #LVM_SETTEXTBKCOLOR, 0, #CLR_NONE)
    Buffer = AllocateMemory(512)
    GetModuleFileName_(GetModuleHandle_(0), Buffer, 512)
    InitialDir$ = GetPathPart(PeekS(Buffer))
    FreeMemory(Buffer)
    File$ = OpenFileRequester("Select image", InitialDir$, "ListIcon supported images|*.bmp;*.ico;*.gif;*.jpg;*.wmf;*.emf", 0)
    If File$
      lbk.LVBKIMAGE
      lbk\ulFlags = #LVBKIF_STYLE_NORMAL|#LVBKIF_SOURCE_URL;|#LVBKIF_STYLE_TILE
      lbk\pszImage = @File$
;      lbk\xOffsetPercent;
;      lbk\yOffsetPercent;
      SendMessage_(ListIconGadget, #LVM_SETBKIMAGE, 0, lbk)
    EndIf
    Repeat
      EventID = WaitWindowEvent()
    Until EventID = #PB_Event_CloseWindow
  EndIf
EndIf
OleUninitialize_()
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
