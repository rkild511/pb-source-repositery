; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2564&start=10
; Author: benny (updated for PB 4.00 by Andre)
; Date: 24. October 2003
; OS: Windows
; Demo: No

; Small test of the new Regular Expression UserLib by FloHimself (can be found on www.purearea.net)
; Kleiner Test der neuen Regular Expression Lib von FloHimself
; _heise-news-ticker_
;
; benny!
;
; PS:
; benötigt demnach die Lib von FloHimself [siehe PureArea.net]
; sowie eine bestehende InternetVerbindung voraus (wird nicht getestet)


Global Dim Titel.s(50)
Global Dim Linkh.s (50)


;- Window Constants
;
Enumeration
#Window_0
EndEnumeration

;- Gadget Constants
;
Enumeration
#Gadget_0
#Gadget_1
#Gadget_3
EndEnumeration


Procedure NewsAktualisieren()
  
  *Reg = RegComp ("(<TITLE>|<title>)(.*)(</TITLE>|</title>)")
  *Reg2= RegComp ("(<LINK>|<link>)(.*)(</LINK>|</link>)")
  
  
  If URLDownloadToFile_(0, "http://www.heise.de/newsticker/heise.rdf", "news.rdf", 0, 0)
        
    If (ReadFile(1, "news.rdf"))
      
      counter = 0
      
      While Eof(1)=0
        
        news.s = ReadString(1)
        title.s = Space(100)
        link.s = Space(100)
        
        If (RegExec(*Reg, news.s))
          RegSub(*Reg, "\2", title.s)
          Titel.s(counter) = title.s
          counter = counter + 1
        EndIf
        
        If (RegExec(*Reg2, news.s))
          RegSub(*Reg2, "\2", link.s)
          Linkh.s(counter) = link.s
        EndIf
        
      Wend
      
      CloseFile(1)
      
      ClearGadgetItemList(#Gadget_3)
      
      For i=1 To counter
        AddGadgetItem(#Gadget_3, -1, Titel.s(i))
      Next i
      
    Else
      Debug "Couldn't read the news.rdf file!"
    EndIf
  
  Else
    Debug "Couldn't download the file: http://www.heise.de/newsticker/heise.rdf"
  EndIf  
  
EndProcedure

Procedure NewsAnzeigen(news.l)
  
  news.l = news.l + 2
  
  If news.l > 1
    RunProgram(linkh.s(news.l))
  EndIf
  
EndProcedure

Procedure Open_Window_0()
  If OpenWindow(#Window_0, 215, 0, 480, 400, "Heise News Ticker by benny! - weltenkonstrukteur.de", #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar)
    If CreateGadgetList(WindowID(#Window_0))
      ButtonGadget(#Gadget_0, 15, 15, 225, 30, "Newsfeed Aktualisieren")
      ButtonGadget(#Gadget_1, 255, 15, 210, 30, "News Anzeigen")
      ListViewGadget(#Gadget_3, 15, 60, 450, 315)
      
    EndIf
  EndIf
EndProcedure


Open_Window_0()

Repeat
  
  Event = WaitWindowEvent()
  
  If Event = #PB_Event_Gadget
    
    ;Debug "WindowID: " + Str(EventWindowID())
    
    GadgetID = EventGadget()
    
    If GadgetID = #Gadget_0
      NewsAktualisieren()
      
    ElseIf GadgetID = #Gadget_1
      NewsAnzeigen(GetGadgetState(#Gadget_3))
      
    EndIf
    
  EndIf
  
Until Event = #PB_Event_CloseWindow

End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
