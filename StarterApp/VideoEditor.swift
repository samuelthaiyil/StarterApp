//
//  VideoEditor.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-06-04.
//

import UIKit
import AVKit
import CoreFoundation

class VideoEditor: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    class Clip {
    var clipNum: Int
    var clipURL: URL
    var clipAsset: AVAsset
        init(clipNum: Int, clipURL: URL)
        {
            self.clipNum = clipNum
            self.clipURL = clipURL
            self.clipAsset = AVAsset(url: clipURL)
        }
     }
   
     @IBOutlet weak var clipTV: UITableView!
     @IBOutlet weak var playerView: UIView!
     var player: AVPlayer?
     var playerItem: AVPlayerItem?
     var playerLayer: AVPlayerLayer?
     var clipURL: URL?
     var clips: [Clip] = []
     @IBOutlet weak var sliderView: UIView!
     @IBOutlet weak var thumbnail: UIImageView!
     @IBOutlet weak var endClip: UIView!
     @IBOutlet weak var startClip: UIView!
     var startClipPressed: Bool = false
     var videoAsset: AVAsset?
     var endClipTime: CMTime?
     var startClipTime: CMTime?
     @IBOutlet weak var clipsTVView: UIView!
     @IBOutlet weak var seconds: UILabel!
     @IBOutlet weak var secondsTooltipView: UIView!
     var selectedArea: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clipTV.delegate = self
        clipTV.dataSource = self
        secondsTooltipView.alpha = 0.0
        
        // change this later
        startClipTime = CMTimeMakeWithSeconds(0, preferredTimescale: 600)
        endClipTime = CMTimeMakeWithSeconds(5, preferredTimescale: 600)
        
        let filePath = Bundle.main.path(forResource: "RPReplay_Final1612295774", ofType: "mov")
        let test = URL(fileURLWithPath: filePath!)
        videoAsset = AVAsset(url: test)
        
        secondsTooltipView.layer.cornerRadius = 3
        
        addViewShadow(view: playerView)
        addViewShadow(view: clipsTVView)
        createSlider(url: test)
        playVideo(url: test)
    }
    
    func addViewShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 5
     }
    func mergeClips(clips: [Clip])
    {
        let mixCompisition = AVMutableComposition()
        var totalTime = CMTime.zero
        
        let finalVideo = mixCompisition.addMutableTrack(withMediaType: .video, preferredTrackID: CMPersistentTrackID())
        
        for clip in clips
        {
            
        }
    }
    func clipVideo(sourceURL1: AVAsset, statTime:Float, endTime:Float) -> Clip?
    {
        let manager = FileManager.default

        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return nil}
        
       
        
        let mediaType = "mov"
            let asset = sourceURL1
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)

            let start = statTime
            let end = endTime

           var outputURL = documentDirectory
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
            }catch let error {
                print(error)
            }

            _ = try? manager.removeItem(at: outputURL)

            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return nil}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mov

            let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)

            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                  print("exported")
                case .failed:
                    print("failed \(exportSession.error!.localizedDescription)")

                case .cancelled:
                    print("cancelled \(exportSession.error!.localizedDescription)")

                default: break
                }
            }
        
        
        return Clip(clipNum: 0, clipURL: outputURL)
        }
    func playVideo(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer?.frame.size.height = playerView.bounds.height
        playerLayer?.frame.size.width = playerView.bounds.width
        playerLayer?.videoGravity = .resize
        player?.replaceCurrentItem(with: playerItem)
        player?.isMuted = true
        player?.automaticallyWaitsToMinimizeStalling = false
        playerItem.preferredForwardBufferDuration = TimeInterval(5.0)
        playerView.layer.addSublayer(playerLayer!)
        view.addSubview(playerView)
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipCell") as? ClipCell
  
        guard clips.indices.contains(indexPath.row) else { return cell! }
        cell!.clipNumber.text = "Clip " + String(indexPath.row)
        cell!.createSlider(url: clips[indexPath.row].clipURL)
        cell!.clipTime.text = String(round(clips[indexPath.row].clipAsset.duration.seconds)) + " seconds"
        cell!.DeleteClip = {
            self.clips.remove(at: indexPath.row)
            DispatchQueue.main.async {
            self.clipTV.performBatchUpdates({
                self.clipTV.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
          }
        }
        return cell!
    }
    
    @IBAction func clip(_ sender: Any) {
        
        let filePath = Bundle.main.path(forResource: "test", ofType: "mov")
        let test = URL(fileURLWithPath: filePath!)
        
        guard let newClip = clipVideo(sourceURL1: AVAsset(url: test), statTime: Float(startClipTime!.seconds), endTime: Float(endClipTime!.seconds)) else {
            print("Failed to create clip")
            return
        }
        clips.append(newClip)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.clipTV.reloadData()
        }
       
     }
    
    @objc func handleStartClipSeek(seekRecognizer: UIPanGestureRecognizer)
    {
        switch seekRecognizer.state {
        case .began, .changed:
           
           
        seekRecognizer.view?.center.x = seekRecognizer.location(in: sliderView).x
        startClipTime = CMTimeMakeWithSeconds((Float64(startClip.frame.origin.x) / 300) * (videoAsset?.duration.seconds)!, preferredTimescale: 600)
       player?.seek(to: startClipTime!)
     secondsTooltipView.isHidden = false
        
            secondsTooltipView.transform = CGAffineTransform(translationX: startClip.frame.origin.x - 145, y:0)
            seconds.text = String(round(CMTimeMakeWithSeconds((Float64(startClip.frame.origin.x) / 300) * (videoAsset?.duration.seconds)!, preferredTimescale: 600).seconds))
            
            UIView.animate(withDuration: 0.3){
              self.secondsTooltipView.alpha = 1.0
            }
            let sec = (Int)(round(CMTimeMakeWithSeconds((Float64(startClip.frame.origin.x) / 300) * (videoAsset?.duration.seconds)!, preferredTimescale: 600).seconds))
           let min = sec / 60
       
            let formattedSec = (String(format: "%02d", sec % 60))
            
            seconds.text = "\(min):\(formattedSec)"
            
            break
        case .ended:
            
            UIView.animate(withDuration: 0.3){
              self.secondsTooltipView.alpha = 0.0
          }
            break
        case .cancelled:
            break
        case .failed:
            break
        case .possible:
            break
        @unknown default:
            break
         }
    }
    
    @objc func handleEndClipSeek(seekRecognizer: UIPanGestureRecognizer)
    {
        switch seekRecognizer.state {
        case .began, .changed:
            seekRecognizer.view?.center.x = seekRecognizer.location(in: sliderView).x
            endClipTime = CMTimeMakeWithSeconds((Float64(endClip.frame.origin.x + endClip.frame.width) / 300) * (videoAsset?.duration.seconds)!, preferredTimescale: 600)
            player?.seek(to: endClipTime!)
            
           
              
            UIView.animate(withDuration: 0.3){
                self.secondsTooltipView.alpha = 1.0
            }
            secondsTooltipView.transform = CGAffineTransform(translationX: endClip.frame.origin.x - 145, y:0)
            let sec = (Int)(round(CMTimeMakeWithSeconds((Float64(endClip.frame.origin.x + endClip.frame.width) / 300) * (videoAsset?.duration.seconds)!, preferredTimescale: 600).seconds))
           let min = sec / 60
       
            let formattedSec = (String(format: "%02d", sec % 60))
            
            seconds.text = "\(min):\(formattedSec)"
            break
        case .possible:
            break
        case .ended:
            
            UIView.animate(withDuration: 0.3){
              self.secondsTooltipView.alpha = 0.0
          }
            break
        case .cancelled:
            break
        case .failed:
            break
        @unknown default:
            break
         }
    }
 
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
 
   func createSlider(url: URL)
    {
        let startClipSeekRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleStartClipSeek))
        let endClipSeekRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleEndClipSeek))
      
        startClipSeekRecognizer.delegate = self
        endClipSeekRecognizer.delegate = self
     
        startClip.addGestureRecognizer(startClipSeekRecognizer)
        endClip.addGestureRecognizer(endClipSeekRecognizer)
    
        
        let asset = AVAsset(url: url)
        let imageGen = AVAssetImageGenerator(asset: asset)
        let interval: Int = Int(asset.duration.seconds / 6)
        for index in 0...5 {
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: index * 50, y: 0, width: 50, height: 45 * 2)
            
            let imageTime = CMTimeMake(value: Int64(interval * index), timescale: 1)
            let image = try! imageGen.copyCGImage(at: imageTime, actualTime: nil)
            imageView.image = UIImage(cgImage: image)
            imageView.contentMode = .scaleToFill
            imageView.alpha = 1
         
            self.sliderView.addSubview(imageView)
        }
        self.sliderView.addSubview(startClip)
        self.sliderView.addSubview(endClip)
        self.view.addSubview(sliderView)
    }
    
    @IBAction func upload(_ sender: Any) {
       
    }
    
}
