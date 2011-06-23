; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3036&highlight=
; Author: Dingzbumz (improved by GPI, updated for PB 4.00 by Andre)
; Date: 06. December 2003
; OS: Windows
; Demo: Yes

Global NewList last_file.s() 
Global NewList liste.s() 

Global last_path.s 

Declare auflisten(dll.s,hinzufuegen) 

Enumeration 1;Menu-Einträge 
  #Menu_Oeffnen;1 
  #Menu_Hinzufuegen;2 
  #Menu_EigeneListe;100+ 
  #Menu_EigeneListeEnde=#Menu_EigeneListe+20 
  #Menu_LastFile;3+ 
  #Menu_LastFileEnde=#Menu_LastFile+10 
  #Menu_Beenden;14 
  #Menu_NameKopieren;31 
  #Menu_AdresseKopieren;32 
  #Menu_ZurListeHinzufuegeen;33 
  #Menu_AktuellesEntfernen;34 
  #Menu_AlleEntfernen;35 
  #Menu_EntferneX;40+ 
  #Menu_EntferneXEnde=#Menu_EntferneX+20 
  #Menu_About;21 
EndEnumeration 
Enumeration 1;Gadgets 
  #Gadget_Oeffnen;20 
  #Gadget_Hinzufuegen;21 
  #Gadget_NameKopieren;22 
  #Gadget_AdresseKopieren;23 
  #Gadget_ZurListe;24 
  #Gadget_Google;26 
  #Gadget_Beenden;27 
  #Gadget_Liste;2 
  #Gadget_DLLName;3 
EndEnumeration 

Procedure Menu() 
  If CreateMenu(0,WindowID(0)) 
    ;erstes menue 
    MenuTitle("&Datei") 
    MenuItem(#Menu_Oeffnen,"ö&ffnen") 
    MenuItem(#Menu_Hinzufuegen,"&hinzufügen") 
    OpenSubMenu("Eigene &Liste") 
    z=0 
    ResetList(liste()) 
    ForEach liste() 
      If z<20 
        MenuItem(#Menu_EigeneListe+z,"&"+Str(z+1)+"  "+liste()) 
      Else 
        DeleteElement(liste()) 
      EndIf 
      z+1 
    Next 
    CloseSubMenu() 
    
    OpenSubMenu("&zuletzt geöffnet") 
    z=0 
    ResetList(last_file()) 
    ForEach last_file() 
      If z<10 
        MenuItem(#Menu_LastFile+z,"&"+Str(z+1)+"  "+last_file()) 
      Else 
        DeleteElement(last_file()) 
      EndIf 
      z+1 
    Next 
    CloseSubMenu() 
    MenuItem(#Menu_Beenden,"b&eenden") 
    
    ;zweites menue 
    MenuTitle("&Bearbeiten") 
    MenuItem(#Menu_NameKopieren,"&Name Kopieren") 
    MenuItem(#Menu_AdresseKopieren,"&Adresse Kopieren") 
    MenuItem(#Menu_ZurListeHinzufuegeen,"zur Liste &hinzufügen") 
    OpenSubMenu("Aus Liste &entfernen") 
    MenuItem(#Menu_AktuellesEntfernen,"&aktuelles entfernen") 
    MenuItem(#Menu_AlleEntfernen,"alle entfernen") 
    MenuBar() 
    z=0 
    ResetList(liste()) 
    ForEach liste() 
      MenuItem(z+#Menu_EntferneX,liste()) 
      z+1 
    Next 
    CloseSubMenu() 
    
    
    ;drittes menue 
    MenuTitle("&Info") 
    MenuItem(#Menu_About,"&about") 
  EndIf 
EndProcedure 

Procedure dll_oeffnen(hinzufuegen) 
  dll_opened.s=OpenFileRequester("DLL wählen", last_path,"dll (*.dll)| *dll",0) 
  If dll_opened 
    last_path=GetPathPart(dll_opened ) 
    auflisten(dll_opened,hinzufuegen) 
  EndIf 
EndProcedure 
Procedure auflisten(dll.s,hinzufuegen) 
  ;-die ifs hab ich hier getrennt, da bei einen if immer alles kontrolliert wird und immer versucht wird die DLL zu öffnen 
  If dll <>"" 
    If OpenLibrary(0,dll) 
      ResetList(last_file()) 
      AddElement(last_file()) 
      last_file()=dll 
      
      vorkommen=0 
      ForEach last_file() 
        If last_file()=dll 
          vorkommen+1 
        EndIf 
      Next 
      If vorkommen >1 
        SelectElement(last_file(),0) 
        While NextElement(last_file()) 
          If last_file()=dll 
            DeleteElement(last_file()) 
            Break 
          EndIf 
        Wend 
      EndIf 
      
      If hinzufuegen<>1 
        ClearGadgetItemList(#Gadget_Liste) 
        i=0 
      Else 
        hinzufuegen=0 
      EndIf 
      
      SetGadgetText(#Gadget_DLLName,dll) 
      If CountLibraryFunctions(0) >0 
        ExamineLibraryFunctions(0) 
        While NextLibraryFunction() 
          i+1 
          AddGadgetItem(#Gadget_Liste,i- 1,Str(i)+Chr(10)+LibraryFunctionName()+Chr(10)+Str(LibraryFunctionAddress())) 
        Wend 
        Menu() 
      Else 
        MessageRequester("Fehler", "Die DLL "+dll+" hat keinen inhalt.") 
      EndIf 
    Else 
      MessageRequester("Fehler", "Die DLL:"+Chr(13)+dll+Chr(13)+"kann nicht gelesen werden, "+Chr(13)+"oder existiert nicht.") 
    EndIf 
  EndIf 
EndProcedure 

Procedure Zur_Liste(dll.s) 
  If dll<>"" 
    vorkommen=0 
    ResetList(liste()) 
    ForEach liste() 
      If liste()=dll 
        vorkommen=1 
        Break 
      EndIf 
    Next 
    
    If vorkommen<>1 
      ResetList(liste()) 
      AddElement(liste()) 
      liste()=dll 
    EndIf 
    Menu() 
  EndIf 
EndProcedure 

Procedure.s GetFunctionName() 
  If GetGadgetState(#Gadget_Liste)<>-1 
    ProcedureReturn GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),1) 
  Else 
    ProcedureReturn "" 
  EndIf  
EndProcedure 


;-letzte Einstellungen laden 
If ReadFile(0,"DLL-Viewer.pref") 
  last_path.s=ReadString(0) 
  a=ReadLong(0) 
  If a>-1 
    For i=0 To a 
      AddElement(last_file()) 
      last_file()=ReadString(0) 
    Next 
  EndIf 
  a=ReadLong(0) 
  If a>-1 
    For i=0 To a 
      AddElement(liste()) 
      liste()=ReadString(0) 
    Next 
  EndIf 
  CloseFile(0) 
EndIf 

If OpenWindow(0, 280, 152, 460, 410, "MLK - DLL VIEWER", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_MinimizeGadget) 
  If CreateGadgetList(WindowID(0)) 
    TextGadget(#Gadget_DLLName,10,55,330,20,"") 
    
    ButtonGadget(#Gadget_Oeffnen, 350, 90, 100, 30, "öffnen") 
    ButtonGadget(#Gadget_Hinzufuegen, 350, 125, 100, 30, "hinzufügen") 
    ButtonGadget(#Gadget_NameKopieren, 350, 170, 100, 27, "Name kopieren") 
    ButtonGadget(#Gadget_AdresseKopieren, 350, 202, 100, 27, "Adresse kopieren") 
    ButtonGadget(#Gadget_ZurListe, 350, 244, 100, 27, "zur Liste") 
    ButtonGadget(#Gadget_Google, 350, 286, 100, 27, "Google")    
    ButtonGadget(#Gadget_Beenden, 350, 343, 100, 27, "beenden")    
    
    ListIconGadget(#Gadget_Liste, 10, 70, 330, 300,"Nr.",50,#PB_ListIcon_AlwaysShowSelection | #PB_ListIcon_FullRowSelect) 
    AddGadgetColumn(#Gadget_Liste,1,"Name",186) 
    AddGadgetColumn(#Gadget_Liste,2,"Adresse",90) 
  Else 
    MessageRequester("DLL-Viewer","CreateGadgetList-Error") 
    End 
  EndIf 
  
  Menu() 
Else 
  MessageRequester("DLL-Viewer","Kann kein Fenster öffnen") 
EndIf 

Repeat 
  Select WaitWindowEvent() 
    Case #PB_Event_Gadget 
      Select EventGadget() ;-gadgets 
        
        Case #Gadget_Oeffnen: dll_oeffnen(0) 
        Case #Gadget_Hinzufuegen: dll_oeffnen(1) 
        Case #Gadget_NameKopieren 
          If GetGadgetState(#Gadget_Liste)<>-1 
            SetClipboardText(GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),1)) 
          EndIf 
          
        Case #Gadget_AdresseKopieren 
          If GetGadgetState(2)<>-1 
            SetClipboardText(GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),2)) 
          EndIf 
          
        Case #Gadget_ZurListe 
          Zur_Liste(GetFunctionName()) 
          
          
        Case #Gadget_Google 
          If GetGadgetState(#Gadget_Liste)<>-1 
            RunProgram("http://www.google.de/search?hl=de&ie=UTF-8&oe=UTF- 8&q="+GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),1)+"&btnG=Google+Suche&meta=lr%3Dlang_de","","") 
          EndIf 
          
        Case #Gadget_Beenden 
          quit=#True 
          
      EndSelect 
      
    Case #PB_Event_Menu ;- Menu 
      MenuID=EventMenu() 
      If MenuID>=#Menu_EigeneListe And MenuID<=#Menu_EigeneListeEnde 
        SelectElement(liste(),MenuID-#Menu_EigeneListe) 
        dll.s=liste() 
        DeleteElement(liste())   ;eintrag an aktueller position löschen... 
        ResetList(liste()) 
        AddElement(liste())     ;und an erster stelle... 
        liste()=dll           ;wieder einfügen. 
        ;auflisten(dll,0) <-------------- Blödsinn, oder? 
      ElseIf MenuID>=#Menu_EntferneX And MenuID<=#Menu_EntferneXEnde 
        SelectElement(liste(),MenuID-#Menu_EntferneX) 
        DeleteElement(liste()) 
        Menu() 
      ElseIf MenuID>=#Menu_LastFile And MenuID<=#Menu_LastFileEnde 
        SelectElement(last_file(),MenuID-#Menu_LastFile) 
        auflisten(last_file(),0) 
      Else 
        Select MenuID 
          Case #Menu_Oeffnen: dll_oeffnen(0) 
          Case #Menu_Hinzufuegen: dll_oeffnen(1) 
          Case #Menu_Beenden: quit=#True 
          Case #Menu_About 
            MessageRequester("Info","http://www.dingzbumz.de") 
          Case #Menu_NameKopieren 
            If GetGadgetState(#Gadget_Liste)<>-1 
              SetClipboardText(GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),1)) 
            EndIf  
          Case #Menu_AdresseKopieren 
            If GetGadgetState(#Gadget_Liste)<>-1 
              SetClipboardText(GetGadgetItemText(#Gadget_Liste,GetGadgetState(#Gadget_Liste),2)) 
            EndIf 
          Case #Menu_ZurListeHinzufuegeen 
            Zur_Liste(GetFunctionName()) 
          Case #Menu_AktuellesEntfernen 
            dll=GetFunctionName() 
            If dll<>"" 
              ResetList(liste()) 
              ForEach liste() 
                If liste()=dll 
                  DeleteElement(liste()) 
                EndIf 
              Next 
              Menu() 
            EndIf 
          Case #Menu_AlleEntfernen 
            ClearList(liste()) 
            Menu() 
        EndSelect 
      EndIf 
      
    Case #PB_Event_CloseWindow 
       quit = 1 
  EndSelect 
  If quit=1 
    ;- Create File BEACHTEN! 
    If CreateFile(0,"DLL-Viewer.pref") 
      WriteStringN(0,last_path) 
      c=CountList(last_file())-1 
      If c>9:c=9:EndIf 
      WriteLong(0,c) 
      If c>-1 
        ResetList(last_file()) 
        For i=0 To c 
          NextElement(last_file()) 
          WriteStringN(0,last_file()) 
        Next 
      EndIf 
        
      c=CountList(liste())-1 
      If c>19:c=19:EndIf 
      WriteLong(0,c) 
      If c>-1 
        ResetList(liste()) 
        For i=0 To c 
          NextElement(liste()) 
          WriteStringN(0,liste()) 
        Next 
      EndIf 
      CloseFile(0) 
    EndIf 
  EndIf 
  
Until quit=1 

End 
; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
