//
//  CommentCell.swift
//  StarterApp
//
//  Created by Sam Thaiyil on 2021-05-26.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
