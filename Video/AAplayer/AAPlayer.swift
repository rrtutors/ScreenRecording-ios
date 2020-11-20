//
//  AAPlayer.swift
//  AAPlayer

//

import UIKit
import AVFoundation
import AVKit

public protocol AAPlayerDelegate : class {
    
    typealias playerItemStatus = AVPlayerItem.Status
    func callBackDownloadDidFinish(_ status:AVPlayerItem.Status?)
}


@available(iOS 10.0, *)
@available(iOS 13.0, *)

public class AAPlayer: UIView {
    
    public weak var delegate:AAPlayerDelegate?
    
     var player:AVPlayer?
    var isLoaderVisible = Bool()
   // var filterList: WYPopoverController? = nil
     var optionsArr =  NSMutableArray()
    var langArr =  NSMutableArray()
    var app = AppDelegate()

    fileprivate var playerLayer:AVPlayerLayer?
    fileprivate var playerItem:AVPlayerItem?
    fileprivate var playUrl:String!
    fileprivate var playButton:AAPlayButton!
    fileprivate var replayButton:UIButton!
    fileprivate var playActivityIndicator:AAPlayerActivityIndicicatorView!
    fileprivate var smallPlayButton:AAPlayButton!
    fileprivate var rotateSizeButton:AAPlayerRotateButton!
    fileprivate var ccButton:UIButton!
     fileprivate var LangButton:UIButton!
    fileprivate var playProgressView:AAPlayProgressView!
    fileprivate var playerSlider:AAPlayerSlider!
    fileprivate var playerBottomView:UIView!
    fileprivate var timeLabel:UILabel!
    fileprivate var timer:Timer?
    fileprivate var errorLabl:UILabel!

    fileprivate var playbackObserver:Any?
    open var totalDuration: TimeInterval = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initWithPlayBottomView()
        initWithPlayButton()
        initWithPlayProgressView()
        initWithSlider()
        initWithTimeLabel()
        initWithPlayActivityIndicator()
        initWithRotateButton()
        initWithCCButton()
        
    }
    @objc func Slectedlang(notificationobj:Notification)
    {        player?.appliesMediaSelectionCriteriaAutomatically = true

        print("notificationObj:\(notificationobj)")
        guard let text = notificationobj.userInfo?["LanguageOptn1"] as? Any else { return }
        print ("textghgvh: \(text)")
        
        for characteristic in (playerItem?.asset.availableMediaCharacteristicsWithMediaSelectionOptions)! {
            print("\(characteristic)")
            
            // Retrieve the AVMediaSelectionGroup for the specified characteristic.
            if let group = playerItem?.asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                // Print its options.
                for option in group.options {
                    print("  Option: \(option.displayName)")
                    print("Option1: \(option)")
                    
                    if text as! AVMediaSelectionOption == option
                     {
                        print("Equal")
                    playerItem?.select(text as? AVMediaSelectionOption, in: group)
return
                    }
                   

                }
            }
            
            
        }
    }
    //MARK:- Interface Builder(Xib,StoryBoard)
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        initWithPlayBottomView()
        initWithPlayButton()
        initWithPlayProgressView()
        initWithSlider()
        initWithTimeLabel()
        initWithErroLabel()
        initWithPlayActivityIndicator()
        initWithRotateButton()
        initWithCCButton()
        initWithLangButton()
    }
    
    deinit {
        
        removeAllObserver()
        resettingObject()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        setPlayerSubviewsFrame()
        detectedInterfaceOrientation()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    //MARK:- initialize method
    fileprivate func initWithPlayBottomView() {
        layer.backgroundColor = UIColor(red: 31/255, green: 37/255, blue: 61/255, alpha: 1).cgColor
        playerBottomView = UIView()
        playerBottomView.backgroundColor = UIColor.black
        playerBottomView.alpha = 0
        addSubview(playerBottomView)
    }
    fileprivate func initWithCCButton() {
        
      ccButton = UIButton()
       // ccButton.addTarget(self, action: #selector(EnableSubtitles), for: .touchUpInside)
        // ccButton.setImage(UIImage.fontAwesomeIcon(name: .cc, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
    playerBottomView.addSubview(ccButton)
    }
    fileprivate func initWithLangButton() {
        
        LangButton = UIButton()
       // LangButton.setImage(UIImage.fontAwesomeIcon(name: .language, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
        playerBottomView.addSubview(LangButton)
    }
    
    fileprivate func initWithPlayButton() {
        playButton = AAPlayButton()
        replayButton = UIButton()
       // replayButton.setImage(UIImage.fontAwesomeIcon(name: .repeat, textColor: UIColor.darkGray, size: CGSize(width: 80, height: 80)), for: .normal)
        replayButton.isHidden = true
        replayButton.addTarget(self, action: #selector(Restart), for: .touchUpInside)
        addSubview(replayButton)
        smallPlayButton = AAPlayButton()
        smallPlayButton.addTarget(self, action: #selector(startPlay), for: .touchUpInside)
        playerBottomView.addSubview(smallPlayButton)
    }
    
    fileprivate func initWithRotateButton() {
        
        rotateSizeButton = AAPlayerRotateButton()
        playerBottomView.addSubview(rotateSizeButton)
        
    }
    
    fileprivate func initWithPlayActivityIndicator() {
        
        playActivityIndicator = AAPlayerActivityIndicicatorView()
        addSubview(playActivityIndicator)
        
    }
    
    fileprivate func initWithPlayProgressView() {
        
        playProgressView = AAPlayProgressView(progressViewStyle: .bar)
        playProgressView.progressTintColor = UIColor(red: 102/255, green: 178/255, blue: 255/255, alpha: 0.5)
        playProgressView.trackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        playProgressView.setProgress(0.0, animated: true)
        playerBottomView.addSubview(playProgressView)
        
    }
    
    fileprivate func initWithSlider() {
        playerSlider = AAPlayerSlider()
        playerSlider.tintColor = UIColor.clear
        playerSlider.backgroundColor = UIColor.clear
        playerSlider.maximumTrackTintColor = UIColor.lightGray
        playerSlider.minimumTrackTintColor = UIColor.white
        //UIColor(red: 231/255, green: 107/255, blue: 107/255, alpha: 1)
        playerSlider.minimumValue = 0
        playerSlider.isContinuous = true
        playerSlider.addTarget(self, action: #selector(touchPlayerProgress), for: [.touchDown, .touchUpInside])
        playerBottomView.addSubview(playerSlider)
    }
    
    fileprivate func initWithTimeLabel() {
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.white
        timeLabel.font = UIFont.boldSystemFont(ofSize: 12)
        playerBottomView.addSubview(timeLabel)
    }
    
    fileprivate func initWithErroLabel() {
        
        errorLabl = UILabel()
        errorLabl.textColor = UIColor.white
        errorLabl.textAlignment = .center
        errorLabl.font = UIFont.boldSystemFont(ofSize: 12)
        addSubview(errorLabl)
    }
    //MARK:- frame method
     func setPlayerSubviewsFrame() {
        
        playerBottomView.frame = CGRect(x: 0, y: frame.height - 40, width: frame.width, height: 40)
        playerLayer?.frame = bounds
       replayButton.frame = CGRect(x: frame.width / 2 - 25, y: frame.height / 2 - 25, width: 50, height: 50)
        replayButton.center = CGPoint(x: frame.width / 2 , y: frame.height / 2)
        errorLabl.frame = CGRect(x: 0, y: frame.height / 2 - 25, width: frame.width , height: 70)
        errorLabl.center = CGPoint(x: frame.width / 2 , y: frame.height / 2)
        playProgressView.frame = CGRect(x: 50, y: playerBottomView.frame.height / 2, width: playerBottomView.frame.width - (LangButton.isHidden ? 180 : 200), height: 2)
        playerSlider.frame = CGRect(x: 40, y: playerBottomView.frame.height / 2 - 9, width: playerBottomView.frame.width - (LangButton.isHidden ? 180 : 200), height: 20)
        smallPlayButton.frame = CGRect(x: 10, y: playerBottomView.frame.height / 2 - 8, width: 20, height: 15)
        timeLabel.frame = CGRect(x: playerBottomView.frame.width - (LangButton.isHidden ? 125 : 115), y: playerBottomView.frame.height / 2 - 9, width: 110, height: 20)
        playActivityIndicator.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        playActivityIndicator.frame.size = CGSize(width: 90, height: 90)
        ccButton.frame = CGRect(x: playerBottomView.frame.width - (LangButton.isHidden ? 35 : 65), y: 5, width:30, height: 30)
        LangButton.frame = CGRect(x: playerBottomView.frame.width - (LangButton.isHidden ? 0 : 35), y: 5, width:LangButton.isHidden ? 0 : 30 , height: 30)

       // rotateSizeButton.frame = CGRect(x: playerBottomView.frame.width - 40, y: 0, width:40, height: 40)
        
         NotificationCenter.default.addObserver(self, selector: #selector(Slectedlang), name: NSNotification.Name.init("LanNAme"), object: nil)
        
        
        
        
        
    }
    
    //MARL:- interface orientation
    fileprivate func detectedInterfaceOrientation()  {
        
        switch UIDevice.current.orientation {
        case .portrait:
            rotateSizeButton.isSelected = false
            break
        case .landscapeRight:
            rotateSizeButton.isSelected = true
            break
        case .landscapeLeft:
            rotateSizeButton.isSelected = true
            break
        default:
            rotateSizeButton.isSelected = false
            break
        }
    }
    
    //MARK:- setting player
    fileprivate func setPlayRemoteUrl() {
        
        if playUrl == nil || playUrl == "" {
            return
        }
        removeAllObserver()
        resettingObject()
        let asset = AVAsset(url: URL(string: playUrl)!)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.backgroundColor = UIColor.black.cgColor
        playerLayer?.videoGravity = AVLayerVideoGravity.resize
        playerLayer?.contentsScale = UIScreen.main.scale
        layer.insertSublayer(playerLayer!, at: 0)
        player?.isClosedCaptionDisplayEnabled=true
       
       
       setAllObserver()
        
    }
    
    //MARK:- setting observer
    fileprivate func setAllObserver() {
        
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)

    
    }

    
  @objc  func playerDidFinishPlaying(note: NSNotification) {
        // Your code here
    player?.seek(to: CMTime.zero)
     replayButton.isHidden = false
         StopPlay()
        
    }
    fileprivate func removeAllObserver() {
        
        player?.removeObserver(self, forKeyPath: "rate")
        playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem?.removeObserver(self, forKeyPath: "status")
        
    }
    
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            
            observePlayerStatus()
            
        } else if keyPath == "loadedTimeRanges" {
            
            let currentTime = getBufferTimeDuration()
            let totalTime = CMTimeGetSeconds((playerItem?.duration)!)
            let percent = currentTime / totalTime
            playProgressView.progress = Float(percent)
            
        } else if keyPath == "rate" {
            
            if (object as! AVPlayer).rate == 0 && Int(playerSlider.value) == Int(playerSlider.maximumValue)  {
                smallPlayButton.isSelected = false
                setPlayBottomViewAnimation()
            }
            
        }
    }
    
    
    //MARK:- check playItem status
    fileprivate func observePlayerStatus() {
        
        let status:AVPlayerItem.Status = (player?.currentItem?.status)!
        switch status {
        case .readyToPlay:
            
            if Float(CMTimeGetSeconds((playerItem?.duration)!)).isNaN  == true { break }
            playerSlider.addTarget(self, action: #selector(changePlayerProgress), for: .valueChanged)
            playerSlider.maximumValue = Float(CMTimeGetSeconds((playerItem?.duration)!))
            let allTimeString = timeFotmatter(Float(CMTimeGetSeconds((playerItem?.duration)!)))
            playbackObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: nil, using: { (time) in
                let during = self.playerItem!.currentTime()
                let time = during.value / Int64(during.timescale)
                self.timeLabel.text = "\(self.timeFotmatter(Float(time))) / \(allTimeString)"
                if !self.playerSlider.isHighlighted {
                    self.playerSlider.value = Float(time)
                }
            })
            
            break
        case .failed:
            errorLabl.isHidden = false
            break
            default:
            break
        }
        playActivityIndicator.stopAnimation()
        downloadDidFinish(status)
    }
    
    
    //MARK:- call back playItem status
    fileprivate func downloadDidFinish(_ status:AVPlayerItem.Status?) {
        
        delegate?.callBackDownloadDidFinish(status)
    }
    
    //MARK:- get buffer time duration
    fileprivate func getBufferTimeDuration() -> TimeInterval {
        
        let loadedTimeRanges =  player!.currentItem!.loadedTimeRanges
        guard let timeRange = loadedTimeRanges.first?.timeRangeValue else { return 0.0 }
        let start = CMTimeGetSeconds(timeRange.start)
        let duration = CMTimeGetSeconds(timeRange.duration)
        let currentTimeDuration = (start + duration)
        return currentTimeDuration
        
    }
    
    //MARK:- calculate time formatter
    fileprivate func timeFotmatter(_ time:Float) -> String {
        
        var hr:Int!
        var min:Int!
        var sec:Int!
        var timeString:String!
        
//        if time >= 3600 {
//            hr = Int(time / 3600)
//            min = Int(time.truncatingRemainder(dividingBy: 3600))
//            sec = Int(min % 60)
//            timeString = String(format: "%02d:%02d:%02d", hr, min, sec)
//        }
        if time >= 60 && time < 3600 {
            min = Int(time / 60)
            sec = Int(time.truncatingRemainder(dividingBy: 60))
            timeString = String(format: "%02d:%02d", min, sec)
        } else if time < 60 {
            sec = Int(time)
            timeString = String(format: "00:%02d", sec)
        }
        
        return timeString
    }

    //MARK:- setting player display
    @objc  func startPlay() {


        if playButton.isHidden == false {
            setPlayRemoteUrl()
            setPlayBottomViewAnimation()
            playActivityIndicator.startAnimation()
        }
        
        if player?.rate == 0 {
            if isLoaderVisible
            {
                playActivityIndicator.startAnimation();
                isLoaderVisible = false
            }
            player?.play()
            playButton.isSelected = true
            replayButton.isHidden = true
            playButton.isHidden = true
            smallPlayButton.isSelected = true
            stopTimer()
            startTimer()
            
        } else {
            player?.pause()
            playButton.isSelected = false
            smallPlayButton.isSelected = false
            if !playActivityIndicator.isHidden
            {
                isLoaderVisible = true
                playActivityIndicator.stopAnimation();

            }
            stopTimer()
        }
    }
    
    @objc func Restart()
    {
        playActivityIndicator.startAnimation();
        player?.play()
        replayButton.isHidden = true
        playButton.isSelected = true
        playButton.isHidden = true
        smallPlayButton.isSelected = true
        stopTimer()
        startTimer()
        playActivityIndicator.stopAnimation();
    }


    func StopPlay() {
        player?.pause()
        playButton.isSelected = false
        smallPlayButton.isSelected = false
        stopTimer()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        setPlayBottomViewAnimation()
        stopTimer()
        if player?.rate == 1 && playerBottomView.alpha == 1 {
            startTimer()
        }
    }
    
    @objc fileprivate func setPlayBottomViewAnimation() {
        
        UIView.animate(withDuration: 0.5) {
            if self.playerBottomView.alpha == 0 {
                self.playerBottomView.alpha = 1
            } else {
                self.playerBottomView.alpha = 0
            }
        }
        
    }
    
    //MARK:- timer
    fileprivate func startTimer() {
        
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(setPlayBottomViewAnimation), userInfo: nil, repeats: false)
    }
    
    fileprivate func stopTimer() {
        
        if timer == nil {
            return
        }
        timer?.invalidate()
        timer = nil
    }
    
    //MARK:- change player progress
    @objc fileprivate func changePlayerProgress() {
        playActivityIndicator.startAnimation()

        let seekDuration = playerSlider.value
        player?.seek(to: CMTimeMake(value: Int64(seekDuration), timescale: 1), completionHandler: { (BOOL) in
           //self.playActivityIndicator.stopAnimation()

        })
        
    }
    
    @objc fileprivate func touchPlayerProgress() {
        
        if playerSlider.isHighlighted {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    //MARK: - resetting display view
    fileprivate func resettingObject() {
        player = nil
        playerLayer = nil
        playbackObserver = nil
        playerItem = nil
        //ccButton.setImage(UIImage.fontAwesomeIcon(name: .cc, textColor: UIColor.lightGray, size: CGSize(width: 30, height: 30)), for: .normal)
    }
    //MARK: - public control method
    public func playVideo(_ url:String) {
       // SetMultipleLang()
        playUrl = url
        errorLabl.isHidden = true
        playButton.isHidden = false
        playButton.isSelected = false
        smallPlayButton.isSelected = false
        if playbackObserver != nil {
            player?.removeTimeObserver(playbackObserver!)
            playbackObserver = nil
        }
        if player?.rate == 1 {
            player?.pause()
        }
        playActivityIndicator.stopAnimation()
        playerLayer?.removeFromSuperlayer()
       
        playerSlider.removeTarget(self, action: #selector(changePlayerProgress), for: .valueChanged)
        playerSlider.value = 0.0
        playProgressView.progress = 0.0
        //timeLabel.text = "00:00:00 / 00:00:00"
        timeLabel.text = "00:00 / 00:00"

//        ccButton.setImage(UIImage.fontAwesomeIcon(name: .cc, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: .normal)
//        playerLayer?.subtitleLabel?.isHidden = false
    }
    
    public func startPlayback() {
        
        player?.play()
    }
    
    public func pausePlayback() {
        
        player?.pause()
        

    }
    
    
}


extension AAPlayerDelegate {
    
    public func callBackDownloadDidFinish(_ status:AVPlayerItem.Status?) {
        
        
    }
}

