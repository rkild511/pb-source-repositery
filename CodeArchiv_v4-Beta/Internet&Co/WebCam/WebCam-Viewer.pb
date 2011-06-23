; English forum: http://www.purebasic.fr/english/viewtopic.php?t=29273#29273
; Author: midebor (updated for PB4.00 by blbltheworm)
; Date: 29. June 2003
; OS: Windows
; Demo: No
; 
; ------------------------------------------------------------ 
; Purebasic Webcam viewer by midebor (mdb@skynet.be) 

; The programm uses URLDownloadToFile Api to download Webcam images 
; to temp.jpg file and displays them using the UseJPEGImageDecoder() 
; function. 
; The program assumes you are already connected To the Internet 
; Has only been tested with ADSL connection 
; ------------------------------------------------------------ 
; 

UseJPEGImageDecoder() ; to decode the "temp.jpg" file 


; ------------------ List of camera's ------------------------ 
Structure List 
  Nam.s ; The Webcam's descriptionin shown in the window header 
  URL.s ; The complete webcam's URL 
EndStructure 

  
Global Dim cam.List(50) 
cam(1)\Nam = "Antwerpen Zeevaartschool" 
cam(1)\URL = "http://www.hzs.be/antwerp/schelde.jpg" 
cam(2)\Nam = "Bad Godesberg" 
cam(2)\URL = "http://www.general-anzeiger-bonn.de/images/neteye/stadthaus.jpg" 
cam(3)\Nam = "Berlin - Podsdammerplatz" 
cam(3)\URL = "http://www.cityscope.de/pp/panos/cityscope.jpg" 
cam(4)\Nam = "Big Ben" 
cam(4)\URL = "http://www.webviews.co.uk/liveimages/bigben.jpg" 
cam(5)\Nam = "Bruxelles Avenue de Terveuren" 
cam(5)\URL = "http://camera.viking.be/images/ispy.jpg" 
cam(6)\Nam = "CFN WebCam" 
cam(6)\URL = "http://www.spiretech.com/~leonard/cfn/webcam/webcam.jpg" 
cam(7)\Nam = "DAX" 
cam(7)\URL = "http://deutsche-boerse.com/parkett/parkett2.jpg" 
cam(8)\Nam = "De Haan Belgium" 
cam(8)\URL = "http://www.dehaan.be/webcam/Video01.jpg" 
cam(9)\Nam = "Del Mar Beach Cam" 
cam(9)\URL = "http://os1.prod.camzone.com/camzone-ie?delmar:1:1025193280125:0" 
cam(10)\Nam = "Dome of Cologne" 
cam(10)\URL = "http://www02.wdr.de/webcam/cam1.jpg" 
cam(11)\Nam = "Essen-Kupferdreh" 
cam(11)\URL = "http://www.kupferdreh.de/cam.jpg" 
cam(12)\Nam = "Europe Weather Satelite" 
cam(12)\URL = "http://www.usatoday.com/weather/twc_images/europesat_440x297.jpg" 
cam(13)\Nam = "GameStar Online-Webcam" 
cam(13)\URL = "http://www.gamestar.de/aktuell/webcam/cam.jpg" 
cam(14)\Nam = "Ground Zero" 
cam(14)\URL = "http://65.200.140.25/ec_metros/ourcams/johnst.jpg" 
cam(15)\Nam = "Iowa State University" 
cam(15)\URL = "http://www.iastate.edu/webcam/hugesize.jpg" 
cam(16)\Nam = "Jericho Beach, Vancouver" 
cam(16)\URL = "http://www.jericho.ca/webcam/images/webcam.jpg" 
cam(17)\Nam = "Kauai, Hawaii" 
cam(17)\URL = "http://hawaiiweathertoday.com/images/webcam_kauai.jpg" 
cam(18)\Nam = "Knokke" 
cam(18)\URL = "http://www.quiksilver.be/beachcam/live/beach.jpg" 
cam(19)\Nam = "Koenigssee, Germany" 
cam(19)\URL = "http://www.koenigssee.com/rodelbahn/fsc4.jpg" 
cam(20)\Nam = "La Tour Eifel" 
cam(20)\URL = "http://www.images-abcparislive.com/eiffel1.jpg?1011467343523" 
cam(21)\Nam = "Louvain La Neuve Belgium" 
cam(21)\URL = "http://www.sri.ucl.ac.be/SRI/webcam/universite.jpg" 
cam(22)\Nam = "MGM Grand (Las Vegas)" 
cam(22)\URL = "http://images.earthcam.com/ec_metros/ourcams/mgm.jpg" 
cam(23)\Nam = "Midvale Hill (Highway 95)" 
cam(23)\URL = "http://www.ruralnetwork.net/~rnsmvlcm/midvalehill.jpg" 
cam(24)\Nam = "MOBOTIX M1 PreParkCam" 
cam(24)\URL = "http://preparkcam.mobotixserver.de/record/current.jpg" 
cam(25)\Nam = "New York Times Square Cam 1" 
cam(25)\URL = "http://images.earthcam.com/ec_metros/ourcams/lindys.jpg" 
cam(26)\Nam = "New York Times Square Cam 2" 
cam(26)\URL = "http://images.earthcam.com/ec_metros/ourcams/lennon.jpg" 
cam(27)\Nam = "Niagara Falls" 
cam(27)\URL = "http://www.fallsview.com/fallsmain.jpg" 
cam(28)\Nam = "Nieuwpoort Belgium)" 
cam(28)\URL = "http://www.vvwnieuwpoort.be/webcam/images/webcam.jpg" 
cam(29)\Nam = "Oostende aan zee - Belgium" 
cam(29)\URL = "http://aanzee.be/images/groot.jpg" 
cam(30)\Nam = "Oostende Camera radioamateurs" 
cam(30)\URL = "http://www.flanderswebhost.com/webcams/radiocam/radiocam.jpg" 
cam(31)\Nam = "Oostende Webcam" 
cam(31)\URL = "http://www.oostende.net/webcam/oostendecam.jpg" 
cam(32)\Nam = "Panama Canal, Miraflores Locks" 
cam(32)\URL = "http://www.pancanal.com/miraflores/miraflores.jpg" 
cam(33)\Nam = "Poppies Pool, Bali" 
cam(33)\URL = "http://www.poppies.net/webcam.jpg" 
cam(34)\Nam = "Poppies Restaurant, Bali" 
cam(34)\URL = "http://www.poppies.net/webcam1.jpg" 
cam(35)\Nam = "Prague" 
cam(35)\URL = "http://193.165.174.197/fullsize.jpg" 
cam(36)\Nam = "PSC/EET Weather Station (New York)" 
cam(36)\URL = "http://www.paulsmiths.edu/aai/eet/aaicam.jpg" 
cam(37)\Nam = "San Diego Zoo Panda Cam" 
cam(37)\URL = "http://outstream.camzone.com/camzone-ie?zoo:2:1020871595627:0" 
cam(38)\Nam = "World - Shamu Cam" 
cam(38)\URL = "http://outstream.camzone.com/camzone-ie?shamu:13:1023798289913" 
cam(39)\Nam = "Seattle" 
cam(39)\URL = "http://images.earthcam.com/ec_metros/washingtonst/seattle/marqueen.jpg" 
cam(40)\Nam = "Stadt Neuburg" 
cam(40)\URL = "http://www.neuburg-donau.de/donaucam/donaukai.jpg" 
cam(41)\Nam = "Trafalgar Square" 
cam(41)\URL = "http://www.webviews.co.uk/liveimages/trafalgarsq.jpg" 
cam(42)\Nam = "University of Arizona" 
cam(42)\URL = "http://www.cs.arizona.edu/camera/view.jpg" 
cam(43)\Nam = "University of Iowa" 
cam(43)\URL = "http://www.iihr.uiowa.edu/webcam/cam.jpg" 
cam(44)\Nam = "USS Intrepid Cam (New York City)" 
cam(44)\URL = "http://65.200.140.25/ec_metros/ourcams/intrepid.jpg" 
cam(45)\Nam = "Waikiki in Honolulu" 
cam(45)\URL = "http://images.earthcam.com/ec_metros/hawaii/waikiki.jpg" 
cam(46)\Nam = "Washington Memorial" 
cam(46)\URL = "http://images.earthcam.com/ec_metros/washington/metrosquare.jpg" 
cam(47)\Nam = "Weimar" 
cam(47)\URL = "http://www.thueringer-webcams.de/weimar/theaterplatz/fullsize.jpg" 
cam(48)\Nam = "WorldTradeAftermath.com" 
cam(48)\URL = "http://worldtradeaftermath.com/capture0.jpg" 
cam(49)\Nam = "Zeebrugge Belgium" 
cam(49)\URL = "http://www.rustyhouse.com/beachcam/beachcam.jpg" 


  
  For i = 1 To 49 
    If URLDownloadToFile_(0, cam(i)\URL, "temp.jpg", 0, 0); 
    EndIf 
    LoadImage(0, "temp.jpg") 
    If OpenWindow(0, 0, 0, ImageWidth(0), ImageHeight(0), "PB - Webcam " + Str(i) + " : " + cam(i)\Nam, #PB_Window_SystemMenu)        
      CreateGadgetList(WindowID(0)) 
      ImageGadget(0, 0, 0, ImageWidth(0), ImageHeight(0), ImageID(0), #PB_Image_Border) 
      Repeat 
      Until WaitWindowEvent() = #PB_Event_CloseWindow 
      Else 
      MessageRequester("Error", "Can't load the image...", 0) 
    EndIf 
  Next i 
End 

; IDE Options = PureBasic v4.00 (Windows - x86)
; Folding = -
