; www.PureArea.net, sent by mail to me
; Author: Stefan 'wayne-c' Christen (updated for PB 4.00 by Andre)
; Date: 28. June 2004
; OS: Windows
; Demo: No


; Purpose: How to use item groups in the ListIcon gadget
; Tested: on Windows XP only (don't think it runs elsewhere)

Structure LVGROUP
  cbSize.l
  mask.l
  pszHeader.l
  cchHeader.l
  pszFooter.l
  cchFooter.l
  iGroupId.l
  stateMask.l
  state.l
  uAlign.l
EndStructure

; Structure LVITEM
;   mask.l
;   iItem.l
;   iSubItem.l
;   state.l
;   stateMask.l
;   pszText.l
;   cchTextMax.l
;   iImage.l
;   lParam.l
;   iIndent.l
;   iGroupId.l
;   cColumns.l
;   puColunns.l
; EndStructure
; 

#LVM_ENABLEGROUPVIEW = #LVM_FIRST + 157
#LVM_MOVEITEMTOGROUP = #LVM_FIRST + 154
#LVM_INSERTGROUP = #LVM_FIRST + 145

#LVIF_GROUPID = $0100

#LVGA_HEADER_LEFT = $1
#LVGA_HEADER_CENTER = $2
#LVGA_HEADER_RIGHT = $4

#LVGS_NORMAL = $0
#LVGS_COLLAPSED = $1
#LVGS_HIDDEN = $2

#LVGF_HEADER = $1
#LVGF_FOOTER = $2
#LVGF_STATE = $4
#LVGF_ALIGN = $8
#LVGF_GROUPID = $10


Procedure StringToUnicode(pbstrptr.l, ucstrptr.l)
  MultiByteToWideChar_ (#CP_ACP, 0, pbstrptr, Len(PeekS(pbstrptr)), ucstrptr, Len(PeekS(ucstrptr)))
  PokeL( ucstrptr + Len(PeekS(pbstrptr))*2, 0)
EndProcedure 


Procedure ListIcon_AddGroup(gadget.l, text.s, groupid.l)
  lvg.LVGROUP\cbSize = SizeOf(LVGROUP)
  lvg\mask = #LVGF_GROUPID | #LVGF_ALIGN | #LVGF_HEADER
  lvg\iGroupId = groupid
  lvg\uAlign = #LVGA_HEADER_LEFT
  text_uc.s = Space(260)  
  StringToUnicode(@text, @text_uc) 
  lvg\pszHeader = @text_uc
  SendMessage_ (GadgetID(gadget), #LVM_INSERTGROUP, -1, @lvg)
EndProcedure


Procedure ListIcon_EnableGroupView(gadget.l, state.l)
  SendMessage_ (GadgetID(gadget), #LVM_ENABLEGROUPVIEW, state, 0)
EndProcedure


Procedure ListIcon_AddItem(gadget.l, text.s, groupid.l)
  itm.LVITEM\mask = #LVIF_TEXT | #LVIF_GROUPID
  itm\pszText = @text
  itm\iGroupId = groupid
  SendMessage_ (GadgetID(gadget), #LVM_INSERTITEM, 0, @itm)
EndProcedure


;- Test


;XIncludeFile "ListIcon_Groups_XP.pb"


Enumeration
  #Window
  #ListIcon
EndEnumeration


If OpenWindow(#Window, 0, 0, 300, 400, "ListIcon_Groups_XP", #PB_Window_SystemMenu|#PB_Window_SizeGadget|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Window))
    ListIconGadget(#ListIcon, 5, 5, 290, 390, "Game", 200)
  EndIf
  
  ListIcon_EnableGroupView(#ListIcon, 1)
  For g=1 To 5
    ListIcon_AddGroup(#ListIcon, "This is group "+Str(g), g)
    For i=1 To 5
      ListIcon_AddItem(#ListIcon, "Item "+Str((g-1)*5+i)+" belongs to group "+Str(g), g)
    Next
  Next
  
  Quit.l = 0
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_CloseWindow
        Quit = 1
      Case #PB_Event_SizeWindow
        ResizeGadget(#ListIcon, 5, 5, WindowWidth(#Window)-10, WindowHeight(#Window)-10)
    EndSelect
  Until Quit > 0
EndIf
End


; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; Executable = ..\Dokumente und Einstellungen\Wayne\Desktop\ListIcon_Groups_XP.exe