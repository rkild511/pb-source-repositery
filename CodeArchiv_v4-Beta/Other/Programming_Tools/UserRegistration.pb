; English forum: http://www.purebasic.fr/english/viewtopic.php?t=8718&highlight=
; Author: Heis Spiter
; Date: 13. December 2003
; OS: Windows
; Demo: Yes

; Registration for user:
; With it, you can create a registration system for your progam user.
; It do all : Search the user, regitrer the user, write the user and
; his mail in a *.ini, and return the name of the user !
; - If e-mail or name are too short, you must change them 
; - If there is no @ in e-mail, you must change it ! 

;************************************************************ 
;Forum français de PureBasic : http://www.serveurperso.com/~cederavic/IPB/index.php?s=8716ee82d0ebe3f922de94d5ceae7bd2&act=ST&f=11&t=655 
;English forum : http://purebasic.myforums.net/viewtopic.php?p=41759 
;Auteur : Heis Spiter 
;Créée le 05/11/03 : Permet l'enregistrement d'un utilisateur sur un fichier *.ini 
;Ex : Nom$ = Enregistrement("config.ini", "Editeur") 
Procedure.s Enregistrement(FichierINI$, Programme$) 

  ; Tente d'ouvrir le fichier *.ini ; s'il exite tout sera sauté 
  If ReadFile(0, FichierINI$) = 0 
    ; affiche un message d'avertissment 
    MessageRequester("Attention", "Ceci est votre première utilisation de " +  Programme$ + " ou le fichier " + FichierINI$ +" a été supprimé ou remplacé ! Il vous sera demandé des informations qui ne seront communiquées à personne (puisque'elle resteront sur votre PC)", #MB_ICONWARNING)  
    ; demande le nom 
    Nom : 
    Nom$ = InputRequester("Saisie des informations 1/2", "Entrez votre nom", "ici") 
    ; Vérifie que le nom n'est pas "ici" 
    If Nom$ = "ici" 
      ; s'il est "ici", il faut recommencer 
      MessageRequester("Erreur", "Votre nom ne peut être ici !", #MB_ICONERROR) 
      Goto Nom 
    EndIf 
    ; Vérifie que le nom n'est pas trop long 
    If Len(Nom$) >= 200 
      ; s'il est trop long, demande de recommencer 
      MessageRequester("Erreur", "Votre nom est trop long !", #MB_ICONERROR) 
      Goto Nom 
    EndIf 
    ; Vérifie que le nom n'est pas trop court 
    If Len(Adresse$) <= 4 
      ; s'il est trop court, demande de recommencer 
      MessageRequester("Erreur", "Votre nom est trop court !", #MB_ICONERROR) 
      Goto Nom 
    EndIf 
    ; demande l'adresse e-mail 
    AdresseMail : 
    Adresse$ = InputRequester("Saisie des informations 2/2", "Entrez une adresse e-mail", "ici") 
    ; Vérifie que l'adresse e-mail n'est pas "ici" 
    If Adresse$ = "ici" 
      ; si elle est "ici", il faut recommencer 
      MessageRequester("Erreur", "Votre adresse e-mail ne peut être ici !", #MB_ICONERROR) 
      Goto AdresseMail 
    EndIf 
    ; Vérifie que l'adresse e-mail n'est pas trop longue 
    If Len(Adresse$) >= 250 
      ; si elle est trop longue, demande de recommencer 
      MessageRequester("Erreur", "Votre adresse e-mail est trop longue !", #MB_ICONERROR) 
      Goto AdresseMail 
    EndIf 
    ; Vérifie que l'adresse e-mail n'est pas trop courte 
    If Len(Adresse$) <= 4 
      ; si elle est trop courte, demande de recommencer 
      MessageRequester("Erreur", "Votre adresse e-mail est trop courte !", #MB_ICONERROR) 
      Goto AdresseMail 
    EndIf 
    ;Vérifie la présence de @ 
    Arobas = FindString(Adresse$, "@", 1) 
    If Arobas = 0 
      ;S'il n'y en a pas, demande de recommencer 
      MessageRequester("Erreur", "Ceci n'est pas une adresse e-mail valide !", #MB_ICONERROR) 
      Goto AdresseMail 
    EndIf 
    ; Créé le fichier et stoke les infos 
    CreateFile(0, FichierINI$) 
    WriteStringN(0, Nom$) 
    WriteString(0, Adresse$) 
    ; Annonce que tout est fini 
    MessageRequester("Succés !", "Vous venez d'acquerir une license ! Elle est decernée à : " + Nom$ + " " + Adresse$ + ".", #MB_ICONINFORMATION) 
    ; ferme le fichier 
    CloseFile(0) 
  EndIf 
  ;Ouvre le fichier 
  If ReadFile(0, FichierINI$) 
    ;Lit la première ligne 
    License$ =  ReadString(0) 
    ;Si elle ne vaut rien 
    If License$ = "" 
      ;Affcihe du message d'erreur 
      MessageRequester("Erreur", "Vous n'avez pas obtenu de license", #MB_ICONERROR) 
      ;Fermeture du fichier 
      CloseFile(0) 
      ;Quitte le programme 
      End 
    EndIf 
  EndIf 
  ;Ouvre le fichier 
  If ReadFile(0,FichierINI$) 
    ;Lit la première ligne 
    License.s =  ReadString(0) 
  EndIf 
  ;La procedure retourne maintenant le nom d'utilisateur 
  ProcedureReturn License.s 

EndProcedure 
;************************************************************

Debug Enregistrement("Config.ini","Editor")
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
