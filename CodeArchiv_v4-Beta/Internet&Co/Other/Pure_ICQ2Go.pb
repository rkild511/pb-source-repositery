; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2193&highlight=
; Author: Tietze
; Date: 03. September 2003
; OS: Windows
; Demo: Yes

If OpenWindow(0,100,100,158,446,"Pure ICQ2go!",#PB_Window_SystemMenu) 

  If CreateGadgetList(WindowID(0)) 
     WebGadget(0,0,0,158,446,"http://go.icq.com//icqgo/web/0,,,00.html") 
  EndIf 

  Repeat 

   EventID = WindowEvent() 

   If EventID = #PB_Event_CloseWindow 
     quit = 1 
   EndIf 

  Until quit=1 

EndIf 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
