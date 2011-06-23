; www.purearea.net (Sourcecode collection by cnesm)
; Author: oppi (updated for PB4.00 by blbltheworm)
; Date: 22. November 2003
; OS: Windows
; Demo: No


; Variablen und Konstanten initialisieren

#version="(c) oppi 2003, V1.61"
#appname="ANACLOX"
#ininame="anaclox.ini"

Global width, height, winx, winy
Global box.l,s, PI2.f, PI.f, xm, ym, radius
Global tickcol.l, seccol.l, mincol.l, hcol.l, backcol.l, boxcol.l, jewcol.l, txtcol.l 
Global tid.l, info$, font.l,s.l,os.l
Global flagShowDay.l, flagShowInfo.l, flagOnTop.l

info$="ANACLOX V1.5"

PI2=ATan(1)*8
PI=ATan(1)*4

Structure xy
  xa.l
  ya.l
  xe.l
  ye.l
  xb.l
  yb.l
  xc.l
  yc.l
  xf.l
  yf.l
EndStructure

Global Dim ticks.xy(60)
Global Dim secs.xy(60)
Global Dim mins.xy(60)
Global Dim hrs.xy(60)

;- GUI Konstanten

#win=0
#clock=0

#set=0
#OnTop=0
#ShowDay=1
#ShowInfo=2
#setInfo=3
#default=8
#ver=9

#seccol=11
#mincol=12
#hrscol=13
#jewcol=14
#txtcol=15
#backcol=16
#boxcol=17
#tickcol=18


Procedure LoadPrefs(ininame.s)
  OpenPreferences(ininame)
  info$  =ReadPreferenceString("info",#version)
  width  =ReadPreferenceLong("width",300)  
  height =ReadPreferenceLong("height",300+30)  
  winx   =ReadPreferenceLong("winx",GetSystemMetrics_(#SM_CXSCREEN)/2-width/2) 
  winy   =ReadPreferenceLong("winy",GetSystemMetrics_(#SM_CYSCREEN)/2-height/2)
  boxcol =ReadPreferenceLong("boxcol",$FFFFFF)
  backcol=ReadPreferenceLong("backcol",$FFFFFF)
  tickcol=ReadPreferenceLong("tickcol",$AAAAAA)
  jewcol =ReadPreferenceLong("jewcol",$00FFFF)
  seccol =ReadPreferenceLong("seccol",$0000FF)
  mincol =ReadPreferenceLong("mincol",$00FF00)
  hcol   =ReadPreferenceLong("hcol",$FF0000)
  txtcol =ReadPreferenceLong("txtcol",$111111)
  flagOnTop=ReadPreferenceLong("ontop",1)
  flagShowDay=ReadPreferenceLong("showday",1)
  flagShowInfo=ReadPreferenceLong("showinfo",1)
  ClosePreferences()
EndProcedure

Procedure savePrefs(ininame.s)
  CreatePreferences(ininame)
  WritePreferenceString("info",info$)
  WritePreferenceLong("width",WindowWidth(#win))  
  WritePreferenceLong("height",WindowHeight(#win))  
  WritePreferenceLong("winx",WindowX(#win)) 
  WritePreferenceLong("winy",WindowY(#win))
  WritePreferenceLong("boxcol",boxcol)
  WritePreferenceLong("backcol",backcol)
  WritePreferenceLong("tickcol",tickcol)
  WritePreferenceLong("jewcol",jewcol)
  WritePreferenceLong("seccol",seccol)
  WritePreferenceLong("mincol",mincol)
  WritePreferenceLong("hcol",hcol)
  WritePreferenceLong("txtcol",txtcol)
  WritePreferenceLong("ontop",flagOnTop)
  WritePreferenceLong("showday",flagShowDay)
  WritePreferenceLong("showinfo",flagShowInfo)
  ClosePreferences()
EndProcedure

Procedure resetPrefs(ininame.s)
  CreatePreferences(ininame)
  ClosePreferences()
  loadPrefs(ininame)  
EndProcedure

Procedure DrawClock()
  xm=WindowWidth(#win)/2 : ym=WindowHeight(#win)/2
  If ym<xm : radius=ym*0.98 : Else : radius=xm*0.98 : EndIf 
  font = LoadFont(0, "comic sans ms", radius*0.06) 
  ;- Koordinaten berechnen
  a.f=PI2 : t=0
  While a >= 0
   ticks(t)\xa=Sin(a+PI)*(radius*0.91)+xm
   ticks(t)\ya=Cos(a+PI)*(radius*0.91)+ym
   ticks(t)\xb=Sin(a+PI+PI/40)*(radius*0.89)+xm
   ticks(t)\yb=Cos(a+PI+PI/40)*(radius*0.89)+ym
   ticks(t)\xc=Sin(a+PI-PI/40)*(radius*0.89)+xm
   ticks(t)\yc=Cos(a+PI-PI/40)*(radius*0.89)+ym
   ticks(t)\xf=Sin(a+PI)*(radius*0.89)+xm
   ticks(t)\yf=Cos(a+PI)*(radius*0.89)+ym
   ticks(t)\xe=Sin(a+PI)*(radius*0.87)+xm
   ticks(t)\ye=Cos(a+PI)*(radius*0.87)+ym

   secs(t)\xa=Sin(a+PI)*(radius*0.10)+xm
   secs(t)\ya=Cos(a+PI)*(radius*0.10)+ym
   secs(t)\xe=Sin(a+PI)*(radius*0.84)+xm
   secs(t)\ye=Cos(a+PI)*(radius*0.84)+ym
   secs(t)\xf=Sin(a+PI)*(radius*0.75)+xm
   secs(t)\yf=Cos(a+PI)*(radius*0.75)+ym

   mins(t)\xa=Sin(a+PI)*(radius*0.10)+xm
   mins(t)\ya=Cos(a+PI)*(radius*0.10)+ym
   mins(t)\xb=Sin(a+PI+PI/40)*(radius*0.60)+xm
   mins(t)\yb=Cos(a+PI+PI/40)*(radius*0.60)+ym
   mins(t)\xc=Sin(a+PI-PI/40)*(radius*0.60)+xm
   mins(t)\yc=Cos(a+PI-PI/40)*(radius*0.60)+ym
   mins(t)\xf=Sin(a+PI)*(radius*0.60)+xm
   mins(t)\yf=Cos(a+PI)*(radius*0.60)+ym
   mins(t)\xe=Sin(a+PI)*(radius*0.80)+xm
   mins(t)\ye=Cos(a+PI)*(radius*0.80)+ym

   hrs(t)\xa=Sin(a+PI)*(radius*0.10)+xm
   hrs(t)\ya=Cos(a+PI)*(radius*0.10)+ym
   hrs(t)\xb=Sin(a+PI+PI/20)*(radius*0.50)+xm
   hrs(t)\yb=Cos(a+PI+PI/20)*(radius*0.50)+ym
   hrs(t)\xc=Sin(a+PI-PI/20)*(radius*0.50)+xm
   hrs(t)\yc=Cos(a+PI-PI/20)*(radius*0.50)+ym
   hrs(t)\xf=Sin(a+PI)*(radius*0.50)+xm
   hrs(t)\yf=Cos(a+PI)*(radius*0.50)+ym
   hrs(t)\xe=Sin(a+PI)*(radius*0.70)+xm
   hrs(t)\ye=Cos(a+PI)*(radius*0.70)+ym

   a-PI2/60
   t+1
  Wend

  ;- Ziffernblatt
  box = CreateImage(0, 2*xm,2*ym) 
  StartDrawing(ImageOutput(0)) 
  Box(0, 0,2*xm, 2*ym,boxcol) 
  Circle(xm,ym,radius,tickcol)
  Circle(xm,ym,radius*0.95,backcol)
  Circle(xm,ym,radius*0.09,tickcol)
  For t=0 To 59
    If t=0 Or t=15 Or t=30 Or t=45
      LineXY(ticks(t)\xa,ticks(t)\ya,ticks(t)\xb,ticks(t)\yb,tickcol)
      LineXY(ticks(t)\xb,ticks(t)\yb,ticks(t)\xe,ticks(t)\ye,tickcol)
      LineXY(ticks(t)\xe,ticks(t)\ye,ticks(t)\xc,ticks(t)\yc,tickcol)
      LineXY(ticks(t)\xc,ticks(t)\yc,ticks(t)\xa,ticks(t)\ya,tickcol)
      FillArea(ticks(t)\xf,ticks(t)\yf,tickcol,jewcol) 
    ElseIf t=5 Or t=10 Or t=20 Or t=25 Or t=35 Or t=40 Or t=50 Or t=55
      Circle(ticks(t)\xf,ticks(t)\yf,radius*0.02,jewcol)
      DrawingMode(4)
      Circle(ticks(t)\xf,ticks(t)\yf,radius*0.02,tickcol)
      DrawingMode(0)
    Else
     LineXY(ticks(t)\xa,ticks(t)\ya,ticks(t)\xe,ticks(t)\ye,tickcol)
    EndIf 
  Next
  StopDrawing()
EndProcedure

Procedure tick(value.l)
  Repeat
    s=Second(Date())
    If s<>os
      m=Minute(Date())
      h=Hour(Date())
      d$=Str(Day(Date()))
      If h > 12 : h=h-12 : EndIf
      h=h*5+m/12
      If h > 60 : h=h-60 : EndIf
     Debug h
      StartDrawing(ImageOutput(0)) 
      DrawingMode(0)

      Circle(xm,ym,radius*0.85,backcol)
      Circle(xm,ym,radius*0.09,tickcol)
      
      If flagShowInfo=#True
      FrontColor(RGB(Red(txtcol),Green(txtcol),Blue(txtcol)))
      BackColor(RGB(Red(backcol),Green(backcol),Blue(backcol)))
      DrawingFont(font)
      l=TextWidth(info$)
      DrawText(xm-l/2,ym+radius*0.40,info$)
      EndIf


      If flagShowDay=#True
      DrawingFont(font)
      l=TextWidth(d$)
      Box(xm-l/2*1.5,ym-radius*0.62,l*1.5,l*1.5,jewcol)
      DrawingMode(4)
      Box(xm-l/2*1.5,ym-radius*0.62,l*1.5,l*1.5,tickcol)

      DrawingMode(0)
      FrontColor(RGB(Red(txtcol),Green(txtcol),Blue(txtcol)))
      BackColor(RGB(Red(jewcol),Green(jewcol),Blue(jewcol)))
      DrawText(xm-l/2,ym-radius*0.60,d$)
      EndIf


      
;       ;- neue Zeiger malen
      LineXY(mins(m)\xa,mins(m)\ya,mins(m)\xb,mins(m)\yb,mincol)
      LineXY(mins(m)\xb,mins(m)\yb,mins(m)\xe,mins(m)\ye,mincol)
      LineXY(mins(m)\xe,mins(m)\ye,mins(m)\xc,mins(m)\yc,mincol)
      LineXY(mins(m)\xc,mins(m)\yc,mins(m)\xa,mins(m)\ya,mincol)
      FillArea(mins(m)\xf,mins(m)\yf,mincol,mincol) 

      LineXY(hrs(h)\xa,hrs(h)\ya,hrs(h)\xb,hrs(h)\yb,hcol)
      LineXY(hrs(h)\xb,hrs(h)\yb,hrs(h)\xe,hrs(h)\ye,hcol)
      LineXY(hrs(h)\xe,hrs(h)\ye,hrs(h)\xc,hrs(h)\yc,hcol)
      LineXY(hrs(h)\xc,hrs(h)\yc,hrs(h)\xa,hrs(h)\ya,hcol)
      FillArea(hrs(h)\xf,hrs(h)\yf,hcol,hcol) 

      LineXY(secs(s)\xa,secs(s)\ya,secs(s)\xe,secs(s)\ye,seccol)
      Circle(secs(s)\xf,secs(s)\yf,radius*0.03,seccol)

 
      StopDrawing()
      SetGadgetState(0,box)
      os=s
 ;     Delay(800); ein bischen warten, damit repeat until nicht soviel loopt
    EndIf
    Delay(1)  
  ForEver
EndProcedure

Procedure ToggleOnTop()
          If GetMenuItemState(#set,#onTop) = 1
            SetWindowPos_(WindowID(#win),#HWND_TOPMOST,0,0,0,0,#SWP_SHOWWINDOW|#SWP_NOMOVE|#SWP_NOSIZE) 
            flagOnTop=1
          Else
            SetWindowPos_(WindowID(#win),#HWND_NOTOPMOST,0,0,0,0,#SWP_SHOWWINDOW|#SWP_NOMOVE|#SWP_NOSIZE) 
            flagOnTop=0
          EndIf  
EndProcedure

;-main
LoadPrefs(#ininame)
box = CreateImage(0, width,height) 

;-create window
OpenWindow(#win,winx,winy,width,height,#appname,#PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget|#PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
CreateGadgetList(WindowID(0))
ImageGadget(#clock,0,0,width,height,box)
CreatePopupMenu(#set)
 MenuTitle(#appname+" settings")
 MenuItem(#OnTop,"always on top")
  SetMenuItemState(#set,#OnTop,flagOnTop) 
  ToggleOnTop()
 MenuItem(#ShowDay,"show day")
  SetMenuItemState(#set,#ShowDay,flagShowDay)
 MenuItem(#ShowInfo,"show info")
  SetMenuItemState(#set,#ShowInfo,flagShowInfo)
 OpenSubMenu("change colors")
  MenuItem(#seccol,"seconds")
  MenuItem(#mincol,"minutes")
  MenuItem(#hrscol,"hours")
  MenuItem(#jewcol,"jewels")
  MenuItem(#txtcol,"text")
  MenuItem(#tickcol,"border")
  MenuItem(#backcol,"background")
  MenuItem(#boxcol,"box")
 CloseSubMenu()
 MenuItem(#setInfo,"change info")
 MenuBar()
 MenuItem(#default,"set defaults")
 MenuBar()
 MenuItem(#ver,#version)
  DisableMenuItem(#set,#ver,1)
 

;-draw clock
DrawClock()
tid=CreateThread(@tick(),0)
;SetWindowCallback(@SizeCallback())

;event loop
Repeat
  EventID = WaitWindowEvent()
  Select EventID
    Case #WM_SIZE 
      PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
    Case #WM_RBUTTONDOWN 
      popx.l=WindowX(#win)+WindowMouseX(#win)
      popy.l=WindowY(#win)+WindowMouseY(#win)
      DisplayPopupMenu(0,WindowID(0),popx,popy) 
;      Case #PB_EventGadget
;        GadgetID = EventGadgetID()
;        Select GadgetID
;     
;        EndSelect
    Case #PB_Event_Menu
      MenuID = EventMenu()
      Select MenuID
        Case #onTop
          SetMenuItemState(#set,#onTop,GetMenuItemState(#set,#onTop)!1) 
          ToggleOnTop()  
        Case #ShowDay
          SetMenuItemState(#set,#Showday,GetMenuItemState(#set,#ShowDay)!1) 
          If GetMenuItemState(#set,#ShowDay) = 1 
             flagShowday=#True 
          Else 
            flagShowDay=#False
          EndIf  
        Case #ShowInfo
          SetMenuItemState(#set,#ShowInfo,GetMenuItemState(#set,#ShowInfo)!1) 
          If GetMenuItemState(#set,#ShowInfo) = 1 
             flagShowInfo=#True 
          Else 
            flagShowInfo=#False
          EndIf  
        Case #setInfo
          Repeat
          info$=InputRequester(#appname+" info text edit","your text has: "+Str(Len(info$))+" chars, max. 30 chars are allowed",info$)
          Until Len(info$)<30
          
        Case #default
          ResetPrefs(#ininame)  
          SetWindowPos_(WindowID(#win),#HWND_TOP,winx,winy,width,height,#SWP_SHOWWINDOW) 
          PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
          ToggleOnTop()
        Case #seccol
          seccol=ColorRequester()
        Case #mincol
          mincol=ColorRequester()
        Case #hrscol
          hcol=ColorRequester()
        Case #jewcol
          jewcol=ColorRequester()
          PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
        Case #txtcol
          txtcol=ColorRequester()
        Case #tickcol
          tickcol=ColorRequester()
          PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
        Case #backcol
          backcol=ColorRequester()
          PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
        Case #boxcol
          boxcol=ColorRequester()
          PauseThread(tid) : os=s-1 : DrawClock() : ResumeThread(tid) 
      EndSelect
  EndSelect
Until EventID = #PB_Event_CloseWindow
SavePrefs(#ininame)
CloseWindow(0)

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
; EnableXP
; Executable = C:\Documents and Settings\wichtel\My Documents\My Basic\uhr\anaclox.exe
; DisableDebugger