//
//  DiscoverPageCell.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-06-01.
//

import UIKit

class DiscoverPageCell: UICollectionViewCell {

        
    //    @IBOutlet weak var view: UIView!
    //    @IBOutlet weak var like: UIButton!
    //    @IBOutlet weak var message: UIButton!
    //    @IBOutlet weak var likes: UILabel!
    //    @IBOutlet weak var school: UILabel!
    //    @IBOutlet weak var desc: UILabel!
        @IBOutlet weak var position: UILabel!
        @IBOutlet weak var username: UILabel!
        var likedPost : (() -> Void)? = nil
        var comment : (() -> Void)? = nil
        var videoSetup : (() -> Void)? = nil
        var isLiked = false
        @IBOutlet weak var infoView: UIView!
        @IBOutlet weak var playerView: UIView!
        @IBOutlet weak var posterDetails: UIView!
    override func awakeFromNib() {
            super.awakeFromNib()
            
            addViewShadow(view: playerView)
            addViewShadow(view: infoView)
            addViewShadow(view: posterDetails)
        
            contentView.addSubview(playerView)
            contentView.addSubview(infoView)
            contentView.addSubview(posterDetails)
            
            position.font = UIFont(name: "Raleway", size: 13)
            
            playerView.isSkeletonable = true
            infoView.isSkeletonable = true
            position.isSkeletonable = true
           
            if let action = self.videoSetup{
                action()
            }
        }
    func addViewShadow(view: UIView)
    {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        view.layer.cornerRadius = 10
    }
    func showSkeleton(state: Bool)
        {
        if state {
            playerView.showAnimatedGradientSkeleton()
            infoView.showAnimatedGradientSkeleton()
            position.showAnimatedGradientSkeleton()
        }else{
            playerView.hideSkeleton()
            infoView.hideSkeleton()
            position.showAnimatedGradientSkeleton()
         }
        }
        @IBAction func liked(_ sender: Any) {
            if let action = self.likedPost{
                action()
            }
        }
        
        @IBAction func comment(_ sender: Any) {
            if let action = self.comment{
                action()
            }
        }
        
    }


