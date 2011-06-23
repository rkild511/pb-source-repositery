; German forum: http://www.purebasic.fr/german/viewtopic.php?t=1562&highlight=
; Author: Franky (updated for PB 4.00 by Andre)
; Date: 08. January 2005
; OS: Windows
; Demo: No

; Hier wird der Cursor einmal geändert und zum ende des Programms wieder zurückgeändert.

; Vorsicht: mit SetClassLong_( setze ich den Wert für alle Gadgets dieser Klasse,
; vielleicht auch bei anderen Anwendungen (hatte ich noch nicht, könnte aber sein
; (oder? ). Wenn ihr dieses Verfahren nutzt, müsst ihr die abfrage sehr genau machen


handle=LoadCursor_(0,#IDC_CROSS   )
CreateImage(1,80,80)
StartDrawing(ImageOutput(1))
FrontColor(RGB(255,0,0))
Circle(40,40,40)
StopDrawing()
If OpenWindow(1,100,200,210,210,"Cursor ändern",#PB_Window_SystemMenu)
  CreateGadgetList(WindowID(1))
  ImageGadget(1,10,10,80,80,ImageID(1))
  ImageGadget(2,120,10,80,80,ImageID(1))
  ImageGadget(3,120,120,80,80,ImageID(1))
  ImageGadget(4,10,120,80,80,ImageID(1))
  normhandle=GetWindowLong_(GadgetID(1),#GCL_HCURSOR)
  SetClassLong_(GadgetID(1),#GCL_HCURSOR,handle)
  Repeat
    event=WaitWindowEvent()
  Until event=#WM_CLOSE
  SetClassLong_(GadgetID(1),#GCL_HCURSOR,normhandle)
  CloseWindow(1)
EndIf
End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -