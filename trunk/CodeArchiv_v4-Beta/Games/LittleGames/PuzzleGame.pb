; English forum: http://www.purebasic.fr/english/viewtopic.php?t=7742
; Author: sec  (updated for PB4.00 by blbltheworm)
; Date: 03. October 2003
; OS: Windows
; Demo: Yes


; Little puzzle game. To compile you need PureBasic v3.72 (or older)
;fill Const auto 
   #idwindow = 1 
   #idnew = 2 
   #idexit = 4 
   #idabout = 8 
   #idmenu = 16 
   #idredo = 32 
   #idundo = 64 
   #idframe = 128 
;VAR 
watr = #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered|#PB_Window_Invisible 
Global Dim idbutton.l(3,3) 
Global Dim gridmark.l(3,3) 

;PROCEDURES 
Procedure newpuzzle() 
For i = 0 To 3 
  For j = 0 To 3 
    gridmark(i,j) = i*4+j+1 
    HideGadget(idbutton(i,j),#False) 
  Next 
Next 

i.l=3 
j.l=3 
While i >=1    
   While j >=1 
     ui = Random(i-1) 
     uj = Random(j-1) 
     k = gridmark(i,j)      
     gridmark(i,j) = gridmark(ui,uj) 
     gridmark(ui,uj) = k 
     j  = j - 1      
   Wend 
   i = i - 1 
Wend 

For i=0 To 3 
  For j=0 To 3 
     If gridmark(i,j) = 16 
       m = i 
       n = j 
     EndIf 
    SetGadgetText(idbutton(i,j),Str(gridmark(i,j))) 
  Next 
Next        
        
gridmark(m,n) = 0 
HideGadget(idbutton(m,n),#True) 
EndProcedure 
;;; 
Procedure.l checkpuzzled() 
Global Dim check(4*4) 
For i = 0 To 3 
  For j= 0 To 3 
     check(4*i+j) = gridmark(i,j) 
  Next 
Next 
For i = 0 To 4*4-3 
If check(i) > check(i+1) 
   ProcedureReturn 0 
EndIf 
Next 
ProcedureReturn 1 
EndProcedure 
;;; 
Procedure About() 
   MessageRequester("About","For 'learn' typing Redo Ctrl+Y :)" + Chr(13)+Chr(10)+"Learner: sec",#MB_OK) 
EndProcedure 
;ENDPROCEDURES 

;MAIN PROGRAM 
If OpenWindow(idwindow,0,0,300,350,"Puzzle",watr) And CreateGadgetList(WindowID(idwindow)) And CreateMenu(#idmenu,WindowID(idwindow)) 
   Frame3DGadget(#idframe,0,0,300,328,"") 
   MenuTitle("&File") 
      MenuItem(#idnew,"New Puzzle" + Chr(9) + "F2") 
      MenuBar() 
      MenuItem(#idexit,"Exit" + Chr(9) + "Alt+X") 
   MenuTitle("&Un/Redo") 
      MenuItem(#idundo,"Undo" + Chr(9) + "Ctrl+Z") 
      MenuItem(#idredo,"Redo" + Chr(9) + "Ctrl+Y")      
   MenuTitle("&Help") 
      MenuItem(#idabout,"About") 
;some button      
   For i = 0 To 3 
      For j = 0 To 3 
         idbutton(i,j) = i*4+j+8 
;         gridmark(i,j) = i*4+j+1 
         ButtonGadget(idbutton(i,j),j*(75),i*(80)+6,75,80,"");Str(gridmark(i,j))) 
      Next j 
   Next i 
;   gridmark(3,3) = 0 
;   HideGadget(idbutton(3,3),#TRUE) 
   newpuzzle() 
   HideWindow(idwindow,#FALSE) 
   Repeat 
      wmevent = WaitWindowEvent() 
      Select wmevent 
         Case #PB_Event_CloseWindow 
            quit = 1 
         Case #PB_Event_Menu 
            Select EventMenu() 
               Case #idnew 
                  newpuzzle() 
               Case #idexit 
                  quit = 1 
               Case #idundo                  
               Case #idredo 
               Case #idabout 
                  About()                  
            EndSelect      
         Case #PB_Event_Gadget 
;            If EventType() = #PB_EventType_LeftClick 
            ev = EventGadget()    
            bi = -1 
            bj = -1 
            For i = 0 To 3 
               For j = 0 To 3 
                  If idbutton(i,j) = ev 
                     bi = i 
                     bj = j 
                     i = 3 
                     Goto nisse 
                  EndIf 
               Next j 
            Next i                        
            nisse: 
            If (bi > -1) And (bj > -1) 
               ai = -1 
               aj = -1 
               If (bi > 0) And (gridmark(bi-1,bj) = 0) 
                    ai = bi - 1 
                    aj = bj 
                 ElseIf (bi<3) And (gridmark(bi+1,bj) = 0) 
                    ai = bi + 1 
                    aj = bj 
                 ElseIf (bj>0) And (gridmark(bi,bj-1) = 0) 
                    ai = bi 
                    aj = bj-1 
                 ElseIf (bj<3) And (gridmark(bi,bj+1) =0) 
                    ai = bi 
                    aj = bj+1                
               EndIf 
               If (ai > -1) And (aj > -1) 
                  gridmark(ai,aj) = gridmark(bi,bj) 
                  gridmark(bi,bj) = 0 
                  HideGadget(idbutton(bi,bj),#TRUE) 
                  HideGadget(idbutton(ai,aj),#FALSE) 
                  SetGadgetText(idbutton(ai,aj),Str(gridmark(ai,aj))) 
               EndIf                
            EndIf 
            If checkpuzzled() = 1 
               MessageRequester("Finish!","Well done.",#MB_OK) 
               newpuzzle() 
            EndIf            
;            EndIf 
      EndSelect 
   Until quit = 1 
EndIf 
;MessageRequester("Goodbye!","See you later",#MB_OK) 
End 

; ExecutableFormat=Windows
; FirstLine=1
; EnableXP
; EOF

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
