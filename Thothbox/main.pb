; Thothbox
; gui :Yann LEBRUN / Thyphoon
; svn : J)sahel Benoist / Djes
; web : GallyHC
; GoScintilla : Srod
; Purebasic tools Configuration
; arguments -send "%FILE"

#prg_name$="Thothbox"
#prg_version$="0.1"


#INCLUDEINPROJECT=#True ; to inform some include file to not compile exemple !(exemple http.pbi)
InitNetwork()

;create a directory to download files this directory willbe erase when you quit

XIncludeFile "http.pbi"

DisableExplicit ; disable because GoScintilla is not EnableExplicit compatible
IncludePath "GoScintilla_PB4.4"
XIncludeFile "GoScintilla.pbi"
IncludePath ".\"
EnableExplicit

UsePNGImageDecoder()
UseJPEGImageDecoder()

Structure TPEPCXHEADER
  bytManufactor.b
  bytVersion.b
  bytEncoding.b
  bytBitsPerPixel.b
  intXMin.w
  intYMin.w
  intXMax.w
  intYMax.w
  intHDPI.w
  intVDPI.w
  bytColorMap.b[48]
  bytReserved.b
  bytNPlanes.b
  intBytesPerline.w
  intpalette_info.w
  bytFiller.b[58]
EndStructure
Structure TPEPALLETS
  bytColorR.a
  bytColorG.a
  bytColorB.a
EndStructure
;}

; ****************************************************************************
; ****************************************************************************
; ****************************************************************************
; ****************************************************************************

; +--------------------------------------------------------------------------+
; |                                                                          |
; +--------------------------------------------------------------------------+

Procedure.i LoadPCX(Image.i,Filename.s)
  Protected i.l
  Protected j.l
  Protected k.l
  Protected file.l
  Protected bdata.a
  Protected llenx.l
  Protected lleny.l
  Protected ltemp.l
  Protected lcount.l
  Protected lfllen.l
  Protected lOffset.l
  Protected Dim Raw.a(0)
  Protected Dim Pallets.TPEPALLETS(255)
  Protected header.TPEPCXHEADER
  Protected result.i

  file = ReadFile(#PB_Any, Filename)
  If file
    lfllen = Lof(file)
    ReadData(file, header, SizeOf(header))
    k = lfllen - SizeOf(header) - 768
    If k <= 0 Or k => lfllen
      CloseFile(file)
      ProcedureReturn #False
    EndIf
    ReDim Raw(k)
    ReadData(file, Raw(), k)
    FileSeek(file, lfllen - 768)
    ReadData(file, Pallets(), 768)
    CloseFile(file)
    If ((header\bytManufactor = 10) Or (header\bytVersion = 5) Or (header\bytEncoding = 1) Or (header\bytNPlanes = 1) Or (header\bytBitsPerPixel = 8))
      i = 0
      llenx = header\intBytesPerline
      lleny = header\intYMax - header\intYMin + 1
      ltemp = lleny
      result = CreateImage(Image, llenx, lleny)
      If result
        If StartDrawing(ImageOutput(Image))
          While ltemp
            lOffset = 0
            ltemp - 1
            j = (lleny - ltemp) * llenx
            While (lOffset < llenx)
              bdata = Raw(i)
              i + 1
              If (bdata & 192) = 192
                lcount  = bdata & 63
                lOffset   + lcount
                bdata     = Raw(i)
                i + 1
                While lcount
                  lcount - 1
                  Plot(j % llenx, (j / llenx) - 1, RGB(Pallets(bdata)\bytColorR, Pallets(bdata)\bytColorG, Pallets(bdata)\bytColorB))
                  j + 1
                Wend
              Else
                Plot(j % llenx, (j / llenx) - 1, RGB(Pallets(bdata)\bytColorR, Pallets(bdata)\bytColorG, Pallets(bdata)\bytColorB))
                lOffset + 1
                j + 1
              EndIf
            Wend
          Wend
          StopDrawing()
          ProcedureReturn Image
        EndIf
      EndIf
    EndIf
  EndIf
  ;
EndProcedure

;Initialise the Scintilla library for Windows.
CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
  ;try to found Scintilla.dll
  Procedure.s findScintillaDll(path.s)
    Protected ex.i,find.s
    ex=ExamineDirectory(#PB_Any, path, "*.*") 
    If ex
      While NextDirectoryEntry(ex)
        If DirectoryEntryType(ex) = #PB_DirectoryEntry_File And DirectoryEntryName(ex)="Scintilla.dll"
          ProcedureReturn path+DirectoryEntryName(ex)
        ElseIf DirectoryEntryName(ex)<>"." And DirectoryEntryName(ex)<>".."
          find=findScintillaDll(path+DirectoryEntryName(ex)+"\")
          If find<>"" 
            ProcedureReturn find
          EndIf
        EndIf
      Wend
      FinishDirectory(ex)
     EndIf
   ProcedureReturn ""
 EndProcedure
 
  Define path.s;="C:\Program Files (x86)\PureBasic\Compilers\Scintilla.dll"
  path=findScintillaDll(GetCurrentDirectory())
  If InitScintilla(path)=0
    MessageRequester("ERROR", "No found Scintilla.dll", #PB_MessageRequester_Ok)
    End
  EndIf
CompilerEndIf

Enumeration
  #win_Main
  #win_Wait
EndEnumeration

;mode and gadget
Enumeration
  
  #mode_searchWindow;mode 0 search window
  #gdt_logo
  #gdt_version
  #gdt_OffOnLine
  #gdt_searchTxt
  #gdt_search
  #gdt_result
  #mode_viewWindow;mode 1 view window
  #gdt_backSearch
  #gdt_titleTxt
  #gdt_title
  #gdt_authorTxt
  #gdt_author
  #gdt_compile
  #gdt_tab
  #gdt_code
  #gdt_historic
  #mode_prefsWindow
  #gdt_prefsBack
  #gdt_prefsServer
  #gdt_prefsServerTxt
  #gdt_prefsServerTest
  #gdt_prefsLanguage
  #gdt_poxyFrame
  #gdt_usePoxy
  #gdt_poxyHost
  #gdt_poxyHostTxt
  #gdt_poxyPort
  #gdt_poxyPortTxt
  #gdt_poxyLogin
  #gdt_poxyLoginTxt
  #gdt_poxyPassword
  #gdt_poxyPasswordTxt
  ;for #win_Wait
  #gdt_waitTxt
  #gdt_end
EndEnumeration

Structure fileslist
  id.i
  filename.s
  lenght.i
EndStructure

Structure threadinfo
  thread.i
  type.b  ;see thread enumeration
EndStructure

Enumeration
  #thrd_firstServerCall
  #thrd_serverCall
  #thrd_serverSearch
  #thrd_serverGetResult
EndEnumeration

#ThreadTimer=100 ; it's timer to check when Thread is finish

Structure globalParameters
  page.l
  language.s
  server.s
  useProxy.b        ;#True or #False if you want to use proxy setting
  proxy.HTTP_Proxy
  List thread.threadinfo()
  threadCheckServer.i
  onOffLine.b
  Map serverInfos.s()
  codeid.i
  List file.fileslist()
  downloadDirectory.s
EndStructure
Global gp.globalParameters

gp\page=#mode_searchWindow
gp\downloadDirectory=GetTemporaryDirectory()+"ThothBox"
If FileSize(gp\downloadDirectory)<>-2
 CreateDirectory(gp\downloadDirectory)
EndIf


Procedure thothboxThread(*callfunction,type.b,value.i=0)
  AddElement(gp\thread())
  gp\thread()\thread=CreateThread(*callfunction,value) 
  gp\thread()\type=type
  If ListSize(gp\thread())=1
    AddWindowTimer(#win_Main, #ThreadTimer, 250)
  EndIf
EndProcedure

XIncludeFile "translator.pbi"


XIncludeFile "preferences.pbi"
LoadPreferences()

XIncludeFile "network.pbi"

;some macro to help to desgin window
;to put a new gadget under
Macro GdtDown(_gdt)
  GadgetY(_gdt)+GadgetHeight(_gdt)
EndMacro

;to put a new gadget at the right 
Macro GdtRight(_gdt)
  GadgetX(_gdt)+GadgetWidth(_gdt)
EndMacro

;to color the selected item
Macro ColorSetGadgetState(__Gdt,__state)
  Protected i.l ;for the loop
  SetGadgetState(__Gdt,__state)
  ;Thanks falsam
  For i=0 To CountGadgetItems(__Gdt)
    If i=GetGadgetState(__Gdt)
      SetGadgetItemColor(__Gdt, i, #PB_Gadget_BackColor, #Yellow)
    Else
      SetGadgetItemColor(__Gdt, i, #PB_Gadget_BackColor, #White) 
    EndIf 
  Next i
EndMacro
#gdtH=20  ;Gadget height
#gdtW=10  ;space after a Gadget

IncludeFile "tab.pbi"



If OpenWindow(#win_Main, 100, 200, 800, 600, #prg_name$+" version "+#prg_version$, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
  ;-menu
  If CreateImageMenu(#win_Main, WindowID(#win_Main),#PB_Menu_ModernLook)
    MenuTitle("?")
    MenuItem(0, t("About"))
    MenuItem(1, t("Preferences"))
    MenuTitle("")
  EndIf
  
  AddKeyboardShortcut(#win_Main, #PB_Shortcut_Return, 1000)
  ;-mode_searchWindow Gadgets
  ContainerGadget(#mode_searchWindow,-WindowWidth(#win_Main),0,WindowWidth(#win_Main),WindowHeight(#win_Main))
  CatchImage(0,?Logo)
  CatchImage(1,?OnLine)
  CatchImage(2,?OffLine)
  ImageGadget(#gdt_logo,0,0,200,50,ImageID(0))
  ImageGadget(#gdt_OffOnLine,16,16,32,32,ImageID(1))
  StringGadget(#gdt_search,0,0,250,#gdtH,"")
  TextGadget(#gdt_version,0,0,100,#gdtH,t("version")+" "+#prg_version$)
  TextGadget(#gdt_searchTxt,0,0,100,#gdtH,  t("search"))
  If LoadFont(0, "Arial", 16)
    SetGadgetFont(#gdt_searchTxt, FontID(0))   ; Set the loaded Arial 16 font as new standard
  EndIf
  ListIconGadget(#gdt_result,  0,  0, 300, 300, t("Name"), 300,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
  GadgetToolTip(#gdt_result, "choose to see code and information")
  AddGadgetColumn(#gdt_result, 1, t("Category"), 100)
  AddGadgetColumn(#gdt_result, 2, t("Platform"), 250)
  CloseGadgetList()
  ;-mode_viewWindow Gadgets
  ContainerGadget(#mode_viewWindow,-WindowWidth(#win_Main)*2,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
  TextGadget(#gdt_titleTxt,50,50,50,#gdtH,t("Title")+":")
  StringGadget(#gdt_title,GdtRight(#gdt_titleTxt),GadgetY(#gdt_titleTxt),250,#gdtH,"http download memorie")
  
  TextGadget(#gdt_authorTxt,GadgetX(#gdt_titleTxt),GdtDown(#gdt_titleTxt)+10,50,#gdtH,t("Author")+" :")
  StringGadget(#gdt_author,GdtRight(#gdt_authorTxt),GadgetY(#gdt_authorTxt),250,#gdtH,"Bidule")
  
  ButtonGadget(#gdt_backSearch,0,0,100,#gdtH,"Back")
  PanelGadget(#gdt_tab, 10, 10, 580, 580)
  CloseGadgetList()

 
  ButtonGadget(#gdt_compile,GadgetX(#gdt_tab),GadgetY(#gdt_tab)-20,100,20,"Compile this code")
  ListIconGadget(#gdt_historic,  0,  0, 300, 300, "Date", 75,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
  AddGadgetColumn(#gdt_historic, 1, "Author", 75)
  AddGadgetColumn(#gdt_historic, 2, "Comment", 145)
  AddGadgetItem(#gdt_historic,0,"2011/10/01"+Chr(10)+"Thyphoon"+Chr(10)+"Pb 4.60 compatible code")
  AddGadgetItem(#gdt_historic,1,"2007/12/03"+Chr(10)+"Bidule"+Chr(10)+"Pb 4.00 compatible code")
  AddGadgetItem(#gdt_historic,2,"2004/17/02"+Chr(10)+"Bidule"+Chr(10)+"optimized code")
  AddGadgetItem(#gdt_historic,3,"2004/16/02"+Chr(10)+"Bidule"+Chr(10)+"Pb 3.95 code")
  CloseGadgetList()
  
  ;-mode_prefsWindow Gadgets
  ContainerGadget(#mode_prefsWindow,-WindowWidth(#win_Main)*3,0,WindowWidth(0),WindowHeight(0))
  ButtonGadget(#gdt_prefsback,0,0,100,#gdtH,"Back")

  TextGadget(#gdt_prefsServerTxt,10,GdtDown(#gdt_prefsback)+#gdtH,50,#gdtH,t("Server"))
  StringGadget(#gdt_prefsServer,GdtRight(#gdt_prefsServerTxt),GadgetY(#gdt_prefsServerTxt),250,#gdtH,"")
  ButtonGadget(#gdt_prefsServerTest,GdtRight(#gdt_prefsServer)+#gdtH,GadgetY(#gdt_prefsServerTxt),60,#gdtH,t("Test"))
  ComboBoxGadget(#gdt_prefsLanguage,GdtRight(#gdt_prefsServerTest)+#gdtH,GadgetY(#gdt_prefsServerTest),200,20)
  Frame3DGadget(#gdt_poxyFrame, 10, GdtDown(#gdt_prefsServerTxt)+#gdtH, 400, 150, t("Network"))
  CheckBoxGadget(#gdt_usePoxy, GadgetX(#gdt_poxyFrame)+10,  GadgetY(#gdt_poxyFrame)+#gdtH, 250, #gdtH, t("Use a Proxy"))
  TextGadget(#gdt_poxyHostTxt,GadgetX(#gdt_usePoxy),GdtDown(#gdt_usePoxy)+#gdtH,75,20,t("Proxy HTTP")+" :")
  StringGadget(#gdt_poxyHost,GdtRight(#gdt_poxyHostTxt),GadgetY(#gdt_poxyHostTxt),200,25,"")
  TextGadget(#gdt_poxyPortTxt,GdtRight(#gdt_poxyHost)+10,GadgetY(#gdt_poxyHost),30,#gdtH,t("Port")+" :")
  SpinGadget(#gdt_poxyPort,GdtRight(#gdt_poxyPortTxt),GadgetY(#gdt_poxyPortTxt),50,#gdtH,0,9999,#PB_Spin_Numeric)
  TextGadget(#gdt_poxyLoginTxt,GadgetX(#gdt_usePoxy),GdtDown(#gdt_poxyHostTxt)+#gdtH,50,#gdtH,t("Login")+" :")
  StringGadget(#gdt_poxyLogin,GdtRight(#gdt_poxyLoginTxt),GadgetY(#gdt_poxyLoginTxt),130,#gdtH,"")
  TextGadget(#gdt_poxyPasswordTxt,GdtRight(#gdt_poxyLogin)+10,GadgetY(#gdt_poxyLogin),50,#gdtH,t("Password")+" :")
  StringGadget(#gdt_poxyPassword,GdtRight(#gdt_poxyPasswordTxt),GadgetY(#gdt_poxyPasswordTxt),130,#gdtH,"")
  CloseGadgetList()
EndIf

Procedure LoadLanguage()
  Debug "Load Language:"+gp\language
  Translator_destroy()
  Translator_init("locale\", gp\language)
  ;-langue searchWindow
  SetMenuItemText(#win_Main, 0, t("About"))
  SetMenuItemText(#win_Main, 1,t("Preferences"))
  SetGadgetText(#gdt_version,t("version")+" "+#prg_version$)
  SetGadgetText(#gdt_searchTxt,t("search"))
  SetGadgetItemText(#gdt_result, -1, t("Name") ,0)
  SetGadgetItemText(#gdt_result, -1, t("Category") ,1)
  SetGadgetItemText(#gdt_result, -1, t("Platform") ,2)
  GadgetToolTip(#gdt_result, t("choose to see code and information"))
  ;-langue viewWindow
  SetGadgetText(#gdt_titleTxt,t("Title")+":")
  SetGadgetText(#gdt_authorTxt,t("Author")+" :")
  ;-langue prefsWindow 
  SetGadgetText(#gdt_prefsback,t("Back"))
  SetGadgetText(#gdt_prefsServerTxt,t("Server"))
  SetGadgetText(#gdt_prefsServerTest,t("Test"))
  SetGadgetText(#gdt_poxyFrame, t("Network"))
  SetGadgetText(#gdt_usePoxy, t("Use a Proxy"))
  SetGadgetText(#gdt_poxyHostTxt,t("Proxy HTTP")+" :")
  SetGadgetText(#gdt_poxyPortTxt,t("Port")+" :")
  SetGadgetText(#gdt_poxyLoginTxt,t("Login")+" :")
  SetGadgetText(#gdt_poxyPasswordTxt,t("Password")+" :")

EndProcedure

Procedure refreachWindow(mode.l)
  Protected hide.b,tmpX.l,tmpY.l,tmpH.l,tmpW.l
  ;-mode_searchWindow Resize
  ResizeGadget(#mode_searchWindow,0,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
  ResizeGadget(#mode_searchWindow,0,0,WindowWidth(0),WindowHeight(0))
  ResizeGadget(#gdt_logo,(WindowWidth(0)-ImageWidth(0))/2,#gdtH,#PB_Ignore,#PB_Ignore)
  ResizeGadget(#gdt_version,(WindowWidth(0)-ImageWidth(0))/2+ImageWidth(0)+10,GdtDown(#gdt_logo)-#gdtH,#PB_Ignore,#PB_Ignore)
  tmpX=(WindowWidth(0)-GadgetWidth(#gdt_searchTxt)-GadgetWidth(#gdt_search))/2
  ResizeGadget(#gdt_searchtxt,tmpX,GdtDown(#gdt_logo)+#gdtH,#PB_Ignore,#PB_Ignore)
  ResizeGadget(#gdt_search,tmpX+GadgetWidth(#gdt_searchTxt),GadgetY(#gdt_searchtxt),#PB_Ignore,#PB_Ignore)
  tmpY=GdtDown(#gdt_search)+50
  tmpH=WindowHeight(0)-tmpY-50
  ResizeGadget(#gdt_result,50,tmpY,WindowWidth(0)-100,tmpH)
  
  ;-mode_viewWindow Resize
  ResizeGadget(#mode_viewWindow,0,0,WindowWidth(0),WindowHeight(0))
  ResizeGadget(#gdt_tab,50,150,WindowWidth(0)-100,WindowHeight(0)-200)
  ResizeGadget(#gdt_compile,GadgetX(#gdt_tab),GadgetY(#gdt_tab)-20,100,#gdtH)
  ResizeGadget(#gdt_historic,WindowWidth(0)-GadgetWidth(#gdt_historic)-50,50,#PB_Ignore,GadgetY(#gdt_tab)-GadgetY(#gdt_historic))
  
  Select mode
    Case #mode_searchWindow
      ResizeGadget(#mode_searchWindow,0,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_viewWindow,WindowWidth(#win_Main),0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_prefsWindow,WindowWidth(#win_Main)*2,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ;HideGadget(#mode_viewWindow,#True)
      ;HideGadget(#mode_searchWindow,#False)
      ;HideGadget(#mode_prefsWindow,#True)
    Case #mode_viewWindow
      ResizeGadget(#mode_viewWindow,0,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_searchWindow,WindowWidth(#win_Main),0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_prefsWindow,WindowWidth(#win_Main)*2,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      
      ;HideGadget(#mode_viewWindow,#False)
      ;HideGadget(#mode_searchWindow,#True)
      ;HideGadget(#mode_prefsWindow,#True)
      ColorSetGadgetState(#gdt_historic,0)
    ;Case #mode_submitWindow
    ;  HideGadget(#mode_viewWindow,#False)
    ;  HideGadget(#mode_searchWindow,#True)
    ;  HideGadget(#mode_prefsWindow,#True)
    ;  HideGadget(#mo
  Case #mode_prefsWindow
      ResizeGadget(#mode_prefsWindow,0,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_searchWindow,WindowWidth(#win_Main),0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ResizeGadget(#mode_viewWindow,WindowWidth(#win_Main)*2,0,WindowWidth(#win_Main),WindowHeight(#win_Main))
      ;HideGadget(#mode_viewWindow,#True)
      ;HideGadget(#mode_searchWindow,#True)
      ;HideGadget(#mode_prefsWindow,#False)
  EndSelect
  
EndProcedure

Procedure commitNewCode(file.s)
  Protected txt.s,format.l
  If FileSize(file)>0 And (LCase(GetExtensionPart(file))="pb" Or LCase(GetExtensionPart(file))="pbi")
    
    If ReadFile(0,file)
      format=ReadStringFormat(0)
      txt=""
      While Eof(0) = 0 ; loop as long the 'end of file' isn't reached
        If format=#PB_Ascii Or format=#PB_UTF8 Or format=#PB_Unicode
            txt=txt+ReadString(0,format)+ #CRLF$
        EndIf
      Wend
      CloseFile(0)
      GOSCI_SetText(#gdt_code, txt)
      gp\page=#mode_viewWindow

      SetGadgetText(#gdt_title,"")
      SetGadgetText(#gdt_author,"")
      ClearGadgetItems(#gdt_historic)
    EndIf
  Else
    MessageRequester("Error", "Read file error :"+#LFCR$+file, #PB_MessageRequester_Ok)
  EndIf
EndProcedure

;White background for a smart rendering !
;SetGadgetColor(#mode_searchWindow,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#mode_viewWindow,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#mode_prefsWindow,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#gdt_searchtxt,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#gdt_titleTxt,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#gdt_authorTxt,#PB_Gadget_BackColor,#White)
;SetGadgetColor(#gdt_version,#PB_Gadget_BackColor,#White)
Define event.l,quit.b=#False,file.s,z.l
For z=#mode_searchWindow To #gdt_end-1
  If IsGadget(z)
    ;SetGadgetColor(z,#PB_Gadget_BackColor,#White)
    ;SetGadgetColor(z,#PB_Gadget_TitleBackColor,#White)
  EndIf
Next

LoadLanguage()
InitGadgets() 
;Check if server is Online
thothboxThread(@threadCheckServer(),#thrd_firstServerCall)

;-Parse input parameters
z=0
While z<CountProgramParameters()-1
  If Left(ProgramParameter(z),1)="-" And Left(ProgramParameter(z+1),1)<>"-"
    Select LCase(ProgramParameter(z))
      Case "-send"
        z+1
        commitNewCode(ProgramParameter(z))
    EndSelect
  EndIf
  z+1
Wend
Repeat
  event = WaitWindowEvent()
  
  Select event
    Case #PB_Event_Timer 
      Define infotxt.s,type.i
      ;-End Thread Control
      If EventTimer() = #ThreadTimer
        gp\onOffLine=1-gp\onOffLine
        SetGadgetState(#gdt_OffOnLine,ImageID(gp\onOffLine+1))
        infotxt=GetMenuTitleText(#win_Main,1)
        If Len(infotxt)>4
          infotxt="";
        Else
          infotxt+"."
        EndIf
        SetMenuTitleText(#win_Main,1,infotxt)
        
        ForEach gp\thread()
          If IsThread(gp\thread()\thread)=0
            type=gp\thread()\type
            DeleteElement(gp\thread())
            Select type
              Case #thrd_firstServerCall
                
                thothboxThread(@threadServerSearch(),#thrd_serverSearch)
                ;Else
                ;  MessageRequester("Server ERROR","we have a problem to connect server")
                ;  gp\page=#mode_prefsWindow
                ;  refreachWindow(gp\page)
                ;EndIf
              Case  #thrd_serverCall
              Case #thrd_serverSearch
              Case #thrd_serverGetResult
                initTabCode()
                DisableGadget(#mode_viewWindow,0)
            EndSelect
            
            If ListSize(gp\thread())=0
              RemoveWindowTimer(0, #ThreadTimer)
              SetMenuTitleText(#win_Main,1,"")
            EndIf
          EndIf
        Next
        
        
      EndIf
    Case #PB_Event_SizeWindow
      refreachWindow(gp\page) ;resize all gadget
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case 0
          Define txt.s
          txt.s=#prg_name$+" version "+#prg_version$+#LFCR$
          txt+"Jean-Yves LERICQUE/ GallyHC"+#LFCR$
          txt+"Jesahel BENOIST / Djes"+#LFCR$
          txt+"Yann LEBRUN / Thyphoon"+#LFCR$
          txt+#LFCR$
          txt+"thanks to"+#LFCR$
          txt+"srdo : GoScintilla"+#LFCR$
          txt+"Fred Laboureur : Purebasic"+#LFCR$
          MessageRequester("Information", txt.s, #PB_MessageRequester_Ok)
        Case 1
          gp\page=#mode_prefsWindow
          refreachWindow(gp\page)
        Case 1000 ;Return keyshort
          Select GetActiveGadget()
            Case #gdt_search
              thothboxThread(@threadServerSearch(),#thrd_serverSearch)
          EndSelect
      EndSelect
    Case #PB_Event_Gadget 
      
      Select EventGadget()
          ;- Event searchWindow
        Case #gdt_OffOnLine
          gp\page=#mode_viewWindow
          refreachWindow(gp\page)
        Case #gdt_search
          If EventType()=#PB_EventType_LostFocus
            
            thothboxThread(@threadServerSearch(),#thrd_serverSearch)
          EndIf
        Case #gdt_result
          If EventType()=#PB_EventType_LeftClick 
            gp\codeid=GetGadgetItemData(#gdt_result,GetGadgetState(#gdt_result))
            SetGadgetText(#gdt_title,GetGadgetItemText(#gdt_result,GetGadgetState(#gdt_result),0))
            DisableGadget(#mode_viewWindow,1)
            clearTabcode()
            thothboxThread(@threadDownloadFiles(),#thrd_serverGetResult)
            gp\page=#mode_viewWindow
            refreachWindow(gp\page)
          EndIf
          
          ;- Event viewWindow  
        Case #gdt_historic
          
        Case #gdt_backSearch
          gp\page=#mode_searchWindow
          refreachWindow(gp\page)
          ;- Event prefsWindows
        Case #gdt_prefsback
          gp\page=#mode_searchWindow
          refreachWindow(gp\page)
          CreateThread(@SavePreferences(),0)
        Case #gdt_prefsServer
          If EventType()=#PB_EventType_LostFocus
            gp\server=GetGadgetText(#gdt_prefsServer)
          EndIf
        Case #gdt_prefsServerTest
          thothboxThread(@threadCheckServer(),#thrd_serverCall,#True)
        Case #gdt_prefsLanguage
          gp\language=GetGadgetText(#gdt_prefsLanguage)
          loadLanguage()
        Case #gdt_usePoxy
          If GetGadgetState(#gdt_usePoxy)=#PB_Checkbox_Checked
              gp\useProxy=#True
              SetGadgetState(#gdt_usePoxy, #PB_Checkbox_Checked)
              DisableGadget(#gdt_poxyHost,0)
              DisableGadget(#gdt_poxyPort,0)
              DisableGadget(#gdt_poxyLogin,0)
              DisableGadget(#gdt_poxyPassword,0)
            Else
              gp\useProxy=#False
              SetGadgetState(#gdt_usePoxy,#PB_Checkbox_Unchecked)
              DisableGadget(#gdt_poxyHost,1)
              DisableGadget(#gdt_poxyPort,1)
              DisableGadget(#gdt_poxyLogin,1)
              DisableGadget(#gdt_poxyPassword,1)
            EndIf
          Case #gdt_poxyHost
            If EventType()=#PB_EventType_LostFocus
              gp\proxy\host=GetGadgetText(#gdt_poxyHost)
            EndIf
          Case #gdt_poxyPort
            ;If EventType()=#PB_EventType_LostFocus
              gp\proxy\port=GetGadgetState(#gdt_poxyPort)
              Debug gp\proxy\port
            ;EndIf
          Case #gdt_poxyLogin
            If EventType()=#PB_EventType_LostFocus
              gp\proxy\login=GetGadgetText(#gdt_poxyLogin)
            EndIf
          Case #gdt_poxyPassword
            If EventType()=#PB_EventType_LostFocus
              gp\proxy\password=GetGadgetText(#gdt_poxyPassword)
            EndIf
        EndSelect
    Case #PB_Event_CloseWindow
      quit=1
  EndSelect
  
Until quit = 1

DeleteDirectory(gp\downloadDirectory, "", #PB_FileSystem_Recursive|#PB_FileSystem_Force)

End
DataSection
  Logo:
  IncludeBinary "gfx/thotbox.png"
  OnLine:
  IncludeBinary "gfx/serverOnline.png"
  OffLine:
  IncludeBinary "gfx/serverOffline.png"
EndDataSection 



; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 603
; FirstLine = 589
; Folding = --
; EnableUnicode
; EnableXP
; UseIcon = gfx\ibis.ico
; Executable = C:\Program Files (x86)\PureBasic\Thothbox.exe
; Compiler = PureBasic 4.60 Beta 3 (Windows - x86)