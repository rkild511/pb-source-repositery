; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1657&highlight=
; Author: Wichtel (updated for PB4.00 by blbltheworm + Andre)
; Date: 09. July 2003
; OS: Windows
; Demo: No


Global STOP.l 

#aboutwindow=1 
#aboutimage=1 
#aboutwidth=320 
#aboutheight=480 
#logofont=1 
#aboutfont=2 

DataSection 
abouttext: 
  ;Hier muesst ihr 'ne textdatei (nicht zu gross) angeben 
  IncludeBinary "abouttext.txt"
  Data.b 0 
EndDataSection 

abouttext.s = PeekS(?abouttext) 

LoadFont(#logofont,"Comic Sans MS", 20) 
LoadFont(#aboutfont,"Comic Sans MS", 12) 


Procedure MakeTextImage(id.l,x.l,y.l,t$,f.l,fg.l,bg.l) 
  CreateImage(id,x,y) 
  StartDrawing(ImageOutput(id)) 
  Box(0, 0,x,y,bg) 
  DrawingMode(1) 
  FrontColor(RGB(Red(fg),Green(fg),Blue(fg))) 
  DrawingFont(FontID(f)) 
  w.l=TextWidth(t$) 
  h.l=TextWidth("Ny") 
  DrawText(x/2-w/2,y/2-h/2,t$) 
  StopDrawing() 
EndProcedure 



Procedure MakeAboutSprite(id.l,x.l,y.l,t$,f,fg.l,bg.l) 

  If Right(t$,2)<>Chr(13)+Chr(10) 
    t$+Chr(13)+Chr(10) 
  EndIf  
  CreateSprite(id,x,y) 
  StartDrawing(SpriteOutput(id)) 
  DrawingFont(FontID(f)) 
  theight=TextWidth("Ny") 
  tlength=TextWidth(t$) 
  txmin=x/10 : tymin=y/10 
  txmax=x-2*txmin : tymax=y-2*tymin 
  tx=txmin : ty=tymin 
  c=1 : w$="" 
  Repeat 
    c$=Mid(t$,c,1) 
    If Asc(c$)> 31 
      w$+c$ 
    EndIf  
    If tx>=txmax 
      c-Len(w$) 
      w$="" 
      tx=txmin 
      ty+theight 
    EndIf  
    If c$ = Chr(13) 
      tx=txmin 
      ty+theight 
      w$="" 
    EndIf  
    If c$=" " 
      tx+TextWidth(w$) 
      w$="" 
    EndIf 
    c+1 
  Until c=Len(t$) 
  StopDrawing() 
  FreeSprite(id) 

  y=ty 
  scrolly=y 
  scrollx=0 
  tymin=y/10 
  tx=txmin 
  ty=tymin 


  CreateSprite(id,x,y) 
  StartDrawing(SpriteOutput(id)) 
  DrawingFont(FontID(f)) 
  Box(0, 0,x,y,bg) 
  DrawingMode(1) 
  FrontColor(RGB(Red(fg),Green(fg),Blue(fg))) 
  c=1 : w$="" 
  Repeat 
    c$=Mid(t$,c,1) 
    If Asc(c$)> 31 
      w$+c$ 
    EndIf  
    If tx>=txmax 
      c-Len(w$) 
      w$="" 
      tx=txmin 
      ty+theight 
    EndIf  
    If c$ = Chr(13) 
      DrawText(tx,ty,w$) 
      tx=txmin 
      ty+theight 
      w$="" 
    EndIf  
    If c$=" " 
      DrawText(tx,ty,w$) 
      tx+TextWidth(w$) 
      w$="" 
    EndIf 
    c+1 
  Until c=Len(t$) 
  StopDrawing() 
EndProcedure 



Procedure ScrollAboutSprite(speed.l) 
  sy=160 
  sx=0 
  Repeat 
    sy-1 
    If sy<-SpriteHeight(1) 
      sy=160 
    EndIf  
    DisplaySprite(1,sx,sy) 
    FlipBuffers() 
    Delay (speed) 
  Until STOP=1 
EndProcedure 



Procedure OpenABoutBox(awin.l, aimg.l, atitle.s, atext.s, afont.l, abutton.s, awinbg.l,atextfg.l,atextbg.l) 
  bgbrush = CreateSolidBrush_(awinbg) 
  OpenWindow(awin,0,0,320,320,atitle,#PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
  SetClassLong_(WindowID(awin), #GCL_HBRBACKGROUND, bgbrush) 
  InvalidateRect_(WindowID(awin), #Null, #True) 
  CreateGadgetList(WindowID(awin)) 
  ImageGadget(1,10,10,1,1,ImageID(aimg)) 
  InitSprite() 
  OpenWindowedScreen(WindowID(awin),10,100,300,180,0,0,0) 
  ClearScreen(RGB(Red(atextbg),Green(atextbg),Blue(atextbg))) 
  ButtonGadget(2,10,290,300,20,abutton) 
  MakeAboutSprite(1,300,300,atext,afont,atextfg,atextbg) 
  
  sid=CreateThread(@ScrollAboutSprite(),30) 

  Repeat 
  EventID = WaitWindowEvent() 
  Select EventID 
   Case #PB_Event_Gadget 
     GadgetID = EventGadget() 
     Select GadgetID 
       Case 2 
         EventID = #PB_Event_CloseWindow 
     EndSelect 
  EndSelect 
  Until EventID = #PB_Event_CloseWindow 
  STOP=1 
  Delay(30) 
  CloseWindow(awin) 
  DeleteObject_(bgbrush) 
  FreeSprite(1) 
EndProcedure 


MakeTextImage(#aboutimage,300,80,"Hier kann das Logo hin",#logofont,$11aaaa, $aa1111) 

OpenAboutBox(#aboutwindow,#aboutimage,"Über",abouttext, #aboutfont, "Jaja", $77ffff, $771111, $ffaaff) 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
