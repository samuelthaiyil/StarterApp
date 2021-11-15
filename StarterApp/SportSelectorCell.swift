//
//  SportSelectorCell.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-06-01.
//

import UIKit

class SportSelectorCell: UICollectionViewCell {
    
    @IBOutlet weak var sport: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
        sport.textColor = UIColor.gray
    }
    
    func setLayout(isSelected: Bool)
    {
        if isSelected {
            sport.textColor = UIColor.black
        }else{
            sport.textColor = UIColor.gray
        }
    
    }
}
