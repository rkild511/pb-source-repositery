; German forum: http://www.purebasic.fr/german/archive/viewtopic.php?t=1350&highlight=
; Author: J-The-Grey
; Date: 15. June 2003
; OS: Windows
; Demo: Yes


; Reads all possible MP3 music genre into the specified array, useful for displaying the 'genre'
; (get it with one of the MP3-ID1 Tag programs) in text form instead of the 'genre' ID...

; Liest alle möglichen MP§ Musikgenres in das angegebene Array. Nützlich für das Anzeigen des
; 'Genre' (kann mit einem der MP3 ID1 Tag Programme ermittelt werden) in Textform anstelle der
; 'Genre' ID Nummer.,,

Dim genre.s(147) 
For i=0 To 146 
    Read genre.s(i) 
Next 

DataSection 
  Data.s "Blues", "Classic Rock", "Country", "Dance", "Disco", "Funk", "Grunge", "Hip-Hop", "Jazz", "Metal" 
  Data.s "New Age", "Oldies", "Other", "Pop", "R&B", "Rap", "Reggae", "Rock", "Techno", "Industrial" 
  Data.s "Alternative", "Ska", "Death Metal", "Pranks", "Soundtrack", "Euro-Techno", "Ambient", "Trip-Hop", "Vocal", "Jazz+Funk" 
  Data.s "Fusion", "Trance", "Classical", "Instrumental", "Acid", "House", "Game", "Sound Clip", "Gospel", "Noise" 
  Data.s "AlternRock", "Bass", "Soul", "Punk", "Space", "Meditative", "Instrumental Pop", "Instrumental Rock", "Ethnic", "Gothic" 
  Data.s "Darkwave", "Techno-Industrial", "Electronic", "Pop-Folk", "Eurodance", "Dream", "Southern Rock", "Comedy", "Cult", "Gangsta" 
  Data.s "Top 40", "Christian Rap", "Pop/Funk", "Jungle", "Native American", "Cabaret", "New Wave", "Psychadelic", "Rave", "Showtunes" 
  Data.s "Trailer", "Lo-Fi", "Tribal", "Acid Punk", "Acid Jazz", "Polka", "Retro", "Musical", "Rock & Roll", "Hard Rock" 
  Data.s "Folk", "Folk-Rock", "National Folk", "Swing", "Fast Fusion", "Bebob", "Latin", "Revival", "Celtic", "Bluegrass" 
  Data.s "Avantgarde", "Gothic Rock", "Progressive Rock", "Psychedelic Rock", "Symphonic Rock", "Slow Rock", "Big Band", "Chorus", "Easy Listening", "Acoustic" 
  Data.s "Humour", "Speech", "Chanson", "Opera", "Chamber Music", "Sonata", "Symphony", "Booty Bass", "Primus", "Porn Groove" 
  Data.s "Satire", "Slow Jam", "Club", "Tango", "Samba", "Folklore", "Ballad", "Power Ballad", "Rhythmic Soul", "Freestyle" 
  Data.s "Duet", "Punk Rock", "Drum Solo", "Acapella", "Euro-House", "Dance Hall", "Goa", "Drum & Bass", "Club-House", "Hardcore", "Terror", "indie", "Brit Pop", "Negerpunk" 
  Data.s "Polsk Punk", "Beat", "Christian Gangsta Rap", "Heavy Metal", "Black Metal", "Crossover", "Comteporary Christian" 
  Data.s "Christian Rock", "Merengue", "Salsa", "Trash Metal", "Anime", "JPop", "Synth Pop" 
EndDataSection 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
