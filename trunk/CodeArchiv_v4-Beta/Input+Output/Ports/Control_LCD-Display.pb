; German forum: http://www.purebasic.fr/german/viewtopic.php?t=332&highlight=
; Author: SoS (updated for PB 4.00 by Andre)
; Date: 04. October 2004
; OS: Windows
; Demo: No


; Programm zum ansteuern eines T6963c / 240x128 pixel LCD's
; Für jeden, der ein solches Display sein eigen nennt, dürfte der folgende Code 
; interessant sein. Aber auch für diejenigen, die lange weile haben und meinen, 
; eine grafische Oberfläche coden zu können. Denkbar wäre diverse Einstellungen 
; zu ändern oder eine Vorschau auf dem PC-Monitor oder....

 ; * ---------------------------------------------------------- 
 ; * Program To control a T6963C-based 240x64 pixel LCD display 
 ; * using the PC's Parallel Port (LPT1:) in bidirectional mode 
 ; * written in Microsoft Quick c 
 ; * 
 ; * written by John P. Beale May 3-4, 1997  Beale@best.com 
 ; * 
 ; *  based on information from Steve Lawther, 
 ; *  "Writing Software for T6963C based Graphic LCDs", 1997 which is at 
 ; *  http://ourworld.compuserve.com/homepages/steve_lawther/T6963C.pdf 
 ; * 
 ; *  And the Toshiba T6963C Data sheet, also on Steve's WWW page 
 ; * 
 ; *  And info at: http://www.citilink.com/~jsampson/lcdindex.htm 
 ; *               http://www.cs.colostate.edu/~hirsch/LCD.html 
 ; *               http://www.hantronix.com/ 
 ; * ------------------------------------------------------------------------------- 
 ; * Portiert nach Purebasic zum ansteuern eines T6963c / 240x128 pixel LCD's by SoS 
 ; * ------------------------------------------------------------------------------- 
 ; * Bioseinstellung des Parallel-Ports (LPT1:) : EPP 
 ; * 

#base = $378 ;            parallelport 
#pdata = $378 ;           parallelport 
#pstatus = $379 ;         parallelport + 1 
#pcont = $37A ;           parallelport + 2 
#LCD_WIDTH =240 
#LCD_HEIGHT =128 
#CHARWIDTH  =6 
#PIXPERBYTE  = 6 ;        #CHARWIDTH 
#BYTES_PER_ROW = 240/6 ;  #LCD_WIDTH/#PIXPERBYTE  // how many bytes per row on screen 
#DISPLAYBYTES = 40*128 ;  #BYTES_PER_ROW*#LCD_HEIGHT 
#G_BASE = $0200 ;         // base address of graphics memory 
#G_END = $15FF ;          #G_BASE+#DISPLAYBYTES-1 
#G_BASE1 = $1600 ;        #G_BASE+#DISPLAYBYTES 
#G_END1 = $29FF ;         #G_BASE1+#DISPLAYBYTES-1 
#T_BASE = $0000 ;         // base address of text memory 
#GRAPH_AREA  = $0200 ;    #G_BASE 
#xmax = 239 
#xmin = 0 
#ymax = 127 
#ymin = 0 

; ---------------------------------------------------------------------------------------------------- 
; Author: NicTheQuick 
Global InpOut32Aktiv.l 
  Procedure OpenInpOut32() 
    Protected Result.l 
    Result = OpenLibrary(0, "InpOut32.dll") 
    If Result = #False 
      InpOut32Aktiv = #False 
      MessageRequester("ERROR", "InpOut32.dll wurde nicht gefunden oder ist korrupt.", #MB_ICONERROR) 
      End 
    Else 
      InpOut32Aktiv = #True 
    EndIf 
    ProcedureReturn Result 
  EndProcedure 
  
  Procedure CloseInpOut32() 
    CloseLibrary(0) 
    InpOut32Aktiv = #False 
  EndProcedure 
  
  Procedure Inp32(Address.l) 
    Protected Value.l 
    Value = CallFunction(0, "Inp32", Address) 
    ProcedureReturn Value 
  EndProcedure 
  
  Procedure Out32(Address.l, Value.l) 
    CallFunction(0, "Out32", Address, Value) 
  EndProcedure 
  
  Procedure CheckInpOut32Functions() 
    Protected FunctionName.s 
    If InpOut32Aktiv 
      Restore CheckInpOut32FunctionsData 
      For a.l = 1 To 2 
        Read FunctionName 
        If GetFunction(0, FunctionName) = #False 
          MessageRequester("ERROR", "Die Funktion " + Chr(34) + FunctionName + Chr(34) +" wurde nicht gefunden", #MB_ICONERROR) 
          ProcedureReturn #False 
        EndIf 
      Next 
      ProcedureReturn #True 
    Else 
      ProcedureReturn #False 
    EndIf 
    
    DataSection 
    CheckInpOut32FunctionsData: 
    Data.s "Inp32", "Out32" 
    EndDataSection 
  EndProcedure 
; ---------------------------------------------------------------------------------------------------- 
  
  ; *  LCD Pin ----- PC Port Pin  Status Reg. bit 
  ; * ------------------------------------------ 
  ; *  c/D  (8) <--> (17) /SEL      3 
  ; *  /WR  (5) <--> (16) Init      2 
  ; *  /RD  (6) <--> (14) /LF       1 
  ; *  /CE  (7) <--> (1)  /Strobe   0 
  ; * ----------------------------------------- 
  
  Procedure cehi () 
    Out32(#pcont,(Inp32(#pcont) & $FE));        // take PC 1 HI 
  EndProcedure 
  
  Procedure celo () 
    Out32(#pcont,(Inp32(#pcont) | $01));        // take PC 1 LO 
  EndProcedure 
  
  Procedure rdhi () 
    Out32(#pcont,(Inp32(#pcont) & $FD));        // take PC 14 HI 
  EndProcedure 
  
  Procedure rdlo () 
    Out32(#pcont,(Inp32(#pcont) | $02));        // take PC 14 LO 
  EndProcedure 
  
  Procedure wrhi () 
    Out32(#pcont,(Inp32(#pcont) | $04));        // take PC 16 HI 
  EndProcedure 
  
  Procedure wrlo () 
    Out32(#pcont,(Inp32(#pcont) & $FB));        // take PC 16 LO 
  EndProcedure 
  
  Procedure cdhi () 
    Out32(#pcont,(Inp32(#pcont) & $F7));        // take PC 17 HI 
  EndProcedure 
  
  Procedure cdlo () 
    Out32(#pcont,(Inp32(#pcont) | $08));        // take PC 17 LO 
  EndProcedure 
  
  Procedure Datain () 
    Out32(#pcont,(Inp32(#pcont) | $20));        // 8bit Data input 
  EndProcedure 
  
  Procedure Dataout () 
    Out32(#pcont,(Inp32(#pcont) & $DF));        // 8bit Data output 
  EndProcedure 
  
    ; * ============================================================== 
    ; * Low-level i/O routines To Interface to LCD display 
    ; * based on four routines: 
    ; * 
    ; *          dput(): write Data byte 
    ; *          cput(): write control byte 
    ; *          dget(): Read Data byte         (UNTESTED) 
    ; *          sget(): Read status 
    ; * ============================================================== 
  
  Procedure sget () ;                          // check LCD display status pbrt 
    Datain() ;                                  // make 8-bit parallel port an input 
    cdhi() ;                                    // bring LCD C/D line high (read status byte) 
    rdlo() ;                                    // bring LCD /RD line low (read active) 
    celo() ;                                    // bring LCD /CE line low (chip-enable active) 
    lcd_status = Inp32(#pdata);                 // read LCD status byte 
    cehi() ;                                    // bring LCD /CE line high, disabling it 
    rdhi() ;                                    // deactivate LCD read mode 
    Dataout() ;                                 // make 8-bit parallel port an output port 
    ProcedureReturn lcd_status 
  EndProcedure 
  
  Procedure dput (byte) ;                      // write data byte to LCD module over par. port 
   ; ------------------------------------------------------------------------------------------- 
    While ($03 & sget()) ! $03 = $03 : Wend ;  // wait until display ready <- geht auch ohne 
   ; ------------------------------------------------------------------------------------------- 
    cdlo() 
    wrlo() ;                                    // activate LCD's write mode 
    Out32(#pdata,byte) ;                        // write value to data port 
    celo() ;                                    // pulse enable LOW > 80 ns (hah!) 
    cehi() ;                                    // return enable HIGH 
    wrhi() ;                                    // restore Write mode to inactive 
  EndProcedure 
  
  Procedure dget () ;                          // get data byte from LCD module 
  ; -------------------------------------------------------------------------------------------  
    While ($03 & sget()) ! $03 = $03 : Wend ;  // wait until display ready <- geht auch ohne 
  ; -------------------------------------------------------------------------------------------  
    Datain();                                   // make PC's port an input port 
    wrhi() ;                                    // make sure WRITE mode is inactive 
    cdlo() ;                                    // data mode 
    rdlo() ;                                    // activate READ mode 
    celo() ;                                    // enable chip, which outputs data 
    lcd_byte = Inp32(#pdata) ;                  // read data from LCD 
    cehi() ;                                    // disable chip 
    rdhi() ;                                    // turn off READ mode 
    Dataout() ;                                 // make 8-bit parallel port an output port 
    ProcedureReturn lcd_byte 
  EndProcedure 
    
  Procedure cput (byte) ;                      // write command byte to LCD module 
  ; -------------------------------------------------------------------------------------------  
    While ($03 & sget()) ! $03 = $03 : Wend ;  // wait until display ready <- geht auch ohne 
  ; -------------------------------------------------------------------------------------------  
    Out32(#pdata,byte) ;                        // present data to LCD on PC's port pins 
    cdhi();                                     // control/status mode 
    rdhi();                                     // make sure LCD read mode is off 
    wrlo();                                     // activate LCD write mode 
    celo();                                     // pulse ChipEnable LOW, > 80 ns, enables LCD I/O 
    cehi();                                     // disable LCD I/O 
    wrhi();                                     // deactivate write mode 
  EndProcedure 
    
  Procedure lcd_setup() ;                      // make sure control lines are at correct levels 
    cehi();                                     // disable chip 
    rdhi();                                     // disable reading from LCD 
    wrhi();                                     // disable writing to LCD 
    cdhi();                                     // command/status mode 
    Dataout();                                  // make 8-bit parallel port an output port 
  EndProcedure 
    
  Procedure lcd_init () ;                      // initialize LCD memory and display modes 
    dput(#G_BASE % 256) 
    dput(#G_BASE >> 8) 
    cput($42);                                  // set graphics memory to address G_BASE 
    
    dput(#BYTES_PER_ROW % 256) 
    dput(#BYTES_PER_ROW >> 8) 
    cput($43);                                  // n bytes per graphics line 
    
    dput(#T_BASE % 256) 
    dput(#T_BASE >> 8) 
    cput($40);                                  // text memory at address T_BASE 
    
    dput(#BYTES_PER_ROW % 256) 
    dput(#BYTES_PER_ROW >> 8) 
    cput($41);                                  // n bytes per text line 
    
    cput($80);                                  // mode set: Graphics OR Text, ROM CGen 
    
    cput($A7);                                  // cursor is 8 lines high 
    dput($00) 
    dput($00) 
    cput($21);                                  // put cursor at (x,y) location 
    
    cput($97);                                  // Graphics & Text ON, cursor blinking 
  EndProcedure 
    
  Procedure lcd_clear_graph () ;               // clear graphics memory of LCD 
    dput(#G_BASE % 256); 
    dput(#G_BASE >> 8); 
    cput($24);                                  // addrptr at address G_BASE 
    For i = 0 To 5119 
      dput(0) 
      cput($C0) 
    Next 
  EndProcedure 
    
  Procedure lcd_clear_text() ;                 // clear text memory of LCD 
    dput(#T_BASE % 256); 
    dput(#T_BASE >> 8); 
    cput($24);                                  // addrptr at address T_BASE 
    For i = 0 To 639 
      dput(0) 
      cput($C0) 
    Next 
  EndProcedure 
    
  Procedure lcd_print( txt$ ) ;                // send string of characters to LCD 
    For i = 1 To Len (txt$) 
      c=Asc((Mid(txt$,i,1)))-32 ;               // convert ASCII to LCD char address 
      If c < 0 
        c= 0 
      EndIf 
      dput(c) 
      cput($C0) ;                               // write character, increment memory ptr. 
    Next 
  EndProcedure 
    
  Procedure lcd_setpixel(column,row) ;                    // set single pixel in 240x128 array 
    addr =  #G_BASE + (row*#BYTES_PER_ROW)  + (column/6) ; // memory address of byte containing pixel to write 
    dput(addr % 256): dput(addr >> 8): cput($24);          // set LCD addr. pointer 
    cput($F8 | (5-(column % 6)) );                         // set bit-within-byte command 
  EndProcedure 
    
  Procedure lcd_xy(x,y) ;                                 // set memory pointer to (x,y) position (text) 
    
    addr = #T_BASE + (y * #BYTES_PER_ROW) + x; 
    dput(addr % 256): dput(addr >> 8): cput($24);          // set LCD addr. pointer 
  EndProcedure 
    
  Procedure.f RandomF(Max.f) 
    ; Author: Froggerprogger 
    ProcedureReturn Max * Random(1000000) / 1000000.0 
  EndProcedure 
    
  Procedure.f GSin(winkel.f) 
    ProcedureReturn Sin(winkel*(2*3.14159265/360)) 
  EndProcedure 
  
  
  Procedure.f GCos(winkel.f) 
    ProcedureReturn Cos(winkel*(2*3.14159265/360)) 
  EndProcedure 
  
  
  OpenInpOut32() 
  CheckInpOut32Functions() 
  
  lcd_setup() 
  lcd_init() 
  lcd_clear_text() 
  cput($97) 
  lcd_xy(0,0) 
  For c= 0 To 10 
    lcd_xy(0,0) 
    For i= 0 To 320 
      cc = (c+i) % $7F ;                               // display all characters 
      dput(cc): cput($C0) 
    Next 
    For i= 0 To 320 
      cc = (c+i) % $7F 
      dput(cc): cput($C0) 
    Next  
  Next 
  Delay(1000) 
  lcd_clear_text() 
  cput($97) 
  lcd_xy(0,0) 
  lcd_print("Hello world."); 
  lcd_xy(0,1);                                         // first character, second line 
  lcd_print("Das ist die 2. Zeile. :)"); 
  lcd_xy(5,2); 
  lcd_print("Hier ist die 3. Zeile...   ;)"); 
  lcd_xy(0,3); 
  lcd_print("...usw. und so fort.    :D"); 
  lcd_xy(10,5); 
  lcd_print("Press any key to exit.   "); 
  lcd_xy(0,7); 
  lcd_print("Display Powered by Purebasic "); 
  lcd_xy(1,9); 
  lcd_print("Display Powered by Purebasic "); 
  lcd_xy(2,11); 
  lcd_print("Display Powered by Purebasic "); 
  lcd_xy(3,13); 
  lcd_print("Display Powered by Purebasic "); 
  lcd_xy(4,15); 
  lcd_print("Display Powered by Purebasic "); 
  Delay(3000) 
  lcd_clear_text() 
  cput($98);                                    // Graphics ON, Text OFF 
  lcd_clear_graph();                            // fill graphics memory with 0x00 
  For y=0 To 127 
    For x=0 To 239 
      lcd_setpixel(x,y);                        // draw pixel on LCD screen 
    Next 
  Next  
  lcd_clear_graph();                            // fill graphics memory with 0x00 
  CloseInpOut32() 
 

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -----