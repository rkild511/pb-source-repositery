; English forum: http://www.purebasic.fr/english/viewtopic.php?t=13742&highlight=
; Author: El_Choni
; Date: 02. February 2005
; OS: Windows
; Demo: No


; Windows: use the shell progress dialog in your apps.
; Windows: Nutzen Sie den Shell-Progress-Dialog in ihren Programmen


; Comments: 
; Windows estimates the remaining time. The more 'progress intermediate points' 
; you use, the more accurate will be the result. 
; In real life you would probably put the update stuff in a timer proc while 
; you're, for example, copying a file. The timer proc would check for the amount 
; of bytes copied (using a critical section, for example), and update the 
; progress dialog according to that. 


; Tested on Windows XP Pro SP1 

Procedure Ansi2Uni(st$) 
   blen = (Len(st$)*2)+2 
   wbuf = AllocateMemory(blen) 
   MultiByteToWideChar_(#CP_ACP, 0, st$, -1, wbuf, blen) 
   ProcedureReturn wbuf 
EndProcedure 

#CLSCTX_INPROC_SERVER = 1 

#PROGDLG_NORMAL = 0 
#PROGDLG_AUTOTIME = 2 

#PDTIMER_RESET = 1 

#IDA_COPY_ANIMATION = 160 ; AVI file resource ID (I use an arbitrary constant name) 
                          ; This one is from shell32.dll. 
                          ; You can use any AVI file resource as long as it's 
                          ; uncompressed or RLE8 compressed, silent and 
                          ; smaller or equal to 272 by 60 pixels in size. 

ProgressLimit = 1000 

CoInitialize_(0) 
hr = CoCreateInstance_(?CLSID_ProgressDialog, #Null, #CLSCTX_INPROC_SERVER, ?IID_IProgressDialog, @ppv.IProgressDialog) 
If hr=#S_OK 
  *Title = Ansi2Uni("System progress dialog box") 
  ppv\SetTitle(*Title) 
  hShell = OpenLibrary(0, "shell32.dll") 
  If hShell 
    ppv\SetAnimation(hShell, #IDA_COPY_ANIMATION) 
  EndIf 
  *Cancel = Ansi2Uni("Cancel") 
  ppv\SetCancelMsg(*Cancel, 0) 
  *Line1 = Ansi2Uni("System progress dialog test in PureBasic") 
  ppv\SetLine(1, *Line1, #True, 0) 
  ppv\StartProgressDialog(#Null, 0, #PROGDLG_AUTOTIME|#PROGDLG_NORMAL, 0) 
  ppv\Timer(#PDTIMER_RESET, 0) 
  Repeat 
    If ppv\HasUserCancelled() 
      MessageRequester("Messsage", "Progress cancelled") 
      Break 
    Else 
      ppv\SetProgress(dwCompleted, ProgressLimit) 
      If dwCompleted>=ProgressLimit 
        MessageRequester("Messsage", "Progress completed") 
        Break 
      Else 
        dwCompleted+1 
        *Line2 = Ansi2Uni("We are at progress point number "+Str(dwCompleted)) 
        ppv\SetLine(2, *Line2, #TRUE, 0) 
        FreeMemory(*Line2) 
      EndIf 
    EndIf 
    Delay(100) 
  ForEver 
  ppv\StopProgressDialog() 
  ppv\Release() 
  FreeMemory(*Title) 
  FreeMemory(*Cancel) 
  FreeMemory(*Line1) 
  If hShell:CloseLibrary(0):EndIf 
Else 
  Debug Hex(hr) 
EndIf 
CoUninitialize_() 

DataSection 
CLSID_ProgressDialog: 
Data.l $f8383852 
Data.w $fcd3, $11d1 
Data.b $a6, $b9, 0, $60, $97, $df, $5b, $d4 
IID_IProgressDialog: 
Data.l $ebbc7c04 
Data.w $315e, $11d2 
Data.b $b6, $2f, 0, $60, $97, $df, $5b, $d4 
EndDataSection 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -