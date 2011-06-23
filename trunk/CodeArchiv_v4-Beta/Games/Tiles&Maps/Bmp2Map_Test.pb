; German forum: http://www.purebasic.fr/german/viewtopic.php?t=2131&highlight=
; Author: Kaeru Gaman (improved + updated for PB 4.00 by Andre)
; Date: 19. February 2005
; OS: Windows
; Demo: Yes

Procedure LoadMap(MapName.s)
  If ReadFile(1,Mapname)
    Global MapWidth  = ReadLong(1)
    Global MapHeight = ReadLong(1)
    Global Dim Map(MapWidth-1,MapHeight-1)
    For t=0 To MapHeight-1
      For n=0 To MapWidth-1
        Map(n,t) = ReadLong(1)
      Next
    Next
    CloseFile(1)
  Else
    Debug "Couldn't open file: "+MapName
  EndIf
EndProcedure

MapName.s = OpenFileRequester("Map zum einlesen auswählen","c:\","Map|*.map|Alle|*.*",0)

If MapName
  LoadMap(MapName)

  For t=0 To MapHeight-1
    For n=0 To MapWidth-1
      Debug Map(n,t)
    Next
  Next

EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -