; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=3325&highlight=
; Author: Mischa (updated for PB4.00 by blbltheworm)
; Date: 04. January 2004
; OS: Windows
; Demo: No


; Creates a .pbi file in the directory of a bitmap, which should
; be used as skin/backgroudn for a window...
; The created .pbi file will contain the calculated window mask data
; as well include the converted bitmap (into .png format).
; Note: an example for using the created .pbi file can be found at
; "WindowSkin_Example.pb" !

; Erstellt eine .pbi Datei im Verzeichnis einer Bitmap, die als
; Hintergrundbild/Skin fürs Fenster fungieren soll. 
; Innerhalb der erstellten .pbi Datei befinden sich die berechneten
; Fenster-Masken Daten. 
; Außerdem wird dort die zuvor als .png konvertierte Bitmap inkludiert. 
; So hat man mit einem Abwasch die Maske und den Fensterhintergrund 
; gesetzt. Da die Maske schon berechnet ist, geht das relativ schnell. 
; Hinweis: ein Beispiel für die Verwendung der erstellten .pbi Datei
; finden Sie unter "WindowSkin_Example.pb" !


; Hier der Generator: 
; (transparente Farbe des Bildes wird rechts-oben gelesen) 

Procedure WindowCallBack(WindowId, Message, lParam, wParam) 
  If Message = #WM_PAINT 
    StartDrawing(WindowOutput(0)) 
      DrawImage(ImageID(1), 0, 0) 
    StopDrawing() 
  EndIf 
  ProcedureReturn #PB_ProcessPureBasicEvents 
EndProcedure 

UsePNGImageEncoder() 
UsePNGImageDecoder() 

Structure myBITMAPINFO 
  bmiHeader.BITMAPINFOHEADER 
  bmiColors.RGBQUAD[1] 
EndStructure 

Structure RGB 
  v.l 
EndStructure 

Procedure CreateMask() 
  hDC = StartDrawing(ImageOutput(1)) 
    main  = CreateRectRgn_(0,0,0,0) 
    picl_X = ImageWidth(1) 
    picl_Y = ImageHeight(1) 
    mem = AllocateMemory(picl_X*picl_Y*4) 
    bmi.myBITMAPINFO 
    bmi\bmiHeader\biSize   = SizeOf(BITMAPINFOHEADER) 
    bmi\bmiHeader\biWidth  = picl_X 
    bmi\bmiHeader\biHeight = picl_Y 
    bmi\bmiHeader\biPlanes = 1 
    bmi\bmiHeader\biBitCount = 32 
    bmi\bmiHeader\biCompression = #BI_RGB 
    GetDIBits_(hDC,ImageID(1),1,picl_Y-1,mem,bmi,#DIB_RGB_COLORS) 
    *pixel.RGB = mem 
    trans.RGB 
    trans\v = *pixel\v 
    For ay=0 To picl_Y-2 
      For ax=0 To picl_X-1 
        If *pixel\v <> trans\v 
          sub = CreateRectRgn_(ax,picl_Y-ay-1,ax+1,picl_Y-ay-2) 
          CombineRgn_(main,main,sub,#RGN_OR) 
          DeleteObject_(sub) 
        EndIf 
        *pixel + 4 
      Next ax 
    Next ay 
  StopDrawing() 
  ProcedureReturn main 
EndProcedure 

file.s=OpenFileRequester("Open Bitmap","","Bitmap|*.bmp;*.png",0) 
If file 
  image=LoadImage(1,file) 
  w=ImageWidth(1):h=ImageHeight(1) 
  screenx=GetSystemMetrics_(#SM_CXSCREEN) 
  screeny=GetSystemMetrics_(#SM_CYSCREEN) 
  hwnd=OpenWindow(0,screenx,screeny,w,h,"Mask-Image",#WS_POPUP) 
  mask=CreateMask() 
  oldsize= GetRegionData_(mask,0,0) 
  *source= AllocateMemory(oldsize) 
  GetRegionData_(mask,oldsize,*source) 
  *target = AllocateMemory(oldsize+8) 
  newsize = PackMemory(*source,*target,oldsize,9) 
  newfile.s = ReplaceString(file,GetExtensionPart(file),"png") 
  SaveImage(1,newfile,#PB_ImagePlugin_PNG) 
  rest = newsize % 4 

  If CreateFile(0,ReplaceString(ReplaceString(file,GetFilePart(file),"MaskWindow_"+GetFilePart(file)),GetExtensionPart(file),"pbi")) 
    WriteStringN(0,"UsePNGImageDecoder()")  
    WriteStringN(0,"Procedure OpenMaskedWindow_"+Left(GetFilePart(file),Len(GetFilePart(file))-4)+"(winID,x,y,title.s,imID)") 
    WriteStringN(0,"  hwnd=OpenWindow(winID,GetSystemMetrics_(#SM_CXSCREEN),y,"+Str(w)+","+Str(h)+",title,#WS_POPUP)") 
    WriteStringN(0,"  memhandle=GlobalAlloc_(#GMEM_MOVEABLE,"+Str(oldsize+8)+")") 
    WriteStringN(0,"  *mem=GlobalLock_(memhandle)") 
    WriteStringN(0,"  UnpackMemory(?"+Left(GetFilePart(file),Len(GetFilePart(file))-4)+"_mask,*mem)") 
    WriteStringN(0,"  region=ExtCreateRegion_(0,"+Str(oldsize)+",*mem)") 
    WriteStringN(0,"  SetWindowRgn_(hwnd,region,#True)") 
    WriteStringN(0,"  pic=CatchImage(imID,?"+Left(GetFilePart(file),Len(GetFilePart(file))-4)+")") 
    WriteStringN(0,"  brush=CreatePatternBrush_(pic)") 
    WriteStringN(0,"  SetClassLong_(hwnd,#GCL_HBRBACKGROUND,brush)")  
    WriteStringN(0,"  ResizeWindow(winID,x,y,#PB_Ignore,#PB_Ignore)") 
    WriteStringN(0,"  GlobalUnlock_(memhandle)") 
    WriteStringN(0,"  GlobalFree_(memhandle)") 
    WriteStringN(0,"  DeleteObject_(region)") 
    WriteStringN(0,"  ProcedureReturn hwnd") 
    WriteStringN(0,"  DataSection") 
    WriteStringN(0,"  "+Left(GetFilePart(file),Len(GetFilePart(file))-4)+":") 
    WriteStringN(0,"    IncludeBinary "+Chr(34)+GetFilePart(newfile)+Chr(34)) 
    WriteStringN(0,"  "+Left(GetFilePart(file),Len(GetFilePart(file))-4)+"_mask:") 
    string.s="    Data.l " 
    For i=0 To newsize-4-rest Step 4 
      string+"$"+LSet(Hex(PeekL(*target+i)),8," ") 
      count+1 
      If count=10 
        count=0 
        WriteStringN(0,string) 
        string="    Data.l " 
      Else 
        string+"," 
      EndIf 
    Next i 
    If count 
      string=Left(string,Len(string)-1) 
      WriteStringN(0,string) 
    EndIf 
    If rest 
      string="    Data.b " 
      For i=newsize-rest To newsize-1 
        string+"$"+Hex(PeekB(*target+i))+"," 
      Next i 
      string=Left(string,Len(string)-1) 
      WriteStringN(0,string) 
    EndIf 
    WriteStringN(0,"  EndDataSection") 
    WriteStringN(0,"EndProcedure") 
    CloseFile(0) 
    MessageRequester(".pbi file created!","Press right mousekey to leave.",0) 
  Else 
    MessageRequester("Error!","Can't create '"+ReplaceString(ReplaceString(file,GetFilePart(file),"MaskWindow_"+GetFilePart(file)),GetExtensionPart(file),"pbi'"),0) 
  EndIf 

  SetWindowRgn_(hwnd,mask,#True) 
  ResizeWindow(0,(screenx-w)/2,(screeny-h)/2,#PB_Ignore,#PB_Ignore) 
  SetWindowCallback(@WindowCallBack()) 
    
  Repeat 
    Select WaitWindowEvent() 
      Case #WM_LBUTTONDOWN 
        SendMessage_(hwnd,#WM_NCLBUTTONDOWN, #HTCAPTION,0) 
      Case #WM_RBUTTONDOWN 
        Quit=1 
    EndSelect 
  Until Quit=1 
  DeleteObject_(mask) 
EndIf  

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
