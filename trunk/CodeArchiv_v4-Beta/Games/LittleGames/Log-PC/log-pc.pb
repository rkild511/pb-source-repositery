; English forum: 
; Author: Unknown
; Date: 31. December 2002
; OS: Windows
; Demo: Yes

ver$="LOG-PC 1.0a"
Dim light(25)
Dim lastlight(25)
best=1000

LoadImage(0, "off.bmp")
LoadImage(1, "on.bmp")

If OpenWindow(0, 0, 0, 154, 193, ver$, #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)

  If CreateMenu(0, WindowID(0))
    MenuTitle("&File")
      OpenSubMenu("New Game")
        MenuItem( 1, "Random Grid [F2]")
        MenuItem( 2, "Custom Grid") : DisableMenuItem(0,2, 1)
        MenuItem(10, "Previous Grid")
        DisableMenuItem(0,10, 1)
      CloseSubMenu()
      OpenSubMenu("Difficulty")
        MenuItem( 7, "Easy (15 Clicks)") : SetMenuItemState(0, 7, 1)
        MenuItem( 8, "Medium (30 Clicks)")
        MenuItem( 9, "Hard (60 Clicks)")
      CloseSubMenu()
      OpenSubMenu("Click Limit")
        MenuItem(11, "10 Clicks") : DisableMenuItem(0,11, 1)
        MenuItem(12, "25 Clicks") : DisableMenuItem(0,12, 1)
        MenuItem(13, "50 Clicks") : DisableMenuItem(0,13, 1)
        MenuItem(14, "100 Clicks") : DisableMenuItem(0,14, 1)
        MenuItem(15, "Unlimited") : SetMenuItemState(0, 15, 1) : DisableMenuItem(0,15, 1)
      CloseSubMenu()
      MenuBar()
      MenuItem( 4, "E&xit")
    MenuTitle("&About")
      MenuItem( 5, "Today's Best")
      MenuBar()
      MenuItem( 3, "About "+ver$)
    
    AddKeyboardShortcut(0, #PB_Shortcut_F2, 1) ; V1.0a addition. Add F2 shortcut to New Game.
  EndIf ;CreateMenu

  If CreateStatusBar(0, WindowID(0))
    AddStatusBarField(500)
  EndIf

  StatusBarText(0, 0, "Welcome to "+ver$, 0)
  
  If CreateGadgetList(WindowID(0))
    x=2 : y=2
    ButtonImageGadget(1, x, y, 30, 30, ImageID(0))
    ButtonImageGadget(2, x+30, y, 30, 30, ImageID(0))
    ButtonImageGadget(3, x+60, y, 30, 30, ImageID(0))
    ButtonImageGadget(4, x+90, y, 30, 30, ImageID(0))
    ButtonImageGadget(5, x+120, y, 30, 30, ImageID(0))  
    
    ButtonImageGadget(6, x, y+30, 30, 30, ImageID(0))
    ButtonImageGadget(7, x+30, y+30, 30, 30, ImageID(0))
    ButtonImageGadget(8, x+60, y+30, 30, 30, ImageID(0))
    ButtonImageGadget(9, x+90, y+30, 30, 30, ImageID(0))
    ButtonImageGadget(10, x+120, y+30, 30, 30, ImageID(0))
    
    ButtonImageGadget(11, x, y+60, 30, 30, ImageID(0))
    ButtonImageGadget(12, x+30, y+60, 30, 30, ImageID(0))
    ButtonImageGadget(13, x+60, y+60, 30, 30, ImageID(0))
    ButtonImageGadget(14, x+90, y+60, 30, 30, ImageID(0))
    ButtonImageGadget(15, x+120, y+60, 30, 30, ImageID(0))
    
    ButtonImageGadget(16, x, y+90, 30, 30, ImageID(0))
    ButtonImageGadget(17, x+30, y+90, 30, 30, ImageID(0))
    ButtonImageGadget(18, x+60, y+90, 30, 30, ImageID(0))
    ButtonImageGadget(19, x+90, y+90, 30, 30, ImageID(0))
    ButtonImageGadget(20, x+120, y+90, 30, 30, ImageID(0))
    
    ButtonImageGadget(21, x, y+120, 30, 30, ImageID(0))
    ButtonImageGadget(22, x+30, y+120, 30, 30, ImageID(0))
    ButtonImageGadget(23, x+60, y+120, 30, 30, ImageID(0))
    ButtonImageGadget(24, x+90, y+120, 30, 30, ImageID(0))
    ButtonImageGadget(25, x+120, y+120, 30, 30, ImageID(0))
  EndIf ;CreateGadgetList  
EndIf ;OpenWindow

Repeat
  EventID = WaitWindowEvent()
  If EventID = #PB_Event_Gadget
    Select EventGadget()
      Case 1
        click= 1 : Gosub calup
      Case 2
        click= 2 : Gosub calup
      Case 3
        click= 3 : Gosub calup
      Case 4
        click= 4 : Gosub calup
      Case 5
        click= 5 : Gosub calup
      Case 6
        click= 6 : Gosub calup
      Case 7
        click= 7 : Gosub calup
      Case 8
        click= 8 : Gosub calup
      Case 9
        click= 9 : Gosub calup
      Case 10
        click= 10 : Gosub calup
      Case 11
        click= 11 : Gosub calup
      Case 12
        click= 12 : Gosub calup
      Case 13
        click= 13 : Gosub calup
      Case 14
        click= 14 : Gosub calup
      Case 15
        click= 15 : Gosub calup
      Case 16
        click= 16 : Gosub calup
      Case 17
        click= 17 : Gosub calup
      Case 18
        click= 18 : Gosub calup
      Case 19
        click= 19 : Gosub calup
      Case 20
        click= 20 : Gosub calup
      Case 21
        click= 21 : Gosub calup
      Case 22
        click= 22 : Gosub calup
      Case 23
        click= 23 : Gosub calup
      Case 24
        click= 24 : Gosub calup
      Case 25
        click= 25 : Gosub calup
    EndSelect
  EndIf

  If EventID = #PB_Event_Menu
    Select EventMenu()  ; To see which menu has been selected
      Case 1
        creategrid:
        For b=1 To 25
          light(b)=0
        Next b
        
        easy=GetMenuItemState(0, 7)
        If easy=1 : diff= 15 : EndIf
        
        medium=GetMenuItemState(0, 8)
        If medium=1 : diff=30 : EndIf
        
        hard=GetMenuItemState(0, 9)
        If hard=1 : diff=60 : EndIf
        
        gameon=1
        For e=1 To diff
          Repeat                    ; V1.0a addition
            click=Random(24)+1       ; Stops the Congrat message whilst creating a grid.
          Until click<>lastclick
          ;          
          lastclick=click
          Gosub calup
        Next e
        
        For f=1 To 25
          lastlight(f)=light(f)
        Next f
        DisableMenuItem(0,10, 0)
        
        numoff=0              ; V1.0a addition
        For f=1 To 25        ; Make sure the grid ins't empty.
          If light(f)=0
            numoff=numoff+1
          EndIf
        Next f
        If numoff>24 : Goto creategrid : EndIf
        
        moves=0
        StatusBarText(0, 0, "Game on!", 0)
      Case 3
        MessageRequester(ver$, ver$+" from G"+Chr(178)+" Software"+Chr(13)+Chr(169)+"2003, Lee Hesselden"+Chr(13)+Chr(13)+"See readme.htm for more details.", 0)
      Case 4
        End
      Case 5
        If best=1000
          MessageRequester(ver$, "No games have been completed!", 0)
        Else
          MessageRequester(ver$, "Today's Best: "+Str(best)+" clicks!", 0)
        EndIf
      Case 7
        state=GetMenuItemState(0, 7) 
        If state<>1
          SetMenuItemState(0, 7, 1)
          SetMenuItemState(0, 8, 0)
          SetMenuItemState(0, 9, 0)
        EndIf
      Case 8
        state=GetMenuItemState(0, 8) 
        If state<>1
          SetMenuItemState(0, 7, 0)
          SetMenuItemState(0, 8, 1)
          SetMenuItemState(0, 9, 0)
        EndIf
      Case 9
        state=GetMenuItemState(0, 9) 
        If state<>1
          SetMenuItemState(0, 7, 0)
          SetMenuItemState(0, 8, 0)
          SetMenuItemState(0, 9, 1)
        EndIf
      Case 10
        For f=1 To 25
          light(f)=lastlight(f)
        Next f
        moves=0
        Gosub update
        gameon=1
    EndSelect
  EndIf

;  Changes on/off when you move the mouse over grid.
;  a=a+1
;  If a=50
;    click=Random(24)+1
;    Gosub calup
;    a=0
;  EndIf

Until EventID = #PB_Event_CloseWindow

End

calup:
If gameon<>1 : Return : EndIf
moves=moves+1
lgtno=click : Gosub cl

If click=6 Or click=11 Or click=16 Or click=21
  ;
Else
  lgtno=click-1 : Gosub cl
EndIf

If click=5 Or click=10 Or click=15 Or click=20
  ;
Else
  lgtno=click+1 : Gosub cl
EndIf

lgtno=click-5 : Gosub cl

lgtno=click+5 : Gosub cl

Gosub update

; check if all out!
total=0
For c=1 To 25
  total=total+light(c)
Next c
If total=0
  StatusBarText(0, 0, "Lights Out!", 0)
  MessageRequester(ver$, "Congratulations! You successfully turned"+Chr(13)+"the lights out in "+Str(moves)+" clicks!", 0)
  gameon=0
  If moves<best : best=moves : EndIf
Else
  If moves>1
    StatusBarText(0, 0, Str(moves)+" clicks so far!", 0)
  EndIf
EndIf

Return

cl:
If lgtno>-1 And lgtno<26
  If light(lgtno)=0
    light(lgtno)=1
  Else
    light(lgtno)=0
  EndIf
EndIf
Return

update:
If CreateGadgetList(WindowID(0))
    For b=1 To 25
      FreeGadget(b)
    Next b
    
    ButtonImageGadget(1, x, y, 30, 30, ImageID(light(1)))
    ButtonImageGadget(2, x+30, y, 30, 30, ImageID(light(2)))
    ButtonImageGadget(3, x+60, y, 30, 30, ImageID(light(3)))
    ButtonImageGadget(4, x+90, y, 30, 30, ImageID(light(4)))
    ButtonImageGadget(5, x+120, y, 30, 30, ImageID(light(5)))  
    
    ButtonImageGadget(6, x, y+30, 30, 30, ImageID(light(6)))
    ButtonImageGadget(7, x+30, y+30, 30, 30, ImageID(light(7)))
    ButtonImageGadget(8, x+60, y+30, 30, 30, ImageID(light(8)))
    ButtonImageGadget(9, x+90, y+30, 30, 30, ImageID(light(9)))
    ButtonImageGadget(10, x+120, y+30, 30, 30, ImageID(light(10)))
    
    ButtonImageGadget(11, x, y+60, 30, 30, ImageID(light(11)))
    ButtonImageGadget(12, x+30, y+60, 30, 30, ImageID(light(12)))
    ButtonImageGadget(13, x+60, y+60, 30, 30, ImageID(light(13)))
    ButtonImageGadget(14, x+90, y+60, 30, 30, ImageID(light(14)))
    ButtonImageGadget(15, x+120, y+60, 30, 30, ImageID(light(15)))
    
    ButtonImageGadget(16, x, y+90, 30, 30, ImageID(light(16)))
    ButtonImageGadget(17, x+30, y+90, 30, 30, ImageID(light(17)))
    ButtonImageGadget(18, x+60, y+90, 30, 30, ImageID(light(18)))
    ButtonImageGadget(19, x+90, y+90, 30, 30, ImageID(light(19)))
    ButtonImageGadget(20, x+120, y+90, 30, 30, ImageID(light(20)))
    
    ButtonImageGadget(21, x, y+120, 30, 30, ImageID(light(21)))
    ButtonImageGadget(22, x+30, y+120, 30, 30, ImageID(light(22)))
    ButtonImageGadget(23, x+60, y+120, 30, 30, ImageID(light(23)))
    ButtonImageGadget(24, x+90, y+120, 30, 30, ImageID(light(24)))
    ButtonImageGadget(25, x+120, y+120, 30, 30, ImageID(light(25)))
  EndIf ;CreateGadgetList 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; UseIcon = N:\My Work\Old System\Software Development\greensquare.ico
; Executable = N:\My Work\Old System\Software Development\LOG-PC.exe