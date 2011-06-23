; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2938&postdays=0&postorder=asc&start=10
; Author: KuschelTeddy82 (updated for PB4.00 by blbltheworm)
; Date: 26. November 2003
; OS: Windows
; Demo: Yes

#Window_0       = 0 
#Text_0         = 1 
#Text_1         = 2 
#Text_2         = 3 
#Text_info      = 4 
#Button_fback   = 5 
#Button_back    = 6 
#Button_next    = 7 
#Button_fnext   = 8 

Structure datenfeld 
  name.s 
  vorname.s 
  nummer.s 
EndStructure 
Global NewList daten.datenfeld() 

Procedure AddNewDatas(name.s, vorname.s, nummer.s) 
  LastElement(daten()) 
  AddElement(daten()) 
  daten()\name    = name 
  daten()\vorname = vorname 
  daten()\nummer  = nummer 
EndProcedure 

Procedure DisplayData(pos) 
  SelectElement(daten(), pos) 
  SetGadgetText(#Text_0, "Name: "+daten()\name) 
  SetGadgetText(#Text_1, "Vorname: "+daten()\vorname) 
  SetGadgetText(#Text_2, "Nummer: "+daten()\nummer) 
  SetGadgetText(#Text_info, Str(pos)) 
EndProcedure 

;--------------------------------------- 
AddNewDatas("Schmidt", "Anja", "030-123456789") 
AddNewDatas("Arbeit", "1. OG", "030987654321") 
AddNewDatas("Der", "Chef", "0000000") 
AddNewDatas("Mittermeier", "Michael", "0190-123456") 
;--------------------------------------- 

index = CountList(daten()) 
If index=0 
  MessageRequester("Fehler", "Keine Daten vorhanden!", #PB_MessageRequester_Ok) 
  End 
EndIf 
offset = 0 

OpenWindow(#Window_0, 279, 160, 220, 90, "Test", #PB_Window_SystemMenu) 
CreateGadgetList(WindowID(#Window_0)) 
TextGadget(#Text_0, 10, 35, 200, 15, "") 
TextGadget(#Text_1, 10, 50, 200, 15, "") 
TextGadget(#Text_2, 10, 65, 200, 15, "") 
ButtonGadget(#Button_fback, 10, 10, 30, 20, "<<") 
ButtonGadget(#Button_back, 40, 10, 30, 20, "<") 
ButtonGadget(#Button_next, 70, 10, 30, 20, ">") 
ButtonGadget(#Button_fnext, 100, 10, 30, 20, ">>") 
TextGadget(#Text_info, 140, 13, 30, 20, "") 

DisplayData(offset) 

Repeat 
  EventID = WindowEvent() 
  If EventID = #PB_Event_Gadget 
    GEID = EventGadget() 
    oldOffset = offset 
    If GEID = #Button_fback 
      offset-5 
      If offset<0 : offset=0 : EndIf 
    EndIf 
    If GEID = #Button_back 
      offset-1 
      If offset<0 : offset=0 : EndIf 
    EndIf 
    If GEID = #Button_next 
      offset+1 
      If offset>=index : offset=index-1 : EndIf 
    EndIf 
    If GEID = #Button_fnext 
      offset+5 
      If offset>=index : offset=index-1 : EndIf 
    EndIf 
    
    If offset<>oldOffset 
      DisplayData(offset) 
    EndIf 
  EndIf 
Until EventID = #PB_Event_CloseWindow 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
