; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=891&postdays=0&postorder=asc&start=10
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 07. May 2003
; OS: Windows
; Demo: Yes


;-Konstanten setzen 
#Window = 0 
#Gadget = 0 

Lib.l = OpenLibrary(0,"COMCTL32.DLL") 
;erstellt eine Imageliste mit kleinen Standard-Icons 
Imagelist.l =  CallFunction(0,"ImageList_LoadImage",Lib,"#120",16,0,#CLR_NONE,#IMAGE_BITMAP,#LR_LOADTRANSPARENT) 

;-Fenster darstellen 

If OpenWindow(#Window, 200, 200, 200, 210, "", #PB_Window_MinimizeGadget) 
  If CreateGadgetList(WindowID(#Window)) 
    ListIconGadget(#Gadget, 5, 25, 190, 190, "Einträge", 80) 
    AddGadgetItem(#Gadget, -1, "Neu" ,CallFunction(0,"ImageList_GetIcon",Imagelist,#PB_ToolBarIcon_New ,0)) 
    AddGadgetItem(#Gadget, -1, "Open" ,CallFunction(0,"ImageList_GetIcon",Imagelist,#PB_ToolBarIcon_Open ,0)) 
    AddGadgetItem(#Gadget, -1, "Save" ,CallFunction(0,"ImageList_GetIcon",Imagelist,#PB_ToolBarIcon_Save ,0)) 
  EndIf 
EndIf 

Repeat 
  EventID.l = WaitWindowEvent() 
Until EventID = #PB_Event_CloseWindow 
CallFunction(0,"ImageList_Destroy",Lib) 
CloseLibrary(0) 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
