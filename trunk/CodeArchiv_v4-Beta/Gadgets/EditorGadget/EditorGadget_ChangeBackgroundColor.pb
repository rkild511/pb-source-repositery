; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2197&highlight=
; Author: Danilo (updated for PB4.00 by blbltheworm)
; Date: 04. September 2003
; OS: Windows
; Demo: No

#Editfeld_Notiz = 1 
#Button1 = 2 
#Button2 = 3 
Global AlteFarbe 

OpenWindow(0,0,0,300,300,"Test",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
      EditorGadget(#Editfeld_Notiz,  1,  1,298,250) 
      ButtonGadget(#Button1       , 20,270,100, 20,"-=> NEU <=-" ) 
      ButtonGadget(#Button2       ,180,270,100, 20,"-=> ALT <=-" ) 
  EndIf 

Repeat 
  Select WaitWindowEvent() 
    ;- GADGET ABFRAGEN 
    Case #PB_Event_Gadget 
      Select EventGadget() 
        Case #Button1 
          AlteFarbe = SendMessage_(GadgetID(#Editfeld_Notiz),#EM_SETBKGNDCOLOR,#Null,RGB(0,0,0)) 
          MessageRequester("Info","$"+RSet(Hex(AlteFarbe),6,"0"),0);#PB_MessageRequester_Ok) 
        Case #Button2 
          AlteFarbe = SendMessage_(GadgetID(#Editfeld_Notiz),#EM_SETBKGNDCOLOR,#Null,AlteFarbe) 
          MessageRequester("Info","$"+RSet(Hex(AlteFarbe),6,"0"),0) 
      EndSelect 
    Case #PB_Event_CloseWindow 
      End 
  EndSelect 
ForEver 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
