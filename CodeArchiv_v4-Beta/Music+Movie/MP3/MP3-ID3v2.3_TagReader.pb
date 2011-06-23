; English forum: http://www.purebasic.fr/english/viewtopic.php?t=6935&highlight=
; Author: ebs (updated for PB4.00 by blbltheworm)
; Date: 18. July 2003
; OS: Windows
; Demo: Yes


; Simple ID3v2.3.x Tag Reader for MP3 Files 

Structure ID3v2 
  Title.s 
  Artist.s 
  Album.s 
  Comment.s 
  Year.s 
  Genre.s 
  Composer.s 
  URL.s 
  OrgArtist.s 
  Copyright.s 
  EncodedBy.s 
  Encoder.s 
  Track.s 
EndStructure 
Global TagID3v2.ID3v2 

Declare.l GetID3v2Tag(FileName.s) 

Repeat 
  MP3File.s = OpenFileRequester("Select MP3 File", "", "MP3 Files (*.mp3)|*.mp3", 0) 
  If GetID3v2Tag(MP3File) 
    ; display tag contents 
    Debug "Album: " + TagID3v2\Album 
    Debug "Artist: " + TagID3v2\Artist 
    Debug "Comment: " + TagID3v2\Comment 
    Debug "Composer: " + TagID3v2\Composer 
    Debug "Copyright: " + TagID3v2\Copyright 
    Debug "Encoded by: " + TagID3v2\EncodedBy 
    Debug "Encoder: " + TagID3v2\Encoder 
    Debug "Genre: " + TagID3v2\Genre 
    Debug "Original Artist: " + TagID3v2\OrgArtist 
    Debug "Title: " + TagID3v2\Title 
    Debug "Track: " + TagID3v2\Track 
    Debug "URL: " + TagID3v2\URL 
    Debug "Year: " + TagID3v2\Year 
    Debug "" 
  EndIf 
Until MP3File = "" 
End 

;- read ID3v2.3.x tag fields from MP3 file 
Procedure.l GetID3v2Tag(FileName.s) 
  If FileName = "" 
    ProcedureReturn #False 
  EndIf 
  
  ReadFile(1, FileName) 
  
  ID3.s = Space(3) 
  ReadData(1,@ID3, 3) 
  ; must be ID3v2.3.x 
  If ID3 = "ID3" And ReadByte(1) = $03 
    ID3Exists = #True 
    ; skip revision and flag bytes 
    ReadWord(1) 
    ; get tag size 
    ID3Size.l = 0 
    For Byte.l = 3 To 0 Step -1 
      ID3Size + (ReadByte(1) << (7*Byte)) 
    Next 
  Else 
    ; no ID3v2.3.x tag present 
    CloseFile(1) 
    ProcedureReturn #False 
  EndIf 
  
  ; clear tag contents 
  TagID3v2\Album = "" 
  TagID3v2\Artist = "" 
  TagID3v2\Comment = "" 
  TagID3v2\Composer = "" 
  TagID3v2\Copyright = "" 
  TagID3v2\EncodedBy = "" 
  TagID3v2\Encoder = "" 
  TagID3v2\Genre = "" 
  TagID3v2\OrgArtist = "" 
  TagID3v2\Title = "" 
  TagID3v2\Track = "" 
  TagID3v2\URL = "" 
  TagID3v2\Year = "" 
  
  Size.l = 0 
  Repeat 
    ; get frames until no more 
    FrameID.s = Space(4) 
    ReadData(1,@FrameID, 4) 
    If Asc(Left(FrameID, 1)) = 0 
      ; no more frames 
      CloseFile(1) 
      ProcedureReturn #True 
    EndIf 
    
    ; get frame size 
    FrameSize.l = 0 
    For Byte.l = 3 To 0 Step -1 
      FrameSize + (ReadByte(1) << (7*Byte)) 
    Next 
    ; add frame size to total size 
    Size + FrameSize 
    
    ; skip flag and language bytes 
    ReadWord(1) 
    ReadByte(1) 
    
    ; get frame contents 
    ; subtract one for language byte 
    FrameSize - 1 
    Contents.s = Space(FrameSize) 
    ReadData(1,@Contents, FrameSize) 
    
    ; put frame contents into structure 
    Select FrameID 
      Case "TALB" 
        TagID3v2\Album = Contents 
      Case "TCOM" 
        TagID3v2\Composer = Contents 
      Case "TCON" 
        TagID3v2\Genre = Contents 
      Case "TCOP" 
        TagID3v2\Copyright = Contents 
      Case "TENC" 
        TagID3v2\EncodedBy = Contents 
      Case "TIT2" 
        TagID3v2\Title = Contents 
      Case "TOPE" 
        TagID3v2\OrgArtist = Contents 
      Case "TPE1" 
        TagID3v2\Artist = Contents 
      Case "TRCK" 
        TagID3v2\Track = Contents 
      Case "TSSE" 
        TagID3v2\Encoder = Contents 
      Case "TYER" 
        TagID3v2\Year = Contents 
      Case "COMM" 
        TagID3v2\Comment = Contents 
      Case "WXXX" 
        TagID3v2\URL = Contents 
    EndSelect 
  ; stop if tag size reached/exceeded  
  Until Size >= ID3Size 

  CloseFile(1) 
  ProcedureReturn #True 
EndProcedure

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
; EnableXP
