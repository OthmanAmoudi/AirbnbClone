//
//  TableViewCell.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 01/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var emailLblCell: UILabel!
    @IBOutlet weak var nameLblCell: UILabel!
    @IBOutlet weak var profilePictureCell: UIImageView!
    
    
    var userIdCell:String!
    var posIdCell:String!
    var date:String!
    var date2:String!
    var ownerCell:String!
    var latitudeCell:String!
    var longitudeCell:String!
    var roomDescription:String!
    var roomPictureCell:String!
    var roomPictureURLCell:String!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        profilePictureCell.layer.cornerRadius = profilePictureCell.frame.size.width / 2
        profilePictureCell.clipsToBounds = true
        // Configure the view for the selected state
    }
    
}
