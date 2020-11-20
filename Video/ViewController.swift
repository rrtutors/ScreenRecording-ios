//
//  ViewController.swift
//  Video
//
//  Created by Mohammad Mohtashim on 18/11/20.
//  Copyright © 2020 Mohammad Mohtashim. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import ReplayKit

@available(iOS 13.0, *)
@available(iOS 10.0, *)
class ViewController: UIViewController,UIGestureRecognizerDelegate,AAPlayerDelegate {

var playerAV:AVPlayer?
var playerLayerAV = AVPlayerLayer()
var externalWindow: UIWindow!
var vw =  UIView()
var bagroundVw =  UIView()
var appdeledate = AppDelegate()
var videoURL = NSURL()
var blackView =  UIView()
    
    @IBOutlet weak var vedioDisplay: AAPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appdeledate =  UIApplication.shared.delegate as! AppDelegate
           VedioPaly()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name:UIApplication.didBecomeActiveNotification, object: nil)
              
              NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name:UIApplication.willResignActiveNotification, object: nil)
              
              NotificationCenter.default.addObserver(self, selector: #selector(screenCaptureStatusChanged), name: NSNotification.Name.screenRecordingDetectorRecordingStatusChanged, object: nil)
              
              NotificationCenter.default.addObserver(self, selector: #selector(DidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(true)
         
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.screenRecordingDetectorRecordingStatusChanged, object: nil)
         
        NotificationCenter.default.removeObserver(self, name:UIApplication.didBecomeActiveNotification, object: nil)
         
        NotificationCenter.default.removeObserver(self, name:UIApplication.willResignActiveNotification, object: nil)
         
         
     }
    
     @objc func DidEnterBackground (){
         ScreenRecordingDetector.triggerDetectorTimer()
         print("DidEnterBackground")
         
     }
     @objc func appDidBecomeActive (){
         ScreenRecordingDetector.triggerDetectorTimer()
         print("become active")
         
         if (ScreenRecordingDetector.sharedInstance().isRecording())
         {
             playerAV?.pause()
             
             bagroundVw = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
             let alertlabl = UILabel.init(frame: CGRect(x:40 , y: 100, width:UIScreen.main.bounds.size.width-20, height:40 ))
             bagroundVw.tag = 101
             
             let closeButton  = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.size.width-60, y: 40, width: 60, height: 60))
            // closeButton.setImage(UIImage.fontAwesomeIcon(name: .timesCircle, textColor: UIColor.white, size: CGSize(width: 60, height: 60)), for: .normal)
             //closeButton.addTarget(self, action: #selector(CloseButtonAction), for: .touchUpInside)
             
             bagroundVw.addSubview(closeButton)
             
             alertlabl.center = bagroundVw.center
             alertlabl.textAlignment = NSTextAlignment.center
             alertlabl.text = "Vedio record has been stopped"
             alertlabl.textColor = UIColor.white
             alertlabl.font = UIFont.boldSystemFont(ofSize: 15)
             bagroundVw.addSubview(alertlabl)
             bagroundVw.backgroundColor = UIColor.darkGray
            self.appdeledate.window?.addSubview(bagroundVw)
            self.appdeledate.window?.bringSubviewToFront(bagroundVw)

             print("Recording started")
             
         }
         
         
         vedioDisplay.StopPlay()
         
         
     }
     @objc func applicationWillResignActive () {
         ScreenRecordingDetector.stopTimer()
         
         vedioDisplay.pausePlayback()
         
         print("Resign active")
     }
     @objc func screenCaptureStatusChanged () {
         setupView()
         
         
         print("screencaptured active")
     }
     
    //MARK:Recording SetUp
    
    func setupView() {
        
        if (ScreenRecordingDetector.sharedInstance().isRecording())
        {
            vedioDisplay.StopPlay()

            
            vw = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height))
            let alertlabl = UILabel.init(frame: CGRect(x:40 , y: 100, width:UIScreen.main.bounds.size.width-20, height:40 ))
            vw.tag = 100
            
            let closeButton  = UIButton.init(frame: CGRect(x: UIScreen.main.bounds.size.width-60, y: 40, width: 60, height: 60))
            //closeButton.setImage(UIImage.fontAwesomeIcon(name: .timesCircle, textColor: UIColor.white, size: CGSize(width: 60, height: 60)), for: .normal)
            closeButton.tag = 10
            //closeButton.addTarget(self, action: #selector(CloseButtonAction), for: .touchUpInside)
            vw.addSubview(closeButton)
            
            alertlabl.center = vw.center
            alertlabl.textAlignment = NSTextAlignment.center
            alertlabl.text = "Vedio record has been stopped"
            alertlabl.textColor = UIColor.white
            alertlabl.font = UIFont.boldSystemFont(ofSize: 15)
            vw.addSubview(alertlabl)
            vw.backgroundColor = UIColor.darkGray
            self.appdeledate.window?.addSubview(vw)
            self.appdeledate.window?.bringSubviewToFront(vw)
            
            print("Recording started")
            
        }
        
        if (ScreenRecordingDetector.sharedInstance().isRecording() == true)
        {
            print("Recording already exists")
            
        }
            
        else
        {
            print("Recording not started")
        }
        
        
    }
    
    //MARK:VideoPlay
    
    func VedioPaly()
    {
       
        print("Video play called")
  
        let VideoUrl = "https://wolverine.raywenderlich.com/content/ios/tutorials/video_streaming/foxVillage.m3u8"

        videoURL = NSURL(string: VideoUrl)!
        vedioDisplay.playVideo(VideoUrl)
        vedioDisplay.setPlayerSubviewsFrame()
        vedioDisplay.startPlay()

     
    }
}

