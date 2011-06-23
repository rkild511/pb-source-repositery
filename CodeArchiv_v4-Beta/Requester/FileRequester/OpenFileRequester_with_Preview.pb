; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3124&highlight=
; Author: Andreas (updated for PB4.00 by blbltheworm + Andre)
; Date: 13. December 2003
; OS: Windows
; Demo: No


; 20. July 2006: zweites Image und entsprechende Zeilen hinzugefügt von blbltheworm

  ;################################## 
  ;OpenFileRequester mit Vorschaubild 
  ;################################## 
  ;Andreas * Dezember 2003 
  ;################################## 

  UseTIFFImageDecoder() 
  UseJPEGImageDecoder() 
  UseTGAImageDecoder() 
  UsePNGImageDecoder() 
  
  #OpenFileButtonGadget = 1 
  #QuitButtonGadget = 2 
  
  #CDN_FIRST = (-601) 
  #CDN_SELCHANGE = (#CDN_FIRST - 1) 
  
  Structure OFNOTIFY  
  hdr.NMHDR 
  lpOFN.OPENFILENAME 
  pszFile.l 
  EndStructure 
  
  
  Procedure OFHookProc(hdlg,uiMsg,wParam,lParam) 
    ;hier wird der Dialog manipuliert 
    Shared newwidth.l,newheight.l,Image.l 
    Result = #False 
    Select uiMsg 
      Case #WM_NOTIFY 
        *of.OFNOTIFY = lParam 
        If *of\hdr\code = #CDN_SELCHANGE;neue Auswahl 
          Buffer$ = Space(260) 
          SendMessage_(GetParent_(hdlg),#CDM_GETFILEPATH,260,Buffer$);Filename und Pfad auslesen 
          SetCursor_(LoadCursor_(0,#IDC_WAIT)) 
          Image = LoadImage(0,Buffer$);Bild laden und Grösse für Vorschau berechnen 
          If Image <> 0 
            width = ImageWidth(0) 
            height = ImageHeight(0) 
            If width > 200 Or height > 200 
            f.f = width / height 
            If width > 200 
              newwidth = 200 
              newheight = newwidth/f 
            EndIf 
            If newheight > 200 
              newheight = 200 
              newwidth  = newheight*f 
            EndIf 
            Else 
            newwidth = width 
            newheight = height 
            EndIf 
            ImageX = 520 - newwidth/2 
            ImageY = 130 - newheight/2 
            ResizeImage(0, newwidth,newheight);Bild neu dimensionieren 
            StartDrawing(ImageOutput(1))
              Box(0,0,200,200,0)
              DrawImage(ImageID(0),(200-newwidth)/2 ,(200-newheight)/2) 
            StopDrawing()
            SetGadgetState(2,ImageID(1))
            SetGadgetText(1,Str(width)+" X "+Str(height)+" Pixel") 
            RedrawWindow_(GadgetID(2),0,0,#RDW_INVALIDATE) 
            SetCursor_(LoadCursor_(0,#IDC_ARROW)) 
          Else
            StartDrawing(ImageOutput(1)) 
              FrontColor(RGB(0,0,0)) 
              FillArea(1,1,1) 
              LineXY(0,0,200,200,RGB(255,0,0)) 
              LineXY(0,200,200,0,RGB(255,0,0)) 
              FrontColor(RGB(255,255,255)) 
              BackColor(RGB(0,0,0)) 
              DrawText(50,90,"keine Vorschau") 
            StopDrawing() 
            ImageX = 520 -100 
            ImageY = 130 -100 
            SetGadgetState(2,ImageID(1))
            SetGadgetText(1,"") 
            RedrawWindow_(GadgetID(2),0,0,#RDW_INVALIDATE) 
          EndIf 
        EndIf  
        Result = #True 
      Case #WM_INITDIALOG 
        ;Dialog erweitern 
        GetWindowRect_(GetParent_(hdlg),wr.RECT) 
        GetWindowRect_(GetDesktopWindow_(),wr1.RECT) 
        MoveWindow_(GetParent_(hdlg),wr1\right/2-(wr\right+210)/2,wr1\bottom/2-(wr\bottom)/2,wr\right+210,wr\bottom,#True) 
        CreateGadgetList(GetParent_(hdlg)) 
        TextGadget(0,417,6,206,20," Vorschau :",#PB_Text_Border) 
        TextGadget(1,417,234,206,20,"",#PB_Text_Border|#PB_Text_Center) 
        Frame3DGadget(3, 417,27,206,205,"",#PB_Frame3D_Double  ) 
        ImageGadget(2, 420, 30, 200,200,0) 
        CreateImage(1,200,200)
        Result = #True 
    EndSelect 
    ProcedureReturn Result 
  EndProcedure 
  
  Procedure.s PB_OpenFile() 
    ;OPENFILENAME-Struktur füllen 
    *FileBuffer = AllocateMemory(#MAX_PATH) 
    Result.s = "" 
    Part1.s = "all supported Files" 
    Part2.s = "*.bmp;*jpg;*tif;*tga;*png" 
    *Pattern = AllocateMemory(Len(Part1+Part2)+2) 
    PokeS(*Pattern,Part1) 
    PokeS(*Pattern+(Len(Part1)+1),Part2) 
    of.OPENFILENAME 
    of\lStructSize = SizeOf(OPENFILENAME) 
    of\flags = #OFN_EXPLORER|#OFN_ENABLEHOOK 
    of\lpstrFilter = *Pattern 
    of\nMaxFile = #MAX_PATH 
    of\lpstrFile = *FileBuffer 
    of\lpfnHook = @OFHookProc() 
    If GetOpenFileName_(of);Dialog aufrufen 
      Result = PeekS(*FileBuffer);wenn OK dann Filenamen auslesen 
    EndIf  
    FreeMemory(*Pattern) 
    FreeMemory(*FileBuffer) 
    ProcedureReturn Result 
  EndProcedure 
  
  If OpenWindow(0,0,0,270,220,"Preview-Sample",#PB_Window_SystemMenu|#PB_Window_ScreenCentered) And CreateGadgetList(WindowID(0)) 
    ButtonGadget(#OpenFileButtonGadget, 10, 10,80,20,"OpenFile") 
    ButtonGadget(#QuitButtonGadget, 10, 40,80,20,"Quit") 
    Repeat 
      EventID.l = WaitWindowEvent() 
      If EventID = #PB_Event_Gadget 
        Select EventGadget() 
          Case #OpenFileButtonGadget 
            opf.s = PB_OpenFile() 
            If opf 
              MessageRequester("File :",opf,0) 
            EndIf 
          Case #QuitButtonGadget 
            SendMessage_(WindowID(0),#WM_CLOSE,0,0) 
        EndSelect  
      EndIf    
    Until EventID = #PB_Event_CloseWindow 
  EndIf 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP
; DisableDebugger