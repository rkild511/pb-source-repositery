; German forum: http://www.purebasic.fr/german/viewtopic.php?t=640&highlight=
; Author: LittleFurz (updated for PB 4.00 by Andre)
; Date: 27. October 2004
; OS: Windows
; Demo: 
; OS; Windows
; Demo: No


; Komprimier-Algo
; ---------------
; Ich hab'n Programm geschrieben, mit dem man 40 KB auf 8,06 KB runter 
; schrauben kann. Der Trick ist: zuerst wird die Exe mit dem Algo in eine 
; BMP umgewandelt. Danach wird die erstellte BMP mit dem RAR Algo in ein 
; Archiv umgewandelt. Wenn man die Exe ohne den Algo verpacken würde, wäre 
; das Archiv ca. 0,40 KB größer. Ist zwar so gesehn nicht sonderlich viel, 
; aber wenn man das vergleichsweise mit einer EXE machen würde, wäre der 
; Unterschied auch größer. 

; Status: BMP2BIN arbeitet noch nicht richtig. zumindest wird das umgewandelte 
; Programm mit einem Error Dialog beendet.

Declare   Open_frmMain() 
Declare.b Bin2BMP(strDatei.s, strDest.s) 
Declare.b BMP2bin(strDatei.s, strDest.s) 

Enumeration 
    #frmMain 
EndEnumeration 

Enumeration 
    #PrbProgress 
    #imgData 
EndEnumeration 

Global Datei.s 
Global FileGroesse.l 
Global EventID.l 

Datei = ProgramParameter() 

Select GetExtensionPart(Datei) 
    Case "bmp" 
        If BMP2bin(Datei, SaveFileRequester("BMP Converter...", "", "*.* (Alle Dateien)|*.*", 0)) = #True 
            MessageRequester("Fertig !", "Convertierung erfolgreich abgeschlossen !")        
        Else 
            MessageRequester("Fehler !", "Fehler beim Öffnen der Datei !") 
        EndIf            
    Case "exe" 
        If Bin2BMP(Datei, SaveFileRequester("BMP Converter...", "", "*.* (Alle Dateien)|*.*", 0)) = #True 
            MessageRequester("Fertig !", "Convertierung erfolgreich abgeschlossen !") 
        Else 
            MessageRequester("Fehler !", "Fehler beim Öffnen der Datei !") 
        EndIf        
    Default 
        Datei = OpenFileRequester("BMP Converter...", "", "*.* (Alle Dateien)|*.*", 0) 
        If Bin2BMP(Datei, SaveFileRequester("BMP Converter...", "", "*.* (Alle Dateien)|*.*", 0)) = #True 
            MessageRequester("Fertig !", "Convertierung erfolgreich abgeschlossen !")        
        Else 
            MessageRequester("Fehler !", "Fehler beim Öffnen der Datei !") 
        EndIf        
EndSelect 

End 

Procedure.b BMP2bin(strDatei.s, strDest.s) 
    Define.l FileHandle, ImageHandle, Proced, MyX, MyY, PointColor 
    
    FileHandle  = OpenFile(#PB_Any, strDest) 
    If FileHandle <> 0 
        ImageHandle = LoadImage(#PB_Any, strDatei) 
        If ImageHandle <> 0 
            If StartDrawing(ImageOutput(ImageHandle)) 
                Open_frmMain() 
                
                Repeat 
                    EventID = WindowEvent() 
                    If EventID <> 0 
                        Select EventID 
                            Case #PB_Event_CloseWindow 
                                End 
                        EndSelect 
                    EndIf                    
                    
                    PointColor = Point(MyX, MyY) 
                    If PointColor = RGB(255, 0, 0) 
                        Break 
                    Else 
                        WriteByte(FileHandle, Red(PointColor)) 
                        Proced = Proced + 1 
                        If MyX = ImageWidth(ImageHandle) 
                            MyX = 0 
                            MyY = MyY + 1 
                        Else 
                            MyX = MyX + 1 
                        EndIf 
                        SetGadgetState(#PrbProgress, Val(StrF((MyX / 512) * 100,0))) 
                    EndIf 
                    
                ForEver 
                
                ProcedureReturn #True 
            Else 
                ProcedureReturn #False 
            EndIf 
        Else 
            ProcedureReturn #False 
        EndIf 
    Else 
        ProcedureReturn #False 
    EndIf 
EndProcedure 

Procedure.b Bin2BMP(strDatei.s, strDest.s) 
    Define.l FileHandle, ImageHandle, Proced, MyX, MyY, Zeichen 
    
    FileHandle = ReadFile(#PB_Any, strDatei) 
    Debug Str(FileHandle) + "/" + strDatei 
    If FileHandle <> 0 
        FileGroesse = FileSize(strDatei) 
        Open_frmMain() 
        
        ImageHandle = CreateImage(#PB_Any, 512, (FileGroesse / 512) + 2) 
        StartDrawing(ImageOutput(ImageHandle)) 
        Box(0,0,512,ImageHeight(ImageHandle), RGB(255,255,255)) 
        StopDrawing() 
        
        If StartDrawing(ImageOutput(ImageHandle)) 
            While Eof(FileHandle) = 0 
                EventID = WindowEvent() 
                
                If EventID <> 0 
                    Select EventID 
                        Case #PB_Event_CloseWindow 
                            End 
                    EndSelect 
                EndIf 
                
                Zeichen = ReadByte(FileHandle) & $FF 
                Debug Str(Zeichen) 
                Plot(MyX, MyY, RGB(Zeichen, Zeichen, Zeichen)) 
                Proced = Proced + 1 
                If MyX = 512 
                    MyX = 0 
                    MyY = MyY + 1 
                Else 
                    MyX = MyX + 1 
                EndIf 
                
                RandomSeed(Date()) 
                SetGadgetState(#PrbProgress, Val(StrF((Proced / FileGroesse) * 100,0))) 
                SetWindowTitle(#frmMain, StrF((Proced / FileGroesse) * 100, 2) + "%...") 
            Wend 
            Plot(MyX, MyY, RGB(255, 0, 0)) 
            StopDrawing()            
        EndIf 
        
        If strDest <> "" 
            SaveImage(ImageHandle, strDest) 
            ProcedureReturn #True 
        EndIf 
    Else 
        ProcedureReturn #False 
    EndIf    
EndProcedure 

Procedure Open_frmMain() 
    If OpenWindow(#frmMain, 237, 272, 281, 41, "BMP Convert", #PB_Window_SystemMenu | #PB_Window_TitleBar | #PB_Window_ScreenCentered) 
        If CreateGadgetList(WindowID(#frmMain)) 
            ProgressBarGadget(#PrbProgress, 10, 10, 260, 20, 0, 100, #PB_ProgressBar_Smooth) 
        EndIf 
    EndIf 
EndProcedure
; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -
; DisableDebugger
