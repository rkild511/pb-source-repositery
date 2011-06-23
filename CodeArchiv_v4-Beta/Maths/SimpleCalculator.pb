; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3353&highlight=
; Author: Lars (updated for PB4.00 by blbltheworm)
; Date: 06. January 2004
; OS: Windows
; Demo: Yes

Enumeration 
  #Window_0 
EndEnumeration 

Enumeration 
  #String_1 
  #String_2 
  #String_3 
  #String_4 
  #String_5 
  #String_6 
  #Text_1 
  #Text_2 
  #String_7 
EndEnumeration 

Procedure Open_Window_0() 
  If OpenWindow(#Window_0, 394, 282, 238, 157, "Beispiel",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
    If CreateGadgetList(WindowID(#Window_0)) 
      StringGadget(#String_1, 20, 55, 150, 25, "") 
      StringGadget(#String_2, 185, 55, 45, 25, "", #PB_String_Numeric | #PB_Text_Right) ;Hier wird etwas trickreich: 
      StringGadget(#String_3, 20, 85, 150, 25, "") 
      StringGadget(#String_4, 185, 85, 45, 25, "", #PB_String_Numeric | #PB_Text_Right) ;Man kann (zu mindestens unter Windows; unter Linux kann 
      StringGadget(#String_5, 20, 25, 150, 25, "") 
      StringGadget(#String_6, 185, 25, 45, 25, "", #PB_String_Numeric | #PB_Text_Right) ;ich das nicht beschwören) #PB_Text_Right auch für StringGadgets 
      TextGadget(#Text_1, 15, 115, 220, 20, "------------------------------------------------------------------------"); benutzen. 
      TextGadget(#Text_2, 25, 135, 145, 20, "Ergebnis:", #PB_Text_Right) 
      StringGadget(#String_7, 185, 130, 50, 25, "", #PB_String_Numeric | #PB_Text_Right) 
    EndIf 
  EndIf 
EndProcedure 

Open_Window_0() 

Repeat 
  Event = WaitWindowEvent() 
  If Event = #PB_Event_Gadget 
    If EventGadget() = #String_2 Or EventGadget() = #String_4 Or EventGadget() = #String_6 
      ErstesString.l = Val(GetGadgetText(#String_2)) ;- HIER 
      ZweitesString.l = Val(GetGadgetText(#String_4)); ist der ganze Zauber. . . 
      DrittesString.l = Val(GetGadgetText(#String_6)) 
      Ergebnis.l = ErstesString + ZweitesString + DrittesString 
      SetGadgetText(#String_7, Str(Ergebnis)) 
    EndIf 
  EndIf 
  
Until Event = #PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
