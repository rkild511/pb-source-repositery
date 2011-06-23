; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=2309&highlight=
; Author: Franky (updated for PB3.92+ by Lars, updated for PB4.00 by blbltheworm)
; Date: 18. September 2003
; OS: Windows
; Demo: No

Global quit.l
Global memory.l
Global code.s
memory=1000
quit=0

Global Dim digi.l(7)

For a=0 To 7
  digi(a)=Pow(2,a)
Next

Procedure FreeRAM()
  
  ;Eine leere Struktur erstellen
  Info.MEMORYSTATUS
  
  ;Die Größe der Struktur ermitteln und in ihr selbst speichern
  Info\dwLength = SizeOf(MEMORYSTATUS)
  
  ;Vom System die Speicherinfos hohlen
  GlobalMemoryStatus_(@Info)
  
  ;Zuweisen der Daten
  Total.f = Info\dwTotalPhys
  Free.l = Info\dwAvailPhys
  
  ;Rückgabe der Ergebnisse, prozentual
  ProcedureReturn  Free
EndProcedure



Procedure Digitalcode(Text.s)
  number.l=0
  For a=1 To 8
    If Mid(Text,a,1)<>"0" And Mid(Text,a,1)<>"1"
      momtext.s="0"
    Else
      momtext=Mid(Text,a,1)
    EndIf
    If momtext="1"
      number=number+digi(8-a)
    EndIf
  Next
  
  
  ProcedureReturn number.l
EndProcedure





Procedure Digitalencode(zahl.l)
  code=""
  For a=1 To 8
    If zahl>0
      float.f=(zahl/digi(8-a))
      If Round(float,0)<1
        code=code+"0"
      Else
        code=code+"1"
        zahl=zahl-digi(8-a)
      EndIf
    Else
      code=code+"0"
    EndIf
    
  Next
EndProcedure



Procedure compile()
  Text.s=""
  string.s=GetGadgetText(1)
  string=ReplaceString(string,Chr(13)+Chr(10),"")
  lang=Round(Len(string)/8,0)-1
  memory=AllocateMemory(lang)
  For a=0 To lang
    momtext.s=Mid(string,8*a+1,8)
    number.l=Digitalcode(momtext)
    mommem=memory+a
    PokeB(mommem,number)
  Next
EndProcedure





Procedure Message()
  Text.s=""
  string.s=GetGadgetText(1)
  string=ReplaceString(string,Chr(13)+Chr(10),"")
  lang=Round(Len(string)/8,0)-1
  For a=0 To lang
    momtext.s=Mid(string,8*a+1,8)
    Text=Text+Chr(Digitalcode(momtext))
  Next
  
  MessageRequester("Message",Text,0)
EndProcedure




Procedure Numbercompile()
  Text.s=""
  string.s=GetGadgetText(1)
  string=ReplaceString(string,Chr(13)+Chr(10),"")
  lang=Round(Len(string)/8,0)-1
  For a=0 To lang
    momtext.s=Mid(string,8*a+1,8)
    Text=Text+Str(Digitalcode(momtext))+","
  Next
  
  MessageRequester("Message",Text,0)
EndProcedure


Procedure open()
  Name.s=OpenFileRequester("Datei entdigitalisieren","","All Files|*.*",0)
  If Name<>""
    max.l=Round(FreeRAM()/16,0)
    If FileSize(Name)<max
      Text.s=""
      If OpenFile(1,Name)
        While Loc(1)< Lof(1)
          nummer.l=ReadByte(1)
          Digitalencode(nummer)
          Text=Text+code
        Wend
        CloseFile(1)
        SetGadgetText(1,Text)
      EndIf
    Else
      MessageRequester("Error","Der Arbeitsspeicher reicht nicht",0)
    EndIf
  EndIf
EndProcedure



Procedure save()
  Name.s=SaveFileRequester("Speichern;Bitte Dateiendung mit angeben","","All Files|*.*",0)
  If Name<>""
    CreateFile(1,Name)
    Text.s=GetGadgetText(1)
    Text=ReplaceString(Text,Chr(13)+Chr(10),"")
    lang=Round(Len(Text)/8,0)-1
    For a=0 To lang
      momtext.s=Mid(Text,a*8+1,8)
      WriteByte(1,Digitalcode(momtext))
    Next
    CloseFile(1)
  EndIf
EndProcedure




If OpenWindow(1,100,100,200,300,"Bitprogrammer",#PB_Window_SystemMenu|#PB_Window_MinimizeGadget)
  CreateMenu(1,WindowID(1))
  MenuTitle("Datei")
  MenuItem(1,"Laden")
  MenuItem(2,"Speichern")
  MenuItem(3,"Beenden")
  MenuTitle("Compile")
  MenuItem(4,"Compile")
  MenuItem(5,"Select Memory")
  MenuItem(6,"Messagedebug")
  MenuItem(7,"Numberdebug")
  MenuItem(8,"Read Buffer")
  CreateGadgetList(WindowID(1))
  StringGadget(1,75,0,75,270,"", #ESB_DISABLE_LEFT | #ESB_DISABLE_RIGHT |#ES_MULTILINE|#PB_String_Numeric|#WS_VSCROLL)
  
  
  Repeat
    
    event=WaitWindowEvent()
    
    
    If event=#PB_Event_Menu
      Select EventMenu()
      Case 1  : open()
      Case 2  : save()
      Case 3  : quit=1
      Case 4  : compile()
      Case 6  : Message()
      Case 7  : Numbercompile()
      EndSelect
      
    EndIf
    
    If event=#WM_CLOSE
      quit=1
    EndIf
  Until quit=1
  
EndIf
End

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = --
