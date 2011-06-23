; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=944&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm)
; Date: 08. May 2003
; OS: Windows
; Demo: No

;############################# 
;Windows-Animationen anzeigen 
;Autor : Andreas 
;############################# 

Global AniLib.l,AniControl.l 
#Anilib = 1000 

Procedure InitAnimate(x,y,w,h,parent) 
    AniLib = OpenLibrary(#Anilib,"shell32.dll") 
    AniControl = CreateWindowEx_(0,"SysAnimate32","Ani",$54000006,x,y,w,h,parent,32000,AniLib,0) 
EndProcedure 

Procedure ExitAnimate() 
    DestroyWindow_(AniControl) 
    CloseLibrary(#Anilib) 
EndProcedure 

Procedure ShowAnimate(s.s) 
    SendMessage_(AniControl,$464,0,s) 
EndProcedure 

If OpenWindow(0, 10, 10, 480, 120, "Animate-Control", #PB_Window_MinimizeGadget) 
    If CreateMenu(0, WindowID(0)) 
        MenuTitle("Animates") 
        MenuItem( 1, "FINDFOLDER") 
        MenuItem( 2, "FINDFILE") 
        MenuItem( 3, "FINDCOMPUTER") 
        MenuItem( 4, "COPYFILES") 
        MenuItem( 5, "COPYFILE") 
        MenuItem( 6, "RECYCLEFILE") 
        MenuItem( 7, "DELETEFILE") 
        MenuBar() 
        MenuItem( 8, "Ende") 
    EndIf 
EndIf 

InitAnimate(10,10,300,100,WindowID(0)) 
Repeat 
    Select WaitWindowEvent() 
    Case #PB_Event_Menu 
        Select EventMenu() 
        Case 1 
            ShowAnimate("#150") 
        Case 2 
            ShowAnimate("#151") 
        Case 3 
            ShowAnimate("#152") 
        Case 4 
            ShowAnimate("#160") 
        Case 5 
            ShowAnimate("#161") 
        Case 6 
            ShowAnimate("#162") 
        Case 7 
            ShowAnimate("#163") 
        Case 8 
            PostMessage_(WindowID(0),#WM_CLOSE,0,0) 
        EndSelect 
        
    Case #WM_CLOSE 
        ExitAnimate() 
        Quit = 1 
    EndSelect 
    
Until Quit = 1 
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
