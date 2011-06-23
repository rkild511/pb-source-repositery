; English forum:
; Author: Unknown
; Date: 21. January 2003
; OS: Windows
; Demo: No

#ID_MWindow =0    ; ID Mother Window
#ID_MPanel  =1    ; ID Mother Panel
#ID_Frame3d =2    ; ID Frame3d
dID_Rich    =500  ; dynamic ID RichGadget

hnd_MWindow=OpenWindow(#ID_MWindow,100,100,640,480,"Bla",#PB_Window_SystemMenu)

If CreateGadgetList(WindowID(#ID_MWindow))                                                            
  PanelGadget(#ID_MPanel,0,28,640,365)
                                                    
  AddGadgetItem(#ID_MPanel,-1,"Info")
  Frame3DGadget(#ID_Frame3d,0,0,640,300,"bla",0)
  OpenRichEdit(GadgetID(#ID_Frame3d),dID_Rich,0,0,635,290,"RichEdit No"+Str(dID_Rich)) : dID_Rich+1

  AddGadgetItem(#ID_MPanel,-1,"Info")
  Frame3DGadget(#ID_Frame3d,0,0,640,300,"bla",0)
  OpenRichEdit(GadgetID(#ID_Frame3d),dID_Rich,0,0,635,290,"RichEdit No"+Str(dID_Rich)) : dID_Rich+1

  AddGadgetItem(#ID_MPanel,-1,"Info")
  Frame3DGadget(#ID_Frame3d,0,0,640,300,"bla",0)
  OpenRichEdit(GadgetID(#ID_Frame3d),dID_Rich,0,0,635,290,"RichEdit No"+Str(dID_Rich)) : dID_Rich+1

  ClosePanelGadget()    ;  <- very important   (huhu Paul ;)
Else : End
EndIf

Repeat
  Event=WaitWindowEvent()
Until Event=#PB_Event_CloseWindow

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -