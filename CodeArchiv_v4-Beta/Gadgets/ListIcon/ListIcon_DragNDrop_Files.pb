; French forum: http://www.serveurperso.com/~cederavic/forum/viewtopic.php?t=239
; Author: Le Soldat Inconnu (updated for PB 4.00 by Andre)
; Date: 29. August 2003
; OS: Windows
; Demo: No


; Drag'n'Drop into a ListIcon

Procedure.l Triage(Liste.l, Colonne.l, File.s) 
  ; Cette procedure permet de connaître la position à laquelle ajouté un élément dans une liste 
  ; Elle trie les éléments de manière à placer les fichiers comme si il était dans un arbre 
  ; Liste : Numéro de la liste 
  ; Colonne : Colonne qui sert de référence 
  ; File : nom du fichier à ajouté et que l'on souhaite placé correctement dans la liste 
  
  File = "#\" + LCase(File) 
  Path.s = GetPathPart(Left(File, Len(File) - 1)) 
  Debug "Path = " + path 
  ExistPath.s = "" 
  Index = 1 
  Depart = 0 
  NbElement = CountGadgetItems(Liste) - 1 
  Fin = NbElement 
  Debug depart 
  Debug fin 
  
  ; La première partie du code consiste à connaitre la partie du nom du fichier qui existe déjà 
  ; dans la liste. puis de connaitre la plage dans laquelle cette partie de fichier est présente (par exemple du 2 au 5ième éléments de la liste) 

  Repeat 
    Partie1.s = StringField(Path, Index, "\") 
    Debug "Partie1 = " + partie1 
    If Partie1 <> "" 
      Test_Ok = 0 
      For n = Depart To Fin 
        File2.s = LCase("#\" + GetGadgetItemText(liste, n, Colonne)) 
        Debug "File2 = " + File2 
        Partie2.s = StringField(GetPathPart(File2), Index, "\") 
        Debug "Partie2 = " + partie2 + "   (index="+ Str(index) + ")" 
        If Test_Ok = 0 And Partie1 = Partie2 
          Test_Ok = 1 
          Depart2 = n 
        EndIf 
        If Partie1 = Partie2 
          Fin2 = n 
        EndIf 
      Next 
      Debug "Depart2 = " + Str(Depart2) 
      Debug "Fin2 = " + Str(Fin2) 
      Depart = Depart2 
      Fin = Fin2 
    EndIf 
    ExistPath2.s = ExistPath + Partie1 + "\" 
    If Partie1 <> "" And FindString(LCase("#\" + GetGadgetItemText(liste, Depart, Colonne)), ExistPath2, 1) = 1 
      ExistPath = ExistPath2 
      Index + 1 
    EndIf 
  Until Partie1 = "" Or FindString(LCase("#\" + GetGadgetItemText(liste, Depart, Colonne)), ExistPath2, 1) = 0 
  
  ; On affiche ici les résultats de la première partie de l'algo 
  Debug ">> Depart = " + Str(depart) 
  Debug ">> Fin = " + Str(fin) 
  Debug ">> ExistPath = " + ExistPath 
  
  ; la deuxième partie du code consiste à placé le fichier parmi ceux qui possède un morceau identique 
  ; donc les dossiers en premier et les fichiers après 
  ; la comparaison s'effectue uniquement sur la partie de l'adresse du fichiers ou dossier qui suit la partie déjà existante du fichiers ou dossiers 
  
  Partie1.s = StringField(File, Index, "\") 
  Type1.s = Mid(File, Len(ExistPath + Partie1) + 1, 1) 
  Debug "Index = " + Str(Index) 
  Debug "Partie1 = " + partie1 
  Debug File 
  Debug ExistPath + Partie1 
  Debug "Type1 = '" + type1 + "'" 
  
  Depart = Depart - 1 
  Repeat 
    Depart + 1 
    File2.s = LCase("#\" + GetGadgetItemText(liste, Depart, Colonne)) 
    Partie2.s = StringField(File2, Index, "\") 
    Longueur.l = Len(ExistPath + Partie2) 
    If Longueur < Len(File2) 
      Type2.s = Mid(File2, Longueur + 1, 1) 
    Else 
      Type2.s = Mid(File2, Longueur, 1) 
      If Type2 <> "\" : Type2 = "" : EndIf 
    EndIf 
    Debug "File2 = " + File2 
    Debug "Partie2 = " + Partie2 
    Debug "Type2 = '" + Type2 + "'" 
  Until (Type1 = Type2 And Partie1 <= Partie2) Or (Type1 = "\" And Type2 = "") Or Depart > Fin Or Depart > NbElement 
  
  Debug ">> Depart = " + Str(depart) 
  Debug "--------------------" 
  
  ProcedureReturn Depart 
EndProcedure 





Procedure ListIconGadgetXP(GadgetID.l, x.l, y.l, tx.l, ty.l, colonne.s, largeur.l, options.l) 
  ListIconGadget(GadgetID, x, y, tx, ty, colonne, largeur, options) 
  #LVM_SETEXTENDEDLISTVIEWSTYLE = 4150 : #LVS_EX_SUBITEMIMAGES = 2 
  hImageListS.l = SHGetFileInfo_("c:\", 0, @InfosFile.SHFILEINFO, SizeOf(SHFILEINFO), #SHGFI_SYSICONINDEX | #SHGFI_SMALLICON) 
  ImageList_SetBkColor_(hImageListS, #CLR_NONE) 
  SendMessage_(GadgetID(GadgetID), #LVM_SETIMAGELIST, #LVSIL_SMALL, hImageListS) 
  SendMessage_(GadgetID(GadgetID), #LVM_SETEXTENDEDLISTVIEWSTYLE, #LVS_EX_SUBITEMIMAGES, #LVS_EX_SUBITEMIMAGES) 
EndProcedure 

Procedure AddGadgetItemXP(GadgetID.l, Pos.l, Texte.s, IconPath.s) 
  SHGetFileInfo_(IconPath, 0, @InfosFile.SHFILEINFO, SizeOf(SHFILEINFO), #SHGFI_SYSICONINDEX | #SHGFI_SMALLICON) 
  If Pos = -1 
    Pos = CountGadgetItems(GadgetID) + 1 
  EndIf 
  
;   Structure LVITEM 
;     mask.l 
;     iItem.l 
;     iSubitem.l 
;     state.l 
;     stateMask.l 
;     pszText.l 
;     cchTextMax.l 
;     iImage.l 
;     lParam.l 
;     iIndent.l 
;     iGroupId.l 
;     cColumns.l 
;     puColumns.l 
;   EndStructure 
  
  var.LVITEM 
  Var\mask = #LVIF_IMAGE | #LVIF_TEXT 
  Var\iSubItem = 0 
  Var\iItem = Pos 
  Var\pszText = @Texte 
  Var\iImage = InfosFile\iIcon 
  SendMessage_(GadgetID(GadgetID), #LVM_INSERTITEM, 0, @Var) 
EndProcedure 

Procedure Open_Window() 
  
  If OpenWindow(0, 0, 0, 500, 200, "Ajouter des fichiers par glisser déposer", #PB_Window_SystemMenu | #PB_Window_ScreenCentered) 
    DragAcceptFiles_(WindowID(0), #True) ; activez le glisser déposer 
    SetWindowPos_(WindowID(0), -1, 0, 0, 0, 0, #SWP_NOSIZE | #SWP_NOMOVE) ; fenêtre toujours au premier plan 
    If CreateGadgetList(WindowID(0)) 
      ListIconGadgetXP(1, 0, 0, 500, 200, "Fichiers", 495, 0) ; crée une listicongadget avec icônes systèmes 
    EndIf 
  EndIf 
EndProcedure 


Procedure DragAndDrop() 
  dropped.l = EventwParam() 
  num.l = DragQueryFile_(dropped, -1, "", 0) 
  For index = 0 To num - 1 
    size.l = DragQueryFile_(dropped, index, 0, 0) 
    filename.s = Space(size) 
    DragQueryFile_(dropped, index, filename, size + 1) 
    
    If FileSize(filename) = -2 
      If Right(filename, 1) <> "\" : filename = filename + "\" : EndIf 
    EndIf 
    
    ; Attention, un dossier doit obligatoirement se finir par un \ sinon l'algo plante 
    Position = Triage(1, 0, Filename) 
    AddGadgetItemXP(1, Position, filename, filename) 
    
  Next 
  DragFinish_(dropped) 
EndProcedure 

;- debut du programme 
Open_Window() 

Repeat 
  Event = WaitWindowEvent() 
  
  If Event = #WM_DROPFILES : DragAndDrop() : EndIf 
  
Until Event = #PB_Event_CloseWindow 

End
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -