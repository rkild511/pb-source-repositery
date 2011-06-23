; German forum: 
; Author: Daniel
; Date: 24. July 2002
; OS: Windows
; Demo: No

Global b.f,b2.f,b3.f,b4.f 
Global c.f,c2.f,c3.f,c4.f 
Global temp1.s,temp2.s,temp3.s 

OpenWindow(0, (GetSystemMetrics_(#SM_CXSCREEN)-80)/2,(GetSystemMetrics_(#SM_CYSCREEN)-90)/2, 160, 180, "quadratische Funktionen Rechner", #PB_Window_SystemMenu|#PB_Window_MinimizeGadget) 

If CreateGadgetList(WindowID(0)) 
  PanelGadget(0,0,0,160,180) 
  AddGadgetItem(0,0," ² -> S") 
  TextGadget(1,10,13,40,20,"y = x² +") 
  StringGadget(2,50,10,30,20,"") 
  TextGadget(3,80,13,30,20," x +") 
  StringGadget(4,110,10,30,20,"") 
  StringGadget(5,20,50,120,20,"( x + "+Str(b)+" ) ² + "+Str(c)) 
  StringGadget(6,35,90,90,20,"S ( "+Str(-b)+" ; "+Str(c)+" )") 
  AddGadgetItem(0,1," S -> ²") 
  TextGadget(8,25,13,20,20," S (") 
  StringGadget(9,45,10,30,20,"") 
  TextGadget(10,75,13,10,20," ; ") 
  StringGadget(11,85,10,30,20,"") 
  TextGadget(12,115,13,10,20," )") 
  StringGadget(13,40,50,80,20,"( x + "+Str(b2)+" ) ² + "+Str(c2)) 
  StringGadget(14,10,90,130,20,"y = x ² + "+Str(b2*2)+" x + "+Str(c2+Pow(b2,2))) 
  AddGadgetItem(0,2," ?") 
  TextGadget(15,10,10,140,120,"Rechner für quadratischhe Funktionen"+Chr(10)+"(c) Copyright 2002"+Chr(10)+"Daniel Starke"+Chr(10)+Chr(10)+"Info:"+Chr(10)+"Anstadt eines Kommers wird ein Punkt gesetzt.") 
  AddGadgetItem(0,3,"Nullstelle") 
  TextGadget(16,10,13,40,20,"y = x² +") 
  StringGadget(17,50,10,30,20,"") 
  TextGadget(18,80,13,30,20," x +") 
  StringGadget(19,110,10,30,20,"") 
  StringGadget(20,40,65,90,20,"") 
  StringGadget(21,40,85,90,20,"") 
  TextGadget(22,15,68,20,20,"x1 = ") 
  TextGadget(23,15,88,20,20,"x2 = ") 
  AddGadgetItem(0,4,"Eigenschaften f(x)") 
  TextGadget(24,10,13,40,20,"y = x² +") 
  StringGadget(25,50,10,30,20,"") 
  TextGadget(26,80,13,30,20," x +") 
  StringGadget(27,110,10,30,20,"") 
  TextGadget(28,5,35,5,5,"") 
  RichEditFrame=Frame3DGadget(29,5,50,145,105,"",0) 
  OpenRichEdit(RichEditFrame,1,0,0,145,105,"test"+Chr(10)+"test") 
  CloseGadgetList() 
EndIf 

Repeat 

  eventid.l=WaitWindowEvent() 

  If eventid=#PB_Event_Gadget 

    ;² -> S 
    Select EventGadget() 
      Case 2 
        Gosub panel1 
      Case 4 
        Gosub panel1 
      ;S -> ² 
      Case 9 
        Gosub panel2 
      Case 11 
        Gosub panel2 
      ;Nullstelle 
      Case 17 
        Gosub panel4 
      Case 19 
        Gosub panel4 
      ;Eigenschaften f(x) 
      Case 25 
        Gosub panel5 
      Case 27 
        Gosub panel5 
    EndSelect 

  EndIf 

Until eventid=#PB_Event_CloseWindow 

End 

;Rechnungen 
;² -> S 
panel1: 
  b=ValF(GetGadgetText(2))/2 
  c=ValF(GetGadgetText(4))-Pow(b,2) 
  If b>=0 And c>=0 
    SetGadgetText(5,"( x + "+StrF(b)+" ) ² + "+StrF(c)) 
  ElseIf b>=0 And c<0 
    SetGadgetText(5,"( x + "+StrF(b)+" ) ² "+StrF(c)) 
  ElseIf b<0 And c>=0 
    SetGadgetText(5,"( x "+StrF(b)+" ) ² + "+StrF(c)) 
  ElseIf b<0 And c<0 
    SetGadgetText(5,"( x "+StrF(b)+" ) ² "+StrF(c)) 
  EndIf 
  SetGadgetText(6,"S ( "+StrF(-b)+" ; "+StrF(c)+" )") 
Return 

;S -> ² 
panel2: 
  b2=ValF(GetGadgetText(9))*-1 
  c2=ValF(GetGadgetText(11)) 
  If b2<0 And c2>=0 
    SetGadgetText(13,"( x "+StrF(b2)+" ) ² + "+StrF(c2)) 
    SetGadgetText(14,"y = x ² "+StrF(b2*2)+" x + "+StrF(c2+Pow(b2,2))) 
  ElseIf b2>=0 And c2<0 
    SetGadgetText(13,"( x + "+StrF(b2)+" ) ² "+StrF(c2)) 
    If c2+Pow(b2,2)<0 
      SetGadgetText(14,"y = x ² + "+StrF(b2*2)+" x "+StrF(c2+Pow(b2,2))) 
    Else 
      SetGadgetText(14,"y = x ² + "+StrF(b2*2)+" x + "+StrF(c2+Pow(b2,2))) 
    EndIf 
  ElseIf b2>=0 And c2>=0 
    SetGadgetText(13,"( x + "+StrF(b2)+" ) ² + "+StrF(c2)) 
    SetGadgetText(14,"y = x ² + "+StrF(b2*2)+" x + "+StrF(c2+Pow(b2,2))) 
  ElseIf b2<0 And c2<0 
    SetGadgetText(13,"( x "+StrF(b2)+" ) ² "+StrF(c2)) 
    If c2+Pow(b2,2)<0 
      SetGadgetText(14,"y = x ² "+StrF(b2*2)+" x "+StrF(c2+Pow(b2,2))) 
    Else 
      SetGadgetText(14,"y = x ² "+StrF(b2*2)+" x + "+StrF(c2+Pow(b2,2))) 
    EndIf 
  EndIf 
Return 

;Nullstelle 
panel4: 
  b3=ValF(GetGadgetText(17)) 
  c3=ValF(GetGadgetText(19)) 
  SetGadgetText(20,StrF( -(b3/2)+Sqr(Pow(b3/2,2)-c3) )) 
  If GetGadgetText(20)="-1.#IND" 
    SetGadgetText(20,"---") 
  EndIf 
  SetGadgetText(21,StrF( -(b3/2)-Sqr(Pow(b3/2,2)-c3) )) 
  If GetGadgetText(21)="-1.#IND" 
    SetGadgetText(21,"---") 
  EndIf 
  If GetGadgetText(20)=GetGadgetText(21) 
    SetGadgetText(21,"---") 
  EndIf 
Return 

;Eigenschaften f(x) 
panel5: 
  temp1="" 
  temp2="" 
  temp3="" 
  b4=ValF(GetGadgetText(25))/-2 
  c4=ValF(GetGadgetText(27))-Pow(b4,2) 
  temp3=temp3+"S ( "+StrF(b4)+" ; "+StrF(c4)+" )"+Chr(10) 
  temp3=temp3+"Werteb.: yeR ; y >= "+StrF(c4)+Chr(10) 
  temp3=temp3+"monoton F/S: x >= "+StrF(b4)+" ; x <= "+StrF(b4)+Chr(10) 
  b4=ValF(GetGadgetText(25)) 
  c4=ValF(GetGadgetText(27)) 
  temp1=StrF( -(b4/2)+Sqr(Pow(b4/2,2)-c4) ) 
  If temp1="-1.#IND" 
    temp1="---" 
  EndIf 
  temp2=StrF( -(b4/2)-Sqr(Pow(b4/2,2)-c4) ) 
  If temp2="-1.#IND" 
    temp2="---" 
  EndIf 
  If temp1=temp2 
    temp2="---" 
  EndIf 
  temp3=temp3+"x1 = "+temp1+Chr(10)
  temp3=temp3+"x2 = "+temp2+Chr(10) 
  temp3=temp3+"y = "+GetGadgetText(27)
  SetGadgetText(28,temp3) 
Return 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -