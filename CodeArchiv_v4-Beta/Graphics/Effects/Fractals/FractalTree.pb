; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2523&highlight=
; Author: Rob (updated for PB4.00 by blbltheworm)
; Date: 10. October 2003
; OS: Windows
; Demo: Yes

; Wer schon immer mal Bäume bauen wollte, kann sich an dieser kleinen Fraktalbaum-Procedure austoben. 
; 
; Die Parameter: 
; startx = X-Koordinate des Stamms 
; starty = Y-Koordinate des Stamms 
; startwinkel = Winkel des gesamten Baumes (270=aufrecht) 
; groesse = Groesse des Stamms (und größe des gesamten Baumes, die sich daraus ergibt) 
; winkel_offset = Winkel zwischen zwei Ästen. 
; schritte = Die Ast-Ebenen. 
; aeste = Anzahl der Startäste 
; astratio = Wert, mit dem die Länge der Äste zu- oder abnimmt 
; color = farbe 

;- Procedure
; Procedure fraktalbaum (startx, starty, startwinkel, groesse, winkel_offset, schritte, aeste, astratio.f, color) 
;   If schritte > 0 
;     x2 = startx + groesse * Cos (0.0174 * startwinkel) 
;     y2 = starty + groesse * Sin (0.0174 * startwinkel) 
;     For i = 0  To schritte 
;       LineXY (startx , starty, x2 , y2, color) 
;     Next 
;     delang.f = winkel_offset / (aeste-1) 
;     ang.f = startwinkel - winkel_offset / 2 - delang 
;     For  i = 1  To aeste 
;       ang + delang 
;       fraktalbaum(x2, y2, ang , groesse * astratio, winkel_offset , schritte-1, aeste, astratio,color) 
;     Next 
;   EndIf 
; EndProcedure 
; 
; 
; Natürlich ausbaufähig. Man könnte die Stammdicke an die Ebene anpassen, am Ende ein paar Blätter malen u.s.w. Viel Spaß ^_^ 
; 
; Ein Beispiel dazu: 
 

;- Example: 
; Fraktalbaum 
; Kleine Demo für die Fraktalbaum-Procedure 
; Robert Gerlach 10.2003 

Procedure fraktalbaum (startx, starty, startwinkel, groesse, winkel_offset, schritte, aeste, astratio.f, color) 
  If schritte > 0 
    x2 = startx + groesse * Cos (0.0174 * startwinkel) 
    y2 = starty + groesse * Sin (0.0174 * startwinkel) 
    For i = 0  To schritte 
      LineXY (startx , starty, x2 , y2, color) 
    Next 
    delang.f = winkel_offset / (aeste-1) 
    ang.f = startwinkel - winkel_offset / 2 - delang 
    For  i = 1  To aeste 
      ang + delang 
      fraktalbaum(x2, y2, ang , groesse * astratio, winkel_offset , schritte-1, aeste, astratio,color) 
    Next 
  EndIf 
EndProcedure 



InitSprite() 

groesse = 40 
astwinkel = 50 
ebenen = 6 
aeste = 2 
astratio.f = 0.9 


win = OpenWindow(0,0,0,400,260,"Fraktalbaum",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) 
CreateGadgetList(win) 

Frame3DGadget(0,302,0,98,40,"Größe") 
TrackBarGadget(10,307,15,88,20,0,100) 
SetGadgetState(10,groesse) 

Frame3DGadget(1,302,50,98,40,"Astwinkel") 
TrackBarGadget(11,307,65,88,20,0,180) 
SetGadgetState(11,astwinkel)  

Frame3DGadget(2,302,100,98,40,"Ebenen") 
TrackBarGadget(12,307,115,88,20,1,15) 
SetGadgetState(12,ebenen)  

Frame3DGadget(3,302,150,98,40,"Äste") 
TrackBarGadget(13,307,165,88,20,1,10) 
SetGadgetState(13,aeste)  

Frame3DGadget(4,302,200,98,40,"Astratio") 
TrackBarGadget(14,307,215,88,20,50,100) 
SetGadgetState(14,astratio*100)  

CreateImage(0,300,240) 
ImageGadget(20,0,0,300,300,ImageID(0)) 


CreateStatusBar(0,win) 
AddStatusBarField(80) : StatusBarText(0,0,"Größe: " + Str(groesse)) 
AddStatusBarField(80) : StatusBarText(0,1,"Astwinkel: " + Str(astwinkel)+"°") 
AddStatusBarField(80) : StatusBarText(0,2,"Ebenen: " + Str(ebenen)) 
AddStatusBarField(80) : StatusBarText(0,3,"Äste: " + Str(aeste)) 
AddStatusBarField(80) : StatusBarText(0,4,"Astratio: " + StrF(astratio,2)) 

StartDrawing(ImageOutput(0)) 
Box(0,0,300,300,RGB(255,255,255)) 
fraktalbaum(150,240,271,groesse,astwinkel,ebenen,aeste,astratio,RGB(0,0,0)) 
StopDrawing() 
SetGadgetState(20,ImageID(0)) 




Repeat 
  eventid = WaitWindowEvent() 
  
  If eventid = #PB_Event_Gadget 
    
    Select EventGadget() 

      Case 10 
        groesse = GetGadgetState(10) 
        StatusBarText(0,0,"Größe: " + Str(groesse)) 
  
      Case 11 
        astwinkel = GetGadgetState(11) 
        StatusBarText(0,1,"Astwinkel: " + Str(astwinkel)+"°") 
      
      Case 12 
        ebenen = GetGadgetState(12) 
        StatusBarText(0,2,"Ebenen: " + Str(ebenen)) 
        
      Case 13 
        aeste = GetGadgetState(13) 
        StatusBarText(0,3,"Äste: " + Str(aeste)) 
        
      Case 14 
        astratio = GetGadgetState(14)/100 
        StatusBarText(0,4,"Astratio: " + StrF(astratio,2)) 
        
      
    EndSelect 
  
    StartDrawing(ImageOutput(0)) 
    Box(0,0,300,300,RGB(255,255,255)) 
    fraktalbaum(150,240,271,groesse,astwinkel,ebenen,aeste,astratio,RGB(0,0,0)) 
    StopDrawing() 
    SetGadgetState(20,ImageID(0)) 
    
  EndIf 
Until eventid = #PB_Event_CloseWindow 


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
