; English Forum:
; Author: Jean Convert (updated for PB3.92+ by Lars & Andre, updated for PB4.00 by blbltheworm)
; Date: 10. January 2003
; OS: Windows
; Demo: No

;
;  Jean Convert January 10th 2003.
;
; ------------------------------------------------------------
;

Global Titre$,ilg.b

Titre$ = "Saucisson_jc V1.0"

Global Dim lib$(41,2)

lib$(0,0) = "AUCUNE ACTION EFFECTUEE." : lib$(0,1) = "NO ACTION DONE."
lib$(1,0) = "Taille = ":lib$(1,1) = "Size = "
lib$(2,0) = " Ko":lib$(2,1) = " KB"
lib$(3,0) = "Taille trop grande.":lib$(3,1) = "Size too large"
lib$(4,0) = "(Taille maxi = ":lib$(4,1) ="(Maximum size = "
lib$(5,0) = " Ko)":lib$(5,1) =" KB)"
lib$(6,0) = "ne vaut pas la peine d'être découpé en morceaux de ":lib$(6,1) ="does not need to be cut in pieces of "
lib$(7,0) = "Le fichier ne peut pas être ouvert.":lib$(7,1) ="The file can't be opened."
lib$(8,0) = "Impossible d'allouer une mémoire tampon de ":lib$(8,1) ="Impossible to allocate a memory of "
lib$(9,0) = "impossible à créer.":lib$(9,1) ="Impossible to create."
lib$(10,0) = " FICHIERS GENERES.":lib$(10,1) =" CREATED FILES."
lib$(11,0) = "ENVOYER AUTANT DE MESSAGES QUE DE FICHIERS,":lib$(11,1) ="PLEASE, SEND AS MANY MAILS AS FILES,"
lib$(12,0) = "ET ENVOYER SAUCISSON_JC.EXE POUR RECONSTITUER LE FICHIER ORIGINAL.":lib$(12,1) ="AND SEND SAUCISSON_JC.EXE TO REBUILD THE ORIGINAL FILE."
lib$(13,0) = "Dans la fenêtre qui va s'ouvrir, il faudra sélectionner":lib$(13,1) ="A window will be opened. In it, you'll have to select"
lib$(14,0) = "le premier fichier de la série. Le nom de ce fichier se termine par .1":lib$(14,1) ="the first file in the serie. The name of this file is terminated with .1"
lib$(15,0) = " CHOISIR LE FICHIER SE TERMINANT PAR .1":lib$(15,1) =" CHOOSE THE FILE WITH A NAME TERMINATED WITH .1"
lib$(16,0) = "Le nom de ce fichier ne se termine pas par .1":lib$(16,1) ="The name of this file is not terminated with .1"
lib$(17,0) = "Fichier vide !":lib$(17,1) ="Empty file !"
lib$(18,0) = "RECONSTITUE.":lib$(18,1) ="REBUILT."
lib$(19,0) = "&Français":lib$(19,1) ="&French"
lib$(20,0) = "&Anglais":lib$(20,1) ="&English"
lib$(21,0) = "&Langue":lib$(21,1) ="&Language"
lib$(22,0) = "&Aide":lib$(22,1) ="&Help"
lib$(23,0) = "&A propos...":lib$(23,1) ="&About..."
lib$(24,0) = "Découpage":lib$(24,1) ="Cutting"
lib$(25,0) = "Reconstitution du fichier original":lib$(25,1) ="Rebuilding the original file"
lib$(26,0) = "par tranche de":lib$(26,1) ="by pieces of"
lib$(27,0) = "Annuler":lib$(27,1) ="Cancel"
lib$(28,0) = "Programme gratuit. Vous utilisez ce logiciel à vos risques et périls.":lib$(28,1) ="Freeware. The user must assume the entire risk of using this soft."
lib$(29,0) = "L'auteur ne peut en aucun cas être tenu responsable":lib$(29,1) ="The author assumes no liability for damages, direct or consequential,"
lib$(30,0) = "des dégats occasionnés par " + Titre$ + ",":lib$(30,1) ="which may result from the use of " + Titre$ + ","
lib$(31,0) = "même si l'auteur a été avisé d'une possibilité de tels risques.":lib$(31,1)="even if the author has been advised of the possibility of such damages."
lib$(32,0) = "Compilateur utilisé : http://www.purebasic.com":lib$(32,1) ="Programming language : http://www.purebasic.com"
lib$(33,0) = "Ko, 1500 maxi conseillé.":lib$(33,1) ="KB, 1500 maxi recommended."
lib$(34,0) = "La longueur doit être comprise entre 100 et 10000.":lib$(34,1) ="The size must be between 100 and 10000."
lib$(35,0) = "Quel est votre choix ?":lib$(35,1) ="What is your choice?"
lib$(36,0) = Titre$ + "       Copyright (c) Jean Convert.":lib$(36,1) = lib$(36,0)
lib$(37,0) = "Découpage d'un gros fichier en plusieurs petits fichiers.":lib$(37,1) ="Cutting a big file into several little files."
lib$(38,0) = "etc...":lib$(38,1) ="more..."
lib$(39,0) = "Les petits fichiers (.1 .2 etc.) doivent tous être dans un même répertoire.":lib$(39,1) ="The little files (.1 .2 etc.) must be all in a same directory."
lib$(40,0) = "Installation : il suffit de copier Saucisson_jc.exe dans un répertoire.":lib$(40,1)="Installation : just copy Saucisson_jc.exe in a directory."
lib$(41,0) = "Désinstallation : supprimer simplement Saucisson_jc.exe.":lib$(41,1)="Uninstallation : just delete Saucisson_jc.exe."


Procedure aide() ; =========================================================================== HELP

  Mes$ = lib$(36,ilg.b) + Chr(13) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(28,ilg.b) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(29,ilg.b) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(30,ilg.b) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(31,ilg.b) + Chr(13) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(40,ilg.b) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(41,ilg.b) + Chr(13) + Chr(13) + Chr(13)
  Mes$ = Mes$ + "cvtjean@wanadoo.fr" + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(32,ilg.b)
  MessageRequester(Titre$,Mes$,0)
  
; ShellExecute_(0, "open", "test.html", 0, 0, 1)
          
EndProcedure

Procedure.s ReadRegKey(OpenKey.l,SubKey.s,ValueName.s)  ; ====================================== ReadRegKey

; key.s=ReadRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\Zone Labs\ZoneAlarm","InstallDirectory")

  hKey.l=0
  keyvalue.s=Space(255)
  DataSize.l=255
  
  If RegOpenKeyEx_(OpenKey,SubKey,0,#KEY_READ,@hKey)
    keyvalue=""
    Else 
    If RegQueryValueEx_(hKey,ValueName,0,0,@keyvalue,@DataSize)
      keyvalue=""
      Else  
      keyvalue=Left(keyvalue,DataSize-1)
    EndIf
    RegCloseKey_(hKey)
  EndIf
   
  ProcedureReturn keyvalue
EndProcedure  



Procedure.l WriteRegKey(OpenKey.l,SubKey.s,keyset.s,keyvalue.s) ; ------------------------ WRITE KEY

; result.l=WriteRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\Test Program Name","Test","TestValue")

  hKey.l=0  
  If RegCreateKey_(OpenKey,SubKey,@hKey)=0
    Result=1
    DataSize.l=Len(keyvalue)
    If RegSetValueEx_(hKey,keyset,0,#REG_SZ,@keyvalue,DataSize)=0
      Result=2
    EndIf 
    RegCloseKey_(hKey)
  EndIf
  ProcedureReturn Result 
;returns 0 if error / could not open or create SubKey
;returns 1 if error / could not write new value
;returns 2 if Success!!

EndProcedure


Procedure decoupage(longueur,current_directory_jc$) ; -------------------------------- CUTTING
  
trt_ok.b = 0  ; it is supposed that there will be an error...

              ; longueur is in KB.

  longueuro = longueur * 1024
  
  aucune$ = lib$(0,ilg.b)

  Debug aucune$
  
  Fichin$ = Trim(OpenFileRequester(Titre$, current_directory_jc$, "", 0))
  If Fichin$ = ""
    MessageRequester(Titre$,aucune$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  Taille.f = FileSize(Fichin$)
  Taille_maxi.f = 500000000
  If Taille.f > Taille_maxi.f
    Mes$ = Fichin$ + Chr(13)
    Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(3,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(4,ilg.b) + Str(Round(Taille_maxi.f / 1024,0)) + lib$(5,ilg.b) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  If Taille.f < longueuro * 1.2
    Mes$ = Fichin$ + Chr(13)
    Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(6,ilg.b) + Str(longueur) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  If ReadFile(0, Fichin$) = 0
    Mes$ = Fichin$ + Chr(13)
    Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(7,ilg.b) + Chr(13) + Chr(13)
    Debug Mes$
    Debug aucune$
    CallDebugger
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf


  *Buffer = AllocateMemory(longueuro)
  If *Buffer = 0
    Mes$ = Fichin$ + Chr(13)
    Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ +  lib$(8,ilg.b)+ Str(longueur) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  reste.f = Taille.f
  cpt = 0
  Mesres$ = ""
  dejamore.b = 0
  
  Repeat
  
    If reste.f > longueuro
      longdecoup = longueuro
    Else
      longdecoup = reste.f
    EndIf  
    
    ReadData(0,*Buffer, longdecoup)
    reste.f = reste.f - longdecoup
  
    cpt = cpt + 1
    Fichout$ = Fichin$ + "." + Trim(Str(cpt))
    If CreateFile(1, Fichout$) = 0
      Mes$ = Fichout$ + Chr(13) + Chr(13)
      Mes$ = Mes$ + lib$(9,ilg.b) + Chr(13)
      Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
      MessageRequester(Titre$,Mes$,0)
      ProcedureReturn trt_ok.b
    EndIf
    
    WriteData(1,*Buffer, longdecoup)
    CloseFile(1)
    
    If cpt < 31
      Mesres$ = Mesres$ + Fichout$ + "    " + Str(Round(longdecoup / 1024,0)) + lib$(2,ilg.b) + Chr(13)
    Else
      If dejamore.b = 0
        Mesres$ = Mesres$ + lib$(38,ilg.b) + Chr(13)
        dejamore.b = 1
      EndIf  
    EndIf  
  Until reste.f = 0
  
  FreeMemory(2)
  CloseFile(0)
  
  
  Mesres$ = Mesres$ + Chr(13) + Str(cpt) + lib$(10,ilg.b) + Chr(13) + Chr(13)
  Mesres$ = Mesres$ + lib$(11,ilg.b) + Chr(13) + Chr(13)
  Mesres$ = Mesres$ + lib$(12,ilg.b) + Chr(13)
  
  MessageRequester(Titre$,Mesres$,0)
  
  trt_ok.b = 1
  
  ProcedureReturn trt_ok.b
EndProcedure


Procedure reconstitution(current_directory_jc$) ; ------------------------------------------ REBUILDING

  trt_ok.b = 0  ; it is supposed that there will be an error...

                ; longueur is in KB.


  aucune$ = lib$(0,ilg.b)

  Mes$ =  lib$(13,ilg.b) + Chr(13) + Chr(13)
  Mes$ = Mes$ + lib$(14,ilg.b)  + Chr(13)  + Chr(13)
  
  MessageRequester(Titre$,Mes$,0)
  
  Fichin$ = Trim(OpenFileRequester(Titre$ + lib$(15,ilg.b), current_directory_jc$, "", 0))
  If Fichin$ = ""
    MessageRequester(Titre$,aucune$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  If Right(Fichin$,2) <> ".1"
    Mes$ = Fichin$ + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(16,ilg.b) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  longueuro = FileSize(Fichin$)
  If longueuro = 0
    Mes$ = Fichin$ + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(17,ilg.b) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  *Buffer = AllocateMemory(longueuro)
  If *Buffer = 0
    Mes$ = Fichin$ + Chr(13)
    Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ +  lib$(8,ilg.b)+ Str(longueur) + lib$(2,ilg.b) + Chr(13) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf

  Fichout$ = Left(Fichin$,Len(Fichin$) - 2)
  
  If CreateFile(1, Fichout$) = 0
    Mes$ = Fichout$ + Chr(13) + Chr(13)
    Mes$ = Mes$ + lib$(8,ilg.b) + Chr(13)
    Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
    MessageRequester(Titre$,Mes$,0)
    ProcedureReturn trt_ok.b
  EndIf
  
  Taille.f = longueuro
  cpt = 1
  
  Repeat

    If ReadFile(0, Fichin$) = 0
      Mes$ = Fichin$ + Chr(13)
      Mes$ = Mes$ + lib$(1,ilg.b) + Str(Round(Taille.f/1024,0)) + lib$(2,ilg.b) + Chr(13) + Chr(13)
      Mes$ = Mes$ + lib$(7,ilg.b) + Chr(13) + Chr(13)
      Mes$ = Mes$ + Chr(13) + aucune$ + Chr(13)
      MessageRequester(Titre$,Mes$,0)
      ProcedureReturn trt_ok.b
    EndIf
    
    ReadData(0,*Buffer, Taille.f)
    CloseFile(0)
    
    WriteData(1,*Buffer, Taille.f)
    
    cpt = cpt + 1
    Fichin$ = Fichout$ + "." + Trim(Str(cpt))
    
    Taille.f = FileSize(Fichin$)
    
  Until Taille.f < 1
  
  FreeMemory(*Buffer)
  CloseFile(1)
  
  MessageRequester(Titre$,Fichout$ + Chr(13) + Chr(13) + lib$(18,ilg.b) + Chr(13),0)

  trt_ok.b = 1
  ProcedureReturn trt_ok.b
EndProcedure

; --------------------------------------------------------------------------------------------- BEGIN

; ----------------------------------------------------------------------- language
ilang.s=ReadRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\saucission_jc","Lg")

Select ilang.s
  Case "0"
  Case "1"
  Default
    ilang.s = "0"  ; French
    Select GetUserDefaultLangID_()
      Case 1036   ; 1036 French sur W 98
      Case 4108   ; 4108 Switzerland 
      Case 5132   ; 5132 Luxembourg
      Case 3084   ; 3084 Canada
      Case 2060   ; 2060 Belgium
      Default
        ilang.s = "1"
    EndSelect
    WriteRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\saucission_jc","Lg",ilang.s)
EndSelect

ilg.b = Val(ilang.s)

; ----------------------------------------------------------------------- working directory
resdir$=Space(512)

res = GetCurrentDirectory_(512,@resdir$)

If res = 0
  current_directory_jc$ = ""
Else
  current_directory_jc$ = Trim(resdir$) + "\"
EndIf

; -------------------------------------------------------------------------------------------------- WINDOWS

; ----------------------------------------------------------------------- Screen resolution
monit_l.l = GetSystemMetrics_(#SM_CXSCREEN)
monit_h.l = GetSystemMetrics_(#SM_CYSCREEN)

win_l.l = 600  ; width height of the window
win_h.l = 355

pos_l.l = Round((monit_l.l - win_l.l) / 2,0)  ; window position
pos_h.l = Round((monit_h.l - win_h.l) / 2,0)

; lexicon :

;  width   height  horizontal  vertical positions

;  win_l   win_h   pos_l       pos_h       window
;  l       h       pl          ph          used part of the window
;  lsub    hsub    plsub       phsub       used part in the sub-window


; ----------------------------------------------------------------------- Font

PoliceID.l = LoadFont(0, "Arial", 10)
Hlig.l = 19         ; average height in pixels of a line
Lcarnum.b = 10      ; average width  in pixels of a numeric character
Lcar.b = 12         ; average width  in pixels of a alpha character


; ----------------------------------------------------------------------- Loop in case of changing language
Repeat

change_langue.b = 0  ; it is assumed that there will not be any change of language.

; ------------------------------------------------------ WINDOWS


If OpenWindow(0, pos_l.l, pos_h.l, win_l.l, win_h.l, Titre$, #PB_Window_MinimizeGadget) = 0
  MessageRequester("Error","Error creating window!",0)
  End
EndIf

gno.b = 1

; ------------------------------------------------------ Menu

If CreateMenu(0, WindowID(0))
  MenuTitle(lib$(21,ilg.b))      
    gno.b = gno.b + 1
    gno_menu_francais = gno.b
    MenuItem( gno_menu_francais, lib$(19,ilg.b))
    gno.b = gno.b + 1
    gno_menu_anglais = gno.b
    MenuItem( gno_menu_anglais, lib$(20,ilg.b))
    
  MenuTitle(lib$(22,ilg.b))
    gno.b = gno.b + 1
    gno_menu_propos = gno.b
    MenuItem( gno_menu_propos, lib$(23,ilg.b))
 
EndIf

; ------------------------------------------------------ StatusBar
  
If CreateStatusBar(0, WindowID(0))
  long3.w = Round(win_l.l / 3,0)
  AddStatusBarField(2 * long3.w)   
  AddStatusBarField(long3.w)   
EndIf

StatusBarText(0, 0, current_directory_jc$ , 0 | 4)
   
; ------------------------------------------------------ Gadget Font
If PoliceID.l <> 0
  SetGadgetFont(#PB_Default, PoliceID.l)   
EndIf

 
; -------------------------------------------------------------------------------------- Gadgets list

If CreateGadgetList(WindowID(0))

  
  Frame3DGadget(gno.b, 0, 0, win_l.l, 2, "", 2)
  
  ; --------------------------------------------------------------------------------------- TEXTS UP

  l.l = Round(win_l.l * 0.95,0)            ; width of a line
  pl.l = Round((win_l.l - l.l) / 2,0)      ; horizontal position
   

  ph.l = 1 * Hlig.l                        ; vertical position

  gno.b = gno.b + 1
  gno_avert_txt1.b = gno.b
  TextGadget(gno_avert_txt1.b, pl.l, ph.l, l.l, Hlig.l, lib$(37,ilg.b),#PB_Text_Center) 

  ph.l = ph.l + 2 * Hlig.l
  gno.b = gno.b + 1
  gno_avert_txt2.b = gno.b
  TextGadget(gno_avert_txt2.b, pl.l, ph.l, l.l, Hlig.l, lib$(28,ilg.b),#PB_Text_Center) 

  ; ---------------------------------------------------------------------------------------- Choices BUTTONS
  

  ph.l = ph.l + 3 * Hlig.l

                  ;             posl  posh  long        H
  gno.b = gno.b + 1
  gno_decoupage.b = gno.b
  OptionGadget(gno_decoupage.b, pl.l, ph.l, 9 * Lcar.b, Hlig.l, lib$(24,ilg.b)) 

  phlong.l = ph.l
  
  ph.l = ph.l + 3 * Hlig.l                  ; vertical position
                  ;           posl  posh  long         H
  gno.b = gno.b + 1
  gno_reconst.b = gno.b
  OptionGadget(gno_reconst.b, pl.l, ph.l, 24 * Lcar.b, Hlig.l, lib$(25,ilg.b)) 

  ph.l = ph.l + Hlig.l
  gno.b = gno.b + 1
  gno_avert_txt3.b = gno.b
  TextGadget(gno_avert_txt3.b, pl.l, ph.l, l.l, Hlig.l, lib$(39,ilg.b),#PB_Text_Center) 


; ---------------------------------------------------- size of the little files

  gno.b = gno.b + 1
  gno_decoupage_txt1.b = gno.b
  TextGadget(gno_decoupage_txt1.b, pl.l + 13 * Lcar.b, phlong.l, 14 * Lcar.b, Hlig.l, lib$(26,ilg.b)) 

  defaut$="  1500"
  ldefaut.w = Lcarnum.b * Len(defaut$)
      
  gno.b = gno.b + 1
  gno_longueur_ko.b = gno.b
  StringGadget(gno_longueur_ko.b, pl.l + 23 * Lcar.b, phlong.l, ldefaut.w, Round(Hlig.l * 1.1,1), defaut$ , #PB_String_Numeric) 

  gno.b = gno.b + 1
  gno_decoupage_txt2.b = gno.b
  TextGadget(gno_decoupage_txt2.b, pl.l + 27 * Lcar.b + ldefault.w + 2 * Lcar.b, phlong.l, 24 * Lcar.b, Hlig.l, lib$(33,ilg.b)) 

; ------------------------------------------------------ OK Cancel

  ph.l = ph.l + 3 * Hlig.l
  gno.b = gno.b + 1
  gno_ordre_ok.b = gno.b
  ButtonGadget(gno_ordre_ok.b, l.l / 4 + 6 * Lcar.b, ph.l, 4 * Lcar.b, 2 * Hlig.l, "OK")
      
  gno.b = gno.b + 1
  gno_ordre_annul.b = gno.b
  ButtonGadget(gno_ordre_annul.b, 3 * l.l / 4 - 8 * Lcar.b , ph.l, 6 * Lcar.b, 2 * Hlig.l, lib$(27,ilg.b))
 

; CloseGadgetList()

; 

EndIf

If GetGadgetState(gno_decoupage.b)
  HideGadget(gno_decoupage_txt1.b, 0) 
  HideGadget(gno_longueur_ko.b, 0) 
  HideGadget(gno_decoupage_txt2.b, 0) 
Else
  HideGadget(gno_decoupage_txt1.b, 1) 
  HideGadget(gno_longueur_ko.b, 1) 
  HideGadget(gno_decoupage_txt2.b, 1) 
EndIf

        
; ------------------------------------------------------ EVENT LOOP

Quit = 0

Repeat
    
  Eventprec.l = Event.l
    
  Event.l = WaitWindowEvent()

  If GetGadgetState(gno_decoupage.b)
    HideGadget(gno_decoupage_txt1.b, 0) 
    HideGadget(gno_longueur_ko.b, 0) 
    HideGadget(gno_decoupage_txt2.b, 0) 
  Else
    HideGadget(gno_decoupage_txt1.b, 1) 
    HideGadget(gno_longueur_ko.b, 1) 
    HideGadget(gno_decoupage_txt2.b, 1) 
  EndIf
        
  Select Event.l

    Case #PB_Event_Menu
        
      Select EventMenu()  ; To see which menu has been selected
            
        Case gno_menu_francais
          If ilg.b <> 0
            change_langue.b = 1
            ilg.b = 0
            quit = 1
          Else
            change_langue.b = 0  
          EndIf
          
          
        Case gno_menu_anglais
          If ilg.b <> 1
            change_langue.b = 1
            ilg.b = 1
            quit = 1         
          Else
            change_langue.b = 0  
          EndIf
          
       
        Case gno_menu_propos
          Aide()
          
        Default
          MessageRequester(Titre$,"Menu inconnu : "+Str(EventMenu()), 0)

      EndSelect

    Case #WM_CLOSE ; #PB_EventCloseWindow
      Quit = 1
  
    Case #PB_Event_Gadget
        
      Select EventGadget()

        Case gno_ordre_ok.b
 
          If GetGadgetState(gno_decoupage.b)
            longueur = Val (Trim(GetGadgetText(gno_longueur_ko.b)))
            If longueur > 99 And longueur < 10001
              If decoupage(longueur,current_directory_jc$)
                quit = 1
              EndIf  
            Else
              MessageRequester(Titre$,lib$(34,ilg.b),0)
            EndIf
          Else
          If GetGadgetState(gno_reconst.b)
            If reconstitution(current_directory_jc$)
              quit = 1
            EndIf  
          Else
            MessageRequester(Titre$,lib$(35,ilg.b),0)
          EndIf
          EndIf

          
        Case gno_ordre_annul.b
          Quit = 1

      EndSelect     
      
  EndSelect

Until Quit = 1      ; end EVENT LOOP

CloseWindow(0)

If change_langue.b
  WriteRegKey(#HKEY_LOCAL_MACHINE,"SOFTWARE\saucission_jc","Lg",Str(ilg.b))
EndIf


Until change_langue.b = 0  ; no loop again if no language change.

End


; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableAsm
; EnableXP
; DisableDebugger