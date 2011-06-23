; German forum: http://www.purebasic.fr/german/viewtopic.php?t=11402&highlight=
; Author: Fluid Byte
; Date: 31. December 2006
; OS: Windows
; Demo: No


; Title:    Ownerdraw Frame3D Control 
; Author:   Fluid Byte 
; Date:     December 31, 2006 
; Compiler: PureBasic v4.02 

Structure FRAME3DEX 
   lpPrevFunc.l 
   clrText.l 
   bThemeXP.b 
EndStructure 

Procedure Frame3DExProc(hWnd.l,uMsg.l,wParam.l,lParam.l) 
   Protected hDC.l,ps.PAINTSTRUCT,*frmex.FRAME3DEX,Title.s,fts.SIZE,wrc.RECT,lpBuffer.l,hThemeButton.l 
    
   *frmex = GetWindowLong_(hwnd,#GWL_USERDATA) 
    
    Select uMsg 
       Case #WM_DESTROY 
       *frmex\lpPrevFunc = -1 
        
       ProcedureReturn 0 
        
        Case #WM_PAINT       
      hdc = BeginPaint_(hwnd,ps) 
       
      SelectObject_(hdc,SendMessage_(hwnd,#WM_GETFONT,0,0))    
       
      Title = GetGadgetText(GetDlgCtrlID_(hwnd))    
      GetTextExtentPoint32_(hdc,Title,Len(Title),fts)    
      GetClientRect_(hWnd,wrc)       
      SetRect_(wrc,wrc\left,wrc\top+fts\cy/2,wrc\right,wrc\bottom)          
       
      If OSVersion() = #PB_OS_Windows_XP And IsThemeActive_() And IsAppThemed_() And *frmex\bThemeXP 
         lpBuffer = AllocateMemory(13) : PokeS(lpBuffer,"Button",-1,1)       
          
         hThemeButton = OpenThemeData_(WindowID(0),lpBuffer)          
         DrawThemeBackground_(hThemeButton,hdc,4,1,wrc,0) 
         CloseThemeData_(hThemeButton) 
          
         FreeMemory(lpBuffer)          
      Else 
         DrawEdge_(hdc,wrc,#EDGE_ETCHED,#BF_RECT) 
      EndIf 
    
      SetBkColor_(hdc,GetSysColor_(#COLOR_3DFACE)) 
      SetTextColor_(hdc,*frmex\clrText) 
      TextOut_(hdc,9,0,Title,Len(Title))    

      EndPaint_(hwnd,ps) 

      ProcedureReturn 0 

      Default 
      If *frmex\lpPrevFunc = -1 : FreeMemory(*frmex) : Else 
         ProcedureReturn CallWindowProc_(*frmex\lpPrevFunc,hWnd,uMsg,wParam,lParam)          
      EndIf 
    EndSelect 
EndProcedure 

Procedure Frame3DGadgetEx(GadgetID.w,X.w,Y.w,Width.w,Height.w,Text.s,Color.l=0)       
   Frame3DGadget(GadgetID,X,Y,Width,Height,Text) 
    
   Protected *frmex.FRAME3DEX,Filename.s,HINSTANCE.l 
    
   *frmex.FRAME3DEX = AllocateMemory(SizeOf(FRAME3DEX)) 
   *frmex\lpPrevFunc = SetWindowLong_(GadgetID(GadgetID),#GWL_WNDPROC,@Frame3DExProc()) 
   *frmex\clrText = Color 
    
   Filename = Space(#MAX_PATH) : GetModuleFileName_(0,Filename,#MAX_PATH) 

   HINSTANCE = LoadLibrary_(Filename) 
   *frmex\bThemeXP = FindResource_(HINSTANCE,1,24) 
   FreeLibrary_(HINSTANCE) 
    
   SetWindowLong_(GadgetID(GadgetID),#GWL_USERDATA,*frmex) 
    
   ProcedureReturn GadgetID(GadgetID) 
EndProcedure 

OpenWindow(0,0,0,400,300,"Ownerdraw Frame3D Control",#WS_OVERLAPPEDWINDOW | 1) 

CreateGadgetList(WindowID(0)) 

SetGadgetFont(#PB_Default,LoadFont(0,"Arial",9)) 

Frame3DGadgetEx(101,10,5,200,90,"Frame3DGadgetEx #1",#Red) 
Frame3DGadgetEx(102,10,100,200,90,"Frame3DGadgetEx #2",RGB(40,180,70)) 
Frame3DGadgetEx(103,10,195,200,90,"Frame3DGadgetEx #3",#Blue) 

While WaitWindowEvent() ! 16 : Wend

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; EnableXP