; German forum: 
; Author: Unknown
; Date: 31. December 2002
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
   TextGadget(3,80,13,30,20,"   x +") 
   StringGadget(4,110,10,30,20,"") 
   StringGadget(5,20,50,120,20,"( x + "+Str(b)+" ) ² + "+Str(c)) 
   StringGadget(6,35,95,90,20,"S ( "+Str(-b)+" ; "+Str(c)+" )") 

  CloseGadgetList() 
EndIf 

Repeat 

eventid.l=WaitWindowEvent() 

If eventid=#PB_Event_Gadget 

  Select EventGadget() 
    Case 2, 4
    Gosub ersteBerechnung 
  EndSelect 

EndIf 

Until eventid=#PB_Event_CloseWindow 

End 

ersteBerechnung: 
;² -> S 
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

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -