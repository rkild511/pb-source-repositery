; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6517&highlight=
; Author: secam59 (updated for PB4.00 by blbltheworm)
; Date: 12. June 2003
; OS: Windows
; Demo: Yes

; Question: Is it possible to write into a windows gadget (EditorGadget Or ListViewGadget)
; the ASCII characters > 127 and especially the 'semi-graphical' characters of a .NFO file
; for example ? 
; Do you need to convert the file or is it just swtiching between two display modes ? 

; Answer: I obtain the right semi-graphical characters when I use the Console Mode windows.
; Here is a small code to see what I want (you must have a .NFO file !) 


;- Window Constants 
; 
#Fenetre_Principale = 0 

;- Gadget Constants 
; 
#Liste_Titres = 0 
#Affichage_repertoire = 1 
#Bouton_repertoire = 2 
#Bouton_Quitter = 3 
#Liste_NFO = 4 

Global FontID1 
FontID1 = LoadFont(1, "FixedSys", 8) 

Procedure Open_Fenetre_Principale() 
  hdc = OpenWindow(#Fenetre_Principale, 306, 31, 611, 555, "NFO Reader",  #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered ) 
  If hdc  
    If CreateGadgetList(WindowID(#Fenetre_Principale)) 
      ListIconGadget(#Liste_Titres, 40, 85, 530, 70, "Titres", 530, #PB_ListIcon_CheckBoxes | #PB_ListIcon_MultiSelect | #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect) 
      StringGadget(#Affichage_repertoire, 40, 35, 275, 20, "") 
      ButtonGadget(#Bouton_repertoire, 335, 35, 225, 20, "Répertoire contenant le NFO") 
      ButtonGadget(#Bouton_Quitter, 440, 525, 130, 20, "Quitter") 
      EditorGadget(#Liste_NFO, 40, 165, 530, 350) 
      SetGadgetFont(#Liste_NFO, FontID1) 
    EndIf 
  EndIf 
EndProcedure 

Open_Fenetre_Principale() 

Repeat 
  Event = WaitWindowEvent() 
  If Event= #PB_Event_Gadget 
      Select EventGadget() 
      
      Case #Bouton_repertoire 
      ClearGadgetItemList(#Liste_NFO) 
      fichier_NFO$ = OpenFileRequester("Fichier NFO", "", "Fichiers NFO |*.NFO", 0) 
        
      SetGadgetText(#Affichage_repertoire, fichier_NFO$) 
      AddGadgetItem(#Liste_Titres, -1, GetFilePart(fichier_NFO$)) 
      OpenConsole() 
      ConsoleColor(0, 15)  
      If OpenFile(1, fichier_NFO$) 
          While Eof(1)=0 
              Texte$ = ReadString(1) 
              AddGadgetItem(#Liste_NFO,-1,Texte$) 
              PrintN(Texte$) 
          Wend 
         CloseFile(1) 
      EndIf 
      Input() 
      CloseConsole() 
      
      Case #Bouton_Quitter 
      Event = #PB_Event_CloseWindow 
      
      EndSelect  
  EndIf 
Until Event = #PB_Event_CloseWindow 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
