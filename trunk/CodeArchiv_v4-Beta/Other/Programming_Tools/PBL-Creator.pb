; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3295&highlight=
; Author: Stefan Moebius (updated for PB 4.00 by Andre)
; Date: 03. January 2004
; OS: Windows
; Demo: No


;PBL-Creator 
;~~~~~~~~~~~ 
;Mit dem PBL-Creator kann man die PBL-Dateien erstellen, die 
;man für den DLL-Importer benötigt, um eine DLL in Purebasic zu importieren. 

Procedure.l hex2dec(h$) 
  h$=UCase(h$) 
  For r=1 To Len(h$) 
    d<<4 : a$=Mid(h$,r,1) 
    If Asc(a$)>60 
      d+Asc(a$)-55 
    Else 
      d+Asc(a$)-48 
    EndIf 
  Next 
  ProcedureReturn d 
EndProcedure 


Procedure GetNumberOfParam(Pointer) 
  Repeat 
    Pointer=DisASMCommand(Pointer) 
    ASM_Code.s=UCase(GetDisASMString()) 
  Until FindString(ASM_Code.s,"RET",1) 
  Bytes=hex2dec(Right(ASM_Code.s,Len(ASM_Code.s)-4)) 
  If Bytes%4 Or Bytes>200:Bytes=-1:EndIf 
  If Bytes>=0:Bytes=Bytes>>2:EndIf 
  ProcedureReturn Bytes 
EndProcedure 

Procedure BadName(Name.s) 
  Result=0 
  If FindString(UCase(Name.s),"DLLENTRYPOINT",1):Result=-1:EndIf 
  If FindString(UCase(Name.s),"DLLCANUNLOADNOW",1):Result=-1:EndIf 
  If FindString(UCase(Name.s),"DLLGETCLASSOBJECT",1):Result=-1:EndIf 
  If FindString(UCase(Name.s),"DLLREGISTERSERVER",1):Result=-1:EndIf 
  If FindString(UCase(Name.s),"DLLUNREGISTERSERVER",1):Result=-1:EndIf 
  If UCase(Name.s)="ATTACHPROCESS":Result=-1:EndIf 
  If UCase(Name.s)="DETACHPROCESS":Result=-1:EndIf 
  If UCase(Name.s)="ATTACHTHREAD":Result=-1:EndIf 
  If UCase(Name.s)="DETACHTHREAD":Result=-1:EndIf 
  If UCase(Name.s)="DLLINITIALIZE":Result=-1:EndIf 
  If Len(Name.s)>100:Result=-1:EndIf 
  If Left(Name.s,1)="?":Result=-1:EndIf 
  If UCase(Name.s)="DUMMY":Result=-1:EndIf 
  ProcedureReturn Result 
EndProcedure 


DLL.s=ProgramParameter() 

If DLL.s="":DLL.s="PureBasic.dll":EndIf 

Flags=#PB_Window_ScreenCentered|#PB_Window_SystemMenu 
OpenWindow(1,0,0,200,115,"PBL-Creator v1.1",Flags) 
CreateGadgetList(WindowID(1)) 
StringGadget  (1, 10, 30,170, 20, DLL) 
TextGadget    (2, 10, 10, 30, 20, "DLL:") 
CheckBoxGadget(3, 10, 60,150, 20, "Fehler anzeigen") 
ButtonGadget  (4, 10, 90, 70, 20, "&Weiter") 
ButtonGadget  (5,110, 90, 70, 20, "&Beenden") 
ButtonGadget  (6,180, 30, 20, 20, "...") 
SetGadgetState(3,1) 

Ok=0 
Repeat 
  Result=WaitWindowEvent() 
  
  Select Result 
    Case #PB_Event_CloseWindow 
      End 
    Case #PB_Event_Gadget 
      If EventGadget()=6 
      SetGadgetText(1,OpenFileRequester("DLL laden","PureBasic.dll","Dynamic Link Library(*.dll)|*.DLL",0)) 
      EndIf 
      
      If EventGadget()=5:End:EndIf 
      If EventGadget()=4:DLL=GetGadgetText(1):DisplayErrors=GetGadgetState(3):Ok=-1:EndIf 
  EndSelect 
  
Until Ok 



If FindString(DLL,".",1)=0:DLL=DLL+".dll":EndIf 

Pbl.s=DLL 
Point=FindString(Pbl,".",1) 
Pbl=Left(Pbl,Point-1)+".pbl" 


Inst=OpenLibrary(1,DLL.s) 

If Inst=0 
  MessageRequester("Fehler","Die DLL "+DLL+" wurde nicht gefunden.") 
  End 
EndIf 

If CreateFile(1,Pbl)=0 
  MessageRequester("Fehler","Die Datei "+Pbl+" konnte nicht erstellt werden.") 
  End 
EndIf 

WriteStringN(1, ";Erstellt mit PBL-Creator v1.1") 
WriteStringN(1, GetFilePart(DLL)) 

If ExamineLibraryFunctions(1) 
  While NextLibraryFunction()<>0 
    
    Name.s=LibraryFunctionName() 
    Addr=GetProcAddress_(Inst,Name) 
    
    Param=GetNumberOfParam(Addr) 
    BadName=BadName(Name) 
    
    
    If DisplayErrors    
      If Param=-1 
        Text$="Falsche Parameteranzahl bei der Funktion "+Name+" ."+Chr(13) 
        Text$=Text$+"Möchten sie die Anzahl der Parameter manuell eingeben ?" 
        If MessageRequester("Fehler",Text$,#MB_YESNO)=#IDYES 
          Param=Val(InputRequester(LibraryFunctionName()+":","Parameteranzahl","0")) 
        EndIf 
      EndIf 
      
      If BadName 
        Text$="Es wird nicht empfohlen, die Funktion "+Name.s+" zu exportieren."+Chr(13) 
        Text$=Text$+"Soll sie dennoch exportiert werden ?" 
        If MessageRequester("Frage",Text$,#MB_YESNO)=#IDYES:BadName=0:EndIf 
      EndIf 
      
    EndIf 
    
    If BadName=0 And Param>=0 
      WriteStringN(1, Name+" "+Str(Param)) 
      Anz+1 
    EndIf 
    AnzGes+1 
  Wend 
Else 
  
  MessageRequester("Fehler","Die DLL "+DLL+" konnte nicht überprüft werden.") 
  End 
EndIf 

CloseLibrary(1) 
CloseFile(1) 
MessageRequester("Information:",Pbl+" wurde erfolgreich erstellt."+Chr(13)+Str(Anz)+"/"+Str(AnzGes)+" Funktionen exportiert.",#MB_ICONINFORMATION) 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger
