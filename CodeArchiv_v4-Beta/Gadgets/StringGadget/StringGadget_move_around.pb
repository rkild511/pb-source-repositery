; English forum:
; Author: Paul (updated for PB4.00 by blbltheworm)
; Date: 12. April 2003
; OS: Windows
; Demo: No

#Window_Main=0
#Up   =100
#Down =101
#Left =102
#Right=103
  
 
maxgrid=8
Global Dim pos(maxgrid,maxgrid)
 
If OpenWindow(#Window_Main,165,0,770,260,"Example2",#PB_Window_SystemMenu|#PB_Window_ScreenCentered)
  If CreateGadgetList(WindowID(#Window_Main))
   
    id=0
    xpos=10
    For x=1 To maxgrid
      ypos=15
      For y=1 To maxgrid
        id+1
        StringGadget(id,xpos,ypos,80,20,"")
        pos(x,y)=GadgetID(id)
        ypos+30
      Next
      xpos+95
    Next
 
    AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Up,#Up)
    AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Down,#Down)
    AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Left,#Left)
    AddKeyboardShortcut(#Window_Main,#PB_Shortcut_Right,#Right)
  EndIf
EndIf
 
 
SetActiveGadget(1)
 
Repeat
  EventID=WaitWindowEvent()
     
  If EventID=#PB_Event_Menu
    For x=1 To maxgrid
      For y=1 To maxgrid
        If GetFocus_()=pos(x,y)
          xpos=x
          ypos=y
        EndIf
      Next
    Next  
 
    Select EventMenu()
      Case #Up
        ypos-1
        If ypos<1:ypos=1:EndIf
      Case #Down
        ypos+1
        If ypos>maxgrid:ypos=maxgrid:EndIf      
      Case #Left
        xpos-1
        If xpos<1:xpos=1:EndIf      
      Case #Right
        xpos+1
        If xpos>maxgrid:xpos=maxgrid:EndIf            
    EndSelect
    SetFocus_(pos(xpos,ypos))
  EndIf  
Until EventID=#PB_Event_CloseWindow
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP