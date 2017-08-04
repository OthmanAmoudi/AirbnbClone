//
//  BookingTableViewCell.swift
//  FinalAssessment
//
//  Created by Othman Mashaab on 03/08/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {

    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomPicContainer: UIImageView!
    
    var bookingIdCell:String!
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

        // Configure the view for the selected state
    }
    
}
