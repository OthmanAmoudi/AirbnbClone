//
//  RoomTableViewCell.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelCell: UILabel!
    @IBOutlet weak var RoomPicCell: UIImageView!
    @IBOutlet weak var dateLabelCell: UILabel!
    @IBOutlet weak var date2LabelCell: UILabel!
    
    var roomPicURL:String!
    var roomId:String!
    var owner:String!
    var longitude:String!
    var latitude:String!
    var roomDescription:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
