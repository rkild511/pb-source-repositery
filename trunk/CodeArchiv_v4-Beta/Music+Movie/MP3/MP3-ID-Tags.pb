; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1350&highlight=
; Author: Momo (corrected by J-The-Grey, updated for PB4.00 by blbltheworm)
; Date: 14. June 2003
; OS: Windows
; Demo: Yes

OpenWindow(1,12,12,300,250,"ID3 Infos:",#PB_Window_ScreenCentered|#PB_Window_SystemMenu) 

AboutText.s="Programmer: Moritz Wagner" + Chr(13) + Chr(13) + Chr(169) + " 2003 by Moritz Wagner"+Chr(13)+"Programmed in Pure Basic" + Chr(13) + Chr(13) + "Contact: Wagnergitti@vr-web.de" 

File.s=OpenFileRequester("Bitte Wählen sie eine MP3 Datei aus die ID3 V1 Tags enthält","","MP3 Tracks (*.MP3)|*.mp3;Alle (*.*)|*.*",0) 
If File<>"" 
     If ReadFile(0,File) 
       MemPointer =  AllocateMemory(128) ; 128 byte reservieren
       If  MemPointer
           FileSeek(0,Lof(0)-128) 
           ReadData(0,MemPointer, 128) ; die letzten 128 byte der Datei auslesen 
          ; Debug mempointer 
           CloseFile(0) 
           header$    = PeekS(MemPointer, 3) 

           If header$ = "TAG"                               ;  3 Zeichen 
              songtitle$ = Trim(PeekS(MemPointer +   3,30)) ; 30 Zeichen 
              artist$    = Trim(PeekS(MemPointer +  33,30)) ; 30 Zeichen 
              album$     = Trim(PeekS(MemPointer +  63,30)) ; 30 Zeichen 
              year$      = Trim(PeekS(MemPointer +  93, 4)) ;  4 Zeichen 
              comment$   = Trim(PeekS(MemPointer +  97,30)) ; 30 Zeichen 
              genre      = PeekB(MemPointer + 127)          ;  1 Zeichen 
              CreateGadgetList(WindowID(1)) 
              TextGadget(7,10,10,80,20,"Titel:") 
              TextGadget(8,10,40,80,20,"Künstler: ") 
              TextGadget(9,10,70,80,20,"Album: ") 
              TextGadget(10,10,100,80,20,"Jahr: ") 
              TextGadget(11,10,130,80,20,"Kommentar: ") 
              TextGadget(12,10,160,80,20,"Genre: ") 
              StringGadget(0,80,10,200,20,songtitle$) 
              StringGadget(1,80,40,200,20,artist$) 
              StringGadget(2,80,70,200,20,album$) 
              StringGadget(3,80,100,200,20,year$) 
              StringGadget(4,80,130,200,20,comment$) 
              StringGadget(5,80,160,200,20,Str(genre)) 
              ButtonGadget(6,20,190,70,30,"About") 
              ButtonGadget(13,120,190,70,30,"OK") 
           EndIf 
        EndIf 
     EndIf 
Else 
   MessageRequester("Error","Bitte Wählen Sie eine MP3 Datei aus!",0) 
EndIf 

Repeat 
  eventid = WaitWindowEvent() 
  If eventid = #PB_Event_CloseWindow 
    Ende=1 
  EndIf 
  If eventid = #PB_Event_Gadget 
    If EventGadget()=6 
      MessageRequester("About",AboutText,OK) 
    EndIf 
    If EventGadget()=13 
      songtitle.s=GetGadgetText(0) 
      artist.s=GetGadgetText(1) 
      album.s=GetGadgetText(2) 
      year.s=GetGadgetText(3) 
      comment.s=GetGadgetText(4) 
      genre=Val(GetGadgetText(5)) 
      
      
      If OpenFile(0,File)
          MemPointer = AllocateMemory(128)
          If MemPointer
             FileSeek(0,Lof(0)-128) 
             PokeS(MemPointer,header$, 3) 
                                        ;  3 Zeichen 
               PokeS(MemPointer+3,songtitle.s,30) ; 30 Zeichen 
               PokeS(MemPointer+33,artist.s,30) ; 30 Zeichen 
               PokeS(MemPointer+63,album.s,30) ; 30 Zeichen 
               PokeS(MemPointer+93,year.s,4) ;  4 Zeichen 
               PokeS(MemPointer+97,comment.s,30) ; 30 Zeichen 
               PokeB(MemPointer + 127,genre)          ;  1 Zeichen 
                
            WriteData(0,MemPointer, 128) 
            CloseFile(0) 
            ;     Debug songtitle 

         EndIf 
      EndIf 
    EndIf 
  EndIf 
Until Ende=1 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
