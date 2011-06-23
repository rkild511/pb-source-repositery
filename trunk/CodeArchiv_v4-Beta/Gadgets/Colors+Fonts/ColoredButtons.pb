; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=973&highlight=
; Author: L/\NGEN (updated for PB4.00 by blbltheworm)
; Date: 11. May 2003
; OS: Windows
; Demo: Yes

Procedure COLOR_BUTTON(id.l,x.l,y.l,w.l,h.l,color.l,textcolor.l,text.s) 
jezaber: 
box.l = CreateImage(id, w,h) 
StartDrawing(ImageOutput(id)) 
    
        If TextWidth(text) <= w 
            posx.l = w/2 -TextWidth(text) / 2 
        Else 
            w = TextWidth(text) + 20 
            StopDrawing() 
            Goto jezaber 
        EndIf 
        
        posy.l=h/2-TextWidth("Xii")/2 
    
    Box(0, 0,w, h,color) 
    DrawingMode(1) 
    FrontColor(RGB(Red(textcolor),Green(textcolor),Blue(textcolor))) 
    DrawText(posx, posy,text) 
    StopDrawing() 
    ButtonImageGadget(id, x, y, w, h,box) 
EndProcedure 

hWnd = OpenWindow(0, 100, 180, 310, 100, "COLO_BUTTON", #PB_Window_SystemMenu ) 

If CreateGadgetList(WindowID(0)) 
COLOR_BUTTON(0,10,15,50,50, $00FF00,$000000,"Grün!") 
COLOR_BUTTON(1,70,15,50,50, $0000FF,$FFFFFF,"Rot!") 

EndIf 


Repeat 
    EventID = WaitWindowEvent() 
    
    Select EventID 
    Case #WM_CTLCOLOREDIT 
    Debug fuck 
    
  EndSelect 
    Select EventGadget() 
    EndSelect 
        
    
Until EventID = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
