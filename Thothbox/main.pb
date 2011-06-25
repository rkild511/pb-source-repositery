; Thot
; gui :Yann LEBRUN / Thyphoon
; svn : Jésahel Benoist / Djes
; web : GallyHC
; GoScintilla : Srod

#prg_name$="Thothbox"
#prg_version$="0.1"
; MessageRequester("Information", GetCurrentDirectory(), #PB_MessageRequester_Ok)
; 
; If CreateFile(0, GetTemporaryDirectory()+#prg_name$+"_debug.txt") 
;     WriteStringN(0,GetEnvironmentVariable("PB_TOOL_Preferences"))
;     WriteStringN(0,"CountProgramParameters:"+Str(CountProgramParameters()))
;   For z=0 To CountProgramParameters()-1
;     WriteStringN(0,"-------------------------------")
;     WriteStringN(0,ProgramParameter(z))
;     
;   Next
;   CloseFile(0)
;   RunProgram(GetTemporaryDirectory()+#prg_name$+"_debug.txt")
;   
; EndIf
IncludePath "GoScintilla_PB4.4"
XIncludeFile "GoScintilla.pbi"

EnableExplicit
UsePNGImageDecoder()

;Initialise the Scintilla library for Windows.
CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
  InitScintilla()
CompilerEndIf

;mode and gadget
Enumeration
  #mode_searchWindow;mode 0 search window
  #gdt_logo
  #gdt_version
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
  #gdt_code
  #gdt_historic
  #mode_prefsWindow
EndEnumeration

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

If OpenWindow(0, 100, 200, 800, 600, #prg_name$+" version "+#prg_version$, #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget|#PB_Window_SizeGadget)
  ;-menu
  If CreateMenu(0, WindowID(0))
    MenuTitle("?")
      MenuItem(0, "About")

  EndIf

  ;-mode_searchWindow Gadgets
  ContainerGadget(#mode_searchWindow,0,0,WindowWidth(0),WindowHeight(0))
  CatchImage(0,?Logo)
  ImageGadget(#gdt_logo,0,0,200,50,ImageID(0))
  StringGadget(#gdt_search,0,0,250,25,"")
  TextGadget(#gdt_version,0,0,100,20,"version "+#prg_version$)
  TextGadget(#gdt_searchTxt,0,0,100,20,"Search")
  If LoadFont(0, "Arial", 16)
    SetGadgetFont(#gdt_searchTxt, FontID(0))   ; Set the loaded Arial 16 font as new standard
  EndIf
  ListIconGadget(#gdt_result,  0,  0, 300, 300, "Name", 300,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
  GadgetToolTip(#gdt_result, "choose to see code and information")
  AddGadgetColumn(#gdt_result, 1, "Category", 100)
  AddGadgetColumn(#gdt_result, 2, "Platform", 250)
  CloseGadgetList()
  ;-mode_viewWindow Gadgets
  ContainerGadget(#mode_viewWindow,0,0,WindowWidth(0),WindowHeight(0))
  TextGadget(#gdt_titleTxt,50,50,50,20,"Title :")
  StringGadget(#gdt_title,GdtRight(#gdt_titleTxt),GadgetY(#gdt_titleTxt),250,25,"http download memorie")
  
  TextGadget(#gdt_authorTxt,GadgetX(#gdt_titleTxt),GdtDown(#gdt_titleTxt)+10,50,20,"Author :")
  StringGadget(#gdt_author,GdtRight(#gdt_authorTxt),GadgetY(#gdt_authorTxt),250,25,"Bidule")
  
  ButtonGadget(#gdt_backSearch,0,0,100,20,"Back")
  GOSCI_Create(#gdt_code, 10, 10, 580, 580, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN|#GOSCI_ALLOWCODEFOLDING)
  
  ;Set the padding added to the width of the line-number margin.
  GOSCI_SetAttribute(#gdt_code, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)
  
  ;Set folding symbols margin width.
  GOSCI_SetMarginWidth(#gdt_code, #GOSCI_MARGINFOLDINGSYMBOLS, 24)
  
  ;Set the back color of the line containing the caret.
  GOSCI_SetColor(#gdt_code, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)
  
  ;Set font.
  GOSCI_SetFont(#gdt_code, "Courier New", 10)
  
  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
  GOSCI_SetTabs(#gdt_code, 2)
  
  ;Set styles for our syntax highlighting.
  ;=======================================
  ;First define some constants to identify our various styles.
  ;You can name these as we wish.
  Enumeration
    #STYLES_COMMANDS = 1
    #STYLES_COMMENTS
    #STYLES_LITERALSTRINGS
    #STYLES_NUMBERS
    #STYLES_CONSTANTS
    #STYLES_FUNCTIONS
  EndEnumeration
  
  ;Set individual styles for commands.
  GOSCI_SetStyleFont(#gdt_code, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
  GOSCI_SetStyleColors(#gdt_code, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.
  
  ;Set individual styles for comments.
  GOSCI_SetStyleFont(#gdt_code, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
  GOSCI_SetStyleColors(#gdt_code, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.
  
  ;Set individual styles for literal strings.
  GOSCI_SetStyleColors(#gdt_code, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.
  
  ;Set individual styles for numbers.
  GOSCI_SetStyleColors(#gdt_code, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.
  
  ;Set individual styles for constants.
  GOSCI_SetStyleColors(#gdt_code, #STYLES_CONSTANTS, $2193DE)  ;We have omitted the optional back color.
  
  ;Set individual styles for functions.
  GOSCI_SetStyleColors(#gdt_code, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.
  
  ;Set keywords for our syntax highlighting.
  ;=========================================
  ;First some commands.
  GOSCI_AddKeywords(#gdt_code, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)
  ;Now set up a ; symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
  ;Note also that this symbol will act as an additional separator.
  GOSCI_AddKeywords(#gdt_code, ";", #STYLES_COMMENTS, #GOSCI_DELIMITTOENDOFLINE)
  ;Now set up quotes to denote literal strings.
  ;We do this by passing the beginning and end delimiting characters; in this case both are quotation marks. Note the use of #GOSCI_DELIMITBETWEEN.
  ;Note also that a quote will subsequently act as an additional separator.
  GOSCI_AddKeywords(#gdt_code, Chr(34) + Chr(34), #STYLES_LITERALSTRINGS, #GOSCI_DELIMITBETWEEN)
  ;Now set up a # symbol to denote a constant. Note the use of #GOSCI_LEFTDELIMITWITHOUTWHITESPACE.
  GOSCI_AddKeywords(#gdt_code, "#", #STYLES_CONSTANTS, #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
  ;Now set up a ( symbol to denote a function. Note the use of #GOSCI_RIGHTDELIMITWITHWHITESPACE.
  GOSCI_AddKeywords(#gdt_code, "(", #STYLES_FUNCTIONS, #GOSCI_RIGHTDELIMITWITHWHITESPACE)
  ;We arrange for a ) symbol to match the coloring of the ( symbol.
  GOSCI_AddKeywords(#gdt_code, ")", #STYLES_FUNCTIONS)
  
  ;Add some folding keywords.
  GOSCI_AddKeywords(#gdt_code, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD|#GOSCI_DELIMITNONE)
  GOSCI_AddKeywords(#gdt_code, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD|#GOSCI_DELIMITNONE)
  
  
  ;Additional lexer options.
  ;=========================
  ;The lexer needs to know what separator characters we are using.
  GOSCI_SetLexerOption(#gdt_code, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
  ;We can also set a style for numbers.
  GOSCI_SetLexerOption(#gdt_code, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)
  ;}
  
  
  ;-Tmp
  Define text$;
  text$ = "; GoScintilla." + #CRLF$
  text$ + "; By Stephen Rodriguez." + #CRLF$ + #CRLF$
  text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
  text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
  text$ + #TAB$ + "Protected result" + #CRLF$
  text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
  text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
  text$ + "EndProcedure" + #CRLF$ + #CRLF$
  text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
  text$ + "End" + #CRLF$
  GOSCI_SetText(#gdt_code, text$)
  ;-End Tmp
  
  ButtonGadget(#gdt_compile,GadgetX(#gdt_code),GadgetY(#gdt_code)-20,100,20,"Compile this code")
  ListIconGadget(#gdt_historic,  0,  0, 300, 300, "Date", 75,#PB_ListIcon_FullRowSelect|#PB_ListIcon_GridLines)
  AddGadgetColumn(#gdt_historic, 1, "Author", 75)
  AddGadgetColumn(#gdt_historic, 2, "Comment", 145)
  AddGadgetItem(#gdt_historic,0,"2011/10/01"+Chr(10)+"Thyphoon"+Chr(10)+"Pb 4.60 compatible code")
  AddGadgetItem(#gdt_historic,1,"2007/12/03"+Chr(10)+"Bidule"+Chr(10)+"Pb 4.00 compatible code")
  AddGadgetItem(#gdt_historic,2,"2004/17/02"+Chr(10)+"Bidule"+Chr(10)+"optimized code")
  AddGadgetItem(#gdt_historic,3,"2004/16/02"+Chr(10)+"Bidule"+Chr(10)+"Pb 3.95 code")
  CloseGadgetList()
  ;-mode_prefsWindow
  ContainerGadget(#mode_prefsWindow,0,0,WindowWidth(0),WindowHeight(0))
  CloseGadgetList()
EndIf

Procedure refreachWindow(mode.l)
  Protected hide.b,tmpX.l,tmpY.l,tmpH.l,tmpW.l
  ;-mode_searchWindow Resize
  
  ResizeGadget(#mode_searchWindow,0,0,WindowWidth(0),WindowHeight(0))
  ResizeGadget(#gdt_logo,(WindowWidth(0)-ImageWidth(0))/2,20,#PB_Ignore,#PB_Ignore)
  ResizeGadget(#gdt_version,(WindowWidth(0)-ImageWidth(0))/2+ImageWidth(0)+10,GdtDown(#gdt_logo)-20,#PB_Ignore,#PB_Ignore)
  tmpX=(WindowWidth(0)-GadgetWidth(#gdt_searchTxt)-GadgetWidth(#gdt_search))/2
  ResizeGadget(#gdt_searchtxt,tmpX,GdtDown(#gdt_logo)+20,#PB_Ignore,#PB_Ignore)
  ResizeGadget(#gdt_search,tmpX+GadgetWidth(#gdt_searchTxt),GadgetY(#gdt_searchtxt),#PB_Ignore,#PB_Ignore)
  tmpY=GdtDown(#gdt_search)+50
  tmpH=WindowHeight(0)-tmpY-50
  ResizeGadget(#gdt_result,50,tmpY,WindowWidth(0)-100,tmpH)
  
  ;-mode_viewWindow Resize
  ResizeGadget(#mode_viewWindow,0,0,WindowWidth(0),WindowHeight(0))
  ResizeGadget(#gdt_code,50,150,WindowWidth(0)-100,WindowHeight(0)-200)
  ResizeGadget(#gdt_compile,GadgetX(#gdt_code),GadgetY(#gdt_code)-20,100,20)
  ResizeGadget(#gdt_historic,WindowWidth(0)-GadgetWidth(#gdt_historic)-50,50,#PB_Ignore,GadgetY(#gdt_code)-GadgetY(#gdt_historic))
  
  Select mode
    Case #mode_searchWindow
      HideGadget(#mode_viewWindow,#True)
      HideGadget(#mode_searchWindow,#False)
      HideGadget(#mode_prefsWindow,#True)
    Case #mode_viewWindow
      HideGadget(#mode_viewWindow,#False)
      HideGadget(#mode_searchWindow,#True)
      HideGadget(#mode_prefsWindow,#True)
      ColorSetGadgetState(#gdt_historic,0)
    Case #mode_prefsWindow
      HideGadget(#mode_viewWindow,#True)
      HideGadget(#mode_searchWindow,#True)
      HideGadget(#mode_prefsWindow,#False)
  EndSelect
  
EndProcedure

Procedure refreachResult()
  ClearGadgetItems(#gdt_result)
  AddGadgetItem(#gdt_result,-1,"http download memorie"+Chr(10)+"Network"+Chr(10)+"Windows/Linux/MacOs"+Chr(10)+"****")
  AddGadgetItem(#gdt_result,-1,"skin windows"+Chr(10)+"window"+Chr(10)+"Windows")
  AddGadgetItem(#gdt_result,-1,"Pathfinding A*"+Chr(10)+"Game 2D"+Chr(10)+"Windows/Linux/MacOs")
  AddGadgetItem(#gdt_result,-1,"Iso 3D maps"+Chr(10)+"Game 2D"+Chr(10)+"Windows/Linux/MacOs")
  AddGadgetItem(#gdt_result,-1,"get network name"+Chr(10)+"Network"+Chr(10)+"Windows")
  
EndProcedure  
SetGadgetColor(#mode_searchWindow,#PB_Gadget_BackColor,#White)
SetGadgetColor(#mode_viewWindow,#PB_Gadget_BackColor,#White)
SetGadgetColor(#mode_prefsWindow,#PB_Gadget_BackColor,#White)
SetGadgetColor(#gdt_searchtxt,#PB_Gadget_BackColor,#White)
SetGadgetColor(#gdt_titleTxt,#PB_Gadget_BackColor,#White)
SetGadgetColor(#gdt_authorTxt,#PB_Gadget_BackColor,#White)
SetGadgetColor(#gdt_version,#PB_Gadget_BackColor,#White)

Define event.l,quit.b=#False,page.l=#mode_searchWindow
Repeat
  event = WaitWindowEvent()
  
  Select event
    Case #PB_Event_SizeWindow
      refreachWindow(page) ;resize all gadget
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case 0
          Define txt.s
          txt.s=#prg_name$+" version "+#prg_version$+#LFCR$
          txt+"GallyHC"+#LFCR$
          txt+"Jésahel Benoist / Djes"+#LFCR$
          txt+"Yann LEBRUN / Thyphoon"+#LFCR$
          txt+#LFCR$
          txt+"thanks to"+#LFCR$
          txt+"srdo : GoScintilla"+#LFCR$
          txt+"Fred Laboureur : GoScintilla"+#LFCR$
          MessageRequester("Information", txt.s, #PB_MessageRequester_Ok)

      EndSelect
    Case #PB_Event_Gadget 
      
      Select EventGadget()
          ;- Event searchWindow
        Case #gdt_search
          If EventType()=#PB_EventType_Change
            refreachResult() ;refreach result gadget
          EndIf
        Case #gdt_result
          page=#mode_viewWindow
          refreachWindow(page)
          
          ;- Event viewWindow  
        Case #gdt_backSearch
          page=#mode_searchWindow
          refreachWindow(page)
      EndSelect
    Case #PB_Event_CloseWindow
      quit=1
  EndSelect
  
Until quit = 1
DataSection
  Logo:
  IncludeBinary "../gfx/thotbox.png"
EndDataSection 



; IDE Options = PureBasic 4.60 Beta 3 (Windows - x86)
; CursorPosition = 85
; FirstLine = 57
; Folding = -
; EnableXP
; UseIcon = ibis.ico
; Executable = C:\Program Files (x86)\PureBasic\Thothbox.exe
; Compiler = PureBasic 4.60 Beta 3 (Windows - x86)