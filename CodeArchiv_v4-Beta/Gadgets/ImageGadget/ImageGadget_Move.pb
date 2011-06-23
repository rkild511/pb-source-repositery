; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2560&start=10
; Author: realgarfield (updated for PB4.00 by blbltheworm)
; Date: 21. November 2003
; OS: Windows
; Demo: No

; disable debugger when running
; zum ausführen den Debugger ausschalten (editiert von Falko)

#Image=1 
Procedure WindowProc(hWnd,Msg,wParam,lParam) 
  
  Shared WindowProc_ImageInMove 
  
  Select Msg 
    Case #WM_LBUTTONDOWN 
      WindowProc_ImageInMove = 1 
    Case #WM_LBUTTONUP 
      WindowProc_ImageInMove = 0 
    Case #WM_MOUSEMOVE 
      If ChildWindowFromPoint_(hWnd,lParam & $FFFF,(lParam>>16) & $FFFF) = GadgetID(#Image) And wParam&#MK_LBUTTON And WindowProc_ImageInMove 
        ResizeGadget(#Image,(lParam & $FFFF)-GadgetWidth(#Image)/2,((lParam>>16)&$FFFF)-GadgetHeight(#Image)/2,#PB_Ignore,#PB_Ignore) 
      Else 
        WindowProc_ImageInMove = 0 
      EndIf 
  EndSelect 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

quit = 0 
wndw = OpenWindow(0,200,100,400,400, "Menüs", #PB_Window_SystemMenu) 
   CreateGadgetList(WindowID(0)) 
   SetWindowCallback(@WindowProc()) 
  CreateMenu(0,wndw) 
    MenuTitle("Datei") 
      MenuItem(1,"Datei öffnen") 
  Repeat      
    Select WindowEvent() 
      Case  #PB_Event_Repaint 
        #Image 
      Case #PB_Event_Menu 
         Select EventMenu()  
          Case 1 ; Datei Oeffnen 
            y=30 
            file$ = OpenFileRequester("Open File","","Bitmaps|*.bmp",1) 
            ;path$ =GetPathPart(file$) 
            ;bild.s =GetFilePart(file$) 
            LoadImage(#Image,file$) 
            ImageGadget(#Image,x,y,0,0,ImageID(#Image)) 
            DisableGadget(#Image,1)     ; added by Andre for PB3.92+ compatibility
          EndSelect 
      Case #PB_Event_CloseWindow 
          quit = 1                
    EndSelect 
  Until quit = 1 
  End                    


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
