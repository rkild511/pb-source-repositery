; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2940&highlight=
; Author: realgarfield (updated for PB4.00 by blbltheworm)
; Date: 02. December 2003
; OS: Windows
; Demo: Yes

Global a.l,auswahl.l 


Procedure drucken() 
  font.l=LoadFont(0,"Arial",250) 
  

  For a=1 To auswahl 

    If DefaultPrinter()    ;Standard Drucker wird definiert 
       StartPrinting("Drucken") ;bezeichnung für Druckauftrag 
       StartDrawing(PrinterOutput()) 
       DrawingMode(1) 
       DrawingFont(font) 
       DrawText(1800,100,"Drucken") 
       DrawingFont(font) 
       DrawText(2000,500,"nach") 
       DrawingFont(font) 
       DrawText(1800,800,"Auswahl") 
       StopDrawing() 
       StopPrinting() 
    EndIf 
  Next a  
EndProcedure  
auswahl=1 
Quit.l=0 

  OpenWindow(0,0,0,200,140,"Drucken",#PB_Window_ScreenCentered) 
  CreateGadgetList(WindowID(0)) 
  If LoadFont(2,"Arial",15) ; geladenen Arial  Zeichensatz grösse 100 Fettschrift 
    SetGadgetFont(#PB_Default,FontID(2))   ; als neuen Standard festlegen 
  EndIf 
  TextGadget(60,0,10,200,20,"Anzahl Exemplare",#PB_Text_Center) 
  If LoadFont(3,"Arial",10) ; geladenen Arial  Zeichensatz grösse 100 Fettschrift 
    SetGadgetFont(#PB_Default,FontID(3))   ; als neuen Standard festlegen 
  EndIf 
  ButtonGadget(1,60,50,20,20,"+") 
  ButtonGadget(2,60,80,20,20,"-") 
  ButtonGadget(3,20,110,70,20,"Drucken") 
  ButtonGadget(4,100,110,70,20,"Abbrechen") 
  TextGadget(5,90,60,30,25,"",#PB_Text_Center|#PB_Text_Border) 
  SetGadgetText(5,Str(auswahl)) 
  Repeat 
    Select WindowEvent() 
      Case #PB_Event_Gadget 
        Select EventGadget() 
          Case 1 
            DisableGadget(2,0) 
            auswahl=auswahl+1 
            SetGadgetText(5,Str(auswahl)) 
          Case 2 
            auswahl=auswahl-1 
            SetGadgetText(5,Str(auswahl)) 
            If auswahl=1 
              DisableGadget(2,1) 
            EndIf 
          Case 3 
            GetGadgetText(5) 
              drucken() 
            auswahl=1 
            quit=1 
          Case 4 
            auswahl=1 
            quit=1 
        EndSelect 
    EndSelect 
      
  Until quit=1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
