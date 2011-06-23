; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11700
; Author: edel
; Date: 21. January 2007
; OS: Windows
; Demo: No

; When filling a ListIcon gadget this code checks for double entries
; Prüft beim Befüllen eines ListIcon Gadgets auf doppelte Einträge.

Structure LVFINDINFO
  flags.l
  psz.s
  lParam.l
  pt.point
  vkDirection.l
EndStructure

Procedure AddGadgetItemEX(id,text.s)

  Protected LFI.LVFINDINFO

  LFI\flags   = #LVFI_PARTIAL | #LVFI_STRING
  LFI\psz     = text

  If SendMessage_(GadgetID(id),#LVM_FINDITEM,-1,LFI) = -1
    ProcedureReturn AddGadgetItem(id,-1,text)
  Else
    MessageRequester("","schon vorhanden")
  EndIf

EndProcedure

hwnd = OpenWindow(0,0,0,300,300,"test")

CreateGadgetList(hwnd)
ListIconGadget(0,0,0,200,300,"blub",50)
ButtonGadget(1,210,5,80,23,"add")
StringGadget(2,210,40,80,23,"",#PB_String_Numeric)

For i = 0 To 100
  AddGadgetItem(0,-1,Str(i))
Next

Repeat
  event = WaitWindowEvent()
  If event = #PB_Event_Gadget
    gadget = EventGadget()
    If gadget = 1
      text.s = GetGadgetText(2)
      If text
        AddGadgetItemEX(0,text)
      EndIf
    EndIf
  EndIf
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP