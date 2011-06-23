; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1510&highlight=
; Author: Rings
; Date: 26. June 2003
; OS: Windows
; Demo: No

; Fast loading of a large text file into EditorGadget()
; Needs Rings FastFile library
#EditorGadget=1 
#ButtonGadget=2 
If OpenWindow(0, 342, 196, 422, 234, "New window ( 0 )",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
If CreateGadgetList(WindowID(0)) 
  EditorGadget(#EditorGadget, 10, 10, 400, 170) 
  ButtonGadget(#ButtonGadget, 10, 190, 110, 30, "Go and load txt file") 
EndIf 
Repeat 
Event = WaitWindowEvent() 
If Event = #PB_Event_Gadget 
  GadgetID = EventGadget() 
  If GadgetID = #ButtonGadget 
   FileName.s=OpenFileRequester("choose txt file","","*.txt|*.TXT",0) 
   If FileName<>"" 
    ADR=FastOpenFile(FileName.s) 
    If ADR 
      SendMessage_(GadgetID(#EditorGadget), #EM_LIMITTEXT, -1, 0) ;Extentd the editogadget 
      SendMessage_(GadgetID(#EditorGadget), #WM_SETTEXT, 0, ADR) ;Place the Content 
      FastCloseFile() 
    EndIf 
   EndIf 
  EndIf 
EndIf 
Until Event = #PB_Event_CloseWindow 
EndIf 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
