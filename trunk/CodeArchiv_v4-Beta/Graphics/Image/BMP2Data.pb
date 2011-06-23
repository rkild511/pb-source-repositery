; English forum: http://www.purebasic.fr/english/viewtopic.php?t=18730
; Author: dobro (updated for PB 4.00 by Andre)
; Date: 18. January 2006
; OS: Windows
; Demo: Yes


; Create a new code with a DataSection of a loaded BMP images
; Erstellt einen neuen Code mit einer DataSection eines geladenen BMP Bilds

If OpenWindow (1, 0, 0, 200, 50, "", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)

  NomFichier$ = OpenFileRequester ( "dobro_datagenerator" , "c:\" , "Fichiers image|*.bmp" , 0 )
  If NomFichier$ = ""
    End
  EndIf

  If LoadImage (0, NomFichier$)
    Hauteur = ImageHeight (0)
    Largeur = ImageWidth (0)
    num= CreateFile ( #PB_Any , "data.pb" ) : ; ceci ecrit le fichier pb (txt) pour etre charge dans l'editeur !!
    WriteStringN (num, "; codé Par Dobro img to data" ): ; ecrit la premiere ligne de code
    WriteStringN (num, "Declare WindowCallback(WindowID,message,wParam,lParam)" )
    WriteStringN (num, "")
    WriteStringN (num, "largeur=" + Str (Largeur)): ; ecrit la variable
    WriteStringN (num, "hauteur=" + Str (Hauteur))
    WriteStringN (num, "CreateImage(1, Largeur, Hauteur)" )

    WriteStringN (num, "For i = 0 To Largeur -1" )
    WriteStringN (num, "  For j = 0 To Hauteur -1 " )
    WriteStringN (num, "    Read a.l " )
    WriteStringN (num, "    If StartDrawing(ImageOutput(1))" )
    WriteStringN (num, "      Plot(i,j,a.l) " )
    WriteStringN (num, "      StopDrawing() " )
    WriteStringN (num, "    EndIf" )
    WriteStringN (num, "  Next j" )
    WriteStringN (num, "Next i" )
    WriteStringN (num, "")

    WriteStringN (num, "titre$=" + Chr ($22)+NomFichier$+ Chr ($22))
    ; dessous: genere le code qui permet de relire les datas !!
    ; ouaaa du code qui s'autoecrit !!!
    WriteStringN (num, "If OpenWindow (1, 0, 0, Largeur, Hauteur, titre$, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget)" )
    WriteStringN (num, "  SetWindowCallback(@WindowCallback()) " )
    WriteStringN (num, "  If StartDrawing(WindowOutput(1))" )
    WriteStringN (num, "    DrawImage(ImageID(1), 0, 0) " )
    WriteStringN (num, "    StopDrawing()" )
    WriteStringN (num, "  EndIf" )
    WriteStringN (num, "  Repeat" )
    WriteStringN (num, "  Until WaitWindowEvent()= #PB_Event_CloseWindow")
    WriteStringN (num, "EndIf " )
    WriteStringN (num, "End " )
    WriteStringN (num, "")

    WriteStringN (num, "Procedure WindowCallback(WindowID,message,wParam,lParam)" )
    WriteStringN (num, "  res= #PB_ProcessPureBasicEvents")
    WriteStringN (num, "  Select message ")
    WriteStringN (num, "    Case #WM_PAINT")
    WriteStringN (num, "      StartDrawing(WindowOutput(1))" )
    WriteStringN (num, "        DrawImage(ImageID(1), 0, 0) " )
    WriteStringN (num, "      StopDrawing() " )
    WriteStringN (num, "      ProcedureReturn #True " )
    WriteStringN (num, "  EndSelect" )
    WriteStringN (num, "  ProcedureReturn res" )
    WriteStringN (num, "EndProcedure " )
    WriteStringN (num, "")
    ;************************

    Resultat = StartDrawing ( WindowOutput (1))
    DrawText (0, 0, "encodage en cours " + Chr (10)+ " attendre la fermeture de cette fenetre" )
    StopDrawing ()

    WriteStringN (num, "DataSection" ) : ; commence la section des data

    For i =0 To Largeur -1
      ligne.s= "  data.l " ; insere la fonction data.l avant les valeurs
      For j = 0 To Hauteur-1
        StartDrawing ( ImageOutput (0) )
        ligne.s=ligne.s+ Str ( Point (i, j))+ "," : ; met des virgules entre les datas
        StopDrawing ()
      Next j
      ligne.s= Left (ligne.s, Len (ligne.s)-1) : ; retire la derniere virgule de la ligne
      WriteStringN (num, ligne.s): ; ecrit une ligne entiere de data
    Next i
    WriteStringN (num, " " ): ; saute une ligne vide
    WriteStringN (num, "EndDataSection" ) : ;ecrit la fin de section data
    CloseFile (num)
  EndIf
  CloseWindow (1)

EndIf

End

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP