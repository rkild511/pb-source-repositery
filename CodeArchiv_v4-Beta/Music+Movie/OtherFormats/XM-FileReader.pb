; English forum: http://www.purebasic.fr/english/viewtopic.php?t=5914
; Author: Inner (updated for PB3.93 by ts-soft, updated for PB4.00 by blbltheworm + Andre)
; Date: 23. April 2003
; OS: Windows
; Demo: Yes

;-----------------------------------------------------------------------------
;
; XM - File Reader
;
; ToDo:
; Pattern Decoding 
;
; Based on:
;       The XM module format description for XM files version $0104.
;       By Mr.H of Triton in 1994.
;
; Code : T.J.Roughton / (A.K.A) Innner
;
;-----------------------------------------------------------------------------
Global Dim notetable.s(256)
OpenConsole()
    filename.s=OpenFileRequester("","","",0)
    If filename = "" : End : EndIf
    For octv=0 To 7
        Restore notes
        For nt=0 To 11
             Read nts.s
             notetable(nti)=nts+" - "+Str(octv)
             nti+1
        Next
    Next
    fsize=FileSize(filename)
    *memptr=AllocateMemory(fsize)
    If(*memptr<>0)
        PrintN("*** Memory Aloocated")
        If(ReadFile(0,filename))
            PrintN("*** File loaded "+filename)
            ReadData(0,*memptr,fsize)
            CloseFile(0)
        EndIf
        DeleteFile("XM.log")
        OpenFile(0,"XM.log")
        WriteStringN(0,"--------------------------- Header ---------------------------")
        idtext.s=PeekS(*memptr,17)
        modname.s=PeekS(*memptr+17,20)
        trackername.s=PeekS(*memptr+38,20)
        version_hi=PeekB(*memptr+58)
        version_lo=PeekB(*memptr+59)
        header_size=PeekL(*memptr+60)        ; 60      4  (dword) Header size
        songlen=PeekW(*memptr+64)            ; +4      2   (word) Song length (in patten order table)                                         
        restartpos=PeekW(*memptr+66)         ; +6      2   (word) Restart position
        numchan=PeekW(*memptr+68)            ; +8      2   (word) Number of channels (2,4,6,8,10,...,32)
        numpatt=PeekW(*memptr+70)            ;+10      2   (word) Number of patterns (max 256)
        numinst=PeekW(*memptr+72)            ;+12      2   (word) Number of instruments (max 128)
        fraqtab=PeekW(*memptr+74)            ;+14      2   (word) Flags: bit 0: 0 = Amiga frequency table (see below);
                                             ;                                  1 = Linear frequency table
        deftempo=PeekW(*memptr+76)           ;+16      2   (word) Default tempo
        defbpm=PeekW(*memptr+78)             ;+18      2   (word) Default BPM
        patordertab=PeekB(*memptr+80)        ;+20    256   (byte) Pattern order table
        WriteStringN(0,"ID Text                     : "+idtext)
        WriteStringN(0,"Module Name                 : "+modname)
        WriteStringN(0,"Tracker Name                : "+trackername)
        WriteStringN(0,"Version                     : "+Str(version_lo)+"."+Str(version_hi))
        WriteStringN(0,"Header Size                 : "+Str(header_size))
        WriteStringN(0,"Song Length                 : "+Str(songlen))
        WriteStringN(0,"Restart Pos                 : "+Str(restartpos))
        WriteStringN(0,"Num Channels                : "+Str(numchan))
        WriteStringN(0,"Num Patterns                : "+Str(numpatt))
        WriteStringN(0,"Num Instruments             : "+Str(numinst))
        WriteStringN(0,"Freq Table                  : "+Str(fraqtab))
        WriteStringN(0,"Default Tempo               : "+Str(deftempo))
        WriteStringN(0,"Default BPM                 : "+Str(defbpm))
        WriteStringN(0,"Pattern Order               : "+Str(patordertab))
        ;-----------------------------------------------------------------------------
        ;Patterns: (Skip Info It's not needed)
        ;-----------------------------------------------------------------------------
        WriteStringN(0,"--------------------------- Patterns ---------------------------")
        npati=256
        For pati=0 To numpatt-1
            header_patsize=PeekL(*memptr+npati+80)
            pack_type=PeekB(*memptr+fkoff+256+84)      ; +4      1   (byte) Packing type (always 0)
            num_rows=PeekW(*memptr+fkoff+256+85)       ; +5      2   (word) Number of rows in pattern (1..256)
            pack_patdatsize=PeekW(*memptr+npati+87)

            WriteStringN(0,"Pattern Header Size         : "+Str(header_patsize))
            WriteStringN(0,"Pattern Pack Type           : "+Str(pack_type))
            WriteStringN(0,"Num Rows                    : "+Str(num_rows))
            WriteStringN(0,"Packed Pattern Data Size    : "+Str(pack_patdatsize))

            npati+header_patsize+pack_patdatsize
        Next
        npati+80
        For getinsti=0 To numinst-1    
            WriteStringN(0,"--------------------------- Instruments ---------------------------")
            WriteStringN(0,"Instrument No. : "+Str(getinsti)+" @ "+Str(npati))
            WriteStringN(0,"-------------------------------------------------------------------")
            instsize=PeekL(*memptr+npati)          ; ?     4  (dword) Instrument size
            instname.s=PeekS(*memptr+npati+4,22)   ; +4     22 (char) Instrument name
            insttype=PeekB(*memptr+npati+26)       ;+26      1 (byte) Instrument type (always 0)
            instninst=PeekW(*memptr+npati+27)      ;+27      2 (word) Number of samples in instrument
            WriteStringN(0,"Instrument size             : "+Str(instsize))
            WriteStringN(0,"Instrument name             : "+instname)
            WriteStringN(0,"Instrument type             : "+Str(insttype))
            WriteStringN(0,"No. of samples              : "+Str(instninst))
            If(instninst>0)
                *smpaddr=*memptr+npati
                header_smpsize=PeekL(*smpaddr+29)   ; +29      4  (dword) Sample header size
                WriteString(0,"Sample number for all notes : ")
                For i=0 To 96
                    smpno_notes=PeekB(*smpaddr+33+i); +33     96   (byte) Sample number for all notes
                    WriteString(0,Str(smpno_notes))
                Next
                WriteStringN(0,"")
                WriteString(0,"Points for volume envelope  : ")
                For i=0 To 48
                    smp_pointsfvol=PeekB(*smpaddr+129+i);+129     48   (byte) Points for volume envelope
                    WriteString(0,Str(smp_pointsfvol))
                Next
                WriteStringN(0,"")
                WriteString(0,"Points for panning envelope : ")
                For i=0 To 48
                    smp_pointsfpan=PeekB(*smpaddr+177+i);+177     48   (byte) Points for panning envelope
                    WriteString(0,Str(smp_pointsfpan))
                Next
                WriteStringN(0,"")
                smpno_volpoints=PeekB(*smpaddr+225) ;+225      1   (byte) Number of volume points
                smpno_panpoints=PeekB(*smpaddr+226) ;+226      1   (byte) Number of panning points
                smp_volsuspoint=PeekB(*smpaddr+227) ;+227      1   (byte) Volume sustain point
                smp_vollopspoint=PeekB(*smpaddr+228);+228      1   (byte) Volume loop start point
                smp_vollopepoint=PeekB(*smpaddr+229);+229      1   (byte) Volume loop end point
                smp_pansuspoint=PeekB(*smpaddr+230) ;+230      1   (byte) Panning sustain point
                smp_panlopspoint=PeekB(*smpaddr+231);+231      1   (byte) Panning loop start point
                smp_panlopepoint=PeekB(*smpaddr+232);+232      1   (byte) Panning loop end point
                smp_voltype=PeekB(*smpaddr+233)     ;+233      1   (byte) Volume type: bit 0: On; 1: Sustain; 2: Loop
                smp_pantype=PeekB(*smpaddr+234)     ;+234      1   (byte) Panning type: bit 0: On; 1: Sustain; 2: Loop
                smpvirb_type=PeekB(*smpaddr+235)    ;+235      1   (byte) Vibrato type
                smpvirb_sweep=PeekB(*smpaddr+236)   ;+236      1   (byte) Vibrato sweep
                smpvirb_depth=PeekB(*smpaddr+237)   ;+237      1   (byte) Vibrato depth
                smpvirb_rate=PeekB(*smpaddr+238)    ;+238      1   (byte) Vibrato rate
                smp_volfadeout=PeekW(*smpaddr+239)  ;+239      2   (word) Volume fadeout
                ;smp=PeekW()                        ;+241      2   (word) Reserved
                WriteStringN(0,"Sample Header Size          : "+Str(header_smpsize))
                WriteStringN(0,"Sample number for all notes : "+Str(smpno_notes))
                WriteStringN(0,"Number of volume points     : "+Str(smpno_volpoints))
                WriteStringN(0,"Number of panning points    : "+Str(smpno_panpoints))
                WriteStringN(0,"Volume sustain point        : "+Str(smp_volsuspoint))
                WriteStringN(0,"Volume loop start point     : "+Str(smp_vollopspoint))
                WriteStringN(0,"Volume loop end point       : "+Str(smp_vollopepoint))
                WriteStringN(0,"Panning sustain point       : "+Str(smp_pansuspoint))
                WriteStringN(0,"Panning loop start point    : "+Str(smp_panlopspoint))
                WriteStringN(0,"Panning loop end point      : "+Str(smp_panlopepoint))
                WriteStringN(0,"Number of volume points     : "+Str(smpno_volpoints))
                WriteStringN(0,"Number of panning points    : "+Str(smpno_panpoints))
                WriteStringN(0,"Volume type                 : "+Str(smp_voltype))
                WriteStringN(0,"Panning type                : "+Str(smp_pantype))
                WriteStringN(0,"Vibrato Type                : "+Str(smpvirb_type))
                WriteStringN(0,"Vibrato Sweep               : "+Str(smpvirb_sweep))
                WriteStringN(0,"Vibrato Depth               : "+Str(smpvirb_depth))
                WriteStringN(0,"Vibrato Rate                : "+Str(smpvirb_rate))
                WriteStringN(0,"Volume FadeOut              : "+Str(smp_volfadeout))
                ;-----------------------------------------------------------------------------
                ;Sample headers
                ;-----------------------------------------------------------------------------
                WriteStringN(0,"--------------------------- Samples ---------------------------")

                *smpaddr=*memptr+npati+instsize
                For csmpi=0 To instninst-1
                    smp_smplen=PeekL(*smpaddr+smpic)          ;   ?      4  (dword) Sample length
                    smp_smploops=PeekL(*smpaddr+4+smpic)      ;  +4      4  (dword) Sample loop start
                    smp_smploope=PeekL(*smpaddr+8+smpic)      ;  +8      4  (dword) Sample loop length
                    smp_smpvol=PeekB(*smpaddr+12+smpic)       ; +12      1   (byte) Volume
                    smp_smpfinetune=PeekB(*smpaddr+13+smpic)  ; +13      1   (byte) Finetune (signed byte -16..+15)
                    smp_smptype=PeekB(*smpaddr+14+smpic)      ; +14      1   (byte) Type: Bit 0-1: 0 = No loop, 1 = Forward loop,
                                                              ;                                    2 = Ping-pong loop;
                                                              ;                                    4 : 16-bit sampledata
                    smp_smpan=PeekB(*smpaddr+15+smpic)        ; +15      1   (byte) Panning (0-255)
                    smp_smprelnote=PeekB(*smpaddr+16+smpic)   ; +16      1   (byte) Relative note number (signed byte)
                    ;smp=PeekB(*smpaddr+17)                   ; +17      1   (byte) Reserved
                    smp_name.s=PeekS(*smpaddr+18+smpic,22)    ; +18     22   (char) Sample name
                    smpic+40
                    WriteStringN(0,"Sample Length               : "+Str(smp_smplen))
                    WriteStringN(0,"Sample loop start           : "+Str(smp_smploops))
                    WriteStringN(0,"Sample loop length          : "+Str(smp_smploope))
                    WriteStringN(0,"Volume                      : "+Str(smp_smpvol))
                    WriteStringN(0,"Finetune                    : "+Str(smp_smpfinetune))
                    WriteStringN(0,"Type                        : "+Str(smp_smptype))
                    WriteStringN(0,"Panning                     : "+Str(smp_smpan))
                    WriteStringN(0,"Relative note number        : "+Str(smp_smprelnote))
                    WriteStringN(0,"Sample name                 : "+smp_name)
                    sampdatsize+smp_smplen                                        
                Next
                npati+instsize+smpic+sampdatsize
                smpic=0 : sampdatsize=0
            Else
                npati+instsize
            EndIf
        Next
        CloseFile(0)
        ;WriteStringN("                            : "+Str())
        FreeMemory(*memptr)
    EndIf
    Input()
CloseConsole()
DataSection
    notes:
    Data.s "C ","C#","D ","D#","E ","F ","F#","G ","G#","A ","A#","B "
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -