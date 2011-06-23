; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6060&highlight=
; Author: Spangly (updated for PB4.00 by blbltheworm)
; Date: 04. May 2003
; OS: Windows
; Demo: No

; Proper Dialogs in Purebasic 
; Hacked together by Spangly 

Structure DLG_TEMPLATE 
    style.l 
    dwExtendedStyle.l 
    cdit.w 
    x.w 
    y.w 
    cx.w 
    cy.w 
    menu.w 
    class.w 
    title.l 
EndStructure 

dlg.DLG_TEMPLATE 
dlg\style=#WS_POPUP | #WS_BORDER | #WS_SYSMENU | #DS_MODALFRAME | #WS_CAPTION | #DS_CENTER 
dlg\cx=200 
dlg\cy=100 

Procedure DlgProc(hWnd, uMsg, wParam, lParam) 
    Select uMsg 
    Case #WM_INITDIALOG 
        CreateGadgetList(hWnd) 
        ButtonGadget(0,20,20,100,22,"OK") 
        ButtonGadget(1,20,50,100,22,"Cancel") 
        ButtonGadget(2,20,80,100,22,"Quit") 
        SetWindowText_(hWnd,"Dialog Title") 
    Case #WM_COMMAND 
        EndDialog_(hWnd,wParam&$FFFF) 
    EndSelect 
    ProcedureReturn 0 
EndProcedure 

OpenWindow(0, 325, 185, 600, 330, "Proper Dialogs", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar ) 
Debug DialogBoxIndirectParam_(0,dlg,WindowID(0),@DlgProc(),0) 

Repeat 
    event.l=WaitWindowEvent() 
    Select event 
        Case #PB_Event_Gadget 
            Debug EventGadget() 
    EndSelect 
Until event=#PB_Event_CloseWindow 

End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
