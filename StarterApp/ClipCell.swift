//
//  ClipCell.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-06-04.
//

import UIKit
import AVKit

class ClipCell: UITableViewCell {

    @IBOutlet weak var clipNumber: UILabel!
    @IBOutlet weak var clipView: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var clipTime: UILabel!
    var DeleteClip : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        clipView.frame = CGRect(x: 0, y: 0, width: 358, height: 150)
        createEffects(view: clipView)
        contentView.addSubview(clipView)
     }
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0))
    }
    func createSlider(url: URL)
    {
       
        let asset = AVAsset(url: url)
        let imageGen = AVAssetImageGenerator(asset: asset)
        let interval: Int = Int(asset.duration.seconds / 6)
        
        print("video length: \(Float(asset.duration.value) / Float(asset.duration.timescale))")
        
        for index in 0...5 {

            let imageView = UIImageView()
            imageView.frame = CGRect(x: index * 50, y: 0, width: 45, height: 45 * 2)
            let imageTime = CMTimeMake(value: Int64(index * interval), timescale: 1)
            let image = try! imageGen.copyCGImage(at: imageTime, actualTime: nil)
            imageView.image = UIImage(cgImage: image)
            imageView.contentMode = .scaleToFill

            self.sliderView.addSubview(imageView)
         }
//
       
    }
    
    func createEffects(view: UIView)
    {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 10
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteClip(_ sender: Any) {
        if let action = self.DeleteClip {
            action()
        }
    }
}
