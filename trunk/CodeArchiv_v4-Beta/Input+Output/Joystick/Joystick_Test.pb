; German forum: http://www.purebasic.fr/german/viewtopic.php?t=10149&postdays=0&postorder=asc&start=60
; Author: GPI (updated for PB 4.00 by hardfalcon)
; Date: 02. February 2003
; OS: Windows
; Demo: No


;*** 
;*** Joytest 
;*** 
;*** GPI 02.02.2003 
;*** 

;Create_str (adr, an)  Rückgabe eines Strings in Speicher 
;                      bis man auf 0 trifft, maximal an Zeichen. 
Procedure.s create_str(adr.l,an) 
  a$="" 
  Repeat 
    a=PeekB(adr):adr+1:an-1 
    If a>0 
      a$+Chr(a) 
    EndIf 
  Until a=0 Or an=0 
  ProcedureReturn a$ 
EndProcedure 

;*** 
;-   Einige Struckturen 
;*** 
Structure joy_caps ; structure joycaps is too short! 
  wMid.w 
  wPid.w 
  szPname.b[#MAXPNAMELEN] 
  wXmin.l 
  wXmax.l 
  wYmin.l 
  wYmax.l 
  wZmin.l 
  wZmax.l 
  wNumButtons.l 
  wPeriodMin.l 
  wPeriodMax.l 
  wRmin.l 
  wRmax.l 
  wUmin.l 
  wUmax.l 
  wVmin.l 
  wVmax.l 
  wCaps.l 
  wMaxAxes.l 
  wNumAxes.l 
  wMaxButtons.l 
  szRegKey.b[#MAXPNAMELEN] 
  szOEMVxD.b[#MAX_JOYSTICKOEMVXDNAME] 
EndStructure 

Structure joy_infoex ; sizeof(JOYINFOEX) does not work! 
  size.l 
  flags.l 
  xpos.l 
  ypos.l 
  zpos.l 
  rpos.l 
  upos.l 
  vpos.l 
  buttons.l 
  buttonNumber.l 
  pov.l 
  reserved1.l 
  reserved2.l 
EndStructure 

;*** 
;-   Konstanten 
;*** 

#JOYCAPS_HASZ=1 
#JOYCAPS_HASR=2 
#JOYCAPS_HASU=4 
#JOYCAPS_HASV=8 
#JOYCAPS_HASPOV=16 
#JOYCAPS_POV4DIR=32 
#JOYCAPS_POVCTS=64 

;*** 
;-   main 
;*** 

;anzahl der Joystick bestimmen 
If OpenWindow(0, 0,0, 500,500, "Joysticktest", #PB_Window_ScreenCentered | #PB_Window_SystemMenu) 
  If CreateGadgetList(WindowID(0)) 
     ;TreeGadget(0, 10, 10, 480,380, #PB_Tree_AlwaysShowSelection | #PB_Tree_NoButtons) 
     TreeGadget(0, 10, 10, 480,380) 
      
     ComboBoxGadget(1, 10, 400, 480, 100) 
     TextGadget(2,  10,425, 150,20,"X:",#PB_Text_Border ) 
     TextGadget(3, 170,425, 150,20,"Y:",#PB_Text_Border ) 
     TextGadget(4, 330,425, 150,20,"Z:",#PB_Text_Border ) 
     TextGadget(5,  10,450, 150,20,"R:",#PB_Text_Border ) 
     TextGadget(6, 170,450, 150,20,"U:",#PB_Text_Border ) 
     TextGadget(7, 330,450, 150,20,"V:",#PB_Text_Border ) 
     TextGadget(8,  10,475, 150,20,"POV:",#PB_Text_Border ) 
     TextGadget(9, 170,475, 310,20,"Buttons:",#PB_Text_Border ) 
     ;TextGadget(10,330,475, 150,20,"ButtonNr:",#PB_Text_Border ) 
                      
     joy_an=joyGetNumDevs_() 
      
     AddGadgetItem(0,-1,"Info") 
       AddGadgetItem(0,-1,"Number of Joysticks:"+Str(joy_an)+" (i had only one, but API says that i have 16 ;)",0,1) 
       AddGadgetItem(0,-1,"Joysticktest by GPI!",0,1) 
     SetGadgetItemState(0, 0, #PB_Tree_Expanded) 
      
;AddGadgetItem(0,-1,,0,1) 
      
Define.joy_caps joy_info 

     For i=0 To joy_an 
       ret=joyGetDevCaps_(i,@joy_info.joy_caps,SizeOf(joy_caps)) 
       If ret 
         AddGadgetItem(1, -1, "Joystick "+Str(i)+ " (not present)") 
         AddGadgetItem(0,-1,"Joystick "+Str(i)) 
           AddGadgetItem(0,-1,"not present",0,1) 
       Else 
         AddGadgetItem(1, -1, "Joystick "+Str(i)) 
         AddGadgetItem(0,-1,"Joystick "+Str(i)) 
         StartNode = CountGadgetItems(0)-1 
           AddGadgetItem(0,-1,"Driver Information",0,1) 
             AddGadgetItem(0,-1,"Joystick produkt name:"+create_str (@joy_info\szpname[0],#MAXPNAMELEN),0,2) 
             AddGadgetItem(0,-1,"Manufacture and Product identifier:"+Str(joy_info\wmid)+" / "+Str(joy_info\wpid),0,2) 
             AddGadgetItem(0,-1,"registry key:"+create_str (@joy_info\szregkey[0],#MAXPNAMELEN),0,2) 
             AddGadgetItem(0,-1,"driver oem:"+create_str (@joy_info\szoemvxd[0],#MAXPNAMELEN),0,2) 
           AddGadgetItem(0,-1,"Axis",0,1) 
             AddGadgetItem(0,-1,"Number of axes supported:"+Str(joy_info\wmaxaxes),0,2) 
             AddGadgetItem(0,-1,"Number of axes in use:"+Str(joy_info\wnumaxes),0,2) 
             AddGadgetItem(0,-1,"X-Axis:"+Str(joy_info\wxmin)+" to "+Str(joy_info\wxmax),0,2) 
             AddGadgetItem(0,-1,"Y-Axis:"+Str(joy_info\wymin)+" to "+Str(joy_info\wymax),0,2) 
             If joy_info\wcaps & #JOYCAPS_HASZ 
               AddGadgetItem(0,-1,"Z-Axis:"+Str(joy_info\wzmin)+" to "+Str(joy_info\wzmax),0,2) 
             EndIf 
             If joy_info\wcaps & #JOYCAPS_HASR 
               AddGadgetItem(0,-1,"R-Axis:"+Str(joy_info\wrmin)+" to "+Str(joy_info\wrmax),0,2) 
             EndIf 
             If joy_info\wcaps & #JOYCAPS_HASU 
               AddGadgetItem(0,-1,"U-Axis:"+Str(joy_info\wumin)+" to "+Str(joy_info\wumax),0,2) 
             EndIf 
             If joy_info\wcaps & #JOYCAPS_HASV 
               AddGadgetItem(0,-1,"V-Axis:"+Str(joy_info\wvmin)+" to "+Str(joy_info\wvmax),0,2) 
             EndIf 
           If joy_info\wcaps & #JOYCAPS_HASPOV 
             AddGadgetItem(0,-1,"POV (point-of-view)",0,1) 
             If joy_info\wcaps & #JOYCAPS_POV4DIR 
               AddGadgetItem(0,-1,"Support of discrete values (centered,forward,backward,left,right)",0,2) 
             EndIf 
             If joy_info\wcaps & #JOYCAPS_POVCTS 
               AddGadgetItem(0,-1,"Support of continuous degree bearings",0,2) 
             EndIf 
           EndIf 
           AddGadgetItem(0,-1,"Buttons",0,1) 
             AddGadgetItem(0,-1,"Supported buttons:"+Str(joy_info\wmaxbuttons),0,2) 
             AddGadgetItem(0,-1,"Number of buttons:"+Str(joy_info\wNumButtons),0,2) 
           AddGadgetItem(0,-1,"Additional Information",0,1) 
             AddGadgetItem(0,-1,"Polling Frequency:"+Str(joy_info\wperiodmin)+" to "+Str(joy_info\wperiodmax),0,2) 
         For k = StartNode To CountGadgetItems(0)-1 
           SetGadgetItemState(0, k, #PB_Tree_Expanded) 
         Next k 
       EndIf 
     Next i 
      
     SetGadgetState(1,0) 

      
     ;For i=0 To CountGadgetItems(0) 
     ;  SetGadgetItemState(0, i, #PB_Tree_Expanded) 
     ;Next 
      
      
      
     joy_status.joy_infoex 
     joy_status\size=SizeOf(JOY_INFOEX) 
     joy_status\flags=#JOY_RETURNALL 
     Repeat 
       Event = WindowEvent() 
       joy=GetGadgetState(1) 
       If joy >=0 
         ret=joyGetPosEx_(joy,@joy_status) 
         If ret=0 
           SetGadgetText(2,"X:"+Str(joy_status\xpos)) 
           SetGadgetText(3,"Y:"+Str(joy_status\ypos)) 
           SetGadgetText(4,"Z:"+Str(joy_status\zpos)) 
           SetGadgetText(5,"R:"+Str(joy_status\rpos)) 
           SetGadgetText(6,"U:"+Str(joy_status\upos)) 
           SetGadgetText(7,"V:"+Str(joy_status\vpos)) 
           a$=Hex(joy_status\pov): While Len(a$)<4: a$="0"+a$: Wend 
           SetGadgetText(8,"POV:$"+a$+":"+Str(joy_status\pov)) 
           a$=Bin(joy_status\buttons): While Len(a$)<32: a$="0"+a$: Wend 
           SetGadgetText(9,"Buttons (bin):"+a$+":"+Str(joy_status\buttons)) 
         Else 
           SetGadgetText(2,"ERROR!"):SetGadgetText(3,"ERROR!"):SetGadgetText(4,"ERROR!") 
           SetGadgetText(5,"ERROR!"):SetGadgetText(6,"ERROR!"):SetGadgetText(7,"ERROR!") 
           SetGadgetText(8,"ERROR!"):SetGadgetText(9,"ERROR!") 
         EndIf 
         Delay(10) 
       EndIf 
     Until Event = #PB_Event_CloseWindow 

  EndIf 
EndIf 

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -