; German forum: 
; Author: Unknown (updated for PB4.00 by blbltheworm)
; Date: 10. June 2003
; OS: Windows
; Demo: Yes

Procedure Testbit(val,bitnum)
  ;gibt Bitwert zureuck
  Global Dim bit.b(8);
  t1 = val / 2 : If t1*2 <> val : bit(1) = 1 : EndIf
  t2 = t1 / 2  : If t2*2 <> t1  : bit(2) = 1 : EndIf
  t3 = t2 / 2  : If t3*2 <> t2  : bit(3) = 1 : EndIf
  t4 = t3 / 2  : If t4*2 <> t3  : bit(4) = 1 : EndIf
  t5 = t4 / 2  : If t5*2 <> t4  : bit(5) = 1 : EndIf
  t6 = t5 / 2  : If t6*2 <> t5  : bit(6) = 1 : EndIf
  t7 = t6 / 2  : If t7*2 <> t6  : bit(7) = 1 : EndIf
  t8 = t7 / 2  : If t8*2 <> t7  : bit(8) = 1 : EndIf
  result = bit(bitnum)
  ProcedureReturn result
EndProcedure

Procedure.w MOD(a.w,b.w)
  ;gibt ganzzahligen Restwert einer Division zurück
  ProcedureReturn a - ((a/b)*b)
EndProcedure

;################
;PFAD anpassen
;################

If ReadFile(0, "automated_test.mp3")
  HeaderStart.l = 0
  FileSeek(0,0)
  ;Header suchen
  ;Fängt mit $FF an, und beginnnt nach einem
  ;möglichen ID3V2-Tag!
  ;Da $FF im ID3V2-Tag niemals vorkommen darf
  ;einfach danach suchen !
  While Asc(Chr(ReadByte(0))) <> $FF
    HeaderStart = HeaderStart + 1
  Wend
  
  If HeaderStart > 0
    Debug "ID3V2-Tag gefunden"
  EndIf
  
  ;in diesen 3 Bytes stehen alle Info's
  Hbyte1.b =  ReadByte(0)
  Hbyte2.b =  ReadByte(0)
  Hbyte3.b =  ReadByte(0)
  
  ;Byte 3
  Select Str(Testbit(Hbyte3,2)) + Str(Testbit(Hbyte3,1))
  Case "00"
    Emp$ = "None"
  Case "01"
    Emp$ = "50/15 microseconds"
  Case "10"
    Emp$ = "Dunno"
  Case "11"
    Emp$ = "CITT j.17"
  EndSelect
  Debug "Emphasis : "+Emp$
  
  Select Str(Testbit(Hbyte3,3))
  Case "0"
    Org$ = "No"
  Case "1"
    Org$ = "Yes"
  EndSelect
  Debug "Original : "+Org$
  
  Select Str(Testbit(Hbyte3,4))
  Case "0"
    Cop$ = "No"
  Case "1"
    Cop$ = "Yes"
  EndSelect
  Debug "Copyright : "+Cop$
  
  Mex$ = Str(Testbit(Hbyte3,6))+Str(Testbit(Hbyte3,5))
  
  Select Str(Testbit(Hbyte3,8))+Str(Testbit(Hbyte3,7))
  Case "00"
    Cha$ = "Stereo"
  Case "01"
    Cha$ = "Joint Stereo"
  Case "10"
    Cha$ = "Dual Chanel"
  Case "11"
    Cha$ = "Mono"
  EndSelect
  Debug "Kanäle : "+Cha$
  
  ;Byte 2
  Select Str(Testbit(Hbyte2,1))
  Case "0"
    Ext$ = "None"
  Case "1"
    Ext$ = "Privat"
  EndSelect
  Debug "Extension : "+Ext$
  
  
  Select Str(Testbit(Hbyte2,2))
  Case "0"
    Pad$ = "1"
  Case "1"
    Pad$ = "0"
  EndSelect
  If Pad$ = "1"
    Debug "Padding : yes"
  Else
    Debug "Padding : no"
  EndIf
  
  Sam$ = Str(Testbit(Hbyte2,4))+Str(Testbit(Hbyte2,3))
  
  Btr$ = Str(Testbit(Hbyte2,8))+Str(Testbit(Hbyte2,7))+Str(Testbit(Hbyte2,6))+Str(Testbit(Hbyte2,5))
  
  ;Byte 1
  Select Str(Testbit(Hbyte1,1))
  Case "0"
    Err$ = "On"
  Case "1"
    Err$ = "Off"
  EndSelect
  Debug "Error-Protection : "+Err$
  
  Select Str(Testbit(Hbyte1,3)) + Str(Testbit(Hbyte1,2))
  Case "00"
    Layer$ = "?"
  Case "01"
    Layer$ = "3"
  Case "10"
    Layer$ = "2"
  Case "11"
    Layer$ = "1"
  EndSelect
  Debug "MPG - Layer : "+Layer$
  
  Select Str(Testbit(Hbyte1,5)) + Str(Testbit(Hbyte1,4))
  Case "00"
    Mpgversion$ = "2.5"
  Case "01"
    Mpgversion$ = "?"
  Case "10"
    Mpgversion$ = "2"
  Case "11"
    Mpgversion$ = "1"
  EndSelect
  Debug "MPG - Version : "+Mpgversion$
  
  
  Select Mpgversion$
  Case "1"
    Select Sam$
    Case "00"
      SampleRate$ = "44100"
    Case "01"
      SampleRate$ = "48000"
    Case "10"
      SampleRate$ = "32000"
    Case "11"
      SampleRate$ = "Stream-Error"
    EndSelect
  Case "2"
    Select Sam$
    Case "00"
      SampleRate$ = "22050"
    Case "01"
      SampleRate$ = "24000"
    Case "10"
      SampleRate$ = "16000"
    Case "11"
      SampleRate$ = "Stream-Error"
    EndSelect
  EndSelect
  Debug "Samplerate : "+SampleRate$+" kHz"
  
  
  Select Mpgversion$
  Case "1"
    Select Mex$
    Case "00"
      ModeExt$ = "Frequenzband 4"
    Case "01"
      ModeExt$ = "Frequenzband 8"
    Case "10"
      ModeExt$ = "Frequenzband 12"
    Case "11"
      ModeExt$ = "Frequenzband 16"
    EndSelect
  Case "2"
    Select Mex$
    Case "00"
      ModeExt$ = "Frequenzband 0"
    Case "01"
      ModeExt$ = "Frequenzband 4"
    Case "10"
      ModeExt$ = "Frequenzband 8"
    Case "11"
      ModeExt$ = "Frequenzband 16"
    EndSelect
  EndSelect
  Debug "Mode-Extension : "+ModeExt$
  
  ;Bitraten-Tabellen
  V1L1$ = "32,64,96,128,160,192,224,256,288,320,353,384,416,448,-1"
  V1L2$ = "32,48,56,64,80,96,112,128,160,192,224,256,320,384,-1"
  V1L3$ = "32,40,48,56,64,80,96,112,128,160,192,224,256,320,-1"
  V2L1$ = "32,64,96,128,160,192,224,256,288,320,352,384,416,448,-1"
  V2L2$ = "32,48,56,64,80,96,112,128,160,192,224,256,320,384,-1"
  V2L3$ = "8,16,24,32,64,80,56,64,128,160,112,128,256,320,-1"
  Liste$ ="0001,0010,0011,0100,0101,0110,0111,1000,1001,1010,1011,1100,1101,1110,1111"
  
  
  If (Layer$ = "1") And (Mpgversion$ = "1")
    Bitrate$ = StringField(V1L1$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  If (Layer$ = "2") And (Mpgversion$ = "1")
    Bitrate$ = StringField(V1L2$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  If (Layer$ = "3") And (Mpgversion$ = "1")
    Bitrate$ = StringField(V1L3$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  If (Layer$ = "1") And (Mpgversion$ = "2")
    Bitrate$ = StringField(V2L1$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  If (Layer$ = "2") And (Mpgversion$ = "2")
    Bitrate$ = StringField(V2L2$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  If (Layer$ = "3") And (Mpgversion$ = "2")
    Bitrate$ = StringField(V2L3$,((FindString(Liste$,Btr$,0)-1)/4)-1,",")
  EndIf
  Debug "Bitrate : "+Bitrate$+" kBits/s"
  
  ;rechnen
  If SampleRate$ ="Stream-Error"
    MessageRequester("Stream-Error","Fehlerhaftes Dateiformat !",16)
    CloseFile(0)
    End
  EndIf
  
  If Val(Bitrate$) > 0 And Val(SampleRate$) > 0
    Sek.l = Int(Lof(0) * 8) / (Val(Bitrate$) *1000)
  EndIf
  Debug "Duration : "+Str(Sek)+" sec"
  
  ;Min =  Sek/60
  ;Seks = Mod(Sek,60)
  Debug "Time : "+Str(Sek/60)+":"+Str(MOD(Sek,60))+" min"
  
  If Val(SampleRate$)>0
    Framesize.l = 144 * (Val(Bitrate$)*1000) / Val(SampleRate$) + Val(Pad$)
    Debug "Framesize : "+Str(Framesize)+" Bytes"
  EndIf

  If Framesize > 0
    Frames.l = (Lof(0)-128-HeaderStart) / (Framesize)
  EndIf
  Debug "Frames : "+Str(Frames)
  Debug ""
  
  
  ;ID3V1-Tag auslesen , die letzten 128 Bytes der Datei
  FileSeek(0,Lof(0)-128)
  ;AllocateMemory(0,128,0) ;pb alt
  MemoryID=AllocateMemory(128)      ;pb neu
  ReadData(0,MemoryID,128)
  
  Tags$ = PeekS(MemoryID,3)
  If Tags$ = "TAG"
    Debug "ID3V1-Tag :"
    ;Debug PeekS(MemoryID(),3);TAG-Kennung
    Debug PeekS(MemoryID+3,30);Titel
    Debug PeekS(MemoryID+33,30);Artist
    Debug PeekS(MemoryID+63,30);Album
    Debug PeekS(MemoryID+93,4);Jahr
    Debug PeekS(MemoryID+97,29);Kommentar
    Debug PeekB(MemoryID+126);Track-NR
    Restore Genre
    For x = 0 To PeekB(MemoryID+127);Genre-ID
      Read Genre$
    Next x
    Debug Genre$
    Debug ""
  EndIf
  
  FreeMemory(MemoryID)
  
  
  ;ID3V2-Tag auslesen! Variable Länge am Anfang der Datei.
  ;Das Ganze ist leider nicht ganz so einfach, da
  ;im Prinzip jedes Programm,das TAG's einfuegen kann,
  ;reinschreiben kann was es will !
  ;Es gibt zwar einige Vorgaben, aber das reicht bei weitem nicht aus !
  ;Alle nicht bekannten Frame-Formate werden mit "unbekannt"
  ;gekennzeichnet !
  If Headerstart > 0
    FileSeek(0,0);zum Anfang
    
    ;die ersten 10 Bytes einlesen
    Global Dim bytes.b(9)
    For x = 0 To 9
      Bytes(x) = ReadByte(0)
    Next x
    
    ID3Ident$ = Chr(Bytes(0))+Chr(Bytes(1))+Chr(Bytes(2))
    ;Debug ID3Ident$
    
    ID3Version.l = Bytes(3)
    ID3SubVersion.l = Bytes(4)
    ID3Flags.l = Bytes(5)
    Debug "ID3V2-Version " +Str(ID3Version)+"."+Str(ID3SubVersion)
    ;Debug ID3Flags
    
    ;die nächsten 4 Bytes sind die Längenangabe
    ;brauchen wir nicht da die Länge schon
    ;bekannt ist (Headerstart-1)
    Debug "ID3V2Size : "+ Str(Headerstart-1)+" Bytes"
    
    ;Extendet Header vorhanden ?
    ;Ist der Header vorhanden verschieben sich die
    ;Frames um 6 Bytes nach hinten
    ExtHeader.l = Testbit(Bytes(5),6)
    ;Debug ExtHeader
    
    ;Frames auslesen
    If Extheader > 0
      FrameStart = 16
    Else
      FrameStart = 10
    EndIf
    
    ;unterschiedliche Behandlung der Versionen
    ;Versionen 3.x und 4.x bearbeiten
    
    If ID3Version = 3 Or ID3Version = 4
      DescriptPlus = 11
      Repeat
        FileSeek(0,FrameStart);zum Anfang
        FrameID$ = Chr(ReadByte(0))+Chr(ReadByte(0))+Chr(ReadByte(0))+Chr(ReadByte(0))
        ;Debug FrameID$
        FrameSize   = ReadByte(0)*256*8*8
        FrameSize   + ReadByte(0)*256*8
        FrameSize   + ReadByte(0)*256
        FrameSize   + ReadByte(0)
        DescriptionStart = FrameStart + DescriptPlus
        If FrameSize <> 0 ; sonst Überlauf
          FileSeek(0,DescriptionStart)
          ;AllocateMemory(0,FrameSize-1,0)
          MemoryID=AllocateMemory(FrameSize-1)
          ReadData(0,MemoryID,FrameSize-1)
          
          ;Winamp schreibt da komisches Zeug rein
          ;wahrscheinlich einen Sprachbezeichner
          ;den brauchen wir nicht, also weg damit
          Frame$ = PeekS(MemoryID,FrameSize-1)
          
          If FrameID$ = "COMM";Sprachbezeichner 3 Zeichen und NULLByte
            Frame$ = PeekS(MemoryID+4,FrameSize-1)
          EndIf
          
          If FrameId$ = "WXXX";Link fängt mit NULLByte an
            Frame$ = PeekS(MemoryID+1,FrameSize-1)
          EndIf
          
          FreeMemory(MemoryID)
          Select FrameID$
          Case "PCNT"
            Framename$ = "Play Counter:"+Frame$
          Case "TRCK"
            Framename$ = "Track:"+Frame$
          Case "TENC"
            Framename$ = "Encoded von:"+Frame$
          Case "WXXX"
            Framename$ = "Link:"+Frame$
          Case "TCOP"
            Framename$ = "Copyright (c):"+Frame$
          Case "TOPE"
            Framename$ = "Ursprünglicher Künstler:"+Frame$
          Case "TCOM"
            Framename$ = "Composer:"+Frame$
          Case "TCON"
            Framename$ = "Genre:"+Frame$
          Case "COMM"
            Framename$ = "Kommentar:"+Frame$
          Case "TYER"
            Framename$ = "Jahr:"+Frame$
          Case "TALB"
            Framename$ = "Album:"+Frame$
          Case "TPE1"
            Framename$ = "Künstler:"+Frame$
          Case "TIT2"
            Framename$ = "Titel:"+Frame$
          Case "TLAN"
            Framename$ = "Sprache:"+Frame$
          Case "TLEN"
            Framename$ = "Länge:"+Frame$
          Case "TMED"
            Framename$ = "Medientyp:"+Frame$
          Case "TPUB"
            Framename$ = "Publisher:"+Frame$
          Case "TSSE"
            Framename$ = "Decoding-Software:"+Frame$
            ;            Default
            ;            Framename$ = "unbekanntes Frame-Format:"+Frame$
          EndSelect
          If Frame$ <> ""
            Debug Framename$
          EndIf
        EndIf
        FrameStart + DescriptPlus + FrameSize -1
      Until FrameID$ = "" Or FrameID$ = "3DI";NULL Oder Footer
    EndIf
    
    ;Version 2.x bearbeiten
    If ID3Version = 2
      DescriptPlus = 6
      FrameSize = 0
      FrameStart = 10
      Repeat
        FileSeek(0,FrameStart);zum Anfang
        FrameID$ = Chr(ReadByte(0))+Chr(ReadByte(0))+Chr(ReadByte(0))
        FrameSize = 0
        FrameSize   + Asc(Chr(ReadByte(0)))*256*8
        FrameSize   + Asc(Chr(ReadByte(0)))*256
        FrameSize   + Asc(Chr(ReadByte(0)))
        ReadByte(0)
        
        If FrameSize > 0;sonst Überlauf
          ;AllocateMemory(0,FrameSize-1,0)
          MemoryID=AllocateMemory(FrameSize-1)
          ReadData(0,MemoryID,FrameSize-1)
          
          ;Sprachbezeichner ausfiltern
          Frame$ = PeekS(MemoryID,FrameSize-1)
          For i = 1 To 4
            If Mid(Frame$,i,1) = Chr(0)
              Frame$ = PeekS(MemoryID+4,FrameSize-1)
            EndIf
          Next I
          
          ;Frame$ = PeekS(MemoryID,FrameSize-1)
          FreeMemory(MemoryID)
          Select FrameID$
          Case "TRK"
            Framename$ = "Track:"+Frame$
          Case "TEN"
            Framename$ = "Encoded von:"+Frame$
          Case "TCR"
            Framename$ = "Copyright (c):"+Frame$
          Case "TOA"
            Framename$ = "Ursprünglicher Künstler:"+Frame$
          Case "TCM"
            Framename$ = "Composer:"+Frame$
          Case "TCO"
            Framename$ = "Genre:"+Frame$
          Case "COM"
            Framename$ = "Kommentar:"+Frame$
          Case "TYE"
            Framename$ = "Jahr:"+Frame$
          Case "TAL"
            Framename$ = "Album:"+Frame$
          Case "TP1"
            Framename$ = "Künstler:"+Frame$
          Case "TT2"
            Framename$ = "Titel:"+Frame$
          Case "TLA"
            Framename$ = "Sprache:"+Frame$
          Case "TMT"
            Framename$ = "Medientyp:"+Frame$
          Case "TSS"
            Framename$ = "Decoding-Software:"+Frame$
            Default
            Framename$ = "unbekanntes Frame-Format:"+Frame$
          EndSelect
          If Frame$ <> ""
            Debug Framename$
          EndIf
          
        EndIf
        FrameStart + FrameSize + DescriptPlus
      Until FrameSize = 0
    EndIf
    
  EndIf
  CloseFile(0)
Else
  Debug "Can't load File"
EndIf
End

DataSection
  Genre:
  Data.s "Blues"
  Data.s "Classic Rock"
  Data.s "Country"
  Data.s "Dance"
  Data.s "Disco"
  Data.s "Funk"
  Data.s "Grunge"
  Data.s "Hip-Hop"
  Data.s "Jazz"
  Data.s "Metal"
  Data.s "New Age"
  Data.s "Oldies"
  Data.s "Other"
  Data.s "Pop"
  Data.s "R&B"
  Data.s "Rap"
  Data.s "Reggae"
  Data.s "Rock"
  Data.s "Techno"
  Data.s "Industrial"
  Data.s "Alternative"
  Data.s "Ska"
  Data.s "Death Metal"
  Data.s "Pranks"
  Data.s "Soundtrack"
  Data.s "Euro-Techno"
  Data.s "Ambient"
  Data.s "Trip-Hop"
  Data.s "Vocal"
  Data.s "Jazz Funk"
  Data.s "Fusion"
  Data.s "Trance"
  Data.s "Classical"
  Data.s "Instrumental"
  Data.s "Acid"
  Data.s "House"
  Data.s "Game"
  Data.s "Sound Clip"
  Data.s "Gospel"
  Data.s "Noise"
  Data.s "AlternRock"
  Data.s "Bass"
  Data.s "Soul"
  Data.s "Punk"
  Data.s "Space"
  Data.s "Meditative"
  Data.s "Instrumental Pop"
  Data.s "Instrumental Rock"
  Data.s "Ethnic"
  Data.s "Gothic"
  Data.s "Darkwave"
  Data.s "Techno -Industrial"
  Data.s "Electronic"
  Data.s "Pop-Folk"
  Data.s "Eurodance"
  Data.s "Dream"
  Data.s "Southern Rock"
  Data.s "Comedy"
  Data.s "Cult"
  Data.s "Gangsta"
  Data.s "Top 40"
  Data.s "Christian Rap"
  Data.s "Pop/Funk"
  Data.s "Jungle"
  Data.s "Native American"
  Data.s "Cabaret"
  Data.s "New Wave"
  Data.s "Psychadelic"
  Data.s "Rave"
  Data.s "Showtunes"
  Data.s "TriGenreiler"
  Data.s "Lo-Fi"
  Data.s "Tribal"
  Data.s "Acid Punk"
  Data.s "Acid Jazz"
  Data.s "Polka"
  Data.s "Retro"
  Data.s "MusiciGenrel"
  Data.s "Rock & Roll"
  Data.s "Hard Rock"
  Data.s "Folk"
  Data.s "Folk-Rock"
  Data.s "National Folk"
  Data.s "Swing"
  Data.s "Fast Fusion"
  Data.s "Bebob"
  Data.s "Latin"
  Data.s "Revival"
  Data.s "Celtic"
  Data.s "Bluegrass"
  Data.s "Avantgarde"
  Data.s "Gothic Rock"
  Data.s "Progressive Rock"
  Data.s "Psychedelic Rock"
  Data.s "Symphonic Rock"
  Data.s "Slow Rock"
  Data.s "Big Band"
  Data.s "Chorus"
  Data.s "Easy Listening"
  Data.s "Acoustic"
  Data.s "Humour"
  Data.s "Speech"
  Data.s "Chanson"
  Data.s "Opera"
  Data.s "Chamber Music"
  Data.s "Sonata"
  Data.s "Symphony"
  Data.s "Booty Bass"
  Data.s "Primus"
  Data.s "Porn Groove"
  Data.s = "Satire"
  Data.s = "Slow Jam"
  Data.s "Club"
  Data.s "Tango"
  Data.s "Samba"
  Data.s "Folklore"
  Data.s "Ballad"
  Data.s "Power Ballad"
  Data.s "Rhythmic Soul"
  Data.s "Freestyle"
  Data.s "Duet"
  Data.s "Punk Rock"
  Data.s "Drum Solo"
  Data.s "A Capella"
  Data.s "Euro-House"
  Data.s "Dance Hall"
  Data.s "Goa"
  Data.s "Drum & Bass"
  Data.s "Club-House"
  Data.s "Hardcore"
  Data.s "Terror"
  Data.s "Indie"
  Data.s "BritPop"
  Data.s "Negerpunk"
  Data.s "Polsk Punk"
  Data.s "Beat"
  Data.s "Christian Gangsta Rap"
  Data.s "Heavy Metal"
  Data.s "Black Metal"
  Data.s "Crossover"
  Data.s "Contemporary Christian"
  Data.s "Christian Rock"
  Data.s "Merengue"
  Data.s "Salsa"
  Data.s "Thrash Metal"
  Data.s "Anime"
  Data.s "JPop"
  Data.s "Synthpop"
EndDataSection

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = -