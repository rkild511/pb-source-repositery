; /**
;  * Audiere Sound System
;  * Version 1.9.3
;  * (c) 2001-2003 Chad Austin
;  *
;  * This API uses principles explained at
;  * http://aegisknight.org/cppinterface.html
;  *
;  * This code licensed under the terms of the LGPL.  See doc/license.txt.
;  *
;  *
;  * Note: When compiling This header in gcc, you may want To use the
;  * -Wno-non-virtual-dtor flag To get rid of those annoying "class has
;  * virtual functions but no virtual destructor" warnings.
;  */
;  * 
;  *
;  *
;  * Purebasic Version of the Audiere Sound System Include File
;  * by WolfgangS@gmx.de 28.10.2003
;  *
;  * 25.10.03 alpha 10
;  *          Inlcude file complete rewritten for Purebasic's new opportunity to
;  *          use com objects.
;  * 28.10.03 beta 1_2



; Set this constant in your main program! (It's just here to have a self-compiling code)
#audiere = 0


; *
; * Converts a Float to a Double
; * 
Structure dblout
  p1.l
  p2.l
EndStructure

Procedure DoublePart1(flt.f)
  Global _input.f:_input.f=flt
  Global _dblout.dblout
  !FLD dword[v__input]
  !FST qword[v__dblout]
  ProcedureReturn _dblout\p1
EndProcedure

Procedure DoublePart2(flt.f)
  Global _input.f:_input.f=flt
  Global _dblout.dblout
  !FLD dword[v__input]
  !FST qword[v__dblout]
  ProcedureReturn _dblout\p2
EndProcedure





; *
; * Converts DOUBLE(part1,part2) To FLOAT
; *
Procedure.f Float(p1.l,p2.l)
  Global _output.f
  Global _dblin.dblout
  _dblin\p1=p1
  _dblin\p2=p2
  !FLD qword[v__dblin]
  !FST dword[v__output]
  ProcedureReturn _output
EndProcedure






Interface RefCounted 
   ref()                ; Long
   unref()              ; Long
EndInterface 





Interface file Extends RefCounted 
  _Read(pbuffer.l,size.l)      ; long
  seek(position.l,SeekMode.l)  ; bool
  tell()                       ; long
EndInterface





Interface SampleBuffer Extends RefCounted 
  getFormat(channel_count.l,sample_rate.l,sample_format.l)  ; void
  getLength()                                               ; long
  getSamples()                                              ; long
  openStream()                                              ; pSampleSource
EndInterface





Interface SampleSource Extends RefCounted 
  getFormat(long.l,long.l)      ; void
  Read(long.l,long.l)          ; long
  reset()                       ; void
  isSeekable()                  ; bool
  getLength()                   ; long
  setPosition(long.l)           ; void
  getPosition()                 ; long
  getRepeat()                   ; bool
  setRepeat(bool.l)             ; void
EndInterface



Interface LoopPointSource Extends SampleSource  
  addLoopPoint(location.l,target.l,loopCount.l)             ; void
  removeLoopPoint(index.l)                                  ; void
  getLoopPointCount()                                       ; long
  getLoopPoint(index.l,plocation.l,ptarget.l,ploopCount.l)  ; bool
EndInterface



Interface OutputStream Extends RefCounted 
  play() 
  stop()                 ; bool
  isPlaying()            ; bool
  reset()                ; void
  setRepeat(bool.l)      ; void
  getRepeat()            ; bool
  setVolume(float.f)     ; void
  getVolume()            ; float
  setPan(float.f)        ; void
  getPan()               ; float
  setPitchShift(float.f) ; void
  getPitchShift()        ; float
  isSeekable()           ; bool
  getLength()            ; int
  setPosition(int.l)     ; void
  getPosition()          ; int
EndInterface




Interface AudioDevice Extends RefCounted
  update()                               ; void
  openStream(pSampleSource.l)            ; pOutputStream
  openBuffer(pSamples.l,frame_count.l,channel_count.l,sample_rate.l,sample_format.l); pOutputStream
  getName()                              ; char.l
EndInterface





Interface SoundEffect Extends RefCounted 
  play()                          ; void
  stop()                          ; void
  setVolume(volume.f)             ; void
  getVolume()                     ; float
  setPan(pan.f)                   ; void
  getPan()                        ; float
  setPitchShift(shift.f)          ; void
  getPitchShift()                 ; float
EndInterface





Enumeration ; SampleFormat 
  #SF_U8      ; unsigned 8-bit integer [0,255]
  #SF_S16     ; signed 16-bit integer in host endianness [-32768,32767]
EndEnumeration



Enumeration ; FileFormat
  #FF_AUTODETECT
  #FF_WAV
  #FF_OGG
  #FF_FLAC
  #FF_MP3
  #FF_MOD
  #FF_AIFF
EndEnumeration



Enumeration ; SoundEffectType 
  #SINGLE
  #MULTIPLE
EndEnumeration




Enumeration ; SeekMode 
  #begin
  #current
  #End
EndEnumeration







;     /**
;      * Returns a formatted string that lists the file formats that Audiere
;      * supports.  This function is DLL-safe.
;      *
;      * it is formatted in the following way:
;      *
;      * description1:ext1,ext2,ext3;description2:ext1,ext2,ext3
;      */
;     ADR_FUNCTION(const char*) AdrGetSupportedFileFormats();
Procedure.l AUDIERE_GetSupportedFileFormats()
  ProcedureReturn CallFunction(#audiere,"_AdrGetSupportedFileFormats@0")
EndProcedure

;
;     /**
;      * Returns a formatted string that lists the audio devices Audiere
;      * supports.  This function is DLL-safe.
;      *
;      * it is formatted in the following way:
;      *
;      * name1:description1;name2:description2;...
;      */
;     ADR_FUNCTION(const char*) AdrGetSupportedAudioDevices();
Procedure.l AUDIERE_GetSupportedAudioDevices()
  ProcedureReturn CallFunction(#audiere,"_AdrGetSupportedAudioDevices@0") 
EndProcedure 
;   /**
;    * Returns the Audiere Version string.
;    *
;    * @Return  Audiere Version information
;    */
;   inline const char* GetVersion() {
;     Return hidden::AdrGetVersion();
;   }
Procedure.l AUDIERE_GetVersion() 
  ProcedureReturn CallFunction(#audiere,"_AdrGetVersion@0") 
EndProcedure 




;   /**
;    * get the size of a sample in a specific sample format.
;    * This is commonly used To determine how many bytes a chunk of
;    * PCM Data will take.
;    *
;    * @Return  number of bytes a single sample in the specified format
;    *          takes.
;    */
;   inline int GetSampleSize(SampleFormat format) {
;     Return hidden::AdrGetSampleSize(format);
;   }
Procedure.l AUDIERE_GetSampleSize(help1.l)
  ProcedureReturn CallFunction(#audiere,"_AdrGetSampleSize@4",help1.l) 
EndProcedure 
;   /**
;    * Open a new audio device. If name Or parameters are not specified,
;    * Defaults are used. Each platform has its own set of audio devices.
;    * Every platform supports the "null" audio device.
;    *
;    * @param  name  name of audio device that should be used
;    * @param  parameters  comma delimited list of audio-device parameters;
;    *                     For example, "buffer=100,rate=44100"
;    *
;    * @Return  new audio device object If OpenDevice succeeds, And 0 in Case
;    *          of failure
;    */
;   inline AudioDevice* OpenDevice(
;     const char* name = 0,
;     const char* parameters = 0)
;   {
;     Return hidden::AdrOpenDevice(name, parameters);
;   }
Procedure.l AUDIERE_OpenDevice(device.l,parameter.l)        ; OK
  ProcedureReturn CallFunction(#audiere,"_AdrOpenDevice@8",device.l,parameter.l) 
EndProcedure 




;   /**
;    * Create a streaming sample Source from a Sound file.  This factory simply
;    * opens a Default file from the System filesystem And calls
;    * OpenSampleSource(file*).
;    *
;    * @See OpenSampleSource(file*)
;    */
;   inline SampleSource* OpenSampleSource(
;     const char* filename,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     Return hidden::AdrOpenSampleSource(filename, file_format);
;   }
Procedure.l AUDIERE_OpenSampleSource(help1.l,help2.l)       ; OK
  ProcedureReturn CallFunction(#audiere,"_AdrOpenSampleSource@8",help1.l,help2.l)
EndProcedure

;   /**
;    * opens a sample Source from the specified file object.  If the Sound file
;    * cannot be opened, This factory function Returns 0.
;    *
;    * @Note  Some Sound Files support seeking, While Some don't.
;    *
;    * @param file         file object from which To Open the decoder
;    * @param file_format  format of the file To load.  If FF_AUTODETECT,
;    *                     Audiere will try opening the file in Each format.
;    *
;    * @Return  new SampleSource If OpenSampleSource succeeds, 0 otherwise
;    */
;   inline SampleSource* OpenSampleSource(
;     const FilePtr& file,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     Return hidden::AdrOpenSampleSourceFromFile(File.get(), file_format);
;   }
; 

Procedure.l AUDIERE_OpenSampleSourceFromFile(help1.l,help2.l)
  ProcedureReturn CallFunction(#audiere,"_AdrOpenSampleSourceFromFile@8",help1.l,help2.l)
EndProcedure






;   /**
;    * Create a tone sample Source with the specified frequency.
;    *
;    * @param  frequency  frequency of the tone in Hz.
;    *
;    * @Return  tone sample Source
;    */
;   inline SampleSource* CreateTone(double frequency) {
;     Return hidden::AdrCreateTone(frequency);
;   }
Procedure.l AUDIERE_CreateTone(help1.l,help2.l)       ; OK
  ProcedureReturn CallFunction(#audiere,"_AdrCreateTone@8",help1.l,help2.l) 
EndProcedure 




;   /**
;    * Create a square wave with the specified frequency.
;    *
;    * @param  frequency  frequency of the wave in Hz.
;    *
;    * @Return  wave sample Source
;    */
;   inline SampleSource* CreateSquareWave(double frequency) {
;     Return hidden::AdrCreateSquareWave(frequency);
;   }
; 
Procedure.l AUDIERE_CreateSquareWave(help1.l,help2.l)     ; OK
    ProcedureReturn CallFunction(#audiere,"_AdrCreateSquareWave@8",help1.l,help2.l)
EndProcedure
  


;   /**
;    * Create a white noise sample Source.  white noise is just random
;    * Data.
;    *
;    * @Return  white noise sample Source
;    */
;   inline SampleSource* CreateWhiteNoise() {
;     Return hidden::AdrCreateWhiteNoise();
;   }
Procedure.l AUDIERE_CreateWhiteNoise()    ;-> OK
  ProcedureReturn CallFunction(#audiere,"_AdrCreateWhiteNoise@0") 
EndProcedure 



;   /**
;    * Create a pink noise sample Source.  pink noise is noise with equal
;    * power distribution among octaves (logarithmic), not frequencies.
;    *
;    * @Return  pink noise sample Source
;    */
;   inline SampleSource* CreatePinkNoise() {
;     Return hidden::AdrCreatePinkNoise();
;   }
Procedure.l AUDIERE_CreatePinkNoise()     ;-> OK
  ProcedureReturn CallFunction(#audiere,"_AdrCreatePinkNoise@0")
EndProcedure




;   /**
;    * Create a LoopPointSource from a SampleSource.  the SampleSource must
;    * be seekable.  If it isn't, or the source isn'T valid, This function
;    * Returns 0.
;    */
;   inline LoopPointSource* CreateLoopPointSource(
;     const SampleSourcePtr& Source)
;   {
;     Return hidden::AdrCreateLoopPointSource(source.get());
;   }
Procedure.l AUDIERE_CreateLoopPointSource(help1.l)
  ProcedureReturn CallFunction(#audiere,"_AdrCreateLoopPointSource@4",help1.l)
EndProcedure



; 
;   /**
;    * Creates a LoopPointSource from a Source loaded from a file.
;    */
;   inline LoopPointSource* CreateLoopPointSource(
;     const char* filename,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     Return CreateLoopPointSource(OpenSampleSource(filename, file_format));
;   }
Procedure.l AUDIERE_CreateLoopPointSourceFile(help1.l,help2.l)
  ProcedureReturn CallFunction(#audiere,"_AdrCreateLoopPointSource@4",AUDIERE_OpenSampleSource(help1,help2.l))
EndProcedure



;   /**
;    * Creates a LoopPointSource from a Source loaded from a file.
;    */
;   inline LoopPointSource* CreateLoopPointSource(
;     const FilePtr& file,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     Return CreateLoopPointSource(OpenSampleSource(file, file_format));
;   }



; 
;   /**
;    * try To Open a Sound buffer using the specified AudioDevice And
;    * sample Source.  If the specified sample Source is seekable, it
;    * loads it into memory And uses AudioDevice::openBuffer To Create
;    * the output stream.  If the stream is not seekable, it uses
;    * AudioDevice::openStream To Create the output stream.  This means
;    * that certain file types must always be streamed, And therefore,
;    * OpenSound will hold on To the file object.  If you must guarantee
;    * that the file on disk is no longer referenced, you must Create
;    * your own memory file implementation And load your Data into that
;    * before calling OpenSound.
;    *
;    * @param device  AudioDevice in which To Open the output stream.
;    *
;    * @param Source  SampleSource used To generate samples For the Sound
;    *                object.  OpenSound takes ownership of Source, even
;    *                If it Returns 0.  (in that Case, OpenSound immediately
;    *                deletes the SampleSource.)
;    *
;    * @param streaming  If false Or unspecified, OpenSound attempts To
;    *                   Open the entire Sound into memory.  otherwise, it
;    *                   streams the Sound from the file.
;    *
;    * @Return  new output stream If successful, 0 otherwise
;    */
;   inline OutputStream* OpenSound(
;     const AudioDevicePtr& device,
;     const SampleSourcePtr& Source,
;     bool streaming = false)
;   {
;     Return hidden::AdrOpenSound(device.get(), source.get(), streaming);
;   }
Procedure.l AUDIERE_OpenSound(device.l,name.l,flag.l)   ; ->OK
  ProcedureReturn CallFunction(#audiere,"_AdrOpenSound@12",device.l,name.l,flag.l)  ; "_AdrOpenSound@12" 
EndProcedure 
; 
;   /**
;    * calls OpenSound(AudioDevice*, SampleSource*) with a sample Source
;    * created via OpenSampleSource(const char*).
;    */
;   inline OutputStream* OpenSound(
;     const AudioDevicePtr& device,
;     const char* filename,
;     bool streaming = false,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     SampleSource* Source = OpenSampleSource(filename, file_format);
;     Return OpenSound(device, Source, streaming);
;   }
; 
;   /**
;    * calls OpenSound(AudioDevice*, SampleSource*) with a sample Source
;    * created via OpenSampleSource(file* file).
;    */
;   inline OutputStream* OpenSound(
;     const AudioDevicePtr& device,
;     const FilePtr& file,
;     bool streaming = false,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     SampleSource* Source = OpenSampleSource(file, file_format);
;     Return OpenSound(device, Source, streaming);
;   }
; 
;   /**
;    * Create a SampleBuffer object using the specified samples And formats.
;    *
;    * @param samples  pointer to a buffer of samples used To initialize the
;    *                 new object.  If This is 0, the sample buffer contains
;    *                 just silence.
;    *
;    * @param frame_count  size of the sample buffer in frames.
;    *
;    * @param channel_count  number of channels in Each frame.
;    *
;    * @param sample_rate  sample rate in Hz.
;    *
;    * @param sample_format  format of Each sample.  @See SampleFormat.
;    *
;    * @Return  new SampleBuffer object
;    */
;   inline SampleBuffer* CreateSampleBuffer(
;     void* samples,
;     int frame_count,
;     int channel_count,
;     int sample_rate,
;     SampleFormat sample_format)
;   {
;     Return hidden::AdrCreateSampleBuffer(
;       samples, frame_count,
;       channel_count, sample_rate, sample_format);
;   }
Procedure.l AUDIERE_CreateSampleBuffer(help1.l,help2.l,help3.l,help4.l,help5.l)
  ProcedureReturn CallFunction(#audiere,"_AdrCreateSampleBuffer@20",help1.l,help2.l,help3.l,help4.l,help5.l)
EndProcedure




 
;   /**
;    * Create a SampleBuffer object from a SampleSource.
;    *
;    * @param Source  seekable sample Source used To Create the buffer.
;    *                If the Source is not seekable, then the function
;    *                fails.
;    *
;    * @Return  new sample buffer If success, 0 otherwise
;    */
;   inline SampleBuffer* CreateSampleBuffer(const SampleSourcePtr& Source) {
;     Return hidden::AdrCreateSampleBufferFromSource(source.get());
;   }
Procedure.l AUDIERE_CreateSampleBufferFromSource(help1.l)
  ProcedureReturn CallFunction(#audiere,"_AdrCreateSampleBufferFromSource@4",help1.l)
EndProcedure


;   /**
;    * Open a SoundEffect object from the given sample Source And Sound
;    * effect type.  @See SoundEffect
;    *
;    * @param device  AudioDevice on which the Sound is played.
;    *
;    * @param Source  the sample Source used To feed the Sound effect
;    *                with Data.
;    *
;    * @param type  the type of the Sound effect.  If type is Multiple,
;    *              the Source must be seekable.
;    *
;    * @Return  new SoundEffect object If successful, 0 otherwise
;    */
;   inline SoundEffect* OpenSoundEffect(
;     const AudioDevicePtr& device,
;     const SampleSourcePtr& Source,
;     SoundEffectType type)
;   {
;     Return hidden::AdrOpenSoundEffect(device.get(), source.get(), type);
;   }
Procedure.l AUDIERE_OpenSoundEffect(help1.l,help2.l,help3.l)
  ProcedureReturn CallFunction(#audiere,"_AdrOpenSoundEffect@12",help1.l,help2,help3.l)
EndProcedure





;   /**
;    * calls OpenSoundEffect(AudioDevice*, SampleSource*,
;    * SoundEffectType) with a sample Source created from the filename.
;    */
;   inline SoundEffect* OpenSoundEffect(
;     const AudioDevicePtr& device,
;     const char* filename,
;     SoundEffectType type,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     SampleSource* Source = OpenSampleSource(filename, file_format);
;     Return OpenSoundEffect(device, Source, type);
;   }
; 



;   /**
;    * calls OpenSoundEffect(AudioDevice*, SampleSource*,
;    * SoundEffectType) with a sample Source created from the file.
;    */
;   inline SoundEffect* OpenSoundEffect(
;     const AudioDevicePtr& device,
;     const FilePtr& file,
;     SoundEffectType type,
;     FileFormat file_format = FF_AUTODETECT)
;   {
;     SampleSource* Source = OpenSampleSource(file, file_format);
;     Return OpenSoundEffect(device, Source, type);
;   }
; 



;   /**
;    * opens a Default file implementation from the local filesystem.
;    *
;    * @param filename   the name of the file on the local filesystem.
;    * @param writeable  whether the writing To the file is allowed.
;    */
;   inline file* OpenFile(const char* filename, bool writeable) {
;     Return hidden::AdrOpenFile(filename, writeable);
;   }
Procedure.l AUDIERE_OpenFile(help1.l,help2.l)
  ProcedureReturn CallFunction(#audiere,"_AdrOpenFile@8",help1.l,help2.l)
EndProcedure

;   /**
;    * Creates a file implementation that reads from a buffer in memory.
;    * it stores a copy of the buffer that is passed in.
;    *
;    * the file object does <i>not</i> take ownership of the memory buffer.
;    * When the file is destroyed, it will not free the memory.
;    *
;    * @param buffer  pointer To the beginning of the Data.
;    * @param size    size of the buffer in bytes.
;    *
;    * @Return  0 If size is non-zero And buffer is null. otherwise,
;    *          Returns a valid file object.
;    */
;   inline file* CreateMemoryFile(const void* buffer, int size) {
;     Return hidden::AdrCreateMemoryFile(buffer, size);
Procedure AUDIERE_CreateMemoryFile(help1.l,help2.l)
  ProcedureReturn CallFunction(#audiere,"_AdrCreateMemoryFile@8",help1.l,help2.l)
EndProcedure
;   }
;     
; }
; 
; 
; #endif
; ExecutableFormat=Windows
; CursorPosition=26
; FirstLine=1
; EOF

; IDE Options = PureBasic v4.02 (Windows - x86)
; Folding = ----
; EnableXP