; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3061&highlight=
; Author: isidoro (updated for PB 4.00 by Andre)
; Date: 09. December 2003
; OS: Windows
; Demo: No

;################################################ 
;#                                               # 
;#    MoveMessage Version 1,28497009-12Q7         # 
;#      Copyright  Auch ohne                       # 
;#                       wenn und aber              # 
;#  Ein Code kommt niemals allein.... Isidor         # 
;#  Bild unter: moxshop.com/Software/MoveMessage.zip  # 
;####################################################### 
#InfoWin=0 ; Konstantan 


Procedure.l ZeilenUmbruch(text_.s,anzahl_.l) 
;########################################### 
  Global Dim Zeilen$(100): ZeilenStart=0: lenght=Len(text_) 
  Repeat 
    Repeat 
      LastPos=pos: pos=FindString(text_," ", pos+1) 
    Until pos > anzahl_+(ZeilenNr*anzahl_) Or pos=0 
    If pos=0 
      Zeilen$(ZeilenNr)=Mid(text_,ZeilenStart,lenght+1-ZeilenStart) 
      ZeilenNr+1 
      Break 
    EndIf 
    Zeilen$(ZeilenNr)=Mid(text_,ZeilenStart,LastPos-ZeilenStart) 
    ZeilenNr+1: ZeilenStart=LastPos+1 
  ForEver 
  ProcedureReturn ZeilenNr 
EndProcedure 
  
Procedure MoveMessage(Background.l,text_.s,ZeilenBreite_.l,Zeit.l) 
;################################################# 
Pause.l=Zeit*1000: Schritt=1: Speed=5  
z=33 ; Abfrage, ob Taskleiste auf oder nicht einfügen 

screenW=GetSystemMetrics_(#SM_CXSCREEN) 
screenH=GetSystemMetrics_(#SM_CYSCREEN) 
InfoWinX=0 
InfoWinY=screenH 

  If Background 
    InfoWinW=ImageWidth(1) 
    InfoWinH=ImageHeight(1) 
     If text_ 
       ZeilenBreite_=(InfoWinW-20)/8 
       ZeilenNr= ZeilenUmbruch(text_.s,ZeilenBreite_.l) 
     EndIf 
    
  Else 
    ZeilenNr= ZeilenUmbruch(text_.s,ZeilenBreite_.l) 
    InfoWinW= (ZeilenBreite_*8)+20 
    InfoWinH= (ZeilenNr*15)+20 
    Background= CreateImage(1,InfoWinW,InfoWinH) 
    If Background 
      If StartDrawing(ImageOutput(1)) 
        Box(3, 3, InfoWinW-6,InfoWinH-6, RGB($51,$AA,$AE)) 
        StopDrawing() 
      EndIf  
    EndIf    
  EndIf 

  If text_ 
    If Background 
      If StartDrawing(ImageOutput(1)) 
        DrawingMode(1) 
        FrontColor(RGB($FF,$FF,$00)) 
        For i= 0 To ZeilenNr 
          DrawText(10, 10+(i*15), Zeilen$(i)) 
        Next 
        StopDrawing() 
      EndIf  
    EndIf    
  EndIf  

  WinX=screenW-InfoWinW-10 
  WinY=screenH 

  hwnd=OpenWindow(#InfoWin, InfoWinX, InfoWinY, InfoWinW, InfoWinH, "MoveMessage", #WS_POPUP) 
  If hwnd 
    If Background : SetWinBackgroundImage(hwnd,Background): EndIf 
    SetForegroundWindow_(hwnd) 
    For i=screenH To screenH+InfoWinH+z 
      If i>screenH+InfoWinH : Speed+1: EndIf  ; rumbremsen 
      WinY-Schritt: ResizeWindow(#InfoWin, WinX, WinY, #PB_Ignore, #PB_Ignore) : Delay(Speed) 
    Next  
    Delay(Pause): Speed=3 
    For i=screenH To screenH+InfoWinH+z 
      WinY+Schritt : ResizeWindow(#InfoWin, WinX, WinY, #PB_Ignore, #PB_Ignore) 
      Delay(Speed) 
    Next  
  EndIf 
EndProcedure 

;########################################################################### 
Message$="Eine Untersuchung des Konfliktverhaltens anderer Arten, insbesondere " 
Message$+"der Wirbeltiere, zeigt, dass die beiden Beteiligten kämpfen und der " 
Message$+"Schwächere schließlich die Flucht ergreift. Sowohl der Kampf als auch " 
Message$+"die Flucht sind für Tiere wirksame Mittel im Umgang miteinander. " 
Message$+"Diese Formen der Konfliktbeseitigung scheinen bei niederen Tierarten " 
Message$+"fast automatische, vorprogrammierte Reaktionen mit einem hohen " 
Message$+"Überlebenswert zu sein. auch wir Menschen kämpfen miteinander und " 
Message$+"flüchten voreinander, manchmal gezwungen, manchmal aus freiem Willen " 
Message$+"- gelegentlich tun wir es offen, aber viel häufiger verbergen wir " 
Message$+"unsere Reaktionen." 

SolangeSollDerUserDasLesen=5 
SoVieleZeichenSollenAuftauchen=50 

MoveMessage(LoadImage(1,"..\..\Graphics\Gfx\PB.bmp"),"",30,SolangeSollDerUserDasLesen) 
MoveMessage(LoadImage(1,"..\..\Graphics\Gfx\PB.bmp"),"Hier kritzle ich rum, sieht man ja , oder ??",30,5) 
MoveMessage(0,Message$,SoVieleZeichenSollenAuftauchen,25) 
MoveMessage(HierOhneDasBild,"So ginge es natürlich auch... :-)",15,2) 
End
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; DisableDebugger
