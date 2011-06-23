; http://www.purebasic-lounge.de
; Author: Benubi (desktop-related screen size added by Andre)
; Date: 24. October 2006
; OS: Windows
; Demo: Yes


; MiniConsole
Global NewList MiniConsoleBuffer.s()

; PrintN
Procedure.l MiniConsole_PrintN(Text.s) ; Text + Newline
  Protected Zeile.s,Eol$, count.l, item.l
  Eol$ = #CRLF$ ; zeilen ende bei windows
  count=1+CountString(Text,Eol$)
  LastElement(MiniConsoleBuffer())
  For item = 1 To count Step 1
    zeile = StringField(Text, item, Eol$) ; zeile aus Text
    zeile = RemoveString(zeile,#LF$) ; das line-feed löschen (PB-Bug ? )
    AddElement(MiniConsoleBuffer())
    MiniConsoleBuffer()  = zeile
  Next
  ProcedureReturn
EndProcedure

; Console zeichnen
Procedure.l MiniConsole_Render() ; OutputID: SpriteOutput/ScreenOutput
  Shared MiniConsole_Sprite.l
  Shared MiniConsole_Visible.l
  Shared MiniConsole_Font.l
  Shared MiniConsole_BkColor.l

  Protected fWidth.l,fHeight.l,sHeight.l
  Protected x.l,y.l,total_height.l,letztezeile.l,zeile

  If MiniConsole_Visible
    If StartDrawing(SpriteOutput(MiniConsole_Sprite))

      Box(0,0,SpriteWidth(MiniConsole_Sprite),SpriteHeight(MiniConsole_Sprite),MiniConsole_BkColor) ; Hintergrund löschen
      DrawingFont(FontID(MiniConsole_Font))
      sHeight      = SpriteHeight(MiniConsole_Sprite) ; Höhe von console
      fHeight      = TextHeight("ABCTEST")           ; Höhe von 1x zeile
      ; Unsichtbare Zeilen entfernen
      While fHeight * CountList(MiniConsoleBuffer()) > sHeight
        FirstElement(MiniConsoleBuffer())
        DeleteElement(MiniConsoleBuffer())
      Wend
      x=1
      y=1
      DrawingMode(1)
      FrontColor($8F8F8F)
      letztezeile=CountList(MiniConsoleBuffer())
      ForEach MiniConsoleBuffer()
        zeile=zeile+1
        DrawText(x,y,MiniConsoleBuffer()) ; Zeilenweise malen
        y=y + fHeight ; nächste zeile

        If zeile=letztezeile ; Cursor am ende der Zeile malen, wenn letzte Zeile erreicht ist
          If Date()&1 ; Blink-effekt bei ungeraden Sekunden
            Line(x+TextWidth(MiniConsoleBuffer()),y-2,TextWidth(" "),0)
          EndIf
        EndIf
      Next
      StopDrawing()
      UseBuffer(-1)
      DisplaySprite(MiniConsole_Sprite,0,0)
    EndIf
  EndIf

EndProcedure


; spiele zeugs
Procedure.l MyRenderGame()
  Static Bg.l,dir.l
  If bg<=64 : dir=1 : ElseIf bg>=191 : dir=-1 : EndIf
  bg + dir
  ClearScreen(RGB(bg,bg,bg))

  ; bäume, aliens etc.
  ; RenderWorld()

  MiniConsole_Render()

EndProcedure

; Keyboard-Events
Procedure MyGameLoop()
  Shared GameExit.l
  Shared MiniConsole_Visible.l

  Protected key.s
  Repeat
    If ExamineKeyboard()
      key=KeyboardInkey()
      If KeyboardPushed(#PB_Key_Escape)
        ; exit
        GameExit=#True
      ElseIf KeyboardReleased(#PB_Key_F1)
        ; switch visible / hidden
        MiniConsole_Visible!1
      ElseIf KeyboardReleased(#PB_Key_Back) ; backspace
        ; letztes zeichen entfernen
        Debug "remove"
        MiniConsoleBuffer()=Left(MiniConsoleBuffer(),Len(MiniConsoleBuffer())-1)
      ElseIf KeyboardReleased(#PB_Key_Return)
        ; return taste

        If LastElement(MiniConsoleBuffer()) ; Auf befehle prüfen
          Select LCase(MiniConsoleBuffer())
            Case "help"
              MiniConsole_PrintN(#CRLF$+#CRLF$+"Help"+#CRLF$+"--------"+#CRLF$+"ESC Quit"+#CRLF$+"F1 Show/Hide"+#CRLF$)
            Case "quit"
              GameExit=#True
            Default

          EndSelect
        EndIf
        MiniConsole_PrintN("")
      Else

        LastElement(MiniConsoleBuffer())
        MiniConsoleBuffer()+key ; hinzufügen
      EndIf
    EndIf
    If GameExit=#False
      MyRenderGame()
      FlipBuffers(1)
    EndIf
  Until GameExit<>#False
EndProcedure

Procedure MyInit()
  Shared GameExit.l
  Shared MiniConsole_Sprite.l
  Shared MiniConsole_Visible.l
  Shared MiniConsole_Font.l
  Shared MiniConsole_BkColor.l

  MiniConsole_Visible=#True
  If  InitSprite()=0  :ProcedureReturn 0:EndIf
  If  InitScreen()=0  :ProcedureReturn 0:EndIf
  If  InitKeyboard()=0:ProcedureReturn 0:EndIf
  ExamineDesktops()
  If  OpenScreen(DesktopWidth(0),DesktopHeight(0),DesktopDepth(0),"MiniConsole")=0:ProcedureReturn 0:EndIf

  MiniConsole_Sprite=CreateSprite(-1,800,300)
  If MiniConsole_Sprite=0:CloseScreen():ProcedureReturn 0:EndIf

  MiniConsole_Font     = LoadFont(-1,"FixedSys",9)
  MiniConsole_BkColor  = $802020

  MiniConsole_PrintN("MiniConsole demo (c) benubi 2006")
  MiniConsole_PrintN("--------------------------------")
  MiniConsole_PrintN("F1 - Hide / Show")
  MiniConsole_PrintN("")
  MiniConsole_PrintN("Press ESC to quit")
  MiniConsole_PrintN(#CRLF$)

  ProcedureReturn #True
EndProcedure
If MyInit()
  MyGameLoop()
EndIf

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -